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

@WebServlet(urlPatterns = "/servlet/UpdateRealMoneyServlet")
public class UpdateRealMoneyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateRealMoneyServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		float nowMoney = Float.valueOf(request.getParameter("NowMoney"));
		int state = 3;
		String projectNo1 = request.getParameter("ProjectNo");
		String projectNo2="";
		int sum = 0;
		JSON json;
		Return_Helper returnhelper = new Return_Helper();
		for(int i = 0;i<projectNo1.length();i++) {
			if(projectNo1.charAt(i) == '.') {
				sum++;
			}
			if(sum == 2) {
				projectNo2 = projectNo1.substring(0, i);
				break;
			}
		}
		if(sum != 2) {
			returnhelper = new Return_Helper(false,"项目编号出错",-1);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
		boolean flag = ProjectDao.updateRealMoney(nowMoney,state,projectNo1);
		
		if(flag) {
			ProjectDao.updateRealMoney(nowMoney,projectNo2);
			returnhelper = new Return_Helper(true,"该项目经费修改成功",1);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			returnhelper = new Return_Helper(false,"该项目修该失败",-2);
			json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
	}

}
