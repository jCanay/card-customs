USE card_customs;

/* 
Esta vista se encarga de generar las facturas de cada pedido, calculando el subtotal y el total de cada una.

- subtotal: Se calcula utilizando la función 'calcular_subtotal_factura'.
- total: Se calcula utilizando la función 'calcular_subtotal_factura' multiplicada por la 'tasa'.
*/
CREATE VIEW facturas AS
SELECT pe.id pedido_id, pe.fecha_pedido, c.nombre, c.apellidos, m.nombre metodo_pago, m.tasa tarifa, round(sum(calcular_subtotal_factura(dp.precio_unitario, f.precio ,dp.cantidad, dp.iva, dp.descuento)), 2) subtotal, round(sum(calcular_total_factura(calcular_subtotal_factura(dp.precio_unitario, f.precio, dp.cantidad, dp.iva, dp.descuento), m.tasa)), 2) total
FROM pedidos pe 
	JOIN detalle_pedidos dp ON pe.id = dp.pedido_id 
	JOIN formato f ON f.id = dp.formato_id 
	JOIN metodos_pago m ON m.id = pe.metodo_pago_id 
	JOIN clientes c ON pe.cliente_id = c.id 
GROUP BY pe.id;

-- Esta vista almacena los pedidos que ya han finalizado su ciclo, tanto como si están entregados o cancelados.
CREATE VIEW pedidos_finalizados AS
SELECT h.pedido_id, pe.fecha_pedido, h.fecha_registro, ep.nombre estado_final, concat((datediff(h.fecha_registro, pe.fecha_pedido)), ' días') duracion
FROM historial_pedidos h 
	JOIN estado_pedido ep ON ep.id = h.estado_final 
	JOIN pedidos pe ON pe.id = h.pedido_id;