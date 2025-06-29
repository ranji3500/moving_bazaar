DROP PROCEDURE IF EXISTS insert_customer;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_customer`(
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone_number VARCHAR(15),
    IN p_whatsapp_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100),
    IN p_outstanding_price DECIMAL(10,2)
)
BEGIN
    DECLARE new_customer_id INT;
    DECLARE existing_customer_id INT;

    -- Check for duplicate by phone number
    SELECT customer_id INTO existing_customer_id
    FROM customer
    WHERE phone_number = p_phone_number
    LIMIT 1;

    IF existing_customer_id IS NOT NULL THEN
        SELECT existing_customer_id AS customerId, 'Duplicate entry: Customer already exists.' AS message;
    ELSE
        -- Insert new customer
        INSERT INTO customer (
            store_name, email, phone_number, whatsapp_number,
            address_line1, address_line2, city, outstanding_price
        )
        VALUES (
            p_store_name, p_email, p_phone_number, p_whatsapp_number,
            p_address_line1, p_address_line2, p_city, p_outstanding_price
        );

        SET new_customer_id = LAST_INSERT_ID();

        SELECT new_customer_id AS customerId, 'Customer inserted successfully.' AS message;
    END IF;
END$$

DELIMITER ;
