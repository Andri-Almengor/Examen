package com.tienda.util;
import java.security.MessageDigest;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
public final class PasswordUtil {
 private PasswordUtil() {}
 public static boolean verificar(String clave,String valor){
  if(clave==null||valor==null)return false;
  PBEKeySpec spec=null;
  try {
   String[] p=valor.split("\\$",-1);
   if(p.length!=4||!"pbkdf2_sha256".equals(p[0]))return false;
   int n=Integer.parseInt(p[1]); if(n<100000||n>1000000)return false;
   byte[] salt=Base64.getDecoder().decode(p[2]);
   byte[] esperado=Base64.getDecoder().decode(p[3]);
   if(salt.length<16||esperado.length!=32)return false;
   spec=new PBEKeySpec(clave.toCharArray(),salt,n,256);
   byte[] real=SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
   return MessageDigest.isEqual(esperado,real);
  }catch(Exception e){return false;}
  finally{if(spec!=null)spec.clearPassword();}
 }
}
