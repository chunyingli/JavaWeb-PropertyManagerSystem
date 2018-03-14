package com.lingjie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.lingjie.info.*;
/**
 * 用户信息操作类
 * @author HanZhen
 *
 */
public class UserDao {
	/**
	 * 
	 * @param user
	 * @return true or false
	 */
	public static boolean insertUser(User user) { 
		Connection conn = null;
		PreparedStatement psta = null;
		// ResultSet rs = null;
		try {
			conn = JdbcUtil.getConnection();
			String insertSql = "insert into UserLogin(UserName,UserPwd) values(?,?)";
			psta = conn.prepareStatement(insertSql);
			psta.setString(1, user.userName);
			psta.setString(2, user.userPwd);
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
	/**
	 * 
	 * @param user
	 * @return
	 */
	public static boolean updateUser(User user) // 更改用户密码
	{
		Connection conn = null;
		PreparedStatement psta = null;
		String updateSql = "update UserLogin set UserPwd = ? where UserName = ?";
		try {
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(updateSql);
			psta.setString(1, user.userPwd);
			psta.setString(2, user.userName);
			psta.addBatch();
			// psta.executeBatch();
			int i = psta.executeUpdate();
			if (i != 0)
				return true;
			else
				return false;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.release(psta, conn);
		}
		return false;
	}
	/**
	 * 
	 * @param user
	 * @return
	 */
	public static boolean findUserInfo(User user,Department department)   //用户详细信息查询
	{
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from DepartmentInfo where UserId = ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setInt(1, user.userId);
			rs = psta.executeQuery();
			while(rs.next())
			{
				department.userId = rs.getInt(1);
				department.companyName= rs.getString(2);
				department.companyPlace = rs.getString(3);
				department.companyBrith = rs.getDate(4);
				department.companyType = rs.getInt(5);
				department.companyRemark = rs.getString(6);
				department.companyNo = rs.getString(7);
				return true;
			}
			
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
	 * @param department
	 * @return
	 */
	public static boolean insertUserInfo(Department department) { 
		Connection conn = null;
		PreparedStatement psta = null;
		java.sql.Date companyBrith = new java.sql.Date(department.companyBrith.getTime());
		// ResultSet rs = null;
		try {
			conn = JdbcUtil.getConnection();
			String insertSql = "insert into DepartmentInfo values(?,?,?,?,?,?,?)";
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
