import mysql.connector
from mysql.connector import pooling

class MySQLDatabase:
    def __init__(self, db_config):
        """Initialize the connection pool"""
        try:
            self.connection_pool = pooling.MySQLConnectionPool(
                pool_name="advanced_pool",
                pool_size=5,
                pool_reset_session=True,
                **db_config
            )
            print("Connection pool created successfully.")
        except mysql.connector.Error as err:
            print(f"Error creating connection pool: {err}")
            raise

    def get_connection(self):
        """Get a connection from the pool"""
        try:
            connection = self.connection_pool.get_connection()
            print("Connection acquired from the pool.")
            return connection
        except mysql.connector.Error as err:
            print(f"Error getting connection: {err}")
            raise

    def close_connection(self, connection):
        """Close a connection and return it to the pool"""
        if connection.is_connected():
            connection.close()
            print("Connection returned to the pool.")

class AdvancedDatabase(MySQLDatabase):
    def __init__(self, db_config):
        """Initialize the parent class"""
        super().__init__(db_config)

    def call_procedure(self, procedure_name, params=None):
        """
        Call a stored procedure.
        :param procedure_name: Name of the procedure.
        :param params: Parameters for the procedure (optional).
        :return: Query result or affected rows.
        """
        connection = self.get_connection()
        try:
            cursor = connection.cursor()
            cursor.callproc(procedure_name, params)
            print(f"Procedure '{procedure_name}' called successfully.")

            # Fetching results for procedures with SELECT statements
            results = []
            for result in cursor.stored_results():
                results.append(result.fetchall())
            return results
        except mysql.connector.Error as err:
            print(f"Error executing procedure '{procedure_name}': {err}")
            raise
        finally:
            cursor.close()
            self.close_connection(connection)

    def insert_using_procedure(self, procedure_name, params):
        """
        Insert data using a stored procedure.
        :param procedure_name: Name of the procedure.
        :param params: Parameters for the procedure.
        :return: Affected rows.
        """
        connection = self.get_connection()
        try:
            cursor = connection.cursor()
            cursor.callproc(procedure_name, params)
            connection.commit()
            print(f"Data inserted using procedure '{procedure_name}'.")
            return cursor.rowcount
        except mysql.connector.Error as err:
            print(f"Error executing insert procedure '{procedure_name}': {err}")
            raise
        finally:
            cursor.close()
            self.close_connection(connection)

    def connection_check(self):
        """
        Check if the database connection is active and functioning.
        :return: True if the connection is valid, False otherwise.
        """
        connection = None
        try:
            connection = self.get_connection()
            if connection.is_connected():
                print("Database connection is active.")
                return True
        except mysql.connector.Error as err:
            print(f"Database connection check failed: {err}")
            return False
        finally:
            if connection:
                self.close_connection(connection)

