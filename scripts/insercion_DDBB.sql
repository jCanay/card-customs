USE card_customs;

INSERT INTO local (tipo, direccion, localidad, email, telefono) VALUES
('Tienda', 'Calle Mayor 123', 'Madrid', 'tienda.madrid@cardcustoms.com', '912345678'),
('Taller', 'Avenida del Sol 45', 'Barcelona', 'taller.bcn@cardcustoms.com', '934567890'),
('Almacen', 'Polígono Industrial Las Rozas Nave 10', 'Madrid', 'almacen.madrid@cardcustoms.com', '919876543'),
('Tienda', 'Gran Vía 5', 'Valencia', 'tienda.vlc@cardcustoms.com', '961234567');

INSERT INTO empleados (id_local, nombre, apellidos, dni, email, telefono, fecha_contratacion, salario) VALUES
(1, 'Ana', 'García Pérez', '12345678A', 'ana.garcia@cardcustoms.com', '600112233', '2022-01-15', 1800.00),
(1, 'Juan', 'Martínez López', '87654321B', 'juan.martinez@cardcustoms.com', '600445566', '2021-03-01', 1950.00),
(2, 'María', 'Rodríguez Sánchez', '11223344C', 'maria.rodri@cardcustoms.com', '611223344', '2023-05-10', 2200.00),
(3, 'Pedro', 'Fernández Ruiz', '55667788D', 'pedro.fer@cardcustoms.com', '622334455', '2020-11-20', 2100.00),
(4, 'Laura', 'Gómez Martín', '99887766E', 'laura.gomez@cardcustoms.com', '633445566', '2024-02-01', 1750.00),
(1, 'Miguel', 'Santos Heredia', '01020304F', 'miguel.san@cardcustoms.com', '644556677', '2023-09-01', 1900.00),
(2, 'Isabel', 'Vázquez Soto', '05060708G', 'isabel.vaz@cardcustoms.com', '655667788', '2022-07-10', 2050.00),
(3, 'Javier', 'Ramírez Castro', '09101112H', 'javier.ram@cardcustoms.com', '666778899', '2021-04-25', 2150.00),
(4, 'Carmen', 'Díaz Navarro', '13141516I', 'carmen.diaz@cardcustoms.com', '677889900', '2024-01-15', 1850.00);

INSERT INTO clientes (nombre, apellidos, email, direccion, telefono) VALUES
('Carlos', 'Serrano Vega', 'carlos.serrano@email.com', 'Calle Falsa 123', '655112233'),
('Sofía', 'Jiménez Díaz', 'sofia.jimenez@email.com', 'Plaza Real 4', '677889900'),
('David', 'Ruiz Morales', 'david.ruiz@email.com', 'Avenida de la Paz 78', NULL),
('Elena', 'Blanco Costa', 'elena.blanco@email.com', 'Paseo Marítimo 10', '688990011'),
('Francisco', 'Ruiz García', 'francisco.ruiz@email.com', 'Callejón del Gato 5', '612345678'),
('Patricia', 'Hernández Gómez', 'patricia.hdez@email.com', 'Ronda de Segovia 20', '623456789'),
('Roberto', 'López Fernández', 'roberto.lopez@email.com', 'Calle del Pez 1', NULL),
('Andrea', 'Martín Torres', 'andrea.martin@email.com', 'Travesía de la Parra 15', '634567890');

INSERT INTO etiquetas (nombre, descripcion) VALUES
('Nuevo', 'Producto recientemente añadido al catálogo.'),
('Popular', 'Uno de nuestros productos más vendidos.'),
('Oferta', 'Producto con un descuento especial por tiempo limitado.');

INSERT INTO formato (nombre, descripcion, precio) VALUES
('Original', 'Formato de carta Magic The Gathering estándar.', 0.00),
('Arte', 'La ilustración de la carta es personalizada a mano por un artista.', 150.00),
('Poster', 'Poster de gran tamaño con la ilustración de la carta.', 25.00),
('Cuadro', 'Cuadro enmarcado con la ilustración de la carta.', 50.00),
('Lienzo', 'Impresión de la ilustración de la carta en lienzo.', 75.00);

