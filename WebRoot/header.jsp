<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	//Object userName=session.getAttribute("userName");
	Object userName = session.getAttribute("userName");  
	if(userName==null)
	{
		response.sendRedirect("login.jsp");
		return;
	}
 %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title><%=PageTitle %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
     <link rel="stylesheet" href="https://ajax.aspnetcdn.com/ajax/bootstrap/3.3.7/css/bootstrap.min.css"/>
     <link rel="stylesheet" href="wwwroot/css/site.min.css" />
     <link rel="stylesheet" href="wwwroot/css/FontAwesome/css/font-awesome.min.css" />
     <script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-2.2.0.min.js" >
     </script>
     <script src="https://ajax.aspnetcdn.com/ajax/bootstrap/3.3.7/bootstrap.min.js">
     </script>
     <script src="wwwroot/js/site.min.js">
     </script>
    <link rel="stylesheet" type="text/css" href="wwwroot/css/admin/css/style.css" />
    <link rel="stylesheet" type="text/css" href="wwwroot/css/admin/css/themes/flat-blue.css" />
</head>

<body class="flat-blue">
    <div class="app-container">
        <div class="row content-container">
            <nav class="navbar navbar-default navbar-fixed-top navbar-top">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-expand-toggle">
                            <i class="fa fa-bars fa-2x icon"></i>
                        </button>
                        <ol class="breadcrumb navbar-breadcrumb">
                            <li class="active">后台管理中心</li>
                        </ol>
                        <button type="button" class="navbar-right-expand-toggle pull-right visible-xs">
                            <i class="fa fa-th icon"></i>
                        </button>
                    </div>
                    <ul class="nav navbar-nav navbar-right">
                        <button type="button" class="navbar-right-expand-toggle pull-right visible-xs">
                            <i class="fa fa-times icon"></i>
                        </button>
                        
                        <li class="dropdown profile">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=userName %><span class="caret"></span></a>
                            <ul class="dropdown-menu animated fadeInDown">
                                
                                <li>
                                    <div class="profile-info">
                                        <h5 class="username"><%=userName %></h5>
                                        <div class="btn-group margin-bottom-2x" role="group">
                                            <a href="PersonView.jsp"  class="btn btn-default"><i class="fa fa-user"></i> Profile</a>
                                            <a href="login.jsp" class="btn btn-default"><i class="fa fa-sign-out"></i> Logout</a>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="side-menu sidebar-inverse">
                <nav class="navbar navbar-default" role="navigation">
                    <div class="side-menu-container">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="#">
                                <div class="icon fa fa-paper-plane"></div>
                                <div class="title">后台管理</div>
                            </a>
                            <button type="button" class="navbar-expand-toggle pull-right visible-xs">
                                <i class="fa fa-times icon"></i>
                            </button>
                        </div>
                        <ul class="nav navbar-nav">
                            <li class="">
                                <a href="index.jsp">
                                    <span>信息</span>
                                </a>
                            </li>
                            <%
                              int companyType=1;
                              if(session.getAttribute("companyType")==null||session.getAttribute("companyType")=="")
                              {
                              	response.sendRedirect("login.jsp");
                              	return ;
                              }
                              companyType=(int)session.getAttribute("companyType");
                              
                              //总部下发任务
                              if(companyType==1)
                              {
                              	//工程管理
                              	out.println("<li class='panel panel-default dropdown "+zongbunav+"'>");
                              	out.println("<a data-toggle='collapse' href='#dropdown-headquartersproject'>");
                              	out.println("<span>工程</span>");
                              	out.println("</a>");
                              	out.println("<div id='dropdown-headquartersproject' class='panel-collapse collapse'>");
                              	out.println("<div class='panel-body'>");
                              	out.println("<ul class='nav navbar-nav'>");
                              	out.println("<li><a href='HeadquartersAddProject.jsp'>添加工程</a></li>");
                              	out.println("<li><a href='HeadquartersQueryProject.jsp'>查看工程</a></li>");
                              	out.println("</ul></div></div></li>");
                              }
                              //分部
                              if(companyType==2)
                              {
                              	//工程管理
                              	out.println("<li class='panel panel-default dropdown "+fenbunav+"'>");
                              	out.println("<a data-toggle='collapse' href='#dropdown-branchproject'>");
                              	out.println("<span>工程</span>");
                              	out.println("</a>");
                              	out.println("<div id='dropdown-branchproject' class='panel-collapse collapse'>");
                              	out.println("<div class='panel-body'>");
                              	out.println("<ul class='nav navbar-nav'>");
                              	out.println("<li><a href='BranchQueryProject.jsp'>查看工程</a></li>");
                              	out.println("</ul></div></div></li>");
                              	out.println();
                              	out.println();
                              }
                              if(companyType==1||companyType==2)
                              {
                              	//子单位管理
                              	out.println("<li class='panel panel-default dropdown "+zidanwei+"'>");
                              	out.println("<a data-toggle='collapse' href='#dropdown-userproject'>");
                              	out.println("<span>子单位</span>");
                              	out.println("</a>");
                              	out.println("<div id='dropdown-userproject' class='panel-collapse collapse'>");
                              	out.println("<div class='panel-body'>");
                              	out.println("<ul class='nav navbar-nav'>");
                              	out.println("<li><a href='AddSubordinate.jsp'>添加子单位</a></li>");
                              	out.println("<li><a href='QuerySubordinate.jsp'>查看子单位</a></li>");
                              	out.println("</ul></div></div></li>");
                              	out.println();
                              	out.println();
                              }
                               //三级下属单位
                              if(companyType==3)
                              {
                              	//工程管理
                              	out.println("<li class='panel panel-default dropdown "+subunitsproject+"'>");
                              	out.println("<a data-toggle='collapse' href='#dropdown-subunitsproject'>");
                              	out.println("<span>工程</span>");
                              	out.println("</a>");
                              	out.println("<div id='dropdown-subunitsproject' class='panel-collapse collapse'>");
                              	out.println("<div class='panel-body'>");
                              	out.println("<ul class='nav navbar-nav'>");
                              	out.println("<li><a href='SubunitsQueryProject.jsp'>查看工程</a></li>");
                              	out.println("</ul></div></div></li>");
                              	out.println();
                              	out.println();
                              }
                             %>
                            <!-- Dropdown-->
                            <li class="panel panel-default dropdown <%=personal%>">
                                <a data-toggle="collapse" href="#component-person">
                                    <span>个人</span>
                                </a>
                                <!-- Dropdown level 1 -->
                                <div id="component-person" class="panel-collapse collapse ">
                                    <div class="panel-body">
                                        <ul class="nav navbar-nav">
                                            <li>
                                                <a href="PersonView.jsp">查看信息</a>
                                            </li>
                                            <li>
                                                <a href="PersonAlter.jsp">修改密码</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <a href="login.jsp">
                                    <span>退出</span>
                                </a>
                            </li>
                            
                        </ul>
                    </div>
                    <!-- /.navbar-collapse -->
                </nav>
            </div>
            <!-- Main Content -->
            <div class="container-fluid">
                <div class="container body-content">
                    <div class="side-body padding-top">