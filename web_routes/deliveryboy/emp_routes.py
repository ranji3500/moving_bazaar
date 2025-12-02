from flask import request, jsonify
from supports.db_function import db
from web_routes.deliveryboy import employee_bp
from flask_jwt_extended import create_access_token
from datetime import timedelta
from flask_jwt_extended import jwt_required, get_jwt
from logger_configuration import logger
import random
import time


@employee_bp.route('/', methods=['GET'])
@jwt_required()
def index():
    return "employee server is running"


@employee_bp.route('/create_customer', methods=['POST'])
@jwt_required()
def create_customer():
    data = request.json
    claims = get_jwt()
    user_id = claims.get('sub')

    logger.info("Create customer request received | user_id=%s | data=%s", user_id, data)

    # Validate required fields
    if not data.get('storeName') or not data.get('phoneNumber'):
        logger.warning("Missing required fields for create_customer | user_id=%s | data=%s", user_id, data)
        return jsonify({"error": "storeName and phoneNumber are required"}), 400

    try:
        procedure_name = "insert_customer"
        params = [
            user_id,
            data.get('storeName'),
            data.get('email', ''),  # Empty string if not provided
            data.get('phoneNumber'),
            data.get('phoneNumber', ''),  # Empty string if not provided
            data.get('addressLine1', ''),
            data.get('addressLine2', ''),
            data.get('city', ''),
            data.get('outstandingPrice', 0.00)
        ]

        # Call stored procedure and get result
        result = db.call_procedure(procedure_name, params)

        logger.info("Stored procedure result | user_id=%s | result=%s", user_id, result)

        # The stored procedure returns a result set with customerId and message
        if result and len(result) > 0:
            customer_id = result[0].get('customerId')
            message = result[0].get('message')

            # Check if it's a duplicate or error
            if customer_id is None or 'Duplicate' in message or 'Error' in message:
                logger.warning(
                    "Customer creation failed | user_id=%s | message=%s",
                    user_id, message
                )

                # Determine appropriate status code
                if 'Duplicate' in message:
                    status_code = 409  # Conflict
                elif 'Invalid user_id' in message:
                    status_code = 400  # Bad Request
                else:
                    status_code = 500  # Internal Server Error

                return jsonify({"error": message}), status_code

            # Success case
            logger.info(
                "Customer created successfully | user_id=%s | customer_id=%s | storeName=%s",
                user_id, customer_id, data.get('storeName')
            )

            return jsonify({
                "message": message,
                "customerId": customer_id
            }), 201
        else:
            logger.error("No result returned from stored procedure | user_id=%s", user_id)
            return jsonify({"error": "Failed to create customer - no result returned"}), 500

    except Exception as e:
        logger.exception("Exception while creating customer | user_id=%s | data=%s | error=%s",
                         user_id, data, str(e))
        return jsonify({"error": "Internal server error"}), 500
# UPDATE Employee
@employee_bp.route('/update_employee/<int:emp_id>', methods=['PUT'])
@jwt_required()
def update_employee(emp_id):
    try:
        data = request.json
        claims = get_jwt()
        user_id = claims.get('userId')
        user_name = claims.get('userName')
        email = claims.get('email')
        user_type = claims.get('user_type')

        procedure_name = "UpdateEmployee"
        params = (
            emp_id,
            data.get('full_name'),
            data.get('email'),
            data.get('phone_number'),
            data.get('password'),
            data.get('profile_photo', None),
            data.get('is_admin', False)
        )

        rows_affected = db.insert_using_procedure(procedure_name, params)

        if rows_affected > 0:
            logger.info(
                "Employee updated successfully: emp_id=%s by user_id=%s email=%s",
                emp_id, user_id, email
            )
            return jsonify({"message": "Employee updated successfully"}), 200
        else:
            logger.warning(
                "Update failed, employee not found: emp_id=%s by user_id=%s email=%s",
                emp_id, user_id, email
            )
            return jsonify({"message": "Employee not found"}), 404

    except Exception as e:
        logger.exception(
            "Exception occurred while updating employee emp_id=%s by user_id=%s email=%s",
            emp_id
        )
        return jsonify({"error": "Internal server error"}), 500

