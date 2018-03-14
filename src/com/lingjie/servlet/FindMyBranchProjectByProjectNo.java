package com.lingjie.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.lingjie.dao.DepartmentDao;
import com.lingjie.dao.ProjectDao;
import com.lingjie.info.Department;
import com.lingjie.info.Project;
import com.lingjie.info.Return_Helper;
@WebServlet(urlPatterns = "/servlet/FindMyBranchProjectByProjectNo")
public class FindMyBranchProjectByProjectNo extends HttpServlet {

	/**
		 * Constructor of the object.
		 */
	public FindMyBranchProjectByProjectNo() {
		super();
	}

	/**
		 * Destruction of the servlet. <br>
		 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
		 * The doGet method of the servlet. <br>
		 *
		 * This method is called when a form has its tag value method equals to get.
		 * 
		 * @param request the request send by the client to the server
		 * @param response the response send by the server to the client
		 * @throws ServletException if an error occurred
		 * @throws IOException if an error occurred
		 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
		 * The doPost method of the servlet. <br>
		 *
		 * This method is called when a form has its tag value method equals to post.
		 * 
		 * @param request the request send by the client to the server
		 * @param response the response send by the server to the client
		 * @throws ServletException if an error occurred
		 * @throws IOException if an error occurred
		 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		String ProjectNo = request.getParameter("ProjectNo");
		
		ArrayList<Project> projectlist = new ArrayList<Project>();
		boolean flag = ProjectDao.findBranchProject(ProjectNo, projectlist);
		
		if(flag) {
			JSONArray jsonarray=JSONArray.parseArray(JSON.toJSONString(projectlist,SerializerFeature.WriteNullStringAsEmpty));
	    	response.getOutputStream().write((jsonarray.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			Return_Helper returnhelper = new Return_Helper(false,"没有项目信息",-1);
			JSON json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
	}

	/**
		 * Initialization of the servlet. <br>
		 *
		 * @throws ServletException if an error occurs
		 */
	public void init() throws ServletException {
		// Put your code here
	}

}
