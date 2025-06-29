
DROP PROCEDURE IF EXISTS GetOrderDetailsbyStagewise;
DELIMITER $$



CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderDetailsbyStagewise`(
    IN p_order_id BIGINT,
    IN p_stage VARCHAR(20),
    INOUT p_employee_id BIGINT
)
BEGIN
    -- ORDER stage: Return customer details in camelCase
    IF p_stage = 'order' THEN
        SELECT
            o.order_id,

            JSON_OBJECT(
                'customerId', sender.customer_id,
                'storeName', sender.store_name,
                'email', sender.email,
                'phoneNumber', sender.phone_number,
                'whatsappNumber', sender.whatsapp_number,
                'addressLine1', sender.address_line1,
                'addressLine2', sender.address_line2,
                'city', sender.city,
                'outstandingPrice', sender.outstanding_price,
                'createdAt', sender.created_at
            ) AS sender,

            JSON_OBJECT(
                'customerId', receiver.customer_id,
                'storeName', receiver.store_name,
                'email', receiver.email,
                'phoneNumber', receiver.phone_number,
                'whatsappNumber', receiver.whatsapp_number,
                'addressLine1', receiver.address_line1,
                'addressLine2', receiver.address_line2,
                'city', receiver.city,
                'outstandingPrice', receiver.outstanding_price,
                'createdAt', receiver.created_at
            ) AS receiver

        FROM moving_bazaar.orders o
        JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
        JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
        WHERE o.order_id = p_order_id AND o.created_by = p_employee_id;

    -- COMMODITY stage: Return commodity and document details
    ELSEIF p_stage = 'commodity' THEN
        SELECT
            oi.order_id,
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'commodityId', c.commodity_id,
                    'itemName', c.item_name,
                    'itemPhoto', c.item_photo,
                    'description', c.description,
                    'minOrderQty', c.min_order_qty,
                    'maxOrderQty', c.max_order_qty,
                    'price', CAST(c.price AS DECIMAL(10,2)),
                    'createdAt', c.created_at,
                    'quantity', oi.quantity,
                    'totalPrice', CAST(oi.total_price AS DECIMAL(10,2))
                )
            ) AS commodities,
            (
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
                WHERE d.order_id = oi.order_id
            ) AS documents
        FROM moving_bazaar.order_items oi
        JOIN moving_bazaar.commodity c ON oi.commodity_id = c.commodity_id
        JOIN moving_bazaar.orders o ON oi.order_id = o.order_id
        WHERE oi.order_id = p_order_id AND o.created_by = p_employee_id
        GROUP BY oi.order_id;
    END IF;

    -- Optional: fetch employee details if needed
    SELECT * FROM moving_bazaar.users WHERE employee_id = p_employee_id;

END &&
DELIMITER ;
