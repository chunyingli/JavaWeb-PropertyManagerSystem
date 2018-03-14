<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	String PageTitle="查看个人信息";
	String zongbunav="";
	String fenbunav="";
	String zidanwei="";
	String personal="active";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp" %>

<label id="Submit_Tips" style="color:red;"></label>
<table class="table table-bordered">
  <tr>
    <td>公司名称</td>
    <td><label id="companyName"></label></td>
  </tr>
  <tr>
    <td>成立时间</td>
    <td><label id="companyBrith"></label></td>
  </tr>
  <tr>
    <td>公司地点</td>
    <td><label id="companyPlace"></label></td>
  </tr>
</table>
<script>
	$.ajax({
         type: 'get',
         url: "servlet/FindMyInfoServlet",
         data: {
         },
         success: function (resultStr) {
         	var result = JSON.parse(resultStr);
             if (result.isSuccess==null) {
                 $("#Submit_Tips").html('查询成功！');
                 //查询成功
                 if(result.companyName!=null)$("#companyName").html(result.companyName);
                 if(result.companyBrith!=null)
                 {
                 	var timestamp = new Date(result.companyBrith);
                 	var timestr=timestamp.getFullYear()+'年';
                 	timestr+=timestamp.getMonth()+1;
                 	timestr+='月'+timestamp.getDate()+'日';
                 	$("#companyBrith").html(timestr);
                 }
                 if(result.companyPlace!=null)$("#companyPlace").html(result.companyPlace);
             }
             else if(result.isSuccess==false)
             	$("#Submit_Tips").html('查询失败！');
         },
         error: function (XMLHttpRequest, textStatus, errorThrown) {
             $("#Submit_Tips").html('发生了错误！');
         } 
     }); 
</script>

<%@ include  file="footer.jsp" %>