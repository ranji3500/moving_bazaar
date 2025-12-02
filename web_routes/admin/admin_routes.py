from flask_jwt_extended import get_jwt_identity
from flask import jsonify, request ,current_app ,send_from_directory

import os
from logger_config import setup_logger
from flask_jwt_extended import jwt_required, get_jwt
import json
from datetime import datetime
from werkzeug.utils import secure_filename
from uuid import uuid4

from logger_config import trace, app_logger

log_file = os.path.join(os.getcwd(), 'logs', 'employee.log')
logger = setup_logger('admin', log_file)


# Define column names for proper key mapping
USER_COLUMNS = [
    "employeeid", "employee_full_name", "employee_email",
    "employee_phone_number", "employee_profile_photo",
    "employee_is_admin", "created_at"
]

# Helper function to format tuples into dictionaries
def format_user_data(results):
    formatted_data = []
    for row in results:
        formatted_data.append(dict(zip(USER_COLUMNS, row)))
    return formatted_data



from flask import jsonify, request
from . import admin_bp
from supports.db_function import db
from flask_jwt_extended import create_access_token
from datetime import timedelta
from logger_config import setup_logger
import os


# Logger setup
log_file = os.path.join(os.getcwd(), 'logs', 'admin_login.log')
logger = setup_logger('admin_login', log_file)
upload_folder = os.path.join(os.getcwd(), 'documents')  # or any specific path
# 📌 Create Employee
@admin_bp.route('/create_employee', methods=['POST'])
@jwt_required()
def create_employee():
    claims = get_jwt()
    user_id = claims.get('userId')
    user_name = claims.get('userName')
    email = claims.get('email')

    try:
        logger.info(f"[ADMIN][create_employee][{user_id}] Request to create new employee")

        # Get form fields
        full_name = request.form.get('fullName')
        emp_email = request.form.get('email')
        phone_number = request.form.get('phoneNumber')
        password = request.form.get('password')
        is_admin = request.form.get('isAdmin', 'false').lower() == 'true'
        user_type = request.form.get('user_type').lower()

        logger.info(f"[ADMIN][create_employee][{user_id}] Data received: fullName={full_name}, email={emp_email}, user_type={user_type}, is_admin={is_admin}")

        # Handle single profile photo
        file = request.files.get('profile_photo')
        profile_photo_filename = None

        if file and file.filename != '':
            original_name = secure_filename(file.filename)
            ext = os.path.splitext(original_name)[1]
            unique_filename = f"{user_id}_profile_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            profile_photo_filename = unique_filename
            logger.info(f"[ADMIN][create_employee][{user_id}] Profile photo saved as {unique_filename}")

        procedure_name = "InsertEmployee"
        params = (
            full_name,
            emp_email,
            phone_number,
            password,
            profile_photo_filename,
            1,
            user_type
        )

        rows_affected = db.insert_using_procedure(procedure_name, params)
        logger.info(f"[ADMIN][create_employee][{user_id}] Employee creation procedure executed, rows_affected={rows_affected}")

        return jsonify({"message": rows_affected, "rows_affected": rows_affected}), 201

    except Exception as e:
        logger.exception(f"[ADMIN][create_employee][{user_id}] Error creating employee")
        return jsonify({"error": str(e)}), 500


# 📌 Admin Login
@admin_bp.route('/login', methods=['POST'])
def admin_login():
    try:
        data = request.json
        username = data.get("username")
        password = data.get("password")

        logger.info(f"[ADMIN][admin_login] Login attempt for username={username}")

        if not username or not password:
            logger.warning(f"[ADMIN][admin_login] Missing username or password")
            return jsonify({"message": "Username and password are required"}), 400

        procedure_name = "AdminLogin"
        params = (username, password)
        result = db.call_procedure(procedure_name, params)
        logger.info(f"[ADMIN][admin_login] Procedure '{procedure_name}' executed for username={username}")

        if not result or len(result) == 0:
            logger.warning(f"[ADMIN][admin_login] Invalid login credentials for username={username}")
            return jsonify({"data": None, "message": "Invalid login credentials"}), 401

        response_dict = result[0]
        result_status = response_dict.get("result_status", 1)

        if result_status == 1:
            admin_id = str(response_dict.get("admin_id", "0"))
            user_name = response_dict.get("username", username)
            user_type = response_dict.get("user_type", "ADMIN")

            access_token = create_access_token(
                identity=admin_id,
                additional_claims={
                    "adminId": admin_id,
                    "userName": user_name,
                    "user_type": user_type
                },
                expires_delta=timedelta(hours=2)
            )

            logger.info(f"[ADMIN][admin_login] Login successful for admin_id={admin_id}")
            return jsonify({
                "message": "Login successful",
                "data": {
                    "adminId": admin_id,
                    "userName": user_name,
                    "userType": user_type,
                    "accessToken": access_token
                }
            }), 200

        else:
            logger.warning(f"[ADMIN][admin_login] Login failed for username={username}: {response_dict.get('message', 'Login failed')}")
            return jsonify({"data": None, "message": response_dict.get("message", "Login failed")}), 401

    except Exception as e:
        logger.exception(f"[ADMIN][admin_login] Error during login for username")
        return jsonify({"error": str(e)}), 500

