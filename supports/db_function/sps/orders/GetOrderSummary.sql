DROP PROCEDURE IF EXISTS GetOrderSummary;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderSummary`(
    IN p_order_id INT,
    IN p_employeeid INT
)
BEGIN
    SELECT
        o.order_id AS orderId,
        sender.store_name AS senderName,
        sender.customer_id AS senderId,
        receiver.store_name AS receiverName,
        receiver.customer_id AS receiverId,

        -- Employee Info
        o.created_by AS employeeId,
        u.employee_full_name AS employeeName,
        u.employee_email AS employeeEmail,

        -- Commodity Info as JSON
        (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'itemName', c.item_name,
                    'quantity', oi.quantity,
                    'price', c.price,
                    'totalPrice', oi.quantity * c.price
                )
            )
            FROM moving_bazaar.order_items oi
            JOIN moving_bazaar.commodity c ON oi.commodity_id = c.commodity_id
            WHERE oi.order_id = p_order_id
        ) AS commodities

    FROM
        moving_bazaar.orders o
    JOIN
        moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN
        moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    LEFT JOIN
        moving_bazaar.users u ON o.created_by = u.employeeid
    WHERE
        o.order_id = p_order_id
        AND o.created_by = p_employeeid;
END$$

DELIMITER ;
