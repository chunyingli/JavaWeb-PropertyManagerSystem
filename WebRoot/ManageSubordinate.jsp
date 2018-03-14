<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="管理下属单位";
	String zongbunav="active";
	String fenbunav="";
	String zidanwei="active";
	String personal="";
	String subunitsproject="";
 %>
<%@ include  file="../header.jsp"%>

                        管理下属单位页面
<%@ include  file="../footer.jsp"%>