DROP PROCEDURE IF EXISTS delete_customer;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE delete_customer(
    IN p_customer_id INT
)
BEGIN
    DECLARE fk_count INT;

    -- Check for foreign key usage in orders table
    SELECT COUNT(*) INTO fk_count
    FROM orders
    WHERE sender_id = p_customer_id OR receiver_id = p_customer_id;

    IF fk_count > 0 THEN
        SELECT 'Cannot delete: Customer has linked orders or transactions.' AS message;
    ELSE
        DELETE FROM customer WHERE customer_id = p_customer_id;

        IF ROW_COUNT() > 0 THEN
            SELECT 'Customer deleted successfully.' AS message;
        ELSE
            SELECT 'Customer not found or already deleted.' AS message;
        END IF;
    END IF;
END$$

DELIMITER ;