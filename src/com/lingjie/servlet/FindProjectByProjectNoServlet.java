package com.lingjie.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.lingjie.dao.ProjectDao;
import com.lingjie.info.Project;
import com.lingjie.info.Return_Helper;

@WebServlet(urlPatterns = "/servlet/FindProjectByProjectNoServlet")
public class FindProjectByProjectNoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FindProjectByProjectNoServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String ProjectNo = request.getParameter("ProjectNo");
//		int taskid = 1;
		Project project = new Project();
		JSON json;
		Return_Helper returnhelper = new Return_Helper();
		
		project = ProjectDao.findProject(ProjectNo);
		if(project.taskId == 0) {
			returnhelper = new Return_Helper(false,"查询结果为空",-1);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			//json = (JSONObject) JSONObject.toJSON(project);
			String jsonstr = JSONObject.toJSONString(project,SerializerFeature.WriteNullStringAsEmpty); 
	    	response.getOutputStream().write(jsonstr.getBytes("utf-8"));
	    	return;
		}
	}

}
