package com.lingjie.servlet;

import java.io.IOException;
import java.security.GeneralSecurityException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONObject;
import com.lingjie.dao.LoginDao;
import com.lingjie.dao.UserDao;
import com.lingjie.info.MD5;
import com.lingjie.info.Return_Helper;
import com.lingjie.info.User;

/**
 * Servlet implementation class updatePwd
 */
@WebServlet(urlPatterns = "/servlet/updatePwd")
public class updatePwdServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public updatePwdServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String userName=(String) request.getSession().getAttribute("userName");
		String userPwd=request.getParameter("UserPwd");
		String userPwdConfim=request.getParameter("UserPwdConfim");
		
		Return_Helper return_help = new Return_Helper();
		
		if(userPwd==null || "".equals(userPwd) || userPwdConfim ==null || "".equals(userPwdConfim)) {
			return_help = new Return_Helper(false,"新密码不能为空",1);
			JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else if(!userPwd.equals(userPwdConfim)){
			return_help = new Return_Helper(false,"密码不一致",2);
			JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			
			MD5 md5 = new MD5();
			String Pwd = "";
			try {
				Pwd = md5.MD5(userPwd);
			} catch (GeneralSecurityException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			User user=new User();
			user.userName = userName;
			user.userPwd = Pwd;
			boolean Flag = UserDao.updateUser(user);
			if(Flag) {
				return_help = new Return_Helper(true,"修改成功",0);
				JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}else {
				return_help = new Return_Helper(false,"修改失败",3);
				JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
		
		}

	}

}
