DROP PROCEDURE IF EXISTS moving_bazaar.createCustomerWithPass;
DELIMITER $$

CREATE PROCEDURE moving_bazaar.createCustomerWithPass (
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone_number VARCHAR(15),
    IN p_whatsapp_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100),
    IN p_outstanding_price DECIMAL(10,2),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE new_customer_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Email already exists or error occurred' AS response;
    END;

    START TRANSACTION;

    -- Insert into customer table
    INSERT INTO moving_bazaar.customer (
        store_name,
        email,
        phone_number,
        whatsapp_number,
        address_line1,
        address_line2,
        city,
        outstanding_price,
        created_at
    )
    VALUES (
        p_store_name,
        p_email,
        p_phone_number,
        p_whatsapp_number,
        p_address_line1,
        p_address_line2,
        p_city,
        p_outstanding_price,
        CURRENT_TIMESTAMP
    );

    SET new_customer_id = LAST_INSERT_ID();

    -- Insert password hash
    INSERT INTO moving_bazaar.customer_auth (
        customer_id,
        password_hash
    )
    VALUES (
        new_customer_id,
        p_password_hash
    );

    COMMIT;

    -- Return final response with customer ID
    SELECT CONCAT('Customer created successfully with ID: ', new_customer_id) AS response;
END$$

DELIMITER ;
