DROP PROCEDURE IF EXISTS deleteCommodity;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCommodity`(
    IN p_commodityId INT
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rowsAffected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity exists
    DELETE FROM commodity WHERE commodity_id = p_commodityId;

    SET rowsAffected = ROW_COUNT();

    IF rowsAffected > 0 THEN
        SELECT 'Commodity Deleted Successfully' AS message;
    ELSE
        SELECT 'Commodity not found.' AS message;
    END IF;
END$$
DELIMITER ;