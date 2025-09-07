DELIMITER $$

-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS SP_UpdateBillingStatus $$

-- Create the procedure
CREATE PROCEDURE SP_UpdateBillingStatus (
    IN p_billing_id INT,
    IN p_new_status VARCHAR(20)
)
BEGIN
    UPDATE moving_bazaar.billing
    SET payment_status = p_new_status
    WHERE id = p_billing_id;
END $$

DELIMITER ;
