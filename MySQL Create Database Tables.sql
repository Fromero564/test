DROP VIEW IF EXISTS vw_StockProducto;
DROP TABLE IF EXISTS Stock, Producto, TipoProducto;
DROP DATABASE IF EXISTS Test;

CREATE DATABASE Test;
USE Test;

CREATE TABLE TipoProducto
(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descripcion varchar(200)
);

CREATE TABLE Producto
(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idTipoProducto int NOT NULL,
    nombre varchar(50),
    precio decimal(10,2) DEFAULT 0,
    FOREIGN KEY (idTipoProducto) REFERENCES TipoProducto(id)
);

CREATE TABLE Stock
(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idProducto int NOT NULL,
    cantidad int DEFAULT 0,
    FOREIGN KEY (idProducto) REFERENCES Producto(id)
);

CREATE VIEW vw_StockProducto AS
SELECT S.idProducto, P.nombre, P.precio, S.cantidad, T.descripcion
FROM Stock S
INNER JOIN Producto P ON P.id = S.idProducto
INNER JOIN TipoProducto T ON T.id = P.idTipoProducto;

DELIMITER //

CREATE PROCEDURE sp_InsertarProducto(
    IN p_idTipoProducto int,
    IN p_nombre varchar(50),
    IN p_precio decimal(10,2),
    IN p_cantidad int)
BEGIN
    INSERT INTO Producto (idTipoProducto, nombre, precio)
    VALUES (p_idTipoProducto, p_nombre, p_precio);
    INSERT INTO Stock (idProducto, cantidad)
    VALUES (LAST_INSERT_ID(), p_cantidad);
END //

CREATE PROCEDURE sp_ModificarProducto(
    IN p_id int,
    IN p_idTipoProducto int,
    IN p_nombre varchar(50),
    IN p_precio decimal(10,2),
    IN p_cantidad int)
BEGIN
    UPDATE Producto
        SET idTipoProducto = p_idTipoProducto, nombre = p_nombre, precio = p_precio
    WHERE p_id = id;
    UPDATE Stock
        SET cantidad = p_cantidad
    WHERE p_id = idProducto;
END //

CREATE PROCEDURE sp_EliminarProducto(
    IN p_id int)
BEGIN
    DELETE FROM Stock
    WHERE p_id = idProducto;
    DELETE FROM Producto
    WHERE p_id = id;
END //

DELIMITER ;

INSERT INTO TipoProducto (descripcion)
VALUES ('Autos');
INSERT INTO TipoProducto (descripcion)
VALUES ('Motos');
INSERT INTO TipoProducto (descripcion)
VALUES ('Camiones');

CALL sp_InsertarProducto(1, 'Volkswagen Gol', 2500000.00, 7);
CALL sp_InsertarProducto(2, 'Yamaha R6', 5700000.00, 2);
CALL sp_InsertarProducto(1, 'Volkswagen Vento', 3550000.00, 2);

CALL sp_ModificarProducto(1, 1, 'Volkswagen Gol', 2500000.00, 4);
CALL sp_ModificarProducto(2, 2, 'Yamaha R6', 5750000.00, 1);

CALL sp_EliminarProducto(3);