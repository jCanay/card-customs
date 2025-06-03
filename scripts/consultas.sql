USE card_customs;

-- Esta consulta funciona como una alerta de stock, clasificandolo por la cantidad de stock que hay.
SELECT p.id, p.nombre, p.stock, 
CASE
	WHEN p.stock > 10000 THEN 'Muy Alto'
	WHEN p.stock BETWEEN 5000 AND 10000 THEN 'Alto'
	WHEN p.stock BETWEEN 2500 AND 5000 THEN 'Normal'
    WHEN p.stock BETWEEN 1000 AND 2500 THEN 'Bajo'
    WHEN p.stock BETWEEN 0 AND 1000 THEN 'Muy bajo'
    ELSE 'Sin stock'
END estado
FROM productos p
ORDER BY p.stock ASC;

-- Devuelve todos los pedidos que se encuentran en estado "Pendiente" o "En preparación", mostrando la ID del pedido, la fecha, y el nombre del cliente.
SELECT pe.id, pe.fecha_pedido, c.nombre, c.apellidos, ep.nombre estado
FROM pedidos pe 
	JOIN clientes c ON pe.cliente_id = c.id 
	JOIN estado_pedido ep ON pe.estado_id = ep.id
WHERE ep.nombre IN ('Pendiente', 'En preparación')
ORDER BY pe.fecha_pedido ASC;

-- Devuelve el precio total de ventas de cada estilo de carta. Algo así como para saber que estilos son más populares o más vendidos.
SELECT e.nombre, concat(sum(dp.cantidad * dp.precio_unitario), ' €') total_ventas
FROM detalle_pedidos dp 
	JOIN estilos e ON dp.estilo_id = e.id
GROUP BY e.nombre
ORDER BY sum(dp.cantidad * dp.precio_unitario) DESC;

-- Muestra los datos completos de cada empleado junto con el tipo de local donde trabajan.
SELECT e.nombre, e.apellidos, e.email, l.direccion, t.nombre
FROM empleados e 
	JOIN local l ON e.local_id = l.id 
	JOIN tipo_local t ON l.tipo_id = t.id;

-- Lista los clientes que han hecho algún pedido en el ultimo mes.
SELECT DISTINCT c.*
FROM clientes c 
    JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha_pedido >= date_sub(curdate(), INTERVAL 1 MONTH);

-- Cuenta el numero de locales de tipo 'Tienda' que hay.
SELECT t.nombre, count(*) cantidad
FROM local l 
	JOIN tipo_local t ON t.id = l.tipo_id
WHERE t.nombre LIKE 'tienda' 
GROUP BY t.nombre;

-- Cuenta el numero de locales que hay de cada tipo en una localidad dada
SELECT t.nombre, count(*) cantidad
FROM local l
	JOIN tipo_local t ON t.id = l.tipo_id
WHERE l.localidad LIKE 'Madrid'
GROUP BY t.nombre;

-- Devuelve el empleado y el local donde trabaja el empleado con más sueldo en la empresa.
SELECT e.nombre, e.apellidos, t.nombre, l.localidad, l.direccion, e.salario
FROM empleados e 
	JOIN local l ON l.id = e.local_id 
	JOIN tipo_local t ON t.id = l.tipo_id 
WHERE e.salario = mayor_salario_empleados();

-- Devuelve los gastos en sueldos de cada tienda filtrado por su localidad.
SELECT l.localidad, concat(sum(e.salario), ' €') gastos_sueldos
FROM empleados e 
	JOIN local l ON e.local_id = l.id
GROUP BY l.localidad
ORDER BY sum(e.salario) DESC;

-- Devuelve el total ganado con todas las ventas de pedidos que se hayan entregado y no se hayan cancelado.
SELECT concat(sum(f.total), ' €') total_ventas
FROM facturas f 
	JOIN pedidos_finalizados pf ON f.pedido_id = pf.pedido_id 
WHERE pf.estado_final LIKE 'Entregado';

-- Devuelve los clientes que hayan gastado más de 100€ en total en todos sus pedidos que no hayan sido cancelados.
SELECT c.nombre, c.apellidos, c.email, concat(sum(f.total), ' €') total_gastado, count(p.id) cantidad_pedidos
FROM clientes c
	JOIN pedidos p ON p.cliente_id = c.id
	JOIN facturas f ON f.pedido_id = p.id
    JOIN pedidos_finalizados pf ON pf.pedido_id = f.pedido_id
WHERE pf.estado_final LIKE 'Entregado'
GROUP BY c.id
HAVING sum(f.total) > 100
ORDER BY sum(f.total) DESC;

-- Devuelve los empleados que cobren más que la media de los salarios.
SELECT e.dni, e.nombre, e.apellidos, e.salario, round((SELECT avg(em.salario) FROM empleados em), 2) media_salario 
FROM empleados e 
WHERE salario > (SELECT avg(em.salario) FROM empleados em)
ORDER BY e.salario DESC;