from flask import jsonify, request ,current_app ,send_from_directory
from . import orders_bp
import mysql.connector
from db_function import db
from werkzeug.utils import secure_filename
import  os
import json
from uuid import uuid4
import os

# ✅ Create a new order
@orders_bp.route('/create_order', methods=['POST'])
def create_order():
    data = request.json
    try:
        procedure_name = "create_order"
        params = (data['senderId'], data['receiverId'], data['createdBy'])
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify({
            "data": {
                "orderId": result['orderId'],
                "orderStage": result['orderStage']
            },
            "message": result['message']
        }), 201
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
        return jsonify({"data":result,"message":"All order items added successfully"}), 201
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
    try:
        order_id = request.args.get('order_id')
        stage = request.args.get('stage')

        if not order_id or not stage:
            return jsonify({"Status": "Failure", "Message": "Missing required parameters"}), 400

        try:
            order_id = int(order_id)
        except ValueError:
            return jsonify({"Status": "Failure", "Message": "Invalid order_id"}), 400

        if stage == "billing":
            procedure_name = "GetOrderSummary"
            params = (order_id,)
        else:
            procedure_name = "GetOrderDetailsbyStagewise"
            params = (order_id, stage)

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
            except Exception:
                result['commodities'] = []

        return jsonify({"data":result,"message":"success"}), 200

    except Exception as e:
        # Optionally: log the error here
        return jsonify({"data": None, "message": str(e)}), 500

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
        return jsonify({"data": None, "Message": str(e)}), 500


@orders_bp.route('/getorderdeliverdetails', methods=['POST'])
def get_order_delivery_details():
    try:
        data = request.get_json()

        if not data:
            return jsonify({
                "status": "Failure",
                "message": "Missing or invalid JSON data. Ensure Content-Type is application/json"
            }), 400

        order_status = data.get("order_status", None)
        order_id = data.get("order_id", None)
        page_number = data.get("page_number", 1)
        page_size = data.get("page_size", 10)

        if page_number < 1 or page_size < 1:
            return jsonify({
                "status": "Failure",
                "message": "page_number and page_size must be integers >= 1"
            }), 400

        procedure_name = "GetOrderDetailsByStatus"
        params = (order_status, order_id, page_number, page_size)

        result = db.call_procedure(procedure_name, params)

        if not result or len(result) < 1:
            return jsonify({
                "status": "Failure",
                "message": "No data returned from procedure"
            }), 500

        # First item is total_records dict, rest are order rows
        total_records = result[0].get("totalRecords", 0)
        orders_data = result[1:]  # Remaining entries are actual data

        return jsonify({
            "data": {"orders":orders_data ,"currentPage": page_number,"pageSize": page_size,"totalRecords": total_records,
},"message": "success"
        }), 200

    except Exception as e:
        return jsonify({
            "message": str(e),
            "data": None
        }), 500

@orders_bp.route('/getdeliverorderdetails', methods=['GET'])
def getdeliverorderdetails():
    """
    GET API to fetch detailed order and document information using 'GetOrderAndStores'.

    Query Parameter:
    - order_id (int): The ID of the order

    Response Format:
    {
        "data": {
            "senderId": ...,
            "receiverId": ...,
            "orderStatus": "...",
            "senderStoreName": "...",
            "receiverStoreName": "...",
            "documents": [ {...}, {...} ]
        },
        "message": "success"
    }
    """
    try:
        order_id = request.args.get('order_id', type=int)

        if not order_id:
            return jsonify({
                "Status": "Failure",
                "Message": "Missing or invalid 'order_id' in query parameters."
            }), 400

        # Call stored procedure
        result = db.call_procedure("GetOrderAndStores", (order_id,))

        if not result or not result[0]:
            return jsonify({
                "data": {},
                "message": "No data found"
            }), 200

        rows = result

        # Extract shared order-level details from the first row
        first_row = rows[0]
        order_data = {
            "senderId": first_row["senderId"],
            "receiverId": first_row["receiverId"],
            "orderStatus": first_row["orderStatus"],
            "senderStoreName": first_row["senderStoreName"],
            "receiverStoreName": first_row["receiverStoreName"],
            "documents": []
        }

        # Build the documents list
        for row in rows:
            paths_raw = row.get("paths")
            try:
                paths = json.loads(paths_raw) if paths_raw else []
            except Exception:
                paths = []

            order_data["documents"].append({
                "docId": row["docId"],
                "paths": paths,
                "category": row["category"]
            })

        return jsonify({
            "data": order_data,
            "message": "success"
        }), 200

    except Exception as e:
        return jsonify({
            "data": None,
            "message": str(e)
        }), 500


@orders_bp.route('/insertdocuments', methods=['POST'])
def insert_documents():
    try:
        order_id = request.form.get("orderId", type=int)
        doc_type = request.form.get("doctype", "commodities")  # e.g., "invoice"
        files = request.files.getlist("paths")

        if not order_id or not files:
            return jsonify({
                "status": "Failure",
                "message": "order_id and at least one file in 'paths' are required.",
                "documents": []
            }), 400

        upload_folder = current_app.config['UPLOAD_FOLDER']
        public_url_prefix = current_app.config.get('PUBLIC_UPLOAD_PATH', '/uploads')  # e.g., for static access

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

        # Call stored procedure
        procedure_name = "insertDocument"
        params = (order_id, images_json_array, doc_type)
        db_result = db.insertall_using_procedure(procedure_name, params)  # returns list of rows with 'documentId'

        # Build final document list
        documents = []
        for file_name, row in zip(saved_file_names, db_result):
            documents.append({
                "documentId": row['documentId'],
                "documentName": file_name,
                "documentCategory": "Order Invoice" if doc_type == "invoice" else "Commodities",
                "requestPath": f"{public_url_prefix}/{file_name}"
            })

        return jsonify({"documents": documents}), 200

    except Exception as e:
        return jsonify({
            "message": str(e),
            "documents": []
        }), 500



