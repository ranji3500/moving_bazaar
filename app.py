from flask import Flask,  jsonify
from web_routes.employee import employee_bp
from web_routes.commodities import commodities_bp
from web_routes.admin import admin_bp
from web_routes.customers import customers_bp
from web_routes.billing import billing_bp
from web_routes.orders import orders_bp


from flask_cors import CORS
from flask_jwt_extended import JWTManager, get_jwt_identity, jwt_required,get_jwt

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'mov_123ywdhbsdjsdfs'
app.config["JWT_TOKEN_LOCATION"] = ["headers"]


jwt = JWTManager(app)
app.register_blueprint(employee_bp, url_prefix='/employee')
app.register_blueprint(commodities_bp, url_prefix='/commodities')
app.register_blueprint(admin_bp, url_prefix='/admin')
app.register_blueprint(customers_bp, url_prefix='/customers')
app.register_blueprint(orders_bp, url_prefix='/orders')
app.register_blueprint(billing_bp, url_prefix='/billing')


CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)
@app.route('/', methods=['GET'])
def index():
    return "backend server is running"

@app.route('/verify_token', methods=['GET'])
@jwt_required()  # ✅ This validates the token
def verify_token():
    try:
        user_id = get_jwt_identity()  # ✅ Retrieves `employee_id`
        claims = get_jwt()  # ✅ Retrieves additional claims

        return jsonify({
            "message": "Token is valid",
            "data": {
                "userId": int(user_id),
                "userName": claims.get("userName"),
                "email": claims.get("email"),
                "userType": claims.get("user_type")
            }
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 401


if __name__ == '__main__':
    app.run(host='localhost', port=5008, threaded=False,debug =True)




