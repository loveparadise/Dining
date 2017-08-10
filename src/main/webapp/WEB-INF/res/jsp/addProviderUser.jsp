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
						<li class="active">添加供应商</li>
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
										for="form-field-1"> 供应商编号： </label>

									<div class="col-sm-9">
										<input type="text" id="code" name="code"
											placeholder="编号与SAP一致，前面有0不要去除要保留,如：0000100163" onblur="exist(this)"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 供应商名： </label>

									<div class="col-sm-9">
										<input type="text" id="name" name="name" placeholder="供应商名"
											onblur="existPname(this)" class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 邮箱地址： </label>

									<div class="col-sm-9">
										<input type="text" id="mail" name="mail" autocomplete="off" class="col-xs-10 col-sm-5" />
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
																
								<div class="widget-box" id="type">
									<div class="widget-header">
										<h4>种类选择</h4>
									</div>

									<div class="widget-body">
										<div class="widget-main">
											<div>
												<label for="typeCode">种类</label> 
												
												<select name="typeCode" 
													class="form-control" id="typeCode">
													<option value="00">通用</option>
													<option value="10" selected="selected">鞋类</option>
													<option value="20">服装</option>
													<option value="30">配件</option>
													<option value="50">广宣用品</option>
													<option value="70">服材</option>
													<option value="80">鞋材</option>
													<option value="90">其它</option>
												</select> 
												
											</div>
										</div>
									</div>
								</div><!--widget-box  -->	
							   <div class="space-4"></div>	
							   <div class="widget-box" id="brand" >
									<div class="widget-header">
										<h4>品牌选择</h4>
									</div>

									<div class="widget-body">
										<div class="widget-main">
											<div>
												<label for="brandCode">品牌</label> 
												
												<select name="brandCode" 
													class="form-control" id="brandCode">											
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

								<div class="space-4"></div>

								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="button" onclick="check()">
											<i class="icon-ok bigger-110"></i> 创建供应商
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
			url : basePath + "provideruser/isExist",
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
								"该供应商号已经存在！");
						$(obj).val("");
						$(obj).focus();
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请重新输入，该供应商号已经存在");
				$(obj).val("");
				$(obj).focus();
			}
		});
	}
	
	function checkEmail(str) {
		var myreg = /^([\.a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/;
		if (!myreg.test(str)) {
			return false;
		} else {
			return true;
		}
	}
	
	function existPname(obj) {
		trimSpace(obj);
		if (!$(obj).val()) {
			return false;
		}
		$.ajax({
			url : basePath + "provideruser/isExistPname",
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
								"该供应商名已经存在！");
						$(obj).val("");
						$(obj).focus();
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请重新输入，该供应商名已经存在");
				$(obj).val("");
				$(obj).focus();
			}
		});
	}
</script>

	<script type="text/javascript">
		function check() {
			if (checkNull($("#code").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入供应商号！");
				return false;
			}
			if (checkNull($("#name").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入供应商名！");
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
			if (checkNull($("#authority").val())&&$("#accountType").val()=="employee") {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入权限串！");
				return false;
			}
			else {
				$.ajax({
					url : basePath + "provideruser/addProvider",
					method : "post",
					data : {
						code : $("#code").val(),
						name : $("#name").val(),
						mail:$("#mail").val(),
						brandCode:$("#brandCode").val(),
						typeCode:$("#typeCode").val()
// 						authority:$("#authority").val()
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if (item == "suc") {
								alertMsg($("#alertMsg"),
										"alert alert-warning alert-dismissable", "警告",
										"保存成功！");
								$("#code").val("");
								$("#name").val("");
								$("#mail").val("");
								$("#authority").val("");
								$("#code").focus();
							} else {
								alertMsg($("#alertMsg"),
										"alert alert-warning alert-dismissable", "警告",
										"保存失败！请重新输入。");
								$("#code").val("");
								$("#name").val("");
								$("#mail").val("");
								$("#authority").val("");
								$("#code").focus();
							}
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),
								"alert alert-warning alert-dismissable", "警告",
								"服务器出错，保存失败！请重新输入。");
						$("#code").val("");
						$("#name").val("");
						$("#code").focus();
					}
				});
			}

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