@orders_bp.route('/getdocumentbyid', methods=['GET'])
def get_document_by_id():
    """
    API to fetch document details by document ID using the stored procedure 'getDocumentById'.

    Request URL (Query Parameters):
    /getdocumentbyid?doc_id=14
    """
    try:
        # Get the doc_id from query string
        doc_id = request.args.get('docId')

        if not doc_id:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'doc_id' parameter in the URL query string."}), 400

        procedure_name = "getDocumentById"
        params = (doc_id,)
        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        # Check if the result is empty (document not found)
        if len(result) == 0:
            return jsonify({"Message": "Document not found."}), 202

        # If document found, return it
        return jsonify({"data":result[0],"message":"success"}), 200  # Correct status code for success

    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500  # Internal Server Error in case of unexpected exceptions



@orders_bp.route('/getdocumentsbyorderandcategory', methods=['GET'])
def get_documents_by_order_and_category():
    """
    API to fetch documents based on order_id and category using the stored procedure 'getDocumentsByOrderIdAndCatagory'.

    Example:
    /getdocumentsbyorderandcategory?orderId=1068025&category=commodities
    """
    try:
        # Extract query parameters
        order_id = request.args.get('orderId')
        category = request.args.get('category')

        if not order_id or not category:
            return jsonify({
                "status": "Failure",
                "message": "Missing 'orderId' or 'category' query parameter.",
                "documents": []
            }), 400

        # Call stored procedure
        procedure_name = "getDocumentsByOrderIdAndCatagory"
        params = (order_id, category)
        db_result = db.call_procedure(procedure_name, params)  # List of rows from DB

        if not db_result:
            return jsonify({
                "status": "Failure",
                "message": "No documents found for the given order ID and category.",
                "documents": []
            }), 404

        # Get public path from config
        public_url_prefix = current_app.config.get('PUBLIC_UPLOAD_PATH', '/uploads')

        # Format result
        documents = []
        for row in db_result:
            documents.append({
                "documentId": row.get('id') or row.get('doc_id'),
                "documentName": row.get('path'),
                "documentCategory": "Order Invoice" if category == "invoice" else "Commodities",
                "requestPath": f"{public_url_prefix}/{row.get('path')}"
            })

        return jsonify({
            "documents": documents
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Error",
            "message": str(e),
            "documents": []
        }), 500



@orders_bp.route('/getdocumentfile/<filename>', methods=['GET'])
def get_image_by_filename(filename):
    """
    Serve an image file from the UPLOAD_FOLDER or its subdirectories by filename.
    The image is displayed directly in the browser.
    """
    try:
        upload_root = current_app.config['UPLOAD_FOLDER']

        # Search for the image file in all subdirectories
        for root, dirs, files in os.walk(upload_root):
            if filename in files:
                # Return the image to be rendered in browser (not downloaded)
                return send_from_directory(root, filename)

        return jsonify({
            "status": "Failure",
            "message": f"Image '{filename}' not found."
        }), 404

    except Exception as e:
        return jsonify({
            "status": "Error",
            "message": str(e)
        }), 500

# Assuming db.call_procedure is defined for calling stored procedures
@orders_bp.route('/deletedocument', methods=['DELETE'])
def delete_document():
    """
    API to delete a document based on doc_id using the stored procedure 'deleteDocumentById'.

    Request URL (Query Parameters):
    /deletedocument?doc_id=21
    """
    try:
        # Extract query parameter
        doc_id = request.args.get('docId')

        # Validate input
        if not doc_id:
            return jsonify({
                "status": "Failure",
                "message": "Missing 'doc_id' query parameter."
            }), 400

        # Call stored procedure to delete document by doc_id
        procedure_name = "deleteDocumentById"
        params = (doc_id,)
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify({
            "message": result["message"],
            "doc_id": result["docId"]
        }), 200

    except Exception as e:
        return jsonify({
            "message": str(e)
        }), 500


@orders_bp.route('/getreasonbyid', methods=['GET'])
def get_reason_by_id():
    """
    API to fetch reason by ID using the stored procedure 'getReasonById'.

    Request URL (Query Parameters):
    /getreasonbyid?reason_id=3
    """
    try:
        # Get the reason_id from the query string
        reason_id = request.args.get('reasonId')

        if not reason_id:
            return jsonify({"Status": "Failure", "Message": "Missing or invalid 'reason_id' parameter in the URL query string."}), 400

        procedure_name = "getReasonById"
        params = (reason_id,)

        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        # Check if result is empty
        if not result:
            return jsonify({"Message": "Reason not found."}), 202

        # Return the result
        return jsonify({"data": result[0], "message": "success"}), 200

    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500


@orders_bp.route('/getallreasons', methods=['GET'])
def get_all_reasons():
    """
    API to fetch all delivery failure reasons using the stored procedure 'getAllReasons'.

    Request URL: /getallreasons
    """
    try:
        # Stored procedure name
        procedure_name = "getAllReasons"
        params = ()  # No parameters needed to fetch all reasons

        # Execute stored procedure
        result = db.call_procedure(procedure_name, params)

        # Check if result is empty
        if not result:
            return jsonify({"Message": "No reasons found."}), 202

        # Return the list of reasons
        return jsonify({"data": result, "message": "success"}), 200

    except Exception as e:
        return jsonify({"data": None, "Message": str(e)}), 500
