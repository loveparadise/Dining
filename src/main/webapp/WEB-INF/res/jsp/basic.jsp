<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<html>
<head>
<link media="screen" rel="stylesheet" type="text/css"
	href="<%=basePath%>res/css/dropdown.css">
<link rel="stylesheet" href="<%=basePath%>res/css/global.css"
	type="text/css">

<link href="<%=basePath%>res/css/calendar/jquery.ui.all.css"  rel="stylesheet" >
	
<script src="<%=basePath%>res/js/head.js"></script>
<script src="<%=basePath%>res/js/jquery-1.11.1.js"></script>
<script type="text/javascript"> 
     var $j = jQuery.noConflict(); 
</script>
<script src="<%=basePath%>res/js/jquery.form.js"></script>


<script src="<%=basePath%>res/js/jquery.ui.core.js"></script>
<script src="<%=basePath%>res/js/jquery.ui.widget.js"></script>
<script src="<%=basePath%>res/js/jquery.ui.datepicker.js"></script>
<script type="text/javascript">
	var basePath = "<%=basePath%>";
	function validateDate(obj) {
		var regexp = new RegExp(
				"(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
		if (!regexp.test($(obj).val()))
			$j(obj).val("");
	}
	
	$j(function() {
		$j( ".calendar" ).datepicker({
			showOn: "button",
			buttonImage: basePath+"res/img/Calendar/date.gif",
			buttonImageOnly: false
		});
	});
	
	function pop(obj)
	{
		$j($j(obj).next()).trigger("click");
	}
</script>