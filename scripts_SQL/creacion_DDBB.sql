-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS card_customs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE card_customs;

-- Creación de tablas
CREATE TABLE IF NOT EXISTS `clientes` (
    `id_cliente` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `apellidos` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `direccion` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(15),
    PRIMARY KEY (`id_cliente`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;