# DELETE Employee
@employee_bp.route('/delete_employee/<int:emp_id>', methods=['DELETE'])
@jwt_required()
def delete_employee(emp_id):
    try:
        claims = get_jwt()
        user_id = claims.get('userId')
        user_name = claims.get('userName')
        email = claims.get('email')
        user_type = claims.get('user_type')

        procedure_name = "DeleteEmployee"
        params = (emp_id,)
        rows_affected = db.insert_using_procedure(procedure_name, params)

        if rows_affected > 0:
            logger.info(
                "Employee deleted successfully: emp_id=%s by user_id=%s email=%s",
                emp_id, user_id, email
            )
            return jsonify({"message": "Employee deleted successfully"}), 200
        else:
            logger.warning(
                "Delete failed, employee not found: emp_id=%s by user_id=%s email=%s",
                emp_id, user_id, email
            )
            return jsonify({"message": "Employee not found"}), 404

    except Exception as e:
        logger.exception(
            "Exception occurred while deleting employee emp_id=%s by user_id=%s email=%s",
            emp_id
        )
        return jsonify({"error": "Internal server error"}), 500


@employee_bp.route('/login_employee', methods=['POST'])
def login_employee():
    try:
        data = request.json
        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            logger.warning("Login attempt with missing email or password: %s", data)
            return jsonify({"message": "Email and password are required"}), 400

        procedure_name = "LoginEmployee"
        params = (email, password)
        result = db.call_procedure(procedure_name, params)

        if not result:
            logger.warning("Invalid login attempt for email: %s", email)
            return jsonify({
                "data": None,
                "message": "Invalid login credentials"
            }), 401

        response_dict = result[0]

        if response_dict.get("result_status") == 1:
            # ✅ Generate JWT Token
            access_token = create_access_token(
                identity=str(response_dict["employee_id"]),
                additional_claims={
                    "userName": response_dict["userName"],
                    "email": response_dict["email"],
                    "user_type": "USER"
                },
                expires_delta=timedelta(hours=2)
            )
            logger.info("Login successful for employee_id=%s email=%s",
                        response_dict["employee_id"], email)

            return jsonify({
                "message": "Login successful",
                "data": {
                    "userId": response_dict["employee_id"],
                    "userName": response_dict["userName"],
                    "email": response_dict["email"],
                    "userType": "USER",
                    "accessToken": access_token
                }
            }), 200

        else:
            logger.warning("Login failed for email=%s: %s",
                           email, response_dict.get("message"))
            return jsonify({
                "data": None,
                "message": response_dict.get("message", "Login failed")
            }), 401

    except Exception as e:
        logger.exception("Exception occurred during login ")
        return jsonify({"error": "Internal server error"}), 500

@employee_bp.route('/forgot_password', methods=['POST'])
@jwt_required()
def forgot_password():
    try:
        claims = get_jwt()
        user_id = claims.get('userId')
        user_name = claims.get('userName')
        email_claim = claims.get('email')
        user_type = claims.get('user_type')

        data = request.json
        email_input = data.get('email')
        new_password = data.get('new_password')

        if not email_input or not new_password:
            logger.warning(
                "Forgot password attempt with missing fields: user_id=%s, email=%s, data=%s",
                user_id, email_claim, data
            )
            return jsonify({"message": "Email and new password are required"}), 400

        procedure_name = "ForgotPassword"
        params = (email_input, new_password)
        rows_affected = db.insert_using_procedure(procedure_name, params)

        if rows_affected > 0:
            logger.info(
                "Password updated successfully for email=%s by user_id=%s",
                email_input, user_id
            )
            return jsonify({"message": "Password updated successfully"}), 200
        else:
            logger.warning(
                "Forgot password failed, email not found: email=%s by user_id=%s",
                email_input, user_id
            )
            return jsonify({"message": "Email not found"}), 404

    except Exception as e:
        logger.exception(
            "Exception occurred during forgot password for user"
        )
        return jsonify({"error": "Internal server error"}), 500



