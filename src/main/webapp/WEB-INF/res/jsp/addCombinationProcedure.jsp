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
<link rel="stylesheet" href="<%=basePath%>assets/css/chosen.css" />
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
						<li class="active">添加组合工序库</li>
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
							<form class="form-horizontal" role="form"
								id="comform" method="post">
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 组合编码： </label>

									<div class="col-sm-9">
										<input type="text" id="code" name="code" placeholder="组合编码"
											onblur="existcode(this)" onmouseout="exist(this);"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 组合名称： </label>

									<div class="col-sm-9">
										<input type="text" id="name" name="name" placeholder="组合名称"
											onblur="exist(this)" onmouseout="exist(this);"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>


								<div class="widget-box">
									<div class="widget-header">
										<h4>工序选择器</h4>

									</div>

									<div class="widget-body">
										<div class="widget-main">
											<div>
												<div class="row">
													<div class="col-sm-6">
														<span class="bigger-110">选择工序</span>
													</div>

													<div class="col-sm-6">
														<span class="pull-right inline"> <span class="grey">style:</span>

															<span class="btn-toolbar inline middle no-margin">
																<span id="chosen-multiple-style" data-toggle="buttons"
																class="btn-group no-margin"> <label
																	class="btn btn-xs btn-yellow active"> 1 <input
																		type="radio" value="1" />
																</label> <label class="btn btn-xs btn-yellow"> 2 <input
																		type="radio" value="2" />
																</label>
															</span>
														</span>
														</span>
													</div>
												</div>

												<div class="space-2"></div>

												<select multiple="" class="width-80 chosen-select"
													name="sprocedure.id" 
													id="form-field-select-4" data-placeholder="选择工序..."
													onchange="selectVal()">

												<c:forEach items="${sProcedures }" var="sprocedure">
													<option value="${sprocedure.id }" >${sprocedure.name }</option>
												</c:forEach>
												</select>
											</div>
										</div>
									</div>
								</div>

								<div class="space-4"></div>
								

								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="button" onclick="check()">
											<i class="icon-ok bigger-110"></i> 创建
										</button>

										&nbsp; &nbsp; &nbsp;
										<button class="btn" type="reset">
											<i class="icon-undo bigger-110"></i> 重置
										</button>
										<input type="hidden" id="hiddenId" name="selectPro"/>
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

	<!-- basic scripts -->
		<!-- page specific plugin scripts -->

		<script src="<%=basePath%>assets/js/chosen.jquery.min.js"></script>

		<!-- inline scripts related to this page -->
		
		
		<script type="text/javascript">
			jQuery(function($) {
				$(".chosen-select").chosen(); 
				$('#chosen-multiple-style').on('click', function(e){
					
					$('#form-field-select-4').addClass('tag-input-style');
					
				});
			
			});
		</script>
	
<script type="text/javascript">
function exist(obj) {
	trimSpace(obj);
	if (!$(obj).val()) {
		return false;
	}
	$.ajax({
		url : basePath + "procedure/isExistCombinationProcedure",
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
							"该组合名称已经存在！");
					$(obj).val("");
					$(obj).focus();
				}
			});
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alertMsg($("#alertMsg"),
					"alert alert-warning alert-dismissable", "警告",
					"请重新输入，该组合名称已经存在");
			$(obj).val("");
			$(obj).focus();
		}
	});
}

function existcode(obj) {
	trimSpace(obj);
	if (!$(obj).val()) {
		return false;
	}
	$.ajax({
		url : basePath + "procedure/isExistCode",
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
							"该组合编码已经存在！");
					$(obj).val("");
					$(obj).focus();
				}
			});
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alertMsg($("#alertMsg"),
					"alert alert-warning alert-dismissable", "警告",
					"请重新输入，该组合编码已经存在");
			$(obj).val("");
			$(obj).focus();
		}
	});
}
</script>

	<script type="text/javascript">
	function selectVal() {
		var mycount = ",";
		for (i = 0; i < $(".chosen-choices .search-choice span").length; i++) {
				if ($(".chosen-choices .search-choice span")[i]!=null) {
					var count = $($(".chosen-choices .search-choice span")[i]).html();
					mycount+=count+","; 
				}
		}
		$("#hiddenId").val(mycount);
		
	}

		function check() {
			if (checkNull($("#name").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告",
						"请输入组合名称！");
				return false;
			}
			if (checkNull($("#code").val())) {
				alertMsg($("#alertMsg"),
						"alert alert-warning alert-dismissable", "警告", "请输入编码！");
				return false;
			}

			else {
				$.ajax({
					url : basePath + "procedure/saveNewCombinationProcedure",
					method : "post",
					data : {
						code : $("#code").val(),
						name : $("#name").val(),
						sps : $("#hiddenId").val(),

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
								$("#hiddenId").val("");
								$("#code").focus();
							} else {
								alertMsg($("#alertMsg"),
										"alert alert-warning alert-dismissable", "警告",
										"保存失败！请重新输入。");
								$("#code").val("");
								$("#name").val("");
								$("#hiddenId").val("");
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
						$("#hiddenId").val("");
						$("#code").focus();
					}
				});
			}
			//$("#comform").submit();
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