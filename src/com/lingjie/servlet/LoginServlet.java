package com.lingjie.servlet;
import java.io.IOException;
import java.security.GeneralSecurityException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSONObject;
import com.lingjie.dao.LoginDao;
import com.lingjie.dao.UserDao;
import com.lingjie.info.Department;
import com.lingjie.info.MD5;
import com.lingjie.info.Return_Helper;
import com.lingjie.info.User;

@WebServlet(urlPatterns = "/servlet/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public LoginServlet() {
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String Name = "";
		String Pwd = "";
		Return_Helper return_help = new Return_Helper();
		try {
			
			Name = request.getParameter("UserName");
			Pwd = request.getParameter("UserPwd");
		}catch(Exception e) {
			
//			e.printStackTrace();
			if(Name.equals("")||Pwd.equals("")) {
				return_help = new Return_Helper(false,"用户名或密码不能为空",1);
				JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
		    	
			}
		}
		//判断验证码
		HttpSession session =request.getSession();
		String verificationCode = (String)session.getAttribute("verificationCode");//得到验证码的session
		session.removeAttribute("verificationCode");//清除验证码的session
		String inputverificationCode=request.getParameter("VerificationCode");//获取request的验证码输入值
		if(verificationCode==null||!verificationCode.equals(inputverificationCode.toLowerCase()))//验证码不一样，返回
		{
//			System.out.println(verificationCode+inputverificationCode);
			return_help = new Return_Helper(false,"验证码不正确",2);
			JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
		if(Name == null||Pwd == null||Name.equals("")||Pwd.equals("")) {
			return_help = new Return_Helper(false,"用户名或密码不能为空",1);
			JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else{
			//填写完成验证开始
			
			MD5 md5 = new MD5();
			String UserPwd = "";
			try {
				UserPwd = md5.MD5(Pwd);
			} catch (GeneralSecurityException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			User user = new User();
			user.userName = Name;
			user.userPwd = UserPwd;
			boolean Flag = LoginDao.userLogin(user);
			Department department = new Department();
			
			if(Flag) {
				UserDao.findUserInfo(user, department);
				request.getSession().setAttribute("userName", user.userName);
				request.getSession().setAttribute("userId", user.userId);
//				System.out.println( request.getSession().getAttribute("userName"));
				request.getSession().setAttribute("companyName", department.companyName);
				request.getSession().setAttribute("companyType", department.companyType);
				
				request.getSession().setAttribute("companyNo", department.companyNo);
//				System.out.println( request.getSession().getAttribute("companyNo"));
				
				//验证成功操作
				return_help = new Return_Helper(true,"登录成功",0);
				JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}else{
				//验证失败
				return_help = new Return_Helper(false,"用户名或密码错误",2);
				JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
		
		}
	}
	
	
	
}