package com.lingjie.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONObject;
import com.lingjie.dao.ProjectDao;
import com.lingjie.info.Project;
import com.lingjie.info.Return_Helper;

@WebServlet(urlPatterns = "/servlet/UpdateProjectServlet")
public class UpdateProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateProjectServlet() {
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
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		String project_name = "";
		String project_place = "";
		Date starttime;
		Date endtime;
		float budgetmoney;
		String acceptno = "";
		String remark = "";
		
		Return_Helper returnhelper;
		JSONObject json;
		
		try {
			project_name = request.getParameter("Name");
			project_place = request.getParameter("Place");
			starttime = format.parse(request.getParameter("StartTime"));
			endtime = format.parse(request.getParameter("EndTime"));
			budgetmoney = Float.parseFloat(request.getParameter("BudgetMoney"));
			acceptno = request.getParameter("AcceptCompanyNo");
			remark = request.getParameter("Remark");
			
			if(project_name.equals("") || project_place.equals("") || starttime == null || endtime == null 
					 || budgetmoney == 0 || acceptno.equals("") || remark.equals("")) {
				returnhelper = new Return_Helper(false,"请输入所有的项目信息",-1);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
				}
			
			Project project = new Project();
			
			project.name = project_name;
			project.place = project_place;
			project.startTime = starttime;
			project.endTime = endtime;
			project.budgetMoney = budgetmoney;
			project.acceptCompanyNo = acceptno;
			project.remark = remark;
			project.projectNo=ProjectNo;
			boolean flag = ProjectDao.updateProject(project);
			
			if(flag) {
					returnhelper = new Return_Helper(true,"修改成功",1);
				}else {
					returnhelper = new Return_Helper(false,"修改失败",-1);
					json = (JSONObject) JSONObject.toJSON(returnhelper);
			}
			
			json = (JSONObject) JSONObject.toJSON(returnhelper);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
			
			}catch(Exception e) {
				returnhelper = new Return_Helper(false,"请输入所有的项目信息",-1);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
	}

}
