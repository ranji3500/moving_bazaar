from flask import jsonify, request
from . import billing_bp
import mysql.connector
from db_function import db



# ✅ API: Generate Billing
@billing_bp.route('/generate_billing', methods=['POST'])
def generate_billing():
    try:
        data = request.json
        order_id = data['order_id']
        created_by = data['created_by']
        paid_by = data['paid_by']
        outstanding_amount = data['outstanding_amount']

        params = (order_id, created_by, paid_by, outstanding_amount)


        result = db.insert_using_procedure("generate_billing",params)


        return jsonify(result), 201
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

# ✅ Create a new order
@billing_bp.route('/get_order_commodities/<int:order_id>', methods=['GET'])
def create_order():
    data = request.json
    try:
        procedure_name = "create_order"
        params = (data['sender_id'], data['receiver_id'], data['created_by'])
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify({"message": "Order Created Successfully", "order_id": result[0][0][0]}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ✅ Get Order Details
@billing_bp.route('/details/<int:order_id>', methods=['GET'])
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
def get_billing_by_employee(employee_id):
    try:
        params =  (employee_id,)
        billing_data = db.call_procedure("GetBillingByEmployeeId",params)
        return jsonify({"billing_details": billing_data})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# CLOSE Multiple Outstanding Balances
@billing_bp.route('/close_outstanding_balances', methods=['POST'])
def close_outstanding_balances():
    data = request.json
    try:
        # Get the list of order_ids from the request
        order_ids = data.get('order_ids', [])

        if not isinstance(order_ids, list) or not order_ids:
            return jsonify({"error": "Provide a non-empty list of order_ids"}), 400

        results = []
        for order_id in order_ids:
            try:
                procedure_name = "CloseOutstandingBalanceByOrderId"
                params = (order_id,)
                result = db.insert_using_procedure(procedure_name, params)
                results.append({
                    "order_id": order_id,
                    "result": result
                })
            except Exception as inner_e:
                results.append({
                    "order_id": order_id,
                    "error": str(inner_e)
                })

        return jsonify(results), 200

    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

import  json
@billing_bp.route('/insertbillingdetails', methods=['POST'])
def insert_billing_details():
    data = request.json
    try:
        # Stored procedure name
        procedure_name = "insert_billing"

        # Extracting parameters from the incoming JSON data using data.get()
        params = (
            data.get('order_id'),  # p_order_id
            data.get('user_id'),  # p_employee_id (user_id corresponds to employee_id)
            data.get('paid_by'),  # p_paid_by (customer_id corresponds to paid_by)
            data.get('grand_total'),  # p_grand_total
            data.get('current_order_value'),  # p_current_order_value
            data.get('total_amount_paid'),  # p_total_amount_paid
            data.get('current_order_amount_paid'),  # p_current_order_amount_paid
            data.get('outstanding_amount_paid'),  # p_outstanding_amount_paid
            json.dumps(data.get('closed_outstanding_order_ids', [])),  # Ensure it's converted to JSON format
            data.get('delivery_date')  # p_delivery_date
        )

        # Check if any required parameter is missing
        if None in params:
            return jsonify({"error": "Missing required fields in the request"}), 400

        # Execute the procedure and get the response from the stored procedure
        message = db.insert_using_procedure(procedure_name, params)

        # Return the message returned by the stored procedure
        return jsonify({"data":{"billingId":message["billing_id"],"orderId":message['order_id'],"orderStage":"delivery"},"message":message["message"]}), 200

    except Exception as e:
        # Return error message if something goes wrong
        return jsonify({"error": str(e)}), 500
