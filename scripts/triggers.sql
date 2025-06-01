USE card_customs;

-- Este trigger se asegura de que siempre se use el precio correcto al insertar un producto en la tabla 'detalle_pedidos'
DELIMITER //
CREATE TRIGGER insertar_precio_unitario_detalle_pedidos 
BEFORE INSERT ON detalle_pedidos 
FOR EACH ROW
BEGIN
    SET NEW.precio_unitario = (SELECT p.precio FROM productos p WHERE id = NEW.producto_id);
END;
// DELIMITER ;

-- Este trigger se encarga de comprobar que exista suficiente stock antes de insertar un nuevo producto en la tabla 'detalle_pedidos'
DELIMITER //
CREATE TRIGGER comprobar_stock
BEFORE INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
	IF ((SELECT stock FROM productos WHERE id = NEW.producto_id) - NEW.cantidad < 0) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock';
    END IF;
END;
// DELIMITER ;

-- Este trigger se encarga de actualizar el stock en la tabla 'productos' cuando se inserte un nuevo producto en la tabla 'detalle_pedidos'

DELIMITER //
CREATE TRIGGER actualizar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
	DECLARE diferencia INT DEFAULT ((SELECT stock FROM productos WHERE id = NEW.producto_id) - NEW.cantidad);
	UPDATE productos SET stock = diferencia WHERE id = NEW.producto_id;
END;
// DELIMITER ;

-- Este trigger registra los pedidos que ya hayan finalizado todo su proceso logístico. Estos son considerados como los que su estado es 'Entregado' o 'Cancelado'

DELIMITER //
CREATE TRIGGER registrar_pedidos_historial
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
	IF (NEW.estado_id IN (3, 4)) THEN
		INSERT INTO historial_pedidos (pedido_id, fecha_entrega, estado_final) VALUES (NEW.pedido_id, now(), NEW.estado_id);
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
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado no puede pasar directamente de "Pendiente" a "Entregado"';
	ELSEIF (OLD.estado_id = 2 AND NEW.estado_id = 1) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede volver al estado "Pendiente" desde el estado "Enviado"';
	ELSEIF (OLD.estado_id IN (3, 4) AND NEW.estado_id IN (1, 2, 3, 4)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido ha llegado a su estado final y no puede ser modificado';
    END IF;
END;
// DELIMITER ;

