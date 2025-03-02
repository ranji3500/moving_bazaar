-- create order using sender id , reciver id ,  createdby

DELIMITER $$

DROP PROCEDURE IF EXISTS create_order$$

CREATE PROCEDURE create_order(
    IN sender_id_param INT,
    IN receiver_id_param INT,
    IN created_by_param INT
)
BEGIN
    DECLARE custom_order_id VARCHAR(8);
    DECLARE error_message VARCHAR(255);
    DECLARE timestamp_part VARCHAR(4);
    DECLARE random_part VARCHAR(4);

    -- ✅ Start a labeled block to use LEAVE properly
    proc_block: BEGIN 

        -- ✅ Start transaction
        START TRANSACTION;

        -- ✅ Check if sender exists
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = sender_id_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Sender does not exist in customer table' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Check if receiver exists
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = receiver_id_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Receiver does not exist in customer table' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Check if created_by user exists (assuming `users` table)
        IF NOT EXISTS (SELECT 1 FROM users WHERE employeeid = created_by_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Created_by user does not exist' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Generate Custom Order ID
        SET timestamp_part = RIGHT(DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), 4);
        SET random_part = LPAD(FLOOR(RAND() * 10000), 4, '0');
        SET custom_order_id = CONCAT(timestamp_part, random_part);

        -- ✅ Insert the new order with the generated order ID
        INSERT INTO orders (order_id, sender_id, receiver_id, created_by, order_status, created_at, updated_at)
        VALUES (custom_order_id, sender_id_param, receiver_id_param, created_by_param, 'In Transit', NOW(), NOW());

        -- ✅ If insertion failed, rollback
        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Could not create Order' AS Message;
            LEAVE proc_block;
        ELSE
            -- ✅ Commit transaction and return success
            COMMIT;
            SELECT 'Success' AS Status, 'Order Created Successfully' AS Message, custom_order_id AS OrderID ,"order" as Ordersatge;
        END IF;

    END proc_block;  -- ✅ End of labeled block

END$$

DELIMITER ;



CALL create_order(12, 13, 10);
