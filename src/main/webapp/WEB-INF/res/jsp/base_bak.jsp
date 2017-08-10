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
<html lang="zh-cmn">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- basic styles -->
<link href="<%=basePath%>assets/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet"	href="<%=basePath%>assets/css/font-awesome.min.css" />

<!--[if IE 7]>
		  <link rel="stylesheet" href="<%=basePath%>assets/css/font-awesome-ie7.min.css" />
<![endif]-->

<!-- page specific plugin styles -->
<!-- 表格需要的css文件 -->
<link rel="stylesheet"
	href="<%=basePath%>assets/css/jquery-ui-1.10.3.full.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/datepicker.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/ui.jqgrid.css" />

<!-- fonts -->
<link rel="stylesheet" href="<%=basePath%>assets/js/opensans.js" />

<!-- ace styles -->
<link rel="stylesheet" href="<%=basePath%>assets/css/ace.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/ace-rtl.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/ace-skins.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/jquery.gritter.css" />
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable .ui-search-toolbar th div {
	padding-top: 2px !important;
}

.ui-jqgrid .ui-jqgrid-htable .ui-search-toolbar th div input[type="text"]
	{
	height: 30px !important;
}

.ui-jqgrid .ui-jqgrid-htable th{
	height: 37px !important;
}
.ui-jqgrid .ui-search-toolbar{
	height: 37px !important;
}
</style>
<!--[if lte IE 8]>
		  <link rel="stylesheet" href="<%=basePath%>assets/css/ace-ie.min.css" />
<![endif]-->

<!-- ace settings handler -->
<script src="<%=basePath%>assets/js/ace-extra.min.js"></script>

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
		<script src="<%=basePath%>assets/js/html5shiv.js"></script>
		<script src="<%=basePath%>assets/js/respond.min.js"></script>
<![endif]-->
<!--[if !IE]> -->
<script type="text/javascript">
	var src="<%=basePath%>assets/js/jquery-2.0.3.min.js";
	window.jQuery || document.write("<script src='"+src+"'>"+"<"+"script>");
</script>
<!-- <![endif]-->
<!--[if !IE]> -->
	<script src="<%=basePath%>assets/js/jquery-2.0.3.min.js"></script>
<!-- <![endif]-->

<!--[if IE]>
	<script src="<%=basePath%>assets/js/jquery-2.0.3.min.js"></script>
<![endif]-->

<!--[if IE]>
<script type="text/javascript">
 	window.jQuery || document.write("<script src='<%=basePath%>assets/js/jquery-2.0.3.min.js'>"+"<"+"script>");
</script>
<![endif]-->

<script type="text/javascript">
		try{ace.settings.check('main-container' , 'fixed')}catch(e){};
		try{ace.settings.check('breadcrumbs' , 'fixed')}catch(e){};
		try{ace.settings.check('navbar' , 'fixed')}catch(e){};
		try{ace.settings.check('sidebar' , 'collapsed')}catch(e){};
		var $path_base = "/";
		var basePath='<%=basePath%>';
		var grid_selector = "#grid-table";
		var pager_selector = "#grid-pager";
		
		 var datePick = function(elem)
          {
                jQuery(elem).datepicker({format:'yyyy-mm-dd' , autoclose:true});
          }
		 
		 function alertMsg(obj,clas,title,detail)
		 {
			 var str="<button type='button' class='close'  aria-hidden='true' onclick='closeAlertMsg()'> &times; </button>";
			 jQuery(obj).attr("class",clas).html(str+"<strong>"+title+":</strong>"+detail);
		 }
		 
		 function closeAlertMsg()
		 {
			 jQuery("#alertMsg").attr("class","hidden");
		 }
</script>
<script >
	jQuery.browser={};(function(){jQuery.browser.msie=false; jQuery.browser.version=0;if(navigator.userAgent.match(/MSIE ([0-9]+)./)){ jQuery.browser.msie=true;jQuery.browser.version=RegExp.$1;}})();
</script>
<script type="text/javascript">
		if("ontouchend" in document) document.write("<script src='<%=basePath%>assets/js/jquery.mobile.custom.min.js'>"+"<"+"script>");
</script>
<script src="<%=basePath%>assets/js/bootstrap.min.js"></script>
<script src="<%=basePath%>assets/js/typeahead-bs2.min.js"></script>

<!-- page specific plugin scripts -->

<!-- 表格需要js -->
<script
	src="<%=basePath%>assets/js/date-time/bootstrap-datepicker.min.js"></script>
<script src="<%=basePath%>assets/js/jqGrid/jquery.jqGrid.min.js"></script>
<script src="<%=basePath%>assets/js/jqGrid/i18n/grid.locale-cn.js"></script>

<!--[if lte IE 8]>
		  <script src="<%=basePath%>assets/js/excanvas.min.js"></script>
<![endif]-->

<script src="<%=basePath%>assets/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="<%=basePath%>assets/js/jquery.ui.touch-punch.min.js"></script>
<script src="<%=basePath%>assets/js/jquery.slimscroll.min.js"></script>
<script src="<%=basePath%>assets/js/jquery.easy-pie-chart.min.js"></script>
<script src="<%=basePath%>assets/js/jquery.sparkline.min.js"></script>
<script src="<%=basePath%>assets/js/flot/jquery.flot.min.js"></script>
<script src="<%=basePath%>assets/js/flot/jquery.flot.pie.min.js"></script>
<script src="<%=basePath%>assets/js/flot/jquery.flot.resize.min.js"></script>
<script src="<%=basePath%>assets/js/jquery-resize.js"></script>

<!-- ace scripts -->

<script src="<%=basePath%>assets/js/ace-elements.min.js"></script>
<script src="<%=basePath%>assets/js/ace.min.js"></script>
</head>
<body>
<div style="display:none">
	<script src="<%=basePath%>assets/js/vcnzz.js" language='JavaScript'
		charset='utf-8'>
	</script>
</div>
</body>