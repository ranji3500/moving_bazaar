from flask import request, jsonify, make_response
from db_function import db
from web_routes.employee import employee_bp
from flask_jwt_extended import create_access_token
from datetime import timedelta

# CREATE Employee
@employee_bp.route('/create_employee', methods=['POST'])
def create_employee():
    data = request.json
    try:
        procedure_name = "InsertEmployee"
        params = (
            data.get('full_name'),
            data.get('email'),
            data.get('phone_number'),
            data.get('password'),
            data.get('profile_photo', None),
            data.get('is_admin', False)
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": "Employee created successfully", "rows_affected": rows_affected}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# UPDATE Employee
@employee_bp.route('/update_employee/<int:emp_id>', methods=['PUT'])
def update_employee(emp_id):
    data = request.json
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
def delete_employee(emp_id):
    try:
        procedure_name = "DeleteEmployee"
        params = (emp_id,)
        rows_affected = db.insert_using_procedure(procedure_name, params)
        if rows_affected > 0:
            return jsonify({"message": "Employee deleted successfully"}), 200
        else:
            return jsonify({"message": "Employee not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# LOGIN Employee
@employee_bp.route('/login_employee', methods=['POST'])
def login_employee():
    data = request.json
    try:
        procedure_name = "LoginEmployee"
        params = (data.get('email'), data.get('password'))

        # Call stored procedure
        result = db.call_procedure(procedure_name, params)
        print("RESULT:", result)

        # Ensure result is not empty and is a list
        if not result or not isinstance(result, list) or len(result) == 0:
            return jsonify({"message": "Invalid login credentials"}), 401

        response_dict = result[0]

        # Extracting values
        result_status = response_dict["result_status"]
        employee_id = response_dict["employee_id"]
        email = response_dict["email"]
        message = response_dict["message"]

        if result_status == 1:
            # Generate JWT token
            access_token = create_access_token(identity=employee_id, expires_delta=timedelta(hours=2))

            # Create response object
            response = make_response(jsonify({
                "isCredentialsValid": True,
                "message": message,
                "employee": {
                    "employeeId": employee_id,
                    "email": email
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
# FORGOT PASSWORD
@employee_bp.route('/forgot_password', methods=['POST'])
def forgot_password():
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