<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	String PageTitle="查看工程信息";
	String zongbunav="";
	String fenbunav="";
	String zidanwei="";
	String personal="";
	String subunitsproject="active";
 %>
<%@ include  file="header.jsp"%>
<label style="color:red;"><h4>查看工程信息</h5></label>
<select id="chooseValue" style="margin-left:20px;">
	<option value="1">全部</option>
	<option value="2">未完成</option>
	<option value="3">已完成</option>
</select>
<script>
	//完成按钮事件
     function table_finish(this2,projectNo) {
     		var inputhtml="";
     		inputhtml+="<input type='text' />";
     		inputhtml+="<button type='button' class='btn btn-default btn-sm' onclick='alter_ok(this,projectNo)'>";
          	inputhtml+="<span class='glyphicon glyphicon-ok'></span></button>";
        	inputhtml+="<button type='button' class='btn btn-default btn-sm' onclick='alter_no(this,projectNo)'>";
          	inputhtml+="<span class='glyphicon glyphicon-remove'></span></button>";
     		inputhtml=inputhtml.replace('projectNo','"'+projectNo+'"');
     		inputhtml=inputhtml.replace('projectNo','"'+projectNo+'"');
     		$(this2).parent().parent().find("td:eq(6)").html(inputhtml);
     		$(this2).attr({"disabled":"disabled"});  
        }
     //选择修改分类
     function alter_ok(this2,projectNo){
     	$.ajax(
            	{
            		type:'get',
            		url:'servlet/UpdateRealMoneyServlet',
            		data:{
            			'NowMoney':$(this2).parent().find("input:eq(0)").val(),
            			'ProjectNo':projectNo
            		},
            		success:function(resultStr){
            			var result = JSON.parse(resultStr);
            			if(result.isSuccess){
            				$(this2).parent().parent().find("td:eq(7)").html('已完成');
            				$(this2).parent().html(projectNo);
            			}
            			else alert("失败");
            		}
            	}
            )  
     }
     //取消修改分类
     function alter_no(this2,projectNo){
     	$(this2).parent().parent().find("td:eq(8)").find("button").removeAttr("disabled");
     	$(this2).parent().html('0');
     }
</script>
<table class="table table-bordered">
	<tr>
		<th>名称</th>
		<th>地点</th>
		<th>起始时间</th>
		<th>结束时间</th>
		<th>完成时间</th>
		<th>预算</th>
		<th>实际花费</th>
		<th>状态</th>
		<th>完成</th>
	</tr>
</table>
<div style="text-align:center;">
    <ul class="pagination">
        <li id="Page_Previous" class=""><a href="#">&laquo;</a></li>
        <li id="Page_1" class=""><a href="#">1</a></li>
        <li id="Page_2" class=""><a href="#">2</a></li>
        <li id="Page_3" class="active"><a href="#">3</a></li>
        <li id="Page_4" class=""><a href="#">4</a></li>
        <li id="Page_5" class=""><a href="#">5</a></li>
        <li id="Page_Next" class=""><a href="#">&raquo;</a></li>
    </ul>
