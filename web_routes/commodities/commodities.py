from flask import jsonify, request
from . import commodities_bp
import mysql.connector
from db_function import db

# Insert Commodity using a stored procedure
@commodities_bp.route('/create_commodity', methods=['POST'])
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
@commodities_bp.route('/update_commodity/<int:productid>', methods=['PUT'])
def update_commodity(productid):
    data = request.json
    try:
        procedure_name = "UpdateCommodity"
        params = (
            data.get('productname'),
            data.get('productdescription'),
            data.get('unit_price'),
            productid
        )
        rows_affected = db.insert_using_procedure(procedure_name, params)
        if rows_affected > 0:
            return jsonify({"message": "Commodity updated successfully", "rows_affected": rows_affected})
        else:
            return jsonify({"message": "Commodity not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Delete Commodity using a stored procedure
@commodities_bp.route('/delete_commodity/<int:productid>', methods=['DELETE'])
def delete_commodity(productid):
    try:
        procedure_name = "DeleteCommodity"
        params = (productid,)
        rows_affected = db.insert_using_procedure(procedure_name, params)
        if rows_affected > 0:
            return jsonify({"message": "Commodity deleted successfully", "rows_affected": rows_affected})
        else:
            return jsonify({"message": "Commodity not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Get All Commodities using a stored procedure
@commodities_bp.route('/get_commodities', methods=['GET'])
def get_commodities():
    try:
        procedure_name = "GetCommodities"
        commodities = db.call_procedure(procedure_name)
        return jsonify(commodities), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Get Single Commodity details using a stored procedure
@commodities_bp.route('/get_commodity/<int:productid>', methods=['GET'])
def get_commodity(productid):
    try:
        procedure_name = "GetCommodityDetails"
        params = (productid,)
        commodity = db.call_procedure(procedure_name, params)
        if commodity:
            return jsonify(commodity), 200
        else:
            return jsonify({"message": "Commodity not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500