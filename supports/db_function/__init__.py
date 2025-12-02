import os
from dotenv import load_dotenv
from .db_layer import AdvancedDatabase

# Load environment variables
load_dotenv()

# Initialize the database connection
db_config = {
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST'),
    'database': os.getenv('DB_NAME'),
    'port': int(os.getenv('DB_PORT', 3306))  # default 3306 if not set
}

db = AdvancedDatabase(db_config)

