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

CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginEmployee`(
    IN input_email VARCHAR(255),
    IN input_password VARCHAR(255)
)
BEGIN
    -- Declare a variable to store the login message
    DECLARE login_message VARCHAR(255);

    -- Check if user exists with the given email and password
    IF EXISTS (
        SELECT 1 
        FROM users
        WHERE employee_email = input_email 
          AND employee_password = input_password
          COLLATE utf8mb4_general_ci -- Case-insensitive comparison
    ) THEN
        -- Set login success message
        SET login_message = 'Login successful';
    ELSE
        -- Set login failure message
        SET login_message = 'Invalid email or password';
    END IF;

    -- Return the login message
    SELECT login_message AS result;
END$$

DELIMITER ;


CALL LoginEmployee('john.doe@example.com', 'hashed_password');

