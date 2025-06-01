from db_function import db
from web_routes.admin import admin_bp ,request ,jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from datetime import timedelta
from flask import request, jsonify, make_response
import os
from logger_config import setup_logger
log_file = os.path.join(os.getcwd(), 'logs', 'employee.log')
logger = setup_logger('admin', log_file)


# Define column names for proper key mapping
USER_COLUMNS = [
    "employeeid", "employee_full_name", "employee_email",
    "employee_phone_number", "employee_profile_photo",
    "employee_is_admin", "created_at"
]

# Helper function to format tuples into dictionaries
def format_user_data(results):
    formatted_data = []
    for row in results:
        formatted_data.append(dict(zip(USER_COLUMNS, row)))
    return formatted_data


@admin_bp.route('/login', methods=['POST'])
def admin_login():
    data = request.json
    logger.info("Login attempt by admin user: %s", data.get('username'))

    try:
        procedure_name = "AdminLogin"
        params = (data.get('username'), data.get('password'))

        # Call stored procedure
        result = db.call_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or len(result) == 0:
            logger.warning("Invalid credentials for user: %s", data.get('username'))
            return jsonify({"message": "Invalid login credentials"}), 401

        response_dict = result[0]

        result_status = 1  # Assuming success
        admin_id = 0  # Replace this with actual admin ID from `response_dict` if available
        username = data.get('username')
        message = response_dict["rmsg"]

        if result_status == 1:
            access_token = create_access_token(identity=admin_id, expires_delta=timedelta(hours=2))

            response = make_response(jsonify({
                "isCredentialsValid": True,
                "message": message,
                "admin": {
                    "adminId": admin_id,
                    "username": username
                }
            }), 200)

            response.set_cookie(
                "jwt",
                access_token,
                httponly=True,
                secure=True,
                samesite='Lax',
                max_age=7200
            )

            logger.info("Admin login successful: %s", username)
            return response
        else:
            logger.warning("Login failed due to status != 1 for user: %s", username)
            return jsonify({"message": message}), 401

    except Exception as e:
        logger.error("Error during admin login: %s", str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500


@admin_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    admin_id = get_jwt_identity()  # Get admin ID from token
    logger.info("Protected route accessed by admin ID: %s", admin_id)

    return jsonify({
        "message": "Access granted",
        "admin_id": admin_id
    }), 200


@admin_bp.route('/get_users', methods=['GET'])
def get_users():
    logger.info("Admin requested all users")

    try:
        procedure_name = "GetUsers"
        users = db.call_procedure(procedure_name)

        if users and len(users[0]) > 0:
            logger.info("Users retrieved successfully. Count: %d", len(users[0]))
            return jsonify(format_user_data(users[0])), 200
        else:
            logger.warning("No users found in database.")
            return jsonify({"message": "No users found"}), 404

    except Exception as e:
        logger.error("Error fetching users: %s", str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500



@admin_bp.route('/get_user/<int:emp_id>', methods=['GET'])
def get_user(emp_id):
    logger.info("Fetching user with ID: %d", emp_id)

    try:
        procedure_name = "GetUserById"
        params = (emp_id,)
        user = db.call_procedure(procedure_name, params)

        if user and len(user[0]) > 0:
            logger.info("User with ID %d retrieved successfully", emp_id)
            return jsonify(format_user_data(user[0])[0]), 200  # Extract single user
        else:
            logger.warning("User with ID %d not found", emp_id)
            return jsonify({"message": "User not found"}), 404

    except Exception as e:
        logger.error("Error fetching user with ID %d: %s", emp_id, str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500
