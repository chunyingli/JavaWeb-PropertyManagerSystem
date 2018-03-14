package com.lingjie.info;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;


public class MD5 {
	public String MD5(String str) throws GeneralSecurityException{   
		String result = "";
		MessageDigest md5 = null;
		try {
			 md5= MessageDigest.getInstance("MD5");
			 md5.update((str).getBytes("UTF-8"));
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
		byte b[] = md5.digest();  
		  
		int i;  
		StringBuffer buf = new StringBuffer("");  
		  
		for(int offset=0; offset<b.length; offset++){  
		    i = b[offset];  
		    if(i<0){  
		        i+=256;  
		    }  
		    if(i<16){  
		        buf.append("0");  
		    }  
		    buf.append(Integer.toHexString(i));  
		}  
		result = buf.toString();  
		return result.toUpperCase();
	}

	public static void main(String[] str) {
		MD5 md5=new MD5();
		try {
			System.out.println(md5.MD5("456"));
		} catch (GeneralSecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
