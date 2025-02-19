from flask import jsonify, request
from . import orders_bp
import mysql.connector
from db_function import db


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
