from flask_jwt_extended import get_jwt_identity
from flask import jsonify, request ,current_app ,send_from_directory

import os
from logger_config import setup_logger
from flask_jwt_extended import jwt_required, get_jwt
import json
from datetime import datetime
from werkzeug.utils import secure_filename
from uuid import uuid4


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

@admin_bp.route('/create_employee', methods=['POST'])
@jwt_required()
def create_employee():
    claims = get_jwt()
    user_id = claims.get('userId')
    user_name = claims.get('userName')
    email = claims.get('email')

    try:
        # Get form fields
        full_name = request.form.get('fullName')
        emp_email = request.form.get('email')
        phone_number = request.form.get('phoneNumber')
        password = request.form.get('password')
        is_admin = request.form.get('isAdmin', 'false').lower() == 'true'
        user_type = request.form.get('user_type').lower()

        # Handle single profile photo
        file = request.files.get('profile_photo')
        profile_photo_filename = None

        if file and file.filename != '':
            original_name = secure_filename(file.filename)
            ext = os.path.splitext(original_name)[1]
            unique_filename = f"{user_id}_profile_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            profile_photo_filename = unique_filename  # store just the filename or path

        procedure_name = "InsertEmployee"
        params = (
            full_name,
            emp_email,
            phone_number,
            password,
            profile_photo_filename,  # single file name (not JSON array)
            1,
            user_type
        )

        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": rows_affected, "rows_affected": rows_affected}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@admin_bp.route('/login', methods=['POST'])
def admin_login():
    try:
        data = request.json
        username = data.get("username")
        password = data.get("password")

        if not username or not password:
            return jsonify({"message": "Username and password are required"}), 400

        procedure_name = "AdminLogin"
        params = (username, password)
        result = db.call_procedure(procedure_name, params)

        if not result or len(result) == 0:
            return jsonify({
                "data": None,
                "message": "Invalid login credentials"
            }), 401

        response_dict = result[0]
        result_status = response_dict.get("result_status", 1)  # Assume success unless told otherwise

        if result_status == 1:
            admin_id = str(response_dict.get("admin_id", "0"))
            user_name = response_dict.get("username", username)
            user_type = response_dict.get("user_type", "ADMIN")

            # 🔐 Generate access token with claims
            access_token = create_access_token(
                identity=admin_id,
                additional_claims={
                    "adminId": admin_id,
                    "userName": user_name,
                    "user_type": user_type
                },
                expires_delta=timedelta(hours=2)
            )

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
            return jsonify({
                "data": None,
                "message": response_dict.get("message", "Login failed")
            }), 401

    except Exception as e:
        logger.error("Error during admin login", exc_info=True)
        return jsonify({"error": str(e)}), 500


@admin_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    admin_id = get_jwt_identity()  # Get admin ID from token
    logger.info("Protected route accessed by admin ID: %s", admin_id)

    return jsonify({
        "message": "Access granted",
        "admin_id": admin_id
    }), 200

