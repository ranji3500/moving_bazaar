from flask import Blueprint

# Create the blueprint for commodities
orders_bp = Blueprint('orders', __name__)

# Import the routes for the commodity blueprint
from . import orders
