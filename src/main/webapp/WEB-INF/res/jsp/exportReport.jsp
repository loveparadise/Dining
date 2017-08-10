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
<script src="<%=basePath%>assets/js/date-time/bootstrap-datepicker.min.js"></script>
</head>

<body>
	<jsp:include page="pageHead.jsp"></jsp:include>
	<audio controls="controls" id="error_player" hidden="hidden">
		<source src="<%=basePath%>file/Error.wav" >
	</audio>
	<audio controls="controls" id="success_player" hidden="hidden">
		<source src="<%=basePath%>file/Success.wav" >
	</audio>
	<div class="main-container" id="main-container">
		<div class="main-container-inner">
			<a class="menu-toggler" id="menu-toggler" href="#"> <span
				class="menu-text"></span>
			</a>

			<jsp:include page="nav.jsp"></jsp:include>

			<div class="main-content">
				<div class="breadcrumbs" id="breadcrumbs">
					<ul class="breadcrumb">
						<li><i class="icon-home home-icon"></i> <a
							href="<%=basePath%>common/index">首页</a></li>
						<li class="active">报表导出</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger hidden" role="alert">
							<strong>提示标题：</strong>具体提示信息
						</div>
						<div class="alert alert-info" id="requirement"
							style="margin-bottom: 0px;">
							<label for="form-field-select-3">报表类型选择:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="箱规选择" id="reportType" onchange="switchDiv()">
								<option value="dayReport">每日装箱明细</option>
								<option value="detailReport">装箱清单</option>
								<option value="summayReport">装箱汇总</option>
							</select>&nbsp;&nbsp;&nbsp;
							<button class="btn btn-sm btn-info" onclick="exportReport();" id="export">
									导出报表<i class="icon-print  align-top bigger-125 icon-on-right"></i>
							</button>

						</div>
						<br />
						<div id="conditionDiv" role="alert">
							<div class="form-group">
								<label class="col-sm-1 control-label no-padding-right"
									for="reprot">订单号：</label> <input type="text" id="ebeln"
									placeholder="请录入订单号"
									class="col-xs-2 col-sm-2"/> &nbsp;&nbsp;
								<label class="col-sm-1 control-label no-padding-right"
									for="report">款号：</label> <input type="text" id="productCode" placeholder="请录入款号"
								class="col-xs-2 col-sm-2"/> &nbsp;&nbsp;
								<label class="col-sm-1 control-label no-padding-right"
									for="WEBAZ">装箱日期:</label>
								<input id="WEBAZ" type="text" data-date-format="yyyy-mm-dd" class="col-xs-2 col-sm-2"
									placeholder="请录入日期：yyyy-mm-dd"/>
								<br/>
							</div>
						</div>
						<!-- /.col -->
					</div>
					<div id="cover" class="cover"></div>
					<!-- /.row -->
				</div>
				<!-- 模态框（Modal） -->
				<div class="modal fade" id="confirmModal" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel">确认</h4>
							</div>
							<div class="modal-body" id="messageTip">
								？</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">关闭</button>
								<button type="button" class="btn btn-primary" id="create"
									onclick="scrapBarcodes();">确认操作</button>
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal -->

				</div>
				<!-- /.page-content -->
			</div>
			<!-- /.main-container -->
		</div>
	</div>
	<script type="text/javascript">
		
		function switchDiv()
		{
			if($("#reportType").val()=="dayReport")
			{
				$("#WEBAZ").attr("disabled",false);
				$("#choosedate").html('装箱日期：');
			}else
			{
				$("#WEBAZ").attr("disabled",true);
				$("#choosedate").html('交货日期：');
			}
		}
		
		function exportReport() {
			if($("#reportType").val()=="dayReport"){
				if($.trim($("#WEBAZ").val())==""){
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请输入日期！！！");
					return;
				}
			}else{
				if(($.trim($("#ebeln").val())=="") && ($.trim($("#productCode").val())=="")){
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请输入订单号或者款号！！！");
					return;
				}
			}
			var fileName = Date.parse(new Date());
			$.ajax({
				url : basePath + "print/exportReport",
				method : "post",
				data : {
					ebeln : $("#ebeln").val(),
					productCode:$("#productCode").val(),
					WEBAZ:$("#WEBAZ").val(),
					fileName:fileName,
					reportType:$("#reportType").val()
				},
				dataType : "json",
				success : function(data) {
					$.each(data, function(id, item) {
						if(id=="message")
						{
							if (item == "success") {
								alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","生成报表成功！！！");
							} else if (item == "error") {
								alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","生成报表失败！！！");
							}
						}else if(id=="fileName")
						{
							window.open(basePath + "common/downloadFile?fileName=pateExcelExport\\"+fileName+".xlsx","_blank");
						}
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！！！");
				}
			});
		}


		jQuery(function($) {
			//注意每个页面都要在“jQuery(function($) {”加入如下resize function
			jQuery("#breadcrumbs").resize(
					function() {
						jQuery("#grid-table").setGridWidth(
								jQuery("#breadcrumbs").width() - 18);
					});
			jQuery(".chosen-select").chosen();
		});

		$('#WEBAZ').datepicker({autoclose:true}).next().on(ace.click_event, function(){
			$(this).prev().focus();
		});
	</script>
</body>
</html>