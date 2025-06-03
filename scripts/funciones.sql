USE card_customs;

-- Esta función se encarga de calcular el subtotal de cada factura teniendo en cuenta un 'precio', un 'formato_precio' una 'cantidad', un 'iva' y un 'descuento'.
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

-- Esta función se encarga de calcular el total de cada factura. Normalmente al argumento 'subtotal' se le pasará el resultado de la función 'calcular_subtotal_factura'.
DELIMITER //
CREATE FUNCTION calcular_total_factura (subtotal DECIMAL(10,2), tasa DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2) DEFAULT (subtotal + (subtotal * tasa / 100));

    RETURN total;
END;
// DELIMITER ;

-- Esta función se encarga de obtener el stock de un producto pasado por parámetro.
DELIMITER //
CREATE FUNCTION obtener_stock_producto(producto_id INT)
RETURNS INT	
DETERMINISTIC
BEGIN
    RETURN (SELECT stock FROM productos WHERE id = producto_id);
END;
// DELIMITER ;

-- Esta función se encarga de obtener el nombre de un estado, que se pasa como parámetro, de la tabla 'estado_pedido'.
DELIMITER //
CREATE FUNCTION obtener_nombre_estado(estado_id INT)
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    RETURN (SELECT nombre FROM estado_pedido WHERE id = estado_id);
END;
// DELIMITER ;

-- Esta funcion devuelve el salario del empleado con mayor salario.
DELIMITER //
CREATE FUNCTION mayor_salario_empleados()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT e.salario FROM empleados e ORDER BY salario DESC LIMIT 1);
END;
// DELIMITER ;

/* DELIMITER //
CREATE FUNCTION calcular_fecha_entrega_estimada(pedido_id INT)
RETURNS DATE
DETERMINISTIC
BEGIN
	
    RETURN (SELECT e.salario FROM empleados e ORDER BY salario DESC LIMIT 1);
END;
// DELIMITER ; */