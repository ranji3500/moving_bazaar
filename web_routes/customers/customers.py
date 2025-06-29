from flask import request, jsonify
from db_function import db
from  . import customers_bp
from flask_jwt_extended import create_access_token, jwt_required, get_jwt
from datetime import timedelta

# CREATE Customer
@customers_bp.route('/create_customer', methods=['POST'])
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

# UPDATE Customer
@customers_bp.route('/update_customer/<int:customer_id>', methods=['PUT'])
@jwt_required()
def update_customer(customer_id):
    data = request.json
    claims = get_jwt()
    user_id = claims.get('userId')
    try:
        procedure_name = "update_customer"
        params = (
            user_id,
            customer_id,
            data.get('store_name'),
            data.get('email'),
            data.get('whatsapp_number', None),
            data.get('address_line1'),
            data.get('address_line2', None),
            data.get('city'),
            float(data.get('outstanding_price', 0.00))
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": rows_affected}), 200
    except ValueError as ve:
        return jsonify({"error": f"Invalid data format: {str(ve)}"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# DELETE Customer
@customers_bp.route('/delete_customer/<int:customer_id>', methods=['DELETE'])
@jwt_required()
def delete_customer(customer_id):
    try:
        procedure_name = "delete_customer"
        params = (customer_id,)
        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": rows_affected}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# GET Customer by Phone Number
@customers_bp.route('/get_customer_by_phone', methods=['POST'])
@jwt_required()
def get_customer_by_phone():
    data = request.json
    try:
        procedure_name = "get_customer_by_phone"
        params = (data.get('phone_number'),)
        result = db.call_procedure(procedure_name, params)
        if result and len(result) > 0:
            customer_data = result
            return jsonify({"message": "Customers fetched successfully", "data": customer_data}), 200
        else:
            return jsonify({"data": None, "message": "Customer not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# API to Get Customers
@customers_bp.route('/customers', methods=['GET'])
@jwt_required()
def get_customers():
    try:
        customers = db.call_procedure("CALL GetCustomers")
        return jsonify({"customers": customers})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# API to Get Orders by Employee ID
@customers_bp.route('/orders/employee/<int:employee_id>', methods=['GET'])
@jwt_required()
def get_orders_by_employee(employee_id):
    try:
        params = (employee_id,)
        orders = db.call_procedure("GetOrdersByEmployeeId", params)
        return jsonify({"orders": orders})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# API to Get Customer Outstanding by ID
@customers_bp.route('/getcustomeroutstanding/<customerid>', methods=['GET'])
@jwt_required()
def get_customer_outstanding(customerid):
    try:
        params = (customerid,)
        orders = db.call_procedure("GetCustomerBalance", params)
        return jsonify(orders)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# INSERT Outstanding Balance
@customers_bp.route('/insert_outstanding_balance', methods=['POST'])
@jwt_required()
def insert_outstanding_balance():
    data = request.json
    try:
        customer_id = data.get('customer_id')
        order_id = data.get('order_id')
        outstanding_amount = float(data.get('outstanding_amount', 0.00))

        if not customer_id or not order_id or outstanding_amount <= 0:
            return jsonify({"error": "Invalid input. Ensure customer_id, order_id, and a positive outstanding_amount."}), 400

        procedure_name = "InsertOutstandingBalance"
        params = (customer_id, order_id, outstanding_amount)
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify(result), 200
    except ValueError:
        return jsonify({"error": "Invalid data format. Please check your input."}), 400
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

# GET Outstanding Balance by Customer ID using Stored Procedure
@customers_bp.route('/get_outstanding_balance/<int:customer_id>', methods=['GET'])
@jwt_required()
def get_outstanding_balance(customer_id):
    try:
        procedure_name = "GetOutstandingBalanceByCustomer"
        params = (customer_id,)
        result = db.call_procedure(procedure_name, params)
        return jsonify({"data": result, "message": "success"}), 200
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
