from flask import Blueprint, request, jsonify
from db_function import db  # Import your database connection class
from datetime import  datetime

from . import commodities_bp

# 📌 1️⃣ Insert a New Commodity
@commodities_bp.route('/create', methods=['POST'])
def create_commodity():
    data = request.json
    try:
        procedure_name = "insert_commodity"
        params = (
            data.get('item_name'),
            data.get('item_photo', None),  # Optional
            data.get('min_order_qty', 1),  # Default to 1
            data.get('max_order_qty', 10),  # Default to 10
            data.get('price', 30.00)  # Default price
        )
        result = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": result}), 201  # Fetching the message from the result
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 2️⃣ Update a Commodity
@commodities_bp.route('/update/<int:commodity_id>', methods=['PUT'])
def update_commodity(commodity_id):
    data = request.json
    try:
        procedure_name = "update_commodity"
        params = (
            commodity_id,
            data.get('item_name'),
            data.get('item_photo', None),
            data.get('min_order_qty'),
            data.get('max_order_qty'),
            data.get('price')
        )
        result = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 3️⃣ Delete a Commodity
@commodities_bp.route('/delete/<int:commodity_id>', methods=['DELETE'])
def delete_commodity(commodity_id):
    try:
        procedure_name = "delete_commodity"
        params = (commodity_id,)
        result = db.call_procedure(procedure_name, params)
        return jsonify({"message": result[0][0]}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 4️⃣ Get Commodity by ID
from decimal import Decimal


@commodities_bp.route('/get/<int:commodity_id>', methods=['GET'])
def get_commodity(commodity_id):
    try:
        procedure_name = "get_commodity_by_id"
        params = (commodity_id,)
        result = db.call_procedure(procedure_name, params)

        if result and isinstance(result[0], list):
            if len(result[0]) == 0:  # No data returned
                return jsonify({"message": "Commodity not found"}), 404

            # Check if the first item is an error message
            if isinstance(result[0][0], tuple) and isinstance(result[0][0][0], str) and "Error:" in result[0][0][0]:
                return jsonify({"message": result[0][0][0]}), 404  # Return error message

            # Extract and format commodity details
            commodity = result[0][0]
            return jsonify({
                "commodity_id": commodity[0],
                "item_name": commodity[1],
                "item_photo": commodity[2],
                "min_order_qty": commodity[3],
                "max_order_qty": commodity[4],
                "price": float(commodity[5]) if isinstance(commodity[5], Decimal) else commodity[5],
                # Convert Decimal to float
                "created_at": commodity[6].isoformat() if isinstance(commodity[6], datetime) else commodity[6]
                # Convert datetime to string
            }), 200

        else:
            return jsonify({"message": "Commodity not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@commodities_bp.route('/commdity_list', methods=['GET'])
def get_commodities():
    try:
        procedure_name = "get_commodities_list"
        result = db.call_procedure(procedure_name)

        # Check if the stored procedure returned valid data
        if result and isinstance(result[0], list):
            first_entry = result[0][0] if len(result[0]) > 0 else None

            # If first_entry is a tuple and contains an error message
            if first_entry and isinstance(first_entry, tuple) and isinstance(first_entry[0], str) and "Error:" in \
                    first_entry[0]:
                return jsonify({"message": first_entry[0]}), 404

            # Process and return the commodities list
            commodities = [
                {
                    "commodity_id": row[0],
                    "item_name": row[1],
                    "item_photo": row[2],
                    "min_order_qty": row[3],
                    "max_order_qty": row[4],
                    "price": float(row[5]) if isinstance(row[5], Decimal) else row[5],
                    "created_at": row[6].isoformat() if isinstance(row[6], datetime) else row[6]
                }
                for row in result[0]
            ]

            return jsonify(commodities), 200

        else:
            return jsonify({"message": "No commodities found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500