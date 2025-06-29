DROP PROCEDURE IF EXISTS `insert_commodity`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_commodity`(
    IN p_item_name       VARCHAR(255),
    IN p_item_photo      VARCHAR(255),
    IN p_description     TEXT,
    IN p_min_order_qty   INT,
    IN p_max_order_qty   INT,
    IN p_price           DECIMAL(10,2),
    IN p_created_by      INT
)
BEGIN
    DECLARE msg VARCHAR(255);

    -- SQL Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 msg = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', msg) AS error_message;
    END;

    -- 1. Validate employee
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE employeeid = p_created_by
    ) THEN
        SELECT 'Error: Invalid employeeid.' AS message;

    -- 2. Check for duplicate item name
    ELSEIF EXISTS (
        SELECT 1 FROM commodity WHERE item_name = p_item_name
    ) THEN
        SELECT 'Error: Commodity already exists with the same name.' AS message;

    -- 3. Insert new commodity
    ELSE
        INSERT INTO commodity (
            item_name, item_photo, description, 
            min_order_qty, max_order_qty, price
        ) VALUES (
            p_item_name, p_item_photo, p_description, 
            p_min_order_qty, p_max_order_qty, p_price
        );

        SELECT 'Commodity inserted successfully.' AS message;
    END IF;
END$$

DELIMITER ;
