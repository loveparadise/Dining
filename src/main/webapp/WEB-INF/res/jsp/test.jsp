<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<jsp:include page="base.jsp"></jsp:include>
</head>

<body>
<input type="button" value="print" onclick="printSome('<%=basePath %>file/V_13.0.pdf')"/>
<div style="display:none">
<div id="to_print"></div>
<input type="button" id="print_button" value="Print" onclick="document.getElementById('FILEtoPrint').focus(); document.getElementById('FILEtoPrint').contentWindow.print();" />
</div>
 
<script>
function printSome(path){ //传入文件路径
    $("#to_print").html('<iframe src='+path+' id="FILEtoPrint"></iframe>');
    setTimeout(function(){$("#print_button").click();}, 1000);
}
</script>
</body>
</html>