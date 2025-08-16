from flask import Blueprint

commodities_bp = Blueprint('commodities', __name__)
employee_bp = Blueprint('employee', __name__)
orders_bp = Blueprint('orders', __name__)
customers_bp = Blueprint('customers', __name__)
billing_bp = Blueprint('billing', __name__)


from . import billing
from . import commodities
from . import emp_routes
from . import orders
from . import customers