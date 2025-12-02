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
from web_routes.signup import user_register, check_user

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
    "http://localhost:3000,http://localhost:5173,http://localhost:5004,http://167.71.239.215:5004,http://167.71.239.215:3000"
).split(",")
CORS(
    app,
    resources={r"/*": {"origins": FRONTEND_ORIGINS}},
    supports_credentials=True,
)


# --- Helpers ------------------------------------------------------------------
def allowed_file(filename: str) -> bool:
    logger.debug("allowed_file check for '%s'", filename)
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def maybe_int(value: Optional[str]):
    if isinstance(value, str) and value.isdigit():
        logger.debug("maybe_int conversion: input=%s, output", value)
        return int(value)
    return value


def json_error(message: str, code: int):
    logger.warning("json_error triggered: %s (HTTP %s)", message, code)
    return jsonify({"status": "Failure", "message": message}), code


# --- Health check -------------------------------------------------------------
@app.get("/health")
def health():
    logger.info("Health check endpoint called")
    return jsonify({"status": "ok"}), 200


# --- Static / SPA -------------------------------------------------------------
@app.route("/static/<path:filename>")
def static_files(filename):
    logger.info("Serving static file: %s", filename)
    try:
        return send_from_directory(os.path.join(app.static_folder, "static"), filename)
    except Exception as e:
        logger.exception("Failed to serve static file: %s", filename)
        return json_error(f"Failed to serve static file: {e}", 500)


@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve_react_app(path):
    file_path = os.path.join(app.static_folder, path)
    if path:
        logger.info("Requested SPA path: %s", path)
    try:
        if path and os.path.exists(file_path):
            return send_from_directory(app.static_folder, path)
        return send_from_directory(app.static_folder, "index.html")
    except Exception as e:
        logger.exception("Failed to serve React app for path: %s", path)
        return json_error(f"Failed to serve app: {e}", 500)


# --- JWT: Verify token via flask-jwt-extended --------------------------------
@app.get("/verify_token")
@jwt_required()
def verify_token():
    try:
        user_id = get_jwt_identity()  # set when you created the token
        claims = get_jwt()  # additional claims if you added
        logger.info("Token verified successfully for userId: %s", user_id)
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
    otp = "".join(str(random.randint(0, 9)) for _ in range(length))
    logger.debug("Generated OTP: %s", otp)
    return otp


@app.post("/send_otp")
def send_otp():
    data = request.get_json(silent=True) or {}
    full_name = data.get("fullName")
    email = data.get("email")
    phone = data.get("phone")

    logger.info("OTP request received for fullName: %s, email: %s", full_name, email)

    if not full_name or not email or not phone:
        logger.warning("Missing fullName or email and phone in OTP request")
        return json_error("fullName and email and phone are required", 400)
    try:
        flag = check_user(email, phone)
        if flag:
            otp = generate_otp()
            cache.set(email, otp, timeout=300)
            logger.debug("OTP stored in cache for %s", email)
        if not flag:
            return jsonify({
                "status": "Failure",
                "message": "User already exists",
            }), 409

    except Exception as e:
        logger.exception("Failed to check the user to %s", email)
        return json_error({
            "status": "Failed",
            "message": "Failed to check the user and send OTP email",
        }), 500
    if flag:
        try:
            send_registration_email(email, otp)
            logger.info("OTP sent successfully to %s: %s", email, otp)
        except Exception as e:
            logger.exception("Failed to send registration email to %s", email)
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

    logger.info("OTP verification attempt for email: %s", email)

    if not email or not otp_input:
        logger.warning("Missing email or OTP in verification request")
        return json_error("Email and OTP are required.", 400)

    stored_otp = cache.get(email)
    if stored_otp is None:
        logger.warning("OTP expired or not found for email: %s", email)
        return json_error("OTP expired or not found.", 400)

    if str(otp_input) != str(stored_otp):
        logger.warning("Invalid OTP provided for email: %s", email)
        return json_error("Invalid OTP.", 401)

    # OTP success — clean up
    cache.delete(email)
    logger.info("OTP verified successfully for email: %s", email)

    try:
        params = (
            full_name,
            email,
            phone,
            password,
            "profile.jpg",
            1,  # company_id or similar
            "client",  # role
        )
        result = user_register(params)
        logger.info("Stored procedure response: %s", result)
        if not result:
            logger.error("Stored procedure returned no data!")
            return json_error("Registration failed.", 500)

        message = result.get("message")
        employee_id = result.get("employee_id")

        # If phone already exists
        if employee_id is None:
            logger.warning("Registration failed: %s", message)
            return json_error(message, 409)  # conflict

        logger.info("User registered successfully (ID: %s)", employee_id)
        if employee_id is not None:
            send_welcome_email(email)
            logger.info("User registered successfully and welcome email sent to: %s", email)
    except Exception as e:
        logger.exception("User registration failed for email: %s", email)
        return json_error(f"Registration failed: {e}", 500)

    return jsonify({"status": "Success", "message": "OTP verified successfully ✅"}), 200


