package com.lingjie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.lingjie.info.Department;
import com.lingjie.info.User;
/**
 * 
 * @author HanZhen
 *
 */
public class DepartmentDao {
	public static int pageSize = 10;  //每页显示的行数
	/**
	 * 生成部门编号
	 * @param companyNo
	 * @return
	 */
	public static int findCompanyNo(String companyNo){
		int num = -1;
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select count(*) from DepartmentInfo "
				+ "where CompanyNo like ? and CompanyNo Not Like ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, companyNo+".%");
			psta.setString(2, companyNo+".%.%");
			rs = psta.executeQuery();
			while(rs.next())
			{
				num = rs.getInt(1);
			}
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			JdbcUtil.release(rs,psta, conn);
		}
		return num;
	}
	/**
	 * 查询部门id
	 * @param user
	 * @return
	 */
	public static boolean findUserId(User user){
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from UserLogin where UserName = ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, user.userName);
			rs = psta.executeQuery();
			while(rs.next())
			{
				user.userId = rs.getInt(1);
			}
			return true;
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			JdbcUtil.release(rs,psta, conn);
		}
		return false;
	}
	/**
	 * 
	 * @param companyNo
	 * @param pageNum
	 * @param departmentList
	 * @return
	 */
	public static boolean findSecDe(String companyNo, int pageNum,ArrayList<Department> departmentList)   
	{
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from DepartmentInfo where CompanyNo like ? and CompanyNo Not Like ?";
		if(pageNum!=-1)
		{
			selectSql+= " order by UserId desc offset ? rows fetch next ? rows only";
		}
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, companyNo+".%");
			psta.setString(2, companyNo+".%.%");
			if(pageNum!=-1)
			{
				psta.setInt(3, pageSize*(pageNum-1));
				psta.setInt(4, pageSize);
			}
			rs = psta.executeQuery();
			while(rs.next())
			{
				Department department = new Department();
				department.userId=rs.getInt(1);
				department.companyName = rs.getString(2);
				department.companyPlace = rs.getString(3);
				department.companyBrith = rs.getDate(4);
				department.companyType = rs.getInt(5);
				department.companyRemark = rs.getString(6);
				department.companyNo= rs.getString(7);
				departmentList.add(department);
			}
			return true;	
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			JdbcUtil.release(rs,psta, conn);
		}
		return false;
	}
	/**
	 * 增加部门信息
	 * @param department
	 * @return
	 */
	public static boolean insertDepartment(Department department) { 
		Connection conn = null;
		PreparedStatement psta = null;
		try {
			java.sql.Date companyBrith = new java.sql.Date(department.companyBrith.getTime());
			conn = JdbcUtil.getConnection();
			String insertSql = "insert into DepartmentInfo " + "values(?,?,?,?,?,?,?)";
			psta = conn.prepareStatement(insertSql);
			psta.setInt(1, department.userId);
			psta.setString(2, department.companyName);
			psta.setString(3, department.companyPlace);
			psta.setDate(4, companyBrith);
			psta.setInt(5, department.companyType);
			psta.setString(6, department.companyRemark);
			psta.setString(7, department.companyNo);
			psta.addBatch();
			psta.executeBatch();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.release(psta, conn);
		}
		return false;
	}

}
