from flask import jsonify, request ,current_app ,send_from_directory
from . import orders_bp
import mysql.connector
from db_function import db
from werkzeug.utils import secure_filename
# from pdf_creation import generate_invoice
import  os
import json
from uuid import uuid4
import os
from datetime import datetime
from flask_jwt_extended import jwt_required, get_jwt, get_jwt_identity

@orders_bp.route('/create_order', methods=['POST'])
@jwt_required()
def create_order():
    data = request.json
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        procedure_name = "create_order"
        params = (data['senderId'], data['receiverId'], user_id)

        result = db.insert_using_procedure(procedure_name, params)
        print("Procedure result:", result)  # DEBUG

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



# ✅ Insert order items
@orders_bp.route('/insert-order-items', methods=['POST'])
@jwt_required()
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
        claims = get_jwt()
        user_id = claims.get("sub")

        procedure_name = "add_order_items"
        order_id = data["order_id"]
        items_json = json.dumps(data["items"])

        # New parameter: user_id added
        params = (order_id, items_json, user_id)

        result = db.insert_using_procedure(procedure_name, params)
        return jsonify({
            "data": result,
            "message": "All order items added successfully"
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/delete-order-commodity', methods=['POST'])
@jwt_required()
def delete_order_commodity():
    try:
        data = request.json
        claims = get_jwt()
        user_id = claims.get("sub")  # employee ID

        order_id = data["order_id"]
        commodity_id = data["commodity_id"]

        procedure_name = "delete_order_commodity"
        params = (order_id, commodity_id, user_id)  # Now includes user_id

        result = db.call_procedure(procedure_name, params)

        return jsonify({"message": result}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@orders_bp.route('/details/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order_details(order_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        procedure_name = "get_order_details"
        params = (order_id, user_id)

        results = db.call_procedure(procedure_name, params)

        if not results or not isinstance(results, list) or len(results) == 0:
            return jsonify({"Status": "Failure", "Message": "No order found or invalid result format"}), 404

        # ✅ We now expect a single row with nested fields (billing, items)
        return jsonify({
            "data": results[0],  # ✅ return the full result row
            "message": "success"
        }), 200

    except mysql.connector.Error as err:
        return jsonify({"Status": "Failure", "Message": f"MySQL Error: {str(err)}"}), 500
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": f"Server Error: {str(e)}"}), 500


@orders_bp.route('/editorder', methods=['PUT'])
@jwt_required()
def edit_order():
    try:
        data = request.json
        claims = get_jwt()
        user_id = claims.get("sub")  # From JWT token

        procedure_name = "edit_order"
        params = (
            data['order_id'],
            data['sender_id'],
            data['receiver_id'],
            data['order_status'].capitalize(),  # Ensure correct ENUM casing
            user_id
        )

        result = db.insert_using_procedure(procedure_name, params)

        return jsonify({
            "message": result.get("Message", "Order Updated Successfully"),
            "status": result.get("Status", "Success")
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ✅ Delete an Order
@orders_bp.route('/deleteorder/<int:order_id>', methods=['DELETE'])
@jwt_required()
def delete_order(order_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")

        procedure_name = "delete_order"
        params = (order_id, user_id)

        result = db.insert_using_procedure(procedure_name, params)
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
@jwt_required()  # 🔐 Enforces JWT authentication
def get_order_commodities(order_id):
    try:
        claims = get_jwt()
        user_id = claims.get("sub")  # 🧑 Extract user ID (for audit or future access control)

        # Note: user_id is not used in the SP currently
        params = (order_id,user_id,)
        results = db.call_procedure("get_order_commodities", params)

        return jsonify({
            "status": "success",
            "commodities": results
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@orders_bp.route('/getOrderDetailsByStatus', methods=['POST'])
@jwt_required()
def get_order_details_by_status():
    try:
        claims = get_jwt()
        user_id = claims.get("sub")  # JWT user ID (optional if needed later)

        data = request.json
        order_status = data.get("order_status", "")
        order_id = data.get("order_id", "")
        delivery_date = data.get("delivery_date")  # Expect YYYY-MM-DD
        page_number = int(data.get("page_number", 1))
        page_size = int(data.get("page_size", 10))

        params = (
            order_status,
            order_id,
            delivery_date,
            page_number,
            page_size,
            user_id
        )

        results = db.call_procedure("getOrderDetailsByStatus", params)

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
        return jsonify({"status": "error", "message": str(e)}), 500



@orders_bp.route('/by-employee/<int:employee_id>', methods=['GET'])
@jwt_required()
def get_orders_by_employee(employee_id):
    try:
        procedure_name = "GetOrdersByEmployeeId"
        params = (employee_id,)
        result = db.call_procedure(procedure_name, params)
        return jsonify({"Status": "Success", "Orders": result}), 200
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500


@orders_bp.route('/order-detailsbystage', methods=['GET'])
@jwt_required()
def get_order_details_bystage():
    try:
        order_id = request.args.get('order_id')
        stage = request.args.get('stage')
        claims = get_jwt()
        user_id = claims.get("sub")  # JWT user ID (optional if needed later)

        if not order_id or not stage:
            return jsonify({"Status": "Failure", "Message": "Missing required parameters"}), 400

        try:
            order_id = int(order_id)
        except ValueError:
            return jsonify({"Status": "Failure", "Message": "Invalid order_id"}), 400

        if stage == "billing":
            procedure_name = "GetOrderSummary"
            params = (order_id,user_id,)
        else:
            procedure_name = "GetOrderDetailsbyStagewise"
            params = (order_id, stage,user_id)

        results = db.call_procedure(procedure_name, params)

        if not results:
            return jsonify({"data": None, "message": "No data found"}), 404

        result = results[0]

        if stage == "billing":
            try:
                result['commodities'] = json.loads(result.get('commodities', '[]'))
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
        return jsonify({"data": None, "message": str(e)}), 500


@orders_bp.route('/getordersummary', methods=['POST'])
@jwt_required()
def get_order_summary():
    try:
        data = request.get_json()
        claims = get_jwt()
        user_id = claims.get("sub")  # JWT user ID (optional if needed later)

        if not data or "order_id" not in data:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid JSON data. Ensure Content-Type is application/json"}), 400

        order_id = data["order_id"]
        procedure_name = "GetOrderSummary"
        params = (order_id,user_id,)
        result = db.call_procedure(procedure_name, params)

        return jsonify(result[0]), 200
    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500


@orders_bp.route('/getorderdeliverdetails', methods=['POST'])
@jwt_required()
def get_order_delivery_details():
    try:
        data = request.get_json()
        claims = get_jwt()
        user_id = claims.get("sub")  # JWT user ID (optional if needed later)

        if not data:
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
            return jsonify({
                "status": "Failure",
                "message": "page_number and page_size must be integers >= 1"
            }), 400

        delivery_date = None
        if delivery_date_str:
            try:
                delivery_date = datetime.strptime(delivery_date_str, "%Y-%m-%d").date()
            except ValueError:
                return jsonify({
                    "status": "Failure",
                    "message": "Invalid deliveryDate format. Expected YYYY-MM-DD."
                }), 400

        procedure_name = "getOrderDetailsByStatus"
        params = (order_status, order_id, delivery_date, page_number, page_size,user_id)

        result = db.call_procedure(procedure_name, params)

        if not result or len(result) < 2:
            return jsonify({
                "status": "Failure",
                "message": "Procedure did not return expected format"
            }), 500

        total_record_item = result[0]
        if not isinstance(total_record_item, dict) or "totalRecords" not in total_record_item:
            return jsonify({
                "status": "Failure",
                "message": "Missing totalRecords in stored procedure result"
            }), 500

        total_records = total_record_item["totalRecords"]
        order_rows = result[1:]

        if len(order_rows) == 1 and list(order_rows[0].keys()) == ['NULL'] and order_rows[0]['NULL'] is None:
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
        return jsonify({
            "status": "Failure",
            "message": str(e),
            "data": None
        }), 500




@orders_bp.route('/getdeliverorderdetails', methods=['GET'])
@jwt_required()
def getdeliverorderdetails():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")

        order_id = request.args.get('orderId', type=int)
        if not order_id:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'order_id' in query parameters."}), 400

        result = db.call_procedure("GetOrderAndStores", (order_id,employee_id))
        result = result[0]['result']
        order_data = json.loads(result)

        if not result or not result[0]:
            return jsonify({"data": {}, "message": "No data found"}), 200

        return jsonify({"data": order_data, "message": "success"}), 200

    except Exception as e:
        return jsonify({"data": None, "message": str(e)}), 500


@orders_bp.route('/insertdocuments', methods=['POST'])
@jwt_required()
def insert_documents():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")

        order_id = request.form.get("orderId", type=int)
        doc_type = request.form.get("doctype", "commodities")
        files = request.files.getlist("paths")

        if not order_id or not files:
            return jsonify({"status": "Failure", "message": "order_id and at least one file in 'paths' are required.", "documents": []}), 400

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

        images_json_array = json.dumps(saved_file_names)
        params = (order_id, images_json_array, doc_type)
        db_result = db.insertall_using_procedure("insertDocument", params)

        return jsonify({"data": db_result}), 200

    except Exception as e:
        return jsonify({"message": str(e), "documents": []}), 500


@orders_bp.route('/getdocumentbyid', methods=['GET'])
@jwt_required()
def get_document_by_id():
    try:
        doc_id = request.args.get('docId')
        if not doc_id:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'doc_id' parameter."}), 400

        result = db.call_procedure("getDocumentById", (doc_id,))
        if not result:
            return jsonify({"Message": "Document not found."}), 202

        return jsonify({"data": result[0], "message": "success"}), 200

    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500


@orders_bp.route('/getdocumentsbyorderandcategory', methods=['GET'])
@jwt_required()
def get_documents_by_order_and_category():
    try:
        order_id = request.args.get('orderId')
        category = request.args.get('category')

        if not order_id or not category:
            return jsonify({"status": "Failure", "message": "Missing 'order_id' or 'category' parameter."}), 400

        result = db.call_procedure("getDocumentsByOrderIdAndCatagory", (order_id, category))

        if not result:
            return jsonify({"status": "Failure", "data": result}), 200

        return jsonify({"status": "Success", "data": result}), 200

    except Exception as e:
        return jsonify({"status": "Error", "message": str(e)}), 500


@orders_bp.route('/getdocumentfile/<filename>', methods=['GET'])
@jwt_required()
def get_image_by_filename(filename):
    try:
        upload_root = current_app.config['UPLOAD_FOLDER']

        for root, dirs, files in os.walk(upload_root):
            if filename in files:
                return send_from_directory(root, filename)

        return jsonify({"status": "Failure", "message": f"Image '{filename}' not found."}), 404

    except Exception as e:
        return jsonify({"status": "Error", "message": str(e)}), 500


@orders_bp.route('/deletedocument', methods=['DELETE'])
@jwt_required()
def delete_document():
    try:
        doc_id = request.args.get('docId')
        if not doc_id:
            return jsonify({"status": "Failure", "message": "Missing 'doc_id' query parameter."}), 400

        result = db.insert_using_procedure("deleteDocumentById", (doc_id,))

        return jsonify({"message": result["message"], "doc_id": result["docId"]}), 200

    except Exception as e:
        return jsonify({"message": str(e)}), 500


@orders_bp.route('/getreasonbyid', methods=['GET'])
@jwt_required()
def get_reason_by_id():
    try:
        reason_id = request.args.get('reasonId')
        if not reason_id:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'reason_id' parameter."}), 400

        result = db.call_procedure("getReasonById", (reason_id,))
        if not result:
            return jsonify({"Message": "Reason not found."}), 202

        return jsonify({"data": result[0], "message": "success"}), 200

    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500


@orders_bp.route('/getallreasons', methods=['GET'])
@jwt_required()
def get_all_reasons():
    try:
        result = db.call_procedure("getAllReasons", ())
        if not result:
            return jsonify({"Message": "No reasons found."}), 202

        return jsonify({"data": result, "message": "success"}), 200

    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500


@orders_bp.route('/updatedeliverorder', methods=['PUT'])
@jwt_required()
def updatedeliverorder():
    try:
        data = request.get_json()
        order_id = data.get("orderId")
        order_status = data.get("orderStatus")
        reason = data.get("reasonId")

        if not all([order_id, order_status]):
            return jsonify({"message": "Missing required fields: order_id, order_status, reason"}), 400

        result = db.insert_using_procedure("UpdateOrderStatusAndReason", (order_id, order_status, reason))

        return jsonify({"data": result, "message": "Order updated successfully"}), 200

    except Exception as e:
        return jsonify({"message": f"Internal Server Error: {str(e)}"}), 500


@orders_bp.route('/getdraftorderdetails', methods=['POST'])
@jwt_required()
def get_draft_order_details():
    try:
        claims = get_jwt()
        employee_id = claims.get("sub")

        data = request.get_json()
        if not data:
            return jsonify({"status": "Failure", "message": "Missing or invalid JSON data."}), 400

        order_status = data.get("orderStatus", None)
        order_id = data.get("searchQuery", None)
        page_number = int(data.get("pageNumber", 1))
        page_size = int(data.get("pageSize", 10))

        if page_number < 1 or page_size < 1:
            return jsonify({"status": "Failure", "message": "Invalid pagination values."}), 400

        procedure_name = "getDraftOrderDetails"
        params = (order_status, order_id, page_number, page_size, employee_id)
        result = db.call_procedure(procedure_name, params)

        if not result or len(result) < 2:
            return jsonify({"status": "Failure", "message": "Unexpected procedure output"}), 500

        total_record_item = result[0]
        if not isinstance(total_record_item, dict) or "totalRecords" not in total_record_item:
            return jsonify({"status": "Failure", "message": "Missing totalRecords from result"}), 500

        total_records = total_record_item["totalRecords"]
        order_rows = [] if isinstance(result[1], list) and len(result[1]) == 1 and result[1][0].get("NULL") is None \
            else result[1] if isinstance(result[1], list) \
            else [result[1]] if isinstance(result[1], dict) and "orderId" in result[1] \
            else []

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
        return jsonify({"status": "Failure", "message": str(e), "data": None}), 500
