<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.tienda.model.Producto"%>
<%@page import="com.tienda.util.Html"%>

<%
    List<Producto> productos =
        (List<Producto>) request.getAttribute("productos");

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Productos - Tienda CRUD</title>

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

        <a class="btn btn-light btn-sm fw-semibold"
           href="<%= request.getContextPath() %>/productos?accion=nuevo">
            + Nuevo producto
        </a>

    </div>
</nav>

<header class="hero-section">
    <div class="container py-5">

        <div class="row align-items-end g-3">

            <div class="col-lg-8">
                <span class="eyebrow">INVENTARIO</span>

                <h1 class="display-6 fw-bold mb-2">
                    Productos registrados
                </h1>

                <p class="lead text-secondary mb-0">
                    Crea, consulta, actualiza y elimina productos
                    desde una sola interfaz.
                </p>
            </div>

            <div class="col-lg-4 text-lg-end">
                <span class="badge text-bg-dark fs-6 px-3 py-2">
                    Total:
                    <%= productos == null ? 0 : productos.size() %>
                </span>
            </div>

        </div>
    </div>
</header>

<main class="container pb-5">

    <% if ("creado".equals(mensaje)) { %>
        <div class="alert alert-success shadow-sm">
            Producto creado correctamente.
        </div>
    <% } else if ("actualizado".equals(mensaje)) { %>
        <div class="alert alert-success shadow-sm">
            Producto actualizado correctamente.
        </div>
    <% } else if ("eliminado".equals(mensaje)) { %>
        <div class="alert alert-success shadow-sm">
            Producto eliminado correctamente.
        </div>
    <% } else if ("noexiste".equals(mensaje)) { %>
        <div class="alert alert-warning shadow-sm">
            El producto solicitado ya no existe.
        </div>
    <% } else if ("error".equals(mensaje)) { %>
        <div class="alert alert-danger shadow-sm">
            No se pudo completar la operación.
        </div>
    <% } %>

    <% if (productos != null && !productos.isEmpty()) { %>

        <div class="row g-4">

        <% for (Producto producto : productos) { %>

            <div class="col-12 col-sm-6 col-lg-4">

                <article class="card product-card h-100 border-0 shadow-sm">

                    <img src="<%= Html.escapar(producto.getImagenUrl()) %>"
                         class="card-img-top product-image"
                         alt="Imagen de <%= Html.escapar(producto.getNombre()) %>"
                         loading="lazy"
                         onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/img/no-image.svg';">

                    <div class="card-body d-flex flex-column p-4">

                        <div class="d-flex justify-content-between
                                    align-items-start gap-3 mb-3">

                            <h2 class="h5 card-title mb-0">
                                <%= Html.escapar(producto.getNombre()) %>
                            </h2>

                            <span class="badge rounded-pill text-bg-light">
                                #<%= producto.getId() %>
                            </span>

                        </div>

                        <p class="card-text text-secondary product-description">
                            <%= Html.escapar(producto.getDescripcion()) %>
                        </p>

                        <div class="product-meta mt-auto pt-3">

                            <div>
                                <span class="meta-label">Precio</span>
                                <strong>
                                    ₡<%= producto.getPrecio().toPlainString() %>
                                </strong>
                            </div>

                            <div>
                                <span class="meta-label">Stock</span>
                                <strong>
                                    <%= producto.getStock() %>
                                </strong>
                            </div>

                        </div>

                    </div>

                    <div class="card-footer bg-white border-0 px-4 pb-4 pt-0">

                        <div class="d-flex gap-2">

                            <a href="<%= request.getContextPath() %>/productos?accion=editar&id=<%= producto.getId() %>"
                               class="btn btn-outline-primary flex-grow-1">
                                Editar
                            </a>

                            <form action="<%= request.getContextPath() %>/productos"
                                  method="POST"
                                  class="flex-grow-1"
                                  onsubmit="return confirm('¿Deseas eliminar este producto?');">

                                <input type="hidden"
                                       name="accion"
                                       value="eliminar">

                                <input type="hidden"
                                       name="id"
                                       value="<%= producto.getId() %>">

                                <button type="submit"
                                        class="btn btn-outline-danger w-100">
                                    Eliminar
                                </button>

                            </form>

                        </div>

                    </div>

                </article>

            </div>

        <% } %>

        </div>

    <% } else { %>

        <div class="card empty-state border-0 shadow-sm">

            <div class="card-body text-center p-5">

                <h2 class="h4">
                    Aún no hay productos
                </h2>

                <p class="text-secondary mb-4">
                    Registra el primer producto para comenzar
                    a utilizar el CRUD.
                </p>

                <a href="<%= request.getContextPath() %>/productos?accion=nuevo"
                   class="btn btn-primary">
                    Crear primer producto
                </a>

            </div>

        </div>

    <% } %>

</main>

</body>
</html>