</div>
    <script>
    	
        //此函数完成分页功能
        function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg); //匹配目标参数
            if (r != null) return unescape(r[2]); return null; //返回参数值
        }
        var url = window.location.href;
        if (url.indexOf("?") < 0) url += "?";
        var Page_Num = 1;


        var page_temp = getUrlParam('Page');
        if (page_temp == null) {
            page_temp = 1; url += 'Page=1';
        }
        var page = parseInt(page_temp);
        var chooseValue=getUrlParam('chooseValue');
        if (chooseValue == null) {
            chooseValue = 1; url += '&chooseValue=1';
        }
        else{
        	$("#chooseValue").val(chooseValue);
        }
        
        //查询总页数
    	$.ajax({
         type: 'get',
         url: "servlet/FindProjectNumServlet",
         data: {
             'State':chooseValue,
             'mark':'Accept'
         },
         success: function (resultStr) {
         	var result = JSON.parse(resultStr);
             if (result!=null) {
                 Page_Num=result.errorCode;
                 ControllPage();
             }
         },
         error: function (XMLHttpRequest, textStatus, errorThrown) {
             alert('发生了错误！');
         } 
     }); 
     function ControllPage(){
	        
	        var pagesize = getUrlParam('PageSize');
	        if (pagesize == null) pagesize = 10;
	        var max_page = 0;
	        max_page = Math.ceil(Page_Num / pagesize);
	        //alert('pagenum:' + page_num + 'pagesize:' + pagesize + 'max_page:' + max_page + 'page:' + page);
	        document.getElementById("Page_Next").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + (page + 1));
	        document.getElementById("Page_Previous").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + (page - 1));
	        document.getElementById("Page_3").getElementsByTagName("a")[0].innerHTML = page;
	        document.getElementById("Page_3").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + page);
	        if (page <= 1) {
	            document.getElementById("Page_Previous").className = "disabled";
	            document.getElementById("Page_Previous").getElementsByTagName("a")[0].href = "#";
	        }
	        if (page >= max_page) {
	            document.getElementById("Page_Next").className = "disabled";
	            document.getElementById("Page_Next").getElementsByTagName("a")[0].href = "#";
	        }
	        if (page - 1 < 1) document.getElementById("Page_2").style.display = "none";
	        else document.getElementById("Page_2").getElementsByTagName("a")[0].innerHTML = parseInt(page) - 1;
	        document.getElementById("Page_2").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + (page - 1));
	
	        if (page - 2 < 1) document.getElementById("Page_1").style.display = "none";
	        else document.getElementById("Page_1").getElementsByTagName("a")[0].innerHTML = parseInt(page) - 2;
	        document.getElementById("Page_1").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + (page - 2));
	        if (page + 1 > max_page) document.getElementById("Page_4").style.display = "none";
	        else document.getElementById("Page_4").getElementsByTagName("a")[0].innerHTML = parseInt(page) + 1;
	        document.getElementById("Page_4").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + (page + 1));
	        if (page + 2 > max_page) document.getElementById("Page_5").style.display = "none";
	        else document.getElementById("Page_5").getElementsByTagName("a")[0].innerHTML = parseInt(page) + 2;
	        document.getElementById("Page_5").getElementsByTagName("a")[0].href = url.replace("Page=" + page, "Page=" + (page + 2));
        }
    </script>
<script>
  
  //查询数据，追加到表格中
   function loaddata(){
     $.ajax({
         type: 'get',
         url: "servlet/FindMyAcceptServlet",
         data: {
             'chooseValue': chooseValue,
             'page':page         
         },
         success: function (resultStr) {
         	var result = JSON.parse(resultStr);
             if (result!=null) {
                 //登陆成功
                 if (result.isSuccess==false) {
                    alert('发生了错误！');
                 }
                 else{
                 	//填充数据
                 	for(var i=0,len=result.length;i<len;i++)
                 	{
                 		var state='未完成';//["0"].state["0"].startTime
                 		if(result[i].state==3)state='已完成';
                 		var timestamp = new Date(result[i].startTime);
                 		var starttimestr=timestamp.getFullYear()+'年';
                 		starttimestr+=timestamp.getMonth()+1;
                 		starttimestr+='月'+timestamp.getDate()+'日';
                 		
                 		timestamp = new Date(result[i].endTime);
                 		var endtimestr=timestamp.getFullYear()+'年';
                 		endtimestr+=timestamp.getMonth()+1;
                 		endtimestr+='月'+timestamp.getDate()+'日';
                 		
                 		var finishtimestr='';
                 		if(result[i].finishTime!=null)
                 		{
                 			timestamp = new Date(result[i].finishTime);
                 			finishtimestr=timestamp.getFullYear()+'年';
                 			finishtimestr+=timestamp.getMonth()+1;
                 			finishtimestr+='月'+timestamp.getDate()+'日';
                 		}
                 		var tablestr="<tr><td>" + result[i].name + "</td><td>" + result[i].place + "</td><td>" 
                 		+ starttimestr +"</td><td>" + endtimestr +"</td><td>" + finishtimestr + "</td><td>"
                 		+ result[i].budgetMoney + "</td><td>"+ result[i].nowMoney + "</td><td>" + state +
                 		"</td><td><button ";
                 		if(result[i].state==3)tablestr+="disabled";
                 		tablestr+= " onclick='table_finish(this,projectNo)'>完成</button></td></tr>";
                 		tablestr=tablestr.replace('projectNo','"'+result[i].projectNo+'"');
                 		//"</td><td><button onclick='table_finish(this,'"+result[i].projectNo+"')'>完成</button></td></tr>";
                 		$('.table').append(tablestr);
                 	}	
                 }
                 
             }
         },
         error: function (XMLHttpRequest, textStatus, errorThrown) {
             //$("#Submit_Tips").html();
             alert('发生了错误！');
         } 
     }); 
     }
     loaddata();
     $("#chooseValue").change(function(){
     	location.href="SubunitsQueryProject.jsp?Page="+page+"&chooseValue="+$("#chooseValue").val();
     })
</script>                  
<%@ include  file="footer.jsp"%>

