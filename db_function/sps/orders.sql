
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    created_by INT NOT NULL,  -- Tracks the user who created the order
    order_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES customer(customer_id),
    FOREIGN KEY (receiver_id) REFERENCES customer(customer_id),
    FOREIGN KEY (created_by) REFERENCES users(employeeid)  -- Links to user who created the order
);


CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    commodity_id INT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE, -- Linked to orders
    FOREIGN KEY (commodity_id) REFERENCES commodity(commodity_id) -- Linked to commodities
);




CREATE TABLE commodities_photos (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    photo_paths JSON NOT NULL,  -- Stores multiple photo paths in JSON format
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the photos were uploaded
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);




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
        VALUES (custom_order_id, sender_id_param, receiver_id_param, created_by_param, 'Pending', NOW(), NOW());

        -- ✅ If insertion failed, rollback
        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Could not create Order' AS Message;
            LEAVE proc_block;
        ELSE
            -- ✅ Commit transaction and return success
            COMMIT;
            SELECT 'Success' AS Status, 'Order Created Successfully' AS Message, custom_order_id AS OrderID;
        END IF;

    END proc_block;  -- ✅ End of labeled block

END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS add_order_items$$

CREATE PROCEDURE add_order_items(
    IN p_order_id INT,
    IN p_commodities JSON
)
BEGIN
    -- ✅ Declare variables at the beginning
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE commodities_length INT;
    DECLARE commodity_id INT;
    DECLARE quantity INT;
    DECLARE price DECIMAL(10,2);
    DECLARE order_item_id INT;
    DECLARE error_message VARCHAR(255);
    DECLARE order_items_list TEXT DEFAULT ''; -- To store all order item IDs

    -- ✅ Error Handler for SQL Exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;  -- Rollback on error
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Start transaction
    START TRANSACTION;

    -- ✅ Check if the order exists
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID does not exist';
    END IF;

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

        -- Get last inserted order_item_id
        SET order_item_id = LAST_INSERT_ID();

        -- ✅ Add order_item_id to the list
        IF order_items_list = '' THEN
            SET order_items_list = order_item_id;
        ELSE
            SET order_items_list = CONCAT(order_items_list, ', ', order_item_id);
        END IF;

        -- ✅ Add to total price
        SET total_price = total_price + (price * quantity);

        -- Move to next item
        SET i = i + 1;
    END WHILE;

    -- ✅ Commit transaction
    COMMIT;

    -- ✅ Return final success message with order ID, all order item IDs, and total price
    SELECT 
        'Success' AS Status, 
        'All Order Items Added Successfully' AS Message, 
        p_order_id AS OrderID, 
        order_items_list AS OrderItemIDs, 
        total_price AS TotalPrice;
END$$

DELIMITER ;



       

DELIMITER $$

DROP PROCEDURE IF EXISTS insert_commodity_photos$$

CREATE PROCEDURE insert_commodity_photos(
    IN p_order_id INT,
    IN p_photo_paths JSON  -- JSON array of photo paths
)
BEGIN
    DECLARE order_exists INT;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;

    -- ✅ Error Handler for SQL Exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Step 1: Ensure `order_id` exists before inserting photos
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID does not exist';
    END IF;

    -- ✅ Step 2: Insert multiple photo paths as JSON
    INSERT INTO commodities_photos (order_id, photo_paths)
    VALUES (p_order_id, p_photo_paths);

    -- ✅ If SQL error occurred earlier, return failure response
    IF error_message IS NOT NULL THEN
        SELECT 'Failure' AS Status, error_message AS Message;
    ELSE
        -- ✅ Return success message
        SELECT 'Success' AS Status, 'Photos inserted successfully' AS Message, p_photo_paths AS 'Inserted Photos';
    END IF;
END$$

DELIMITER ;


DELIMITER $$


CALL add_order_items(13, '[{"commodity_id": 2, "quantity": 3, "price": 40.00}, {"commodity_id": 5, "quantity": 2, "price": 35.50}]');





ALTER TABLE order_items 
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE;


DELIMITER $$

