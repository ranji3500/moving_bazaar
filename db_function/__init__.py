from .db_layer import AdvancedDatabase
# Initialize the database connection
db_config = {
    'user': 'root',
    'password': 'root',
    'host': 'localhost',
    'database': 'moving_bazaar',
    'port': 3306
}
db = AdvancedDatabase(db_config)

