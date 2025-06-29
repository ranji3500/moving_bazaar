
DROP PROCEDURE IF EXISTS AdminLogin;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminLogin`(
    IN p_username VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT
        CASE
            WHEN COUNT(*) > 0 THEN 'login successful'
            ELSE 'login failed'
        END AS rmsg
    FROM admin_users
    WHERE ausername = p_username AND password = p_password;
END$$

DELIMITER ;
