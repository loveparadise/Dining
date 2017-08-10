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
						<li class="active">添加工序库</li>
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
										for="form-field-1"> 工序名称： </label>

									<div class="col-sm-9">
										<input type="text" id="name" name="name" placeholder="工序名称："
											onblur="exist(this);" 
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="button" onclick="check()">
											<i class="icon-ok bigger-110"></i> 添加工序
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
					url : basePath + "procedure/isExistProcedure",
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
								alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","该工序名称已经存在！");
								$(obj).val("");
								$(obj).focus();
								
							}
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请重新输入，该工序名称已经存在");
						$(obj).val("");
						$(obj).focus();
					}
				});
			}
			
			function check() {
				if (checkNull($("#name").val())) {
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请输入工序名称！");
					return false;
				} else {
					$.ajax({
						url : basePath + "procedure/saveNewProcedure",
						method : "post",
						data : {
							val : $("#name").val()
						},
						dataType : "json",
						success : function(data) {
							$.each(data, function(id, item) {
								if (item == "suc") {
									alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","保存成功！");
									$("#name").val("");
									$("#name").focus();
								} else {
									alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","保存失败！请重新输入。");
									$("#name").val("");
									$("#name").focus();
								}
							});
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","服务器出错，保存失败！请重新输入。");
							$("#name").val("");
							$("#name").focus();
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