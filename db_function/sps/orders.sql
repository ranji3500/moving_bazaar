
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


CREATE TABLE billing (
    billing_id VARCHAR(50) PRIMARY KEY,  -- Unique Billing Reference (e.g., BILL-DUBAI-YYYYMMDD-HHMMSS-ORDERID)
    order_id INT NOT NULL,
    user_id INT NOT NULL,  -- The user who created the billing (same as created_by in orders)
    total_price DECIMAL(10,2) NOT NULL,  -- Total cost of the order
    payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,  -- Links to orders
    FOREIGN KEY (user_id) REFERENCES users(employeeid)  -- Links to user who created the billing
);




DELIMITER $$

CREATE PROCEDURE create_order(
    IN sender_id INT,
    IN receiver_id INT,
    IN created_by INT
)
BEGIN
    DECLARE order_id INT;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;

    -- ✅ Error Handler for SQL Exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Insert the new order (Allowing duplicates)
    INSERT INTO orders (sender_id, receiver_id, created_by, order_status)
    VALUES (sender_id, receiver_id, created_by, 'Pending');

    -- ✅ Get the newly created order_id
    SET order_id = LAST_INSERT_ID();

    -- ✅ Return success message with order_id
    SELECT 'Success' AS Status, 'Order Created Successfully' AS Message, order_id AS OrderID;
END$$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE add_order_items(
    IN p_order_id INT,
    IN p_commodities JSON  -- JSON array of commodities (commodity_id, quantity, price)
)
BEGIN
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE commodities_length INT;
    DECLARE commodity_id INT;
    DECLARE quantity INT;
    DECLARE price DECIMAL(10,2);

    -- Step 1: Ensure order_id exists before inserting items
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID does not exist';
    END IF;

    -- Step 2: Get the length of JSON array
    SET commodities_length = JSON_LENGTH(p_commodities);

    -- Step 3: Loop through the JSON array and insert each commodity
    WHILE i < commodities_length DO
        SET commodity_id = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].commodity_id')));
        SET quantity = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].quantity')));
        SET price = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].price')));

        -- Ensure commodity_id exists
        IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = commodity_id) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Invalid commodity_id';
        END IF;

        -- Insert order item
        INSERT INTO order_items (order_id, commodity_id, quantity, total_price)
        VALUES (p_order_id, commodity_id, quantity, price * quantity);

        -- Add to the total price
        SET total_price = total_price + (price * quantity);

        -- Move to the next item
        SET i = i + 1;
    END WHILE;

    -- Return the total price
    SELECT total_price AS 'Total Price';
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE generate_billing(
    IN p_order_id INT,
    IN p_created_by INT
)
BEGIN
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE billing_id VARCHAR(20);
    DECLARE unique_seq INT;
    DECLARE item_count INT;
    DECLARE attempt INT DEFAULT 0;
    DECLARE duplicate_found INT DEFAULT 1; -- 1 means true, 0 means false
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    
    -- ✅ Capture exact MySQL error details
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Ensure `order_id` exists in `orders` table
    SELECT COUNT(*) INTO item_count FROM orders WHERE order_id = p_order_id;
    IF item_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ Ensure `order_id` exists in `order_items`
    SELECT COUNT(*) INTO item_count FROM order_items WHERE order_id = p_order_id;
    IF item_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No items found for this order. Please add items before generating billing.';
    END IF;

    -- ✅ Correct total price calculation using quantity * unit price
    SELECT COALESCE(SUM(oi.quantity * c.price), 0) 
    INTO total_price 
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;

    -- ✅ Generate a unique numeric billing ID (YYYYMMDD + Sequence + Order ID)
    WHILE duplicate_found = 1 AND attempt < 5 DO
        -- Get the last sequence number for today's date
        SELECT COALESCE(MAX(CAST(SUBSTRING(billing_id, 9, 4) AS UNSIGNED)), 0) + 1 
        INTO unique_seq
        FROM billing 
        WHERE SUBSTRING(billing_id, 1, 8) = DATE_FORMAT(NOW(), '%Y%m%d');

        -- Generate the billing ID
        SET billing_id = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(unique_seq, 4, '0'), p_order_id);

        -- Check if the billing ID already exists
        SELECT COUNT(*) INTO item_count FROM billing WHERE billing_id = billing_id;
        IF item_count = 0 THEN
            SET duplicate_found = 0; -- No duplicate found, exit loop
        ELSE
            SET attempt = attempt + 1; -- Retry with next sequence
        END IF;
    END WHILE;

    -- ✅ If max attempts reached, return error
    IF duplicate_found = 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Unable to generate a unique billing ID. Try again later.';
    END IF;

    -- ✅ Insert into `billing` table
    INSERT INTO billing (billing_id, order_id, user_id, total_price, payment_status)
    VALUES (billing_id, p_order_id, p_created_by, total_price, 'Pending');

    -- ✅ If SQL error occurred earlier, return failure response
    IF error_message IS NOT NULL THEN
        SELECT 'Failure' AS Status, error_message AS Message;
    ELSE
        SELECT 'Success' AS Status, billing_id AS 'Billing ID', total_price AS 'Total Price';
    END IF;

END$$

DELIMITER ;







ALTER TABLE order_items 
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE;

CALL create_order(6, 5, 13);


CALL add_order_items(8, '[{"commodity_id": 2, "quantity": 3, "price": 40.00}, {"commodity_id": 5, "quantity": 2, "price": 35.50}]');


CALL generate_billing(7, 13);


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


CALL edit_order(8, 4, 5, 'Processing');

CALL delete_order(8);


CALL get_order(7);


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

CREATE PROCEDURE get_billing_by_order(
    IN p_order_id INT
)
BEGIN
    SELECT 
        b.billing_id, b.order_id, b.user_id, b.total_price, b.payment_status, b.created_at
    FROM billing b
    WHERE b.order_id = p_order_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_billing_by_customer(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        b.billing_id, b.order_id, o.sender_id, o.receiver_id, b.total_price, b.payment_status, b.created_at
    FROM billing b
    JOIN orders o ON b.order_id = o.order_id
    WHERE o.sender_id = p_customer_id OR o.receiver_id = p_customer_id;
END$$

DELIMITER ;


CALL get_order_commodities(7);

CALL get_billing_by_order(7);


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




CALL edit_commodity(2, 'Premium Fresh Fruits', 'new_fruits.jpg', 50.00);


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

CALL edit_order_commodity(7, 2, 5, 45.00);

CALL recalculate_billing_price(8);



