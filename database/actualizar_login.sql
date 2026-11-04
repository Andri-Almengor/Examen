-- Ejecutar únicamente para una base tienda ya existente (no borra productos).
USE tienda;
CREATE TABLE IF NOT EXISTS usuarios (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nombre_usuario VARCHAR(80) NOT NULL UNIQUE,
 contrasena_hash VARCHAR(255) NOT NULL,
 activo TINYINT(1) NOT NULL DEFAULT 1
);
INSERT INTO usuarios (nombre_usuario, contrasena_hash, activo)
VALUES ('admin', 'pbkdf2_sha256$210000$x2IbTQIHnbhTkOV8I6kUug==$VbyecpPh3SlMoIB/isclwFCkWGzVxQcOweMf0odDrgQ=', 1)
ON DUPLICATE KEY UPDATE nombre_usuario=nombre_usuario;
