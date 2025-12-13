from flask import jsonify, request, current_app, send_from_directory
from . import orders_bp
import mysql.connector
from supports.db_function import db
from werkzeug.utils import secure_filename
# from pdf_creation import generate_invoice
import json
from uuid import uuid4
import os
from datetime import datetime
from flask_jwt_extended import jwt_required, get_jwt
from logger_configuration import logger


# 📌 Create Order
@orders_bp.route('/create_order', methods=['POST'])
@jwt_required()
def create_order():
    data = request.json
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"User {user_id} is creating an order with data: {data}")

        procedure_name = "create_order"
        params = (data['senderId'], data['receiverId'], user_id)

        result = db.insert_using_procedure(procedure_name, params)
        logger.info(f"Stored procedure '{procedure_name}' executed successfully. Result: {result}")

        if not result or not isinstance(result, dict):
            logger.error(f"Invalid response from stored procedure '{procedure_name}'. Result: {result}")
            return jsonify({"error": "Invalid response from stored procedure"}), 500

        response = {
            "data": {
                "orderId": result.get("orderId"),
                "orderStage": result.get("orderStage")
            },
            "message": result.get("message", "")
        }
        logger.info(f"Order created successfully: {response}")
        return jsonify(response), 201

    except Exception as e:
        logger.exception(f"Error creating order: {str(e)}")
        return jsonify({"error": str(e)}), 500


# ✅ Insert order items

# 📌 Insert Order Items
@orders_bp.route('/insert-order-items', methods=['POST'])
@jwt_required()
def insert_order_items():
    data = request.json
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"User {user_id} inserting order items. Payload: {data}")

        procedure_name = "add_order_items"
        order_id = data["order_id"]
        items_json = json.dumps(data["items"])
        params = (order_id, items_json, user_id)

        result = db.insert_using_procedure(procedure_name, params)
        logger.info(f"Stored procedure '{procedure_name}' executed successfully. Result: {result}")

        response = {
            "data": result,
            "message": "All order items added successfully"
        }
        logger.info(f"Order items added successfully for order_id={order_id}")
        return jsonify(response), 201

    except Exception as e:
        logger.exception(f"Error inserting order items: {str(e)}")
        return jsonify({"error": str(e)}), 500


# 📌 Delete Order Commodity
@orders_bp.route('/delete-order-commodity', methods=['POST'])
@jwt_required()
def delete_order_commodity():
    try:
        data = request.json
        claims = get_jwt()
        user_id = claims.get("sub")

        order_id = data["order_id"]
        commodity_id = data["commodity_id"]

        logger.info(f"User {user_id} deleting commodity {commodity_id} from order {order_id}")

        procedure_name = "delete_order_commodity"
        params = (order_id, commodity_id, user_id)

        result = db.call_procedure(procedure_name, params)
        logger.info(f"Stored procedure '{procedure_name}' executed successfully. Result: {result}")

        response = {"message": result}
        logger.info(f"Commodity {commodity_id} deleted from order {order_id} by user {user_id}")
        return jsonify(response), 200

    except Exception as e:
        logger.exception(f"Error deleting commodity from order: {str(e)}")
        return jsonify({"error": str(e)}), 500


