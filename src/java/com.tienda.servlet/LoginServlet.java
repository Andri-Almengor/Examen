package com.tienda.servlet;
import com.tienda.dao.UsuarioDAO;
import java.io.*;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
 private final UsuarioDAO dao=new UsuarioDAO();
 @Override protected void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException{
  HttpSession s=req.getSession(false);
  if(s!=null&&s.getAttribute("usuario")!=null){res.sendRedirect(req.getContextPath()+"/productos");return;}
  res.setHeader("Cache-Control","no-store");
  req.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(req,res);
 }
 @Override protected void doPost(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException{
  req.setCharacterEncoding("UTF-8");
  String usuario=req.getParameter("usuario"),clave=req.getParameter("contrasena");
  if(usuario==null||usuario.length()>80||clave==null||clave.length()>256){
   res.sendRedirect(req.getContextPath()+"/login?error=1");return;
  }
  try {
   if(!dao.validar(usuario,clave)){res.sendRedirect(req.getContextPath()+"/login?error=1");return;}
   HttpSession vieja=req.getSession(false);if(vieja!=null)vieja.invalidate();
   HttpSession s=req.getSession(true);
   s.setAttribute("usuario",usuario.trim());
   s.setAttribute("csrfToken",UUID.randomUUID().toString());
   s.setMaxInactiveInterval(1800);
   res.sendRedirect(req.getContextPath()+"/productos?mensaje=bienvenido");
  }catch(SQLException e){log("Error al autenticar",e);res.sendRedirect(req.getContextPath()+"/login?error=bd");}
 }
}
