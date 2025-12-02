from flask import request, jsonify
from flask_jwt_extended import jwt_required, get_jwt
from supports.db_function import db
from . import commodities_bp
from logger_configuration import logger

# 📌 1⃣️ Insert a New Commodity
@commodities_bp.route('/createcommodity', methods=['POST'])
@jwt_required()
def create_commodity():
    claims = get_jwt()
    employee_id = claims.get("sub")
    data = request.json

    try:
        logger.info(f"User {employee_id} requested to create a commodity")
        logger.debug(f"Request data: {data}")

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

        logger.info(f"Commodity created successfully by user {employee_id}: {result}")
        return jsonify(result), 200

    except Exception as e:
        logger.exception(f"Error while creating commodity by user {employee_id}")
        return jsonify({"error": str(e)}), 500


# 📌 2⃣️ Update a Commodity
@commodities_bp.route('/updatecommodity/<int:commodityId>', methods=['PUT'])
@jwt_required()
def update_commodity(commodityId):
    claims = get_jwt()
    employee_id = claims.get("sub")
    data = request.json

    try:
        logger.info(f"User {employee_id} requested to update commodity {commodityId}")
        logger.debug(f"Update data: {data}")

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

        logger.info(f"Commodity {commodityId} updated successfully by user {employee_id}")
        return jsonify(result), 200

    except Exception as e:
        logger.exception(f"Error while updating commodity {commodityId} by user {employee_id}")
        return jsonify({"error": str(e)}), 500


# 📌 3⃣️ Delete a Commodity
@commodities_bp.route('/deletecommodity/<int:commodityId>', methods=['DELETE'])
@jwt_required()
def delete_commodity(commodityId):
    claims = get_jwt()
    employee_id = claims.get("sub")

    try:
        logger.info(f"User {employee_id} requested to delete commodity {commodityId}")

        procedure_name = "deleteCommodity"
        params = (commodityId, employee_id)
        result = db.insert_using_procedure(procedure_name, params)

        logger.info(f"Commodity {commodityId} deleted successfully by user {employee_id}")
        return jsonify(result), 200

    except Exception as e:
        logger.exception(f"Error while deleting commodity {commodityId} by user {employee_id}")
        return jsonify({"error": str(e)}), 500


# 📌 4⃣️ Get Commodity by ID
@commodities_bp.route('/getcommodity/<int:commodityId>', methods=['GET'])
@jwt_required()
def get_commodity(commodityId):
    claims = get_jwt()
    employee_id = claims.get("sub")

    try:
        logger.info(f"User {employee_id} requested commodity details for ID {commodityId}")

        procedure_name = "getCommodityById"
        params = (commodityId, employee_id)
        result = db.call_procedure(procedure_name, params)

        if result:
            logger.info(f"Commodity {commodityId} retrieved successfully by user {employee_id}")
            return jsonify(result), 200

        logger.warning(f"Commodity {commodityId} not found for user {employee_id}")
        return jsonify({"message": "Commodity not found"}), 404

    except Exception as e:
        logger.exception(f"Error while retrieving commodity {commodityId} by user {employee_id}")
        return jsonify({"error": str(e)}), 500


# 📌 5⃣️ Get All Commodities
@commodities_bp.route('/commodityList', methods=['GET'])
@jwt_required()
def get_commodities():
    claims = get_jwt()
    employee_id = claims.get("sub")

    try:
        logger.info(f"User {employee_id} requested commodity list")

        procedure_name = "getCommoditiesList"
        params = (employee_id,)
        result = db.call_procedure(procedure_name)

        if result:
            logger.info(f"Commodity list retrieved successfully for user {employee_id}, count={len(result)}")
            return jsonify({
                "data": result,
                "message": "Commodity details have been fetched successfully"
            }), 200

        logger.warning(f"No commodities found for user {employee_id}")
        return jsonify({
            "data": None,
            "message": "No commodities found"
        }), 404

    except Exception as e:
        logger.exception(f"Error while fetching commodities for user {employee_id}")
        return jsonify({"error": str(e)}), 500
