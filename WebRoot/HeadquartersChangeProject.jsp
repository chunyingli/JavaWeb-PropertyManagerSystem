<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="总部修改工程页面";
	String zongbunav="active";
	String fenbunav="";
	String zidanwei="";
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
	<label style="color:red;"><h5>修改工程</h5></label>
	<br/>
	<label>工程名称:</label><input id="Name" /><label style="color:red;" id="Name_Tips"></label>
	<br/><br/>
	<label>工程地点:</label><input id="Place" /><label style="color:red;" id="Place_Tips"></label>
	<br/><br/>
	<label>起始时间:</label><input id="StartTime" type="date" />
	<br/><br/>
	<label>结束时间:</label><input id="EndTime" type="date" />
	<br/><br/>
	<label>工程预算:</label><input id="BudgetMoney" />
	<br/><br/>
	<label>接收单位:</label>
	<select id="AcceptCompanyNo">
	</select>
	<br/><br/>
	<label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
	<br/>
	<textarea id="Remark" style="width:250px;height:80px;max-length:200;">
	
	</textarea>
	<br/><br/>
	<button  id="Submit" />修改</button>
	<label style="color:red;" id="Submit_Tips"></label>
<%@ include  file="footer.jsp"%>
<script>
	function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg); //匹配目标参数
            if (r != null) return unescape(r[2]); return null; //返回参数值
        }
 	//填充下拉列表
		$.ajax({
        type: 'get',
        url: "servlet/FindMyEmployeeServlet",
        data: {
            'Page':'-1'
        },
        success: function (resultStr) {
        	var result = JSON.parse(resultStr);
            if (result!=null) {
                //登陆成功
                if (result.isSuccess==false) {
                    $("#AcceptCompanyNo_Tips").html(result.msg);
                }
                else{
                	for(var i=0,l=result.length;i<l;i++){
		    $("#AcceptCompanyNo").append("<option value='"+result[i].companyNo+"'>"+result[i].companyName+"</option>");  //为Select追加一个Option(下拉项)
		 }
                }
                
            }
            else $("#AcceptCompanyNo_Tips").html('没有数据!');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $("#Submit_Tips").html('发生了错误！');
        } 
    });
    //填充数据
    $.ajax({
        type: 'get',
        url: "servlet/FindProjectByProjectNoServlet",
        data: {
            'ProjectNo':getUrlParam('ProjectNo')
        },
        success: function (resultStr) {
        	var result = JSON.parse(resultStr);
            if (result!=null) {
                //查询成功
                if (result.isSuccess==false) {
                    alert('非法访问!');
                }
                else{
                	$("#Name").val(result.name);
                	$("#Place").val(result.place);
                	var timestamp = new Date(result.startTime);
                	//格式化日，如果小于9，前面补0
					var day = ("0" + timestamp.getDate()).slice(-2);
					//格式化月，如果小于9，前面补0
					var month = ("0" + (timestamp.getMonth() + 1)).slice(-2);
					//拼装完整日期格式
					var today = timestamp.getFullYear()+"-"+(month)+"-"+(day) ;
					//完成赋值
					$('#StartTime').val(today);
                	timestamp = new Date(result.endTime);
                	day = ("0" + timestamp.getDate()).slice(-2);
                	month = ("0" + (timestamp.getMonth() + 1)).slice(-2);
                	today = timestamp.getFullYear()+"-"+(month)+"-"+(day) ;
                	
                	$("#EndTime").val(today);
                	$("#BudgetMoney").val(result.budgetMoney);
                	$("#AcceptCompanyNo").val(result.acceptCompanyNo);
                	$("#Remark").val(result.remark);
                }
                
            }
            else alert('非法访问!');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert('发生了错误！');
        } 
    });
     //判断工程名称是否为空
     $("#Name").blur(function () {
         if ($("#Name").val() == null || $("#Name").val() == "")
             $('#Name_Tips').html('工程名称为空！');
         else $('#Name_Tips').html('');
     });
     //判断密码是否为空
     $("#Place").blur(function () {
         if ($("#Place").val() == null || $("#Place").val() == "")
             $('#Place_Tips').html('工程地点为空！');
         else $('#Place_Tips').html('');
     });
     //submit按钮点击事件
     $("#Submit").click(function () {
         if ($("#Name").val() == null || $("#Name").val() == "")
         {
             $('#Name_Tips').html('工程名称为空！');
             return;
         }
         if ($("#Place").val() == null || $("#Place").val() == "")
         {
             $('#Place_Tips').html('工程地点为空！'); 
             return;
         }
         if(isNaN($("#BudgetMoney").val())){
     		$('#Submit_Tips').html('工程预算输入不合法！'); 
             return;
 		}
         $.ajax({
             type: 'post',
             url: "servlet/UpdateProjectServlet",
             data: {
                 'Name': $("#Name").val(),
                 'Place': $("#Place").val(),
                 'StartTime':$("#StartTime").val(),
                 'EndTime':$("#EndTime").val(),
                 'BudgetMoney':$("#BudgetMoney").val(),
                 'AcceptCompanyNo':$("#AcceptCompanyNo").val(),
                 'Remark':$("#Remark").val(),
                 'ProjectNo':getUrlParam('ProjectNo')
             },
             success: function (resultStr) {
             	var result = JSON.parse(resultStr);
                 if (result!=null) {
                     $("#Submit_Tips").html(result.msg);
                     
                 }
             },
             error: function (XMLHttpRequest, textStatus, errorThrown) {
                 $("#Submit_Tips").html('发生了错误！');
             } 
         }); 
     });
	</script>