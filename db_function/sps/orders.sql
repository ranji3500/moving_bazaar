

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each order
    sender_customer_id INT NOT NULL,                -- Sender's customer ID (foreign key from customer table)
    receiver_customer_id INT NOT NULL,              -- Receiver's customer ID (foreign key from customer table)
    total_amount DECIMAL(10, 2) NOT NULL,           -- Total amount for the order
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Order creation timestamp
    FOREIGN KEY (sender_customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (receiver_customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE order_commodities (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for the record
    order_id INT NOT NULL, -- Foreign key referencing orders(order_id)
    productid INT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);



SHOW CREATE TABLE order_commodities;

ALTER TABLE order_commodities DROP FOREIGN KEY order_commodities_ibfk_2;
ALTER TABLE commodities MODIFY productid INT AUTO_INCREMENT;

ALTER TABLE order_commodities
ADD CONSTRAINT order_commodities_ibfk_2
FOREIGN KEY (productid) REFERENCES commodities(productid);


DELIMITER //

CREATE PROCEDURE InsertOrderWithProducts(
    IN sender_id INT,
    IN receiver_id INT,
    IN products JSON
)
BEGIN
    DECLARE total_order_amount DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE new_order_id INT;
    DECLARE current_productid INT;
    DECLARE current_quantity INT;
    DECLARE current_price DECIMAL(10, 2);
    DECLARE current_total_price DECIMAL(10, 2);

    -- Insert into the orders table (auto-increment handles order_id)
    INSERT INTO orders (sender_customer_id, receiver_customer_id, total_amount)
    VALUES (sender_id, receiver_id, 0);

    -- Get the last inserted order ID (auto-incremented order_id)
    SET new_order_id = LAST_INSERT_ID();

    -- Loop through the JSON string to extract and process each product
    WHILE JSON_LENGTH(products) > 0 DO
        -- Extract current productid, quantity, and price
        SET current_productid = CAST(JSON_UNQUOTE(JSON_EXTRACT(products, '$[0].productid')) AS UNSIGNED);
        SET current_quantity = CAST(JSON_UNQUOTE(JSON_EXTRACT(products, '$[0].quantity')) AS UNSIGNED);
        SET current_price = CAST(JSON_UNQUOTE(JSON_EXTRACT(products, '$[0].price')) AS DECIMAL(10, 2));

        -- Calculate total price for the current product
        SET current_total_price = current_quantity * current_price;

        -- Insert into order_commodities table
        INSERT INTO order_commodities (order_id, productid, quantity, total_price)
        VALUES (new_order_id, current_productid, current_quantity, current_total_price);

        -- Add to the total order amount
        SET total_order_amount = total_order_amount + current_total_price;

        -- Remove the first element from the JSON array
        SET products = JSON_REMOVE(products, '$[0]');
    END WHILE;

    -- Update total amount in orders table
    UPDATE orders
    SET total_amount = total_order_amount
    WHERE order_id = new_order_id;

    -- Return the new order ID
    SELECT new_order_id AS order_id;
END //

DELIMITER ;



CALL InsertOrderWithProducts(
    6, -- Sender ID (must exist in customer table)
    7, -- Receiver ID (must exist in customer table)
    '[{"productid": 1, "quantity": 2, "price": 21}, {"productid": 2, "quantity": 1, "price": 30}]'
);

DELIMITER //

CREATE PROCEDURE UpdateOrder(
    IN input_order_id INT,
    IN sender_id INT,
    IN receiver_id INT,
    IN new_total_amount DECIMAL(10, 2)
)
BEGIN
    -- Attempt to update the order
    UPDATE orders
    SET sender_customer_id = sender_id,
        receiver_customer_id = receiver_id,
        total_amount = new_total_amount
    WHERE order_id = input_order_id; -- Use the input parameter in the WHERE clause

    -- Check if any rows were updated
    IF ROW_COUNT() > 0 THEN
        SELECT 'Order updated successfully' AS message;
    ELSE
        SELECT 'No order found with the given order_id' AS message;
    END IF;
END //

DELIMITER ;




CALL UpdateOrder(1, 6, 7, 100.010);

DELIMITER //

CREATE PROCEDURE DeleteOrder(
    IN order_id INT
)
BEGIN
    -- Attempt to delete related records in order_commodities
    DELETE FROM order_commodities WHERE order_id = order_id;

    -- Attempt to delete the order itself
    DELETE FROM orders WHERE order_id = order_id;

    -- Check if any rows were deleted
    IF ROW_COUNT() > 0 THEN
        SELECT 'Order and related items deleted successfully' AS message;
    ELSE
        SELECT 'No order found with the given order_id' AS message;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetOrders()
BEGIN
    -- Check if there are any orders
    IF EXISTS (SELECT 1 FROM orders) THEN
        -- Retrieve all orders
        SELECT * FROM orders;
    ELSE
        -- Return a message if no orders exist
        SELECT 'No orders found' AS message;
    END IF;
END //

DELIMITER ;


CALL GetOrders();



DELIMITER //

CREATE PROCEDURE GetOrderById(
    IN input_order_id INT
)
BEGIN
    -- Check if the order exists
    IF EXISTS (SELECT 1 FROM orders WHERE order_id = input_order_id) THEN
        -- Retrieve the specific order
        SELECT * FROM orders WHERE order_id = input_order_id;
    ELSE
        -- Return a message if the order is not found
        SELECT 'No order found with the given order_id' AS message;
    END IF;
END //

DELIMITER ;

CALL GetOrderById(1);








