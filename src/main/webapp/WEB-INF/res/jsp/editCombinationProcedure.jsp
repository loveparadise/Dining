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
						<li class="active">编辑组合工序库</li>
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

								<input type="hidden" name="id" id="id"
									value="${produceProcedure.id}" /> <input type="hidden"
									name="selectedStr" id="selectedStr" value="${selectedStr}" />
								<input type="hidden" name="orignalName" id="orignalName"
									value="${produceProcedure.name}" /> <input type="hidden"
									name="orignalCode" id="orignalCode"
									value="${produceProcedure.code}" />

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 组合编码： </label>

									<div class="col-sm-9">
										<input type="text" id="code" name="code" placeholder="组合编码"
											onblur="existcode(this)" disabled="disabled"
											value="${produceProcedure.code}" class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										for="form-field-1"> 组合名称： </label>

									<div class="col-sm-9">
										<input type="text" id="name" name="name" placeholder="组合名称"
											onblur="exist(this)" value="${produceProcedure.name}"
											class="col-xs-10 col-sm-5" />
									</div>
								</div>

								<div class="space-4"></div>

								<div class="row">
									<div class="col-sm-6">
										<div class="widget-box">
											<div class="widget-header header-color-blue2">
												<h4 class="lighter smaller">工序库</h4>
											</div>

											<div class="widget-body">
												<div class="widget-main padding-8">
													<div id="tree1" class="tree">
														<table id="unselect" rules="rows">
															<thead>
																<tr>
																	<th>选择</th>
																	<th>工序</th>
																</tr>
															</thead>
															<tbody>

																<c:if test="${procedures ==null||empty procedures}">
																	<tr index=0>
																		<td class="noResults" headers="details" colspan="11">-资料为空-</td>
																	</tr>
																</c:if>
																<c:if test="${procedures!=null && not empty procedures}">
																	<c:forEach var="procedure" items="${procedures }">
																		<tr index="${procedure.id }">
																			<td><img alt="${procedure.name }"
																				src="<%=basePath%>res/img/add15.gif"
																				value="${procedure.id }" onclick="select(this)"></td>
																			<td>${procedure.name }</td>
																		</tr>
																	</c:forEach>
																</c:if>
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col-sm-6">
										<div class="widget-box">
											<div class="widget-header header-color-green2">
												<h4 class="lighter smaller">Browse Files</h4>
											</div>

											<div class="widget-body">
												<div class="widget-main padding-8">
													<div id="tree2" class="tree">
														<table id="select" rules="rows">
															<thead>
																<tr>
																	<th>反选</th>
																	<th>工序</th>
																</tr>
															</thead>
															<tbody>


																<c:if
																	test="${produceProcedure.sprocedures==null||empty produceProcedure.sprocedures}">
																	<tr index=0>
																		<td class="noResults" headers="details" colspan="11">-资料为空-</td>
																	</tr>
																</c:if>
																<c:if
																	test="${produceProcedure.sprocedures!=null && not empty produceProcedure.sprocedures}">
																	<c:forEach var="procedure"
																		items="${produceProcedure.sprocedures }">
																		<tr index="${procedure.id }">
																			<td>
																			<img alt="${procedure.name }"
																				src="<%=basePath%>res/img/delete15.gif"
																				value="${procedure.id }" onclick="unselect(this)"></td>
																			<td>${procedure.name }</td>
																		</tr>
																	</c:forEach>
																</c:if>
															</tbody>
														</table>
													</div>
												</div>
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
										<input type="hidden" id="hiddenId" name="selectPro" />
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


<!-- 	<script type="text/javascript">
			jQuery(function($) {
				$(".chosen-select").chosen(); 
				$('#chosen-multiple-style').on('click', function(e){
					
					var target = $(e.target).find('input[type=radio]');
					var which = parseInt(target.val());
					if(which == 2) $('#form-field-select-4').addClass('tag-input-style');
					else $('#form-field-select-4').removeClass('tag-input-style');
					
				});
				
				tohtml();
			});
		</script> -->

