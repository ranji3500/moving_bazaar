from supports.db_function import db


def user_register(params):
    procedure_name = "InsertEmployee"

    rows_affected = db.insert_using_procedure(procedure_name, params)

    return rows_affected


def check_user(email,phone):
    procedure_name = "GetAllUserEmailsPhones"

    existing_users = db.get_data(procedure_name)

    for user in existing_users:
        if user["employee_email"] == email or user["employee_phone_number"] == phone:
            return False

    return True
