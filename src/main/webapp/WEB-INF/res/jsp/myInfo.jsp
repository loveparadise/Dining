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
	<jsp:include page="pageHead.jsp"></jsp:include>

	<div class="main-container" id="main-container">
		<div class="main-container-inner">
			<a class="menu-toggler" id="menu-toggler" href="#"> <span
				class="menu-text"></span>
			</a>

			<jsp:include page="nav.jsp"></jsp:include>

			<div class="main-content">
				<div class="breadcrumbs" id="breadcrumbs"">
					<ul class="breadcrumb">
						<li><i class="icon-home home-icon"></i> <a href="#">首页</a></li>
						<li class="active">个人密码、邮箱修改</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger hidden" role="alert">
							<strong>提示标题：</strong>具体提示信息
						</div>
						<div class="col-xs-12">
							<!-- PAGE CONTENT BEGINS -->
							<form class="form-horizontal" role="form">
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 登录帐号： </label>

									<div class="col-sm-9">
										<input type="text" id="accountId" name="accountId" 
										    placeholder="帐号" value="${user.account }"
											disabled="disabled"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>
								
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 姓名： </label>

									<div class="col-sm-9">
										<input type="text" id="name" name="name" 
										    placeholder="帐号" value="${user.name }"
											disabled="disabled"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-2"> 新密码： </label>

									<div class="col-sm-9">
										<input type="password" id="password"
											autocomplete="off"
											name="password" value="" maxlength="20"
											class="col-xs-10 col-sm-5"/>
									</div>
								</div>
								
								<div class="space-4"></div>
								
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-2"> 重新输入新密码： </label>

									<div class="col-sm-9">
										<input type="password" id="retype_password"
											autocomplete="off"
											name="retype_password" value="" maxlength="20"
											class="col-xs-10 col-sm-5"/>
									</div>
								</div>
								
								<div class="space-4"></div>
								
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 邮箱地址： </label>

									<div class="col-sm-9">
										<input type="text" id="mail" name="mail" placeholder="邮箱地址："
											value="${user.mail }"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="button" onclick="check()">
											<i class="icon-ok bigger-110"></i> 修改
										</button>

										&nbsp; &nbsp; &nbsp;
										<button class="btn" type="reset">
											<i class="icon-undo bigger-110"></i> 重置
										</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>

				<!-- PAGE CONTENT ENDS -->
			</div>
			<!-- /.col -->
		</div>
		<!-- /.row -->
	</div>
	<!-- /.page-content -->

	</div>
	<!-- /.main-container -->

	<!-- inline scripts related to this page -->

	<script type="text/javascript">
	jQuery(function($) {
		var authority='${curUser.authority}';
		if(authority=="null")
			alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","帐号对应的密码已过期，请更新密码！更新密码后，重新刷新页面后，才可正常使用系统！");
	});
		
	function checkEmail(str) {
		var myreg = /^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/;
		if (!myreg.test(str)) {
			return false;
		} else {
			return true;
		}
	}

	function check() {
		if (checkNull($("#mail").val())) {
			alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请输入邮箱地址!");
			
			return false;
		} else {
			if (!checkEmail($("#mail").val())) {
				alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","邮箱格式不正确!");
				return false;
			}
		}
		
		if (checkNull($("#password").val())) {
			alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请输入密码!");
			return false;
		}
		
		if (checkNull($("#password").val())||checkPass($("#password").val())<3) {
			alertMsg($("#alertMsg"),
					"alert alert-warning alert-dismissable", "警告",
					"请输入密码！同时密码要求至少8位，包含字母、数字、特殊符号！");
			return false;
		}
		
		if (checkNull($("#retype_password").val())) {
			alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请输入确认密码!");
			return false;
		}

		if ($("#password").val() != $("#retype_password").val()) {
			alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","两次输入密码不匹配！");
			return false;
		}else{
			$.ajax({
				url : basePath + "user/updateUser",
				method : "post",
				data : {
					mail : $("#mail").val(),
					password : $("#password").val(),

				},
				dataType : "json",
				success : function(data) {
					$.each(data, function(id, item) {
						if (item == "suc") {
							alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","保存成功！请按<font color='red'>‘Ctrl+F5’刷新页面！</font>");
							$("#mail").val("");
							$("#retype_password").val("");
							$("#mail").focus();
						} else {
							alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","保存失败！请重新输入，请确保新旧密码不一样。");
							$("#mail").val("");
							$("#retype_password").val("");
							$("#mail").focus();
						}
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","服务器出错，保存失败！请重新输入。");
					$("#mail").val("");
					$("#retype_password").val("");
					$("#mail").focus();
				}
			});
		}
	}
	
	function checkPass(pass){
		  if(pass.length < 8){
		           return 0;
		 }
		 var ls = 0;
		 if(pass.match(/([a-z])+/)||pass.match(/([A-Z])+/)){
		     ls++;
		  }
		 if(pass.match(/([0-9])+/)){
		       ls++; 
		 }
//		 if(pass.match(/([A-Z])+/)){
//		        ls++;
//		  }
		  if(pass.match(/[^a-zA-Z0-9]+/)){
		        ls++;
		  }
		  return ls;
	}

	function checkNull(obj) {
		if (!obj) {
			return true;
		} else {
			return false;
		}
	}
	</script>
</body>
</html>