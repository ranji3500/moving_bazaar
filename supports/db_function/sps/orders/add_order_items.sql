DELIMITER $$

DROP PROCEDURE IF EXISTS add_order_items$$

CREATE PROCEDURE add_order_items(
    IN p_order_id INT,
    IN p_commodities JSON
)
BEGIN
    -- ✅ Declare variables
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE commodities_length INT;
    DECLARE commodity_id INT;
    DECLARE quantity INT;
    DECLARE price DECIMAL(10,2);
    DECLARE order_item_id INT;
    DECLARE order_items_list TEXT DEFAULT ''; -- To store all order item IDs
    DECLARE order_exists INT;
    DECLARE items_inserted INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);

    -- ✅ Error Handler for SQL Exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;  -- Rollback on error
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Start labeled block
    proc_block: BEGIN

        -- ✅ Check if the order exists BEFORE inserting items
        SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;

        -- ✅ If order does not exist, return an error message **IMMEDIATELY**
        IF order_exists = 0 THEN
            SELECT 'Failure' AS Status, 'Order ID not found' AS Message, p_order_id AS OrderID;
            LEAVE proc_block;  -- ✅ Exit procedure safely
        END IF;

        -- ✅ Start transaction
        START TRANSACTION;

        -- ✅ Get JSON array length
        SET commodities_length = JSON_LENGTH(p_commodities);

        -- ✅ Loop through JSON array
        WHILE i < commodities_length DO
            -- Extract values
            SET commodity_id = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].commodity_id')));
            SET quantity = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].quantity')));
            SET price = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].price')));

            -- ✅ Ensure commodity exists
            IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = commodity_id) = 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Invalid commodity_id';
            END IF;

            -- ✅ Insert order item
            INSERT INTO order_items (order_id, commodity_id, quantity, total_price)
            VALUES (p_order_id, commodity_id, quantity, price * quantity);

            -- ✅ Check if insertion was successful
            IF ROW_COUNT() > 0 THEN
                -- Get last inserted order_item_id
                SET order_item_id = LAST_INSERT_ID();
                
                -- ✅ Add order_item_id to the list
                IF order_items_list = '' THEN
                    SET order_items_list = order_item_id;
                ELSE
                    SET order_items_list = CONCAT(order_items_list, ', ', order_item_id);
                END IF;
                
                -- ✅ Increase count of inserted items
                SET items_inserted = items_inserted + 1;

                -- ✅ Add to total price
                SET total_price = total_price + (price * quantity);
            END IF;

            -- Move to next item
            SET i = i + 1;
        END WHILE;

        -- ✅ Commit transaction
        COMMIT;

        -- ✅ Return final message **based on items inserted**
        IF items_inserted > 0 THEN
            SELECT 
                'Success' AS Status, 
                'All Order Items Added Successfully' AS Message, 
                p_order_id AS OrderID, 
                order_items_list AS OrderItemIDs, 
                total_price AS TotalPrice;
        ELSE
            SELECT 
                'Failure' AS Status, 
                'No items were added' AS Message, 
                p_order_id AS OrderID;
        END IF;

    END proc_block;  -- ✅ End labeled block

END$$

DELIMITER ;
