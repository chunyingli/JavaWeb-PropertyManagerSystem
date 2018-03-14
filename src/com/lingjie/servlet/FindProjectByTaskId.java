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
import com.lingjie.info.Project;
import com.lingjie.info.Return_Helper;

@WebServlet(urlPatterns = "/servlet/FindProjectByTaskId")
public class FindProjectByTaskId extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FindProjectByTaskId() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		int taskid = Integer.valueOf(request.getParameter("TaskId"));
		Project project = new Project();
		JSON json;
		Return_Helper returnhelper = new Return_Helper();
		
		project = ProjectDao.findProject(taskid);
		if(project.taskId == 0) {
			returnhelper = new Return_Helper(false,"查询结果为空",-1);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			json = (JSONObject) JSONObject.toJSON(project);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
	}

}
