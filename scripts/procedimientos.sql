USE card_customs;

-- Este procedimiento se encargar de mostrar todos los datos de una factura especificada y mostrarlos de una forma que se entienda mejor cada fila.
DELIMITER //
CREATE PROCEDURE obtener_factura_detallada_pedido(pedido_id INT)
BEGIN
	SELECT pe.id, pe.fecha_pedido, c.nombre, c.apellidos, pr.nombre, f.nombre, e.nombre, dp.precio_unitario, dp.cantidad, dp.iva, dp.descuento
	FROM detalle_pedidos dp JOIN pedidos pe ON pe.id = dp.pedido_id JOIN clientes c ON c.id = pe.cliente_id JOIN formato f ON f.id = dp.formato_id LEFT JOIN estilos e ON dp.estilo_id = e.id JOIN productos pr ON pr.id = dp.producto_id
	WHERE dp.pedido_id = pedido_id;
END;
// DELIMITER ;

-- Este procedimiento se encarga de insertar un producto nuevo a una factura. Si ya existe pero la cantidad es distinta, se actualizará la fila existente.
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

-- Este procedimiento muestra todas las facturas de un cliente dado.
DELIMITER //
CREATE PROCEDURE listar_facturas_cliente(cliente_id INT)
BEGIN
	SELECT f.*, ep.nombre estado FROM facturas f JOIN pedidos pe ON f.pedido_id = pe.id JOIN clientes c ON c.id = pe.cliente_id JOIN estado_pedido ep ON ep.id = pe.estado_id WHERE c.id = cliente_id;
END;
// DELIMITER ;

-- Este procedimiento actualiza un pedido a su siguiente estado siguiendo el orden logístico (Excepto al estado 'Entregado' y 'Cancelado').
DELIMITER //
CREATE PROCEDURE actualizar_siguiente_estado_pedido(pedido_id INT)
BEGIN
	IF ((SELECT pe.estado_id FROM pedidos pe WHERE pe.id = pedido_id) + 1 < 4) THEN
		UPDATE pedidos pe SET pe.estado_id = pe.estado_id + 1 WHERE pe.id = pedido_id;
    END IF;
END;
// DELIMITER ;

-- Este procedimiento se encarga de establecer el estado de un pedido dado a 'Entregado'.
DELIMITER //
CREATE PROCEDURE entregar_pedido(pedido_id INT)
BEGIN
	UPDATE pedidos SET estado_id = 4 WHERE id = pedido_id;
END;
// DELIMITER ;

-- Este procedimiento se encarga de cancelar un pedido dado, estableciendo su estado a 'Cancelado'.
DELIMITER //
CREATE PROCEDURE cancelar_pedido(pedido_id INT)
BEGIN
	UPDATE pedidos SET estado_id = 5 WHERE id = pedido_id;
END;
// DELIMITER ;

-- Este procedimiento muestra todas las actualizaciones de un pedido que se pasa por parámetro.
DELIMITER //
CREATE PROCEDURE ver_actualizaciones_estado_pedido(pedido_id INT)
BEGIN
	SELECT * FROM seguimiento_pedidos s WHERE s.pedido_id = pedido_id;
END;
// DELIMITER ;

-- Este procedimiento muestra todos los trabajadores que tiene un local
DELIMITER //
CREATE PROCEDURE ver_empleados_local(local_id INT)
BEGIN
	SELECT e.nombre, e.apellidos, t.nombre tipo, l.direccion, l.localidad, l.email, l.telefono FROM empleados e JOIN local l ON l.id = e.local_id JOIN tipo_local t ON t.id = l.tipo WHERE l.id = local_id;
END;
// DELIMITER ;

-- Este procedimiento se encarga de eliminar todos los datos de un cliente, incluidos sus pedidos y los detalles de cada pedido.
DELIMITER //
CREATE PROCEDURE eliminar_cliente_completo(cliente_id INT)
BEGIN
	DELETE FROM detalle_pedidos dp WHERE dp.pedido_id IN (SELECT pe.id FROM pedidos pe WHERE pe.cliente_id = cliente_id);
	DELETE FROM pedidos pe WHERE pe.cliente_id = cliente_id;
	DELETE FROM clientes WHERE id = cliente_id;
END;
// DELIMITER ;