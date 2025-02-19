CREATE TABLE billing (
    billing_id VARCHAR(50) PRIMARY KEY,  -- Unique Billing Reference (e.g., BILL-DUBAI-YYYYMMDD-HHMMSS-ORDERID)
    order_id INT NOT NULL,
    user_id INT ,  -- The user who created the billing (same as created_by in orders)
    paid_by INT ,  -- ✅ Added customer_id to reference customer table
    total_price DECIMAL(10,2) NOT NULL,  -- Total cost of the order
    payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- ✅ Foreign Key Constraints
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,  -- Links to orders
    FOREIGN KEY (user_id) REFERENCES users(employeeid) ON DELETE SET NULL,  -- Links to user who created the billing
    FOREIGN KEY (paid_by) REFERENCES customer(customer_id) ON DELETE CASCADE  -- ✅ Now correctly references customer table
);

ALTER TABLE billing ADD CONSTRAINT unique_order UNIQUE (order_id);

ALTER TABLE billing 
ADD COLUMN receipt_pdf VARCHAR(255) NULL;  -- Stores the path or URL to the receipt PDF




DELIMITER $$

DROP PROCEDURE IF EXISTS generate_billing$$

CREATE PROCEDURE generate_billing(
    IN p_order_id INT,
    IN p_created_by INT,
    IN p_paid_by INT,
    IN p_outstanding_amount DECIMAL(10,2)
)
BEGIN
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE final_total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE outstanding_price DECIMAL(10,2) DEFAULT 0;
    DECLARE billing_id VARCHAR(50);
    DECLARE customer_id INT;
    DECLARE error_message VARCHAR(255);

    -- ✅ Capture Duplicate Entry Error (Error Code 1062)
    DECLARE CONTINUE HANDLER FOR 1062 
    BEGIN
        SELECT 'Failure' AS Status, 'Error: Billing already exists for this Order ID' AS Message;
    END;

    -- ✅ General Error Handling for Other SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Check if Billing Already Exists for the Order
    IF EXISTS (SELECT 1 FROM billing WHERE order_id = p_order_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing already exists for this Order ID';
    END IF;

    -- ✅ Ensure `p_created_by` exists in `users`
    IF (SELECT COUNT(*) FROM users WHERE employeeid = p_created_by) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Created By User (employeeid) not found in users table';
    END IF;

    -- ✅ Ensure `p_paid_by` exists in `users`
    IF (SELECT COUNT(*) FROM users WHERE employeeid = p_paid_by) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Paid By User (employeeid) not found in users table';
    END IF;

    -- ✅ Fetch Customer ID from Order
    SELECT sender_id INTO customer_id FROM orders WHERE order_id = p_order_id;
    IF customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No customer linked to this order';
    END IF;

    -- ✅ Fetch Outstanding Amount from `customer` Table If Needed
    IF p_outstanding_amount = 0 THEN
        SELECT outstanding_price INTO outstanding_price 
        FROM moving_bazaar.customer 
        WHERE customer_id = customer_id
        LIMIT 1;
    ELSE
        SET outstanding_price = p_outstanding_amount;
    END IF;

    -- ✅ Ensure `order_id` Exists in `orders`
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ Ensure `order_id` has Items in `order_items`
    IF (SELECT COUNT(*) FROM order_items WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No items found for this order. Please add items before generating billing.';
    END IF;

    -- ✅ Calculate Total Price from Order Items
    SELECT COALESCE(SUM(oi.quantity * c.price), 0) 
    INTO total_price 
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;

    -- ✅ Compute Final Total Price (Including Outstanding Amount)
    SET final_total_price = total_price + COALESCE(outstanding_price, 0);

    -- ✅ Generate Unique Billing ID (YYYYMMDD-OrderID)
    SET billing_id = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d'), '-', p_order_id);

    -- ✅ Insert into `billing` Table (Handles Duplicate Entry with `1062`)
    INSERT INTO billing (billing_id, order_id, user_id, paid_by, total_price, payment_status)
    VALUES (billing_id, p_order_id, p_created_by, p_paid_by, final_total_price, 'Pending');

    -- ✅ **Return Success Response Only If INSERT Was Successful**
    IF ROW_COUNT() > 0 THEN
        SELECT 
            'Success' AS Status, 
            billing_id AS 'Billing ID', 
            p_order_id AS 'Order ID',
            p_paid_by AS 'Paid By',
            total_price AS 'Item Total Price', 
            COALESCE(outstanding_price, 0) AS 'Outstanding Amount',
            final_total_price AS 'Final Total Price';
    END IF;

END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS update_billing_by_order$$

CREATE PROCEDURE update_billing_by_order(
    IN p_order_id INT,
    IN p_paid_by INT,
    IN p_total_price DECIMAL(10,2),
    IN p_payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded')
)
BEGIN
    DECLARE billing_exists INT;
    DECLARE billing_id VARCHAR(50);
    DECLARE error_message VARCHAR(255);

    -- ✅ Check if the Order ID has a Billing Record
    SELECT billing_id INTO billing_id FROM billing WHERE order_id = p_order_id LIMIT 1;

    IF billing_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No billing record found for this Order ID';
    END IF;

    -- ✅ Update Billing Details
    UPDATE billing 
    SET 
        paid_by = p_paid_by,
        total_price = p_total_price,
        payment_status = p_payment_status
    WHERE order_id = p_order_id;

    -- ✅ Confirm Update Success
    IF ROW_COUNT() > 0 THEN
        SELECT 
            'Success' AS Status, 
            billing_id AS 'Billing ID',
            p_order_id AS 'Order ID',
            p_paid_by AS 'Updated Paid By',
            p_total_price AS 'Updated Total Price',
            p_payment_status AS 'Updated Payment Status';
    ELSE
        SELECT 'Error' AS Status, 'Update Failed. No changes made.' AS Message;
    END IF;

END$$

DELIMITER ;

DELIMITER $$

-- ✅ Procedure to Delete Billing
DROP PROCEDURE IF EXISTS delete_billing$$

CREATE PROCEDURE delete_billing(
    IN p_billing_id VARCHAR(50)
)
BEGIN
    DECLARE billing_exists INT;

    -- ✅ Check if Billing ID Exists
    SELECT COUNT(*) INTO billing_exists FROM billing WHERE billing_id = p_billing_id;
    
    IF billing_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing ID not found';
    END IF;

    -- ✅ Delete Billing Record
    DELETE FROM billing WHERE billing_id = p_billing_id;

    -- ✅ Return Success Message
    SELECT 
        'Success' AS Status, 
        p_billing_id AS 'Deleted Billing ID';

END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_receipt_pdf$$

CREATE PROCEDURE update_receipt_pdf(
    IN p_order_id INT,
    IN p_receipt_pdf VARCHAR(255)
)
BEGIN
    DECLARE billing_exists INT;

    -- ✅ Check if Billing Exists for Given Order ID
    SELECT COUNT(*) INTO billing_exists FROM billing WHERE order_id = p_order_id;
    
    IF billing_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No billing record found for this Order ID';
    END IF;

    -- ✅ Update the Receipt PDF Path
    UPDATE billing 
    SET receipt_pdf = p_receipt_pdf
    WHERE order_id = p_order_id;

    -- ✅ Return Success Message
    SELECT 
        'Success' AS Status, 
        p_order_id AS 'Order ID',
        p_receipt_pdf AS 'Updated Receipt PDF Path';

END$$

DELIMITER ;





CALL generate_billing(56224403, 10, 5, 50.00);


CALL get_order_commodities(56224403);

CALL get_billing_by_order(56224403);


CALL update_receipt_pdf(56224403, 'https://example.com/receipts/bill')

