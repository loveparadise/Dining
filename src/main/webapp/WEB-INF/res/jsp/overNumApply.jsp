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
				<div class="breadcrumbs" id="breadcrumbs">
					<ul class="breadcrumb">
						<li><i class="icon-home home-icon"></i> <a href="#">首页</a></li>
						<li class="active">超数申请</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger" role="alert">
							<strong>导入注意：1.模板中黄色表头不可修改，否则无法导入
							    <br/>2.尺码根据实际情况扩充，一个尺码一列
							    <br/>3.配件无尺码的货品使用“通用”列
								<br/>4.尺码列后紧跟“合计”列，不可出现空列
							</strong>
						</div>
						<div class="alert alert-info" id="requirement"
							style="margin-bottom: 0px;text-align: center;disaply:inline;">
							<form id='fileUpload' action="<%=basePath %>" enctype='multipart/form-data' method='post'>
								<button class='btn btn-xs btn-yellow' onclick="return exportExcel();">下载模板数据</button>&nbsp;&nbsp;&nbsp;
								<input id='excelFile' name='file' type='file' class="btn btn-xs btn-yellow" style="display:inline;width:300px;"/>
							&nbsp;&nbsp;
								<button class='btn btn-xs btn-yellow' type="button" onclick="uploadExcel()">上传EXCEL</button>
							</form>
						</div>						
						<%--<div class="col-xs-12" style="padding-left:0px;">--%>
							<%--<!-- PAGE CONTENT BEGINS -->--%>
							<%--<div class="table-responsive">--%>
								<%--<table id="sample-table-1"--%>
									   <%--class="table table-striped table-bordered table-hover">--%>
									<%--<thead>--%>
									<%--<tr>--%>
										<%--<th>种类</th>--%>
										<%--<th>货号</th>--%>
										<%--<th>供应商号</th>--%>
										<%--<th>订单属性</th>--%>
										<%--<th>采购订单</th>--%>
										<%--<th>订单行项目</th>--%>
										<%--<th>网络值</th>--%>
										<%--<th>超入数</th>--%>
										<%--<th>调整后下单数量</th>--%>
									<%--</tr>--%>
									<%--</thead>--%>
									<%--<tbody id="tbody"></tbody>--%>
								<%--</table>--%>
							<%--</div>--%>
							<%--<!-- PAGE CONTENT ENDS -->--%>
						<%--</div>--%>
						<!-- /.col -->
					</div>
					<!-- /.row -->
				</div>
				<!-- /.page-content -->
				<!-- /.main-container -->

			</div>
		</div>
	</div>

	<!-- inline scripts related to this page -->

	<script type="text/javascript">
	
			function exportExcel() {
				window.open(basePath + "order/overNumDownload?filepath=file\\overNumApplyTemplate.xlsx","_blank");
				return false;
			}
	

			 function uploadExcel() {
				 var excelFile = $("#excelFile").val();
				 if (excelFile == '') {
					 alertMsg($("#alertMsg"), "alert alert-warning alert-dismissable", "警告", "请选择上传EXCEL文件!");
					 return false;
				 } else if (excelFile.indexOf('.xlsx') == -1) {
					 alertMsg($("#alertMsg"), "alert alert-danger alert-dismissable", "错误", "文件格式不正确，请选择正确的Excel文件(后缀名.xlxs)！");
					 return false;
				 } else {
					 var url = basePath + "order/uploadOverNumExcel";
					 var formData = new FormData($("#fileUpload")[0]);
					 $.ajax({
						 url: url,
						 type: 'POST',
						 data: formData,
						 async: true,
						 cache: false,
						 contentType: false,
						 processData: false,
						 dataType: "json",
						 success: function (data) {
							 $.each(data, function (id, item) {
								 if (id == "message") {
									 if (item == "success") {
										 alertMsg($("#alertMsg"), "alert alert-success alert-dismissable", "成功", "已导入相关数据！");
									 } else if (item == "error") {
										 alertMsg($("#alertMsg"), "alert alert-danger alert-dismissable", "失败", "访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！");
									 }
								 } else if (id == "faultMsg") {
									 alertMsg($("#alertMsg"), "alert alert-warning alert-dismissable", "警告", item);
								 } else if (id == "headError") {
									 alertMsg($("#alertMsg"), "alert alert-danger alert-dismissable", "失败", item);
								 }
							 });
						 },
						 error: function (jqXHR, textStatus, errorThrown) {
							 alertMsg($("#alertMsg"), "alert alert-danger alert-dismissable", "出错", "访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
						 }
					 });
				 }
			 }
		</script>
</body>
</html>