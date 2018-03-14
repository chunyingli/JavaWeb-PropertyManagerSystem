package com.lingjie.servlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lingjie.info.verificationCode;
@WebServlet(urlPatterns = "/servlet/getVerificationImg")
public class getVerificationImg extends HttpServlet{
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	// 设置响应的类型格式为图片格式
        response.setContentType("image/jpeg");
        //禁止图像缓存。
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        verificationCode vCode = new verificationCode(100,30,5,10);
        HttpSession session=request.getSession();
        String codeName=request.getParameter("role");
        if(codeName==null)codeName="verificationCode";
        session.setAttribute(codeName, vCode.getCode());
        vCode.write(response.getOutputStream());
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO Auto-generated method stub
        this.doGet(req, resp);
    }
}
