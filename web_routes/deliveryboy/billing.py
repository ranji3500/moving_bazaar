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
from logger_configuration import logger



# log_dir = os.path.join(os.getcwd(), 'logs')
# os.makedirs(log_dir, exist_ok=True)  # ✅ create folder before using it
#
# log_file = os.path.join(log_dir, 'billing.log')
#
# # Set up logger for billing
# logger = setup_logger('billing', log_file)


# Set up logger for billing
# log_file = os.path.join(os.getcwd(), 'logs', 'billing.log')
# logger = setup_logger('billing', log_file)
# os.makedirs(log_dir, exist_ok=True)
# ✅ API: Generate Billing
@billing_bp.route('/generate_billing', methods=['POST'])
@jwt_required()
def generate_billing():
    try:
        data = request.json
        claims = get_jwt()
        created_by = claims.get("sub")
        paid_by = data.get('paid_by')
        outstanding_amount = data.get('outstanding_amount')
        order_id = data.get('order_id')

        # Validate input
        if not paid_by or outstanding_amount is None or not order_id:
            logger.warning(
                "Generate billing attempt with missing fields: created_by=%s, data=%s",
                created_by, data
            )
            return jsonify({"message": "Missing required billing information"}), 400

        params = (order_id, created_by, paid_by, outstanding_amount)
        result = db.insert_using_procedure("generate_billing", params)

        logger.info(
            "Billing generated successfully: order_id=%s by user=%s, paid_by=%s, amount=%s",
            order_id, created_by, paid_by, outstanding_amount
        )
        return jsonify(result), 201

    except Exception as e:
        logger.exception(
            "Exception occurred while generating billing for order"
        )
        return jsonify({"status": "error", "message": "Internal server error"}), 500

# ✅ Create a new order
@billing_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
@jwt_required()
def create_order():
    try:
        data = request.json
        claims = get_jwt()
        created_by = claims.get("sub")

        if not data.get('sender_id') or not data.get('receiver_id'):
            logger.warning(
                "Create order attempt with missing sender or receiver: created_by=%s, data=%s",
                created_by, data
            )
            return jsonify({"message": "Sender and receiver IDs are required"}), 400

        procedure_name = "create_order"
        params = (data['sender_id'], data['receiver_id'], created_by)
        result = db.insert_using_procedure(procedure_name, params)

        logger.info(
            "Order created successfully: order_id=%s by user=%s, sender_id=%s, receiver_id=%s",
            result[0][0][0], created_by, data['sender_id'], data['receiver_id']
        )
        return jsonify({"message": "Order Created Successfully", "order_id": result[0][0][0]}), 201

    except Exception as e:
        logger.exception(
            "Exception occurred while creating order by user"
        )
        return jsonify({"error": "Internal server error"}), 500

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

            logger.info(
                "Fetched order details: order_id=%s",
                order_id
            )

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
            logger.warning(
                "Order not found: order_id=%s",
                order_id
            )
            return jsonify({"message": "Order not found"}), 404

    except Exception as e:
        logger.exception(
            "Exception occurred while fetching order details: order_id=%s",
            order_id
        )
        return jsonify({"error": "Internal server error"}), 500


# ✅ Edit an Order
@billing_bp.route('/edit', methods=['PUT'])
@jwt_required()
def edit_order():
    try:
        data = request.json
        if not data.get('order_id') or not data.get('sender_id') or not data.get('receiver_id') or not data.get('order_status'):
            logger.warning("Edit order attempt with missing fields: data=%s", data)
            return jsonify({"message": "All order fields are required"}), 400

        procedure_name = "edit_order"
        params = (data['order_id'], data['sender_id'], data['receiver_id'], data['order_status'])
        db.insert_using_procedure(procedure_name, params)

        logger.info(
            "Order updated successfully: order_id=%s, sender_id=%s, receiver_id=%s, status=%s",
            data['order_id'], data['sender_id'], data['receiver_id'], data['order_status']
        )
        return jsonify({"message": "Order Updated Successfully"}), 200

    except Exception as e:
        logger.exception("Exception occurred while editing order")
        return jsonify({"error": "Internal server error"}), 500


