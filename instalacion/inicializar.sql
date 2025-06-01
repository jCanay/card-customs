CREATE DATABASE IF NOT EXISTS card_customs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE card_customs;

CREATE TABLE IF NOT EXISTS tipo_local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo) REFERENCES tipo_local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    local_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    dni VARCHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (local_id) REFERENCES local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS etiquetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS formato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2) CHECK (precio >= 0) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    etiqueta_id INT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estilos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estado_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    tasa DECIMAL(5, 2)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    estado_id INT NOT NULL DEFAULT 1,
    metodo_pago_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estado_pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    estilo_id INT,
    formato_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(5, 2) NOT NULL DEFAULT 21.00,
    descuento DECIMAL(5, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (estilo_id) REFERENCES estilos(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (formato_id) REFERENCES formato(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS historial_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_final INT NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS seguimiento_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_anterior VARCHAR(25),
    estado_nuevo VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

DELIMITER //
CREATE FUNCTION calcular_subtotal_factura (precio DECIMAL(10,2), formato_precio DECIMAL(10,2), cantidad INT, iva DECIMAL(5,2), descuento DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE precio_formato DECIMAL (10,2) DEFAULT (precio + formato_precio);
    DECLARE precio_iva DECIMAL(10,2) DEFAULT (precio_formato + (precio_formato * iva / 100));
    DECLARE precio_iva_descuento DECIMAL(10, 2) DEFAULT (precio_iva - (precio_iva * descuento / 100));
    DECLARE subtotal DECIMAL(10,2) DEFAULT (precio_iva_descuento * cantidad);
    
    RETURN subtotal;
END;
// DELIMITER ;

DELIMITER //
CREATE FUNCTION calcular_total_factura (subtotal DECIMAL(10,2), tasa DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2) DEFAULT (subtotal + (subtotal * tasa / 100));

    RETURN total;
END;
// DELIMITER ;

DELIMITER //
CREATE FUNCTION obtener_stock_producto(producto_id INT)
RETURNS INT	
DETERMINISTIC
BEGIN
    RETURN (SELECT stock FROM productos WHERE id = producto_id);
END;
// DELIMITER ;

DELIMITER //
CREATE FUNCTION obtener_nombre_estado(estado_id INT)
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    RETURN (SELECT nombre FROM estado_pedido WHERE id = estado_id);
END;
// DELIMITER ;

DELIMITER //
CREATE FUNCTION mayor_salario_empleados()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT e.salario FROM empleados e ORDER BY salario DESC LIMIT 1);
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER insertar_precio_unitario_detalle_pedidos 
BEFORE INSERT ON detalle_pedidos 
FOR EACH ROW
BEGIN
    SET NEW.precio_unitario = (SELECT p.precio FROM productos p WHERE id = NEW.producto_id);
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER comprobar_actualizar_stock_detalle_pedido_INSERT
BEFORE INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
	DECLARE diferencia INT DEFAULT (obtener_stock_producto(NEW.producto_id) - NEW.cantidad);
    
	IF (diferencia < 0) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock';
	ELSE 
		UPDATE productos SET stock = stock - NEW.cantidad WHERE id = NEW.producto_id;
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER comprobar_actualizar_stock_detalle_pedido_UPDATE
BEFORE UPDATE ON detalle_pedidos
FOR EACH ROW
BEGIN
	IF (NEW.cantidad > OLD.cantidad) THEN 
		IF (obtener_stock_producto(OLD.producto_id) - (NEW.cantidad - OLD.cantidad) < 0) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock';
		END IF;
		UPDATE productos SET stock = stock - (NEW.cantidad - OLD.cantidad) WHERE id = OLD.producto_id;
	ELSEIF (NEW.cantidad < OLD.cantidad) THEN
		UPDATE productos SET stock = stock + (OLD.cantidad - NEW.cantidad) WHERE id = OLD.producto_id;
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER registrar_pedidos_historial
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
	IF (NEW.estado_id IN (4, 5)) THEN
		INSERT INTO historial_pedidos (pedido_id, fecha_registro, estado_final) VALUES (NEW.id, now(), NEW.estado_id);
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER comprobar_proceso_logistico
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN 
	IF (OLD.estado_id = 1 AND NEW.estado_id = 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado no puede pasar directamente de "Pendiente" a "Enviado"';
	ELSEIF (OLD.estado_id = 1 AND NEW.estado_id = 4) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado no puede pasar directamente de "Pendiente" a "Entregado"';
	ELSEIF (OLD.estado_id = 2 AND NEW.estado_id = 1) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede volver del estado "En preparación" al estado "Pendiente"';
	ELSEIF (OLD.estado_id = 2 AND NEW.estado_id = 4) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado no puede pasar directamente de "En preparación" a "Entregado"';
	ELSEIF (OLD.estado_id = 3 AND NEW.estado_id = 1) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede volver del estado "Enviado" al estado "Pendiente"';
	ELSEIF (OLD.estado_id = 3 AND NEW.estado_id = 2) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede volver del estado "Enviado" al estado "En preparación"';
	ELSEIF (OLD.estado_id IN (4, 5) AND NEW.estado_id IN (1, 2, 3, 4, 5)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido ha llegado a su estado final y no puede ser modificado';
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER registrar_seguimiento_inicial_pedidos
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
	INSERT INTO seguimiento_pedidos (pedido_id, fecha_registro, estado_anterior, estado_nuevo) VALUES (NEW.id, now(), NULL, obtener_nombre_estado(NEW.estado_id));
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER registrar_seguimiento_pedidos
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
	INSERT INTO seguimiento_pedidos (pedido_id, fecha_registro, estado_anterior, estado_nuevo) VALUES (OLD.id, now(), obtener_nombre_estado(OLD.estado_id), obtener_nombre_estado(NEW.estado_id));
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtener_factura_detallada_pedido(pedido_id INT)
BEGIN
	SELECT pe.id, pe.fecha_pedido, c.nombre, c.apellidos, pr.nombre, f.nombre, e.nombre, dp.precio_unitario, dp.cantidad, dp.iva, dp.descuento
	FROM detalle_pedidos dp JOIN pedidos pe ON pe.id = dp.pedido_id JOIN clientes c ON c.id = pe.cliente_id JOIN formato f ON f.id = dp.formato_id LEFT JOIN estilos e ON dp.estilo_id = e.id JOIN productos pr ON pr.id = dp.producto_id
	WHERE dp.pedido_id = pedido_id;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE agregar_producto_pedido(pedido_id INT, producto_id INT, estilo_id INT, formato_id INT, cantidad INT, descuento DECIMAL(5,2))
BEGIN
	IF ((producto_id, estilo_id, formato_id, descuento) IN (SELECT dp.producto_id, dp.estilo_id, dp.formato_id, dp.descuento FROM detalle_pedidos dp WHERE dp.pedido_id = pedido_id)) THEN
		UPDATE detalle_pedidos dp SET dp.cantidad = dp.cantidad + cantidad WHERE dp.pedido_id = pedido_id AND dp.producto_id = producto_id AND dp.estilo_id = estilo_id AND dp.formato_id = formato_id;
	ELSE
		INSERT INTO detalle_pedidos (pedido_id, producto_id, estilo_id, formato_id, cantidad, descuento) VALUES
		(pedido_id, producto_id, estilo_id, formato_id, cantidad, descuento);
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE listar_facturas_cliente(cliente_id INT)
BEGIN
	SELECT f.*, ep.nombre estado FROM facturas f JOIN pedidos pe ON f.pedido_id = pe.id JOIN clientes c ON c.id = pe.cliente_id JOIN estado_pedido ep ON ep.id = pe.estado_id WHERE c.id = cliente_id;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE actualizar_siguiente_estado_pedido(pedido_id INT)
BEGIN
	IF ((SELECT pe.estado_id FROM pedidos pe WHERE pe.id = pedido_id) + 1 < 4) THEN
		UPDATE pedidos pe SET pe.estado_id = pe.estado_id + 1 WHERE pe.id = pedido_id;
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE entregar_pedido(pedido_id INT)
BEGIN
	UPDATE pedidos SET estado_id = 4 WHERE id = pedido_id;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE cancelar_pedido(pedido_id INT)
BEGIN
	UPDATE pedidos SET estado_id = 5 WHERE id = pedido_id;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE ver_actualizaciones_estado_pedido(pedido_id INT)
BEGIN
	SELECT * FROM seguimiento_pedidos s WHERE s.pedido_id = pedido_id;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE ver_empleados_local(local_id INT)
BEGIN
	SELECT e.nombre, e.apellidos, t.nombre tipo, l.direccion, l.localidad, l.email, l.telefono FROM empleados e JOIN local l ON l.id = e.local_id JOIN tipo_local t ON t.id = l.tipo WHERE l.id = local_id;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE eliminar_cliente_completo(cliente_id INT)
BEGIN
	DELETE FROM detalle_pedidos dp WHERE dp.pedido_id IN (SELECT pe.id FROM pedidos pe WHERE pe.cliente_id = cliente_id);
	DELETE FROM pedidos pe WHERE pe.cliente_id = cliente_id;
	DELETE FROM clientes WHERE id = cliente_id;
END;
// DELIMITER ;

CREATE VIEW facturas AS
SELECT pe.id pedido_id, pe.fecha_pedido, c.nombre, c.apellidos, m.nombre metodo_pago, m.tasa tarifa, round(sum(calcular_subtotal_factura(dp.precio_unitario, f.precio ,dp.cantidad, dp.iva, dp.descuento)), 2) subtotal, round(sum(calcular_total_factura(calcular_subtotal_factura(dp.precio_unitario, f.precio, dp.cantidad, dp.iva, dp.descuento), m.tasa)), 2) total
FROM pedidos pe 
	JOIN detalle_pedidos dp ON pe.id = dp.pedido_id 
	JOIN formato f ON f.id = dp.formato_id 
	JOIN metodos_pago m ON m.id = pe.metodo_pago_id 
	JOIN clientes c ON pe.cliente_id = c.id 
GROUP BY pe.id;

CREATE VIEW pedidos_finalizados AS
SELECT h.pedido_id, pe.fecha_pedido, h.fecha_registro, ep.nombre estado_final, concat((datediff(h.fecha_registro, pe.fecha_pedido)), ' días') duracion
FROM historial_pedidos h 
	JOIN estado_pedido ep ON ep.id = h.estado_final 
	JOIN pedidos pe ON pe.id = h.pedido_id;















INSERT INTO tipo_local (nombre) VALUES
('Tienda'),
('Taller'),
('Almacen');

INSERT INTO local (tipo, direccion, localidad, email, telefono) VALUES
(1, 'Calle Mayor 123', 'Madrid', 'madrid@cardcustoms.com', '912345678'),
(2, 'Avenida Innovación 45', 'Barcelona', 'barcelona@cardcustoms.com', '932109876'),
(3, 'Polígono Industrial s/n', 'Valencia', 'valencia@cardcustoms.com', '965432109');

INSERT INTO empleados (local_id, nombre, apellidos, dni, email, telefono, fecha_contratacion, salario) VALUES
(1, 'Ana', 'García Pérez', '11111111A', 'ana.garcia@cardcustoms.com', '600111222', '2022-01-15', 1800.00),
(1, 'Luis', 'Martínez Ruiz', '22222222B', 'luis.martinez@cardcustoms.com', '600333444', '2021-06-01', 1950.00),
(2, 'Marta', 'Fernández López', '33333333C', 'marta.fernandez@cardcustoms.com', '600555666', '2023-03-10', 2200.00),
(3, 'Javier', 'Sánchez Gil', '44444444D', 'javier.sanchez@cardcustoms.com', '600777888', '2020-09-20', 2000.00),
(1, 'Sofía', 'Ramírez Blanco', '55555555E', 'sofia.ramirez@cardcustoms.com', '600999000', '2023-01-20', 1750.00),
(2, 'Pedro', 'González Torres', '66666666F', 'pedro.gonzalez@cardcustoms.com', '600123456', '2022-07-01', 2100.00),
(3, 'Elena', 'Vázquez Costa', '77777777G', 'elena.vazquez@cardcustoms.com', '600789012', '2021-02-14', 1900.00),
(1, 'Ricardo', 'Jiménez Soler', '88888888H', 'ricardo.jimenez@cardcustoms.com', '600345678', '2024-04-01', 1850.00),
(2, 'Isabel', 'Moreno Vargas', '99999999I', 'isabel.moreno@cardcustoms.com', '600901234', '2022-11-11', 2050.00),
(3, 'Juan', 'Ruiz Castro', '10101010J', 'juan.ruiz@cardcustoms.com', '600567890', '2023-08-25', 1700.00);

INSERT INTO clientes (nombre, apellidos, email, direccion, telefono) VALUES
('Carlos', 'Díaz Soto', 'carlos.diaz@example.com', 'Paseo de la Castellana 10, Madrid', '611223344'),
('Laura', 'Herrera Vidal', 'laura.herrera@example.com', 'Gran Vía 50, Barcelona', '622334455'),
('Pedro', 'Ruiz Gómez', 'pedro.ruiz@example.com', 'Calle Colón 20, Valencia', '633445566'),
('Elena', 'Blanco Cruz', 'elena.blanco@example.com', 'Calle de Toledo 8, Madrid', '644556677'),
('Miguel', 'Santos Prieto', 'miguel.santos@example.com', 'Rambla Cataluña 5, Barcelona', '655667788'),
('Sofía', 'López García', 'sofia.lopez@example.com', 'Calle Mayor 1, Madrid', '666778899'),
('Jorge', 'Fernández Gil', 'jorge.fernandez@example.com', 'Av. del Puerto 30, Valencia', '677889900'),
('Ana', 'Pérez Moreno', 'ana.perez@example.com', 'Plaza España 15, Madrid', '688990011'),
('Daniel', 'Navarro Torres', 'daniel.navarro@example.com', 'Diagonal 200, Barcelona', '699001122'),
('Lucía', 'Gómez Martín', 'lucia.gomez@example.com', 'Calle de la Paz 7, Valencia', '600112233');

INSERT INTO etiquetas (nombre, descripcion) VALUES
('Nuevo', 'Producto recién añadido al catálogo'),
('Popular', 'Uno de nuestros productos más vendidos'),
('Oferta', 'Producto con descuento especial');

INSERT INTO formato (nombre, descripcion, precio) VALUES
('Estándar', 'Sin formato. Carta original', 0.00),
('Arte', 'Formato tipo carta personalizado', 59.99),
('Póster', 'Formato póster estándar impreso', 4.99),
('Cuadro', 'Formato cuadro', 24.99),
('Lienzo', 'Formato lienzo', 79.99);

INSERT INTO productos (nombre, descripcion, etiqueta_id, precio, stock) VALUES
('MTG Lightning Bolt', 'Un hechizo de daño directo icónico en MTG', 2, 8.50, 50),
('MTG Counterspell', 'Una de las mejores cartas de anulación en MTG', 2, 7.00, 45),
('MTG Sol Ring', 'Artefacto que genera mucho maná, clave en Commander', 2, 12.00, 30),
('MTG Swords to Plowshares', 'Eliminación de criaturas de coste bajo', 1, 5.00, 60),
('MTG Dark Confidant', 'Criatura que te permite robar cartas extras', NULL, 15.00, 20),
('MTG Force of Will', 'Contramagia sin coste de maná si descartas otra carta azul', NULL, 25.00, 10),
('MTG Mana Crypt', 'Artefacto que genera maná incoloro, con una desventaja', 1, 35.00, 5),
('MTG Cyclonic Rift', 'Hechizo de rebote de gran impacto', 3, 18.00, 15),
('MTG Doubling Season', 'Duplica contadores y fichas', NULL, 22.00, 8),
('MTG Tarmogoyf', 'Criatura que crece según los tipos de cartas en el cementerio', NULL, 10.00, 25),
('MTG Llanowar Elves', 'Criatura que genera maná verde', 1, 1.50, 150),
('MTG Opt', 'Cantrip que te permite ver la primera carta de tu biblioteca', NULL, 0.75, 200);

INSERT INTO estilos (nombre, descripcion) VALUES
('Minimalista', 'Diseño simple y moderno'),
('Abstracto', 'Diseño artístico y no figurativo');

INSERT INTO estado_pedido (nombre) VALUES
('Pendiente'),
('En preparación'),
('Enviado'), 
('Entregado'),
('Cancelado');

INSERT INTO metodos_pago (nombre, tasa) VALUES
('Tarjeta', 0.00),
('Transferencia', 0.00),
('Paypal', 2.00),
('Bizum', 1.00);

INSERT INTO pedidos (cliente_id, fecha_pedido, metodo_pago_id) VALUES
(1, '2024-05-10 10:30:00', 1),
(2, '2024-05-11 14:00:00', 2),
(1, '2024-05-12 11:45:00', 1),
(3, '2024-05-12 16:20:00', 3),
(4, '2024-05-13 09:00:00', 1),
(5, '2024-05-14 10:15:00', 2),
(6, '2024-05-14 15:30:00', 3),
(7, '2024-05-15 11:00:00', 1),
(8, '2024-05-15 17:45:00', 2),
(9, '2024-05-16 08:30:00', 3),
(10, '2024-05-16 13:00:00', 1);

INSERT INTO detalle_pedidos (pedido_id, producto_id, estilo_id, formato_id, cantidad, descuento) VALUES
(1, 1, 1, 2, 1, 0.00),
(1, 2, 2, 1, 2, 0.00),
(2, 3, 1, 1, 1, 0.00),
(3, 4, 2, 3, 3, 0.50),
(4, 5, NULL, 1, 1, 0.00),
(5, 6, 1, 2, 1, 0.00),
(6, 7, 2, 3, 1, 5.00),
(7, 8, NULL, 1, 2, 0.00),
(8, 9, 1, 2, 1, 0.00),
(9, 10, 2, 1, 1, 0.00),
(10, 11, 1, 1, 10, 0.00),
(10, 12, 2, 3, 20, 0.00);