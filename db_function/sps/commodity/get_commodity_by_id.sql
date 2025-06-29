DROP PROCEDURE IF EXISTS `get_commodity_by_id`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodity_by_id`(
    IN p_commodity_id INT,
    IN p_created_by   INT
)
BEGIN
    DECLARE err_msg VARCHAR(255);

    -- Error handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', err_msg) AS error_message;
    END;

    -- 1. Validate employee
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE employeeid = p_created_by
    ) THEN
        SELECT 'Error: Invalid employeeid.' AS message;
    ELSE
        -- 2. Check and return commodity details
        IF EXISTS (
            SELECT 1 FROM commodity WHERE commodity_id = p_commodity_id
        ) THEN
            SELECT 
                commodity_id,
                item_name,
                item_photo,
                description,
                min_order_qty,
                max_order_qty,
                price,
                created_at
            FROM commodity
            WHERE commodity_id = p_commodity_id;
        ELSE
            SELECT 'Error: Commodity not found.' AS message;
        END IF;
    END IF;
END$$

DELIMITER ;
