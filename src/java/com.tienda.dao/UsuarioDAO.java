package com.tienda.dao;
import com.tienda.util.PasswordUtil;
import java.sql.*;
public class UsuarioDAO {
 public boolean validar(String usuario,String clave) throws SQLException {
  if(usuario==null||clave==null||usuario.trim().isEmpty())return false;
  try(Connection c=Conexion.obtenerConexion();
      PreparedStatement p=c.prepareStatement("SELECT contrasena_hash FROM usuarios WHERE nombre_usuario=? AND activo=1")){
   p.setString(1,usuario.trim());
   try(ResultSet r=p.executeQuery()){
    return r.next() && PasswordUtil.verificar(clave,r.getString(1));
   }
  }
 }
}
