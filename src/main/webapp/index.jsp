<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html lang="zh-C2" data-device-type="dedicated">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="renderer" content="webkit">
<title>用户登录 - 安踏食堂管理系统</title>
<script src="<%=basePath%>res/js/jquery-1.11.1.js"></script>
<script type="text/javascript"> 
     var $j = jQuery.noConflict(); 
</script>
<link href="<%=basePath%>res/css/zh-cn.css" rel="stylesheet">


<style>
body {
	background-color: #fff
}

#container {
	margin: 10% auto 0 auto
}

#login-panel {
	margin: 0 auto;
	width: 540px;
	min-height: 280px;
	background-color: #fff;
	border: 1px solid #dfdfdf;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	-moz-box-shadow: 0px 0px 30px rgba(0, 0, 0, 0.75);
	-webkit-box-shadow: 0px 0px 30px rgba(0, 0, 0, 0.75);
	box-shadow: 0px 0px 30px rgba(0, 0, 0, 0.75)
}

#login-panel .panel-head {
	min-height: 70px;
	background-color: #edf3fe;
	border-bottom: 1px solid #dfdfdf;
	position: relative;
	
}

#login-panel .panel-head h4 {
	margin: 0 0 0 20px;
	padding: 0;
	line-height: 50px;
	font-size: 14px;
	font-style:inherit;
}

#login-panel .panel-actions {
	float: right;
	position: absolute;
	right: 15px;
	top: 18px;
	padding: 0
}

#login-panel .panel-actions .dropdown {
	display: inline-block;
	margin-right: 2px
}

#mobile {
	font-size: 28px;
	padding: 1px 12px;
	line-height: 28px
}

#mobile i {
	font-size: 28px;
}

#login-panel .panel-content {
	padding-left: 150px;
	background: url('<%=basePath%>res/img/aoms.png') 20px top no-repeat;
	min-height: 161px
}

#login-panel .panel-content table {
	border: none;
	width: 300px;
	margin: 20px auto
}

#login-panel .panel-content .button-s {
	width: 80px
}

#login-panel .panel-content .button-c {
	width: 88px;
	margin-right: 0
}

#login-panel .panel-foot {
	text-align: center;
	padding: 15px;
	line-height: 2em;
	background-color: #e5e5e5;
	border-top: 1px solid #dfdfdf
}

#poweredby {
	float: none;
	color: #eee;
	text-align: center;
	margin: 10px auto
}

#poweredby a {
	color: #fff
}

#keeplogin label {
	font-weight: normal
}

.popover {
	max-width: 500px
}

.popover-content {
	padding: 0;
	width: 297px
}

.btn-submit {
	min-width: 70px;
	background-color: #9dcaed;
}
</style>

<script type="text/javascript">
    function refresh(obj) {
    	$j(obj).attr("style","background-image:url('<%=basePath%>image/randomCode?"+Math.random()+"');background-repeat: no-repeat; background-position: 150px;");
   };

</script>

</head>
<body class="m-user-login">
	<div id="container">
		<div id="login-panel">
			<div class="panel-head">
				<h4>安踏食堂管理系统</h4>
				<c:if test="${errorValue==1}">
						<h3 style="color:red">&nbsp;&nbsp;验证码校验失败！</h3>
				</c:if>
				<c:if test="${errorValue==2}">
					<tr>
						<h3 style="color:red">&nbsp;&nbsp;用户名或密码出错！</h3>
					</tr>
				</c:if>
				<c:if test="${errorValue==3}">
					<tr>
						<h3 style="color:red">&nbsp;&nbsp;帐号${errorAccount}登录出错超过5次，帐号被系统锁定10分钟！</h3>
					</tr>
				</c:if>
			</div>
			<div class="panel-content" id="login-form">
				<form method="post" action="<%=basePath%>user/login" class="form-condensed" autocomplete="off">
					<table class="table table-form">
						<tbody>
							<tr>
								<th>用名</th>
								<td><input class="form-control" name="account" id="account"
									type="text"></td>
							</tr>
							<tr>
								<th>密码</th>
								<td><input class="form-control" name="password" 
									type="password" id="password"></td>
							</tr>
							<tr>
								<th></th>
								<td><input value="" id="randomCode" class="form-control" name="randomCode"
									type="text" ondblclick="refresh(this);"
									style="background-image:url('<%=basePath%>image/randomCode');background-repeat: no-repeat; background-position: 150px;" /></td>
							</tr>
							<tr>
								<th></th>
								<td>
									<button type="submit" id="submit"
										class="btn btn-submit btn-primary">登录</button>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>


		</div>
		<div id="poweredby"></div>
	</div>
</body>
</html>