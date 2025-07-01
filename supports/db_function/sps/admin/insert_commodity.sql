DROP PROCEDURE IF EXISTS insert_customer;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_commodity`(
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_description TEXT,
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
        -- Insert New Commodity with description
        INSERT INTO commodity (item_name, item_photo, description, min_order_qty, max_order_qty, price)
        VALUES (p_item_name, p_item_photo, p_description, p_min_order_qty, p_max_order_qty, p_price);

        SELECT 'Commodity inserted successfully.' AS message;
    END IF;
END$$
DELIMITER;