from flask import Blueprint,request ,jsonify



admin_bp = Blueprint('admin', __name__, url_prefix='/admin')

from . import  admin_routes