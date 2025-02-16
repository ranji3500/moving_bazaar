CREATE TABLE commodity (
    commodity_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each commodity
    item_name VARCHAR(255) NOT NULL,              -- Name of the commodity
    item_photo VARCHAR(255),                      -- Image URL or path for the item
    min_order_qty INT NOT NULL DEFAULT 1,         -- Minimum order quantity
    max_order_qty INT NOT NULL DEFAULT 10,        -- Maximum order quantity
    price DECIMAL(10,2) NOT NULL DEFAULT 30.00,   -- Default price in AED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Record creation timestamp
);


ALTER TABLE commodity 
ADD CONSTRAINT unique_commodity 
UNIQUE (item_name);


DELIMITER $$

CREATE PROCEDURE insert_commodity(
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_min_order_qty INT,
    IN p_max_order_qty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity already exists
    IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_item_name) THEN
        SELECT 'Error: Commodity already exists with the same name.' AS message;
    ELSE
        -- Insert New Commodity
        INSERT INTO commodity (item_name, item_photo, min_order_qty, max_order_qty, price)
        VALUES (p_item_name, p_item_photo, p_min_order_qty, p_max_order_qty, p_price);

        SELECT 'Commodity inserted successfully.' AS message;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE update_commodity(
    IN p_commodity_id INT,
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_min_order_qty INT,
    IN p_max_order_qty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rows_affected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodity_id) THEN
        -- Prevent duplicate item name
        IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_item_name AND commodity_id <> p_commodity_id) THEN
            SELECT 'Error: Another commodity with the same name exists.' AS message;
        ELSE
            -- Update the commodity record
            UPDATE commodity
            SET 
                item_name = COALESCE(p_item_name, item_name),
                item_photo = COALESCE(p_item_photo, item_photo),
                min_order_qty = COALESCE(p_min_order_qty, min_order_qty),
                max_order_qty = COALESCE(p_max_order_qty, max_order_qty),
                price = COALESCE(p_price, price)
            WHERE commodity_id = p_commodity_id;

            SET rows_affected = ROW_COUNT();

            IF rows_affected > 0 THEN
                SELECT 'Commodity updated successfully.' AS message;
            ELSE
                SELECT 'No changes were made.' AS message;
            END IF;
        END IF;
    ELSE
        SELECT 'Error: Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE delete_commodity(
    IN p_commodity_id INT
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rows_affected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity exists
    DELETE FROM commodity WHERE commodity_id = p_commodity_id;
    
    SET rows_affected = ROW_COUNT();

    IF rows_affected > 0 THEN
        SELECT 'Commodity deleted successfully.' AS message;
    ELSE
        SELECT 'Error: Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_commodity_by_id(
    IN p_commodity_id INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodity_id) THEN
        SELECT commodity_id, item_name, item_photo, min_order_qty, max_order_qty, price, created_at
        FROM commodity
        WHERE commodity_id = p_commodity_id;
    ELSE
        SELECT 'Error: Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;

CALL insert_commodity(' Vege', 'veg_image.jpg', 1, 10, 35.50);

CALL update_commodity(7, 'Fresh', 'fruits.jpg', 2, 15, 40.00);

CALL delete_commodity(7);

CALL get_commodity_by_id(5);


DELIMITER $$

CREATE PROCEDURE get_commodities_list()
BEGIN
    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'SQL Error occurred while fetching commodities' AS message;
    END;

    -- Fetch all commodities
    SELECT commodity_id, item_name, item_photo, min_order_qty, max_order_qty, price, created_at 
    FROM commodity;
END$$

DELIMITER ;


CALL get_commodities_list();





