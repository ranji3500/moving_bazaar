CREATE TABLE commodity (
    commodity_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each commodity
    item_name VARCHAR(255) NOT NULL,              -- Name of the commodity
    item_photo VARCHAR(255),                      -- Image URL or path for the item
    min_order_qty INT NOT NULL DEFAULT 1,         -- Minimum order quantity
    max_order_qty INT NOT NULL DEFAULT 10,        -- Maximum order quantity
    price DECIMAL(10,2) NOT NULL DEFAULT 30.00,   -- Default price in AED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Record creation timestamp
);


ALTER TABLE commodity 
ADD CONSTRAINT unique_commodity 
UNIQUE (item_name);

ALTER TABLE commodity 
ADD COLUMN description TEXT COMMENT 'Detailed description of the commodity' AFTER item_photo;


DROP PROCEDURE IF EXISTS insertCommodity;
DROP PROCEDURE IF EXISTS updateCommodity;
DROP PROCEDURE IF EXISTS deleteCommodity;
DROP PROCEDURE IF EXISTS getCommodityById;
DROP PROCEDURE IF EXISTS getCommoditiesList;




DELIMITER $$

CREATE PROCEDURE insertCommodity(
    IN p_itemName VARCHAR(255),
    IN p_itemPhoto VARCHAR(255),
    IN p_description TEXT,
    IN p_minOrderQty INT,
    IN p_maxOrderQty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE newCommodityId INT;
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity already exists
    IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_itemName) THEN
        SELECT 'error: Commodity already exists with the same name.' AS message;
    ELSE
        -- Insert New Commodity and get inserted ID
        INSERT INTO commodity (item_name, item_photo, description, min_order_qty, max_order_qty, price)
        VALUES (p_itemName, p_itemPhoto, p_description, p_minOrderQty, p_maxOrderQty, p_price);

        -- Retrieve the last inserted commodity ID
        SET newCommodityId = LAST_INSERT_ID();

        -- Return commodityId along with success message
        SELECT newCommodityId AS commodityId, 'commodityInsertedSuccessfully' AS message;
    END IF;
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE updateCommodity(
    IN p_commodityId INT,
    IN p_itemName VARCHAR(255),
    IN p_itemPhoto VARCHAR(255),
    IN p_description TEXT,
    IN p_minOrderQty INT,
    IN p_maxOrderQty INT,
    IN p_price DECIMAL(10,2)
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
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodityId) THEN
        -- Prevent duplicate item name
        IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_itemName AND commodity_id <> p_commodityId) THEN
            SELECT 'error: Another commodity with the same name exists.' AS message;
        ELSE
            -- Update the commodity record
            UPDATE commodity
            SET 
                item_name = COALESCE(p_itemName, item_name),
                item_photo = COALESCE(p_itemPhoto, item_photo),
                description = COALESCE(p_description, description),
                min_order_qty = COALESCE(p_minOrderQty, min_order_qty),
                max_order_qty = COALESCE(p_maxOrderQty, max_order_qty),
                price = COALESCE(p_price, price)
            WHERE commodity_id = p_commodityId;

            SET rowsAffected = ROW_COUNT();

            IF rowsAffected > 0 THEN
                SELECT 'commodityUpdatedSuccessfully' AS message ,commodity_id As commodity_id;
            ELSE
                SELECT 'error: No changes were made.' AS message;
            END IF;
        END IF;
    ELSE
        SELECT 'error: Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE deleteCommodity(
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
        SELECT 'commodityDeletedSuccessfully' AS message;
    ELSE
        SELECT 'error: Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE getCommodityById(
    IN p_commodityId INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodityId) THEN
        SELECT commodity_id AS commodityId,
               item_name AS itemName,
               item_photo AS itemPhoto,
               description AS description,
               min_order_qty AS minOrderQty,
               max_order_qty AS maxOrderQty,
               price,
               created_at AS createdAt
        FROM commodity
        WHERE commodity_id = p_commodityId;
    ELSE
        SELECT 'error: Commodity not found.' AS message;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE getCommoditiesList()
BEGIN
    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'sqlError: Error occurred while fetching commodities' AS errorMessage;
    END;

    -- Fetch all commodities
    SELECT commodity_id AS commodityId,
           item_name AS itemName,
           item_photo AS itemPhoto,
           description AS description,
           min_order_qty AS minOrderQty,
           max_order_qty AS maxOrderQty,
           price,
           created_at AS createdAt
    FROM commodity;
END$$

DELIMITER ;


CALL insertCommodity('asd', 'veg_image.jpg', 'Fresh oganic vegetables', 1, 10, 35.50);

CALL updateCommodity(44, 'FreshFruit', 'fruits.jpg', 'Seasonal organic fruits', 2, 15, 40.00);

CALL deleteCommodity(45);

CALL getCommodityById(29);

CALL getCommoditiesList();



