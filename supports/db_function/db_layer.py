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

    def get_data(self, procedure_name):
        connection = self.get_connection()
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.callproc(procedure_name)
            all_rows = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                all_rows.extend(rows)
            return all_rows
        except mysql.connector.Error as err:
            print(f"Error executing procedure '{procedure_name}': {err}")
            raise
        finally:
            cursor.close()
            self.close_connection(connection)

    def call_procedure(self, procedure_name, params=None):
        """
        Call a stored procedure and return structured results with keys.

        :param procedure_name: Name of the procedure.
        :param params: Parameters for the procedure (optional).
        :return: List of dictionaries (each row as a dict with column names as keys).
        """
        connection = self.get_connection()
        try:
            cursor = connection.cursor()

            # Handle procedures with and without parameters
            if params:
                cursor.callproc(procedure_name, params)
            else:
                cursor.callproc(procedure_name)

            print(f"Procedure '{procedure_name}' called successfully.")

            # Fetch results dynamically
            results = []
            for result in cursor.stored_results():
                columns = [desc[0] for desc in result.description]  # Extract column names
                for row in result.fetchall():
                    results.append(dict(zip(columns, row)))  # Convert row to dictionary

            connection.commit()
            return results  # Return structured result
        except mysql.connector.Error as err:
            print(f"Error executing procedure '{procedure_name}': {err}")
            raise
        finally:
            cursor.close()
            self.close_connection(connection)

    def insert_using_procedure(self, procedure_name, params):
        """
        Insert data using a stored procedure and return the output dynamically as a dictionary.

        :param procedure_name: Name of the procedure.
        :param params: Parameters for the procedure.
        :return: Dictionary containing the output message from the stored procedure.
        """
        connection = self.get_connection()
        try:
            cursor = connection.cursor()

            # Call the procedure
            cursor.callproc(procedure_name, params)

            # Fetch the output dynamically
            result_dict = {}
            for result in cursor.stored_results():
                row = result.fetchone()  # Assuming a single row is returned
                if row:
                    columns = [desc[0] for desc in result.description]  # Extract column names dynamically
                    result_dict = dict(zip(columns, row))  # Create dictionary dynamically

            connection.commit()
            print(f"Procedure '{procedure_name}' executed successfully.")
            return result_dict  # Return the result as a dictionary

        except mysql.connector.Error as err:
            print(f"Error executing procedure '{procedure_name}': {err}")
            raise
        finally:
            cursor.close()
            self.close_connection(connection)

    def insertall_using_procedure(self, procedure_name, params):
        """
        Call a stored procedure and return all rows as a list of dictionaries.

        :param procedure_name: Name of the stored procedure.
        :param params: Parameters for the stored procedure.
        :return: List of dictionaries, each representing a row.
        """
        connection = self.get_connection()
        try:
            cursor = connection.cursor()

            # Call the procedure
            cursor.callproc(procedure_name, params)

            result_list = []
            for result in cursor.stored_results():
                columns = [desc[0] for desc in result.description]
                for row in result.fetchall():
                    result_list.append(dict(zip(columns, row)))

            connection.commit()
            print(f"Procedure '{procedure_name}' executed successfully.")
            return result_list  # Return all rows

        except mysql.connector.Error as err:
            print(f"Error executing procedure '{procedure_name}': {err}")
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
