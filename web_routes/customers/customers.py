from flask import request, jsonify
from db_function import db
from  . import customers_bp
from flask_jwt_extended import create_access_token
from datetime import timedelta

# CREATE Customer
@customers_bp.route('/create_customer', methods=['POST'])
def create_customer():
    data = request.json
    try:
        procedure_name = "insert_customer"
        params = (
            data.get('store_name'),
            data.get('email'),
            data.get('phone_number'),
            data.get('whatsapp_number', None),
            data.get('address_line1'),
            data.get('address_line2', None),
            data.get('city'),
            data.get('outstanding_price', 0.00)
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": rows_affected}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# UPDATE Customer
@customers_bp.route('/update_customer/<int:customer_id>', methods=['PUT'])
def update_customer(customer_id):
    data = request.json
    try:
        procedure_name = "update_customer"
        params = (
            customer_id,
            data.get('store_name'),
            data.get('email'),
            data.get('whatsapp_number', None),
            data.get('address_line1'),
            data.get('address_line2', None),
            data.get('city'),
            float(data.get('outstanding_price', 0.00))  # Convert to float explicitly
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)

        return jsonify({"message": rows_affected}), 200

    except ValueError as ve:
        return jsonify({"error": f"Invalid data format: {str(ve)}"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# DELETE Customer
@customers_bp.route('/delete_customer/<int:customer_id>', methods=['DELETE'])
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
def get_customer_by_phone():
    data = request.json
    try:
        procedure_name = "get_customer_by_phone"
        params = (data.get('phone_number'),)

        # Call stored procedure
        result = db.call_procedure(procedure_name, params)

        if result and len(result[0]) > 0:
            customer_data = result[0][0]

            return jsonify({
                "customer_id": customer_data[0],
                "store_name": customer_data[1],
                "email": customer_data[2],
                "phone_number": customer_data[3],
                "whatsapp_number": customer_data[4],
                "address_line1": customer_data[5],
                "address_line2": customer_data[6],
                "city": customer_data[7],
                "outstanding_price": float(customer_data[8]),
                "created_at": customer_data[9]
            }), 200
        else:
            return jsonify({"message": "Customer not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# API to Get Customers
@customers_bp.route('/customers', methods=['GET'])
def get_customers():
    try:
        customers = db.call_procedure("CALL GetCustomers")

        return jsonify({"customers": customers})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# API to Get Orders by Employee ID
@customers_bp.route('/orders/employee/<int:employee_id>', methods=['GET'])
def get_orders_by_employee(employee_id):
    try:
        params =(employee_id,)
        orders = db.call_procedure("GetOrdersByEmployeeId",params)
        return jsonify({"orders": orders})
    except Exception as e:
        return jsonify({"error": str(e)}), 500



