from flask import request, jsonify
from supports.db_function import db
from web_routes.deliveryboy import employee_bp
from flask_jwt_extended import create_access_token
from datetime import timedelta
from flask_jwt_extended import jwt_required, get_jwt




@employee_bp.route('/', methods=['GET'])
@jwt_required()
def index():
    return "employee server is running"

# CREATE Employee
@employee_bp.route('/create_customer', methods=['POST'])
@jwt_required()
def create_customer():
    data = request.json
    claims = get_jwt()
    user_id = claims.get('userId')
    try:
        procedure_name = "insert_customer"
        params = (
            user_id,
            data.get('storeName'),
            data.get('email'),
            data.get('phoneNumber'),
            data.get('whatsappNumber', None),
            data.get('addressLine1'),
            data.get('addressLine2', None),
            data.get('city'),
            data.get('outstandingPrice', 0.00)
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": rows_affected}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# UPDATE Employee
@employee_bp.route('/update_employee/<int:emp_id>', methods=['PUT'])
@jwt_required()
def update_employee(emp_id):
    data = request.json
    claims = get_jwt()
    user_id = claims.get('userId')
    user_name = claims.get('userName')
    email = claims.get('email')
    user_type = claims.get('user_type')
    try:
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
            return jsonify({"message": "Employee updated successfully"}), 200
        else:
            return jsonify({"message": "Employee not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

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
            return jsonify({"message": "Employee deleted successfully"}), 200
        else:
            return jsonify({"message": "Employee not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@employee_bp.route('/login_employee', methods=['POST'])
def login_employee():
    try:
        data = request.json
        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            return jsonify({"message": "Email and password are required"}), 400

        procedure_name = "LoginEmployee"
        params = (email, password)
        result = db.call_procedure(procedure_name, params)

        if not result:
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
            return jsonify({
                "data": None,
                "message": response_dict.get("message", "Login failed")
            }), 401

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# FORGOT PASSWORD
@employee_bp.route('/forgot_password', methods=['POST'])
@jwt_required()
def forgot_password():
    claims = get_jwt()
    user_id = claims.get('userId')
    user_name = claims.get('userName')
    email = claims.get('email')
    user_type = claims.get('user_type')
    data = request.json
    try:
        procedure_name = "ForgotPassword"
        params = (data.get('email'), data.get('new_password'))
        rows_affected = db.insert_using_procedure(procedure_name, params)
        if rows_affected > 0:
            return jsonify({"message": "Password updated successfully"}), 200
        else:
            return jsonify({"message": "Email not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


