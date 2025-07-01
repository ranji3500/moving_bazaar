DROP PROCEDURE IF EXISTS getOrderDetailsByStatus;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderDetailsByStatus`(
    IN inOrderStatus VARCHAR(20),
    IN inOrderId VARCHAR(50),
    IN inDeliveryDate DATE,
    IN inPageNumber INT,
    IN inPageSize INT
)
BEGIN
    DECLARE offsetVal INT;
    DECLARE total INT;

    -- Calculate offset for pagination
    SET offsetVal = (inPageNumber - 1) * inPageSize;

    -- Step 1: Get total matching records
    SELECT COUNT(*) INTO total
    FROM orders o
    JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    JOIN moving_bazaar.billing b ON o.order_id = b.order_id
    WHERE 
        (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
        AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'))
        AND (inDeliveryDate IS NULL OR b.delivery_date = inDeliveryDate);

    -- Return total count
    SELECT total AS totalRecords;

    -- Step 2: Return paginated result if records exist
    IF total > 0 THEN
        SELECT 
            o.order_id AS orderId,
            o.order_status AS orderStatus,
            sender.store_name AS senderName,
            receiver.store_name AS receiverName,
            b.delivery_date AS deliveryDate,
            sender.address_line1 AS senderAddressLine1,
            sender.address_line2 AS senderAddressLine2,
            sender.city AS senderCity,
            receiver.address_line1 AS receiverAddressLine1,
            receiver.address_line2 AS receiverAddressLine2,
            receiver.city AS receiverCity
        FROM orders o
        JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
        JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
        JOIN moving_bazaar.billing b ON o.order_id = b.order_id
        WHERE 
            (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
            AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'))
            AND (inDeliveryDate IS NULL OR b.delivery_date = inDeliveryDate)
        LIMIT offsetVal, inPageSize;
    ELSE
        -- Return single row with NULL if no results
        SELECT NULL AS orderId, NULL AS orderStatus, NULL AS senderName, NULL AS receiverName,
               NULL AS deliveryDate, NULL AS senderAddressLine1, NULL AS senderAddressLine2,
               NULL AS senderCity, NULL AS receiverAddressLine1, NULL AS receiverAddressLine2,
               NULL AS receiverCity;
    END IF;
END$$

DELIMITER ;
