<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<%
	String PageTitle="查看下属单位";
	String zongbunav="";
	String fenbunav="";
	String zidanwei="active";
	String personal="";
	String subunitsproject="";
 %>
<%@ include  file="header.jsp"%>
<label style="color:red;"><h4>查看子单位详细信息</h5></label>
<table class="table table-bordered">
	<tr>
		<th>单位名称</th>
		<th>办公地点</th>
		<th>成立时间</th>
		<th>备注</th>
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
        //查询总页数
    	$.ajax({
         type: 'get',
         url: "servlet/FindUnderingNumServlet",
         data: {
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
  function loaddata(){
     $.ajax({
         type: 'get',
         url: "servlet/FindMyEmployeeServlet",
         data: {
             'Page':page         
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
                 		var timestamp = new Date(result[i].companyBrith);
                 		var timestr=timestamp.getFullYear()+'年';
                 		timestr+=timestamp.getMonth()+1;
                 		timestr+='月'+timestamp.getDate()+'日';
                 		$('.table').append('<tr><td>' + result[i].companyName + '</td><td>' + result[i].companyPlace + '</td><td>' 
                 		 + timestr +'</td><td>' 
                 		+ result[i].companyRemark + '</td></tr>')
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
  </script>
<%@ include  file="footer.jsp"%>