# 📌 Get Order Details
@orders_bp.route('/details/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order_details(order_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} fetching details for order_id={order_id}")

        procedure_name = "get_order_details"
        params = (order_id, user_id)

        results = db.call_procedure(procedure_name, params)
        logger.info(f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, results={results}")

        if not results or not isinstance(results, list) or len(results) == 0:
            logger.warning(f"[ORDERS] No order found for order_id={order_id} by user {user_id}")
            return jsonify({"Status": "Failure", "Message": "No order found or invalid result format"}), 404

        response = {
            "data": results[0],
            "message": "success"
        }
        logger.info(f"[ORDERS] Order details retrieved successfully for order_id={order_id}")
        return jsonify(response), 200

    except mysql.connector.Error as err:
        logger.exception(f"[ORDERS] MySQL error while fetching order {order_id} by user ")
        return jsonify({"Status": "Failure", "Message": f"MySQL Error: {str(err)}"}), 500
    except Exception as e:
        logger.exception(f"[ORDERS] Server error while fetching order {order_id} by user ")
        return jsonify({"Status": "Failure", "Message": f"Server Error: {str(e)}"}), 500


# 📌 Edit Order
@orders_bp.route('/editorder', methods=['PUT'])
@jwt_required()
def edit_order():
    try:
        data = request.json
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} editing order with payload: {data}")

        procedure_name = "edit_order"
        params = (
            data['order_id'],
            data['sender_id'],
            data['receiver_id'],
            data['order_status'].capitalize(),
            user_id
        )

        result = db.insert_using_procedure(procedure_name, params)
        logger.info(f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, result={result}")

        response = {
            "message": result.get("Message", "Order Updated Successfully"),
            "status": result.get("Status", "Success")
        }
        logger.info(f"[ORDERS] Order {data['order_id']} updated successfully by user {user_id}")
        return jsonify(response), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error editing order ")
        return jsonify({"error": str(e)}), 500


# ✅ Delete an Order
@orders_bp.route('/deleteorder/<int:order_id>', methods=['DELETE'])
@jwt_required()
def delete_order(order_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} requested delete for order_id={order_id}")

        procedure_name = "delete_order"
        params = (order_id, user_id)

        result = db.insert_using_procedure(procedure_name, params)
        logger.info(f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, result={result}")

        if result:
            response = {
                "message": result.get("Message", "Order deleted successfully"),
                "status": result.get("Status", "Success")
            }
            logger.info(f"[ORDERS] Order {order_id} deleted successfully by user {user_id}")
            return jsonify(response), 200
        else:
            logger.warning(
                f"[ORDERS] No result returned from '{procedure_name}' for order_id={order_id}, user {user_id}")
            return jsonify({"message": "No result returned from procedure"}), 500

    except Exception as e:
        logger.exception(f"[ORDERS] Error deleting order ")
        return jsonify({"error": str(e)}), 500


# 📌 Get Order Commodities
@orders_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order_commodities(order_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} fetching commodities for order_id={order_id}")

        params = (order_id, user_id)
        results = db.call_procedure("get_order_commodities", params)
        logger.info(
            f"[ORDERS] Procedure 'get_order_commodities' executed with params={params}, results_count={len(results) if results else 0}")

        return jsonify({
            "status": "success",
            "commodities": results
        }), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error fetching commodities for order_id={order_id} user")
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


# 📌 Get Orders by Status
@orders_bp.route('/getOrderDetailsByStatus', methods=['POST'])
@jwt_required()
def get_order_details_by_status():
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        data = request.json
        order_status = data.get("order_status", "")
        order_id = data.get("order_id", "")
        delivery_date = data.get("delivery_date")
        page_number = int(data.get("page_number", 1))
        page_size = int(data.get("page_size", 10))

        params = (order_status, order_id, delivery_date, page_number, page_size, user_id)

        logger.info(
            f"[ORDERS] User {user_id} fetching orders by status={order_status}, order_id={order_id}, delivery_date={delivery_date}, page={page_number}, size={page_size}")

        results = db.call_procedure("getOrderDetailsByStatus", params)
        logger.info(
            f"[ORDERS] Procedure 'getOrderDetailsByStatus' executed with params={params}, results_count={len(results) if results else 0}")

        if not results or len(results) < 2:
            return jsonify({"status": "success", "totalRecords": 0, "orders": []}), 200

        total_records = results[0][0].get("totalRecords", 0)
        orders = results[1]

        return jsonify({
            "status": "success",
            "totalRecords": total_records,
            "orders": orders
        }), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error fetching orders by status for user")
        return jsonify({"status": "error", "message": str(e)}), 500


# 📌 Get Orders by Employee
@orders_bp.route('/by-employee/<int:employee_id>', methods=['GET'])
@jwt_required()
def get_orders_by_employee(employee_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} fetching orders assigned to employee_id={employee_id}")

        procedure_name = "GetOrdersByEmployeeId"
        params = (employee_id,)
        result = db.call_procedure(procedure_name, params)

        logger.info(
            f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, results_count={len(result) if result else 0}")

        return jsonify({"Status": "Success", "Orders": result}), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error fetching orders for employee_id={employee_id}")
        return jsonify({"Status": "Failure", "Message": str(e)}), 500


# 📌 Get Order Details by Stage
@orders_bp.route('/order-detailsbystage', methods=['GET'])
@jwt_required()
def get_order_details_bystage():
    try:
        order_id = request.args.get('order_id')
        stage = request.args.get('stage')
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} requested order-detailsbystage with order_id={order_id}, stage={stage}")

        if not order_id or not stage:
            logger.warning(f"[ORDERS] User {user_id} missing required params order_id or stage")
            return jsonify({"Status": "Failure", "Message": "Missing required parameters"}), 400

        try:
            order_id = int(order_id)
        except ValueError:
            logger.warning(f"[ORDERS] User {user_id} provided invalid order_id={order_id}")
            return jsonify({"Status": "Failure", "Message": "Invalid order_id"}), 400

        if stage == "billing":
            procedure_name = "GetOrderSummary"
            params = (order_id, user_id)
        else:
            procedure_name = "GetOrderDetailsbyStagewise"
            params = (order_id, stage, user_id)

        results = db.call_procedure(procedure_name, params)
        logger.info(
            f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, results_count={len(results) if results else 0}")

        if not results:
            logger.info(f"[ORDERS] No data found for order_id={order_id}, stage={stage}, user_id={user_id}")
            return jsonify({"data": None, "message": "No data found"}), 404

        result = results[0]

        if stage == "billing":
            try:
                # result['commodities'] = json.loads(result.get('commodities', '[]'))
                result['commodities'] = json.loads(result.get('commodities', '[]'))
                result['documents'] = json.loads(result.get('documents', '[]'))  # ✅ ADD THIS

            except Exception:
                result['commodities'] = []
        elif stage == "order":
            result['sender'] = json.loads(result.get('sender', '{}'))
            result['receiver'] = json.loads(result.get('receiver', '{}'))
        elif stage == "commodity":
            try:
                result['commodities'] = json.loads(result.get('commodities', '[]'))
                result['documents'] = json.loads(result.get('documents', '[]'))
            except Exception:
                result['commodities'] = []

        return jsonify({"data": result, "message": "success"}), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error fetching order-detailsbystage for user")
        return jsonify({"data": None, "message": str(e)}), 500


# 📌 Get Order Summary
@orders_bp.route('/getordersummary', methods=['POST'])
@jwt_required()
def get_order_summary():
    try:
        data = request.get_json()
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} requested order summary with data={data}")

        if not data or "order_id" not in data:
            logger.warning(f"[ORDERS] User {user_id} missing or invalid JSON data in getordersummary")
            return jsonify({"Status": "Failure",
                            "Message": "Missing or invalid JSON data. Ensure Content-Type is application/json"}), 400

        order_id = data["order_id"]
        procedure_name = "GetOrderSummary"
        params = (order_id, user_id)
        result = db.call_procedure(procedure_name, params)

        logger.info(
            f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, result_count={len(result) if result else 0}")

        return jsonify(result[0]), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error fetching getordersummary for user")
        return jsonify({"data": None, "Message": str(e)}), 500


# 📌 Get Order Delivery Details
@orders_bp.route('/getorderdeliverdetails', methods=['POST'])
@jwt_required()
def get_order_delivery_details():
    try:
        data = request.get_json()
        claims = get_jwt()
        user_id = claims.get("sub")

        logger.info(f"[ORDERS] User {user_id} requested order delivery details with data={data}")

        if not data:
            logger.warning(f"[ORDERS] User {user_id} missing JSON data in getorderdeliverdetails")
            return jsonify({
                "status": "Failure",
                "message": "Missing or invalid JSON data. Ensure Content-Type is application/json"
            }), 400

        delivery_date_str = data.get("deliveryDate", None)
        order_status = data.get("orderStatus", None)
        order_id = data.get("searchQuery", None)
        page_number = int(data.get("pageNumber", 1))
        page_size = int(data.get("pageSize", 10))

        if page_number < 1 or page_size < 1:
            logger.warning(
                f"[ORDERS] User {user_id} provided invalid pagination: page_number={page_number}, page_size={page_size}")
            return jsonify({
                "status": "Failure",
                "message": "page_number and page_size must be integers >= 1"
            }), 400

        delivery_date = None
        if delivery_date_str:
            try:
                delivery_date = datetime.strptime(delivery_date_str, "%Y-%m-%d").date()
            except ValueError:
                logger.warning(f"[ORDERS] User {user_id} provided invalid deliveryDate={delivery_date_str}")
                return jsonify({
                    "status": "Failure",
                    "message": "Invalid deliveryDate format. Expected YYYY-MM-DD."
                }), 400

        procedure_name = "getOrderDetailsByStatus"
        params = (order_status, order_id, delivery_date, page_number, page_size, user_id)

        result = db.call_procedure(procedure_name, params)
        logger.info(
            f"[ORDERS] Procedure '{procedure_name}' executed with params={params}, results_count={len(result) if result else 0}")

        if not result or len(result) < 2:
            logger.info(f"[ORDERS] No orders found for user_id={user_id}, filters={params}")
            return jsonify({
                "data": {
                    "orders": [],
                    "currentPage": page_number,
                    "pageSize": page_size,
                    "totalRecords": 0
                },
                "message": "success"
            }), 200

        total_record_item = result[0]
        if not isinstance(total_record_item, dict) or "totalRecords" not in total_record_item:
            logger.error(f"[ORDERS] Missing totalRecords in SP result for user_id={user_id}, params={params}")
            return jsonify({
                "status": "Failure",
                "message": "Missing totalRecords in stored procedure result"
            }), 500

        total_records = total_record_item["totalRecords"]
        order_rows = result[1:]

        if len(order_rows) == 1 and list(order_rows[0].keys()) == ['NULL'] and order_rows[0]['NULL'] is None:
            logger.info(f"[ORDERS] Empty order set returned for user_id={user_id}, params={params}")
            return jsonify({
                "data": {
                    "orders": [],
                    "currentPage": page_number,
                    "pageSize": page_size,
                    "totalRecords": total_records
                },
                "message": "success"
            }), 200

        return jsonify({
            "data": {
                "orders": order_rows,
                "currentPage": page_number,
                "pageSize": page_size,
                "totalRecords": total_records
            },
            "message": "success"
        }), 200

    except Exception as e:
        logger.exception(f"[ORDERS] Error fetching getorderdeliverdetails for user")
        return jsonify({
            "status": "Failure",
            "message": str(e),
            "data": None
        }), 500


# 📌 Get Deliver Order Details
@orders_bp.route('/getdeliverorderdetails', methods=['GET'])
@jwt_required()
def getdeliverorderdetails():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")

        order_id = request.args.get('orderId', type=int)
        logger.info(f"[ORDERS][getdeliverorderdetails][{employee_id}] Request with orderId={order_id}")

        if not order_id:
            logger.warning(f"[ORDERS][getdeliverorderdetails][{employee_id}] Missing or invalid 'order_id'")
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'order_id' in query parameters."}), 400

        result = db.call_procedure("GetOrderAndStores", (order_id,))
        result = result[0]['result']
        order_data = json.loads(result)

        if not result or not result[0]:
            logger.info(f"[ORDERS][getdeliverorderdetails][{employee_id}] No data found for orderId={order_id}")
            return jsonify({"data": {}, "message": "No data found"}), 200

        logger.info(
            f"[ORDERS][getdeliverorderdetails][{employee_id}] Successfully fetched deliver order details for orderId={order_id}")
        return jsonify({"data": order_data, "message": "success"}), 200

    except Exception as e:
        logger.exception(f"[ORDERS][getdeliverorderdetails] Error fetching deliver order details")
        return jsonify({"data": None, "message": str(e)}), 500


# 📌 Insert Documents
@orders_bp.route('/insertdocuments', methods=['POST'])
@jwt_required()
def insert_documents():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")

        order_id = request.form.get("orderId", type=int)
        doc_type = request.form.get("doctype", "commodities")
        files = request.files.getlist("paths")

        logger.info(
            f"[ORDERS][insert_documents][{employee_id}] Request with orderId={order_id}, doc_type={doc_type}, files_count={len(files)}")

        if not order_id or not files:
            logger.warning(f"[ORDERS][insert_documents][{employee_id}] Missing order_id or no files provided")
            return jsonify({"status": "Failure", "message": "order_id and at least one file in 'paths' are required.",
                            "documents": []}), 400

        upload_folder = current_app.config['UPLOAD_FOLDER']
        saved_file_names = []

        for file in files:
            if file.filename == '':
                continue
            original_name = secure_filename(file.filename)
            ext = os.path.splitext(original_name)[1]
            unique_filename = f"{order_id}_{doc_type}_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            saved_file_names.append(unique_filename)

        logger.info(f"[ORDERS][insert_documents][{employee_id}] Saved files: {saved_file_names}")

        images_json_array = json.dumps(saved_file_names)
        params = (order_id, images_json_array, doc_type)
        db_result = db.insertall_using_procedure("insertDocument", params)

        logger.info(f"[ORDERS][insert_documents][{employee_id}] Documents inserted successfully for orderId={order_id}")
        return jsonify({"data": db_result}), 200

    except Exception as e:
        logger.exception(f"[ORDERS][insert_documents]Error inserting documents")
        return jsonify({"message": str(e), "documents": []}), 500


# 📌 Get Document by ID
@orders_bp.route('/getdocumentbyid', methods=['GET'])
@jwt_required()
def get_document_by_id():
    try:
        doc_id = request.args.get('docId')
        logger.info(f"[ORDERS][get_document_by_id] Request with docId={doc_id}")

        if not doc_id:
            logger.warning("[ORDERS][get_document_by_id] Missing or invalid doc_id parameter")
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'doc_id' parameter."}), 400

        result = db.call_procedure("getDocumentById", (doc_id,))
        if not result:
            logger.info(f"[ORDERS][get_document_by_id] Document not found for docId={doc_id}")
            return jsonify({"Message": "Document not found."}), 202

        logger.info(f"[ORDERS][get_document_by_id] Document fetched successfully for docId={doc_id}")
        return jsonify({"data": result[0], "message": "success"}), 200

    except Exception as e:
        logger.exception(f"[ORDERS][get_document_by_id] Error fetching document for docId")
        return jsonify({"data": None, "Message": str(e)}), 500


# 📌 Get Documents by Order & Category
@orders_bp.route('/getdocumentsbyorderandcategory', methods=['GET'])
@jwt_required()
def get_documents_by_order_and_category():
    try:
        order_id = request.args.get('orderId')
        category = request.args.get('category')

        logger.info(
            f"[ORDERS][get_documents_by_order_and_category] Request with orderId={order_id}, category={category}")

        if not order_id or not category:
            logger.warning("[ORDERS][get_documents_by_order_and_category] Missing 'order_id' or 'category'")
            return jsonify({"status": "Failure", "message": "Missing 'order_id' or 'category' parameter."}), 400

        result = db.call_procedure("getDocumentsByOrderIdAndCatagory", (order_id, category))

        if not result:
            logger.info(
                f"[ORDERS][get_documents_by_order_and_category] No documents found for orderId={order_id}, category={category}")
            return jsonify({"status": "Failure", "data": result}), 200

        logger.info(
            f"[ORDERS][get_documents_by_order_and_category] Successfully fetched {len(result)} documents for orderId={order_id}, category={category}")
        return jsonify({"status": "Success", "data": result}), 200

    except Exception as e:
        logger.exception(f"[ORDERS][get_documents_by_order_and_category] Error fetching documents for order")
        return jsonify({"status": "Error", "message": str(e)}), 500


# 📌 Get Document File
@orders_bp.route('/getdocumentfile/<filename>', methods=['GET'])
def get_document_file(filename):
    try:
        logger.info(f"[ORDERS][get_document_file] Request for filename='{filename}'")

        upload_root = current_app.config['UPLOAD_FOLDER']

        # Detect file extension from request if present
        req_name, req_ext = os.path.splitext(filename)

        # CASE 1: User requests IMAGE (filename includes extension)
        if req_ext.lower() in [".png", ".jpg", ".jpeg", ".webp"]:
            logger.info("[ORDERS] Searching for image file")

            for root, dirs, files in os.walk(upload_root):
                if filename in files:
                    logger.info(f"[ORDERS] Image file '{filename}' found, sending file")
                    return send_from_directory(root, filename)

            logger.warning(f"[ORDERS] Image file '{filename}' not found")
            return jsonify({"status": "Failure", "message": f"Image '{filename}' not found."}), 404

        # CASE 2: User requests PDF (filename has NO extension)
        logger.info("[ORDERS] Searching for PDF file")

        for root, dirs, files in os.walk(upload_root):
            for file in files:
                file_name_no_ext, file_ext = os.path.splitext(file)

                if file_ext.lower() == ".pdf" and file_name_no_ext == filename:
                    logger.info(f"[ORDERS] PDF '{file}' found, sending file")
                    return send_from_directory(root, file)

        logger.warning(f"[ORDERS] PDF or file '{filename}' not found")
        return jsonify({"status": "Failure", "message": f"File '{filename}' not found."}), 404

    except Exception as e:
        logger.exception(f"[ORDERS][get_document_file] Error fetching file '{filename}'")
        return jsonify({"status": "Error", "message": str(e)}), 500

# @orders_bp.route('/getdocumentfile/<filename>', methods=['GET'])
# # @jwt_required()
# def get_image_by_filename(filename):
#     try:
#         logger.info(f"[ORDERS][get_image_by_filename] Request for filename='{filename}'")
#
#         upload_root = current_app.config['UPLOAD_FOLDER']
#         for root, dirs, files in os.walk(upload_root):
#             for file in files:
#                 file_name_no_ext, file_ext = os.path.splitext(file)
#                 if file_ext == ".pdf":
#                     if filename == file_name_no_ext:
#                         logger.info(f"[ORDERS][get_image_by_filename] File '{file}' found, sending file")
#                         return send_from_directory(root, file)
#
#         logger.warning(f"[ORDERS][get_image_by_filename] File '{filename}' not found")
#         return jsonify({"status": "Failure", "message": f"File '{filename}' not found."}), 404
#
#     except Exception as e:
#         logger.exception(f"[ORDERS][get_image_by_filename] Error fetching file '{filename}'")
#         return jsonify({"status": "Error", "message": str(e)}), 500


# 📌 Delete Document
@orders_bp.route('/deletedocument/<doc_id>', methods=['DELETE'])
@jwt_required()
def delete_document(doc_id):
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")
        logger.info(f"[ORDERS][delete_document][{employee_id}] Request to delete doc_id={doc_id}")

        if not doc_id:
            logger.warning(f"[ORDERS][delete_document][{employee_id}] Missing doc_id")
            return jsonify({"status": "Failure", "message": "Missing 'doc_id' query parameter."}), 400

        result = db.insert_using_procedure("deleteDocumentById", (doc_id,))
        logger.info(f"[ORDERS][delete_document][{employee_id}] Document deleted successfully: doc_id={doc_id}")

        return jsonify({"message": result["message"], "doc_id": result["docId"]}), 200

    except Exception as e:
        logger.exception(f" Error deleting doc_id={doc_id}")
        return jsonify({"message": str(e)}), 500


# 📌 Get Reason by ID
@orders_bp.route('/getreasonbyid', methods=['GET'])
@jwt_required()
def get_reason_by_id():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")
        reason_id = request.args.get('reasonId')
        logger.info(f"[ORDERS][get_reason_by_id][{employee_id}] Request for reasonId={reason_id}")

        if not reason_id:
            logger.warning(f"[ORDERS][get_reason_by_id][{employee_id}] Missing reasonId")
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'reason_id' parameter."}), 400

        result = db.call_procedure("getReasonById", (reason_id,))
        if not result:
            logger.info(f"[ORDERS][get_reason_by_id][{employee_id}] Reason not found for reasonId={reason_id}")
            return jsonify({"Message": "Reason not found."}), 202

        logger.info(f"[ORDERS][get_reason_by_id][{employee_id}] Reason fetched successfully for reasonId={reason_id}")
        return jsonify({"data": result[0], "message": "success"}), 200

    except Exception as e:
        logger.exception(f" Error fetching reasonId")
        return jsonify({"data": None, "Message": str(e)}), 500


# 📌 Get All Reasons
@orders_bp.route('/getallreasons', methods=['GET'])
@jwt_required()
def get_all_reasons():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")
        logger.info(f"[ORDERS][get_all_reasons][{employee_id}] Fetching all reasons")

        result = db.call_procedure("getAllReasons", ())
        if not result:
            logger.info(f"[ORDERS][get_all_reasons][{employee_id}] No reasons found")
            return jsonify({"Message": "No reasons found."}), 202

        logger.info(f"[ORDERS][get_all_reasons][{employee_id}] Successfully fetched {len(result)} reasons")
        return jsonify({"data": result, "message": "success"}), 200

    except Exception as e:
        logger.exception(f" Error fetching all reasons")
        return jsonify({"data": None, "Message": str(e)}), 500


# 📌 Update Delivery Order
@orders_bp.route('/updatedeliverorder', methods=['PUT'])
@jwt_required()
def updatedeliverorder():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")
        data = request.get_json()
        order_id = data.get("orderId")
        order_status = data.get("orderStatus")
        reason = data.get("reasonId")

        logger.info(
            f"[ORDERS][updatedeliverorder][{employee_id}] Update request for orderId={order_id}, orderStatus={order_status}, reasonId={reason}")

        if not all([order_id, order_status]):
            logger.warning(f"[ORDERS][updatedeliverorder][{employee_id}] Missing required fields")
            return jsonify({"message": "Missing required fields: order_id, order_status, reason"}), 400

        result = db.insert_using_procedure("UpdateOrderStatusAndReason", (order_id, order_status, reason))
        logger.info(f"[ORDERS][updatedeliverorder][{employee_id}] Order updated successfully: orderId={order_id}")
        return jsonify({"data": result, "message": "Order updated successfully"}), 200

    except Exception as e:
        logger.exception(f"Error updating orderId")
        return jsonify({"message": f"Internal Server Error: {str(e)}"}), 500


# 📌 Get Draft Order Details
@orders_bp.route('/getdraftorderdetails', methods=['POST'])
@jwt_required()
def get_draft_order_details():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")
        data = request.get_json()
        logger.info(f"[ORDERS][get_draft_order_details][{employee_id}] Request payload: {data}")

        if not data:
            logger.warning(f"[ORDERS][get_draft_order_details][{employee_id}] Missing or invalid JSON data")
            return jsonify({"status": "Failure", "message": "Missing or invalid JSON data."}), 400

        order_status = data.get("orderStatus", None)
        page_number = int(data.get("pageNumber", 1))
        page_size = int(data.get("pageSize", 10))

        if page_number < 1 or page_size < 1:
            logger.warning(
                f"[ORDERS][get_draft_order_details][{employee_id}] Invalid pagination values: pageNumber={page_number}, pageSize={page_size}")
            return jsonify({"status": "Failure", "message": "Invalid pagination values."}), 400

        procedure_name = "getDraftOrderDetails"
        params = (order_status, page_number, page_size, employee_id)
        result = db.call_procedure(procedure_name, params)
        logger.info(
            f"[ORDERS][get_draft_order_details][{employee_id}] Procedure '{procedure_name}' executed, result length: {len(result)}")

        if not result or len(result) < 2:
            logger.error(f"[ORDERS][get_draft_order_details][{employee_id}] Unexpected procedure output")
            return jsonify({"status": "Failure", "message": "Unexpected procedure output"}), 500

        total_record_item = result[0]
        if not isinstance(total_record_item, dict) or "totalRecords" not in total_record_item:
            logger.error(f"[ORDERS][get_draft_order_details][{employee_id}] Missing totalRecords from result")
            return jsonify({"status": "Failure", "message": "Missing totalRecords from result"}), 500

        total_records = total_record_item["totalRecords"]
        order_result = result[1]
        order_rows = order_result if isinstance(order_result, list) else (
            [order_result] if isinstance(order_result, dict) else [])

        logger.info(
            f"[ORDERS][get_draft_order_details][{employee_id}] Successfully fetched draft orders, count={len(order_rows)}")
        return jsonify({
            "data": {
                "orders": order_rows,
                "currentPage": page_number,
                "pageSize": page_size,
                "totalRecords": total_records
            },
            "message": "success"
        }), 200

    except Exception as e:
        logger.exception(f"[ORDERS][get_draft_order_details]Error fetching draft order details")
        return jsonify({"status": "Failure", "message": str(e), "data": None}), 500
