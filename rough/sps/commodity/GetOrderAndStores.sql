DROP PROCEDURE IF EXISTS `GetOrderAndStores`;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderAndStores`( 
    IN inputOrderId INT,
    IN p_employee_id INT
)
BEGIN
    DECLARE vSenderId INT;
    DECLARE vReceiverId INT;
    DECLARE vOrderStatus VARCHAR(50);
    DECLARE vSenderStoreName VARCHAR(255);
    DECLARE vReceiverStoreName VARCHAR(255);
    DECLARE vReasonId INT;
    DECLARE vReasonText VARCHAR(255);
    DECLARE vDeliveryDate DATETIME;
    DECLARE err_msg VARCHAR(255);

    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT JSON_OBJECT('error', CONCAT('SQL Error: ', err_msg)) AS result;
    END;

    -- Step 1: Validate employee ID
    IF NOT EXISTS (
        SELECT 1 FROM moving_bazaar.users WHERE employeeid = p_employee_id
    ) THEN
        SELECT JSON_OBJECT('error', 'Invalid employee ID.') AS result;
    ELSE
        -- Step 2: Fetch order details
        SELECT sender_id, receiver_id, order_status, reason_id
        INTO vSenderId, vReceiverId, vOrderStatus, vReasonId
        FROM moving_bazaar.orders 
        WHERE order_id = inputOrderId;

        -- Step 3: Fetch sender and receiver store names
        SELECT store_name INTO vSenderStoreName
        FROM moving_bazaar.customer 
        WHERE customer_id = vSenderId;

        SELECT store_name INTO vReceiverStoreName
        FROM moving_bazaar.customer 
        WHERE customer_id = vReceiverId;

        -- Step 4: Fetch reason text
        SELECT reason INTO vReasonText
        FROM moving_bazaar.delivery_failure_reasons 
        WHERE reasonid = vReasonId;

        -- Step 5: Fetch delivery date
        SELECT delivery_date INTO vDeliveryDate
        FROM moving_bazaar.billing
        WHERE order_id = inputOrderId;

        -- Step 6: Return final result
        SELECT JSON_OBJECT(
            'orderId', inputOrderId,
            'orderStatus', vOrderStatus,
            'reasonId', vReasonId,
            'reason', vReasonText,
            'senderId', vSenderId,
            'senderName', vSenderStoreName,
            'receiverId', vReceiverId,
            'receiverName', vReceiverStoreName,
            'deliveryDate', vDeliveryDate,
            'documents', (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'documentId', d.doc_id,
                        'documentName', d.path,
                        'requestPath', d.path,
                        'uploadedAt', d.uploaded_at,
                        'category', d.catagory
                    )
                )
                FROM moving_bazaar.documents d
                WHERE d.order_id = inputOrderId
            )
        ) AS result;
    END IF;
END$$

DELIMITER ;
