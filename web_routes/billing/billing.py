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
