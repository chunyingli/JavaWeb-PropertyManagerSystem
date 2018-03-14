package com.lingjie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import com.lingjie.info.Department;
import com.lingjie.info.Project;
/**
 * 
 * @author HanZhen
 *
 */
public class ProjectDao {
	public static int pageSize = 10;  //每页显示的行数
	/**
	 * 生成项目编号
	 * @return
	 */
	public static int findProjectNo(String releaseCompanyNo){
		int num = -1;
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select count(*) from ProjectInfo where ReleaseCompanyNo = ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1,releaseCompanyNo );
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
	 * 
	 * @param companyNo
	 * @param mark
	 * @param projectState
	 * @return
	 */
	
	public static int findProjectNo(String companyNo,String mark,int projectState){
		String selectSql = null;
		if(mark.equals("Release")) {
			if(projectState == 1) {
				selectSql = "select count(*) from ProjectInfo where ReleaseCompanyNo = ?";
			}else if(projectState == 2) {
				selectSql = "select count(*) from ProjectInfo where ReleaseCompanyNo = ? and State = 2";
			}else {
				selectSql = "select count(*) from ProjectInfo where ReleaseCompanyNo = ? and State = 3";
			}
		}else{
			if(projectState == 1) {
				selectSql = "select count(*) from ProjectInfo where AcceptCompanyNo = ?";
			}else if(projectState == 2) {
				selectSql = "select count(*) from ProjectInfo where AcceptCompanyNo = ? and State = 2";
			}else {
				selectSql = "select count(*) from ProjectInfo where AcceptCompanyNo = ? and State = 3";
			}
		}
		
		int num = -1;
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1,companyNo);
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
	 * 添加项目信息
	 * @param project
	 * @return
	 */
	public static boolean insertProject(Project project) { 
		Connection conn = null;
		PreparedStatement psta = null;
		// ResultSet rs = null;
		java.sql.Date startTime=null ;
		java.sql.Date endTime =null;
		java.sql.Date finishTime=null;
		try{
			startTime = new java.sql.Date(project.startTime.getTime());
			endTime = new java.sql.Date(project.endTime.getTime());
			finishTime = new java.sql.Date(project.finishTime.getTime());
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		try {
			conn = JdbcUtil.getConnection();
			String insertSql = "insert into ProjectInfo "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?)";
			psta = conn.prepareStatement(insertSql);
			psta.setString(1, project.name);
			psta.setString(2, project.place);
			psta.setDate(3, startTime);
			psta.setDate(4, endTime);
			psta.setDate(5, finishTime);
			psta.setFloat(6, project.budgetMoney);
			psta.setFloat(7, project.nowMoney);
			psta.setInt(8, project.state);
			psta.setString(9, project.releaseCompanyNo);
			psta.setString(10, project.acceptCompanyNo);
			psta.setString(11, project.remark);
			psta.setString(12, project.projectNo);
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
 * 查询已发布得项目
 * @param department
 * @param projectList
 * @return
 */
	public static boolean findReleaseProject(int pageNum, Department department, ArrayList<Project> projectList,int projectState)   //项目详细信息查询
	{
		String selectSql="";
		if(projectState==1) {
			selectSql = "select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where "
					+ "ReleaseCompanyNo = ?  and AcceptCompanyNo = CompanyNo";
		}else if(projectState==2){
			selectSql = "select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where "
					+ "ReleaseCompanyNo = ? and State = 2 and AcceptCompanyNo = CompanyNo";
		}else {
			selectSql = "select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where"
					+ " ReleaseCompanyNo = ? and State = 3 and AcceptCompanyNo = CompanyNo";
		}
		if(pageNum!=-1)
		{
			selectSql+= " order by TaskId desc offset ? rows fetch next ? rows only";
		}
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, department.companyNo);
			if(pageNum!=-1)
			{
				psta.setInt(2, pageSize*(pageNum-1));
				psta.setInt(3, pageSize);
			}
			rs = psta.executeQuery();
			while(rs.next())
			{
				Project project = new Project();
				project.taskId =rs.getInt(1);
				project.name = rs.getString(2);
				project.place = rs.getString(3);
				project.startTime = rs.getDate(4);
				project.endTime = rs.getDate(5);
				project.finishTime = rs.getDate(6);
				project.budgetMoney = rs.getFloat(7);
				project.nowMoney = rs.getFloat(8);
				project.state = rs.getInt(9);
				project.releaseCompanyNo = rs.getString(10);
				project.acceptCompanyNo = rs.getString(11);
				project.remark = rs.getString(12);
				project.projectNo = rs.getString(13);
				project.acceptCompanyName = rs.getString(14);
				projectList.add(project);
				
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
	 * 查询接收的项目
	 * @param department
	 * @param projectList
	 * @return
	 */
	public static boolean findAcceptProject(int pageNum, Department department, ArrayList<Project> projectList,int projectState)   //接收项目详细信息查询
	{
		String selectSql="";
		if(projectState==1) {
			selectSql = "select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where "
					+ "AcceptCompanyNo = ?  and ReleaseCompanyNo = CompanyNo";
		}else if(projectState==2){
			selectSql = "select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where "
					+ "AcceptCompanyNo = ? and State = 2 and ReleaseCompanyNo = CompanyNo";
		}else {
			selectSql = "select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where"
					+ " AcceptCompanyNo = ? and State = 3 and ReleaseCompanyNo = CompanyNo";
		}
		if(pageNum!=-1)
		{
			selectSql+= " order by TaskId desc offset ? rows fetch next ? rows only";
		}
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, department.companyNo);
			if(pageNum!=-1)
			{
				psta.setInt(2, pageSize*(pageNum-1));
				psta.setInt(3, pageSize);
			}
			rs = psta.executeQuery();
			while(rs.next())
			{
				Project project = new Project();
				project.taskId =rs.getInt(1);
				project.name = rs.getString(2);
				project.place = rs.getString(3);
				project.startTime = rs.getDate(4);
				project.endTime = rs.getDate(5);
				project.finishTime = rs.getDate(6);
				project.budgetMoney = rs.getFloat(7);
				project.nowMoney = rs.getFloat(8);
				project.state = rs.getInt(9);
				project.releaseCompanyNo = rs.getString(10);
				project.acceptCompanyNo = rs.getString(11);
				project.remark = rs.getString(12);
				project.projectNo = rs.getString(13);
				project.releaseCompanyName = rs.getString(14);
				projectList.add(project);
				
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
	 * 查询全部工程
	 * @param department
	 * @param projectList
	 * @return
	 */
	public static boolean findallProject( ArrayList<Project> projectList)   //全部项目详细信息查询
	{
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from ProjectInfo";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			rs = psta.executeQuery();
			while(rs.next())
			{
				Project project = new Project();
				project.taskId =rs.getInt(1);
				project.name = rs.getString(2);
				project.place = rs.getString(3);
				project.startTime = rs.getDate(4);
				project.endTime = rs.getDate(5);
				project.finishTime = rs.getDate(6);
				project.budgetMoney = rs.getFloat(7);
				project.nowMoney = rs.getFloat(8);
				project.state = rs.getInt(9);
				project.releaseCompanyNo = rs.getString(10);
				project.acceptCompanyNo = rs.getString(11);
				project.remark = rs.getString(12);
				project.projectNo = rs.getString(13);
				projectList.add(project);
				
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
	 * 根据项目tadkId查询项目信息
	 * @param taskId
	 * @return
	 */
	
	public static Project findProject(int taskId) {
		
		Project project = new Project();
		
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from ProjectInfo where TaskId = ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setInt(1,taskId );
			rs = psta.executeQuery();
			
			while(rs.next())
			{
				
				project.taskId =rs.getInt(1);
				project.name = rs.getString(2);
				project.place = rs.getString(3);
				project.startTime = rs.getDate(4);
				project.endTime = rs.getDate(5);
				project.finishTime = rs.getDate(6);
				project.budgetMoney = rs.getFloat(7);
				project.nowMoney = rs.getFloat(8);
				project.state = rs.getInt(9);
				project.releaseCompanyNo = rs.getString(10);
				project.acceptCompanyNo = rs.getString(11);
				project.remark = rs.getString(12);
				project.projectNo = rs.getString(13);
			}
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			JdbcUtil.release(rs,psta, conn);
		}
		return project;
	}
	
	/**
	 * 根据项目projectNo查询项目信息
	 * @param projectNo
	 * @return
	 */
	
	public static Project findProject(String projectNo) {
		
		Project project = new Project();
		
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select * from ProjectInfo where ProjectNo = ?";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1,projectNo );
			rs = psta.executeQuery();
			
			while(rs.next())
			{
				
				project.taskId =rs.getInt(1);
				project.name = rs.getString(2);
				project.place = rs.getString(3);
				project.startTime = rs.getDate(4);
				project.endTime = rs.getDate(5);
				project.finishTime = rs.getDate(6);
				project.budgetMoney = rs.getFloat(7);
				project.nowMoney = rs.getFloat(8);
				project.state = rs.getInt(9);
				project.releaseCompanyNo = rs.getString(10);
				project.acceptCompanyNo = rs.getString(11);
				project.remark = rs.getString(12);
				project.projectNo = rs.getString(13);
			}
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			JdbcUtil.release(rs,psta, conn);
		}
		return project;
	}
	
	/**
	 * 更新项目信息
	 * @param project
	 * @return
	 */
	public static boolean updateProject(Project project)
	{
		Connection conn = null;
		PreparedStatement psta = null;
		String updateSql = "update ProjectInfo set"
				+ " Name =?, Place = ?,StartTime = ?,Endtime = ?,BudgetMoney = ?,AcceptCompanyNo = ?,remark = ? "
				+ "where ProjectNo = ?";
		try {
			java.sql.Date startTime = new java.sql.Date(project.startTime.getTime());
			java.sql.Date endTime = new java.sql.Date(project.endTime.getTime());
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(updateSql);
			psta.setString(1, project.name);
			psta.setString(2, project.place);
			psta.setDate(3, startTime);
			psta.setDate(4, endTime);
			psta.setFloat(5, project.budgetMoney);
			psta.setString(6, project.acceptCompanyNo);
			psta.setString(7, project.remark);
			psta.setString(8, project.projectNo);
			psta.addBatch();
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
	 *根据项目编号查询子集项目信息
	 * 
	 * **/
	public static boolean findBranchProject(String ProjectNo, ArrayList<Project> projectList)   //项目详细信息查询
	{
		String selectSql="select ProjectInfo.*,CompanyName from DepartmentInfo,ProjectInfo where ProjectNo like ? and AcceptCompanyNo = CompanyNo order by TaskId";
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, ProjectNo+".%");
			rs = psta.executeQuery();
			while(rs.next())
			{
				Project project = new Project();
				project.taskId =rs.getInt(1);
				project.name = rs.getString(2);
				project.place = rs.getString(3);
				project.startTime = rs.getDate(4);
				project.endTime = rs.getDate(5);
				project.finishTime = rs.getDate(6);
				project.budgetMoney = rs.getFloat(7);
				project.nowMoney = rs.getFloat(8);
				project.state = rs.getInt(9);
				project.releaseCompanyNo = rs.getString(10);
				project.acceptCompanyNo = rs.getString(11);
				project.remark = rs.getString(12);
				project.projectNo = rs.getString(13);
				project.acceptCompanyName = rs.getString(14);
				projectList.add(project);
				
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
	 * @param projectNo
	 * @return
	 */
	public static int findThrNo(String projectNo){
		int num = -1;
		Connection conn = null;
		PreparedStatement psta = null;
		ResultSet rs = null;
		String selectSql = "select count(*) from ProjectInfo where ProjectNo like ? ";
		try{
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(selectSql);
			psta.setString(1, projectNo+".%");
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
	public static boolean updateRealMoney(float NowMoney,String ProjectNo) {
		Connection conn = null;
		PreparedStatement psta = null;
		String sql="update ProjectInfo set NowMoney = NowMoney + ? where ProjectNo = ?";
		
		try {
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(sql);
			psta.setFloat(1,NowMoney );
			psta.setString(2,ProjectNo );
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
	 * @param NowMoney
	 * @param State
	 * @param ProjectNo
	 * @return
	 */
	public static boolean updateRealMoney(float NowMoney,int State,String ProjectNo1) {
		Connection conn = null;
		PreparedStatement psta = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = sdf.format(new java.util.Date());
		String sql="update ProjectInfo set NowMoney = ? , State = ? , FinishTime= ? where ProjectNo = ?";
		
		try {
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(sql);
			psta.setFloat(1,NowMoney );
			psta.setInt(2, State);
			psta.setString(3,date );
			psta.setString(4,ProjectNo1 );
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
	
	/*
	 * 更新项目完成了
	 * */
	public static boolean updateFinishProject(String ProjectNo) {
		Connection conn = null;
		PreparedStatement psta = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = sdf.format(new java.util.Date());
		String sql="update ProjectInfo set State = 3 , FinishTime= ? where ProjectNo = ?";
		
		try {
			conn = JdbcUtil.getConnection();
			psta = conn.prepareStatement(sql);
			psta.setString(1,date );
			psta.setString(2,ProjectNo);
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
}
