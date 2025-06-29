DROP PROCEDURE IF EXISTS `updateCommodity`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCommodity`( 
    IN p_commodityId INT,
    IN p_itemName VARCHAR(255),
    IN p_itemPhoto VARCHAR(255),
    IN p_description TEXT,
    IN p_minOrderQty INT,
    IN p_maxOrderQty INT,
    IN p_price DECIMAL(10,2),
    IN p_created_by INT
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rowsAffected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- 1. Check if employee ID is valid
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE employeeid = p_created_by
    ) THEN
        SELECT 'Error: Invalid employeeid.' AS message;

    -- 2. Check if commodity exists
    ELSEIF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodityId) THEN

        -- 3. Prevent duplicate item names on other commodities
        IF EXISTS (
            SELECT 1 FROM commodity 
            WHERE item_name = p_itemName AND commodity_id <> p_commodityId
        ) THEN
            SELECT 'error: Another commodity with the same name exists.' AS message;

        -- 4. Perform update
        ELSE
            UPDATE commodity
            SET 
                item_name = COALESCE(p_itemName, item_name),
                item_photo = COALESCE(p_itemPhoto, item_photo),
                description = COALESCE(p_description, description),
                min_order_qty = COALESCE(p_minOrderQty, min_order_qty),
                max_order_qty = COALESCE(p_maxOrderQty, max_order_qty),
                price = COALESCE(p_price, price)
            WHERE commodity_id = p_commodityId;

            SET rowsAffected = ROW_COUNT();

            IF rowsAffected > 0 THEN
                SELECT 'Commodity Updated Successfully' AS message, p_commodityId AS commodityId;
            ELSE
                SELECT 'No changes were made.' AS message;
            END IF;
        END IF;

    -- 5. If commodity not found
    ELSE
        SELECT 'Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;

