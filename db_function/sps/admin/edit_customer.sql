DROP PROCEDURE IF EXISTS edit_customer;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_customer`(
    IN p_customer_id INT,
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
    DECLARE customer_exists INT;

    SELECT COUNT(*) INTO customer_exists
    FROM customer
    WHERE customer_id = p_customer_id;

    IF customer_exists = 0 THEN
        SELECT 'Customer not found.' AS message;
    ELSE
        UPDATE customer
        SET
            store_name = p_store_name,
            email = p_email,
            phone_number = p_phone_number,
            whatsapp_number = p_whatsapp_number,
            address_line1 = p_address_line1,
            address_line2 = p_address_line2,
            city = p_city,
            outstanding_price = p_outstanding_price
        WHERE customer_id = p_customer_id;

        SELECT 'Customer updated successfully.' AS message;
    END IF;
END$$

DELIMITER ;