# ✅ Delete an Order
@billing_bp.route('/delete/<int:order_id>', methods=['DELETE'])
@jwt_required()
def delete_order(order_id):
    try:
        procedure_name = "delete_order"
        params = (order_id,)
        db.insert_using_procedure(procedure_name, params)

        logger.info("Order deleted successfully: order_id=%s", order_id)
        return jsonify({"message": "Order Deleted Successfully"}), 200

    except Exception as e:
        logger.exception("Exception occurred while deleting order: order_id=%s", order_id)
        return jsonify({"error": "Internal server error"}), 500


# CLOSE Multiple Outstanding Balances
@billing_bp.route('/close_outstanding_balances', methods=['POST'])
@jwt_required()
def close_outstanding_balances():
    try:
        data = request.json
        order_ids = data.get('order_ids', [])

        if not isinstance(order_ids, list) or not order_ids:
            logger.warning("Close outstanding balances attempt with invalid order_ids: %s", order_ids)
            return jsonify({"error": "Provide a non-empty list of order_ids"}), 400

        results = []
        for order_id in order_ids:
            try:
                procedure_name = "CloseOutstandingBalanceByOrderId"
                params = (order_id,)
                result = db.insert_using_procedure(procedure_name, params)
                results.append({"order_id": order_id, "result": result})
                logger.info("Outstanding balance closed successfully: order_id=%s", order_id)
            except Exception as inner_e:
                results.append({"order_id": order_id, "error": str(inner_e)})
                logger.exception("Failed to close outstanding balance: order_id=%s", order_id)

        return jsonify(results), 200

    except Exception as e:
        logger.exception("Exception occurred while closing outstanding balances")
        return jsonify({"error": "Internal server error"}), 500

def generate_invoice_background(order_id):
    try:
        logger.info(f"🔄 Starting invoice generation for order_id={order_id}")

        # ✅ Step 1: Fetch invoice data
        invoice_result = db.call_procedure("sp_get_invoice_json", (order_id,))
        logger.debug(f"Fetched invoice_result from DB: {invoice_result}")

        if not invoice_result or not invoice_result[0]:
            raise ValueError("Invoice generation failed: empty data from DB")

        invoice_json_str = invoice_result[0].get("invoice_data")
        if not invoice_json_str:
            raise ValueError("No invoice_data returned for order")

        invoice_data = json.loads(invoice_json_str)
        logger.debug(f"Parsed invoice JSON for order_id={order_id}")

        # ✅ Step 2: Build file path
        today_str = pdftime.now().strftime("%Y%m%d")
        filename = f"invoice_{order_id}_{today_str}"
        documents_dir = os.path.join(os.getcwd(), "documents")
        os.makedirs(documents_dir, exist_ok=True)

        # ✅ Step 3: Generate PDF
        pdf_path_, filenames = pdf_invoice(invoice_data, documents_dir, filename)
        if not pdf_path_ or not os.path.exists(pdf_path_):
            raise ValueError("PDF generation failed: file not found")

        logger.info(f"PDF successfully created for order_id={order_id} at {pdf_path_}")

        # ✅ Step 4: Save to DB
        paths_json = json.dumps(filenames)
        params = (order_id, paths_json, "invoice")
        db.insertall_using_procedure("insertDocument", params)
        logger.info(f"Inserted invoice document into DB for order_id={order_id}")

        return pdf_path_

    except Exception as e:
        logger.error(f"❌ Invoice generation failed for order_id={order_id}: {e}", exc_info=True)
        return None


