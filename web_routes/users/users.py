
from flask import request, jsonify
from supports.db_function import db
from  . import client_bp
from flask_jwt_extended import create_access_token, jwt_required, get_jwt

import bcrypt
from logger_configuration import logger


@client_bp.route('/create_customer', methods=['POST'])
@jwt_required()
def create_customer():
    claims = get_jwt()
    user_id = claims.get('userId')
    data = request.json

    logger.info("[CREATE_CUSTOMER] Request by user_id=%s, data=%s", user_id, {k: v for k, v in data.items() if k != 'password'})

    try:
        procedure_name = "createCustomerWithPass"
        params = (
            data.get('storeName'),
            data.get('email'),
            data.get('phoneNumber'),
            data.get('whatsappNumber'),
            data.get('addressLine1'),
            data.get('addressLine2'),
            data.get('city'),
            data.get('outstandingPrice', 0.00),
            data.get('password')  # Ensure password is hashed already
        )

        logger.info("[CREATE_CUSTOMER] Calling stored procedure %s with params (password hidden)", procedure_name)

        with db.connection.cursor() as cursor:
            cursor.callproc(procedure_name, params)
            for result in cursor.stored_results():
                message_row = result.fetchone()
                break

        if message_row:
            logger.info("[CREATE_CUSTOMER] Procedure returned message: %s", message_row[0])
            return jsonify({"message": message_row[0]}), 201
        else:
            logger.warning("[CREATE_CUSTOMER] No result returned from procedure")
            return jsonify({"error": "No result returned from procedure"}), 500

    except Exception as e:
        logger.exception("[CREATE_CUSTOMER] Exception occurred for user_id=%s", user_id)
        return jsonify({"error": str(e)}), 500


@client_bp.route('/login', methods=['POST'])
def customer_login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    logger.info("[CUSTOMER_LOGIN] Login attempt for email=%s", email)

    if not email or not password:
        logger.warning("[CUSTOMER_LOGIN] Missing email or password")
        return jsonify({"message": "Email and password are required", "status": 0}), 400

    try:
        with db.connection.cursor() as cursor:
            # Step 1: Get stored hash
            cursor.execute("""
                SELECT a.password_hash
                FROM customer c
                JOIN customer_auth a ON c.customer_id = a.customer_id
                WHERE c.email = %s
                LIMIT 1
            """, (email,))
            result = cursor.fetchone()

            if not result:
                logger.warning("[CUSTOMER_LOGIN] Email not found: %s", email)
                return jsonify({"message": "Invalid email or password", "status": 0}), 401

            stored_hash = result[0]

            # Step 2: Compare password
            if not bcrypt.checkpw(password.encode('utf-8'), stored_hash.encode('utf-8')):
                logger.warning("[CUSTOMER_LOGIN] Invalid password for email=%s", email)
                return jsonify({"message": "Invalid email or password", "status": 0}), 401

            # Step 3: Call login procedure
            cursor.callproc('clientLogin', (email, stored_hash))
            for res in cursor.stored_results():
                response = res.fetchone()
                break

            if response and response[1] == 1:
                access_token = create_access_token(identity=email)
                logger.info("[CUSTOMER_LOGIN] Login successful for email=%s", email)
                return jsonify({
                    "message": response[0],
                    "status": 1,
                    "token": access_token
                }), 200
            else:
                logger.warning("[CUSTOMER_LOGIN] Login failed for email=%s, response=%s", email, response)
                return jsonify({
                    "message": response[0] if response else "Login failed",
                    "status": 0
                }), 401

    except Exception as e:
        logger.exception("[CUSTOMER_LOGIN] Exception occurred for email=%s", email)
        return jsonify({"message": str(e), "status": 0}), 500