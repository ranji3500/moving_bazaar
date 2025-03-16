from flask import Blueprint, request, jsonify
from db_function import db  # Import your database connection class
from datetime import datetime
from decimal import Decimal
from . import commodities_bp


# 📌 1️⃣ Insert a New Commodity
@commodities_bp.route('/createcommodity', methods=['POST'])
def create_commodity():
    data = request.json
    try:
        procedure_name = "insertCommodity"
        params = (
            data.get('itemName'),
            data.get('itemPhoto', None),
            data.get('description', None),
            data.get('minOrderQty', 1),
            data.get('maxOrderQty', 10),
            data.get('price', 30.00)
        )
        result = db.insert_using_procedure(procedure_name, params)

        if result :
            return jsonify(result), 200


    except Exception as e:
        return jsonify({"error": str(e)}), 500



# 📌 2️⃣ Update a Commodity
@commodities_bp.route('/updatecommodity/<int:commodityId>', methods=['PUT'])
def update_commodity(commodityId):
    data = request.json
    try:
        procedure_name = "updateCommodity"
        params = (
            commodityId,
            data.get('itemName'),
            data.get('itemPhoto', None),
            data.get('description', None),
            data.get('minOrderQty'),
            data.get('maxOrderQty'),
            data.get('price')
        )
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 3️⃣ Delete a Commodity
@commodities_bp.route('/deletecommodity/<int:commodityId>', methods=['DELETE'])
def delete_commodity(commodityId):
    try:
        procedure_name = "deleteCommodity"
        params = (commodityId,)
        result = db.insert_using_procedure(procedure_name, params)


        return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 4️⃣ Get Commodity by ID
@commodities_bp.route('/getcommodity/<int:commodityId>', methods=['GET'])
def get_commodity(commodityId):
    try:
        procedure_name = "getCommodityById"
        params = (commodityId,)
        result = db.call_procedure(procedure_name, params)

        if result:
            commodity = result

            return jsonify(commodity), 200

        return jsonify({"message": "Commodity not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 5️⃣ Get All Commodities
@commodities_bp.route('/commodityList', methods=['GET'])
def get_commodities():
    try:
        procedure_name = "getCommoditiesList"
        result = db.call_procedure(procedure_name)

        if result :

            return jsonify(result), 200

        return jsonify({"message": "No commodities found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500
