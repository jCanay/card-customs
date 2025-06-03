USE card_customs;

-- Este trigger se asegura de que siempre se use el precio correcto al insertar un producto en la tabla 'detalle_pedidos'.
DELIMITER //
CREATE TRIGGER insertar_precio_unitario_detalle_pedidos 
BEFORE INSERT ON detalle_pedidos 
FOR EACH ROW
BEGIN
    SET NEW.precio_unitario = (SELECT p.precio FROM productos p WHERE id = NEW.producto_id);
END;
// DELIMITER ;

-- Este trigger se encarga de comprobar y actualizar el stock antes de insertar un nuevo producto en la tabla 'detalle_pedidos'.
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

-- Este trigger se encarga de comprobar y actualizar el stock en la tabla 'productos' cuando se actualiza una fila en la tabla 'detalle_pedidos'.
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

-- Este trigger registra los pedidos que ya hayan finalizado todo su proceso logístico. Estos son considerados como los que su estado es 'Entregado' o 'Cancelado'.
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

-- Este trigger comprueba que durante el proceso de actualización de estado de un pedido, no puedan haber saltos entre los estados y se asegura de que se siga un proceso logístico correcto.
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

-- Este trigger registra cualquier pedido insertado en la tabla 'pedidos'.
DELIMITER //
CREATE TRIGGER registrar_seguimiento_inicial_pedidos
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
	INSERT INTO seguimiento_pedidos (pedido_id, fecha_registro, estado_anterior, estado_nuevo) VALUES (NEW.id, now(), NULL, obtener_nombre_estado(NEW.estado_id));
END;
// DELIMITER ;

-- Este trigger se encarga de registrar cualquier cambio de estado de un pedido.
DELIMITER //
CREATE TRIGGER registrar_seguimiento_pedidos
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
	INSERT INTO seguimiento_pedidos (pedido_id, fecha_registro, estado_anterior, estado_nuevo) VALUES (OLD.id, now(), obtener_nombre_estado(OLD.estado_id), obtener_nombre_estado(NEW.estado_id));
END;
// DELIMITER ;