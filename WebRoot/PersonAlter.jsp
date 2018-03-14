<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="修改个人信息";
	String zongbunav="";
	String fenbunav="";
	String zidanwei="";
	String personal="active";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp"%>
<label style="color:red;">修改密码</label>
<br/><br/>
<label>密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码：</label>	<input id="Password" type="password" />
<label style="color:red;" id="Password_Tips"></label>
<br/><br/>
<label>确认密码：</label><input id="UserPwdConfim" type="password" />
<label style="color:red;" id="UserPwdConfim_Tips"></label>
<br/><br/>
<input type="button" value="修改" id="Submit" />
<label style="color:red;" id="Submit_Tips"></label>
<%@ include  file="footer.jsp"%>
	<script>
     //判断用户名是否为空
     $("#Password").blur(function () {
         if ($("#Password").val() == null || $("#Password").val() == "")
             $('#Password_Tips').html('密码为空！');
         else $('#Password_Tips').html('');
     });
     //判断密码是否为空
     $("#UserPwdConfim").blur(function () {
         if ($("#UserPwdConfim").val() == null || $("#UserPwdConfim").val() == "")
             $('#UserPwdConfim_Tips').html('确认密码为空！');
         else if($("#UserPwdConfim").val()!=$("#Password").val())
         	$('#UserPwdConfim_Tips').html('两次密码不一样！');
         else $('#UserPwdConfim_Tips').html('');
     });
     //submit按钮点击事件
     $("#Submit").click(function () {
         if ($("#Password").val() == null || $("#Password").val() == "")
         {
             $('#Password_Tips').html('密码为空！');
             return;
         }
         if ($("#UserPwdConfim").val() == null || $("#UserPwdConfim").val() == "")
         {
             $('#UserPwdConfim_Tips').html('确认密码为空！'); 
             return;
         }
         if($("#UserPwdConfim").val()!=$("#Password").val())
         {
         	$("#Submit_Tips").html('两次密码不一样！');
         	return;
         }
         $.ajax({
             type: 'post',
             url: "servlet/updatePwd",
             data: {
                 'UserPwd': $("#Password").val(),
                 'UserPwdConfim': $("#UserPwdConfim").val()
             },
             success: function (resultStr) {
             	var result = JSON.parse(resultStr);
                 if (result!=null) {
                     $("#Submit_Tips").html(result.msg);
                     //登陆成功
                     if (result.isSuccess) {
                         $("#Password").val('');
                         $("#UserPwdConfim").val('');
                     }
                     
                 }
             },
             error: function (XMLHttpRequest, textStatus, errorThrown) {
                 $("#Submit_Tips").html('发生了错误！');
             } 
         }); 
     });
	</script>