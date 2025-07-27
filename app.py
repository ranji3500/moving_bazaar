from flask import Flask,send_from_directory
from web_routes.deliveryboy import commodities_bp ,employee_bp,orders_bp,billing_bp,customers_bp
from web_routes.admin import admin_bp
from flask_caching import Cache
import os ,random
from web_routes.welcomegretting import send_welcome_email
from web_routes.registergretting import send_registration_email
os.makedirs("logs", exist_ok=True)

from flask_cors import CORS
from flask_jwt_extended import JWTManager, get_jwt_identity, jwt_required,get_jwt

app = Flask(__name__, static_folder='dist')


# Configure cache (you can switch to Redis in production)
app.config['CACHE_TYPE'] = 'SimpleCache'
app.config['CACHE_DEFAULT_TIMEOUT'] = 300  # OTP valid for 5 minutes
cache = Cache(app)


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


CORS(app,
     resources={r"/*": {"origins": ["http://localhost:3000", "http://localhost:5173"]}},
     supports_credentials=True)


import jwt
from flask import request, jsonify

# Replace with your actual secret key used to sign the JWTs
JWT_SECRET = 'your-secret-key'
JWT_ALGORITHM = 'HS256'

def decode_jwt_from_header():
    auth_header = request.headers.get('Authorization', None)
    if not auth_header or not auth_header.startswith('Bearer '):
        raise Exception('Authorization header is missing or invalid')

    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        raise Exception('Token expired')
    except jwt.InvalidTokenError:
        raise Exception('Invalid token')

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


ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'pdf'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def generate_otp(length=6):
    return ''.join([str(random.randint(0, 9)) for _ in range(length)])


# 1. Send OTP
@app.route('/send_otp', methods=['POST'])
def send_otp():
    data = request.get_json()
    full_name = data.get('fullName')
    email = data.get('email')

    if not full_name or not email:
        return jsonify({
            'status': 'Failure',
            'message': 'fullName and email are required'
        }), 400

    otp = generate_otp()

    # 🔐 Store OTP with expiry (if supported by your cache)
    cache.set(email, otp)  # If using dict, this will just store it directly

    # 📨 Simulate or send email
    send_welcome_email(email, otp)

    # 🐞 Debug info
    print(f"[DEBUG] OTP for {email}: {otp}")
    print(f"[INFO] Simulating OTP sent to email: {email}")

    return jsonify({
        'status': 'Success',
        'message': f'OTP sent to {full_name} at {email}'
    }), 200


# 2. Verify OTP
@app.route('/verify_otp', methods=['POST'])
def verify_otp():
    data = request.get_json()

    email = data.get('email')
    otp_input = data.get('otp')

    if not email or not otp_input:
        return jsonify({
            'status': 'Failure',
            'message': 'Email and OTP are required.'
        }), 400

    # Fetch OTP from cache (like Redis)
    stored_otp = cache.get(email)

    if stored_otp is None:
        return jsonify({
            'status': 'Failure',
            'message': 'OTP expired or not found.'
        }), 400

    # Compare OTPs
    if str(otp_input) == str(stored_otp):  # Ensure string comparison
        cache.delete(email)  # Clean up OTP after successful validation
        send_welcome_email(email)  # Optional: send a welcome/confirmation email

        return jsonify({
            'status': 'Success',
            'message': 'OTP verified successfully ✅'
        }), 200
    else:
        return jsonify({
            'status': 'Failure',
            'message': 'Invalid OTP ❌'
        }), 401


if __name__ == '__main__':
    app.run(host='localhost', port=5008, threaded=True,debug =True)




