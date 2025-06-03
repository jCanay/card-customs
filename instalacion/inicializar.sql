CREATE DATABASE IF NOT EXISTS card_customs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE card_customs;

CREATE TABLE IF NOT EXISTS tipo_local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_id INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo_id) REFERENCES tipo_local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    local_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    dni VARCHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (local_id) REFERENCES local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS etiquetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS formato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2) CHECK (precio >= 0) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    etiqueta_id INT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS estilos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS estado_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    tasa DECIMAL(5, 2)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_id INT NOT NULL DEFAULT 1,
    metodo_pago_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estado_pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    estilo_id INT,
    formato_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario > 0),
    iva DECIMAL(5, 2) NOT NULL DEFAULT 21.00 CHECK (iva > 0),
    descuento DECIMAL(5, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (estilo_id) REFERENCES estilos(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (formato_id) REFERENCES formato(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS historial_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_final INT NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS seguimiento_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_anterior VARCHAR(25),
    estado_nuevo VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT = 1;

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
	SELECT e.nombre, e.apellidos, t.nombre tipo, l.direccion, l.localidad, l.email, l.telefono FROM empleados e JOIN local l ON l.id = e.local_id JOIN tipo_local t ON t.id = l.tipo_id WHERE l.id = local_id;
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

USE card_customs;

INSERT INTO tipo_local (nombre) VALUES
('Tienda'),
('Taller'),
('Almacen'),
('Oficina');

INSERT INTO local (tipo_id, direccion, localidad, email, telefono) VALUES
(1, 'Calle Mayor 123', 'Madrid', 'madrid@cardcustoms.com', '912345678'),
(2, 'Avenida Innovación 45', 'Barcelona', 'barcelona@cardcustoms.com', '932109876'),
(3, 'Polígono Industrial s/n', 'Valencia', 'valencia@cardcustoms.com', '965432109'),
(1, 'Calle Preciados 5', 'Madrid', 'madrid.centro@cardcustoms.com', '912345679'),
(4, 'Paseo de Gracia 80', 'Barcelona', 'barcelona.gracia@cardcustoms.com', '932109877'),
(2, 'Calle Colón 15', 'Valencia', 'valencia.almacen@cardcustoms.com', '965432100'),
(1, 'Avenida de la Constitución 1', 'Sevilla', 'sevilla.principal@cardcustoms.com', '954112233'),
(1, 'Plaza del Pilar 10', 'Zaragoza', 'zaragoza.pilar@cardcustoms.com', '976887766'),
(1, 'Calle Larios 3', 'Málaga', 'malaga.centro@cardcustoms.com', '952445566'),
(4, 'Calle Alcalá 200', 'Madrid', 'madrid.este@cardcustoms.com', '912345680'),
(3, 'Diagonal 600', 'Barcelona', 'barcelona.oficina@cardcustoms.com', '932109878'),
(1, 'Gran Vía 40', 'Valencia', 'valencia.granvia@cardcustoms.com', '965432110'),
(2, 'Polígono Aeropuerto s/n', 'Sevilla', 'sevilla.almacen@cardcustoms.com', '954112234'),
(1, 'Calle Alfonso I 5', 'Zaragoza', 'zaragoza.alfonso@cardcustoms.com', '976887767'),
(2, 'Calle Salitre 1', 'Málaga', 'malaga.almacen@cardcustoms.com', '952445567'),
(1, 'Calle Goya 10', 'Madrid', 'madrid.goya@cardcustoms.com', '912345681'),
(1, 'Rambla de Cataluña 100', 'Barcelona', 'barcelona.rambla@cardcustoms.com', '932109879'),
(3, 'Plaza del Ayuntamiento 1', 'Valencia', 'valencia.oficina@cardcustoms.com', '965432111'),
(1, 'Calle Tetuán 2', 'Sevilla', 'sevilla.tetuan@cardcustoms.com', '954112235'),
(2, 'Calle Bari 3', 'Zaragoza', 'zaragoza.logistica@cardcustoms.com', '976887768'),
(1, 'Avenida Andalucía 20', 'Málaga', 'malaga.andalucia@cardcustoms.com', '952445568'),
(1, 'Paseo de la Castellana 200', 'Madrid', 'madrid.norte@cardcustoms.com', '912345682'),
(2, 'Calle Marina 10', 'Barcelona', 'barcelona.marina@cardcustoms.com', '932109880');

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
(3, 'Juan', 'Ruiz Castro', '10101010J', 'juan.ruiz@cardcustoms.com', '600567890', '2023-08-25', 1700.00),
(1, 'Andrea', 'Vega Ramos', '11223344K', 'andrea.vega@cardcustoms.com', '601234567', '2023-05-01', 1820.00),
(2, 'Carlos', 'Ortega Morales', '22334455L', 'carlos.ortega@cardcustoms.com', '602345678', '2022-03-15', 2150.00),
(3, 'Laura', 'Gil Prieto', '33445566M', 'laura.gil@cardcustoms.com', '603456789', '2021-09-01', 1980.00),
(1, 'David', 'Díaz Soto', '44556677N', 'david.diaz@cardcustoms.com', '604567890', '2024-01-10', 1790.00),
(2, 'Sara', 'Herrera Vidal', '55667788O', 'sara.herrera@cardcustoms.com', '605678901', '2023-07-22', 2020.00),
(3, 'Pablo', 'Blanco Cruz', '66778899P', 'pablo.blanco@cardcustoms.com', '606789012', '2020-04-05', 2250.00),
(1, 'María', 'Navarro Torres', '77889900Q', 'maria.navarro@cardcustoms.com', '607890123', '2023-02-28', 1880.00),
(2, 'Miguel', 'Gómez Martín', '88990011R', 'miguel.gomez@cardcustoms.com', '608901234', '2022-09-01', 2080.00),
(3, 'Cristina', 'Santos Prieto', '99001122S', 'cristina.santos@cardcustoms.com', '609012345', '2021-01-05', 1930.00),
(1, 'Roberto', 'López García', '00112233T', 'roberto.lopez@cardcustoms.com', '610123456', '2024-03-01', 1770.00),
(2, 'Nuria', 'Fernández Gil', '11223344U', 'nuria.fernandez@cardcustoms.com', '611345678', '2022-06-10', 2180.00),
(3, 'Sergio', 'Pérez Moreno', '22334455V', 'sergio.perez@cardcustoms.com', '612456789', '2021-10-15', 1960.00),
(1, 'Verónica', 'Ramírez Castro', '33445566W', 'veronica.ramirez@cardcustoms.com', '613567890', '2023-04-20', 1810.00),
(2, 'Fernando', 'Núñez Bravo', '44556677X', 'fernando.nunez@cardcustoms.com', '614678901', '2022-08-01', 2090.00),
(3, 'Beatriz', 'Jiménez Soler', '55667788Y', 'beatriz.jimenez@cardcustoms.com', '615789012', '2021-03-01', 2230.00),
(1, 'Jorge', 'Vidal Serrano', '66778899Z', 'jorge.vidal@cardcustoms.com', '616890123', '2024-02-14', 1760.00),
(2, 'Clara', 'Ortega Molina', '77889900A', 'clara.ortega@cardcustoms.com', '617901234', '2023-09-05', 2040.00),
(3, 'Oscar', 'Sánchez Ramos', '88990011B', 'oscar.sanchez@cardcustoms.com', '618012345', '2022-05-20', 1910.00),
(1, 'Diana', 'Romero Salas', '99001122C', 'diana.romero@cardcustoms.com', '619123456', '2024-01-01', 1830.00),
(2, 'Raúl', 'Morales Rico', '00112233D', 'raul.morales@cardcustoms.com', '620234567', '2023-11-15', 2120.00),
(4, 'Marina', 'Pascual Martín', '12345678E', 'marina.pascual@cardcustoms.com', '621345678', '2022-04-01', 1870.00),
(5, 'Gonzalo', 'Castro Díez', '23456789F', 'gonzalo.castro@cardcustoms.com', '622456789', '2023-06-20', 2030.00),
(6, 'Lorena', 'Herranz Vargas', '34567890G', 'lorena.herranz@cardcustoms.com', '623567890', '2021-08-10', 1990.00),
(7, 'Hugo', 'Benito Salgado', '45678901H', 'hugo.benito@cardcustoms.com', '624678901', '2024-01-05', 1780.00),
(8, 'Julia', 'Prieto Ramos', '56789012I', 'julia.prieto@cardcustoms.com', '625789012', '2023-03-01', 2110.00),
(9, 'Adrián', 'Vázquez Cruz', '67890123J', 'adrian.vazquez@cardcustoms.com', '626890123', '2022-10-10', 1940.00),
(10, 'Elena', 'Guerrero Ortiz', '78901234K', 'elena.guerrero@cardcustoms.com', '627901234', '2021-05-18', 2210.00),
(11, 'Rubén', 'Serrano Vega', '89012345L', 'ruben.serrano@cardcustoms.com', '628012345', '2024-02-20', 1860.00),
(12, 'Lucía', 'Muñoz Gil', '90123456M', 'lucia.munoz@cardcustoms.com', '629123456', '2023-07-01', 2070.00),
(13, 'Alejandro', 'Blanco Soto', '01234567N', 'alejandro.blanco@cardcustoms.com', '630234567', '2022-09-25', 1920.00),
(14, 'Paula', 'Castro López', '12345678O', 'paula.castro@cardcustoms.com', '631345678', '2021-11-01', 2160.00),
(15, 'Iker', 'Díaz Gómez', '23456789P', 'iker.diaz@cardcustoms.com', '632456789', '2024-04-15', 1890.00),
(16, 'Daniela', 'Fernández Martín', '34567890Q', 'daniela.fernandez@cardcustoms.com', '633567890', '2023-01-10', 2010.00),
(17, 'Adriana', 'García Ruiz', '45678901R', 'adriana.garcia@cardcustoms.com', '634678901', '2022-07-05', 1970.00),
(18, 'Nacho', 'Martínez Soler', '56789012S', 'nacho.martinez@cardcustoms.com', '635789012', '2021-02-01', 2220.00),
(19, 'Carolina', 'Navarro Torres', '67890123T', 'carolina.navarro@cardcustoms.com', '636890123', '2024-03-20', 1740.00),
(20, 'Felipe', 'Pérez Moreno', '78901234U', 'felipe.perez@cardcustoms.com', '637901234', '2023-05-12', 2140.00),
(21, 'Valeria', 'Ramírez Blanco', '89012345V', 'valeria.ramirez@cardcustoms.com', '638012345', '2022-01-01', 1900.00),
(22, 'Samuel', 'Sánchez Gil', '90123456W', 'samuel.sanchez@cardcustoms.com', '639123456', '2021-06-30', 2060.00),
(23, 'Emma', 'Santos Prieto', '01234567X', 'emma.santos@cardcustoms.com', '640234567', '2024-01-25', 1840.00),
(1, 'Óliver', 'Vázquez Costa', '12345678Y', 'oliver.vazquez@cardcustoms.com', '641345678', '2023-02-10', 2190.00),
(2, 'Rocío', 'Vega Ramos', '23456789Z', 'rocio.vega@cardcustoms.com', '642456789', '2022-08-15', 1950.00),
(3, 'Marcos', 'Ortega Morales', '34567890A', 'marcos.ortega@cardcustoms.com', '643567890', '2021-04-01', 2200.00),
(4, 'Alba', 'Gil Prieto', '45678901B', 'alba.gil@cardcustoms.com', '644678901', '2024-01-03', 1780.00),
(5, 'Diego', 'Díaz Soto', '56789012C', 'diego.diaz@cardcustoms.com', '645789012', '2023-06-01', 2050.00),
(6, 'Elena', 'Herrera Vidal', '67890123D', 'elena.herrera@cardcustoms.com', '646890123', '2022-03-01', 1900.00),
(7, 'Martín', 'Blanco Cruz', '78901234E', 'martin.blanco@cardcustoms.com', '647901234', '2021-09-10', 2280.00),
(8, 'Marina', 'Navarro Torres', '89012345F', 'marina.navarro2@cardcustoms.com', '648012345', '2024-02-05', 1800.00),
(9, 'Álvaro', 'Gómez Martín', '90123456G', 'alvaro.gomez@cardcustoms.com', '649123456', '2023-07-15', 2100.00),
(10, 'Nerea', 'Santos Prieto', '01234567H', 'nerea.santos@cardcustoms.com', '650234567', '2022-04-20', 1960.00),
(11, 'Juanjo', 'López García', '12345678I', 'juanjo.lopez@cardcustoms.com', '651345678', '2021-01-10', 2000.00),
(12, 'Lorena', 'Fernández Gil', '23456789J', 'lorena.fernandez2@cardcustoms.com', '652456789', '2024-03-10', 1750.00),
(13, 'Borja', 'Pérez Moreno', '34567890K', 'borja.perez@cardcustoms.com', '653567890', '2023-08-01', 2150.00),
(14, 'Carmen', 'Ramírez Castro', '45678901L', 'carmen.ramirez@cardcustoms.com', '654678901', '2022-02-14', 1850.00),
(15, 'Antonio', 'Núñez Bravo', '56789012M', 'antonio.nunez@cardcustoms.com', '655789012', '2021-07-20', 2200.00),
(16, 'Inés', 'Jiménez Soler', '67890123N', 'ines.jimenez@cardcustoms.com', '656890123', '2024-04-05', 1900.00),
(17, 'Rubén', 'Vidal Serrano', '78901234O', 'ruben.vidal@cardcustoms.com', '657901234', '2023-01-01', 1700.00),
(18, 'Pilar', 'Ortega Molina', '89012345P', 'pilar.ortega@cardcustoms.com', '658012345', '2022-10-01', 2030.00),
(19, 'Esteban', 'Sánchez Ramos', '90123456Q', 'esteban.sanchez@cardcustoms.com', '659123456', '2021-03-01', 1980.00),
(20, 'Silvia', 'Romero Salas', '01234567R', 'silvia.romero@cardcustoms.com', '660234567', '2024-01-15', 1820.00),
(21, 'Josefa', 'Morales Rico', '12345678S', 'josefa.morales@cardcustoms.com', '661345678', '2023-06-10', 2170.00),
(22, 'Víctor', 'Díaz Soto', '23456789T', 'victor.diaz@cardcustoms.com', '662456789', '2022-05-01', 1900.00),
(23, 'Laura', 'Herrera Vidal', '34567890U', 'laura.herrera2@cardcustoms.com', '663567890', '2021-08-01', 2250.00),
(1, 'Adrián', 'Blanco Cruz', '45678901V', 'adrian.blanco@cardcustoms.com', '664678901', '2024-02-20', 1880.00),
(2, 'Natalia', 'Navarro Torres', '56789012W', 'natalia.navarro@cardcustoms.com', '665789012', '2023-09-01', 2000.00),
(3, 'Gonzalo', 'Gómez Martín', '67890123X', 'gonzalo.gomez@cardcustoms.com', '666890123', '2022-06-15', 2100.00),
(4, 'Rosa', 'Santos Prieto', '78901234Y', 'rosa.santos@cardcustoms.com', '667901234', '2021-11-01', 1950.00),
(5, 'Dani', 'López García', '89012345Z', 'dani.lopez@cardcustoms.com', '668012345', '2024-01-01', 1700.00)
;

INSERT INTO clientes (nombre, apellidos, email, direccion, telefono) VALUES
('Carlos', 'Díaz Soto', 'carlos.diaz@example.com', 'Paseo de la Castellana 10', '611223344'),
('Laura', 'Herrera Vidal', 'laura.herrera@example.com', 'Gran Vía 50', '622334455'),
('Pedro', 'Ruiz Gómez', 'pedro.ruiz@example.com', 'Calle Colón 20', '633445566'),
('Elena', 'Blanco Cruz', 'elena.blanco@example.com', 'Calle de Toledo 8', '644556677'),
('Miguel', 'Santos Prieto', 'miguel.santos@example.com', 'Rambla Cataluña 5', '655667788'),
('Sofía', 'López García', 'sofia.lopez@example.com', 'Calle Mayor 1', '666778899'),
('Jorge', 'Fernández Gil', 'jorge.fernandez@example.com', 'Av. del Puerto 30', '677889900'),
('Ana', 'Pérez Moreno', 'ana.perez@example.com', 'Plaza España 15', '688990011'),
('Daniel', 'Navarro Torres', 'daniel.navarro@example.com', 'Diagonal 200', '699001122'),
('Lucía', 'Gómez Martín', 'lucia.gomez@example.com', 'Calle de la Paz 7', '600112233'),
('Javier', 'Ramírez Castro', 'javier.ramirez@example.com', 'Avenida de la Constitución 1', '601234567'),
('Marta', 'Núñez Bravo', 'marta.nunez@example.com', 'Calle Betis 25', '602345678'),
('Pablo', 'Jiménez Soler', 'pablo.jimenez@example.com', 'Paseo Marítimo 12', '603456789'),
('Andrea', 'Vidal Serrano', 'andrea.vidal@example.com', 'Calle Larios 3', '604567890'),
('David', 'Ortega Molina', 'david.ortega@example.com', 'Gran Vía de Colón 18', '605678901'),
('Sara', 'Sánchez Ramos', 'sara.sanchez@example.com', 'Calle Alfonso I 2', '606789012'),
('Manuel', 'Romero Salas', 'manuel.romero@example.com', 'Avenida de la Palmera 7', '607890123'),
('Isabel', 'Morales Rico', 'isabel.morales@example.com', 'Plaza de la Merced 10', '608901234'),
('Fernando', 'Ruiz Marín', 'fernando.ruiz@example.com', 'Paseo de Gracia 90', '609012345'),
('Cristina', 'Prieto Vega', 'cristina.prieto@example.com', 'Calle San Miguel 5', '610123456'),
('Sergio', 'Herrero Campos', 'sergio.herrero@example.com', 'Calle Mayor 45', '611234567'),
('Beatriz', 'Marín Díaz', 'beatriz.marin@example.com', 'Plaza del Pilar 1', '612345678'),
('Ricardo', 'Crespo León', 'ricardo.crespo@example.com', 'Calle Cuna 9', '613456789'),
('Patricia', 'Guerrero Ortiz', 'patricia.guerrero@example.com', 'Avenida de Gasteiz 22', '614567890'),
('Roberto', 'Méndez Torres', 'roberto.mendez@example.com', 'Calle Laurel 14', '615678901'),
('Nuria', 'Iglesias Cano', 'nuria.iglesias@example.com', 'Paseo de Zorrilla 100', '616789012'),
('Alejandro', 'Delgado Cruz', 'alejandro.delgado@example.com', 'Calle Sierpes 60', '617890123'),
('Verónica', 'Cortés Molina', 'veronica.cortes@example.com', 'Rúa do Vilar 3', '618901234'),
('Francisco', 'Castro Soto', 'francisco.castro@example.com', 'Gran Vía 1', '619012345'),
('Monica', 'Gallardo Blanco', 'monica.gallardo@example.com', 'Paseo de Recoletos 2', '620123456'),
('Raquel', 'Benito Salgado', 'raquel.benito@example.com', 'Calle de la Oca 10', '621234567'),
('Álvaro', 'Campos Romero', 'alvaro.campos@example.com', 'Av. del Mediterráneo 5', '622345678'),
('Silvia', 'Díaz Navarro', 'silvia.diaz@example.com', 'Paseo de las Delicias 30', '623456789'),
('Víctor', 'Esteban Soto', 'victor.esteban@example.com', 'Calle de Atocha 70', '624567890'),
('Eva', 'Ferrer Giménez', 'eva.ferrer@example.com', 'Ronda de Toledo 4', '625678901'),
('Javier', 'Gil Sánchez', 'javier.gil@example.com', 'Calle del Cardenal Cisneros 2', '626789012'),
('Laura', 'Hernández Ruiz', 'laura.hernandez@example.com', 'Calle de Bailén 1', '627890123'),
('Miguel', 'Iglesias Vidal', 'miguel.iglesias@example.com', 'Calle del Dr. Esquerdo 55', '628901234'),
('Nuria', 'Jiménez Alonso', 'nuria.jimenez@example.com', 'Avenida de América 10', '629012345'),
('Oscar', 'Lara Fuentes', 'oscar.lara@example.com', 'Calle de Velázquez 12', '630123456'),
('Pilar', 'Márquez Ortiz', 'pilar.marquez@example.com', 'Calle de Hermosilla 8', '631234567'),
('Quique', 'Nieto Pérez', 'quique.nieto@example.com', 'Plaza de Cibeles 1', '632345678'),
('Rosa', 'Ochoa Vega', 'rosa.ochoa@example.com', 'Calle de Alcalá 15', '633456789'),
('Samuel', 'Pardo Martín', 'samuel.pardo@example.com', 'Calle de Génova 20', '634567890'),
('Teresa', 'Quintero Salas', 'teresa.quintero@example.com', 'Paseo del Prado 10', '635678901'),
('Ubaldo', 'Ramírez Castro', 'ubaldo.ramirez@example.com', 'Calle de Serrano 50', '636789012'),
('Violeta', 'Serrano Díez', 'violeta.serrano@example.com', 'Calle de Toledo 100', '637890123'),
('Walter', 'Torres Bravo', 'walter.torres@example.com', 'Carrera de San Jerónimo 5', '638901234'),
('Xenia', 'Ugarte Gil', 'xenia.ugarte@example.com', 'Calle de San Bernardo 60', '639012345'),
('Yago', 'Vargas López', 'yago.vargas@example.com', 'Glorieta de Bilbao 3', '640123456'),
('Zoe', 'Zapata Soler', 'zoe.zapata@example.com', 'Plaza Mayor 1', '641234567'),
('Andrés', 'Alonso Martín', 'andres.alonso@example.com', 'Calle del Arenal 10', '642345678'),
('Blanca', 'Benítez Soto', 'blanca.benitez@example.com', 'Paseo de Recoletos 5', '643456789'),
('César', 'Caballero Luna', 'cesar.caballero@example.com', 'Calle de la Princesa 25', '644567890'),
('Diana', 'Domínguez Prieto', 'diana.dominguez@example.com', 'Avenida de Menéndez Pelayo 1', '645678901'),
('Emilio', 'Expósito Cruz', 'emilio.exposito@example.com', 'Calle de Embajadores 40', '646789012'),
('Fátima', 'Flores García', 'fatima.flores@example.com', 'Calle de Bravo Murillo 90', '647890123'),
('Guillermo', 'Garrido Herrera', 'guillermo.garrido@example.com', 'Ronda de Valencia 12', '648901234'),
('Helena', 'Ibáñez Vidal', 'helena.ibanez@example.com', 'Paseo de la Florida 2', '649012345'),
('Ignacio', 'Izquierdo Santos', 'ignacio.izquierdo@example.com', 'Calle de la Montera 15', '650123456'),
('Julia', 'Jara Moreno', 'julia.jara@example.com', 'Calle de Segovia 5', '651234567'),
('Kira', 'Kovalenko Ruiz', 'kira.kovalenko@example.com', 'Avenida del Manzanares 30', '652345678'),
('Leo', 'León Pérez', 'leo.leon@example.com', 'Calle de la Cruz 20', '653456789'),
('Mireia', 'Marco Navarro', 'mireia.marco@example.com', 'Plaza de Oriente 1', '654567890'),
('Nico', 'Naranjo Torres', 'nico.naranjo@example.com', 'Calle del Marqués de Urquijo 10', '655678901'),
('Olivia', 'Ojeda Gómez', 'olivia.ojeda@example.com', 'Ronda de Segovia 50', '656789012'),
('Pau', 'Pacheco Martín', 'pau.pacheco@example.com', 'Calle de Atocha 10', '657890123'),
('Quim', 'Quijada Blanco', 'quim.quijada@example.com', 'Paseo de Extremadura 80', '658901234'),
('Rita', 'Rivera Cruz', 'rita.rivera@example.com', 'Calle de la Colegiata 5', '659012345'),
('Saúl', 'Salazar Díaz', 'saul.salazar@example.com', 'Calle de San Andrés 1', '660123456'),
('Tina', 'Tapia Ferrer', 'tina.tapia@example.com', 'Glorieta de Quevedo 2', '661234567'),
('Uriel', 'Urbano Giménez', 'uriel.urbano@example.com', 'Calle de Fuencarral 120', '662345678'),
('Valeria', 'Vallejo Hernández', 'valeria.vallejo@example.com', 'Calle de Alberto Aguilera 35', '663456789'),
('Wenceslao', 'Wong Ruiz', 'wenceslao.wong@example.com', 'Calle del Conde Duque 15', '664567890'),
('Ximena', 'Ximénez López', 'ximena.ximenez@example.com', 'Calle de la Luna 2', '665678901'),
('Yerai', 'Yáñez Martín', 'yerai.yanez@example.com', 'Plaza de Callao 5', '666789012'),
('Zacarias', 'Zúñiga García', 'zacarias.zuniga@example.com', 'Calle del Carnero 7', '667890123'),
('Abel', 'Acosta Pérez', 'abel.acosta@example.com', 'Calle de la Bolsa 1', '668901234'),
('Berta', 'Bastida Moreno', 'berta.bastida@example.com', 'Plaza de Santa Ana 10', '669012345'),
('Camilo', 'Cano Torres', 'camilo.cano@example.com', 'Calle de Echegaray 20', '670123456'),
('Dario', 'Domínguez Soto', 'dario.dominguez@example.com', 'Calle de los Jardines 5', '671234567'),
('Esther', 'Escobar Vidal', 'esther.escobar@example.com', 'Calle de la Palma 3', '672345678'),
('Fausto', 'Franco Gómez', 'fausto.franco@example.com', 'Calle del Pez 18', '673456789'),
('Gema', 'Gallego Cruz', 'gema.gallego@example.com', 'Calle de la Madera 1', '674567890'),
('Héctor', 'Herrera Blanco', 'hector.herrera@example.com', 'Calle de San Vicente Ferrer 30', '675678901'),
('Inma', 'Iriarte Prieto', 'inma.iriarte@example.com', 'Plaza de España 10', '676789012'),
('Jacobo', 'Jordán Santos', 'jacobo.jordan@example.com', 'Calle de la Bola 12', '677890123'),
('Karen', 'King García', 'karen.king@example.com', 'Calle de Leganitos 25', '678901234'),
('Lucas', 'Lozano Fernández', 'lucas.lozano@example.com', 'Calle de Amaniel 1', '679012345'),
('Mónica', 'Montes Gil', 'monica.montes2@example.com', 'Calle de la Pasa 3', '680123456'),
('Nacho', 'Naranjo Pérez', 'nacho.naranjo2@example.com', 'Calle del Nuncio 5', '681234567'),
('Olga', 'Otero Moreno', 'olga.otero@example.com', 'Plaza de la Villa 1', '682345678'),
('Paco', 'Palomino Navarro', 'paco.palomino@example.com', 'Calle de Cuchilleros 10', '683456789'),
('Quique', 'Quintero Torres', 'quique.quintero@example.com', 'Calle de Segovia 1', '684567890'),
('Rafa', 'Reyes Gómez', 'rafa.reyes@example.com', 'Plaza Mayor 5', '685678901'),
('Sonia', 'Salas Martín', 'sonia.salas@example.com', 'Calle del Espejo 2', '686789012'),
('Tomás', 'Tejeda Blanco', 'tomas.tejeda@example.com', 'Calle de Postas 1', '687890123'),
('Úrsula', 'Urbina Cruz', 'ursula.urbina@example.com', 'Plaza de la Puerta Cerrada 3', '688901234'),
('Vicente', 'Varela Díaz', 'vicente.varela@example.com', 'Calle de la Cava Baja 15', '689012345');

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
('MTG Lightning Bolt', 'Un hechizo de daño directo icónico en MTG', 2, 8.50, 878),
('MTG Counterspell', 'Una de las mejores cartas de anulación en MTG', 2, 7.00, 3139),
('MTG Sol Ring', 'Artefacto que genera mucho maná, clave en Commander', 2, 12.00, 4833),
('MTG Swords to Plowshares', 'Eliminación de criaturas de coste bajo', 1, 5.00, 3574),
('MTG Dark Confidant', 'Criatura que te permite robar cartas extras', NULL, 15.00, 4518),
('MTG Force of Will', 'Contramagia sin coste de maná si descartas otra carta azul', NULL, 25.00, 3757),
('MTG Mana Crypt', 'Artefacto que genera maná incoloro, con una desventaja', 1, 35.00, 4519),
('MTG Cyclonic Rift', 'Hechizo de rebote de gran impacto', 3, 18.00, 1698),
('MTG Doubling Season', 'Duplica contadores y fichas', NULL, 22.00, 2908),
('MTG Tarmogoyf', 'Criatura que crece según los tipos de cartas en el cementerio', NULL, 10.00, 4398),
('MTG Llanowar Elves', 'Criatura que genera maná verde', 1, 1.50, 4292),
('MTG Opt', 'Cantrip que te permite ver la primera carta de tu biblioteca', NULL, 0.75, 4104),
('MTG Lightning Greaves', 'Equipo que da prisa y antimaleficio a la criatura equipada', 1, 6.50, 3632),
('MTG Demonic Tutor', 'Hechizo que te permite buscar cualquier carta de tu biblioteca', 2, 30.00, 4124),
('MTG Path to Exile', 'Eliminación de criaturas de coste bajo que da una tierra al oponente', 1, 4.00, 1145),
('MTG Blood Moon', 'Encantamiento que convierte las tierras no básicas en Montañas', 2, 16.00, 2062),
('MTG fetchland - Misty Rainforest', 'Tierra doble que busca tierras de bosque o isla', 3, 45.00, 4160),
('MTG Birds of Paradise', 'Criatura que genera maná de cualquier color', NULL, 9.00, 2516),
('MTG Snapcaster Mage', 'Flash y lanzar instantáneos o conjuros del cementerio', 2, 28.00, 4619),
('MTG Aether Vial', 'Artefacto que permite lanzar criaturas con contadores', 1, 11.00, 3073),
('MTG Stoneforge Mystic', 'Criatura que busca y pone equipos en juego', NULL, 13.00, 1969),
('MTG Chord of Calling', 'Buscador de criaturas instantáneo con convocar', 3, 7.50, 1099);

INSERT INTO estilos (nombre, descripcion) VALUES
('Minimalista', 'Diseño simple y moderno'),
('Abstracto', 'Diseño artístico y no figurativo'),
('Clásico', 'Estilo atemporal y tradicional, con elementos de época'),
('Futurista', 'Diseño que evoca tecnología avanzada y ciencia ficción'),
('Retro/Vintage', 'Estilo inspirado en épocas pasadas, con estética nostálgica'),
('Ilustración', 'Dibujos detallados y artísticos, a menudo hechos a mano'),
('Cómic', 'Estilo vibrante y dinámico, inspirado en las viñetas de cómics'),
('Graffiti/Urbano', 'Diseño con elementos de arte callejero y cultura urbana'),
('Fantástico', 'Estilo que representa mundos y criaturas de fantasía, épico'),
('Ciberpunk', 'Diseño oscuro y futurista, con elementos tecnológicos y distópicos');

INSERT INTO estado_pedido (nombre) VALUES
('Pendiente'),
('En preparación'),
('Enviado'), 
('Entregado'),
('Cancelado');

INSERT INTO metodos_pago (nombre, tasa) VALUES
('Tarjeta', 0.00),
('Transferencia', 0.00),
('Apple Pay', 0.00),
('Google Pay', 0.00),
('Paypal', 2.90),
('Bizum', 1.10);

INSERT INTO pedidos (cliente_id, fecha_pedido, metodo_pago_id) VALUES
(1, '2024-11-20 10:15:30', 1),
(2, '2024-11-21 11:05:45', 2),
(3, '2024-11-22 14:20:10', 3),
(4, '2024-11-23 09:30:00', 4),
(5, '2024-11-24 16:00:00', 1),
(6, '2024-11-25 12:45:15', 2),
(7, '2024-11-26 10:00:00', 3),
(8, '2024-11-27 15:30:00', 4),
(9, '2024-11-28 08:00:00', 1),
(10, '2024-11-29 13:00:00', 2),
(1, '2024-12-05 09:30:00', 3),
(2, '2024-12-06 14:10:00', 4),
(3, '2024-12-07 10:00:00', 1),
(4, '2024-12-08 17:00:00', 2),
(5, '2024-12-09 11:30:00', 3),
(6, '2024-12-10 13:45:00', 4),
(7, '2024-12-11 09:00:00', 1),
(8, '2024-12-12 16:15:00', 2),
(9, '2024-12-13 10:20:00', 3),
(10, '2024-12-14 15:50:00', 4),
(1, '2025-01-01 10:00:00', 1),
(2, '2025-01-02 11:15:00', 2),
(3, '2025-01-03 14:30:00', 3),
(4, '2025-01-04 09:40:00', 4),
(5, '2025-01-05 16:25:00', 1),
(6, '2025-01-06 12:00:00', 2),
(7, '2025-01-07 10:10:00', 3),
(8, '2025-01-08 15:20:00', 4),
(9, '2025-01-09 08:45:00', 1),
(10, '2025-01-10 13:30:00', 2),
(11, '2025-02-01 10:00:00', 1),
(12, '2025-02-02 11:00:00', 2),
(13, '2025-02-03 14:00:00', 3),
(14, '2025-02-04 09:00:00', 4),
(15, '2025-02-05 16:00:00', 1),
(11, '2025-03-01 10:30:00', 2),
(12, '2025-03-02 11:30:00', 3),
(13, '2025-03-03 14:30:00', 4),
(14, '2025-03-04 09:30:00', 1),
(15, '2025-03-05 16:30:00', 2),
(11, '2025-04-01 10:45:00', 3),
(12, '2025-04-02 11:45:00', 4),
(13, '2025-04-03 14:45:00', 1),
(14, '2025-04-04 09:45:00', 2),
(15, '2025-04-05 16:45:00', 3),
(11, '2025-05-01 11:00:00', 4),
(12, '2025-05-02 12:00:00', 1),
(13, '2025-05-03 15:00:00', 2),
(14, '2025-05-04 10:00:00', 3),
(15, '2025-05-05 17:00:00', 4);

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
(10, 12, 2, 3, 20, 0.00),
(11, 1, 1, 2, 1, 0.00),
(12, 2, 2, 1, 2, 0.00),
(13, 3, 1, 1, 1, 0.00),
(14, 4, 2, 3, 3, 0.00),
(15, 5, NULL, 1, 1, 0.00),
(16, 6, 1, 2, 1, 0.00),
(17, 7, 2, 3, 1, 0.00),
(18, 8, NULL, 1, 2, 0.00),
(19, 9, 1, 2, 1, 0.00),
(20, 10, 2, 1, 1, 0.00),
(21, 11, 1, 1, 5, 0.00),
(22, 12, 2, 3, 10, 0.00),
(23, 13, NULL, 4, 1, 0.00),
(24, 14, 3, 5, 1, 0.00),
(25, 15, 4, 1, 2, 0.00),
(26, 16, 5, 2, 1, 0.00),
(27, 17, 6, 3, 1, 0.00),
(28, 18, 7, 4, 3, 0.00),
(29, 19, 8, 5, 1, 0.00),
(30, 20, 9, 1, 1, 0.00),
(31, 21, 10, 2, 2, 0.00),
(32, 22, NULL, 3, 1, 0.00),
(33, 1, 1, 4, 1, 0.00),
(34, 2, 2, 5, 2, 0.00),
(35, 3, 3, 1, 1, 0.00),
(36, 4, 4, 2, 3, 0.00),
(37, 5, NULL, 3, 1, 0.00),
(38, 6, 5, 4, 1, 0.00),
(39, 7, 6, 5, 1, 0.00),
(40, 8, NULL, 1, 2, 0.00),
(41, 9, 7, 2, 1, 0.00),
(42, 10, 8, 3, 1, 0.00),
(43, 11, 9, 4, 5, 0.00),
(44, 12, 10, 5, 10, 0.00),
(45, 13, NULL, 1, 1, 0.00),
(46, 14, 1, 2, 1, 0.00),
(47, 15, 2, 3, 2, 0.00),
(48, 16, 3, 4, 1, 0.00),
(49, 17, 4, 5, 1, 0.00),
(50, 18, 5, 1, 3, 0.00),
(1, 13, 6, 4, 1, 0.00),
(2, 14, 7, 5, 1, 0.00),
(3, 15, 8, 1, 2, 0.00),
(4, 16, 9, 2, 1, 0.00),
(5, 17, 10, 3, 1, 0.00),
(6, 18, NULL, 4, 3, 0.00),
(7, 19, 1, 5, 1, 0.00),
(8, 20, 2, 1, 1, 0.00),
(9, 21, 3, 2, 2, 0.00),
(10, 22, 4, 3, 1, 0.00),
(11, 14, 5, 4, 1, 0.00),
(12, 15, 6, 5, 2, 0.00),
(13, 16, 7, 1, 1, 0.00),
(14, 17, 8, 2, 1, 0.00),
(15, 18, 9, 3, 3, 0.00),
(16, 19, 10, 4, 1, 0.00),
(17, 20, NULL, 5, 1, 0.00),
(18, 21, 1, 1, 2, 0.00),
(19, 22, 2, 2, 1, 0.00),
(20, 1, 3, 3, 1, 0.00),
(21, 2, 4, 4, 2, 0.00),
(22, 3, 5, 5, 1, 0.00),
(23, 4, 6, 1, 3, 0.00),
(24, 5, NULL, 2, 1, 0.00),
(25, 6, 7, 3, 1, 0.00),
(26, 7, 8, 4, 1, 0.00),
(27, 8, NULL, 5, 2, 0.00),
(28, 9, 9, 1, 1, 0.00),
(29, 10, 10, 2, 1, 0.00),
(30, 11, 1, 3, 5, 0.00),
(31, 12, 2, 4, 10, 0.00),
(32, 13, 3, 5, 1, 0.00),
(33, 14, 4, 1, 1, 0.00),
(34, 15, 5, 2, 2, 0.00),
(35, 16, 6, 3, 1, 0.00),
(36, 17, 7, 4, 1, 0.00),
(37, 18, 8, 5, 3, 0.00),
(38, 19, 9, 1, 1, 0.00),
(39, 20, 10, 2, 1, 0.00),
(40, 21, NULL, 3, 2, 0.00),
(41, 22, 1, 4, 1, 0.00),
(42, 1, 2, 5, 1, 0.00),
(43, 2, 3, 1, 2, 0.00),
(44, 3, 4, 2, 1, 0.00),
(45, 4, 5, 3, 3, 0.00),
(46, 5, NULL, 4, 1, 0.00),
(47, 6, 6, 5, 1, 0.00),
(48, 7, 7, 1, 1, 0.00),
(49, 8, NULL, 2, 2, 0.00),
(50, 9, 8, 3, 1, 0.00);