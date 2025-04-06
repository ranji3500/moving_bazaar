from flask import jsonify, request
from . import orders_bp
import mysql.connector
from db_function import db

import json


# ✅ Create a new order
@orders_bp.route('/create_order', methods=['POST'])
def create_order():
    data = request.json
    try:
        procedure_name = "create_order"
        params = (data['senderId'], data['receiverId'], data['createdBy'])
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

        return jsonify(result), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/delete-order-commodity', methods=['POST'])
def delete_order_commodity():
    """
    API to delete a specific commodity from an order using the stored procedure 'delete_order_commodity'.

    Expected JSON:
    {
        "order_id": 1068025,
        "commodity_id": 17
    }
    """
    data = request.json
    try:
        procedure_name = "delete_order_commodity"
        order_id = data["order_id"]
        commodity_id = data["commodity_id"]

        params = (order_id, commodity_id)  # Procedure expects (order_id, commodity_id)

        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        return jsonify({"message": result}), 200
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
@orders_bp.route('/editorder', methods=['PUT'])
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
@orders_bp.route('/deleteorder/<int:order_id>', methods=['DELETE'])
def delete_order(order_id):
    try:
        procedure_name = "delete_order"
        params = (order_id,)
        result = db.insert_using_procedure(procedure_name, params)
        if result:
            return jsonify({"message": result["Message"],"status":result["Status"]}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ✅ API: Get Order Commodities
@orders_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
def get_order_commodities(order_id):
    try:

        params = (order_id,)
        results = db.call_procedure("get_order_commodities", params)

        return jsonify({"status": "success", "commodities": results}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ✅ API: Get Orders
@orders_bp.route('/getuserstatuswiseorders', methods=['POST'])
def get_order_byuser():
    try:
        data = request.json
        userid = data.get("userid")
        status = data.get("status")

        if not userid or not status:
            return jsonify({"status": "error", "message": "userid and status are required"}), 400

        params = (userid, status)
        results = db.call_procedure("getUserOrdersByStatus", params)


        return jsonify({"status": "success", "orders": results}), 200
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


@orders_bp.route('/order-detailsbystage', methods=['GET'])
def get_order_details_bystage():
    """
    API to fetch order details by order ID and stage using the stored procedure 'GetOrderDetailsbyStagewise'.

    Query Parameters:
    - order_id: The ID of the order (Required)
    - stage: The stage of the order ('order' or 'commodity') (Required)

    URL Example:
    GET /orders/order-detailsbystage?order_id=58430656&stage=order
    GET /orders/order-detailsbystage?order_id=58430656&stage=commodity
    """
    try:
        # Extract query parameters
        order_id = request.args.get('order_id')
        stage = request.args.get('stage')

        # Validate required parameters
        if not order_id or not stage:
            return jsonify({"Status": "Failure", "Message": "Missing required parameters"}), 400

        procedure_name = "GetOrderDetailsbyStagewise"
        params = (order_id, stage)

        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        return jsonify({"Status": "Success", "Details": result}), 200
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500


@orders_bp.route('/getordersummary', methods=['POST'])
def get_order_summary():
    """
    API to fetch order details by order ID using the stored procedure 'GetOrderSummary'.

    Request Body (JSON):
    {
        "order_id": 58430656
    }
    """
    try:
        # Try to parse JSON, even if headers are missing
        data = request.get_json()

        # Validate required parameter
        if not data or "order_id" not in data:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid JSON data. Ensure Content-Type is application/json"}), 400

        order_id = data["order_id"]

        procedure_name = "GetOrderSummary"
        params = (order_id,)
        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        return jsonify( result[0]), 200
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500
