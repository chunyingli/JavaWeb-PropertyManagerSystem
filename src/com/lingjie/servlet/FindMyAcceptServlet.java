package com.lingjie.servlet;

import java.io.IOException;
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
import com.lingjie.dao.ProjectDao;
import com.lingjie.info.Department;
import com.lingjie.info.Project;
import com.lingjie.info.Return_Helper;

@WebServlet(urlPatterns = "/servlet/FindMyAcceptServlet")
public class FindMyAcceptServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	 public FindMyAcceptServlet() {
	        super();
	    }

		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			doPost(request, response);
		}

		protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
			response.setCharacterEncoding("UTF-8");
			request.setCharacterEncoding("UTF-8");
			
			String companyno = (String) request.getSession().getAttribute("companyNo");
			String choosevalue = request.getParameter("chooseValue");//1全部2未完成3已完成
			String PageStr=request.getParameter("page");
			int Page=1;
			if(PageStr==null)Page=Integer.parseInt(PageStr);
//			String companyno = "123";
//			String choosevalue = "1";//1全部2未完成3已完成
			
			
			Department department = new Department();
			department.companyNo = companyno;
			ArrayList<Project> projectlist = new ArrayList<Project>();
			boolean flag;
			
			if(choosevalue.equals("2")) {//查找自己接收未完成的项目
				flag = ProjectDao.findAcceptProject(Page,department,projectlist,2);
			}else if(choosevalue.equals("3")){//查找自己接收已完成的项目
				flag = ProjectDao.findAcceptProject(Page,department,projectlist,3);
			}else {
				//查找自己接收所有项目
				flag = ProjectDao.findAcceptProject(Page,department,projectlist,1);
			}
			
			JSONArray jsonarray;
			JSON json;
			
			if(flag) {
				jsonarray=JSONArray.parseArray(JSON.toJSONString(projectlist,SerializerFeature.WriteNullStringAsEmpty));
		    	response.getOutputStream().write((jsonarray.toJSONString()).getBytes("utf-8"));
		    	return;
			}else {
				Return_Helper returnhelper = new Return_Helper(false,"没有项目信息",-1);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
				response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
			
		}

	}
