
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each customer
    store_name VARCHAR(255) NOT NULL,            -- Name of the store or customer
    email VARCHAR(255) NOT NULL UNIQUE,          -- Email address of the customer
    phone_number VARCHAR(15) NOT NULL,           -- Phone number of the customer
    address_line1 VARCHAR(255) NOT NULL,         -- First line of the address
    address_line2 VARCHAR(255),                  -- Second line of the address (optional)
    city VARCHAR(100) NOT NULL,                  -- City of the customer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Record creation timestamp
);


ALTER TABLE customers
ADD COLUMN whatsapp_number VARCHAR(15) AFTER phone_number;

ALTER TABLE customer 
ADD COLUMN outstanding_price DECIMAL(10,2) DEFAULT 0.00 AFTER city;



DELIMITER $$

DROP PROCEDURE IF EXISTS insert_customer$$

CREATE PROCEDURE insert_customer(
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
    DECLARE message VARCHAR(255);

    -- Start Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Insert Data
    INSERT INTO customer (store_name, email, phone_number, whatsapp_number, address_line1, address_line2, city, outstanding_price)
    VALUES (p_store_name, p_email, p_phone_number, p_whatsapp_number, p_address_line1, p_address_line2, p_city, p_outstanding_price);

    -- Success Message
    SELECT 'Customer inserted successfully.' AS message;
END$$

DELIMITER ;




DELIMITER $$

DROP PROCEDURE IF EXISTS update_customer$$

CREATE PROCEDURE update_customer(
    IN p_customer_id INT,
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_whatsapp_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100),
    IN p_outstanding_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM customer WHERE customer_id = p_customer_id) THEN
        -- Update the customer record
        UPDATE customer
        SET 
            store_name = IFNULL(p_store_name, store_name),
            email = IFNULL(p_email, email),
            whatsapp_number = IFNULL(p_whatsapp_number, whatsapp_number),
            address_line1 = IFNULL(p_address_line1, address_line1),
            address_line2 = IFNULL(p_address_line2, address_line2),
            city = IFNULL(p_city, city),
            outstanding_price = IFNULL(p_outstanding_price, outstanding_price)
        WHERE customer_id = p_customer_id;

        SELECT 'Customer updated successfully.' AS message;
    ELSE
        SELECT 'Error: Customer not found.' AS message;
    END IF;
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE delete_customer(
    IN p_customer_id INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM customer WHERE customer_id = p_customer_id) THEN
        DELETE FROM customer WHERE customer_id = p_customer_id;
        SELECT 'Customer deleted successfully.' AS message;
    ELSE
        SELECT 'Error: Customer not found.' AS message;
    END IF;
END$$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS get_customer_by_phone$$

CREATE PROCEDURE get_customer_by_phone(
    IN p_phone_number VARCHAR(15)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM customer WHERE phone_number = p_phone_number) THEN
        SELECT customer_id, store_name, email, phone_number, whatsapp_number, address_line1, address_line2, city, outstanding_price, created_at
        FROM customer
        WHERE phone_number = p_phone_number;
    ELSE
        SELECT 'Error: Customer not found.' AS message;
    END IF;
END$$

DELIMITER ;


ALTER TABLE customer ADD INDEX (phone_number);


CALL insert_customer(
    'Vignesh Store', 
    'karthick@example.com', 
    '050000003', 
    '050000004', 
    '123 Street', 
    'Area A', 
    'New York',
    250.75
);


CALL update_customer(
    5,                  
    'New Store Name', 
    'new_email@example.com', 
    '050000002',        
    '456 New Street', 
    'Area B', 
    'Los Angeles',
    150.50
);


CALL delete_customer(2); 

CALL get_customer_by_phone('050000003');


DELIMITER $$

CREATE PROCEDURE GetCustomers()
BEGIN
    SELECT 
        customer_id, 
        store_name, 
        email, 
        phone_number, 
        address_line1, 
        address_line2, 
        city, 
        created_at
    FROM customer;
END $$

DELIMITER ;




