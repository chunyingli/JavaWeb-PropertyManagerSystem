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

@WebServlet(urlPatterns = "/servlet/AddProjectServlet")
public class AddProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AddProjectServlet() {
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
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		String project_name = "";
		String project_place = "";
		Date starttime;
		Date endtime;
		Date finishtime;
		float budgetmoney;
		float nowmoney;
		int state;
		String relesaseno = "";
		String acceptno = "";
		String remark = "";
		String projectno =""; 
		
		Return_Helper returnhelper;
		JSONObject json;
		
		try {
			project_name = request.getParameter("Name");
			project_place = request.getParameter("Place");
			starttime = format.parse(request.getParameter("StartTime"));
			endtime = format.parse(request.getParameter("EndTime"));
			finishtime =null;
			budgetmoney = Float.parseFloat(request.getParameter("BudgetMoney"));
			nowmoney =0;
			state = 2;
			relesaseno = (String) request.getSession().getAttribute("companyNo");
			acceptno = request.getParameter("AcceptCompanyNo");
			remark = request.getParameter("Remark");
			if(request.getParameter("ProjectNo")==null)
			{
				projectno=relesaseno;
				int num=ProjectDao.findProjectNo(relesaseno)+1;
				projectno=projectno+"."+num;
			}
			else{
				
				projectno=request.getParameter("ProjectNo");
				int num=ProjectDao.findThrNo(projectno)+1;
				projectno=projectno+"."+num;
			}
			if(project_name.equals("") || project_place.equals("") || budgetmoney == 0  || relesaseno == null || acceptno.equals("") ||  projectno.equals("")) {
				returnhelper = new Return_Helper(false,"请输入所有的项目信息",-1);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
				}
			
			Project project = new Project();
			
			project.name = project_name;
			project.place = project_place;
			project.startTime = starttime;
			project.endTime =  endtime;
			project.finishTime = finishtime;
			project.budgetMoney = budgetmoney;
			project.nowMoney = nowmoney;
			project.state = state;
			project.releaseCompanyNo = relesaseno;
			project.acceptCompanyNo = acceptno;
			project.remark = remark;
			project.projectNo = projectno;
			
			boolean flag = ProjectDao.insertProject(project);
			
			if(flag) {
					returnhelper = new Return_Helper(true,"添加成功",1);
				}else {
					returnhelper = new Return_Helper(false,"添加失败",-2);
					json = (JSONObject) JSONObject.toJSON(returnhelper);
			}
			
			json = (JSONObject) JSONObject.toJSON(returnhelper);
	    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
			
			}catch(Exception e) {
				returnhelper = new Return_Helper(false,"输入数据不合法",-3);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
	}
}