INSERT INTO productos (nombre, descripcion, id_etiqueta, precio, stock) VALUES
('Black Lotus', 'Carta de artefacto legendario, una de las más poderosas del juego.', 2, 50000.00, 5),
('Mox Jet', 'Carta de artefacto de mana rápido.', 1, 15000.00, 10),
('Lightning Bolt', 'Hechizo de daño directo, clásico e indispensable.', 3, 3.50, 1000),
('Counterspell', 'Hechizo de anulación, fundamental en control.', NULL, 7.00, 800),
('Sol Ring', 'Artefacto que acelera el mana, muy popular en Commander.', 2, 25.00, 300),
('Force of Will', 'Contrarresto de coste alternativo, esencial en Legacy y Vintage.', NULL, 75.00, 50),
('Goblin Guide', 'Criatura rápida y agresiva para mazos rojos.', 2, 10.00, 200),
('Brainstorm', 'Hechizo azul de robo y manipulación, staple en muchos formatos.', 1, 6.00, 700),
('Dark Confidant', 'Criatura que te permite robar cartas a cambio de vida.', 3, 40.00, 80),
('Mana Crypt', 'Artefacto que produce mana incoloro, con un riesgo.', 1, 180.00, 20),
('Swords to Plowshares', 'Eliminador de criaturas blanco, muy eficiente.', 3, 4.00, 600),
('Path to Exile', 'Otro eliminador blanco, para exiliar criaturas.', NULL, 3.00, 550);

INSERT INTO estilos (nombre, descripcion) VALUES
('Gótico', 'Diseño oscuro y detallado con motivos medievales y gárgolas.'),
('Cyberpunk', 'Estilo futurista con neones, circuitos y elementos tecnológicos.'),
('Minimalista', 'Diseño limpio y sencillo con líneas claras y colores sobrios.'),
('Acuarela', 'Ilustraciones con efecto de pintura a la acuarela, suaves y vibrantes.');

INSERT INTO pedidos (id_cliente, fecha_pedido, estado, metodo_pago, iva_total, descuento_total, total) VALUES
(1, '2025-05-20 10:30:00', 'Entregado', 'Tarjeta', 10500.00, 0.00, 60500.00),
(2, '2025-05-21 14:00:00', 'Enviado', 'Paypal', 0.73, 0.00, 8.23),
(3, '2025-05-22 09:15:00', 'Pendiente', 'Transferencia', 0.66, 0.00, 7.66),
(4, '2025-05-23 16:45:00', 'Cancelado', 'Tarjeta', 0.00, 0.00, 0.00),
(5, '2025-05-24 11:00:00', 'Enviado', 'Tarjeta', 15.75, 0.00, 90.75),
(6, '2025-05-24 17:30:00', 'Pendiente', 'Paypal', 1.26, 0.00, 7.26),
(7, '2025-05-25 09:00:00', 'Entregado', 'Transferencia', 8.40, 0.00, 48.40),
(8, '2025-05-26 13:00:00', 'Pendiente', 'Tarjeta', 2.10, 0.00, 12.10),
(1, '2025-05-26 15:00:00', 'Pendiente', 'Tarjeta', 3150.00, 0.00, 18150.00),
(2, '2025-05-26 16:00:00', 'Enviado', 'Paypal', 1.68, 0.00, 9.68),
(3, '2025-05-27 09:30:00', 'Pendiente', 'Transferencia', 10.50, 0.00, 60.50),
(4, '2025-05-27 10:00:00', 'Pendiente', 'Tarjeta', 15.75, 0.00, 90.75),
(5, '2025-05-27 11:00:00', 'Enviado', 'Tarjeta', 5.25, 0.00, 30.25),
(6, '2025-05-27 12:00:00', 'Pendiente', 'Paypal', 0.63, 0.00, 3.63),
(7, '2025-05-27 13:00:00', 'Entregado', 'Tarjeta', 37.80, 0.00, 217.80),
(8, '2025-05-27 14:00:00', 'Pendiente', 'Transferencia', 1.47, 0.00, 8.47),
(1, '2025-05-27 15:00:00', 'Pendiente', 'Tarjeta', 21.00, 0.00, 121.00),
(2, '2025-05-27 15:30:00', 'Pendiente', 'Paypal', 5.25, 0.00, 30.25),
(3, '2025-05-27 16:00:00', 'Pendiente', 'Tarjeta', 1.05, 0.00, 6.05),
(4, '2025-05-27 16:30:00', 'Pendiente', 'Transferencia', 1.05, 0.00, 6.05),
(5, '2025-05-27 17:00:00', 'Enviado', 'Tarjeta', 8.40, 0.00, 48.40),
(6, '2025-05-27 17:30:00', 'Pendiente', 'Paypal', 15.75, 0.00, 90.75),
(7, '2025-05-27 18:00:00', 'Pendiente', 'Tarjeta', 3150.00, 0.00, 18150.00),
(8, '2025-05-27 18:30:00', 'Pendiente', 'Transferencia', 5.25, 0.00, 30.25),
(1, '2025-05-27 19:00:00', 'Cancelado', 'Tarjeta', 0.00, 0.00, 0.00),
(2, '2025-05-27 20:00:00', 'Cancelado', 'Paypal', 0.00, 0.00, 0.00);

