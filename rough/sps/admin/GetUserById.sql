
DROP PROCEDURE IF EXISTS GetUserById;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserById`(IN empId INT)
BEGIN
    SELECT 
        employeeid, 
        employee_full_name, 
        employee_email, 
        employee_phone_number, 
        employee_profile_photo, 
        employee_is_admin, 
        created_at 
    FROM users
    WHERE employeeid = empId;
END$$

DELIMITER ;
