package com.tienda.servlet;

import com.tienda.dao.ProductoDAO;
import com.tienda.model.Producto;
import com.tienda.util.ProductoValidator;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controlador del CRUD de productos.
 * GET: listar, abrir formulario de creación y abrir formulario de edición.
 * POST: crear, actualizar y eliminar.
 */
@WebServlet("/productos")
public class ProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        if ("detalle".equals(accion)) {
            mostrarDetalle(request, response);
            return;
        }

        if ("nuevo".equals(accion)) {
            if (!autenticado(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            mostrarFormularioNuevo(request, response);
            return;
        }

        if ("editar".equals(accion)) {
            if (!autenticado(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            mostrarFormularioEditar(request, response);
            return;
        }

        listar(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession sesion = request.getSession(false);
        if (!autenticado(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                               "Debes iniciar sesión.");
            return;
        }
        String token = (String) sesion.getAttribute("csrfToken");
        if (token == null || !token.equals(request.getParameter("csrfToken"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                               "Formulario no autorizado.");
            return;
        }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrar(request, response);
            return;
        }

        if ("actualizar".equals(accion)) {
            actualizar(request, response);
            return;
        }

        if ("eliminar".equals(accion)) {
            eliminar(request, response);
            return;
        }

        response.sendError(
            HttpServletResponse.SC_BAD_REQUEST,
            "Acción no válida."
        );
    }

    private boolean autenticado(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);
        return sesion != null && sesion.getAttribute("usuario") != null;
    }

    private void mostrarDetalle(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = obtenerId(request);
        if (id == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                               "Identificador inválido.");
            return;
        }
        try {
            Producto producto = productoDAO.buscarPorId(id);
            if (producto == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                   "Producto no encontrado.");
                return;
            }
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("/WEB-INF/vistas/detalle.jsp")
                   .forward(request, response);
        } catch (SQLException e) {
            log("Error cargando detalle", e);
            mostrarError(request, response,
                         "No se pudo consultar este producto.");
        }
    }

    private void listar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Producto> productos = productoDAO.listar();
            request.setAttribute("productos", productos);

            request.getRequestDispatcher(
                "/WEB-INF/vistas/listar.jsp"
            ).forward(request, response);

        } catch (SQLException e) {
            log("Error consultando productos", e);
            mostrarError(
                request,
                response,
                "No se pudo cargar el listado de productos."
            );
        }
    }

    private void mostrarFormularioNuevo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("modo", "crear");

        request.getRequestDispatcher(
            "/WEB-INF/vistas/formulario.jsp"
        ).forward(request, response);
    }

    private void mostrarFormularioEditar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Integer id = obtenerId(request);

        if (id == null) {
            redirigir(response, request, "error");
            return;
        }

        try {
            Producto producto = productoDAO.buscarPorId(id);

            if (producto == null) {
                redirigir(response, request, "noexiste");
                return;
            }

            request.setAttribute("modo", "editar");
            request.setAttribute("producto", producto);

            request.getRequestDispatcher(
                "/WEB-INF/vistas/formulario.jsp"
            ).forward(request, response);

        } catch (SQLException e) {
            log("Error buscando producto para editar", e);
            mostrarError(
                request,
                response,
                "No se pudo cargar el producto solicitado."
            );
        }
    }

    private void registrar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Producto producto = validarProducto(request);

            if (productoDAO.insertar(producto)) {
                redirigir(response, request, "creado");
            } else {
                mostrarError(
                    request,
                    response,
                    "No se pudo registrar el producto."
                );
            }

        } catch (IllegalArgumentException e) {
            reenviarFormulario(
                request,
                response,
                "crear",
                null,
                e.getMessage()
            );

        } catch (SQLException e) {
            log("Error registrando producto", e);
            mostrarError(
                request,
                response,
                "Ocurrió un error al guardar el producto."
            );
        }
    }

    private void actualizar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Integer id = obtenerId(request);

        if (id == null) {
            redirigir(response, request, "error");
            return;
        }

        try {
            Producto producto = validarProducto(request);

            if (productoDAO.actualizar(id, producto)) {
                redirigir(response, request, "actualizado");
            } else {
                redirigir(response, request, "noexiste");
            }

        } catch (IllegalArgumentException e) {
            reenviarFormulario(
                request,
                response,
                "editar",
                id,
                e.getMessage()
            );

        } catch (SQLException e) {
            log("Error actualizando producto", e);
            mostrarError(
                request,
                response,
                "Ocurrió un error al actualizar el producto."
            );
        }
    }

    private void eliminar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Integer id = obtenerId(request);

        if (id == null) {
            redirigir(response, request, "error");
            return;
        }

        try {
            boolean eliminado = productoDAO.eliminar(id);

            redirigir(
                response,
                request,
                eliminado ? "eliminado" : "noexiste"
            );

        } catch (SQLException e) {
            log("Error eliminando producto", e);
            redirigir(response, request, "error");
        }
    }

    private Producto validarProducto(HttpServletRequest request) {

        return ProductoValidator.validar(
            request.getParameter("nombre"),
            request.getParameter("descripcion"),
            request.getParameter("precio"),
            request.getParameter("stock"),
            request.getParameter("imagenUrl")
        );
    }

    private Integer obtenerId(HttpServletRequest request) {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            return id > 0 ? id : null;

        } catch (Exception e) {
            return null;
        }
    }

    private void reenviarFormulario(
            HttpServletRequest request,
            HttpServletResponse response,
            String modo,
            Integer id,
            String error)
            throws ServletException, IOException {

        request.setAttribute("modo", modo);
        request.setAttribute("error", error);

        if (id != null) {
            request.setAttribute("idFormulario", id);
        }

        request.setAttribute(
            "nombreFormulario",
            valor(request.getParameter("nombre"))
        );
        request.setAttribute(
            "descripcionFormulario",
            valor(request.getParameter("descripcion"))
        );
        request.setAttribute(
            "precioFormulario",
            valor(request.getParameter("precio"))
        );
        request.setAttribute(
            "stockFormulario",
            valor(request.getParameter("stock"))
        );
        request.setAttribute(
            "imagenFormulario",
            valor(request.getParameter("imagenUrl"))
        );

        request.getRequestDispatcher(
            "/WEB-INF/vistas/formulario.jsp"
        ).forward(request, response);
    }

    private String valor(String valor) {
        return valor == null ? "" : valor;
    }

    private void redirigir(
            HttpServletResponse response,
            HttpServletRequest request,
            String mensaje)
            throws IOException {

        response.sendRedirect(
            request.getContextPath()
            + "/productos?mensaje="
            + mensaje
        );
    }

    private void mostrarError(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje)
            throws ServletException, IOException {

        request.setAttribute("mensaje", mensaje);
        response.setStatus(
            HttpServletResponse.SC_INTERNAL_SERVER_ERROR
        );

        request.getRequestDispatcher(
            "/WEB-INF/vistas/error.jsp"
        ).forward(request, response);
    }
}
