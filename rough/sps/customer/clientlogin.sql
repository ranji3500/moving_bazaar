DROP PROCEDURE IF EXISTS moving_bazaar.clientLogin;
DELIMITER $$

CREATE PROCEDURE moving_bazaar.clientLogin (
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_customer_id INT;

    -- Try to find a matching customer with given email and password
    SELECT c.customer_id, c.store_name, c.email, c.phone_number, c.city
    FROM moving_bazaar.customer c
    JOIN moving_bazaar.customer_auth a ON c.customer_id = a.customer_id
    WHERE c.email = p_email AND a.password_hash = p_password_hash
    LIMIT 1;
END$$

DELIMITER ;
