from flask import jsonify, request, current_app, send_from_directory
from . import orders_bp
import mysql.connector
from db_function import db
from werkzeug.utils import secure_filename
import os
import json
from uuid import uuid4
from datetime import datetime
from flask_jwt_extended import jwt_required, get_jwt


def get_employee_id():
    claims = get_jwt()
    return claims.get("employee_id") or claims.get("sub")


@orders_bp.route('/create_order', methods=['POST'])
@jwt_required()
def create_order():
    try:
        data = request.json
        employee_id = get_employee_id()
        result = db.insert_using_procedure("create_order", (data['senderId'], data['receiverId'], employee_id))

        if not result or not isinstance(result, dict):
            return jsonify({"error": "Invalid response from stored procedure"}), 500

        return jsonify({
            "data": {
                "orderId": result.get("orderId"),
                "orderStage": result.get("orderStage")
            },
            "message": result.get("message", "")
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/insert-order-items', methods=['POST'])
@jwt_required()
def insert_order_items():
    try:
        data = request.json
        employee_id = get_employee_id()
        params = (data["order_id"], json.dumps(data["items"]), employee_id)

        result = db.insert_using_procedure("add_order_items", params)
        return jsonify({"data": result, "message": "All order items added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/delete-order-commodity', methods=['POST'])
@jwt_required()
def delete_order_commodity():
    try:
        data = request.json
        employee_id = get_employee_id()
        params = (data["order_id"], data["commodity_id"], employee_id)
        result = db.call_procedure("delete_order_commodity", params)
        return jsonify({"message": result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/details/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order_details(order_id):
    try:
        employee_id = get_employee_id()
        result = db.call_procedure("get_order_details", (order_id, employee_id))

        if not result or not isinstance(result, list) or len(result) == 0:
            return jsonify({"Status": "Failure", "Message": "No order found or invalid result format"}), 404

        return jsonify({"data": result[0], "message": "success"}), 200
    except mysql.connector.Error as err:
        return jsonify({"Status": "Failure", "Message": f"MySQL Error: {str(err)}"}), 500
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": f"Server Error: {str(e)}"}), 500


@orders_bp.route('/editorder', methods=['PUT'])
@jwt_required()
def edit_order():
    try:
        data = request.json
        employee_id = get_employee_id()
        params = (
            data['order_id'],
            data['sender_id'],
            data['receiver_id'],
            data['order_status'].capitalize(),
            employee_id
        )
        result = db.insert_using_procedure("edit_order", params)
        return jsonify({
            "message": result.get("Message", "Order Updated Successfully"),
            "status": result.get("Status", "Success")
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/deleteorder/<int:order_id>', methods=['DELETE'])
@jwt_required()
def delete_order(order_id):
    try:
        employee_id = get_employee_id()
        result = db.insert_using_procedure("delete_order", (order_id, employee_id))

        if result:
            return jsonify({
                "message": result.get("Message", "Order deleted successfully"),
                "status": result.get("Status", "Success")
            }), 200
        else:
            return jsonify({"message": "No result returned from procedure"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order_commodities(order_id):
    try:
        employee_id = get_employee_id()
        params = (order_id, employee_id)
        result = db.call_procedure("get_order_commodities", params)
        return jsonify({"status": "success", "commodities": result}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@orders_bp.route('/getOrderDetailsByStatus', methods=['POST'])
@jwt_required()
def get_order_details_by_status():
    try:
        employee_id = get_employee_id()
        data = request.json
        params = (
            data.get("order_status", ""),
            data.get("order_id", ""),
            data.get("delivery_date"),
            int(data.get("page_number", 1)),
            int(data.get("page_size", 10)),
            employee_id
        )
        results = db.call_procedure("getOrderDetailsByStatus", params)

        if not results or len(results) < 2:
            return jsonify({"status": "success", "totalRecords": 0, "orders": []}), 200

        return jsonify({
            "status": "success",
            "totalRecords": results[0][0].get("totalRecords", 0),
            "orders": results[1]
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@orders_bp.route('/getdeliverorderdetails', methods=['GET'])
@jwt_required()
def getdeliverorderdetails():
    try:
        order_id = request.args.get('orderId', type=int)

        if not order_id:
            return jsonify({
                "Status": "Failure",
                "Message": "Missing or invalid 'order_id' in query parameters."
            }), 400

        result = db.call_procedure("GetOrderAndStores", (order_id,))

        result = result[0]['result']
        order_data = json.loads(result)
        if not result or not result[0]:
            return jsonify({
                "data": {},
                "message": "No data found"
            }), 200

        return jsonify({
            "data": order_data,
            "message": "success"
        }), 200

    except Exception as e:
        return jsonify({
            "data": None,
            "message": str(e)
        }), 500
