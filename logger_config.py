# import logging
# import os
#
#
# def setup_logger(name, log_file, level=logging.INFO):
#     """Function to setup as many loggers as you want"""
#     formatter = logging.Formatter('[%(asctime)s] %(levelname)s in %(name)s: %(message)s')
#
#     handler = logging.FileHandler(log_file)
#     handler.setFormatter(formatter)
#
#     logger = logging.getLogger(name)
#     logger.setLevel(level)
#
#     # Avoid duplicate logs
#     if not logger.handlers:
#         logger.addHandler(handler)
#
#     return logger


import logging
import os
from functools import wraps
from flask import request


# --------------------------------------------------------------------
# Logger setup
# --------------------------------------------------------------------
def setup_logger(name: str, log_file: str, level=logging.INFO) -> logging.Logger:
    """Function to setup loggers writing to file with consistent format"""
    os.makedirs(os.path.dirname(log_file), exist_ok=True)

    formatter = logging.Formatter(
        '[%(asctime)s] %(levelname)s in %(name)s: %(message)s'
    )

    handler = logging.FileHandler(log_file, encoding="utf-8")
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    logger.setLevel(level)

    # Avoid duplicate handlers
    if not logger.handlers:
        logger.addHandler(handler)

    return logger


# --------------------------------------------------------------------
# Create a default app-wide logger
# --------------------------------------------------------------------
app_logger = setup_logger("app", os.path.join("logs", "app.log"))


# --------------------------------------------------------------------
# Trace decorator for functions / routes
# --------------------------------------------------------------------
def trace(func):
    """Decorator to trace entry/exit and exceptions for any function"""

    @wraps(func)
    def wrapper(*args, **kwargs):
        app_logger.info(f"➡️ Entering {func.__name__} args={args} kwargs={kwargs}")
        try:
            result = func(*args, **kwargs)
            app_logger.info(f"✅ Exiting {func.__name__}")
            return result
        except Exception as e:
            app_logger.exception(f"❌ Exception in {func.__name__}: {e}")
            raise

    return wrapper


# --------------------------------------------------------------------
# Flask request/response logging helpers
# --------------------------------------------------------------------
def init_request_logging(app):
    """Attach request/response logging and global error handling to Flask app"""

    @app.before_request
    def log_request_info():
        app_logger.info(
            f"📥 Request: {request.method} {request.path} | IP={request.remote_addr}"
        )

    @app.after_request
    def log_response_info(response):
        app_logger.info(
            f"📤 Response: {request.method} {request.path} | Status={response.status_code}"
        )
        return response

    @app.errorhandler(Exception)
    def unhandled(e):
        app_logger.exception("Unhandled error")
        return {"status": "Failure", "message": f"Server error: {e}"}, 500


# --------------------------------------------------------------------
# Auto-wrap all routes with trace
# --------------------------------------------------------------------
def auto_trace_routes(app):
    """Automatically wrap all Flask routes with @trace after registering blueprints"""
    for rule in app.url_map.iter_rules():
        view_func = app.view_functions[rule.endpoint]
        if not getattr(view_func, "_traced", False):
            app.view_functions[rule.endpoint] = trace(view_func)
            app.view_functions[rule.endpoint]._traced = True
