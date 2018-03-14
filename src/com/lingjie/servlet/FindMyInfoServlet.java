package com.lingjie.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.lingjie.dao.UserDao;
import com.lingjie.info.Department;
import com.lingjie.info.Return_Helper;
import com.lingjie.info.User;

@WebServlet(urlPatterns = "/servlet/FindMyInfoServlet")
public class FindMyInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FindMyInfoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		int userid;
		userid = (int) request.getSession().getAttribute("userId");
		User user = new User();
		user.userId = userid;
		
		Department department = new Department();
		boolean flag = UserDao.findUserInfo(user, department);
		
		if(flag) {
			String jsonstr = JSONObject.toJSONString(department,SerializerFeature.WriteNullStringAsEmpty); 
	    	response.getOutputStream().write(jsonstr.getBytes("utf-8"));
	    	return;
		}else {
			Return_Helper return_help = new Return_Helper(false,"查看信息失败",2);
			JSONObject json = (JSONObject) JSONObject.toJSON(return_help);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
		
		
	}

}
