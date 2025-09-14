import os
import logging
import random
from datetime import timedelta
from typing import Optional

from flask import Flask, request, jsonify, send_from_directory, abort
from flask_caching import Cache
from flask_cors import CORS
from werkzeug.utils import secure_filename

from flask_jwt_extended import (
    JWTManager,
    get_jwt_identity,
    get_jwt,
    jwt_required,
)

# --- Blueprints (your existing modules) --------------------------------------
from web_routes.deliveryboy import (
    commodities_bp,
    employee_bp,
    orders_bp,
    billing_bp,
    customers_bp,
)
from web_routes.admin import admin_bp
from web_routes.welcomegretting import send_welcome_email
from web_routes.registergretting import send_registration_email
from web_routes.signup import user_register

# --- Basic setup --------------------------------------------------------------
os.makedirs("logs", exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("app")

# --- App factory (simple single-file pattern) ---------------------------------
app = Flask(__name__, static_folder="dist")

# Cache (swap to Redis in prod)
app.config["CACHE_TYPE"] = "SimpleCache"
app.config["CACHE_DEFAULT_TIMEOUT"] = 300  # default 5 min
cache = Cache(app)

# Security / JWT
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "dev-only-change-me")
app.config["JWT_TOKEN_LOCATION"] = ["headers"]
# Optional: set token expiry if you mint tokens here
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(hours=8)
jwt = JWTManager(app)

# Uploads
UPLOAD_FOLDER = os.path.join(os.getcwd(), "documents")
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024  # 16MB
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif", "pdf"}

# CORS
FRONTEND_ORIGINS = os.getenv(
    "FRONTEND_ORIGINS",
    "http://localhost:3000,http://localhost:5173",
).split(",")
CORS(
    app,
    resources={r"/*": {"origins": FRONTEND_ORIGINS}},
    supports_credentials=True,
)

# --- Helpers ------------------------------------------------------------------
def allowed_file(filename: str) -> bool:
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

def maybe_int(value: Optional[str]):
    if isinstance(value, str) and value.isdigit():
        return int(value)
    return value

def json_error(message: str, code: int):
    return jsonify({"status": "Failure", "message": message}), code

# --- Health check -------------------------------------------------------------
@app.get("/health")
def health():
    return jsonify({"status": "ok"}), 200

# --- Static / SPA -------------------------------------------------------------
@app.route("/static/<path:filename>")
def static_files(filename):
    return send_from_directory(os.path.join(app.static_folder, "static"), filename)

@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve_react_app(path):
    file_path = os.path.join(app.static_folder, path)
    if path and os.path.exists(file_path):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, "index.html")

# --- JWT: Verify token via flask-jwt-extended --------------------------------
@app.get("/verify_token")
@jwt_required()
def verify_token():
    try:
        user_id = get_jwt_identity()               # set when you created the token
        claims = get_jwt()                          # additional claims if you added
        return jsonify({
            "message": "Token is valid",
            "data": {
                "userId": maybe_int(user_id),
                "userName": claims.get("userName"),
                "email": claims.get("email"),
                "userType": claims.get("user_type"),
            },
        }), 200
    except Exception as e:
        logger.exception("verify_token failed")
        return jsonify({"message": "Token is invalid", "error": str(e)}), 401

# --- OTP flow -----------------------------------------------------------------
def generate_otp(length: int = 6) -> str:
    return "".join(str(random.randint(0, 9)) for _ in range(length))

@app.post("/send_otp")
def send_otp():
    data = request.get_json(silent=True) or {}
    full_name = data.get("fullName")
    email = data.get("email")

    if not full_name or not email:
        return json_error("fullName and email are required", 400)

    otp = generate_otp()
    # store with explicit TTL (uses CACHE_DEFAULT_TIMEOUT if not provided)
    cache.set(email, otp, timeout=300)

    try:
        send_registration_email(email, otp)
        logger.info("OTP generated for %s: %s", email, otp)
    except Exception as e:
        logger.exception("Failed to send registration email")
        return json_error(f"Failed to send OTP email: {e}", 500)

    return jsonify({
        "status": "Success",
        "message": f"OTP sent to {full_name} at {email}",
    }), 200

@app.post("/verify_otp")
def verify_otp():
    data = request.get_json(silent=True) or {}
    email = data.get("email")
    otp_input = data.get("otp")
    full_name = data.get("fullName")
    password = data.get("password")
    phone = data.get("phone")

    if not email or not otp_input:
        return json_error("Email and OTP are required.", 400)

    stored_otp = cache.get(email)
    if stored_otp is None:
        return json_error("OTP expired or not found.", 400)

    if str(otp_input) != str(stored_otp):
        return json_error("Invalid OTP.", 401)

    # OTP success — clean up
    cache.delete(email)

    # Register user (your implementation)
    try:
        params = (
            full_name,
            email,
            phone,
            password,
            "profile.jpg",
            1,            # company_id or similar
            "client",     # role
        )
        user_register(params)
        # Send a welcome email (different template from registration/OTP)
        send_welcome_email(email)
    except Exception as e:
        logger.exception("User registration failed")
        return json_error(f"Registration failed: {e}", 500)

    return jsonify({"status": "Success", "message": "OTP verified successfully ✅"}), 200

# --- Secure upload endpoint ---------------------------------------------------
@app.post("/upload")
@jwt_required()
def upload_file():
    if "file" not in request.files:
        return json_error("No file part in request.", 400)

    file = request.files["file"]
    if file.filename == "":
        return json_error("No selected file.", 400)

    if not allowed_file(file.filename):
        return json_error(f"File type not allowed. Allowed: {', '.join(sorted(ALLOWED_EXTENSIONS))}", 400)

    filename = secure_filename(file.filename)
    save_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)

    # Avoid overwrite: append a counter if exists
    base, ext = os.path.splitext(filename)
    counter = 1
    while os.path.exists(save_path):
        filename = f"{base}_{counter}{ext}"
        save_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
        counter += 1

    try:
        file.save(save_path)
    except Exception as e:
        logger.exception("File save failed")
        return json_error(f"Failed to save file: {e}", 500)

    return jsonify({
        "status": "Success",
        "message": "File uploaded.",
        "filename": filename,
        "path": f"/documents/{filename}",
    }), 201

@app.get("/documents/<path:filename>")
@jwt_required()
def get_document(filename):
    safe_name = secure_filename(filename)
    full_path = os.path.join(app.config["UPLOAD_FOLDER"], safe_name)
    if not os.path.exists(full_path):
        abort(404)
    return send_from_directory(app.config["UPLOAD_FOLDER"], safe_name)

# --- Blueprints ---------------------------------------------------------------
app.register_blueprint(employee_bp, url_prefix="/employee")
app.register_blueprint(commodities_bp, url_prefix="/commodities")
app.register_blueprint(admin_bp, url_prefix="/admin")
app.register_blueprint(customers_bp, url_prefix="/customers")
app.register_blueprint(orders_bp, url_prefix="/orders")
app.register_blueprint(billing_bp, url_prefix="/billing")

# --- Error handlers -----------------------------------------------------------
@app.errorhandler(413)
def too_large(_e):
    return json_error("File too large. Max 16MB.", 413)

@app.errorhandler(404)
def not_found(_e):
    return json_error("Not found.", 404)

@app.errorhandler(Exception)
def unhandled(e):
    logger.exception("Unhandled error")
    return json_error(f"Server error: {e}", 500)

# --- Entrypoint ---------------------------------------------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5008, threaded=True, debug=True)
