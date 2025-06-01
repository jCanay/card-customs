USE card_customs;

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