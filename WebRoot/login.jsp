<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
	session.invalidate();
 %>
<!DOCTYPE>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>管理人员登陆</title>
    <link rel="stylesheet" href="https://ajax.aspnetcdn.com/ajax/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="wwwroot/css/site.min.css" />
    <link rel="stylesheet" href="wwwroot/css/FontAwesome/css/font-awesome.min.css" />
    <script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-2.2.0.min.js" >
    </script>
    <script src="https://ajax.aspnetcdn.com/ajax/bootstrap/3.3.7/bootstrap.min.js">
    </script>
    <script src="wwwroot/js/site.min.js">
    </script>
    <style>
    label {
        margin-top:10px;
        padding-right: 20px;
        padding-left:5px;
    }
    input {
        margin-top: 20px;
        border:2px;
        border-radius: 5px;
    }
    input:hover {
        background-color: #FFF;
    }
    input:focus {
        border: 1px solid #31b6e7;
        background-color: #FFF;
        -webkit-box-shadow: #CCC 0px 0px 5px;
        -moz-box-shadow: #CCC 0px 0px 5px;
        box-shadow: #0178a4 0px 0px 5px;
    }
</style>
</head>
  
<body>
   <div >
      <div style="background-image:url('wwwroot/images/Admin/login-bg.jpg');background-size:cover;height:100%;">
	    <div style="width:100%;height:200px;">
	    	<div style="width:10px;height:80px;"></div>
	    	<i style="font-size:28px;color:#00FF00;margin-left:35%;">菱杰房地产信息系统</i>
	    </div>
	   	<div style="width:600px;height:292px; background-image:url('wwwroot/images/Admin/login.png');background-repeat:no-repeat;margin:auto;">
	       <div style="padding-top:50px;padding-left:100px;">
	           <div>
	               <label>用户名</label>
	               <input type="text"  id="UserName" placeholder="用户名" name="UserName">
	               <label style="color:red;" id="UserName_Tips"></label>
	           </div>
	           <div>
	               <label>密　码</label>
	               <input type="password"  id="Password" placeholder="密码" name="Password">
	               <label style="color:red;" id="Password_Tips"></label>
	               
	           </div>
	           <div>
	               <label>验证码</label>
	               <input type="text" id="VerificationCode" placeholder="验证码" name="VerificationCode" style="width:80px;">
	               <img id="VerificationCode_Img" src="servlet/getVerificationImg" alt="看不清？点击更换" onclick="this.src = this.src + '?'" />
	               <label style="color:red;" id="VerificationCode_Tips"></label>
	
	           </div>
	           <br />
	           <input type="button" id="Submit" value="登录" style="margin-left:25%;" onclick="">
	           <label style="color:red;" id="Submit_Tips"></label>
	       </div>
	   </div>
	   <hr />
	   <div style="bottom:60px;position:absolute;left:35%;">
        <footer style="text-align:center;">
            <p>&copy; 2018 - 菱杰房地产综合管理信息系统</p>
        </footer>
	   
	   </div>
	   
	</div>
	<script>
    //页面加载完毕执行此函数
    //判断用户名是否为空
    $("#UserName").blur(function () {
        if ($("#UserName").val() == null || $("#UserName").val() == "")
            $('#UserName_Tips').html('用户名为空！');
        else $('#UserName_Tips').html('');
    });
    $("#UserName").focus(function () {
        //if ($("#UserName").val() == null || $("#UserName").val() == "")
        //    $('#UserName_Tips').html('用户名为空！');
    });
    //判断密码是否为空
    $("#Password").blur(function () {
        if ($("#Password").val() == null || $("#Password").val() == "")
            $('#Password_Tips').html('密码为空！');
        else $('#Password_Tips').html('');
    });
    //判断验证码是否为空
    $("#VerificationCode").blur(function () {
        if ($("#VerificationCode").val() == null || $("#VerificationCode").val() == "")
            $('#VerificationCode_Tips').html('验证码为空！');
        else $('#VerificationCode_Tips').html('');
    });
    //submit按钮点击事件
    $("#Submit").click(function () {
        if ($("#UserName").val() == null || $("#UserName").val() == "")
        {
            $('#UserName_Tips').html('用户名为空！');
            return;
        }
        if ($("#Password").val() == null || $("#Password").val() == "")
        {
            $('#Password_Tips').html('密码为空！'); 
            return;
        }
        if ($("#VerificationCode").val() == null || $("#VerificationCode").val() == "")
        {
            $('#VerificationCode_Tips').html('验证码为空！'); 
            return;
        }
        var VerificationCode = $("#VerificationCode").val();
        $.ajax({
            type: 'post',
            url: "servlet/LoginServlet",
            data: {
                'UserName': $("#UserName").val(),
                'UserPwd': $("#Password").val(),
                'VerificationCode': VerificationCode.toLowerCase()
            },
            success: function (resultStr) {
            	var result = JSON.parse(resultStr);
                if (result!=null) {
                    $("#Submit_Tips").html(result.msg);
                    //登陆成功
                    if (result.isSuccess) {
                        setTimeout(function () {//两秒后跳转  
                            location.href = "index.jsp";//PC网页式跳转  
                             
                        }, 2000);  

                    }
                    //登陆失败
                    else {
                        $("#Password").val('');
                        $("#VerificationCode").val('');
                        $("#VerificationCode_Img").click();
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $("#Submit_Tips").html('发生了错误！');
            } 
        }); 
    });
	</script>
        
        
        
        
    </div>
  </body>
</html>
