
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
import com.lingjie.dao.DepartmentDao;
import com.lingjie.info.Department;
import com.lingjie.info.Return_Helper;

/**
 * Servlet implementation class FindMyEmployeeServlet
 */
@WebServlet(urlPatterns = "/servlet/FindMyEmployeeServlet")
public class FindMyEmployeeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FindMyEmployeeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setHeader("Content-type","text/html;charset=UTF-8"); //指定消息头以UTF-8码表读数据 
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String companyNo = (String) request.getSession().getAttribute("companyNo");
		int pagenum = Integer.parseInt(request.getParameter("Page"));
		ArrayList<Department> departmentlist = new ArrayList<Department>();
		boolean flag = DepartmentDao.findSecDe(companyNo, pagenum, departmentlist);
		
		if(flag && departmentlist.size()>0) {
			JSONArray jsonarray=JSONArray.parseArray(JSON.toJSONString(departmentlist,SerializerFeature.WriteNullStringAsEmpty));
	    	response.getOutputStream().write((jsonarray.toJSONString()).getBytes("utf-8"));
	    	return;
		}else {
			Return_Helper returnhelper = new Return_Helper(false,"没有项目信息",-1);
			JSON json = (JSONObject) JSONObject.toJSON(returnhelper);
			response.getOutputStream().write((json.toJSONString()).getBytes("utf-8"));
	    	return;
		}
		
	}

}
