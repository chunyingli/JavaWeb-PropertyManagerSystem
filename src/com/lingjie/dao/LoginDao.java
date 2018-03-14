package com.lingjie.dao;

import com.lingjie.info.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/***
 * 登陆成功返回true,否则false
 * @author HanZhen
 *
 */
public class LoginDao {
	public static boolean userLogin(User user)   //用户登陆查询
	{
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from UserLogin where UserName = ? and UserPwd = ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, user.userName);
			psta.setString(2, user.userPwd);
			rs = psta.executeQuery();
			while(rs.next())
			{
				user.userId = rs.getInt(1);
				user.userName= rs.getString(2);
				user.userPwd = rs.getString(3);
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
}
