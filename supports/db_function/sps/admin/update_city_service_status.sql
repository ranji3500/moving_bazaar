DROP PROCEDURE IF EXISTS update_city_service_status;
DELIMITER $$

CREATE PROCEDURE update_city_service_status (
    IN p_city_id INT,
    IN p_is_service BOOLEAN
)
BEGIN
    DECLARE affected_rows INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);

    -- Handle errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', error_message) AS message;
    END;

    -- Update city service status
    UPDATE city
    SET is_service = p_is_service
    WHERE c_id = p_city_id;

    SET affected_rows = ROW_COUNT();

    IF affected_rows > 0 THEN
        SELECT 'City service status updated successfully.' AS message;
    ELSE
        SELECT 'No city found with the given ID.' AS message;
    END IF;
END$$

DELIMITER ;
