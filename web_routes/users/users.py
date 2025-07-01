
from flask import request, jsonify
from supports.db_function import db
from  . import client_bp
from flask_jwt_extended import create_access_token, jwt_required, get_jwt

import bcrypt




@client_bp.route('/create_customer', methods=['POST'])
@jwt_required()
def create_customer():
    data = request.json
    claims = get_jwt()
    user_id = claims.get('userId')

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
            data.get('password')  # 🚨 This should be already hashed before sending
        )

        # Execute stored procedure and fetch result
        with db.connection.cursor() as cursor:
            cursor.callproc(procedure_name, params)
            for result in cursor.stored_results():
                message_row = result.fetchone()
                break  # Only fetch first result

        if message_row:
            return jsonify({"message": message_row[0]}), 201
        else:
            return jsonify({"error": "No result returned from procedure"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@client_bp.route('/login', methods=['POST'])
def customer_login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"message": "Email and password are required", "status": 0}), 400

    try:
        with db.connection.cursor() as cursor:
            # Step 1: Get stored hash from customer_auth table
            cursor.execute("""
                SELECT a.password_hash
                FROM customer c
                JOIN customer_auth a ON c.customer_id = a.customer_id
                WHERE c.email = %s
                LIMIT 1
            """, (email,))
            result = cursor.fetchone()

            if not result:
                return jsonify({"message": "Invalid email or password", "status": 0}), 401

            stored_hash = result[0]

            # Step 2: Compare entered password with stored hash
            if not bcrypt.checkpw(password.encode('utf-8'), stored_hash.encode('utf-8')):
                return jsonify({"message": "Invalid email or password", "status": 0}), 401

            # Step 3: Call clientLogin stored procedure (returns message + status)
            cursor.callproc('clientLogin', (email, stored_hash))
            for res in cursor.stored_results():
                response = res.fetchone()
                break

            if response and response[1] == 1:
                # Optional: generate JWT token
                access_token = create_access_token(identity=email)

                return jsonify({
                    "message": response[0],
                    "status": 1,
                    "token": access_token  # Optional
                }), 200
            else:
                return jsonify({
                    "message": response[0] if response else "Login failed",
                    "status": 0
                }), 401

    except Exception as e:
        return jsonify({"message": str(e), "status": 0}), 500

