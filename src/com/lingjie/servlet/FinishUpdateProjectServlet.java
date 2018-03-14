package com.lingjie.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lingjie.dao.ProjectDao;
import com.lingjie.info.Project;
import com.lingjie.info.Return_Helper;

@WebServlet(urlPatterns = "/servlet/FinishUpdateProjectServlet")
public class FinishUpdateProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FinishUpdateProjectServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String ProjectNo=request.getParameter("ProjectNo");
		JSON json;
		Return_Helper returnhelper = new Return_Helper();
		boolean flag = ProjectDao.updateFinishProject(ProjectNo);
		
		if(flag) {
			returnhelper = new Return_Helper(true,"修改成功",1);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			returnhelper = new Return_Helper(true,"该项目修该失败",-2);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
	}

}
