package com.tienda.dao;

import com.tienda.model.Producto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

/**
 * ADO/DAO responsable de todas las sentencias DML de productos.
 */
public class ProductoDAO {

    public boolean insertar(Producto producto) throws SQLException {

        String sql =
            "INSERT INTO productos "
            + "(nombre, descripcion, precio, stock, imagen_url) "
            + "VALUES (?, ?, ?, ?, ?)";

        try (
            Connection conexion = Conexion.obtenerConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            cargarParametros(ps, producto);
            return ps.executeUpdate() == 1;
        }
    }

    public List<Producto> listar() throws SQLException {

        List<Producto> productos = new ArrayList<>();

        String sql =
            "SELECT id, nombre, descripcion, precio, stock, imagen_url "
            + "FROM productos ORDER BY id DESC";

        try (
            Connection conexion = Conexion.obtenerConexion();
            PreparedStatement ps = conexion.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                productos.add(mapear(rs));
            }
        }

        return productos;
    }

    public Producto buscarPorId(int id) throws SQLException {

        String sql =
            "SELECT id, nombre, descripcion, precio, stock, imagen_url "
            + "FROM productos WHERE id = ?";

        try (
            Connection conexion = Conexion.obtenerConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public boolean actualizar(int id, Producto producto)
            throws SQLException {

        String sql =
            "UPDATE productos "
            + "SET nombre = ?, descripcion = ?, precio = ?, "
            + "stock = ?, imagen_url = ? "
            + "WHERE id = ?";

        try (
            Connection conexion = Conexion.obtenerConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            cargarParametros(ps, producto);
            ps.setInt(6, id);

            return ps.executeUpdate() == 1;
        }
    }

    public boolean eliminar(int id) throws SQLException {

        String sql = "DELETE FROM productos WHERE id = ?";

        try (
            Connection conexion = Conexion.obtenerConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        }
    }

    private void cargarParametros(
            PreparedStatement ps, Producto producto)
            throws SQLException {

        ps.setString(1, producto.getNombre());
        ps.setString(2, producto.getDescripcion());
        ps.setBigDecimal(3, producto.getPrecio());
        ps.setInt(4, producto.getStock());
        ps.setString(5, producto.getImagenUrl());
    }

    private Producto mapear(ResultSet rs) throws SQLException {

        return new Producto(
            rs.getInt("id"),
            rs.getString("nombre"),
            rs.getString("descripcion"),
            rs.getBigDecimal("precio"),
            rs.getInt("stock"),
            rs.getString("imagen_url")
        );
    }
}
