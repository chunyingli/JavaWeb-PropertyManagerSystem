package com.lingjie.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JdbcUtil {

	public Connection conn = null; // 数据库连接对象
	public Statement stmt = null; // Statement对象，用于执行SQL语句
	public ResultSet rs = null; // 结果集对象
	private static String dbClassName = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; // 驱动类的类名
	private static String dbUrl = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=JavaWeb";
	private static String dbUser = "test"; // 登录SQL Server的用户名
	private static String dbPwd = "testadmin"; // 登录SQL Server的密码
//	private static String dbUrl = "jdbc:sqlserver://39.106.207.29:1433;DatabaseName=Software_Constr";
//	private static String dbUser = "sa"; // 登录SQL Server的用户名
//	private static String dbPwd = "123456"; // 登录SQL Server的密码

	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName(dbClassName).newInstance();
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (conn == null) {
			System.err.println("DbConnectionManager.getConnection():" + dbClassName + "\r\n :" + dbUrl + "\r\n "
					+ dbUser + "/" + dbPwd);// 输出连接信息，方便调试
		}
		return conn;
	}

	// 关闭连接释放资源
	public static void release(Statement stmt, Connection conn) {
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			stmt = null;
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			conn = null;
		}
	}

	public static void release(ResultSet rs, Statement stmt, Connection conn) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			rs = null;
		}
		release(stmt, conn);
	}

}