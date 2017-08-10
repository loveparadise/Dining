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
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<script type="text/javascript">
	//重写Alert方法
	function Alert(str) {
		var msgw, msgh, bordercolor;
		msgw = 300;//提示窗口的宽度   
		msgh = 100;//提示窗口的高度   
		titleheight = 25 //提示窗口标题高度   
		bordercolor = "#0055e6";//提示窗口的边框颜色   
		titlecolor = "#99CCFF";//提示窗口的标题颜色   
		var sWidth, sHeight;
		//获取当前窗口尺寸   
		sWidth = document.body.offsetWidth;
		sHeight = document.body.offsetHeight;
		//背景div   
		var bgObj = document.createElement("div");
		bgObj.setAttribute('id', 'AlertbgDiv');
		bgObj.style.position = "absolute";
		bgObj.style.top = "0";
		bgObj.style.background = "white";//"#E8E8E8";   
		bgObj.style.filter = "progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
		bgObj.style.opacity = "0.6";
		bgObj.style.left = "0";
		bgObj.style.width = sWidth + "px";
		bgObj.style.height = sHeight + "px";
		bgObj.style.zIndex = "10000";
		document.body.appendChild(bgObj);
		//创建提示窗口的div   
		var msgObj = document.createElement("div")
		msgObj.setAttribute("id", "AlertmsgDiv");
		msgObj.setAttribute("align", "center");
		msgObj.style.background = "#ece9d8";
		msgObj.style.border = "1px solid " + bordercolor;
		msgObj.style.position = "absolute";
		msgObj.style.left = "50%";
		msgObj.style.font = "12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
		//窗口距离左侧和顶端的距离    
		msgObj.style.marginLeft = "-225px";
		//窗口被卷去的高+（屏幕可用工作区高/2）-150   
		msgObj.style.top = document.body.scrollTop
				+ (window.screen.availHeight / 2) - 150 + "px";
		msgObj.style.width = msgw + "px";
		msgObj.style.height = msgh + "px";
		msgObj.style.textAlign = "center";
		msgObj.style.lineHeight = "25px";
		msgObj.style.zIndex = "10001";
		document.body.appendChild(msgObj);
		//提示信息标题   
		var title = document.createElement("h4");
		title.setAttribute("id", "AlertmsgTitle");
		title.setAttribute("align", "left");
		title.style.margin = "0";
		title.style.padding = "3px";
		title.style.background = bordercolor;
		title.style.filter = "progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
		title.style.opacity = "0.75";
		title.style.border = "1px solid " + bordercolor;
		title.style.height = "18px";
		title.style.font = "12px Verdana, Geneva, Arial, Helvetica, sans-serif";
		title.style.color = "white";
		title.innerHTML = "提示信息";
		document.getElementById("AlertmsgDiv").appendChild(title);
		//提示信息   
		var txt = document.createElement("p");
		txt.setAttribute("id", "msgTxt");
		txt.style.margin = "16px 0";
		txt.innerHTML = str;
		document.getElementById("AlertmsgDiv").appendChild(txt);
		//确定button
		//	var btn = document.createElement("button");
		//	btn.value="确   定";
		//	btn.setAttribute('id','btn1');
		//	btn.onclick=function(){
		//		bgObj.style.display = "none";
		//		msgObj.style.display = "none";
		//		title.style.display = "none";
		//		
		//	}
		//	document.getElementById("AlertmsgDiv").appendChild(btn);

		//设置关闭时间   
		window.setTimeout("closewin()", 2000);
	}
	function closewin() {
		document.body.removeChild(document.getElementById("AlertbgDiv"));
		document.getElementById("AlertmsgDiv").removeChild(
				document.getElementById("AlertmsgTitle"));
		document.body.removeChild(document.getElementById("AlertmsgDiv"));
	}

	function synMaterialOrder() {
		showBg();
		$j.ajax({
			url : basePath + "order/synMaterialOrders",
			method : "get",
			dataType : "json",
			success : function(data) {

				$j.each(data, function(id, item) {
					if (item == "success") {
						loadingHide();

						Alert("同步成功。。。");
						location.reload();
					} else if (item == "empty") {
						loadingHide();
						Alert("没有需要同步的订单！");
					} else {
						loadingHide();
						Alert("操作失败。。。");
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {

				loadingHide();
				Alert("操作失败。。。");
			}
		});
	}

	function showBg() {
		var bh = $j("html").height();
		var bw = $j("html").width();
		$j("#fullbg").css({
			height : bh,
			width : bw,
			display : "block"
		});
		$j("#main-menu li ul").removeClass("sub");
		$j("#dialog").show();
	}

	function loadingHide() {
		$j("#fullbg,#dialog").hide();
		$j("#main-menu li ul").addClass("sub");
	}

	function trimSpace(obj)
	{
		$j(obj).val($j.trim($j(obj).val()));
	}
	
	function showMask(){
		$("#body").css("overflow","hidden");
		$("#cover").show();
	}
	
	//function hidden()
	//{document.html.style.overflow='hidden';}
</script>

<style type="text/css">
#fullbg {
	background-color: gray;
	left: 0;
	opacity: 0.5;
	position: absolute;
	top: 0;
	z-index: 3;
	filter: alpha(opacity =       50);
	-moz-opacity: 0.5;
	-khtml-opacity: 0.5;
}

#dialog {
	background-color: #fff;
	border: 5px solid rgba(0, 0, 0, 0.4);
	height: 200px;
	left: 50%;
	margin: -200px 0 0 -200px;
	padding: 1px;
	position: fixed !important; /* 浮动对话框 */
	position: absolute;
	top: 50%;
	width: 400px;
	z-index: 5;
	border-radius: 5px;
	display: none;
}

.cover {
position:fixed; top: 0px; right:0px; bottom:0px;filter: alpha(opacity=60); background-color: #777;
z-index: 1002; left: 0px; display:none;
opacity:0.5; -moz-opacity:0.5;
}
</style>
</head>
<body>
	<div id="fullbg"></div>
	<div id="dialog">
		<div style="text-align:center;">
			正在同步，请稍后.... <br /> <img alt="加载中。。。"
				src="<%=basePath%>res/img/loading.gif">
		</div>
	</div>
	<div>
		<div class="containerCentered">

			<a href="<%=basePath%>" class="at-img-logo">鞋商品</a>

			<nav id="main-menu">
				<ul id="nav">
					<li class="top"><a href="#">我的订单</a>
						<ul class="sub">
							<c:choose>
								<c:when test="${curUser!=null && not empty curUser}">
									<li><a href="<%=basePath%>order/myOrders" class="sub">订单列表</a></li>
									<li><a href="<%=basePath%>order/listOrderDetail"
										class="sub">订单明细列表</a></li>
									<li><a href="<%=basePath%>order/editOrderDetails"
										class="sub">维护订单明细</a></li>
									<li><a href="javascript:synMaterialOrder()" class="sub">订单同步</a></li>
								</c:when>
							</c:choose>
						</ul></li>

					<%-- 					<li class="top"><a href="#">我的信息</a>
						<ul class="sub">
							<c:choose>
								<c:when test="${curUser!=null && not empty curUser}">
									<li><a href="<%=basePath%>user/myInfo" class="sub">个人信息</a></li>
								</c:when>
							</c:choose>
						</ul></li> --%>
					<c:choose>
						<c:when test="${curUser.isAdmin}">
							<li class="top"><a href="#">基础信息库</a>
								<ul class="sub">
									<c:choose>
										<c:when test="${curUser!=null && not empty curUser}">
											<li><a href="<%=basePath%>procedure/addProcedure"
												class="sub">添加工序库</a></li>
											<li><a href="<%=basePath%>procedure/listProcedure"
												class="sub">维护工序库</a></li>
											<li><a
												href="<%=basePath%>procedure/addCombinationProcedure"
												class="sub">添加组合工序库</a></li>
											<li><a
												href="<%=basePath%>procedure/listCombinationProcedure"
												class="sub">维护组合工序库</a></li>
										</c:when>
									</c:choose>
								</ul></li>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${curUser.isAdmin }">
							<li class="top"><a href="#">用户管理</a>
								<ul class="sub">
									<li><a href="<%=basePath%>user/addUser" class="sub">添加用户</a></li>
									<li><a href="<%=basePath%>user/permission" class="sub">权限管理</a></li>
								</ul></li>
						</c:when>
					</c:choose>
				</ul>

			</nav>

			<div id="login-header" class="form-inline open">
				<c:if test="${curUser!=null&&!curUser.isAdmin}">
					<div class="input-wrapper small" style="width:200px">
						歡迎您，<a href="<%=basePath%>user/myInfo" target="_blank"><c:out
								value="${curUser.name }"></c:out></a>
					</div>
					<div class="input-wrapper small" style="width:320px">
						<a href="<%=basePath%>user/logout">退出</a>&nbsp;材料订单同步时间：
						<c:out value="${curUser.synMaterialDate }"></c:out>&nbsp;打印订单同步时间：
						<c:out value="${curUser.synPrintDate }"></c:out>						
				</c:if>

				<c:if test="${curUser!=null&&curUser.isAdmin}">
					<div class="input-wrapper small" style="width:120px">
						管理员，<a href="<%=basePath%>user/myInfo" target="_blank"><c:out
								value="${curUser.name }"></c:out></a>
					</div>
					<div class="input-wrapper small" style="width:320px">
						<a href="<%=basePath%>user/logout">退出</a>&nbsp;材料订单同步时间：
						<c:out value="${curUser.synMaterialDate }"></c:out>&nbsp;打印订单同步时间：
						<c:out value="${curUser.synPrintDate }"></c:out>
					</div>
				</c:if>
			</div>

		</div>
	</div>
</body>
</html>