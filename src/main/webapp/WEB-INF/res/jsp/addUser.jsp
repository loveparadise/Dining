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
<link rel="stylesheet" href="<%=basePath%>assets/css/chosen.css" />
<script src="<%=basePath%>assets/js/chosen.jquery.min.js"></script>
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
						<li class="active">添加用户</li>
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
											for="form-field-1"> 帐号类型： </label>
	
									<div class="col-sm-9">
										<select name="accountType" id="accountType" onchange="selected(this);">
											<option value="provider" selected="selected">供应商</option>
											<option value="employee">安踏员工</option>
											<option value="admin">管理员</option>
										</select>
									</div>
								</div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 登录帐号： </label>

									<div class="col-sm-9">
										<input type="text" id="account" name="account"
											placeholder="帐号" onblur="exist(this)"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 姓名： </label>

									<div class="col-sm-9">
										<input type="text" id="name" name="name" placeholder="姓名"
											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group" id="pwd">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-2"> 密码： </label>

									<div class="col-sm-9">
										<input autocomplete="off" type="password" id="password"
											name="password" maxlength="20" onblur="trimSpace(this);"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group" id="conformpwd">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-2"> 重新输入密码： </label>

									<div class="col-sm-9">
										<input autocomplete="off" type="password" id="retype_password"
											name="retype_password" value="" maxlength="20"
											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 邮箱地址： </label>

									<div class="col-sm-9">
										<input type="text" id="mail" name="mail" autocomplete="off"
											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" />
									</div>
								</div>
								
<!-- 								<div class="form-group"> -->
<!-- 									<label class="col-sm-3 control-label no-padding-right" -->
<!-- 										for="form-field-1"> 权限串： </label> -->

