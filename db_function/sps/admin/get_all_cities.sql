DROP PROCEDURE IF EXISTS get_all_cities;
DELIMITER $$

CREATE PROCEDURE get_all_cities()
BEGIN
    SELECT c_id, cityname, is_service, created_at
    FROM city
    ORDER BY cityname;
END $$

DELIMITER ;