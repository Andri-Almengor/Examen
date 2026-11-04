<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.tienda.model.Producto,com.tienda.util.Html"%>
<%
 Producto p=(Producto)request.getAttribute("producto");
 boolean admin=session.getAttribute("usuario")!=null;
 String token=(String)session.getAttribute("csrfToken");
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=Html.escapar(p.getNombre())%> | Tienda CRUD</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/estilos.css" rel="stylesheet"></head><body>
<nav class="navbar navbar-expand navbar-dark app-navbar"><div class="container">
<a class="navbar-brand" href="<%=request.getContextPath()%>/productos">Tienda CRUD</a>
<div class="ms-auto d-flex gap-2">
<a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/productos">Catálogo</a>
<% if(admin){ %>
<form method="post" action="<%=request.getContextPath()%>/logout" class="m-0">
<input type="hidden" name="csrfToken" value="<%=Html.escapar(token)%>">
<button class="btn btn-outline-light btn-sm">Salir</button></form>
<% }else{ %><a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/login">Iniciar sesión</a><% } %>
</div></div></nav>
<main class="container py-5">
<a class="d-inline-block mb-4 text-decoration-none" href="<%=request.getContextPath()%>/productos">← Volver al catálogo</a>
<div class="card border-0 shadow-sm overflow-hidden"><div class="row g-0">
<div class="col-md-6"><img class="detalle-imagen" src="<%=Html.escapar(p.getImagenUrl())%>"
alt="<%=Html.escapar(p.getNombre())%>"
onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/img/no-image.svg';"></div>
<div class="col-md-6"><div class="card-body p-4 p-lg-5">
<span class="eyebrow">DETALLE DEL PRODUCTO</span>
<h1 class="h2 mb-3"><%=Html.escapar(p.getNombre())%></h1>
<p class="text-secondary detalle-descripcion"><%=Html.escapar(p.getDescripcion())%></p>
<div class="product-meta my-4">
<div><span class="meta-label">Precio</span><strong>₡<%=p.getPrecio().toPlainString()%></strong></div>
<div><span class="meta-label">Unidades disponibles</span><strong><%=p.getStock()%></strong></div></div>
<% if(p.getStock()>0){ %><span class="badge text-bg-success mb-4">Disponible</span>
<% }else{ %><span class="badge text-bg-secondary mb-4">Agotado</span><% } %>
<% if(admin){ %><div class="d-flex gap-2 flex-wrap">
<a class="btn btn-primary" href="<%=request.getContextPath()%>/productos?accion=editar&id=<%=p.getId()%>">Editar</a>
<form method="post" action="<%=request.getContextPath()%>/productos"
onsubmit="return confirm('¿Eliminar este producto?');">
<input type="hidden" name="accion" value="eliminar"><input type="hidden" name="id" value="<%=p.getId()%>">
<input type="hidden" name="csrfToken" value="<%=Html.escapar(token)%>">
<button class="btn btn-outline-danger">Eliminar</button></form></div><% } %>
</div></div></div></div>
</main></body></html>