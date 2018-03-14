<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="总部查看具体的工程信息";
	String zongbunav="active";
	String fenbunav="";
	String zidanwei="";
	String personal="";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp"%>

<link rel="stylesheet" href="wwwroot/css/timeline/timeline-style.css" />
<table class="table table-bordered">
	<caption id="Name" style="font-size:20px;"></caption>
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
                	if(result.state==3)state='已完成';
                	$("#State").html(state);
                	if(result.state==3)
                	{
                		$(".list-group-item").hide();
                	}
                }
                
            }
            else alert('非法访问!');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert('发生了错误！');
        } 
    });
   //展示子项目信息
   function loadData(){
   		var timelinestr1="<div class='cd-timeline-block'><div class='cd-timeline-img cd-picture'>\
			<img src='wwwroot/css/timeline/img/cd-icon-location.svg' alt='Location' />\
		</div>\
		<div class='cd-timeline-content'>\
			<h2>mytitle&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label style='color:mystatecolor;'>mystate</label></h2>\
			<p>mycontent</p>\
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
   }
   loadData();
</script>   
<%@ include  file="footer.jsp"%>