DROP PROCEDURE IF EXISTS getDraftOrderDetails;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDraftOrderDetails`(
    IN inOrderStatus VARCHAR(20),
    IN inPageNumber INT,
    IN inPageSize INT,
    IN inEmployeeId INT
)
BEGIN
    DECLARE offsetVal INT;
    DECLARE totalRecords INT;

    SET offsetVal = (inPageNumber - 1) * inPageSize;

    SELECT
        COUNT(*) INTO totalRecords
    FROM
        orders o
    LEFT JOIN
        moving_bazaar.billing b ON o.order_id = b.order_id;

    SELECT totalRecords AS totalRecords;

    IF totalRecords > 0 THEN
        SELECT
            o.order_id AS orderId,
            o.stage AS orderStage,
            o.updated_at AS updatedAt
        FROM
            orders o
        LEFT JOIN
            moving_bazaar.billing b ON o.order_id = b.order_id
        ORDER BY o.updated_at DESC
        LIMIT offsetVal, inPageSize;
    ELSE
        SELECT NULL;
    END IF;
END$$

DELIMITER ;
