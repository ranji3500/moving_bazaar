DROP PROCEDURE IF EXISTS getOrderDetailsByStatus;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderDetailsByStatus`(
    IN inOrderStatus VARCHAR(20),
    IN inOrderId VARCHAR(50),
    IN inDeliveryDate DATE,
    IN inPageNumber INT,
    IN inPageSize INT,
    IN inEmployeeId INT
)
BEGIN
    DECLARE offsetVal INT;
    DECLARE total INT;

    SET offsetVal = (inPageNumber - 1) * inPageSize;

    -- Step 1: Count
    SELECT COUNT(*) INTO total
    FROM orders o
    JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    JOIN moving_bazaar.billing b ON o.order_id = b.order_id
    WHERE
        (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
        AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'))
        AND (inDeliveryDate IS NULL OR b.delivery_date = inDeliveryDate)
        AND (inEmployeeId IS NULL OR o.created_by = inEmployeeId);  -- Replace `created_by` if different

    SELECT total AS totalRecords;

    -- Step 2: Paginated data
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
            AND (inEmployeeId IS NULL OR o.created_by = inEmployeeId)  -- Replace accordingly
        ORDER BY b.delivery_date DESC
        LIMIT offsetVal, inPageSize;
    ELSE
        SELECT NULL;
    END IF;
END$$

DELIMITER ;
