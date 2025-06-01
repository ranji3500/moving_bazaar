from flask import Flask,  jsonify ,send_from_directory
from web_routes.employee import employee_bp
from web_routes.commodities import commodities_bp
from web_routes.admin import admin_bp
from web_routes.customers import customers_bp
from web_routes.billing import billing_bp
from web_routes.orders import orders_bp
import os

from flask_cors import CORS
from flask_jwt_extended import JWTManager, get_jwt_identity, jwt_required,get_jwt

app = Flask(__name__, static_folder='dist')

app.config['JWT_SECRET_KEY'] = 'mov_123ywdhbsdjsdfs'
app.config["JWT_TOKEN_LOCATION"] = ["headers"]

# Set the upload folder path
UPLOAD_FOLDER = os.path.join(os.getcwd(), 'documents')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
# Optional: Limit upload size (e.g., 16MB max)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB
# Ensure the folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)


jwt = JWTManager(app)
app.register_blueprint(employee_bp, url_prefix='/employee')
app.register_blueprint(commodities_bp, url_prefix='/commodities')
app.register_blueprint(admin_bp, url_prefix='/admin')
app.register_blueprint(customers_bp, url_prefix='/customers')
app.register_blueprint(orders_bp, url_prefix='/orders')
app.register_blueprint(billing_bp, url_prefix='/billing')



CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)
# @app.route('/', methods=['GET'])
# def index():
#     return "backend server is running"

# Serve static files (JS, CSS, etc.)
@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory(os.path.join(app.static_folder, 'static'), filename)

# Catch-all route for SPA
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_react_app(path):
    file_path = os.path.join(app.static_folder, path)
    if path != "" and os.path.exists(file_path):
        return send_from_directory(app.static_folder, path)
    else:
        # Serve index.html for React routing
        return send_from_directory(app.static_folder, 'index.html')



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



from werkzeug.utils import secure_filename

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'pdf'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



if __name__ == '__main__':
    app.run(host='localhost', port=5008, threaded=False,debug =True)




