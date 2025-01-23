from flask import Blueprint

# Create the blueprint for commodities
commodities_bp = Blueprint('commodities', __name__)

# Import the routes for the commodity blueprint
from . import commodities