# 📌 Protected route
@admin_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    try:
        admin_id = get_jwt_identity()  # Get admin ID from token
        logger.info(f"[ADMIN][protected] Protected route accessed by admin ID: {admin_id}")

        return jsonify({
            "message": "Access granted",
            "admin_id": admin_id
        }), 200

    except Exception as e:
        logger.exception("[ADMIN][protected] Error accessing protected route")
        return jsonify({"error": str(e)}), 500


# 📌 Get all users
@admin_bp.route('/get_users', methods=['GET'])
@jwt_required()
def get_users():
    logger.info("[ADMIN][get_users] Admin requested all users")
    try:
        procedure_name = "GetUsers"
        users = db.call_procedure(procedure_name)

        if users and len(users[0]) > 0:
            logger.info(f"[ADMIN][get_users] Users retrieved successfully. Count: {len(users[0])}")
            return jsonify(users), 200
        else:
            logger.warning("[ADMIN][get_users] No users found in database")
            return jsonify({"message": "No users found"}), 404

    except Exception as e:
        logger.exception("[ADMIN][get_users] Error fetching users")
        return jsonify({"error": str(e)}), 500


# 📌 Get a single user by ID
@admin_bp.route('/get_user/<int:emp_id>', methods=['GET'])
@jwt_required()
def get_user(emp_id):
    logger.info(f"[ADMIN][get_user] Fetching user with ID: {emp_id}")
    try:
        procedure_name = "GetUserById"
        params = (emp_id,)
        user = db.call_procedure(procedure_name, params)

        if user and len(user[0]) > 0:
            logger.info(f"[ADMIN][get_user] User with ID {emp_id} retrieved successfully")
            return jsonify(user), 200
        else:
            logger.warning(f"[ADMIN][get_user] User with ID {emp_id} not found")
            return jsonify({"message": "User not found"}), 404

    except Exception as e:
        logger.exception(f"[ADMIN][get_user] Error fetching user with ID {emp_id}")
        return jsonify({"error": str(e)}), 500


# 📌 Dashboard Overview
@admin_bp.route('/overview', methods=['GET'])
@jwt_required()
def get_dashboard_overview():
    try:
        filter_type = request.args.get('filter', default='today')  # 'today', 'week', 'month', or 'custom'
        start_date = None
        end_date = None

        logger.info(f"[ADMIN][overview] Dashboard overview requested with filter: {filter_type}")

        if filter_type == 'custom':
            start_date = request.args.get('start_date')  # 'YYYY-MM-DD'
            end_date = request.args.get('end_date')      # 'YYYY-MM-DD'

            if not start_date or not end_date:
                logger.warning("[ADMIN][overview] Custom filter missing start_date or end_date")
                return jsonify({"error": "Both start_date and end_date are required for custom filter"}), 400

            try:
                start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
                end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
            except ValueError as e:
                logger.warning(f"[ADMIN][overview] Invalid date format: {e}")
                return jsonify({"error": "Invalid date format. Please use 'YYYY-MM-DD'."}), 400

        results = db.call_procedure("GetDashboardOverview", (filter_type, start_date, end_date))
        logger.info(f"[ADMIN][overview] Procedure executed with filter={filter_type}, start_date={start_date}, end_date={end_date}")

        if results and len(results) > 0:
            dashboard_summary = json.loads(results[0]['dashboard_summary'])
            logger.info("[ADMIN][overview] Dashboard data retrieved successfully")
            return jsonify({
                "metrics": dashboard_summary.get("metrics"),
                "users": dashboard_summary.get("users"),
                "customers": dashboard_summary.get("customers"),
                "message": dashboard_summary.get("message", "success")
            }), 200

        logger.warning("[ADMIN][overview] No dashboard data found")
        return jsonify({"message": "No data found"}), 404

    except Exception as e:
        logger.exception("[ADMIN][overview] Error fetching dashboard overview")
        return jsonify({"error": str(e)}), 500