CREATE PROCEDURE edit_order(
    IN p_order_id INT,
    IN new_sender_id INT,
    IN new_receiver_id INT,
    IN new_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled')
)
BEGIN
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE order_exists INT;

    -- ✅ Error Handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Check if the order exists
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ Update the order
    UPDATE orders 
    SET sender_id = new_sender_id,
        receiver_id = new_receiver_id,
        order_status = new_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE order_id = p_order_id;

    -- ✅ Return success message
    SELECT 'Success' AS Status, 'Order Updated Successfully' AS Message;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE delete_order(
    IN p_order_id INT
)
BEGIN
    -- Ensure order exists
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- Delete the order (Cascade delete will remove order_items and billing)
    DELETE FROM orders WHERE order_id = p_order_id;

    SELECT 'Success' AS Status, 'Order deleted successfully' AS Message;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_order(
    IN p_order_id INT
)
BEGIN
    -- Ensure order exists
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- Retrieve order details
    SELECT 
        o.order_id, o.sender_id, o.receiver_id, o.created_by, o.order_status, o.created_at, o.updated_at,
        SUM(oi.total_price) AS total_price
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_id = p_order_id
    GROUP BY o.order_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_orders_by_user(
    IN p_user_id INT
)
BEGIN
    SELECT 
        order_id, sender_id, receiver_id, order_status, created_at, updated_at
    FROM orders
    WHERE created_by = p_user_id
    ORDER BY created_at DESC;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_orders_by_customer(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        order_id, sender_id, receiver_id, created_by, order_status, created_at, updated_at
    FROM orders
    WHERE sender_id = p_customer_id OR receiver_id = p_customer_id
    ORDER BY created_at DESC;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_orders_by_date(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        order_id, sender_id, receiver_id, created_by, order_status, created_at, updated_at
    FROM orders
    WHERE DATE(created_at) BETWEEN p_start_date AND p_end_date
    ORDER BY created_at DESC;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_order_commodities(
    IN p_order_id INT
)
BEGIN
    SELECT 
        oi.commodity_id, c.item_name, c.item_photo, oi.quantity, oi.total_price
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;
END$$

DELIMITER ;






DELIMITER $$

CREATE PROCEDURE delete_commodity(
    IN p_commodity_id INT
)
BEGIN
    -- Ensure commodity exists
    IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = p_commodity_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity ID not found';
    END IF;

    -- Delete commodity from orders before deleting
    DELETE FROM order_items WHERE commodity_id = p_commodity_id;
    
    -- Delete commodity
    DELETE FROM commodity WHERE commodity_id = p_commodity_id;

    -- Recalculate billing
    CALL recalculate_billing_price();

    SELECT 'Success' AS Status, 'Commodity deleted successfully' AS Message;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE edit_billing(
    IN p_billing_id VARCHAR(50),
    IN p_payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded'),
    IN p_total_price DECIMAL(10,2)
)
BEGIN
    -- Ensure billing exists
    IF (SELECT COUNT(*) FROM billing WHERE billing_id = p_billing_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing ID not found';
    END IF;

    -- Update billing details
    UPDATE billing
    SET payment_status = p_payment_status, total_price = p_total_price
    WHERE billing_id = p_billing_id;

    SELECT 'Success' AS Status, 'Billing updated successfully' AS Message;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE delete_billing(
    IN p_billing_id VARCHAR(50)
)
BEGIN
    -- Ensure billing exists
    IF (SELECT COUNT(*) FROM billing WHERE billing_id = p_billing_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing ID not found';
    END IF;

    -- Delete billing
    DELETE FROM billing WHERE billing_id = p_billing_id;

    SELECT 'Success' AS Status, 'Billing deleted successfully' AS Message;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE update_order_items_price(
    IN p_commodity_id INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    -- Update order_items with new total price
    UPDATE order_items
    SET total_price = quantity * p_new_price
    WHERE commodity_id = p_commodity_id;

    -- Recalculate billing for affected orders
    CALL recalculate_billing_price();

    SELECT 'Success' AS Status, 'Order items updated successfully' AS Message;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE edit_commodity(
    IN p_commodity_id INT,
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    -- ✅ Declare variables at the top
    DECLARE old_price DECIMAL(10,2);

    -- ✅ Ensure commodity exists before proceeding
    IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = p_commodity_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity ID not found';
    END IF;

    -- ✅ Get the old price before updating
    SELECT price INTO old_price FROM commodity WHERE commodity_id = p_commodity_id;

    -- ✅ Safe Update: Using PRIMARY KEY (`commodity_id`) in WHERE clause
    UPDATE commodity 
    SET item_name = p_item_name, 
        item_photo = p_item_photo, 
        price = p_new_price
    WHERE commodity_id = p_commodity_id LIMIT 1;

    -- ✅ If the price has changed, update order items and billing
    IF old_price <> p_new_price THEN
        CALL update_order_items_price(p_commodity_id, p_new_price);
    END IF;

    -- ✅ Return success message
    SELECT 'Success' AS Status, 'Commodity updated successfully' AS Message;
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE edit_order_commodity(
    IN p_order_id INT,
    IN p_commodity_id INT,
    IN p_new_quantity INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    DECLARE old_total_price DECIMAL(10,2);
    DECLARE new_total_price DECIMAL(10,2);
    DECLARE item_exists INT;

    -- ✅ Check if the order and commodity exist
    SELECT COUNT(*) INTO item_exists 
    FROM order_items 
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    IF item_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity not found in this order';
    END IF;

    -- ✅ Get the old total price
    SELECT total_price INTO old_total_price
    FROM order_items 
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    -- ✅ Calculate the new total price
    SET new_total_price = p_new_quantity * p_new_price;

    -- ✅ Update the order_items table
    UPDATE order_items
    SET quantity = p_new_quantity, 
        total_price = new_total_price
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    -- ✅ Update the billing total
    CALL recalculate_billing_price(p_order_id);

    -- ✅ Return success message
    SELECT 'Success' AS Status, 'Order commodity updated successfully' AS Message;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE recalculate_billing_price(
    IN p_order_id INT
)
BEGIN
    DECLARE new_total DECIMAL(10,2);

    -- ✅ Calculate new total price
    SELECT COALESCE(SUM(total_price), 0)
    INTO new_total 
    FROM order_items 
    WHERE order_id = p_order_id;

    -- ✅ Update the billing total price
    UPDATE billing
    SET total_price = new_total
    WHERE order_id = p_order_id;

    SELECT 'Success' AS Status, 'Billing total updated successfully' AS Message, new_total AS NewTotalPrice;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_order_details(
    IN p_order_id INT
)
BEGIN
    DECLARE order_exists INT;

    -- ✅ Check if order exists
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ First Result Set: Order Details (Includes Sender & Receiver Info)
    SELECT 
        o.order_id,
        o.sender_id,
        s.store_name AS sender_name,
        o.receiver_id,
        r.store_name AS receiver_name,
        o.created_by,
        u.employee_full_name AS created_by_name,
        o.order_status,
        o.created_at,
        o.updated_at,
        COALESCE(SUM(oi.quantity * c.price), 0) AS total_price
    FROM orders o
    LEFT JOIN customer s ON o.sender_id = s.customer_id  -- ✅ Get sender info
    LEFT JOIN customer r ON o.receiver_id = r.customer_id  -- ✅ Get receiver info
    LEFT JOIN users u ON o.created_by = u.employeeid  -- ✅ Get created by user info
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE o.order_id = p_order_id
    GROUP BY o.order_id;

    -- ✅ Second Result Set: Billing Details (If Exists)
    SELECT 
        b.billing_id,
        b.total_price AS billing_total_price,
        b.payment_status,
        b.created_at AS billing_created_at
    FROM billing b
    WHERE b.order_id = p_order_id;

    -- ✅ Third Result Set: Order Items
    SELECT 
        oi.order_item_id,
        oi.commodity_id,
        c.item_name AS commodity_name,
        oi.quantity,
        c.price AS price,
        oi.quantity * c.price AS subtotal
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;
END$$

DELIMITER ;




CALL create_order(4, 5, 13);

CALL add_order_items(56224403, '[{"commodity_id": 2, "quantity": 3, "price": 40.00}, {"commodity_id": 5, "quantity": 2, "price": 35.50}]');


CALL edit_order_commodity(56224403, 2, 5, 45.00);

CALL recalculate_billing_price(13);

CALL generate_billing(13, 13);


CALL edit_order(8, 4, 5, 'Processing');

CALL delete_order(8);

CALL get_order(7);

CALL get_order_details(7);

CALL insert_commodity_photos(7, '["uploads/order_7/photo1.jpg", "uploads/order_7/photo2.jpg", "uploads/order_7/photo3.jpg"]');


