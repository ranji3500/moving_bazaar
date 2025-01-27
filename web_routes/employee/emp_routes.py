from flask import request, jsonify
from db_function import db
from web_routes.employee import employee_bp

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
        result = db.insert_using_procedure(procedure_name, params)
        if result:
            if "Invalid email or password" in result:
                return jsonify({"message": result}), 401
            return jsonify({
                "message": "Login successful",
                "employee": result
            }), 200
        else:
            return jsonify({"message": "Invalid email or password"}), 401
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