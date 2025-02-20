CREATE TABLE admin_users (
    auserid INT AUTO_INCREMENT PRIMARY KEY,
    ausername VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO admin_users (ausername, password)
VALUES ('ranji', 'ranji123');


DELIMITER $$

CREATE PROCEDURE AdminLogin(
    IN input_username VARCHAR(255),
    IN input_password VARCHAR(255)
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE status INT;
    DECLARE admin_id INT;
    
    -- Check if the admin exists with the given username and password
    SELECT auserid, ausername
    INTO admin_id, input_username
    FROM admin_users
    WHERE ausername = input_username 
      AND password = input_password;
    
    -- If found, set success message
    IF admin_id IS NOT NULL THEN
        SET msg = 'Login successful';
        SET status = 1;
    ELSE
        SET msg = 'Invalid username or password';
        SET status = 0;
        SET admin_id = NULL;
        SET input_username = NULL;
    END IF;

    -- Return login status, admin_id, and message
    SELECT status AS result_status, admin_id AS admin_id, input_username AS username, msg AS message;
END$$

DELIMITER ;

