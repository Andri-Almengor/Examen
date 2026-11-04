package com.tienda.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Centraliza la conexión JDBC con MySQL.
 * Las variables de entorno son opcionales y facilitan mover el proyecto
 * a otro equipo sin modificar el código fuente.
 */
public final class Conexion {

    private static final String URL = obtenerVariable(
        "DB_URL",
        "jdbc:mysql://localhost:3305/tienda"
        + "?useSSL=false"
        + "&allowPublicKeyRetrieval=true"
        + "&serverTimezone=UTC"
        + "&characterEncoding=UTF-8"
    );

    private static final String USUARIO =
        obtenerVariable("DB_USER", "tienda_app");

    private static final String CLAVE =
        obtenerVariable("DB_PASSWORD", "Tienda2026!");

    private Conexion() {
    }

    public static Connection obtenerConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "No se encontró el driver JDBC de MySQL.", e
            );
        }

        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }

    private static String obtenerVariable(
            String nombre, String valorPredeterminado) {

        String valor = System.getenv(nombre);

        if (valor == null || valor.trim().isEmpty()) {
            return valorPredeterminado;
        }

        return valor.trim();
    }
}
