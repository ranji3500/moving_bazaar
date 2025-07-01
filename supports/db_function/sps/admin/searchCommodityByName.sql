DROP PROCEDURE IF EXISTS searchCommoditySimilar;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchCommoditySimilar`(
    IN p_searchTerm VARCHAR(100)
)
BEGIN
    SELECT
        commodity_id,
        item_name,
        item_photo,
        description,
        min_order_qty,
        max_order_qty,
        price,
        created_at
    FROM commodity
    WHERE SOUNDEX(item_name) = SOUNDEX(p_searchTerm)
       OR item_name LIKE CONCAT('%', p_searchTerm, '%');
END$$

DELIMITER ;
