from flask import jsonify, request
from . import billing_bp
from supports.db_function import db
from supports.pdf_creation import generate_invoice
from supports.invoice_pdf import pdf_invoice
from logger_config import setup_logger
from flask_jwt_extended import jwt_required, get_jwt
import os
import json
import threading
from datetime import datetime as pdftime

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


def generate_invoice_background(order_id):
    try:
        # ✅ Step 1: Fetch invoice data
        invoice_result = db.call_procedure("sp_get_invoice_json", (order_id,))
        if not invoice_result or not invoice_result[0]:
            raise ValueError("Invoice generation failed: empty data from DB")

        invoice_json_str = invoice_result[0].get("invoice_data")
        if not invoice_json_str:
            raise ValueError("No invoice_data returned for order")

        invoice_data = json.loads(invoice_json_str)


        # ✅ Step 2: Build file path
        today_str = pdftime.now().strftime("%Y%m%d")
        filename = f"invoice_{order_id}_{today_str}.pdf"
        documents_dir = os.path.join(os.getcwd(), "documents")
        os.makedirs(documents_dir, exist_ok=True)
        # ✅ Step 3: Generate PDF
        pdf_path_ = pdf_invoice(invoice_data, documents_dir,filename)
        if not pdf_path_ or not os.path.exists(pdf_path_):
            raise ValueError("PDF generation failed: file not found")

        paths_json = json.dumps(filename)  # <-- JSON string
        params = (order_id, paths_json, "invoice")
        db.insertall_using_procedure("insertDocument", params)

        logger.info(f"✅ Invoice generated at: {pdf_path_}, DB insert result: {insert_invoice}")
        return pdf_path_

    except Exception as e:
        logger.warning(f"❌ Invoice generation failed for order {order_id}: {e}", exc_info=True)
        return None


@billing_bp.route('/insertbillingdetails', methods=['POST'])
@jwt_required()
def insert_billing_details():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "Empty request body"}), 400

        claims = get_jwt()
        user_id = claims.get("sub")
        if not user_id:
            return jsonify({"error": "User ID not found in token"}), 401


        closed_outstanding_ids = data.get('closed_outstanding_order_ids', [])
        if not isinstance(closed_outstanding_ids, list):
            return jsonify({"error": "closed_outstanding_order_ids must be a list"}), 400

        params = (
            data['order_id'],
            user_id,
            data['paid_by'],
            data['grand_total'],
            data['current_order_value'],
            data['total_amount_paid'],
            data['current_order_amount_paid'],
            data['outstanding_amount_paid'],
            json.dumps(closed_outstanding_ids),
            data['delivery_date']
        )

        message = db.insert_using_procedure("insert_billing", params)

        if not isinstance(message, dict):
            return jsonify({"error": "Unexpected response from billing insertion"}), 500

        if "billing_id" not in message or "order_id" not in message:
            return jsonify({"error": "Billing insert did not return required IDs"}), 500

        order_id = message['order_id']

        # 🧵 Start the thread
        threading.Thread(target=generate_invoice_background, args=(order_id,), daemon=True).start()

        return jsonify({
            "data": {
                "billingId": message["billing_id"],
                "orderId": message["order_id"],
                "orderStage": "delivery"
            },
            "message": message.get("message", "Billing inserted successfully")
        }), 200

    except KeyError as ke:
        return jsonify({"error": f"Missing key: {ke}"}), 400
    except Exception as e:
        logger.exception("Billing insertion failed")
        return jsonify({"error": str(e)}), 500


@billing_bp.route('/test', methods=['GET'])
def billing_test_api():
    sample_response = {
        "status": "success"
        }
    return jsonify(sample_response), 200

# API to Get Billing Details by Order ID (POST)
@billing_bp.route('/invoice_pdf', methods=['POST'])
def get_invoice_by_orders():
    try:
        data = request.get_json()

        if not data or 'order_id' not in data:
            return jsonify({"error": "Missing 'order_id' in request body"}), 400

        order_id = data['order_id']
        params = (order_id,)
        invoice_result = db.call_procedure("sp_get_invoice_json", params)

        if not invoice_result or not invoice_result[0]:
            return jsonify({"error": "No invoice found for given order ID"}), 404

        import json
        invoice_json_str = invoice_result[0]["invoice_data"]
        invoice_data = json.loads(invoice_json_str)

        return jsonify({"invoice_data": invoice_data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@billing_bp.route('/billing_overview', methods=['GET'])
@jwt_required()
def get_billing_overview():
    try:
        claims = get_jwt()

        status_filter = request.args.get('status', None)
        user_id = claims.get('sub')
        claims = get_jwt()
        # result = db.call_procedure('GetBillingByEmployeeId', (status_filter,))
        result = db.call_procedure('GetBillingByEmployeeId', (user_id,))

        if not result:
            return jsonify({
                "status": "Success",
                "message": "No billing records found.",
                "data": []
            }), 200

        return jsonify({
            "status": "Success",
            "message": "Billing records retrieved successfully.",
            "data": result
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500