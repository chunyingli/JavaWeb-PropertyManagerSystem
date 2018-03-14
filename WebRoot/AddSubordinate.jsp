<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="添加下属单位";
	String zongbunav="";
	String fenbunav="";
	String zidanwei="active";
	String personal="";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp"%>
<style>
		input{
			margin-left:20px;
			width:170px;
		}
		select{
			margin-left:17px;
			width:170px;
		}
	</style>
	<label style="color:red;"><h3>添加子单位</h5></label>
	<br/>
	<label>账户名称:</label><input id="UserName" /><label style="color:red;" id="UserName_Tips"></label>
	<br/><br/>
	<label>账户密码:</label><input id="UserPwd" type="password" /><label style="color:red;" id="UserPwd_Tips"></label>
	<br/><br/>
	<label>单位名称:</label><input id="CompanyName" /><label style="color:red;" id="CompanyName_Tips"></label>
	<br/><br/>
	<label>办公地点:</label><input id="CompanyPlace" /><label style="color:red;" id="CompanyPlace_Tips"></label>
	<br/><br/>
	<label>成立时间:</label><input id="CompanyBrith" type="date" /><label style="color:red;" id="Submit_Tips"></label>
	<br/><br/>
	<label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
	<br/>
	<textarea id="CompanyRemark" style="width:250px;height:80px;">
	
	</textarea>
	<br/><br/>
	<button  id="Submit" type="button" class="btn btn-info" />添加</button>
	<label style="color:red;" id="Submit_Tips"></label>
<%@ include  file="footer.jsp"%>
<script>
	
    //判断名称是否为空
    $("#UserName").blur(function () {
        if ($("#UserName").val() == null || $("#UserName").val() == "")
            $('#UserName_Tips').html('账户名称为空！');
        else $('#UserName_Tips').html('');
    });
    //判断密码是否为空
    $("#UserPwd").blur(function () {
        if ($("#UserPwd").val() == null || $("#UserPwd").val() == "")
            $('#UserPwd_Tips').html('密码为空！');
        else $('#UserPwd_Tips').html('');
    });
    //判断单位名称是否为空
    $("#CompanyName").blur(function () {
        if ($("#CompanyName").val() == null || $("#CompanyName").val() == "")
            $('#CompanyName_Tips').html('单位名称为空！');
        else $('#CompanyName_Tips').html('');
    });
    //判断办公地点是否为空
    $("#CompanyPlace").blur(function () {
        if ($("#CompanyPlace").val() == null || $("#CompanyPlace").val() == "")
            $('#CompanyPlace_Tips').html('办公地点为空！');
        else $('#CompanyPlace_Tips').html('');
    });
    //判断成立时间是否为空
    $("#CompanyBrith").blur(function () {
        if ($("#CompanyBrith").val() == null || $("#CompanyBrith").val() == "")
            $('#CompanyBrith_Tips').html('成立时间为空！');
        else $('CompanyBrith_Tips').html('');
    });
    
    //submit按钮点击事件
    $("#Submit").click(function () {
        if ($("#UserName").val() == null || $("#UserName").val() == "")
        {
            $('#UserName_Tips').html('账户名称为空！');
            return;
        }
        if ($("#UserPwd").val() == null || $("#UserPwd").val() == "")
        {
            $('#UserPwd_Tips').html('密码为空为空！'); 
            return;
        }
        if ($("#CompanyName").val() == null || $("#CompanyName").val() == "")
        {
            $('#CompanyName_Tips').html('单位名称为空！'); 
            return;
        }
        if ($("#CompanyPlace").val() == null || $("#CompanyPlace").val() == "")
        {
            $('#CompanyPlace_Tips').html('办公地点为空！'); 
            return;
        }
        if ($("#CompanyBrith").val() == null || $("#CompanyBrith").val() == "")
        {
            $('#CompanyBrith_Tips').html('成立时间为空！'); 
            return;
        }
        $.ajax({
            type: 'post',
            url: "servlet/AddUnderlingServlet",
            data: {
                'UserName': $("#UserName").val(),
                'UserPwd': $("#UserPwd").val(),
                'CompanyName':$("#CompanyName").val(),
                'CompanyPlace':$("#CompanyPlace").val(),
                'CompanyBrith':$("#CompanyBrith").val()
            },
            success: function (resultStr) {
            	var result = JSON.parse(resultStr);
                if (result!=null) {
                    $("#Submit_Tips").html(result.msg);
                    //添加成功
                    if (result.isSuccess) {
                        $("#UserName").val('');
                        $("#UserPwd").val('');
                        $("#CompanyName").val('');
                        $("#CompanyPlace").val('');
                        $("#CompanyBrith").val('');
                    }
                    
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $("#Submit_Tips").html('发生了错误！');
            } 
        }); 
    });
	</script>