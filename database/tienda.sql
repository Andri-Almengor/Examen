-- =========================================================
-- Base de datos para el examen CRUD JSP + Servlet + ADO/DAO
-- Proyecto: Tienda CRUD
-- =========================================================

DROP DATABASE IF EXISTS tienda;

CREATE DATABASE tienda
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tienda;

CREATE TABLE productos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT UNSIGNED NOT NULL DEFAULT 0,
    imagen_url VARCHAR(1000) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT chk_productos_precio
        CHECK (precio >= 0),
    CONSTRAINT chk_productos_stock
        CHECK (stock >= 0)
);

-- Registros de ejemplo para que las Cards se vean al iniciar.
INSERT INTO productos
    (nombre, descripcion, precio, stock, imagen_url)
VALUES
    (
        'Reloj inteligente',
        'Reloj con pantalla digital y seguimiento de actividad.',
        45900.00,
        12,
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80'
    ),
    (
        'Audífonos inalámbricos',
        'Audífonos cómodos con conexión Bluetooth.',
        32500.00,
        20,
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80'
    ),
    (
        'Computadora portátil',
        'Equipo portátil para estudio, trabajo y navegación.',
        389900.00,
        6,
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=80'
    );

-- Administrador de demostración.
CREATE TABLE usuarios (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nombre_usuario VARCHAR(80) NOT NULL UNIQUE,
 contrasena_hash VARCHAR(255) NOT NULL,
 activo TINYINT(1) NOT NULL DEFAULT 1
);
INSERT INTO usuarios (nombre_usuario, contrasena_hash, activo)
VALUES ('admin', 'pbkdf2_sha256$210000$x2IbTQIHnbhTkOV8I6kUug==$VbyecpPh3SlMoIB/isclwFCkWGzVxQcOweMf0odDrgQ=', 1);

-- Usuario utilizado por Conexion.java.
-- Ejecute este script con una cuenta administradora de MySQL.
CREATE USER IF NOT EXISTS
    'tienda_app'@'localhost'
    IDENTIFIED BY 'Tienda2026!';

ALTER USER
    'tienda_app'@'localhost'
    IDENTIFIED BY 'Tienda2026!';

GRANT SELECT, INSERT, UPDATE, DELETE
    ON tienda.*
    TO 'tienda_app'@'localhost';

FLUSH PRIVILEGES;
