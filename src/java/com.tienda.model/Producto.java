package com.tienda.model;

import java.math.BigDecimal;

/**
 * Modelo que representa un producto almacenado en MySQL.
 */
public class Producto {

    private final int id;
    private final String nombre;
    private final String descripcion;
    private final BigDecimal precio;
    private final int stock;
    private final String imagenUrl;

    public Producto(
            int id,
            String nombre,
            String descripcion,
            BigDecimal precio,
            int stock,
            String imagenUrl) {

        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.stock = stock;
        this.imagenUrl = imagenUrl;
    }

    public Producto(
            String nombre,
            String descripcion,
            BigDecimal precio,
            int stock,
            String imagenUrl) {

        this(0, nombre, descripcion, precio, stock, imagenUrl);
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public int getStock() {
        return stock;
    }

    public String getImagenUrl() {
        return imagenUrl;
    }
}
