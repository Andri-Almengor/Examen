<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,com.tienda.model.Producto,com.tienda.util.Html"%>
<%
 List<Producto> productos=(List<Producto>)request.getAttribute("productos");
 boolean admin=session.getAttribute("usuario")!=null;
 String token=(String)session.getAttribute("csrfToken");
 String mensaje=request.getParameter("mensaje");
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Catálogo | Tienda CRUD</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/estilos.css" rel="stylesheet"></head>
<body><nav class="navbar navbar-expand navbar-dark app-navbar"><div class="container gap-2">
<a class="navbar-brand fw-bold" href="<%=request.getContextPath()%>/productos">Tienda CRUD</a>
<div class="ms-auto d-flex gap-2 align-items-center">
<% if(admin){ %>
<a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/productos?accion=nuevo">+ Nuevo producto</a>
<form method="post" action="<%=request.getContextPath()%>/logout" class="m-0">
<input type="hidden" name="csrfToken" value="<%=Html.escapar(token)%>">
<button class="btn btn-outline-light btn-sm">Cerrar sesión</button></form>
<% }else{ %>
<a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/login">Iniciar sesión</a>
<% } %></div></div></nav>
<header class="hero-section"><div class="container py-5">
<span class="eyebrow"><%=admin?"ADMINISTRACIÓN":"CATÁLOGO"%></span>
<h1 class="display-6 fw-bold"><%=admin?"Gestionar productos":"Explora nuestros productos"%></h1>
<p class="lead text-secondary"><%=admin?"Crea, edita o elimina los artículos.":"Visita el detalle de cualquier artículo sin registrarte."%></p>
</div></header>
<main class="container pb-5">
<% if("creado".equals(mensaje)){ %><div class="alert alert-success">Producto creado correctamente.</div>
<% }else if("actualizado".equals(mensaje)){ %><div class="alert alert-success">Producto actualizado correctamente.</div>
<% }else if("eliminado".equals(mensaje)){ %><div class="alert alert-success">Producto eliminado correctamente.</div>
<% }else if("noexiste".equals(mensaje)){ %><div class="alert alert-warning">El producto ya no existe.</div>
<% }else if("error".equals(mensaje)){ %><div class="alert alert-danger">No se pudo completar la operación.</div>
<% }else if("bienvenido".equals(mensaje)&&admin){ %><div class="alert alert-success">Sesión iniciada correctamente.</div>
<% }else if("salida".equals(mensaje)){ %><div class="alert alert-info">Ahora navegas como visitante.</div><% } %>
<div class="d-flex justify-content-between align-items-center mb-4">
<h2 class="h5 mb-0">Productos disponibles</h2>
<span class="badge text-bg-dark"><%=productos==null?0:productos.size()%> productos</span></div>
<% if(productos!=null&&!productos.isEmpty()){ %>
<div class="row g-4">
<% for(Producto p:productos){ %>
<div class="col-12 col-sm-6 col-lg-4"><article class="card product-card h-100 border-0 shadow-sm">
<a href="<%=request.getContextPath()%>/productos?accion=detalle&id=<%=p.getId()%>">
<img src="<%=Html.escapar(p.getImagenUrl())%>" class="card-img-top product-image"
alt="<%=Html.escapar(p.getNombre())%>" loading="lazy"
onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/img/no-image.svg';"></a>
<div class="card-body d-flex flex-column p-4">
<h3 class="h5"><%=Html.escapar(p.getNombre())%></h3>
<p class="text-secondary product-description"><%=Html.escapar(p.getDescripcion())%></p>
<div class="product-meta mt-auto pt-3"><div><span class="meta-label">Precio</span>
<strong>₡<%=p.getPrecio().toPlainString()%></strong></div>
<div><span class="meta-label">Stock</span><strong><%=p.getStock()%></strong></div></div>
</div><div class="card-footer bg-white border-0 px-4 pb-4 pt-0">
<a class="btn btn-primary w-100 mb-2"
href="<%=request.getContextPath()%>/productos?accion=detalle&id=<%=p.getId()%>">Ver detalles</a>
<% if(admin){ %><div class="d-flex gap-2">
<a class="btn btn-outline-primary flex-grow-1" href="<%=request.getContextPath()%>/productos?accion=editar&id=<%=p.getId()%>">Editar</a>
<form class="flex-grow-1" method="post" action="<%=request.getContextPath()%>/productos"
onsubmit="return confirm('¿Eliminar este producto?');">
<input type="hidden" name="accion" value="eliminar">
<input type="hidden" name="id" value="<%=p.getId()%>">
<input type="hidden" name="csrfToken" value="<%=Html.escapar(token)%>">
<button class="btn btn-outline-danger w-100">Eliminar</button></form></div><% } %>
</div></article></div>
<% } %></div>
<% }else{ %><div class="card border-0 shadow-sm"><div class="card-body text-center p-5">
<h2 class="h4">No hay productos registrados</h2>
<p class="text-secondary">Los nuevos productos aparecerán aquí.</p>
<% if(admin){ %><a href="<%=request.getContextPath()%>/productos?accion=nuevo" class="btn btn-primary">Agregar producto</a><% } %>
</div></div><% } %>
</main></body></html>