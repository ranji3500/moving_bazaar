CREATE DEFINER=`root`@`localhost` PROCEDURE `get_customer_by_phone`(
    IN p_phone_number VARCHAR(15)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if any matching customer exists using LIKE
    IF EXISTS (
        SELECT 1 FROM customer WHERE phone_number LIKE CONCAT('%', p_phone_number, '%')
    ) THEN
        SELECT
            customer_id AS customerId,
            store_name AS storeName,
            email AS email,
            phone_number AS phoneNumber,
            whatsapp_number AS whatsappNumber,
            address_line1 AS addressLine1,
            address_line2 AS addressLine2,
            city AS city,
            outstanding_price AS outstandingPrice,
            created_at AS createdAt
        FROM customer
        WHERE phone_number LIKE CONCAT('%', p_phone_number, '%');
    ELSE
        SELECT 'Error: Customer not found.' AS message;
    END IF;
END