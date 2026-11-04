package com.tienda.servlet;
import java.io.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
 @Override protected void doGet(HttpServletRequest req,HttpServletResponse res)throws IOException{
  res.sendRedirect(req.getContextPath()+"/productos");
 }
 @Override protected void doPost(HttpServletRequest req,HttpServletResponse res)throws IOException{
  HttpSession s=req.getSession(false);
  if(s==null||s.getAttribute("usuario")==null){res.sendRedirect(req.getContextPath()+"/productos");return;}
  String esperado=(String)s.getAttribute("csrfToken");
  if(esperado==null||!esperado.equals(req.getParameter("csrfToken"))){
   res.sendError(403,"Formulario inválido");return;
  }
  s.invalidate();
  res.sendRedirect(req.getContextPath()+"/productos?mensaje=salida");
 }
}
