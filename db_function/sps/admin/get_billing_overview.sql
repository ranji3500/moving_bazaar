DROP PROCEDURE IF EXISTS get_billing_overview;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_billing_overview`(
    IN status_filter ENUM('All', 'Pending', 'Paid')
)
BEGIN
    SELECT 
        b.billing_id AS billingId,
        CONCAT(sender.store_name, ' - ', receiver.store_name) AS billTitle,
        b.created_at AS createdAt,
        b.payment_status AS paymentStatus,
        b.total_price AS totalPrice,
        b.amount_paid AS amountPaid,
        b.outstanding_amount_paid AS balance,
        b.grand_total AS grandTotal,
        CONCAT(emp.employee_full_name) AS billedBy,
        b.delivery_date AS deliveryDate,
        b.receipt_pdf AS receiptFile,
        sender.store_name AS senderName,
        receiver.store_name AS receiverName

    FROM billing b
    JOIN orders o ON o.order_id = b.order_id
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    LEFT JOIN users emp ON emp.employeeid = b.paid_by
    WHERE 
        status_filter = 'All' OR b.payment_status = status_filter
    ORDER BY b.created_at DESC;
END$$

DELIMITER ;