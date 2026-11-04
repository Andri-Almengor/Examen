<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.tienda.model.Producto"%>
<%@page import="com.tienda.util.Html"%>

<%
    String modo = (String) request.getAttribute("modo");
    boolean editar = "editar".equals(modo);

    Producto producto =
        (Producto) request.getAttribute("producto");

    String error =
        (String) request.getAttribute("error");

    Integer idFormulario =
        (Integer) request.getAttribute("idFormulario");

    String nombre =
        (String) request.getAttribute("nombreFormulario");
    String descripcion =
        (String) request.getAttribute("descripcionFormulario");
    String precio =
        (String) request.getAttribute("precioFormulario");
    String stock =
        (String) request.getAttribute("stockFormulario");
    String token = (String) session.getAttribute("csrfToken");

    String imagen =
        (String) request.getAttribute("imagenFormulario");

    if (nombre == null && producto != null) {
        nombre = producto.getNombre();
    }
    if (descripcion == null && producto != null) {
        descripcion = producto.getDescripcion();
    }
    if (precio == null && producto != null) {
        precio = producto.getPrecio().toPlainString();
    }
    if (stock == null && producto != null) {
        stock = String.valueOf(producto.getStock());
    }
    if (imagen == null && producto != null) {
        imagen = producto.getImagenUrl();
    }

    if (idFormulario == null && producto != null) {
        idFormulario = producto.getId();
    }

    nombre = nombre == null ? "" : nombre;
    descripcion = descripcion == null ? "" : descripcion;
    precio = precio == null ? "" : precio;
    stock = stock == null ? "" : stock;
    imagen = imagen == null ? "" : imagen;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>
        <%= editar ? "Editar producto" : "Nuevo producto" %>
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="<%= request.getContextPath() %>/css/estilos.css"
          rel="stylesheet">
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark app-navbar">
    <div class="container">
        <a class="navbar-brand fw-bold"
           href="<%= request.getContextPath() %>/productos">
            Tienda CRUD
        </a>

        <a class="btn btn-outline-light btn-sm"
           href="<%= request.getContextPath() %>/productos">
            Ver productos
        </a>
    </div>
</nav>

<main class="container py-5">

    <div class="row justify-content-center">
        <div class="col-lg-8 col-xl-7">

            <div class="card form-card border-0 shadow-sm">

                <div class="card-body p-4 p-md-5">

                    <div class="mb-4">
                        <span class="eyebrow">
                            <%= editar ? "ACTUALIZAR" : "CREAR" %>
                        </span>

                        <h1 class="h3 mb-2">
                            <%= editar
                                ? "Editar producto"
                                : "Registrar nuevo producto" %>
                        </h1>

                        <p class="text-secondary mb-0">
                            Completa todos los campos. La imagen se
                            almacena mediante una URL.
                        </p>
                    </div>

                    <% if (error != null) { %>
                        <div class="alert alert-warning"
                             role="alert">
                            <%= Html.escapar(error) %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/productos"
                          method="POST">

                        <input type="hidden" name="csrfToken" value="<%= Html.escapar(token) %>">
                        <input type="hidden"
                               name="accion"
                               value="<%= editar
                                   ? "actualizar"
                                   : "registrar" %>">

                        <% if (editar && idFormulario != null) { %>
                            <input type="hidden"
                                   name="id"
                                   value="<%= idFormulario %>">
                        <% } %>

                        <div class="mb-3">
                            <label for="nombre"
                                   class="form-label">
                                Nombre
                            </label>

                            <input id="nombre"
                                   type="text"
                                   name="nombre"
                                   class="form-control"
                                   maxlength="120"
                                   value="<%= Html.escapar(nombre) %>"
                                   placeholder="Ej: Audífonos inalámbricos"
                                   required>
                        </div>

                        <div class="mb-3">
                            <label for="descripcion"
                                   class="form-label">
                                Descripción
                            </label>

                            <textarea id="descripcion"
                                      name="descripcion"
                                      class="form-control"
                                      rows="4"
                                      maxlength="500"
                                      placeholder="Información relevante del producto"
                                      required><%= Html.escapar(descripcion) %></textarea>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="precio"
                                       class="form-label">
                                    Precio
                                </label>

                                <div class="input-group">
                                    <span class="input-group-text">₡</span>
                                    <input id="precio"
                                           type="number"
                                           name="precio"
                                           class="form-control"
                                           min="0"
                                           max="99999999.99"
                                           step="0.01"
                                           value="<%= Html.escapar(precio) %>"
                                           placeholder="0.00"
                                           required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="stock"
                                       class="form-label">
                                    Stock
                                </label>

                                <input id="stock"
                                       type="number"
                                       name="stock"
                                       class="form-control"
                                       min="0"
                                       max="1000000"
                                       step="1"
                                       value="<%= Html.escapar(stock) %>"
                                       placeholder="0"
                                       required>
                            </div>
                        </div>

                        <div class="mt-3 mb-4">
                            <label for="imagenUrl"
                                   class="form-label">
                                URL de la imagen
                            </label>

                            <input id="imagenUrl"
                                   type="url"
                                   name="imagenUrl"
                                   class="form-control"
                                   maxlength="1000"
                                   value="<%= Html.escapar(imagen) %>"
                                   placeholder="https://ejemplo.com/imagen.jpg"
                                   required>

                            <div class="form-text">
                                Debe iniciar con http:// o https://.
                            </div>
                        </div>

                        <div class="d-flex flex-wrap gap-2">

                            <button type="submit"
                                    class="btn btn-primary px-4">
                                <%= editar
                                    ? "Guardar cambios"
                                    : "Crear producto" %>
                            </button>

                            <a href="<%= request.getContextPath() %>/productos"
                               class="btn btn-outline-secondary px-4">
                                Cancelar
                            </a>

                        </div>

                    </form>

                </div>
            </div>

        </div>
    </div>

</main>

</body>
</html>
