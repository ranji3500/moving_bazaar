from supports.db_function import db



def user_register(params):
    procedure_name = "InsertEmployee"

    rows_affected = db.insert_using_procedure(procedure_name, params)

    return rows_affected