# 📌 Get Order Overview
@admin_bp.route('/getorderoverview', methods=['GET'])
@jwt_required()
def getorderoverview():
    try:
        logger.info("[ADMIN][getorderoverview] Request received with params: %s", request.args.to_dict())

        # Query Params
        delivery_date_str = request.args.get("deliveryDate", None)
        order_status = request.args.get("orderStatus", None)
        order_id = request.args.get("searchQuery", None)
        page_number = int(request.args.get("pageNumber", 1))
        page_size = int(request.args.get("pageSize", 10))
        user_id = request.args.get("userId", None)

        if page_number < 1 or page_size < 1:
            logger.warning("[ADMIN][getorderoverview] Invalid pagination values: page_number=%d, page_size=%d", page_number, page_size)
            return jsonify({"status": "Failure", "message": "Invalid pagination values"}), 400

        delivery_date = None
        if delivery_date_str:
            try:
                delivery_date = datetime.strptime(delivery_date_str, "%Y-%m-%d").date()
            except ValueError:
                logger.warning("[ADMIN][getorderoverview] Invalid deliveryDate format: %s", delivery_date_str)
                return jsonify({"status": "Failure", "message": "Invalid deliveryDate format. Use YYYY-MM-DD"}), 400

        procedure_name = "getOrderDetailsByStatus"
        params = (order_status, order_id, delivery_date, page_number, page_size, user_id)
        logger.info("[ADMIN][getorderoverview] Calling procedure %s with params: %s", procedure_name, params)
        result = db.call_procedure(procedure_name, params)

        if not result or len(result) < 2:
            logger.error("[ADMIN][getorderoverview] Procedure result format is invalid: %s", result)
            return jsonify({"status": "Failure", "message": "Procedure result format is invalid"}), 500

        total_record_item = result[0]
        if not isinstance(total_record_item, dict) or "totalRecords" not in total_record_item:
            logger.error("[ADMIN][getorderoverview] Missing totalRecords in procedure result: %s", total_record_item)
            return jsonify({"status": "Failure", "message": "Missing totalRecords"}), 500

        total_records = total_record_item["totalRecords"]
        order_rows = result[1:]
        if len(order_rows) == 1 and list(order_rows[0].keys()) == ["orderId"] and order_rows[0]["orderId"] is None:
            order_rows = []

        logger.info("[ADMIN][getorderoverview] Returning %d orders (totalRecords=%d)", len(order_rows), total_records)
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
        logger.exception("[ADMIN][getorderoverview] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e), "data": None}), 500


# 📌 Get Commodities
@admin_bp.route('/get_commodities', methods=['GET'])
@jwt_required()
def get_commodities():
    logger.info("[ADMIN][get_commodities] Request received")
    try:
        procedure_name = "getCommodities"
        logger.info("[ADMIN][get_commodities] Calling procedure: %s", procedure_name)
        commodities = db.call_procedure(procedure_name)

        if commodities and len(commodities[0]) > 0:
            logger.info("[ADMIN][get_commodities] Commodities retrieved successfully. Count: %d", len(commodities[0]))
            return jsonify({"data": commodities, "message": "Commodities retrieved successfully"}), 200
        else:
            logger.warning("[ADMIN][get_commodities] No commodities found in database")
            return jsonify({"message": "No commodities found"}), 404

    except Exception as e:
        logger.exception("[ADMIN][get_commodities] Error fetching commodities")
        return jsonify({"error": str(e)}), 500


# 📌 Insert Commodity
@admin_bp.route('/insert_commodity', methods=['POST'])
@jwt_required()
def insert_commodity():
    try:
        logger.info("[ADMIN][insert_commodity] Insert commodity request received")
        # Extract form data
        item_name = request.form.get("itemName")
        description = request.form.get("description")
        min_order_qty = request.form.get("minOrderQty")
        max_order_qty = request.form.get("maxOrderQty")
        price = request.form.get("price")
        file = request.files.get("itemPhoto")
        item_photo_filename = None

        if file and file.filename:
            ext = os.path.splitext(file.filename)[1]
            unique_filename = f"commodity_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            item_photo_filename = unique_filename
            logger.info("[ADMIN][insert_commodity] Image saved as %s", unique_filename)
        else:
            logger.warning("[ADMIN][insert_commodity] Missing image file (itemPhoto)")
            return jsonify({"status": "Failure", "message": "Image (itemPhoto) is required"}), 400

        if not all([item_name, description, min_order_qty, max_order_qty, price]):
            logger.warning("[ADMIN][insert_commodity] Missing required fields")
            return jsonify({"status": "Failure", "message": "All fields are required"}), 400

        procedure_name = "insert_commodity"
        params = (item_name, item_photo_filename, description, int(min_order_qty), int(max_order_qty), float(price))
        logger.info("[ADMIN][insert_commodity] Calling procedure %s with params: %s", procedure_name, params)
        result = db.insertall_using_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or not result[0]:
            logger.error("[ADMIN][insert_commodity] No response from stored procedure")
            return jsonify({"status": "Failure", "message": "No response from stored procedure"}), 500

        message = result[0].get("message") or result[0].get("error_message", "Unknown error")
        status = "Success" if "inserted" in message.lower() else "Failure"
        logger.info("[ADMIN][insert_commodity] Procedure result: %s, status: %s", message, status)

        return jsonify({"status": status, "message": message}), 200

    except Exception as e:
        logger.exception("[ADMIN][insert_commodity] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500

# 📌 Update Commodity
@admin_bp.route('/update_commodity', methods=['POST'])  # PUT also acceptable
@jwt_required()
def update_commodity():
    try:
        logger.info("[ADMIN][update_commodity] Request received")

        # Extract form data
        commodity_id = request.form.get("commodityId")
        item_name = request.form.get("itemName")
        description = request.form.get("description")
        min_order_qty = request.form.get("minOrderQty")
        max_order_qty = request.form.get("maxOrderQty")
        price = request.form.get("price")
        file = request.files.get("itemPhoto")
        item_photo_filename = None

        if file and file.filename:
            ext = os.path.splitext(file.filename)[1]
            unique_filename = f"commodity_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            item_photo_filename = unique_filename
            logger.info("[ADMIN][update_commodity] Image saved: %s", unique_filename)

        procedure_name = "edit_commodity"
        params = (int(commodity_id), item_name, item_photo_filename, description,
                  int(min_order_qty), int(max_order_qty), float(price))
        logger.info("[ADMIN][update_commodity] Calling procedure %s with params: %s", procedure_name, params)

        result = db.insertall_using_procedure(procedure_name, params)
        if not result or not isinstance(result, list) or not result[0]:
            logger.error("[ADMIN][update_commodity] No response from stored procedure")
            return jsonify({"status": "Failure", "message": "No response from stored procedure"}), 500

        response_data = result[0]
        logger.info("[ADMIN][update_commodity] Procedure result: %s", response_data)
        return jsonify({
            "status": response_data.get("Status", "Success"),
            "message": response_data.get("Message", "Commodity updated successfully"),
        }), 200

    except Exception as e:
        logger.exception("[ADMIN][update_commodity] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Delete Commodity
@admin_bp.route('/delete_commodity/<int:commodity_id>', methods=['DELETE'])
@jwt_required()
def delete_commodity(commodity_id):
    try:
        logger.info("[ADMIN][delete_commodity] Request received for commodity_id: %d", commodity_id)

        if not commodity_id:
            logger.warning("[ADMIN][delete_commodity] Missing commodity_id")
            return jsonify({"status": "Failure", "message": "commodityId is required"}), 400

        procedure_name = "deleteCommodity"
        params = (commodity_id,)
        logger.info("[ADMIN][delete_commodity] Calling procedure %s with params: %s", procedure_name, params)

        result = db.insertall_using_procedure(procedure_name, params)
        if not result or not isinstance(result, list) or not result[0]:
            logger.error("[ADMIN][delete_commodity] No response from stored procedure")
            return jsonify({"status": "Failure", "message": "No response from stored procedure"}), 500

        response_data = result[0]
        message = response_data.get("message") or response_data.get("errorMessage", "")
        logger.info("[ADMIN][delete_commodity] Procedure result: %s", message)

        if message.startswith("sqlError"):
            logger.error("[ADMIN][delete_commodity] SQL error: %s", message)
            return jsonify({"status": "Failure", "message": message}), 500

        return jsonify({"status": "Success" if "Deleted" in message else "Failure", "message": message}), 200

    except Exception as e:
        logger.exception("[ADMIN][delete_commodity] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Search Commodity
@admin_bp.route('/search_commodity', methods=['GET'])
@jwt_required()
def search_commodity():
    try:
        search_term = request.args.get("query")
        logger.info("[ADMIN][search_commodity] Search request received for query: %s", search_term)

        if not search_term:
            logger.warning("[ADMIN][search_commodity] Missing query parameter")
            return jsonify({"status": "Failure", "message": "Missing 'query' parameter in URL"}), 400

        procedure_name = "searchCommoditySimilar"
        params = (search_term,)
        logger.info("[ADMIN][search_commodity] Calling procedure %s with params: %s", procedure_name, params)

        result = db.insertall_using_procedure(procedure_name, params)
        if not result:
            logger.info("[ADMIN][search_commodity] No commodities matched for query: %s", search_term)
            return jsonify({"status": "Success", "message": "No commodities found", "data": []}), 200

        logger.info("[ADMIN][search_commodity] %d commodities matched for query: %s", len(result), search_term)
        return jsonify({"status": "Success", "message": f"{len(result)} commodities matched", "data": result}), 200

    except Exception as e:
        logger.exception("[ADMIN][search_commodity] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Insert Employee
@admin_bp.route('/insert_employee', methods=['POST'])
@jwt_required()
def insert_employee():
    try:
        data = request.get_json()
        logger.info("[ADMIN][insert_employee] Request received: %s", data)

        if not data:
            logger.warning("[ADMIN][insert_employee] Missing JSON data")
            return jsonify({"status": "Failure", "message": "Missing or invalid JSON data. Ensure Content-Type is application/json"}), 400

        full_name = data.get("fullName")
        email = data.get("email")
        phone_number = data.get("phoneNumber")
        password = data.get("password")
        profile_photo = data.get("profilePhoto") or None
        is_admin = data.get("isAdmin", 0)

        if not all([full_name, email, phone_number, password]):
            logger.warning("[ADMIN][insert_employee] Missing required fields")
            return jsonify({"status": "Failure", "message": "Full name, email, phone number, and password are required"}), 400

        procedure_name = "InsertEmployee"
        params = (full_name, email, phone_number, password, profile_photo, int(is_admin))
        logger.info("[ADMIN][insert_employee] Calling procedure %s with params: %s", procedure_name, params)

        result = db.insertall_using_procedure(procedure_name, params)
        if not result or not isinstance(result, list) or not result[0]:
            logger.error("[ADMIN][insert_employee] No response from stored procedure")
            return jsonify({"status": "Failure", "message": "No response from stored procedure"}), 500

        message = result[0].get("message", "Unknown result")
        logger.info("[ADMIN][insert_employee] Procedure result: %s", message)

        return jsonify({"status": "Success" if "successfully" in message.lower() else "Failure", "message": message}), 200

    except Exception as e:
        logger.exception("[ADMIN][insert_employee] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500

# 📌 Insert Customer
@admin_bp.route('/insert_customer', methods=['POST'])
@jwt_required()
def insert_customer():
    try:
        logger.info("[ADMIN][insert_customer] Request received")
        data = request.get_json()
        logger.info("[ADMIN][insert_customer] Payload: %s", data)

        if not data:
            logger.warning("[ADMIN][insert_customer] Missing JSON data")
            return jsonify({
                "status": "Failure",
                "message": "Missing or invalid JSON data. Ensure Content-Type is application/json"
            }), 400

        # Extract fields
        store_name = data.get("storeName")
        email = data.get("email")
        phone_number = data.get("phoneNumber")
        whatsapp_number = data.get("whatsappNumber")
        address_line1 = data.get("addressLine1")
        address_line2 = data.get("addressLine2")
        city = data.get("city")
        outstanding_price = data.get("outstanding", 0.00)

        # Validate required fields
        if not all([store_name, email, phone_number, whatsapp_number, address_line1, city]):
            logger.warning("[ADMIN][insert_customer] Missing required fields")
            return jsonify({
                "status": "Failure",
                "message": "Missing required fields. Please provide storeName, email, phoneNumber, whatsappNumber, addressLine1, and city"
            }), 400

        # Prepare stored procedure call
        procedure_name = "insert_customer_admin"
        params = (store_name, email, phone_number, whatsapp_number, address_line1, address_line2, city, float(outstanding_price))
        logger.info("[ADMIN][insert_customer] Calling procedure %s with params: %s", procedure_name, params)

        result = db.insertall_using_procedure(procedure_name, params)
        if not result or not isinstance(result, list) or not result[0]:
            logger.error("[ADMIN][insert_customer] No response from stored procedure")
            return jsonify({"status": "Failure", "message": "No response from stored procedure"}), 500

        response = result[0]
        logger.info("[ADMIN][insert_customer] Procedure result: %s", response)

        return jsonify({
            "status": "Success" if "inserted successfully" in response.get("message", "").lower() else "Failure",
            "message": response.get("message"),
            "customerId": response.get("customerId")
        }), 200

    except Exception as e:
        logger.exception("[ADMIN][insert_customer] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Edit Customer
@admin_bp.route('/edit_customer', methods=['PUT'])
@jwt_required()
def edit_customer():
    try:
        logger.info("[ADMIN][edit_customer] Request received")
        data = request.get_json()
        logger.info("[ADMIN][edit_customer] Payload: %s", data)

        required_fields = ["customerId", "storeName", "email", "phoneNumber", "whatsappNumber", "addressLine1", "city", "outstanding"]
        if not all(data.get(field) for field in required_fields):
            logger.warning("[ADMIN][edit_customer] Missing required fields")
            return jsonify({"status": "Failure", "message": "Missing required fields"}), 400

        params = (
            int(data["customerId"]),
            data["storeName"],
            data["email"],
            data["phoneNumber"],
            data["whatsappNumber"],
            data["addressLine1"],
            data.get("addressLine2", ""),
            data["city"],
            float(data["outstanding"])
        )
        logger.info("[ADMIN][edit_customer] Calling procedure edit_customer with params: %s", params)

        result = db.insertall_using_procedure("edit_customer", params)
        message = result[0].get("message", "Unknown result") if result else "No response"
        logger.info("[ADMIN][edit_customer] Procedure result: %s", message)

        return jsonify({
            "status": "Success" if "updated" in message.lower() else "Failure",
            "message": message
        }), 200

    except Exception as e:
        logger.exception("[ADMIN][edit_customer] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Delete Customer
@admin_bp.route('/delete_customer/<int:customer_id>', methods=['DELETE'])
@jwt_required()
def delete_customer(customer_id):
    try:
        logger.info("[ADMIN][delete_customer] Request received for customer_id: %d", customer_id)
        params = (customer_id,)
        logger.info("[ADMIN][delete_customer] Calling procedure delete_customer with params: %s", params)

        result = db.insertall_using_procedure("delete_customer", params)
        message = result[0].get("message", "Unknown result") if result else "No response"
        logger.info("[ADMIN][delete_customer] Procedure result: %s", message)

        return jsonify({
            "status": "Success" if "deleted" in message.lower() else "Failure",
            "message": message
        }), 200

    except Exception as e:
        logger.exception("[ADMIN][delete_customer] Exception occurred")
        return jsonify({"status": "Failure", "message": str(e)}), 500
# 📌 Billing Overview
@admin_bp.route('/billing_overview', methods=['GET'])
@jwt_required()
def get_billing_overview():
    admin_id = get_jwt_identity()
    try:
        status_filter = request.args.get('status', 'All')
        logger.info("[ADMIN:%s][billing_overview] Request received with status_filter=%s", admin_id, status_filter)

        # Validate input
        if status_filter not in ['All', 'Pending', 'Paid']:
            logger.warning("[ADMIN:%s][billing_overview] Invalid status filter: %s", admin_id, status_filter)
            return jsonify({
                "status": "Failure",
                "message": "Invalid status filter. Use 'All', 'Pending', or 'Paid'."
            }), 400

        result = db.call_procedure('get_billing_overview', (status_filter,))
        logger.info("[ADMIN:%s][billing_overview] Procedure result count: %d", admin_id, len(result) if result else 0)

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
        logger.exception("[ADMIN:%s][billing_overview] Exception occurred", admin_id)
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Get Documents by Order
@admin_bp.route('/documents/<int:order_id>', methods=['GET'])
@jwt_required()
def get_documents_by_order(order_id):
    admin_id = get_jwt_identity()
    try:
        logger.info("[ADMIN:%s][get_documents_by_order] Request received for order_id=%d", admin_id, order_id)

        results = db.call_procedure('get_document_paths_by_order_id', (order_id,))
        logger.info("[ADMIN:%s][get_documents_by_order] Procedure result count: %d", admin_id, len(results) if results else 0)

        if not results:
            return jsonify({
                "status": "Success",
                "message": "No documents found for this order.",
                "data": []
            }), 200

        return jsonify({
            "status": "Success",
            "message": "Documents retrieved successfully.",
            "data": results
        }), 200

    except Exception as e:
        logger.exception("[ADMIN:%s][get_documents_by_order] Exception occurred", admin_id)
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Update City Service
@admin_bp.route('/update_city_service', methods=['PUT'])
@jwt_required()
def update_city_service():
    admin_id = get_jwt_identity()
    try:
        data = request.get_json()
        logger.info("[ADMIN:%s][update_city_service] Request payload: %s", admin_id, data)

        cities = data.get('cities')
        if not cities or not isinstance(cities, list):
            logger.warning("[ADMIN:%s][update_city_service] Invalid or missing 'cities' list", admin_id)
            return jsonify({"status": "Failure", "message": "Missing or invalid 'cities' list in request body"}), 400

        procedure_name = 'update_city_service_status'
        results = []

        for city in cities:
            city_id = city.get('cityId')
            is_service = city.get('isService')

            if city_id is None or is_service is None:
                logger.warning("[ADMIN:%s][update_city_service] Missing cityId or isService in city: %s", admin_id, city)
                results.append({"cityId": city_id, "status": "Failure", "message": "Missing 'cityId' or 'isService'"})
                continue

            try:
                params = (int(city_id), bool(is_service))
                logger.info("[ADMIN:%s][update_city_service] Calling procedure %s with params: %s", admin_id, procedure_name, params)

                result = db.insertall_using_procedure(procedure_name, params)

                if result and result[0]:
                    msg = result[0].get("message", "Updated successfully")
                    results.append({"cityId": city_id, "status": "Success", "message": msg})
                    logger.info("[ADMIN:%s][update_city_service] City %d updated successfully: %s", admin_id, city_id, msg)
                else:
                    results.append({"cityId": city_id, "status": "Failure", "message": "No response from procedure"})
                    logger.error("[ADMIN:%s][update_city_service] No response from procedure for city %d", admin_id, city_id)

            except Exception as inner_e:
                logger.exception("[ADMIN:%s][update_city_service] Exception updating city %d", admin_id, city_id)
                results.append({"cityId": city_id, "status": "Failure", "message": str(inner_e)})

        return jsonify({"status": "Complete", "results": results}), 200

    except Exception as e:
        logger.exception("[ADMIN:%s][update_city_service] Exception occurred", admin_id)
        return jsonify({"status": "Failure", "message": str(e)}), 500


# 📌 Fetch Cities
@admin_bp.route('/cities', methods=['GET'])
@jwt_required()
def fetch_cities():
    admin_id = get_jwt_identity()
    try:
        logger.info("[ADMIN:%s][fetch_cities] Request received", admin_id)
        results = db.call_procedure("get_all_cities")
        logger.info("[ADMIN:%s][fetch_cities] Retrieved %d cities", admin_id, len(results) if results else 0)

        return jsonify({"status": "Success", "message": "Cities retrieved successfully.", "data": results}), 200

    except Exception as e:
        logger.exception("[ADMIN:%s][fetch_cities] Exception occurred", admin_id)
        return jsonify({"status": "Failure", "message": str(e)}), 500
# 📌 Insert Documents / Profile
@admin_bp.route('/insertprofile', methods=['POST'])
@jwt_required()
def insert_documents():
    claims = get_jwt()
    employee_id = claims.get("sub")
    try:
        order_id = request.form.get("orderId", type=int)
        doc_type = request.form.get("doctype", "commodities")
        files = request.files.getlist("paths")

        logger.info("[EMPLOYEE:%s][insertprofile] Received request with order_id=%s, doc_type=%s, files_count=%d",
                    employee_id, order_id, doc_type, len(files))

        if not order_id or not files:
            logger.warning("[EMPLOYEE:%s][insertprofile] Missing order_id or files", employee_id)
            return jsonify({"status": "Failure", "message": "order_id and at least one file in 'paths' are required.", "documents": []}), 400

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
            logger.info("[EMPLOYEE:%s][insertprofile] Saved file: %s", employee_id, unique_filename)

        images_json_array = json.dumps(saved_file_names)
        params = (order_id, images_json_array, doc_type)
        db_result = db.insertall_using_procedure("insertDocument", params)
        logger.info("[EMPLOYEE:%s][insertprofile] Stored procedure insertDocument called with params: %s", employee_id, params)

        return jsonify({"data": db_result}), 200

    except Exception as e:
        logger.exception("[EMPLOYEE:%s][insertprofile] Exception occurred", employee_id)
        return jsonify({"message": str(e), "documents": []}), 500


# 📌 Get Image by Filename
@admin_bp.route('/getdocumentfile/<filename>', methods=['GET'])
@jwt_required()
def get_image_by_filename(filename):
    try:
        logger.info("[getdocumentfile] Request for filename: %s", filename)
        for root, dirs, files in os.walk(upload_folder):
            if filename in files:
                logger.info("[getdocumentfile] File found: %s", filename)
                return send_from_directory(root, filename)

        logger.warning("[getdocumentfile] File not found: %s", filename)
        return jsonify({"status": "Failure", "message": f"Image '{filename}' not found."}), 404

    except Exception as e:
        logger.exception("[getdocumentfile] Exception occurred")
        return jsonify({"status": "Error", "message": str(e)}), 500


# 📌 Delete Employee
@admin_bp.route('/delete_employee/<int:emp_id>', methods=['DELETE'])
@jwt_required()
def delete_employee(emp_id):
    claims = get_jwt()
    user_id = claims.get('userId')
    try:
        procedure_name = "DeleteEmployee"
        params = (emp_id,)
        logger.info("[ADMIN:%s][delete_employee] Deleting employee_id=%d", user_id, emp_id)

        rows_affected = db.insert_using_procedure(procedure_name, params)
        if rows_affected:
            logger.info("[ADMIN:%s][delete_employee] Delete result: %s", user_id, rows_affected)
            return jsonify({"message": rows_affected['message']}), 200
        else:
            logger.warning("[ADMIN:%s][delete_employee] Employee not found: %d", user_id, emp_id)
            return jsonify({"message": "Employee not found"}), 404
    except Exception as e:
        logger.exception("[ADMIN:%s][delete_employee] Exception occurred", user_id)
        return jsonify({"error": str(e)}), 500


# 📌 Get Orders by Employee
@admin_bp.route('/userorders/<int:employee_id>/<status>', methods=['GET'])
@jwt_required()
def get_orders_by_employee(employee_id, status):
    try:
        procedure_name = "GetOrdersByEmployeeId"
        order_status = None if status.lower() == "null" else status
        params = (employee_id, order_status)
        logger.info("[userorders] Fetching orders for employee_id=%d, status=%s", employee_id, order_status)

        result = db.call_procedure(procedure_name, params)
        logger.info("[userorders] Orders fetched count: %d", len(result) if result else 0)

        return jsonify({"Status": "Success", "Orders": result}), 200
    except Exception as e:
        logger.exception("[userorders] Exception occurred")
        return jsonify({"Status": "Failure", "Message": str(e)}), 500


# 📌 Get Order Details by Status
@admin_bp.route('/getOrderDetailsByStatus/<userid>', methods=['POST'])
@jwt_required()
def get_order_details_by_status(userid):
    try:
        claims = get_jwt()
        data = request.json
        order_status = data.get("order_status", "")
        order_id = data.get("order_id", "")
        delivery_date = data.get("delivery_date")
        page_number = int(data.get("page_number", 1))
        page_size = int(data.get("page_size", 10))

        params = (order_status, order_id, delivery_date, page_number, page_size, userid)
        logger.info("[getOrderDetailsByStatus] Fetching orders for user=%s with params=%s", userid, params)

        results = db.call_procedure("getOrderDetailsByStatus", params)

        if not results or len(results) < 2:
            logger.warning("[getOrderDetailsByStatus] No orders found for user=%s", userid)
            return jsonify({"status": "success", "totalRecords": 0, "orders": []}), 200

        total_records = results[0][0].get("totalRecords", 0)
        orders = results[1]
        logger.info("[getOrderDetailsByStatus] Total orders: %d", total_records)

        return jsonify({"status": "success", "totalRecords": total_records, "orders": orders}), 200

    except Exception as e:
        logger.exception("[getOrderDetailsByStatus] Exception occurred")
        return jsonify({"status": "error", "message": str(e)}), 500


# 📌 Get Order Summary
@admin_bp.route('/get_order_summary', methods=['POST'])
@jwt_required()
def get_order_summary():
    try:
        data = request.get_json()
        order_id = data.get('order_id')
        logger.info("[get_order_summary] Requested order summary for order_id=%s", order_id)

        if not order_id:
            logger.warning("[get_order_summary] Missing order_id in request")
            return jsonify({"error": "Missing 'order_id' in request body"}), 400

        procedure_name = "GetOrderSummaryDetails"
        result_sets = db.call_procedure(procedure_name, [order_id])

        parsed_data = {}
        if result_sets:
            for row in result_sets:
                section = row.get("section")
                json_data = row.get("data")
                try:
                    parsed_json = json.loads(json_data)
                except Exception as e:
                    logger.warning("[get_order_summary] JSON parse failed for section %s: %s", section, str(e))
                    parsed_json = json_data
                parsed_data[section] = parsed_json
            logger.info("[get_order_summary] Parsed summary for order_id=%s", order_id)
            return jsonify({"data": parsed_data, "message": "Order summary retrieved successfully"}), 200
        else:
            logger.warning("[get_order_summary] No summary found for order_id=%s", order_id)
            return jsonify({"message": f"No summary found for order_id {order_id}"}), 404

    except Exception as e:
        logger.exception("[get_order_summary] Exception occurred")
        return jsonify({"error": "Internal server error"}), 500


# 📌 Get Order Documents
@admin_bp.route('/get_order_documents', methods=['GET'])
@jwt_required()
def get_order_documents():
    try:
        order_id = request.args.get('order_id', type=int)
        category = request.args.get('category', default='commodities', type=str)
        logger.info("[get_order_documents] Fetching documents for order_id=%s, category=%s", order_id, category)

        if not order_id or not category:
            logger.warning("[get_order_documents] Missing parameters: order_id or category")
            return jsonify({"message": "Missing order_id or category"}), 400

        procedure_name = "getOrderDocuments"
        result = db.call_procedure(procedure_name, [order_id, category])

        if result and len(result[0]) > 0:
            logger.info("[get_order_documents] Documents found for order_id=%s, category=%s", order_id, category)
            return jsonify({"data": result, "message": "Documents retrieved successfully"}), 200
        else:
            logger.warning("[get_order_documents] No documents found for order_id=%s, category=%s", order_id, category)
            return jsonify({"message": "No documents found"}), 404

    except Exception as e:
        logger.exception("[get_order_documents] Exception occurred")
        return jsonify({"error": str(e)}), 500


# 📌 Get Orders by Customer
@admin_bp.route('/cusorders/<int:cus_id>/<status>', methods=['GET'])
@jwt_required()
def get_orders_by_customer(cus_id, status):
    try:
        procedure_name = "GetOrdersByCustomerId"
        order_status = None if status.lower() == "null" else status
        params = (cus_id, order_status)
        logger.info("[cusorders] Fetching orders for customer_id=%d, status=%s", cus_id, order_status)

        result = db.call_procedure(procedure_name, params)
        logger.info("[cusorders] Orders fetched count: %d", len(result) if result else 0)

        return jsonify({"Status": "Success", "Orders": result}), 200
    except Exception as e:
        logger.exception("[cusorders] Exception occurred")
        return jsonify({"Status": "Failure", "Message": str(e)}), 500
