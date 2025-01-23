from flask import jsonify, request
from . import orders_bp
import mysql.connector
from db_function import db


# Insert Commodity using a stored procedure
@orders_bp.route('/create_commodity', methods=['POST'])
def create_commodity():
    data = request.json
    try:
        procedure_name = "InsertCommodity"
        params = (
            data.get('productid'),
            data.get('productname'),
            data.get('productdescription'),
            data.get('unit_price', 21.00),  # Default unit_price if not provided
            data.get('created_at', None)   # Optional: If you want to add created_at timestamp
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)
        return jsonify({"message": "Commodity created successfully", "rows_affected": rows_affected}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Update Commodity using a stored procedure
