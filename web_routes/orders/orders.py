from flask import jsonify, request
from . import orders_bp
import mysql.connector
from db_function import db

import json


# ✅ Create a new order
@orders_bp.route('/create', methods=['POST'])
def create_order():
    data = request.json
    try:
        procedure_name = "create_order"
        params = (data['sender_id'], data['receiver_id'], data['created_by'])
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify({"message":  result}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/insert-order-items', methods=['POST'])
def insert_order_items():
    """
    API to insert order items using the stored procedure 'add_order_items'.

    Expected JSON:
    {
        "order_id": 56224403,
        "items": [
            {"commodity_id": 17, "quantity": 3, "price": 120.00},
            {"commodity_id": 18, "quantity": 2, "price": 60.00}
        ]
    }
    """
    data = request.json
    try:
        procedure_name = "add_order_items"
        order_id = data["order_id"]
        items_json = json.dumps(data["items"])  # Convert list to JSON string

        params = (order_id, items_json)  # Procedure expects (order_id, JSON array)

        # Execute stored procedure
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify({"message": result}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
# ✅ Get Order Details
@orders_bp.route('/orders/details/<int:order_id>', methods=['GET'])
def get_order_details(order_id):
    try:
        procedure_name = "get_order_details"
        params = (order_id,)

        # ✅ Call the stored procedure
        results = db.call_procedure(procedure_name, params)

        return jsonify(results), 200

    except mysql.connector.Error as err:
        return jsonify({"Status": "Failure", "Message": str(err)}), 500
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500

# ✅ Edit an Order
@orders_bp.route('/edit', methods=['PUT'])
def edit_order():
    data = request.json
    try:
        procedure_name = "edit_order"
        params = (data['order_id'], data['sender_id'], data['receiver_id'], data['order_status'])
        db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": "Order Updated Successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ✅ Delete an Order
@orders_bp.route('/delete/<int:order_id>', methods=['DELETE'])
def delete_order(order_id):
    try:
        procedure_name = "delete_order"
        params = (order_id,)
        db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": "Order Deleted Successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
# ✅ API: Get Order Commodities
@orders_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
def get_order_commodities(order_id):
    try:

        params = (order_id,)
        results = db.insert_using_procedure("get_order_commodities", params)

        commodities = []
        for result in results:
            commodities.extend(result.fetchall())

        return jsonify({"status": "success", "commodities": commodities}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ✅ API: Get Orders
@orders_bp.route('/getordersbyuser/<int:userid>', methods=['GET'])
def get_order_byuser(userid):
    try:

        params = (userid,)
        results = db.call_procedure("getOrdersByUser", params)

        commodities = []
        for result in results:
            commodities.extend(result.fetchall())

        return jsonify({"status": "success", "commodities": commodities}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ✅ API: Get Orders
@orders_bp.route('/getuserordersbystatus/<int:userid>', methods=['GET'])
def getuserordersbystatus(userid):
    try:

        params = (userid,)
        results = db.call_procedure("getUserOrdersByStatus", params)

        commodities = []
        for result in results:
            commodities.extend(result.fetchall())

        return jsonify({"status": "success", "commodities": commodities}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@orders_bp.route('by-employee/<int:employee_id>', methods=['GET'])
def get_orders_by_employee(employee_id):
    """
    API to fetch orders by employee ID using the stored procedure 'GetOrdersByEmployeeId'.

    URL Example:
    GET /orders/by-employee/10
    """
    try:
        procedure_name = "GetOrdersByEmployeeId"
        params = (employee_id,)  # Tuple with one element

        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        return jsonify({"Status": "Success", "Orders": result}), 200
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500