<!-- 									<div class="col-sm-9"> -->
<!-- 										<input type="text" id="authority" name="authority" autocomplete="off" -->
<!-- 											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" /> -->
<!-- 									</div> -->
<!-- 								</div> -->
								
								<div class="form-group" id="centerGroup" style="display: none">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 中心： </label>

									<div class="col-sm-9">
										<input type="text" id="center" name="center" autocomplete="off"
											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" />
									</div>
								</div>
								
								<div class="form-group" id="departmentGroup" style="display: none">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 部门： </label>

									<div class="col-sm-9">
										<input type="text" id="department" name="department" autocomplete="off"
											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" />
									</div>
								</div>	
								
								<div class="form-group" id="sapAccountGroup" style="display: none">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> SAP帐号： </label>

									<div class="col-sm-9">
										<input type="text" id="sapAccount" name="sapAccount" autocomplete="off"
											onblur="trimSpace(this);" class="col-xs-10 col-sm-5" />
									</div>
								</div>															

								<div class="space-4"></div>	
								<div class="widget-box" id="providerUser">
									<div class="widget-header">
										<h4>关联供应商</h4>
									</div>

									<div class="widget-body">
										<div class="widget-main">
											<div>
												<label for="form-field-select-1">供应商</label> 
												<select name="providerUsercode" 
														class="chosen-select" id="providerUsers" style="width:300px;">
													<c:forEach items="${providerUsers }" var="providerUser">
														<option value="${providerUser.code }">${providerUser.name }</option>
													</c:forEach>
												</select> 
											</div>
										</div>
									</div>
								</div><!--widget-box  -->
								
								<div class="widget-box" id="brandCode" >
									<div class="widget-header">
										<h4>品牌选择</h4>
									</div>

									<div class="widget-body">
										<div class="widget-main">
											<div>
												<label for="brand">品牌</label> 
												
												<select name="brand" 
													class="form-control" id="brand">											
												<option value="ZP01" selected="selected">大货</option>
												<option value="ZP02">FILA-大货</option>
												<option value="ZP08">海外</option>
												<option value="ZP05">赞助</option>
												<option value="ZP06">运动生活</option>
												<option value="ZP03">儿童</option>
												<option value="ZP09">店铺形象物品</option>
												<option value="ZP10">鞋材辅材</option>
												<option value="ZP12">广宣用品</option>
												<option value="ZP11">电商</option>
												<option value="ZP13">NBA大货</option>
												<option value="ZP15">NBA儿童</option>
												<option value="ZP21">原材料</option>
												<option value="ZP22">半成品</option>
												<option value="ZP23">易耗品</option>
												<option value="ZP24">模具</option>
												<option value="ZP25">虚拟物料</option>
												<option value="ZP32">FILA-广宣用品</option>
												<option value="ZP33">FILA-儿童</option>
												<option value="ZP35">FILA-赞助</option>
												<option value="-99">全部</option>
												</select> 
												
											</div>
										</div>
									</div>
								</div><!--widget-box  -->
								
								<div class="widget-box" id="typeCode">
									<div class="widget-header">
										<h4>种类选择</h4>
									</div>

									<div class="widget-body">
										<div class="widget-main">
											<div>
												<label for="type">种类</label> 
												
												<select name="type" 
													class="form-control" id="type">
													<option value="00">通用</option>
													<option value="10" selected="selected">鞋类</option>
													<option value="20">服装</option>
													<option value="30">配件</option>
													<option value="50">广宣用品</option>
													<option value="70">服材</option>
													<option value="80">鞋材</option>
													<option value="90">其它</option>
													<option value="-99">全部</option>
												</select> 
												
											</div>
										</div>
									</div>
								</div><!--widget-box  -->								

								<div class="space-4"></div>

								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="button" onclick="check()">
											<i class="icon-ok bigger-110"></i> 创建账户
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
	function exist(obj) {
		trimSpace(obj);
		if (!$(obj).val()) {
			return false;
		}
		$.ajax({
			url : basePath + "user/isExist",
			method : "post",
			data : {
				field : $(obj).attr("name"),
				val : $(obj).val()
			},
			dataType : "json",
			success : function(data) {
				$.each(data, function(id, item) {
					if (item != "exist") {

					} else {
						alertMsg($("#alertMsg"),
								"alert alert-warning alert-dismissable", "警告",
								"该登录帐号已经存在！");
						$(obj).val("");
						$(obj).focus();
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请重新输入，该登录帐号已经存在");
				$(obj).val("");
				$(obj).focus();
			}
		});
	}
	
	jQuery(function($) {
		jQuery(".chosen-select").chosen();
	});
	
	</script>
	
	<script type="text/javascript">
		function checkEmail(str) {
			var myreg = /^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/;
			if (!myreg.test(str)) {
				return false;
			} else {
				return true;
			}
		}

		function check() {
			if (checkNull($("#account").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入登录帐号！");
				return false;
			}
			if (checkNull($("#name").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入姓名！");
				return false;
			}
			if (checkNull($("#mail").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入邮箱！");
				return false;
			} else {
				if (!checkEmail($("#mail").val())) {
					alertMsg($("#alertMsg"),
							"alert alert-warning alert-dismissable", "警告",
							"邮箱格式不正确！");
					return false;
				}
			}
			
// 			if (checkNull($("#authority").val())&&$("#accountType").val()=="employee") {
// 				alertMsg($("#alertMsg"),
// 						"alert alert-warning alert-dismissable", "警告",
// 						"请输入权限串！");
// 				return false;
// 			} 
			
// 			if (checkNull($("#sapAccount").val())&&$("#accountType").val()=="employee") {
// 				alertMsg($("#alertMsg"),
// 						"alert alert-warning alert-dismissable", "警告",
// 						"请输入SAP帐号！");
// 				return false;
// 			} 			

			if ((checkNull($("#password").val())||checkPass($("#password").val())<3)&&$("#accountType").val()!="employee") {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入密码！同时密码要求至少8位，包含字母、数字、特殊符号！");
				return false;
			}
			if (checkNull($("#retype_password").val())&&$("#accountType").val()!="employee") {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入确认密码！");
				return false;
			}

			if ($("#password").val() != $("#retype_password").val()) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"两次输入密码不匹配！");
				return false;
			}
// 			if ($("#isAdmin").is(':checked') == true && $("#isProvider").is(':checked') == true) {  
// 				alertMsg($("#alertMsg"),
// 						"alert alert-warning alert-dismissable", "警告",
// 						"管理员和供应商不能同时选择！");
// 				return false;
// 			} 
// 			if ($("#isAdmin").is(':checked') == false && $("#isProvider").is(':checked') == false) {
// 				alertMsg($("#alertMsg"),
// 						"alert alert-warning alert-dismissable", "警告",
// 						"请选择管理员或者供应商！");
// 				return false;
// 			} 
			else {
				$.ajax({
					url : basePath + "user/regist",
					method : "post",
					data : {
						account : $("#account").val(),
						name : $("#name").val(),
						mail : $("#mail").val(),
// 						isProvider : $("#isProvider").val(),
						password : $("#password").val(),
						isAdmin : $("#isAdmin").val(),
						providercode:$("#providerUsers").val(),
						accountType:$("#accountType").val(),
						center:$("#center").val(),
						department:$("#department").val(),
						typeCode:$("#type").val(),
						brandCode:$("#brand").val(),
// 						authority:$("#authority").val(),
						sapAccount:$("#sapAccount").val()
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if (item == "suc") {
								alertMsg($("#alertMsg"),
										"alert alert-success alert-dismissable", "成功",
										"保存成功！");
								$("#account").val("");
								$("#name").val("");
								$("#mail").val("");
// 								$("#isProvider").val("");
								$("#password").val("");
								$("#isAdmin").val("");
								$("#retype_password").val("");
								$("#account").focus();
// 								$("#authority").val("");
								$("#sapAccount").val("");
// 								$("#brand").val("");
// 								$("#type").val("");
							} else {
								alertMsg($("#alertMsg"),
										"alert alert-danger alert-dismissable", "错误",
										"保存失败！请重新输入。");
								$("#account").val("");
								$("#name").val("");
								$("#mail").val("");
// 								$("#isProvider").val("");
								$("#password").val("");
								$("#isAdmin").val("");
								$("#retype_password").val("");
								$("#account").focus();
// 								$("#authority").val("");
								$("#sapAccount").val("");
// 								$("#brand").val("");
// 								$("#type").val("");
							}
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),
								"alert alert-warning alert-dismissable", "警告",
								"服务器出错，保存失败！请重新输入。");
						$("#account").val("");
						$("#name").val("");
						$("#mail").val("");
// 						$("#isProvider").val("");
						$("#password").val("");
						$("#isAdmin").val("");
						$("#retype_password").val("");
						$("#account").focus();
// 						$("#authority").val("");
						$("#sapAccount").val("");
// 						$("#brand").val("");
// 						$("#type").val("");
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
// 			 if(pass.match(/([A-Z])+/)){
// 			        ls++;
// 			  }
			  if(pass.match(/[^a-zA-Z0-9]+/)){
			        ls++;
			  }
			  return ls
		}

		function checkNull(obj) {
			if (!obj) {
				return true;
			} else {
				return false;
			}
		}
		
		function selectedadmin(obj) {
			if ($(obj).is(':checked') == true) {
				$(obj).val(true);
			} else {
				$(obj).val(false);
			}
		}

		function selected(obj) {
			if ($(obj).val()=="provider") {
				document.getElementById("providerUser").style.display="";
				document.getElementById("centerGroup").style.display="none";
				document.getElementById("departmentGroup").style.display="none";
				document.getElementById("sapAccountGroup").style.display="none";
				document.getElementById("typeCode").style.display="";
				document.getElementById("brandCode").style.display="";
			} else {
				document.getElementById("providerUser").style.display="none";
			}
			
			if ($(obj).val()=="employee") {
				document.getElementById("centerGroup").style.display="";
				document.getElementById("departmentGroup").style.display="";
				document.getElementById("sapAccountGroup").style.display="";
				document.getElementById("typeCode").style.display="";
				document.getElementById("brandCode").style.display="";
				document.getElementById("pwd").style.display="none";
				document.getElementById("conformpwd").style.display="none";
			}else
			{
				document.getElementById("pwd").style.display="";
				document.getElementById("conformpwd").style.display="";
				document.getElementById("centerGroup").style.display="none";
				document.getElementById("departmentGroup").style.display="none";
				document.getElementById("sapAccountGroup").style.display="none";
				if($(obj).val()=="admin")
				{
					document.getElementById("typeCode").style.display="none";
					document.getElementById("brandCode").style.display="none";
				}
			}
		}
		
	</script>
</body>
</html>