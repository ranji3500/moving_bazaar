from flask import Flask
from web_routes.employee import employee_bp
from web_routes.commodities import commodities_bp
from web_routes.admin import admin_bp
from web_routes.customers import customers_bp
from web_routes.billing import billing_bp
from web_routes.orders import orders_bp
from flask_jwt_extended import JWTManager
from flask_cors import CORS

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'mov_123ywdhbsdjsdfs'  
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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5009, threaded=False,debug =True)




