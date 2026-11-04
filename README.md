# Examen - CRUD de Productos

Aplicación web Java desarrollada con **JSP + Servlet + ADO/DAO + JDBC + MySQL**.

## Funcionalidades

- Crear productos.
- Consultar productos.
- Actualizar productos.
- Eliminar productos.
- Mostrar todos los registros en **Cards de Bootstrap**.
- Mostrar una imagen por producto mediante URL.
- Validar nombre, descripción, precio, stock y URL de imagen.
- Mostrar mensajes de confirmación y error.
- Utilizar `PreparedStatement` para las sentencias DML.

## Base de datos

Ejecute como administrador de MySQL:

`database/tienda.sql`

La configuración predeterminada de `Conexion.java` es:

- Base de datos: `tienda`
- Puerto: `3305`
- Usuario: `tienda_app`
- Contraseña: `Tienda2026!`

Si su MySQL usa otro puerto puede cambiar la URL en `Conexion.java` o definir las variables de entorno `DB_URL`, `DB_USER` y `DB_PASSWORD`.

## Ejecución

1. Ejecute el script SQL.
2. Abra el proyecto en NetBeans.
3. Verifique que Tomcat esté configurado.
4. Ejecute **Clean and Build**.
5. Ejecute el proyecto.

El conector JDBC se incluye en la carpeta `lib`.