INSERT INTO detalle_pedidos (id_pedido, id_producto, id_estilo, id_formato, cantidad, precio_unitario, iva, descuento, subtotal) VALUES
(1, 1, 1, 1, 1, 50000.00, 21.00, 0.00, 50000.00),
(2, 3, 3, 1, 2, 3.50, 21.00, 0.00, 7.00),
(3, 4, 4, 1, 1, 7.00, 21.00, 0.00, 7.00),
(5, 6, 1, 1, 1, 75.00, 21.00, 0.00, 75.00),
(6, 7, 2, 1, 1, 10.00, 21.00, 0.00, 10.00),
(7, 9, 3, 1, 1, 40.00, 21.00, 0.00, 40.00),
(8, 8, 4, 1, 2, 6.00, 21.00, 0.00, 12.00),
(9, 2, 2, 2, 1, 15000.00, 21.00, 0.00, 15000.00),
(10, 3, 1, 1, 3, 3.50, 21.00, 0.00, 10.50),
(11, 5, 3, 4, 1, 25.00, 21.00, 0.00, 25.00),
(12, 6, 4, 5, 1, 75.00, 21.00, 0.00, 75.00),
(13, 7, 1, 3, 1, 10.00, 21.00, 0.00, 10.00),
(13, 8, 2, 1, 1, 6.00, 21.00, 0.00, 6.00),
(14, 11, 3, 1, 1, 4.00, 21.00, 0.00, 4.00),
(15, 10, 4, 1, 1, 180.00, 21.00, 0.00, 180.00),
(16, 12, 1, 1, 1, 3.00, 21.00, 0.00, 3.00),
(16, 3, 2, 1, 1, 3.50, 21.00, 0.00, 3.50),
(17, 10, 1, 2, 1, 180.00, 21.00, 0.00, 180.00),
(18, 3, 2, 3, 1, 3.50, 21.00, 0.00, 3.50),
(19, 12, 3, 1, 1, 3.00, 21.00, 0.00, 3.00),
(20, 11, 4, 1, 1, 4.00, 21.00, 0.00, 4.00),
(21, 9, 1, 1, 1, 40.00, 21.00, 0.00, 40.00),
(22, 6, 2, 1, 1, 75.00, 21.00, 0.00, 75.00),
(22, 8, 3, 1, 1, 6.00, 21.00, 0.00, 6.00),
(23, 2, 4, 5, 1, 15000.00, 21.00, 0.00, 15000.00),
(24, 5, 1, 3, 1, 25.00, 21.00, 0.00, 25.00),
(25, 4, 2, 1, 1, 7.00, 21.00, 0.00, 7.00),
(26, 7, 3, 1, 1, 10.00, 21.00, 0.00, 10.00),
(26, 11, 4, 1, 1, 4.00, 21.00, 0.00, 4.00);

INSERT INTO historial_pedidos (id_pedido, fecha_pedido, fecha_entrega, estado_final) VALUES
(1, '2025-05-20 10:30:00', '2025-05-25 18:00:00', 'Entregado'),
(4, '2025-05-23 16:45:00', NULL, 'Cancelado'),
(5, '2025-05-24 11:00:00', '2025-05-27 10:00:00', 'Entregado'),
(7, '2025-05-25 09:00:00', '2025-05-27 15:30:00', 'Entregado'),
(10, '2025-05-26 16:00:00', '2025-05-27 11:30:00', 'Entregado'),
(13, '2025-05-27 11:00:00', '2025-05-27 14:00:00', 'Entregado'),
(15, '2025-05-27 13:00:00', '2025-05-27 16:00:00', 'Entregado'),
(21, '2025-05-27 17:00:00', '2025-05-28 10:00:00', 'Entregado'),
(25, '2025-05-27 19:00:00', NULL, 'Cancelado'),
(26, '2025-05-27 20:00:00', NULL, 'Cancelado');