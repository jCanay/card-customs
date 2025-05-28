-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS card_customs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE card_customs;

-- Creación de tablas
CREATE TABLE IF NOT EXISTS local (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Tienda', 'Taller', 'Almacen') NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS empleados (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_local INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    dni VARCHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_local) REFERENCES local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS clientes (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS etiquetas (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre ENUM('Nuevo', 'Popular', 'Oferta') NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS formato (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2) CHECK (precio >= 0) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS productos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    id_etiqueta INT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (id_etiqueta) REFERENCES etiquetas(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estilos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estado_pedido (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS metodos_pago (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
    tasa DECIMAL(10, 2) 
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS pedidos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    id_estado INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    iva_total DECIMAL(10, 2) NOT NULL,
    descuento_total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_estado) REFERENCES estado_pedido(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago(id) 
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    id_estilo INT NOT NULL,
    id_formato INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(5, 2) NOT NULL,
    descuento DECIMAL(5, 2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_producto) REFERENCES productos(id),
    FOREIGN KEY (id_estilo) REFERENCES estilos(id),
    FOREIGN KEY (id_formato) REFERENCES formato(id)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS historial_pedidos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    fecha_entrega DATETIME,
    estado_final ENUM('Entregado', 'Cancelado') NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;