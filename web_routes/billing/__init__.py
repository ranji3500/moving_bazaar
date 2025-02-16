from flask import Blueprint

# Create the blueprint for commodities
billing_bp = Blueprint('billing', __name__)

# Import the routes for the commodity blueprint
from . import billing
