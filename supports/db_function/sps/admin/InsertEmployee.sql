DROP PROCEDURE IF EXISTS InsertEmployee;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmployee`(
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone_number VARCHAR(15),
    IN p_password VARCHAR(255),
    IN p_profile_photo VARCHAR(255),
    IN p_is_admin TINYINT(1)
)
BEGIN
    DECLARE phone_exists INT;

    -- Check if phone number already exists
    SELECT COUNT(*) INTO phone_exists
    FROM users
    WHERE employee_phone_number = p_phone_number;

    IF phone_exists > 0 THEN
        SELECT 'Phone number already exists.' AS message;
    ELSE
        -- Insert the new employee
        INSERT INTO users (
            employee_full_name,
            employee_email,
            employee_phone_number,
            employee_password,
            employee_profile_photo,
            employee_is_admin,
            created_at
        )
        VALUES (
            p_full_name,
            p_email,
            p_phone_number,
            p_password,
            p_profile_photo,
            p_is_admin,
            NOW()
        );

        SELECT 'Employee successfully inserted.' AS message;
    END IF;
END$$

DELIMITER ;
