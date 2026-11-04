package com.tienda.util;

import com.tienda.model.Producto;

import java.math.BigDecimal;
import java.net.URI;

/**
 * Validaciones de negocio reutilizadas al crear y actualizar productos.
 */
public final class ProductoValidator {

    private ProductoValidator() {
    }

    public static Producto validar(
            String nombre,
            String descripcion,
            String precioTexto,
            String stockTexto,
            String imagenUrl) {

        nombre = limpiar(nombre);
        descripcion = limpiar(descripcion);
        precioTexto = limpiar(precioTexto);
        stockTexto = limpiar(stockTexto);
        imagenUrl = limpiar(imagenUrl);

        if (nombre.isEmpty()) {
            throw new IllegalArgumentException(
                "El nombre del producto es obligatorio."
            );
        }

        if (nombre.length() > 120) {
            throw new IllegalArgumentException(
                "El nombre no puede superar 120 caracteres."
            );
        }

        if (descripcion.isEmpty()) {
            throw new IllegalArgumentException(
                "La descripción es obligatoria."
            );
        }

        if (descripcion.length() > 500) {
            throw new IllegalArgumentException(
                "La descripción no puede superar 500 caracteres."
            );
        }

        BigDecimal precio;

        try {
            precio = new BigDecimal(precioTexto.replace(",", "."));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                "Ingrese un precio válido."
            );
        }

        if (precio.signum() < 0
                || precio.scale() > 2
                || precio.compareTo(
                    new BigDecimal("99999999.99")) > 0) {

            throw new IllegalArgumentException(
                "El precio debe estar entre 0 y 99999999.99 "
                + "y tener máximo dos decimales."
            );
        }

        int stock;

        try {
            stock = Integer.parseInt(stockTexto);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                "El stock debe ser un número entero."
            );
        }

        if (stock < 0 || stock > 1000000) {
            throw new IllegalArgumentException(
                "El stock debe estar entre 0 y 1 000 000."
            );
        }

        validarUrlImagen(imagenUrl);

        return new Producto(
            nombre,
            descripcion,
            precio,
            stock,
            imagenUrl
        );
    }

    private static void validarUrlImagen(String imagenUrl) {

        if (imagenUrl.isEmpty()) {
            throw new IllegalArgumentException(
                "La URL de la imagen es obligatoria."
            );
        }

        if (imagenUrl.length() > 1000) {
            throw new IllegalArgumentException(
                "La URL de la imagen es demasiado larga."
            );
        }

        try {
            URI uri = new URI(imagenUrl);
            String esquema = uri.getScheme();

            boolean http =
                "http".equalsIgnoreCase(esquema)
                || "https".equalsIgnoreCase(esquema);

            if (!http || uri.getHost() == null) {
                throw new IllegalArgumentException(
                    "La imagen debe utilizar una URL http o https válida."
                );
            }

        } catch (IllegalArgumentException e) {
            throw e;

        } catch (Exception e) {
            throw new IllegalArgumentException(
                "La URL de la imagen no es válida."
            );
        }
    }

    private static String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
