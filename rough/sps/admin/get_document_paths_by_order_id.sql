DROP PROCEDURE IF EXISTS get_document_paths_by_order_id;
DELIMITER $$

CREATE PROCEDURE get_document_paths_by_order_id(IN p_order_id BIGINT)
BEGIN
    SELECT
        doc_id,
        order_id,
        path,
        uploaded_at,
        catagory
    FROM documents
    WHERE order_id = p_order_id;
END $$

DELIMITER ;
