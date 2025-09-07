DROP PROCEDURE IF EXISTS GetUsers;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUsers`()
BEGIN
    SELECT
        employeeid,
        employee_full_name,
        employee_email,
        employee_phone_number,
        employee_profile_photo,
        employee_is_admin,
        created_at
    FROM users;
END$$

DELIMITER ;
