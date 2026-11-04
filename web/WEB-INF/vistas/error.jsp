<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.tienda.util.Html"%>

<%
    String mensaje =
        (String) request.getAttribute("mensaje");

    if (mensaje == null) {
        mensaje = "Ocurrió un error inesperado.";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Error - Tienda CRUD</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="<%= request.getContextPath() %>/css/estilos.css"
          rel="stylesheet">
</head>

<body>

<nav class="navbar navbar-dark app-navbar">
    <div class="container">
        <a class="navbar-brand fw-bold"
           href="<%= request.getContextPath() %>/productos">
            Tienda CRUD
        </a>
    </div>
</nav>

<main class="container py-5">

    <div class="row justify-content-center">
        <div class="col-lg-7">

            <div class="alert alert-danger shadow-sm p-4">

                <h1 class="h4">
                    No se pudo completar la solicitud
                </h1>

                <p>
                    <%= Html.escapar(mensaje) %>
                </p>

                <a href="<%= request.getContextPath() %>/productos"
                   class="btn btn-danger">
                    Volver al listado
                </a>

            </div>

        </div>
    </div>

</main>

</body>
</html>
