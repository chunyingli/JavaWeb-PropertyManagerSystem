<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="总部查看工程页面";
	String zongbunav="active";
	String fenbunav="";
	String zidanwei="";
	String personal="";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp"%>
<label style="color:red;"><h4>查看工程信息</h5></label>
<select id="chooseValue" style="margin-left:20px;">
	<option value="1">全部</option>
	<option value="2">未完成</option>
	<option value="3">已完成</option>
</select>

<table class="table table-bordered">
	<tr>
		<th>名称</th>
		<th>地点</th>
		<th>处理单位</th>
		<th>起始时间</th>
		<th>预算</th>
		<th>状态</th>
		<th>修改</th>
		<th>详情</th>
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
             'mark':'Release'
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
<%@ include  file="footer.jsp"%>
<script>
   //查询数据，追加到表格中
   function loaddata(){
     $.ajax({
         type: 'get',
         url: "servlet/FindMyRealseServlet",
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
                 		if(result[i].state==3)var state='已完成';
                 		var timestamp = new Date(result[i].startTime);
                 		var timestr=timestamp.getFullYear()+'年';
                 		timestr+=timestamp.getMonth()+1;
                 		timestr+='月'+timestamp.getDate()+'日';
                 		$('.table').append('<tr><td>' + result[i].name + '</td><td>' + result[i].place + '</td><td>' 
                 		+ result[i].acceptCompanyName +'</td><td>' + timestr +'</td><td>' 
                 		+ result[i].budgetMoney + '</td><td>' + state 
                 		+'</td><td><a href="HeadquartersChangeProject.jsp?ProjectNo='+result[i].projectNo+
                 		'" >修改</a></td><td><a href="HeadquartersViewProject.jsp?ProjectNo='+result[i].projectNo+'">详情</a></td></tr>')
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
     	location.href="HeadquartersQueryProject.jsp?Page="+page+"&chooseValue="+$("#chooseValue").val();
     })
	</script>
