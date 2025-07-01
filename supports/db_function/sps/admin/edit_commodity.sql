CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_commodity`(
    IN p_commodity_id INT,
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_description TEXT,
    IN p_min_order_qty INT,
    IN p_max_order_qty INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    DECLARE old_price DECIMAL(10,2);
    DECLARE commodity_exists INT;
    DECLARE changes_detected INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_order_id INT;

    -- Declare current values
    DECLARE cur CURSOR FOR
        SELECT DISTINCT order_id FROM order_items WHERE commodity_id = p_commodity_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Step 1: Check if commodity exists
    SELECT COUNT(*) INTO commodity_exists
    FROM commodity
    WHERE commodity_id = TRIM(p_commodity_id);

    IF commodity_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity ID not found';
    END IF;

    -- Step 2: Load current values
    SELECT 
        price, item_name, item_photo, description, min_order_qty, max_order_qty
    INTO 
        old_price, 
        @current_name, 
        @current_photo, 
        @current_desc, 
        @current_min_qty, 
        @current_max_qty
    FROM commodity
    WHERE commodity_id = TRIM(p_commodity_id);

    -- Step 3: Check if any value has changed
    IF (
        @current_name <> p_item_name OR
        @current_photo <> p_item_photo OR
        @current_desc <> p_description OR
        @current_min_qty <> p_min_order_qty OR
        @current_max_qty <> p_max_order_qty OR
        old_price <> p_new_price
    ) THEN
        SET changes_detected = 1;

        -- Step 4: Update the commodity
        UPDATE commodity
        SET 
            item_name = p_item_name,
            item_photo = p_item_photo,
            description = p_description,
            min_order_qty = p_min_order_qty,
            max_order_qty = p_max_order_qty,
            price = p_new_price
        WHERE commodity_id = TRIM(p_commodity_id);

    END IF;

    -- Step 6: Final response
    SELECT 
        'Success' AS Status, 
        CASE 
            WHEN changes_detected = 1 THEN 'Commodity updated successfully'
            ELSE 'No changes detected. Commodity already up-to-date'
        END AS Message;
END