from flask import jsonify, request
from . import billing_bp
from db_function import db
from logger_config import setup_logger
from flask_jwt_extended import jwt_required, get_jwt
import os
import json

# Set up logger for billing
log_file = os.path.join(os.getcwd(), 'logs', 'billing.log')
logger = setup_logger('billing', log_file)

# ✅ API: Generate Billing
@billing_bp.route('/generate_billing', methods=['POST'])
@jwt_required()
def generate_billing():
    try:
        data = request.json
        claims = get_jwt()
        created_by = claims.get("sub")
        paid_by = data['paid_by']
        outstanding_amount = data['outstanding_amount']
        order_id = data['order_id']

        params = (order_id, created_by, paid_by, outstanding_amount)
        result = db.insert_using_procedure("generate_billing", params)
        return jsonify(result), 201
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

# ✅ Create a new order
@billing_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
@jwt_required()
def create_order():
    data = request.json
    try:
        claims = get_jwt()
        created_by = claims.get("sub")
        procedure_name = "create_order"
        params = (data['sender_id'], data['receiver_id'], created_by)
        result = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": "Order Created Successfully", "order_id": result[0][0][0]}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ✅ Get Order Details
@billing_bp.route('/details/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order_details(order_id):
    try:
        procedure_name = "get_order_details"
        params = (order_id,)
        result = db.call_procedure(procedure_name, params)

        if result and len(result) >= 2:
            order_info = result[0][0]
            order_items = result[1]

            return jsonify({
                "order_id": order_info[0],
                "sender_id": order_info[1],
                "receiver_id": order_info[2],
                "created_by": order_info[3],
                "order_status": order_info[4],
                "created_at": order_info[5].isoformat(),
                "items": [
                    {
                        "order_item_id": item[0],
                        "commodity_name": item[1],
                        "quantity": item[2],
                        "price": float(item[3]),
                        "subtotal": float(item[4])
                    } for item in order_items
                ]
            }), 200
        else:
            return jsonify({"message": "Order not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ✅ Edit an Order
@billing_bp.route('/edit', methods=['PUT'])
@jwt_required()
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
@billing_bp.route('/delete/<int:order_id>', methods=['DELETE'])
@jwt_required()
def delete_order(order_id):
    try:
        procedure_name = "delete_order"
        params = (order_id,)
        db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": "Order Deleted Successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# API to Get Billing Details by Employee ID
@billing_bp.route('/billing/employee/<int:employee_id>', methods=['GET'])
@jwt_required()
def get_billing_by_employee(employee_id):
    try:
        params = (employee_id,)
        billing_data = db.call_procedure("GetBillingByEmployeeId", params)
        return jsonify({"billing_details": billing_data})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# CLOSE Multiple Outstanding Balances
@billing_bp.route('/close_outstanding_balances', methods=['POST'])
@jwt_required()
def close_outstanding_balances():
    data = request.json
    try:
        order_ids = data.get('order_ids', [])

        if not isinstance(order_ids, list) or not order_ids:
            return jsonify({"error": "Provide a non-empty list of order_ids"}), 400

        results = []
        for order_id in order_ids:
            try:
                procedure_name = "CloseOutstandingBalanceByOrderId"
                params = (order_id,)
                result = db.insert_using_procedure(procedure_name, params)
                results.append({"order_id": order_id, "result": result})
            except Exception as inner_e:
                results.append({"order_id": order_id, "error": str(inner_e)})

        return jsonify(results), 200

    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@billing_bp.route('/insertbillingdetails', methods=['POST'])
@jwt_required()
def insert_billing_details():
    data = request.json
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        procedure_name = "insert_billing"

        params = (
            data.get('order_id'),
            user_id,
            data.get('paid_by'),
            data.get('grand_total'),
            data.get('current_order_value'),
            data.get('total_amount_paid'),
            data.get('current_order_amount_paid'),
            data.get('outstanding_amount_paid'),
            json.dumps(data.get('closed_outstanding_order_ids', [])),
            data.get('delivery_date')
        )

        if None in params:
            return jsonify({"error": "Missing required fields in the request"}), 400

        message = db.insert_using_procedure(procedure_name, params)

        return jsonify({"data": {"billingId": message["billing_id"], "orderId": message['order_id'], "orderStage": "delivery"}, "message": message["message"]}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500