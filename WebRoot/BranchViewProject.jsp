<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="分部查看管理详细工程信息";
	String zongbunav="active";
	String fenbunav="";
	String zidanwei="";
	String personal="";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp"%>
<link rel="stylesheet" href="wwwroot/css/timeline/timeline-style.css" />
<table class="table table-bordered">
	<caption id="Name">名称</caption>
	<tr>
		<th>地点</th>
		<th>预算</th>
		<th>实际花销</th>
		<th>是否超支</th>
		<th>备注</th>
	</tr>
	<tr>
		<td><label id="Place"></label></td>
		<td><label id="BudgetMoney"></label></td>
		<td><label id="NowMoney"></label></td>
		<td><label id="IsOverspend"></label></td>
		<td><label id="Remark"></label></td>
	</tr>
	<tr>
		<th>开始时间</th>
		<th>结束时间</th>
		<th>完成时间</th>
		<th>状态</th>
		<th>所用天数</th>
	</tr>
	<tr>
		<td><label id="StartTime"></label></td>
		<td><label id="EndTime"></label></td>
		<td><label id="FinishTime"></label></td>
		<td><label id="State"></label></td>
		<td><label id="UseDay"></label></td>
	</tr>
</table>
 
<button id="finish-button">提交完成&nbsp;&nbsp;&nbsp;</button><label id="finish-button-tips"></label>
<br/><br/>
<li class="panel panel-default  list-group-item">
       <a data-toggle="collapse" href="#component-addproject">
           <span>添加子任务</span>
       </a>
       <div id="component-addproject" class="panel-collapse collapse ">
           <div class="panel-body">
               	<style>
					input{
						margin-left:20px;
						width:170px;
						margin-right:20px;
					}
					select{
						margin-left:17px;
						width:170px;
					}
					
				</style>
				<label>工程名称:</label><input id="Name-add" />
				<label>工程地点:</label><input id="Place-add" />
				<br/><br/>
				<label>起始时间:</label><input id="StartTime-add" type="date" />
				<label>结束时间:</label><input id="EndTime-add" type="date" />
				<br/><br/>
				<label>工程预算:</label><input id="BudgetMoney-add" />
				<label>接收单位:</label>
				<select id="AcceptCompanyNo">
					
				</select>
				<label style="color:red;" id="AcceptCompanyNo_Tips"></label>
				<br/><br/>
				<label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
				<br/>
				<textarea id="Remark-add" style="width:250px;height:80px;max-length:200;">
	
				</textarea>
				<br/><br/>
				<button  id="Submit" />添加</button>
				<label style="color:red;" id="Submit_Tips"></label>
           </div>
       </div>
   </li>    
<section id="cd-timeline" class="cd-container">
	
