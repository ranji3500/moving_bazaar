from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt
from db_function import db
from datetime import datetime
from decimal import Decimal
from . import commodities_bp


# 📌 1⃣️ Insert a New Commodity
@commodities_bp.route('/createcommodity', methods=['POST'])
@jwt_required()
def create_commodity():
    claims = get_jwt()
    employee_id = claims.get("sub")

    data = request.json
    try:
        procedure_name = "insertCommodity"
        params = (
            data.get('itemName'),
            data.get('itemPhoto', None),
            data.get('description', None),
            data.get('minOrderQty', 1),
            data.get('maxOrderQty', 10),
            data.get('price', 30.00),
            employee_id
        )
        result = db.insert_using_procedure(procedure_name, params)

        if result:
            return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 2⃣️ Update a Commodity
@commodities_bp.route('/updatecommodity/<int:commodityId>', methods=['PUT'])
@jwt_required()
def update_commodity(commodityId):
    claims = get_jwt()
    employee_id = claims.get("sub")

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
            data.get('price'),
            employee_id
        )
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 3⃣️ Delete a Commodity
@commodities_bp.route('/deletecommodity/<int:commodityId>', methods=['DELETE'])
@jwt_required()
def delete_commodity(commodityId):
    claims = get_jwt()
    employee_id = claims.get("sub")

    try:
        procedure_name = "deleteCommodity"
        params = (commodityId, employee_id)
        result = db.insert_using_procedure(procedure_name, params)

        return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 4⃣️ Get Commodity by ID
@commodities_bp.route('/getcommodity/<int:commodityId>', methods=['GET'])
@jwt_required()
def get_commodity(commodityId):
    claims = get_jwt()
    employee_id = claims.get("sub")

    try:
        procedure_name = "getCommodityById"
        params = (commodityId, employee_id)
        result = db.call_procedure(procedure_name, params)

        if result:
            commodity = result
            return jsonify(commodity), 200

        return jsonify({"message": "Commodity not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 📌 5⃣️ Get All Commodities
@commodities_bp.route('/commodityList', methods=['GET'])
@jwt_required()
def get_commodities():
    claims = get_jwt()
    employee_id = claims.get("sub")

    try:
        procedure_name = "getCommoditiesList"
        params = (employee_id,)
        result = db.call_procedure(procedure_name, params)

        if result:
            return jsonify({
                "data": result,
                "message": "Commodity details has been fetched successfully"
            }), 200

        return jsonify({
            "data": None,
            "message": "No commodities found"
        }), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500
