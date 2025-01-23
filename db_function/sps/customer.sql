
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


DELIMITER $$

CREATE PROCEDURE insert_customer(
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100)
)
BEGIN
    DECLARE message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET message = 'Error: Unable to insert customer.';
        SELECT message;
    END;

    INSERT INTO customer (store_name, email, phone_number, address_line1, address_line2, city)
    VALUES (p_store_name, p_email, p_phone_number, p_address_line1, p_address_line2, p_city);

    SET message = 'Customer inserted successfully.';
    SELECT message;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE update_customer(
    IN p_phone_number VARCHAR(15),
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100)
)
BEGIN
    DECLARE message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET message = 'Error: Unable to update customer.';
        SELECT message;
    END;

    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM customer WHERE phone_number = p_phone_number) THEN
        -- Update the customer record
        UPDATE customer
        SET 
            store_name = IFNULL(p_store_name, store_name),
            email = IFNULL(p_email, email),
            address_line1 = IFNULL(p_address_line1, address_line1),
            address_line2 = IFNULL(p_address_line2, address_line2),
            city = IFNULL(p_city, city)
        WHERE phone_number = p_phone_number;

        SET message = 'Customer updated successfully.';
    ELSE
        -- Customer not found
        SET message = 'Error: Customer not found.';
    END IF;

    -- Return the message
    SELECT message;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE delete_customer(
    IN p_phone_number VARCHAR(15)
)
BEGIN
    DECLARE message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET message = 'Error: Unable to delete customer.';
        SELECT message;
    END;

    IF EXISTS (SELECT 1 FROM customer WHERE phone_number = p_phone_number) THEN
        DELETE FROM customer WHERE phone_number = p_phone_number;

        SET message = 'Customer deleted successfully.';
    ELSE
        SET message = 'Error: Customer not found.';
    END IF;

    SELECT message;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_customer_by_phone(
    IN p_phone_number VARCHAR(15)
)
BEGIN
    DECLARE message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET message = 'Error: Unable to retrieve customer.';
        SELECT message;
    END;

    IF EXISTS (SELECT 1 FROM customer WHERE phone_number = p_phone_number) THEN
        SELECT customer_id, store_name, email, phone_number, address_line1, address_line2, city, created_at
        FROM customer
        WHERE phone_number = p_phone_number;

        SET message = 'Customer retrieved successfully.';
    ELSE
        SET message = 'Error: Customer not found.';
        SELECT message;
    END IF;
END$$

DELIMITER ;

ALTER TABLE customer ADD INDEX (phone_number);



CALL insert_customer('karthick Store', 'karthick@example.com', '050000002', '123 Street', 'Area A', 'New York');

CALL update_customer('0500000000', 'New Storef', 'new_email@example.com', '456 New Street', 'Area B', 'Los Angeles');

CALL delete_customer('0500000000');

CALL get_customer_by_phone('0500000000');



