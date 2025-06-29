DROP PROCEDURE IF EXISTS getCommodities;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCommodities`()
BEGIN
    SELECT *
    FROM commodity;
END$$

DELIMITER ;