@app.post("/upload")
@jwt_required()
def upload_file():
    logger.info("File upload request received from user: %s", get_jwt_identity())

    if "file" not in request.files:
        logger.warning("No file part in request")
        return json_error("No file part in request.", 400)

    file = request.files["file"]
    if file.filename == "":
        logger.warning("No selected file for upload")
        return json_error("No selected file.", 400)

    if not allowed_file(file.filename):
        logger.warning("File type not allowed: %s", file.filename)
        return json_error(
            f"File type not allowed. Allowed: {', '.join(sorted(ALLOWED_EXTENSIONS))}", 400
        )

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
        logger.info("File uploaded successfully: %s", filename)
    except Exception as e:
        logger.exception("File save failed for: %s", filename)
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
    user_id = get_jwt_identity()  # Get user identity from JWT
    safe_name = secure_filename(filename)
    full_path = os.path.join(app.config["UPLOAD_FOLDER"], safe_name)

    logger.info("User %s requested document: %s", user_id, filename)

    if not os.path.exists(full_path):
        logger.warning("Document not found: %s requested by user %s", filename, user_id)
        abort(404)

    try:
        logger.info("Serving document: %s to user %s", filename, user_id)
        return send_from_directory(app.config["UPLOAD_FOLDER"], safe_name)
    except Exception as e:
        logger.exception("Error serving document %s to user %s", filename, user_id)
        return jsonify({"status": "Failure", "message": f"Error serving document: {str(e)}"}), 500


# --- Blueprints ---------------------------------------------------------------
app.register_blueprint(employee_bp, url_prefix="/employee")
app.register_blueprint(commodities_bp, url_prefix="/commodities")
app.register_blueprint(admin_bp, url_prefix="/admin")
app.register_blueprint(customers_bp, url_prefix="/customers")
app.register_blueprint(orders_bp, url_prefix="/orders")
app.register_blueprint(billing_bp, url_prefix="/billing")


# --- Error handlers -----------------------------------------------------------
@app.errorhandler(413)
def too_large(e):
    logger.warning(
        "Request too large: Path=%s Method=%s ClientIP=%s",
        request.path,
        request.method,
        request.remote_addr
    )
    return json_error("File too large. Max 16MB.", 413)


@app.errorhandler(404)
def not_found(e):
    logger.warning(
        "Not Found: Path=%s Method=%s ClientIP=%s",
        request.path,
        request.method,
        request.remote_addr
    )
    return json_error("Not found.", 404)


@app.errorhandler(Exception)
def unhandled(e):
    logger.exception(
        "Unhandled exception: Path=%s Method=%s ClientIP=%s Error=%s",
        request.path,
        request.method,
        request.remote_addr,
        str(e)
    )
    return json_error(f"Server error: {e}", 500)


# --- Entrypoint ---------------------------------------------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5008, threaded=True, debug=True)