<script type="text/javascript">

/* function tohtml(){
	var htm = "";
	
	<c:if test="${produceProcedure.sprocedures==null||empty produceProcedure.sprocedures}">
	 	$($(".chosen-choices .search-field input")[0]).val("");
	</c:if>
	<c:if test="${produceProcedure.sprocedures!=null && not empty produceProcedure.sprocedures}">
	<c:forEach var="sp" items="${sps }">
		<c:forEach var="procedure" items="${produceProcedure.sprocedures }">
		//if("${procedure.name }"=="${sp.name }"){
			
			htm = "<li class='search-choice'><span>RB</span><a data-option-array-index='3' class='search-choice-close'></a></li>"
			+"<li class='search-field'><input value='选择工序...' class='default' autocomplete='off' style='width: 89px;' type='text'></li>";
			//$(".chosen-drop .chosen-results li:first").attr("class","result-selected");
			//$(".chosen-results").find("${procedure.name }").eq(1).trigger(jQuery.Event("click"));
			//$("active-result").trigger("click");
		//}
		//htm += "<li class='search-choice'><span>${procedure.name }</span><a data-option-array-index='3' class='search-choice-close'></a></li>";
		</c:forEach>
	</c:forEach>
	//$($(".chosen-choices")[0]).html(htm);
	</c:if>
	console.log(htm);
} */


function exist(obj) {
	trimSpace(obj);
	if (!$(obj).val()) {
		return false;
	}
	if($("#orignalName").val()==$(obj).val())
	{
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
	if($("#orignalCode").val()==$(obj).val())
	{
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
	/* function selectVal() {
		var mycount = "";
		for (i = 0; i < $(".chosen-choices .search-choice span").length; i++) {
				if ($(".chosen-choices .search-choice span")[i]!=null) {
					var count = $($(".chosen-choices .search-choice span")[i]).html();
					mycount+=count+","; 
				}
		}
		$("#hiddenId").val(mycount);
		
	} */
	
	var selectedStr=",";
	$(document).ready(function(){
		selectedStr=$("#selectedStr").val();
	});

	function select(obj) {
		var indexValue=$(obj).attr("value")
		var alt=$(obj).attr("alt");
		var unselect= $("#unselect");
		var select= $("#select");
		var deleteTr=$("#select").find("tr[index=0]");
		var trEle= $(unselect).find("tr[index='"+indexValue+"']");
		var addTr="<tr index="+indexValue+"><td><img alt="+alt+" src="+basePath+"res/img/delete15.gif value="+indexValue+" onclick='unselect(this)'></td><td>"+alt+"</td></tr>";
		$(trEle).remove();
		$(deleteTr).remove();
		$(select).append($(addTr));
		selectedStr=selectedStr+indexValue+",";
		$("#selectedStr").val(selectedStr);
	};
	
	function unselect(obj){
		var indexValue=$(obj).attr("value")
		var alt=$(obj).attr("alt");
		var unselect= $("#unselect");
		var deleteTr=$("#unselect").find("tr[index=0]");
		var select= $("#select");
		var trEle= $(select).find("tr[index='"+indexValue+"']");
		var addTr="<tr index="+indexValue+"><td><img alt="+alt+" src="+basePath+"res/img/add15.gif value="+indexValue+" onclick='select(this)'></td><td>"+alt+"</td></tr>";
		$(trEle).remove();
		$(deleteTr).remove();
		$(unselect).append($(addTr));
		selectedStr=selectedStr.replace(","+indexValue+",",",");
		$("#selectedStr").val(selectedStr);
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
					url : basePath + "procedure/updateCombinationProcedure",
					method : "post",
					data : {
						code : $("#code").val(),
						name : $("#name").val(),
						sps : $("#hiddenId").val(),
						selectedStr: selectedStr,
						id :$("#id").val()
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