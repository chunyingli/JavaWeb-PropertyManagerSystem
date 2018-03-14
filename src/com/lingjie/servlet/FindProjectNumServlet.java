package com.lingjie.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lingjie.dao.ProjectDao;
import com.lingjie.info.Return_Helper;

@WebServlet(urlPatterns = "/servlet/FindProjectNumServlet")
public class FindProjectNumServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FindProjectNumServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String companyNo = (String) request.getSession().getAttribute("companyNo");
		String mark = request.getParameter("mark");
		int state = Integer.valueOf(request.getParameter("State"));
		int num = ProjectDao.findProjectNo(companyNo, mark, state);
		JSON json;
		Return_Helper returnhelper = new Return_Helper();
		
		if(num == -1) {
			returnhelper = new Return_Helper(false,"没有找到项目信息",-1);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			returnhelper = new Return_Helper(true,"查询成功",num);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
	}

}
