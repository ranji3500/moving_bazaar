from flask import Blueprint

# Create the blueprint for commodities
customers_bp = Blueprint('customers', __name__)

# Import the routes for the commodity blueprint
from . import customers