@billing_bp.route('/insertbillingdetails', methods=['POST'])
@jwt_required()
def insert_billing_details():
    try:
        logger.info("Received request to insert billing details")
        data = request.get_json()
        logger.debug(f"Request data: {data}")

        if not data:
            logger.warning("Empty request body received")
            return jsonify({"error": "Empty request body"}), 400

        claims = get_jwt()
        user_id = claims.get("sub")
        if not user_id:
            logger.warning("JWT does not contain user_id")
            return jsonify({"error": "User ID not found in token"}), 401

        closed_outstanding_ids = data.get('closed_outstanding_order_ids', [])
        if not isinstance(closed_outstanding_ids, list):
            logger.warning("closed_outstanding_order_ids is not a list")
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

        logger.info(f"Inserting billing details for order_id={data['order_id']} by user_id={user_id}")
        message = db.insert_using_procedure("insert_billing", params)
        logger.debug(f"DB response from insert_billing: {message}")

        if not isinstance(message, dict):
            logger.error("Unexpected response from billing insertion")
            return jsonify({"error": "Unexpected response from billing insertion"}), 500

        if "billing_id" not in message or "order_id" not in message:
            logger.error("Billing insert did not return required IDs")
            return jsonify({"error": "Billing insert did not return required IDs"}), 500

        order_id = message['order_id']

        # 🧵 Start the thread
        logger.info(f"Spawning background thread to generate invoice for order_id={order_id}")
        threading.Thread(target=generate_invoice_background, args=(order_id,), daemon=True).start()

        logger.info(f"Billing inserted successfully for order_id={order_id}, billing_id={message['billing_id']}")
        return jsonify({
            "data": {
                "billingId": message["billing_id"],
                "orderId": message["order_id"],
                "orderStage": "delivery"
            },
            "message": message.get("message", "Billing inserted successfully")
        }), 200

    except KeyError as ke:
        logger.error(f"Missing key in billing details request: {ke}")
        return jsonify({"error": f"Missing key: {ke}"}), 400
    except Exception as e:
        logger.exception("Billing insertion failed due to unexpected error")
        return jsonify({"error": str(e)}), 500

# ✅ Health Check API
@billing_bp.route('/test', methods=['GET'])
def billing_test_api():
    try:
        logger.info("Billing test API called")
        sample_response = {"status": "success"}
        return jsonify(sample_response), 200
    except Exception as e:
        logger.exception("Error in billing_test_api")
        return jsonify({"error": str(e)}), 500


# ✅ API to Get Billing Details by Order ID
@billing_bp.route('/invoice_pdf', methods=['POST'])
def get_invoice_by_orders():
    try:
        logger.info("Invoice PDF API called")
        data = request.get_json()
        logger.debug(f"Request payload: {data}")

        if not data or 'order_id' not in data:
            logger.warning("Missing 'order_id' in request body")
            return jsonify({"error": "Missing 'order_id' in request body"}), 400

        order_id = data['order_id']
        logger.info(f"Fetching invoice for order_id={order_id}")

        params = (order_id,)
        invoice_result = db.call_procedure("sp_get_invoice_json", params)
        logger.debug(f"DB response for invoice fetch: {invoice_result}")

        if not invoice_result or not invoice_result[0]:
            logger.warning(f"No invoice found for order_id={order_id}")
            return jsonify({"error": "No invoice found for given order ID"}), 404

        import json
        invoice_json_str = invoice_result[0]["invoice_data"]
        invoice_data = json.loads(invoice_json_str)

        logger.info(f"Invoice data retrieved successfully for order_id={order_id}")
        return jsonify({"invoice_data": invoice_data}), 200

    except Exception as e:
        logger.exception("Error occurred while fetching invoice")
        return jsonify({"error": str(e)}), 500


# ✅ API to Get Billing Overview
@billing_bp.route('/billing_overview', methods=['GET'])
@jwt_required()
def get_billing_overview():
    try:
        logger.info("Billing overview API called")
        claims = get_jwt()
        user_id = claims.get('sub')
        status_filter = request.args.get('status', None)

        logger.info(f"Fetching billing overview for user_id={user_id}, status_filter={status_filter}")
        result = db.call_procedure('GetBillingByEmployeeId', (user_id,))
        logger.debug(f"DB response for billing overview: {result}")

        if not result:
            logger.info(f"No billing records found for user_id={user_id}")
            return jsonify({
                "status": "Success",
                "message": "No billing records found.",
                "data": []
            }), 200

        logger.info(f"Billing records retrieved successfully for user_id={user_id}, count={len(result)}")
        return jsonify({
            "status": "Success",
            "message": "Billing records retrieved successfully.",
            "data": result
        }), 200

    except Exception as e:
        logger.exception("Error occurred while fetching billing overview")
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500
