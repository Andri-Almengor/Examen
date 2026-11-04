<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Administración - Tienda CRUD</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/estilos.css" rel="stylesheet"></head><body>
<nav class="navbar navbar-dark app-navbar"><div class="container">
<a class="navbar-brand" href="<%=request.getContextPath()%>/productos">Tienda CRUD</a>
<a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/productos">Volver al catálogo</a></div></nav>
<main class="container py-5"><div class="row justify-content-center"><div class="col-md-6 col-lg-5">
<div class="card border-0 shadow-sm"><div class="card-body p-4 p-md-5">
<h1 class="h3 mb-2">Iniciar sesión</h1><p class="text-secondary mb-4">Acceso para administrar los productos.</p>
<% if("1".equals(request.getParameter("error"))){ %>
<div class="alert alert-danger">Usuario o contraseña incorrectos.</div>
<% } else if("bd".equals(request.getParameter("error"))){ %>
<div class="alert alert-danger">No se pudo conectar a MySQL.</div><% } %>
<form action="<%=request.getContextPath()%>/login" method="post">
<label class="form-label" for="usuario">Usuario</label>
<input id="usuario" name="usuario" type="text" class="form-control mb-3" maxlength="80" autocomplete="username" required>
<label class="form-label" for="contrasena">Contraseña</label>
<input id="contrasena" name="contrasena" type="password" class="form-control mb-4" autocomplete="current-password" required>
<button class="btn btn-primary w-100">Ingresar</button></form>
<a href="<%=request.getContextPath()%>/productos" class="d-block text-center mt-3">Continuar como visitante</a>
</div></div></div></div></main></body></html>
