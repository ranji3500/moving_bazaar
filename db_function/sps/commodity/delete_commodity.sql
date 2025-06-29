DROP PROCEDURE IF EXISTS `delete_commodity`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_commodity`( 
    IN p_commodity_id INT,
    IN p_created_by   INT
)
BEGIN
    DECLARE err_msg VARCHAR(255);

    -- SQL error handler
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
        -- 2. Check if commodity exists
        IF NOT EXISTS (
            SELECT 1 FROM commodity WHERE commodity_id = p_commodity_id
        ) THEN
            SELECT 'Error: Commodity ID not found.' AS message;

        ELSE
            -- 3. Delete from order_items if related
            DELETE FROM order_items WHERE commodity_id = p_commodity_id;

            -- 4. Delete from commodity
            DELETE FROM commodity WHERE commodity_id = p_commodity_id;

            -- 5. Recalculate billing
            CALL recalculate_billing_price();

            -- 6. Success response
            SELECT 'Success' AS Status, 'Commodity deleted successfully' AS Message;
        END IF;
    END IF;
END$$

DELIMITER ;
