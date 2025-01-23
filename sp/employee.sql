CREATE TABLE users (
    employeeid INT AUTO_INCREMENT PRIMARY KEY,
    employee_full_name VARCHAR(255) NOT NULL,
    employee_email VARCHAR(255) NOT NULL UNIQUE,
    employee_phone_number VARCHAR(15) NOT NULL,
    employee_password VARCHAR(255) NOT NULL,
    employee_profile_photo VARCHAR(255) DEFAULT NULL,
    employee_is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER $$

CREATE PROCEDURE InsertEmployee(
    IN fullName VARCHAR(255),
    IN email VARCHAR(255),
    IN phoneNumber VARCHAR(15),
    IN password VARCHAR(255),
    IN profilePhoto VARCHAR(255),
    IN isAdmin BOOLEAN
)
BEGIN
    INSERT INTO users (employee_full_name, employee_email, employee_phone_number, employee_password, employee_profile_photo, employee_is_admin)
    VALUES (fullName, email, phoneNumber, password, profilePhoto, isAdmin);
END$$

DELIMITER ;


CALL InsertEmployee('Ranjith', 'ranji@example.com', '555-1234', 'hashed_password', NULL, FALSE);

DELIMITER $$

CREATE PROCEDURE UpdateEmployee(
    IN empId INT,
    IN fullName VARCHAR(255),
    IN email VARCHAR(255),
    IN phoneNumber VARCHAR(15),
    IN password VARCHAR(255),
    IN profilePhoto VARCHAR(255),
    IN isAdmin BOOLEAN
)
BEGIN
    UPDATE users
    SET 
        employee_full_name = fullName,
        employee_email = email,
        employee_phone_number = phoneNumber,
        employee_password = password,
        employee_profile_photo = profilePhoto,
        employee_is_admin = isAdmin
    WHERE employeeid = empId;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE DeleteEmployee(
    IN empId INT
)
BEGIN
    DELETE FROM users WHERE employeeid = empId;
END$$

DELIMITER ;

CALL DeleteEmployee(1);


DELIMITER $$

CREATE PROCEDURE ForgotPassword(
    IN email VARCHAR(255),
    IN newPassword VARCHAR(255)
)
BEGIN
    UPDATE users
    SET employee_password = newPassword
    WHERE employee_email = email;
END$$

DELIMITER ;

CALL ForgotPassword('john.doe@example.com', 'new_hashed_password');


DELIMITER $$

CREATE PROCEDURE LoginEmployee(
    IN email VARCHAR(255),
    IN password VARCHAR(255)
)
BEGIN
    DECLARE userExists INT;

    -- Check if user exists with the given email and password
    SELECT COUNT(*) INTO userExists
    FROM users
    WHERE employee_email = email AND employee_password = password;

    -- If the user exists, return their details
    IF userExists > 0 THEN
        SELECT 
            employeeid, 
            employee_full_name, 
            employee_is_admin 
        FROM users
        WHERE employee_email = email;
    ELSE
        -- If no user exists, return an error message
        SELECT 'Invalid email or password' AS message;
    END IF;
END$$

DELIMITER ;

CALL LoginEmployee('john.doe@example.com', 'hashed_password');

