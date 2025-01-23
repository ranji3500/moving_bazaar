CREATE TABLE commodities (
    productid INT AUTO_INCREMENT PRIMARY KEY,
    productname VARCHAR(255),
    productdescription TEXT,
    unit_price DECIMAL(10, 2) DEFAULT 21.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



DELIMITER $$

CREATE PROCEDURE insertCommodity(
    IN p_productname VARCHAR(255),
    IN p_productdescription TEXT,
    IN p_unit_price DECIMAL(10, 2)
)
BEGIN
    INSERT INTO commodities ( productname, productdescription, unit_price)
    VALUES ( p_productname, p_productdescription, p_unit_price);
    SELECT 'Commodity inserted successfully' AS message;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE updateCommodity(
    IN p_productid INT,
    IN p_productname VARCHAR(255),
    IN p_productdescription TEXT,
    IN p_unit_price DECIMAL(10, 2)
)
BEGIN
    UPDATE commodities
    SET productname = p_productname, productdescription = p_productdescription, unit_price = p_unit_price
    WHERE productid = p_productid;
    
    IF ROW_COUNT() > 0 THEN
        SELECT 'Commodity updated successfully' AS message;
    ELSE
        SELECT 'Commodity not found' AS message;
    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE deleteCommodity(
    IN p_productid INT
)
BEGIN
    DELETE FROM commodities WHERE productid = p_productid;
    
    IF ROW_COUNT() > 0 THEN
        SELECT 'Commodity deleted successfully' AS message;
    ELSE
        SELECT 'Commodity not found' AS message;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getCommodities()
BEGIN
    SELECT productid, productname, productdescription, unit_price, created_at
    FROM commodities;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE getCommodityDetails(
    IN p_productid INT
)
BEGIN
    SELECT productid, productname, productdescription, unit_price, created_at
    FROM commodities
    WHERE productid = p_productid;
    
    IF ROW_COUNT() = 0 THEN
        SELECT 'Commodity not found' AS message;
    END IF;
END $$

DELIMITER ;

CALL insertCommodity('Vegetables', 'Fresh vegetables, packed in 10x10x10', 21.00);
CALL insertCommodity('Fruits', 'Fresh vegetables, packed in 10x10x10', 21.00);


CALL updateCommodity(1, 'Organic Vegetables', 'Fresh organic vegetables, packed in 10x10x10', 25.00);

CALL deleteCommodity(1);

CALL getCommodities();

CALL getCommodityDetails(1);


