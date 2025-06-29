DROP PROCEDURE IF EXISTS `get_commodities_list`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodities_list`( 
    IN p_employeeid INT
)
BEGIN
    DECLARE err_msg VARCHAR(255);

    -- SQL Error Handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', err_msg) AS error_message;
    END;

    -- 1. Check if employee exists
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE employeeid = p_employeeid
    ) THEN
        SELECT 'Error: Invalid employeeid.' AS message;
    ELSE
        -- 2. Fetch all commodities
        SELECT 
            commodity_id, 
            item_name, 
            item_photo, 
            min_order_qty, 
            max_order_qty, 
            CAST(price AS DOUBLE) AS price, 
            created_at 
        FROM commodity;
    END IF;
END$$

DELIMITER ;