@admin_bp.route('/get_users', methods=['GET'])
@jwt_required()
def get_users():
    logger.info("Admin requested all users")

    try:
        procedure_name = "GetUsers"
        users = db.call_procedure(procedure_name)

        if users and len(users[0]) > 0:
            logger.info("Users retrieved successfully. Count: %d", len(users[0]))
            return jsonify(users), 200
        else:
            logger.warning("No users found in database.")
            return jsonify({"message": "No users found"}), 404

    except Exception as e:
        logger.error("Error fetching users: %s", str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500

@admin_bp.route('/get_user/<int:emp_id>', methods=['GET'])
@jwt_required()
def get_user(emp_id):
    logger.info("Fetching user with ID: %d", emp_id)

    try:
        procedure_name = "GetUserById"
        params = (emp_id,)
        user = db.call_procedure(procedure_name, params)

        if user and len(user[0]) > 0:
            logger.info("User with ID %d retrieved successfully", emp_id)
            return jsonify(user), 200  # Extract single user
        else:
            logger.warning("User with ID %d not found", emp_id)
            return jsonify({"message": "User not found"}), 404

    except Exception as e:
        logger.error("Error fetching user with ID %d: %s", emp_id, str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500

@admin_bp.route('/overview', methods=['GET'])
@jwt_required()
def get_dashboard_overview():
    try:
        filter_type = request.args.get('filter', default='today')  # 'today', 'week', 'month', or 'custom'

        start_date = None
        end_date = None

        # If filter_type is 'custom', we fetch custom date range
        if filter_type == 'custom':
            start_date = request.args.get('start_date')  # 'YYYY-MM-DD' format
            end_date = request.args.get('end_date')      # 'YYYY-MM-DD' format

            # Check if start_date and end_date are provided
            if not start_date or not end_date:
                return jsonify({"error": "Both start_date and end_date are required for custom filter"}), 400

            # Convert date strings to date objects (if using date filtering)
            try:
                start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
                end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
            except ValueError as e:
                return jsonify({"error": f"Invalid date format. Please use 'YYYY-MM-DD'."}), 400

        # Call the stored procedure with filter and optional dates
        results = db.call_procedure("GetDashboardOverview", (filter_type, start_date, end_date))

        # Procedure returns a single result set, we process it
        if results and len(results) > 0:
            dashboard_summary = json.loads(results[0]['dashboard_summary'])
            return jsonify({
                "metrics": dashboard_summary["metrics"],
                "users": dashboard_summary["users"],
                "customers": dashboard_summary["customers"],
                "message": dashboard_summary["message"]
            }), 200

        return jsonify({
            "message": "No data found"
        }), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@admin_bp.route('/getorderoverview', methods=['GET'])
@jwt_required()
def getorderoverview():
    try:
        # Query Params
        delivery_date_str = request.args.get("deliveryDate", None)
        order_status = request.args.get("orderStatus", None)
        order_id = request.args.get("searchQuery", None)
        page_number = int(request.args.get("pageNumber", 1))
        page_size = int(request.args.get("pageSize", 10))
        user_id = request.args.get("userId", None)

        # Validate pagination
        if page_number < 1 or page_size < 1:
            return jsonify({"status": "Failure", "message": "Invalid pagination values"}), 400

        # Parse delivery date
        delivery_date = None
        if delivery_date_str:
            try:
                delivery_date = datetime.strptime(delivery_date_str, "%Y-%m-%d").date()
            except ValueError:
                return jsonify({"status": "Failure", "message": "Invalid deliveryDate format. Use YYYY-MM-DD"}), 400

        # Stored procedure call
        procedure_name = "getOrderDetailsByStatus"
        params = (order_status, order_id, delivery_date, page_number, page_size, user_id)
        result = db.call_procedure(procedure_name, params)

        # Validate result
        if not result or len(result) < 2:
            return jsonify({"status": "Failure", "message": "Procedure result format is invalid"}), 500

        total_record_item = result[0]
        if not isinstance(total_record_item, dict) or "totalRecords" not in total_record_item:
            return jsonify({"status": "Failure", "message": "Missing totalRecords"}), 500

        total_records = total_record_item["totalRecords"]
        order_rows = result[1:]

        # Handle empty result
        if len(order_rows) == 1 and list(order_rows[0].keys()) == ["orderId"] and order_rows[0]["orderId"] is None:
            order_rows = []

        # Return successful response
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


@admin_bp.route('/get_commodities', methods=['GET'])
@jwt_required()
def get_commodities():
    logger.info("Admin requested all commodities")

    try:
        procedure_name = "getCommodities"
        commodities = db.call_procedure(procedure_name)

        if commodities and len(commodities[0]) > 0:
            logger.info("Commodities retrieved successfully. Count: %d", len(commodities[0]))
            return jsonify({"data":commodities,"message":"Commodities retrieved successfully"}), 200
        else:
            logger.warning("No commodities found in database.")
            return jsonify({"message": "No commodities found"}), 404

    except Exception as e:
        logger.error("Error fetching commodities: %s", str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500


@admin_bp.route('/insert_commodity', methods=['POST'])
@jwt_required()
def insert_commodity():
    try:
        # Extract form data
        item_name = request.form.get("itemName")
        description = request.form.get("description")
        min_order_qty = request.form.get("minOrderQty")
        max_order_qty = request.form.get("maxOrderQty")
        price = request.form.get("price")

        # Extract image file
        file = request.files.get("itemPhoto")
        item_photo_filename = None

        if file and file.filename:
            ext = os.path.splitext(file.filename)[1]
            unique_filename = f"commodity_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            item_photo_filename = unique_filename
        else:
            return jsonify({
                "status": "Failure",
                "message": "Image (itemPhoto) is required"
            }), 400

        # Validate required fields
        required = [item_name, description, min_order_qty, max_order_qty, price]
        if not all(required):
            return jsonify({
                "status": "Failure",
                "message": "All fields are required"
            }), 400

        procedure_name = "insert_commodity"
        params = (
            item_name,
            item_photo_filename,
            description,
            int(min_order_qty),
            int(max_order_qty),
            float(price)
        )

        result = db.insertall_using_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or not result[0]:
            return jsonify({
                "status": "Failure",
                "message": "No response from stored procedure"
            }), 500

        message = result[0].get("message") or result[0].get("error_message", "Unknown error")

        return jsonify({
            "status": "Success" if "inserted" in message.lower() else "Failure",
            "message": message
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500


@admin_bp.route('/update_commodity', methods=['POST'])  # PUT also acceptable
@jwt_required()
def update_commodity():
    try:
        # Extract form data
        commodity_id = request.form.get("commodityId")
        item_name = request.form.get("itemName")
        description = request.form.get("description")
        min_order_qty = request.form.get("minOrderQty")
        max_order_qty = request.form.get("maxOrderQty")
        price = request.form.get("price")

        # Extract image file (optional)
        file = request.files.get("itemPhoto")
        item_photo_filename = None

        if file and file.filename:
            ext = os.path.splitext(file.filename)[1]
            unique_filename = f"commodity_{uuid4().hex}{ext}"
            filepath = os.path.join(upload_folder, unique_filename)
            file.save(filepath)
            item_photo_filename = unique_filename

        # Call stored procedure
        procedure_name = "edit_commodity"
        params = (
            int(commodity_id),
            item_name,
            item_photo_filename,
            description,
            int(min_order_qty),
            int(max_order_qty),
            float(price)
        )

        result = db.insertall_using_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or not result[0]:
            return jsonify({
                "status": "Failure",
                "message": "No response from stored procedure"
            }), 500

        response_data = result[0]
        return jsonify({
            "status": response_data.get("Status", "Success"),
            "message": response_data.get("Message", "Commodity updated successfully"),
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500


@admin_bp.route('/delete_commodity/<int:commodity_id>', methods=['DELETE'])
@jwt_required()
def delete_commodity(commodity_id):
    try:
        if not commodity_id:
            return jsonify({
                "status": "Failure",
                "message": "commodityId is required"
            }), 400

        # Call stored procedure with param
        procedure_name = "deleteCommodity"
        params = (commodity_id,)

        result = db.insertall_using_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or not result[0]:
            return jsonify({
                "status": "Failure",
                "message": "No response from stored procedure"
            }), 500

        # Parse result
        response_data = result[0]
        message = response_data.get("message") or response_data.get("errorMessage", "")

        if message.startswith("sqlError"):
            return jsonify({
                "status": "Failure",
                "message": message
            }), 500

        return jsonify({
            "status": "Success" if "Deleted" in message else "Failure",
            "message": message
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500


@admin_bp.route('/search_commodity', methods=['GET'])
@jwt_required()
def search_commodity():
    try:
        search_term = request.args.get("query")

        if not search_term:
            return jsonify({
                "status": "Failure",
                "message": "Missing 'query' parameter in URL"
            }), 400

        # Stored procedure and parameters
        procedure_name = "searchCommoditySimilar"
        params = (search_term,)

        # Call your DB utility
        result = db.insertall_using_procedure(procedure_name, params)

        if not result:
            return jsonify({
                "status": "Success",
                "message": "No commodities found",
                "data": []
            }), 200

        return jsonify({
            "status": "Success",
            "message": f"{len(result)} commodities matched",
            "data": result
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500



@admin_bp.route('/insert_employee', methods=['POST'])
@jwt_required()
def insert_employee():
    try:
        data = request.get_json()

        if not data:
            return jsonify({
                "status": "Failure",
                "message": "Missing or invalid JSON data. Ensure Content-Type is application/json"
            }), 400

        full_name = data.get("fullName")
        email = data.get("email")
        phone_number = data.get("phoneNumber")
        password = data.get("password")
        profile_photo = data.get("profilePhoto") or None
        is_admin = data.get("isAdmin", 0)

        # Validation
        if not all([full_name, email, phone_number, password]):
            return jsonify({
                "status": "Failure",
                "message": "Full name, email, phone number, and password are required"
            }), 400

        # Stored procedure and params
        procedure_name = "InsertEmployee"
        params = (
            full_name,
            email,
            phone_number,
            password,
            profile_photo,
            int(is_admin)
        )

        result = db.insertall_using_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or not result[0]:
            return jsonify({
                "status": "Failure",
                "message": "No response from stored procedure"
            }), 500

        message = result[0].get("message", "Unknown result")

        return jsonify({
            "status": "Success" if "successfully" in message.lower() else "Failure",
            "message": message
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500



@admin_bp.route('/insert_customer', methods=['POST'])
@jwt_required()
def insert_customer():
    try:
        data = request.get_json()

        if not data:
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
            return jsonify({
                "status": "Failure",
                "message": "Missing required fields. Please provide storeName, email, phoneNumber, whatsappNumber, addressLine1, and city"
            }), 400

        # Prepare stored procedure call
        procedure_name = "insert_customer_admin"
        params = (
            store_name,
            email,
            phone_number,
            whatsapp_number,
            address_line1,
            address_line2,
            city,
            float(outstanding_price)
        )

        result = db.insertall_using_procedure(procedure_name, params)

        if not result or not isinstance(result, list) or not result[0]:
            return jsonify({
                "status": "Failure",
                "message": "No response from stored procedure"
            }), 500

        response = result[0]
        return jsonify({
            "status": "Success" if "inserted successfully" in response.get("message", "").lower() else "Failure",
            "message": response.get("message"),
            "customerId": response.get("customerId")
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500


@admin_bp.route('/edit_customer', methods=['PUT'])
@jwt_required()
def edit_customer():
    try:
        data = request.get_json()

        required_fields = ["customerId", "storeName", "email", "phoneNumber", "whatsappNumber", "addressLine1", "city", "outstanding"]
        if not all(data.get(field) for field in required_fields):
            return jsonify({
                "status": "Failure",
                "message": "Missing required fields"
            }), 400

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

        result = db.insertall_using_procedure("edit_customer", params)
        message = result[0].get("message", "Unknown result")

        return jsonify({
            "status": "Success" if "updated" in message.lower() else "Failure",
            "message": message
        }), 200

    except Exception as e:
        return jsonify({"status": "Failure", "message": str(e)}), 500


@admin_bp.route('/delete_customer/<int:customer_id>', methods=['DELETE'])
@jwt_required()
def delete_customer(customer_id):
    try:
        params = (customer_id,)
        result = db.insertall_using_procedure("delete_customer", params)

        message = result[0].get("message", "Unknown result")

        return jsonify({
            "status": "Success" if "deleted" in message.lower() else "Failure",
            "message": message
        }), 200

    except Exception as e:
        return jsonify({"status": "Failure", "message": str(e)}), 500

@admin_bp.route('/billing_overview', methods=['GET'])
@jwt_required()
def get_billing_overview():
    try:
        status_filter = request.args.get('status', 'All')

        # Validate input
        if status_filter not in ['All', 'Pending', 'Paid']:
            return jsonify({
                "status": "Failure",
                "message": "Invalid status filter. Use 'All', 'Pending', or 'Paid'."
            }), 400

        result = db.call_procedure('get_billing_overview', (status_filter,))

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

@admin_bp.route('/documents/<int:order_id>', methods=['GET'])
@jwt_required()
def get_documents_by_order(order_id):
    try:
        results = db.call_procedure('get_document_paths_by_order_id', (order_id,))

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
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500


@admin_bp.route('/update_city_service', methods=['PUT'])
@jwt_required()
def update_city_service():
    try:
        data = request.get_json()
        cities = data.get('cities')

        if not cities or not isinstance(cities, list):
            return jsonify({
                "status": "Failure",
                "message": "Missing or invalid 'cities' list in request body"
            }), 400

        procedure_name = 'update_city_service_status'
        results = []

        for city in cities:
            city_id = city.get('cityId')
            is_service = city.get('isService')

            if city_id is None or is_service is None:
                results.append({
                    "cityId": city_id,
                    "status": "Failure",
                    "message": "Missing 'cityId' or 'isService'"
                })
                continue

            try:
                params = (int(city_id), bool(is_service))
                result = db.insertall_using_procedure(procedure_name, params)

                if result and result[0]:
                    results.append({
                        "cityId": city_id,
                        "status": "Success",
                        "message": result[0].get("message", "Updated successfully")
                    })
                else:
                    results.append({
                        "cityId": city_id,
                        "status": "Failure",
                        "message": "No response from procedure"
                    })
            except Exception as inner_e:
                results.append({
                    "cityId": city_id,
                    "status": "Failure",
                    "message": str(inner_e)
                })

        return jsonify({
            "status": "Complete",
            "results": results
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500



@admin_bp.route('/cities', methods=['GET'])
@jwt_required()
def fetch_cities():
    try:
        results = db.call_procedure("get_all_cities")

        return jsonify({
            "status": "Success",
            "message": "Cities retrieved successfully.",
            "data": results
        }), 200

    except Exception as e:
        return jsonify({
            "status": "Failure",
            "message": str(e)
        }), 500


@admin_bp.route('/insertprofile', methods=['POST'])
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

@admin_bp.route('/getdocumentfile/<filename>', methods=['GET'])
@jwt_required()
def get_image_by_filename(filename):
    try:
        for root, dirs, files in os.walk(upload_folder):
            if filename in files:
                return send_from_directory(root, filename)

        return jsonify({"status": "Failure", "message": f"Image '{filename}' not found."}), 404

    except Exception as e:
        return jsonify({"status": "Error", "message": str(e)}), 500


# DELETE Employee
@admin_bp.route('/delete_employee/<int:emp_id>', methods=['DELETE'])
@jwt_required()
def delete_employee(emp_id):
    try:
        claims = get_jwt()
        user_id = claims.get('userId')
        user_name = claims.get('userName')
        email = claims.get('email')
        user_type = claims.get('user_type')
        procedure_name = "DeleteEmployee"
        params = (emp_id,)
        rows_affected = db.insert_using_procedure(procedure_name, params)
        if rows_affected > 0:
            return jsonify({"message": "Employee deleted successfully"}), 200
        else:
            return jsonify({"message": "Employee not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@admin_bp.route('/userorders/<int:employee_id>/<status>', methods=['GET'])
@jwt_required()
def get_orders_by_employee(employee_id, status):
    try:
        procedure_name = "GetOrdersByEmployeeId"

        # Convert "null" string to actual None (so it maps to SQL NULL)
        order_status = None if status.lower() == "null" else status

        params = (employee_id, order_status)
        result = db.call_procedure(procedure_name, params)

        return jsonify({"Status": "Success", "Orders": result}), 200
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500


@admin_bp.route('/getOrderDetailsByStatus/<userid>', methods=['POST'])
@jwt_required()
def get_order_details_by_status(userid):  # ✅ Add parameter here
    try:
        claims = get_jwt()

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
            userid
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


@admin_bp.route('/get_order_summary', methods=['POST'])
@jwt_required()
def get_order_summary():
    try:
        data = request.get_json()
        order_id = data.get('order_id')

        if not order_id:
            return jsonify({"error": "Missing 'order_id' in request body"}), 400

        logger.info("Admin requested order summary for order_id: %s", order_id)

        procedure_name = "GetOrderSummaryDetails"
        result_sets = db.call_procedure(procedure_name, [order_id])

        parsed_data = {}

        if result_sets:
            for row in result_sets:  # Assuming only 1 result set with multiple rows
                section = row.get("section")
                json_data = row.get("data")

                try:
                    parsed_json = json.loads(json_data)
                except Exception as e:
                    logger.warning("JSON parsing failed for section %s: %s", section, str(e))
                    parsed_json = json_data  # Keep raw if JSON is invalid

                parsed_data[section] = parsed_json

            logger.info("Parsed and structured order summary for order_id %s", order_id)
            return jsonify({
                "data": parsed_data,
                "message": "Order summary retrieved successfully"
            }), 200

        else:
            return jsonify({"message": f"No summary found for order_id {order_id}"}), 404

    except Exception as e:
        logger.error("Error fetching order summary: %s", str(e), exc_info=True)
        return jsonify({"error": "Internal server error"}), 500

@admin_bp.route('/get_order_documents', methods=['GET'])
@jwt_required()
def get_order_documents():
    try:
        # Get query parameters
        order_id = request.args.get('order_id', type=int)
        category = request.args.get('category', default='commodities', type=str)

        logger.info("Admin requested documents for order_id: %s, category: %s", order_id, category)

        # Validate required inputs
        if not order_id or not category:
            logger.warning("Missing required parameters: order_id or category")
            return jsonify({"message": "Missing order_id or category"}), 400

        # Call stored procedure
        procedure_name = "getOrderDocuments"
        result = db.call_procedure(procedure_name, [order_id, category])

        if result and len(result[0]) > 0:
            logger.info("Documents found for order_id %s, category %s", order_id, category)
            return jsonify({
                "data": result,
                "message": "Documents retrieved successfully"
            }), 200
        else:
            logger.warning("No documents found for order_id %s, category %s", order_id, category)
            return jsonify({"message": "No documents found"}), 404

    except Exception as e:
        logger.error("Error fetching order documents: %s", str(e), exc_info=True)
        return jsonify({"error": str(e)}), 500

@admin_bp.route('/cusorders/<int:cus_id>/<status>', methods=['GET'])
@jwt_required()
def get_orders_by_customer(cus_id, status):
    try:
        procedure_name = "GetOrdersByCustomerId"

        # Convert "null" string to actual None (so it maps to SQL NULL)
        order_status = None if status.lower() == "null" else status

        params = (cus_id, order_status)
        result = db.call_procedure(procedure_name, params)

        return jsonify({"Status": "Success", "Orders": result}), 200
    except Exception as e:
        return jsonify({"Status": "Failure", "Message": str(e)}), 500