</section>
<script>
	//填充项目基本信息
	function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg); //匹配目标参数
        if (r != null) return unescape(r[2]); return null; //返回参数值
    }
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
                	$("#Name").html(result.name);
                	$("#BudgetMoney").html(result.budgetMoney);
                	$("#Place").html(result.place);
                	$("#NowMoney").html(result.nowMoney);
                	if(result.nowMoney>result.budgetMoney)$("#IsOverspend").html('已超支');
                	else $("#IsOverspend").html('未超支');
                	$("#Remark").html(result.remark);
                	var starttimestamp = new Date(result.startTime);
                	//格式化日，如果小于9，前面补0
					var day = ("0" + starttimestamp.getDate()).slice(-2);
					//格式化月，如果小于9，前面补0
					var month = ("0" + (starttimestamp.getMonth() + 1)).slice(-2);
					//拼装完整日期格式
					var today = starttimestamp.getFullYear()+"-"+(month)+"-"+(day) ;
					//完成赋值
					$('#StartTime').html(today);
                	var endtimestamp = new Date(result.endTime);
                	day = ("0" + endtimestamp.getDate()).slice(-2);
                	month = ("0" + (endtimestamp.getMonth() + 1)).slice(-2);
                	today = endtimestamp.getFullYear()+"-"+(month)+"-"+(day) ;
                	$("#EndTime").html(today);
                	if(result.finishTime!=null)
                	{
                		var finishtimestamp = new Date(result.finishTime);
                		day = ("0" + finishtimestamp.getDate()).slice(-2);
	                	month = ("0" + (finishtimestamp.getMonth() + 1)).slice(-2);
	                	today = finishtimestamp.getFullYear()+"-"+(month)+"-"+(day) ;
	                	$("#FinishTime").html(today);
	                	var time = finishtimestamp.getTime() - starttimestamp.getTime() ;
	                	$("#UseDay").html(Math.floor(time/(24*60*60*1000)));
                	}
                	var state='未完成';
                	if(result.state==3)
                	{
                		state='已完成';
                		$("#finish-button").attr({"disabled":"disabled"});
                		$(".list-group-item").hide();
                		
                	}
                	$("#State").html(state);
                }
                
            }
            else alert('非法访问!');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert('发生了错误！');
        } 
    });
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
       $("#Name-add").blur(function () {
          if ($("#Name-add").val() == null || $("#Name-add").val() == "")
              $('#Submit_Tips').html('工程名称为空！');
          else $('#Submit_Tips').html('');
      });
      //判断密码是否为空
      $("#Place-add").blur(function () {
          if ($("#Place-add").val() == null || $("#Place-add").val() == "")
              $('#Submit_Tips').html('工程地点为空！');
          else $('#Submit_Tips').html('');
      });
      //submit按钮点击事件
      $("#Submit").click(function () {
          if ($("#Name-add").val() == null || $("#Name-add").val() == "")
          {
              $('#Submit_Tips').html('工程名称为空！');
              return;
          }
          if ($("#Place-add").val() == null || $("#Place-add").val() == "")
          {
              $('#Submit_Tips').html('工程地点为空！'); 
              return;
          }
          if(isNaN($("#BudgetMoney-add").val())){
      		$('#Submit_Tips').html('工程预算输入不合法！'); 
              return;
  		}
          $.ajax({
              type: 'post',
              url: "servlet/AddProjectServlet",
              data: {
                  'Name': $("#Name-add").val(),
                  'Place': $("#Place-add").val(),
                  'StartTime':$("#StartTime-add").val(),
                  'EndTime':$("#EndTime-add").val(),
                  'BudgetMoney':$("#BudgetMoney-add").val(),
                  'AcceptCompanyNo':$("#AcceptCompanyNo").val(),
                  'Remark':$("#Remark-add").val(),
                  'ProjectNo':getUrlParam('ProjectNo')
              },
              success: function (resultStr) {
              	var result = JSON.parse(resultStr);
                  if (result!=null) {
                      $("#Submit_Tips").html(result.msg);
                      //添加成功
                      if (result.isSuccess) {
                          $("#Name-add").val('');
                          $("#Place-add").val('');
                          $("#StartTime-add").val('');
                          $("#EndTime-add").val('');
                          $("#BudgetMoney-add").val('');
                          $("#Remark-add").val('');
                      }
                      
                  }
              },
              error: function (XMLHttpRequest, textStatus, errorThrown) {
                  $("#Submit_Tips").html('发生了错误！');
              } 
          }); 
      });
   //展示子项目信息
   function loadData(){
   		var timelinestr1="<div class='cd-timeline-block'><div class='cd-timeline-img cd-picture'>\
			<img src='wwwroot/css/timeline/img/cd-icon-location.svg' alt='Location' />\
		</div>\
		<div class='cd-timeline-content'>\
			<h2>mytitle&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label style='color:mystatecolor;'>mystate</label></h2>\
			<p>mycontent</p>\
			<a href='HeadquartersChangeProject.jsp?ProjectNo=myProjectNo' class='cd-read-more' target='_blank'>修改</a>\
			<span class='cd-date'>mydate</span>\
		</div>\
	</div>";
	var timelinestr2=timelinestr1.replace('picture','movie');
	$.ajax({
           type: 'get',
           url: "servlet/FindMyBranchProjectByProjectNo",
           data: {
               'ProjectNo':getUrlParam('ProjectNo')
           },
           success: function (resultStr) {
           	var result = JSON.parse(resultStr);
               if (result!=null) {
                   //成功
                   if (result.isSuccess==false) {
                       alert(result.msg);
                   }
                   else{
                   	for(var i=0,l=result.length;i<l;i++){
                   		var str;
                   		if(i%2==0)str=timelinestr1;
                   		else str=timelinestr2;
                   		str=str.replace('mytitle','<label>'+result[i].name+'</label>&nbsp;&nbsp;地点:&nbsp;<label>'+result[i].place+'</label>&nbsp;&nbsp;承建单位:&nbsp;<label>'+result[i].acceptCompanyName+'</label>');
                   		str=str.replace('myProjectNo',result[i].projectNo);
                   		
                   		var starttimestamp = new Date(result[i].startTime);
	                	//格式化日，如果小于9，前面补0
						var day = ("0" + starttimestamp.getDate()).slice(-2);
						//格式化月，如果小于9，前面补0
						var month = ("0" + (starttimestamp.getMonth() + 1)).slice(-2);
						//拼装完整日期格式
						var today = starttimestamp.getFullYear()+"-"+(month)+"-"+(day) ;
						str=str.replace('mydate',today);
						var contentstr="<label>预算:&nbsp;&nbsp;";
						contentstr+=result[i].budgetMoney;
						contentstr+="</label>"
						if(result[i].state==2)
						{
							str=str.replace('mystatecolor','#c03b44');
							str=str.replace('mystate','未完成');
							$("#finish-button").attr({"disabled":"disabled"});
							$("#finish-button-tips").html('&nbsp;&nbsp;&nbsp;当前项目有未完成子项，请完成后再提交完成');
						}
						else{
							str=str.replace('mystatecolor','#75ce66');
							str=str.replace('mystate','已完成');
							str=str.replace('href',result[i].projectNo);
							contentstr+='&nbsp;&nbsp;实际:&nbsp;<label>'+result[i].nowMoney+'</label>&nbsp;&nbsp;<label>';
							if(result[i].nowMoney>result[i].budgetMoney)contentstr+='已超支';
							else contentstr+='未超支';
							contentstr+='</label>';
							var finishtimestamp = new Date(result[i].finishTime);
							day = ("0" + finishtimestamp.getDate()).slice(-2);
							//格式化月，如果小于9，前面补0
							month = ("0" + (finishtimestamp.getMonth() + 1)).slice(-2);
							//拼装完整日期格式
							today = finishtimestamp.getFullYear()+"-"+(month)+"-"+(day) ;
							contentstr+='&nbsp;&nbsp;完成于&nbsp;&nbsp;<label>';
							contentstr+=today+'</label>&nbsp;&nbsp;用时&nbsp;&nbsp;';
							var time = finishtimestamp.getTime() - starttimestamp.getTime() ;
							contentstr+=Math.floor(time/(24*60*60*1000))+'天</label>';
						}
						str=str.replace('mycontent',contentstr);
					    $("#cd-timeline").append(str);
					 }
                   }
               }
           },
           error: function (XMLHttpRequest, textStatus, errorThrown) {
               alert('发生了错误！');
           } 
       });
   	//$("#cd-timeline").append(timelinestr1);
   	//$("#cd-timeline").append(timelinestr2);
   }
   loadData();
</script>
<script>
	//提交完成
	$("#finish-button").click(function () {
          $.ajax({
              type: 'post',
              url: "servlet/FinishUpdateProjectServlet",
              data: {
                  'ProjectNo':getUrlParam('ProjectNo')
              },
              success: function (resultStr) {
              	var result = JSON.parse(resultStr);
                  if (result.isSuccess==true) {
                      alert('已经成功提交');
                      $("#finish-button").attr({"disabled":"disabled"});
                		$(".list-group-item").hide();
                  }
                  else alert('提交失败');
              },
              error: function (XMLHttpRequest, textStatus, errorThrown) {
                  $("#Submit_Tips").html('发生了错误！');
              } 
          }); 
      });

</script>
<%@ include  file="footer.jsp"%>
