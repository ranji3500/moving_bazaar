from db_function import db
from web_routes.admin import admin_bp ,request ,jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from datetime import timedelta
from flask import request, jsonify, make_response



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
    try:
        procedure_name = "AdminLogin"
        params = (data.get('username'), data.get('password'))

        # Call stored procedure
        result = db.call_procedure(procedure_name, params)

        # Ensure result is not empty and is a list
        if not result or not isinstance(result, list) or len(result) == 0:
            return jsonify({"message": "Invalid login credentials"}), 401

        response_dict = result[0]

        # Extracting values
        result_status = 1
        admin_id = 0
        username = data.get('username')
        message = response_dict["rmsg"]

        if result_status == 1:
            # Generate JWT token
            access_token = create_access_token(identity=admin_id, expires_delta=timedelta(hours=2))

            # Create response object
            response = make_response(jsonify({
                "isCredentialsValid": True,
                "message": message,
                "admin": {
                    "adminId": admin_id,
                    "username": username
                }
            }), 200)

            # Set token as HTTP-Only cookie
            response.set_cookie(
                "jwt",
                access_token,
                httponly=True,
                secure=True,
                samesite='Lax',
                max_age=7200
            )

            return response
        else:
            return jsonify({"message": message}), 401

    except Exception as e:
        return jsonify({"error": str(e)}), 500



# Protected Route - Example to Verify Session
@admin_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    admin_id = get_jwt_identity()  # Get admin ID from token
    return jsonify({"message": "Access granted", "admin_id": admin_id}), 200


# Get all users
@admin_bp.route('/get_users', methods=['GET'])
def get_users():
    try:
        procedure_name = "GetUsers"
        users = db.call_procedure(procedure_name)

        if users and len(users[0]) > 0:
            return jsonify(format_user_data(users[0])), 200
        else:
            return jsonify({"message": "No users found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Get a specific user by ID
@admin_bp.route('/get_user/<int:emp_id>', methods=['GET'])
def get_user(emp_id):
    try:
        procedure_name = "GetUserById"
        params = (emp_id,)
        user = db.call_procedure(procedure_name, params)

        if user and len(user[0]) > 0:
            return jsonify(format_user_data(user[0])[0]), 200  # Extract single user
        else:
            return jsonify({"message": "User not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500
