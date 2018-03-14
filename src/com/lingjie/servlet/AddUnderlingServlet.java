package com.lingjie.servlet;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.http.HTTPException;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lingjie.dao.DepartmentDao;
import com.lingjie.dao.UserDao;
import com.lingjie.info.Department;
import com.lingjie.info.MD5;
import com.lingjie.info.Return_Helper;
import com.lingjie.info.User;

@WebServlet(urlPatterns = "/servlet/AddUnderlingServlet")
public class AddUnderlingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AddUnderlingServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
		MD5 md5 = new MD5();
		JSONObject json;
		Return_Helper returnhelper = new Return_Helper();
		
		try {
			String mycompanyNo = (String) request.getSession().getAttribute("companyNo");//获取用户companyNo
			String userName = request.getParameter("UserName");
			String companyName = request.getParameter("CompanyName");
			String companyPlace = request.getParameter("CompanyPlace");
			Date companyBrith = dateformat.parse(request.getParameter("CompanyBrith"));
			int companyType =(Integer)request.getSession().getAttribute("companyType");
			companyType+=1;
			String companyRemark = request.getParameter("CompanyRemark");
			
			if(mycompanyNo.equals("") || userName.equals("") || companyName.equals("") || companyPlace.equals("")) {
				returnhelper = new Return_Helper(false,"请输入必要信息",-1);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
			
			User user = new User();
			user.userName = userName;
			user.userPwd = md5.MD5(request.getParameter("UserPwd"));
			
			boolean flag = UserDao.insertUser(user);
			if(!flag) {
				returnhelper = new Return_Helper(false,"用户添加失败",-2);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
		    	response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
			
			int Num = DepartmentDao.findCompanyNo(mycompanyNo)+1;//获取新建人员的最后一个编号
			String companyNo = mycompanyNo+"."+String.valueOf(Num);//将此编号添加到上级编号之后
			
			Department department = new Department();
			flag = DepartmentDao.findUserId(user);
			department.userId = user.userId;
			department.companyName = companyName;
			department.companyPlace = companyPlace;
			department.companyBrith = companyBrith;
			department.companyType = companyType;
			department.companyRemark = companyRemark;
			department.companyNo = companyNo;
			
			flag = DepartmentDao.insertDepartment(department);
			if(flag) {
				returnhelper = new Return_Helper(true,"添加用户成功",1);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
				response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}else {
				returnhelper = new Return_Helper(false,"添加用户失败",-3);
				json = (JSONObject) JSONObject.toJSON(returnhelper);
				response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
		    	return;
			}
			
		} catch (Exception e) {
			returnhelper = new Return_Helper(false,"输入信息不合法",-4);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
	}

}
