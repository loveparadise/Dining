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
						<li class="active">包装扫描</li>
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
							<label for="form-field-select-3">装箱方式选择:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="箱规选择" id="boxes" onchange="switchDiv()">
								<option value="barCode">扫描箱码装箱</option>
								<option value="ebelnAnum">录入订单号+箱号装箱</option>
							</select>&nbsp;&nbsp;&nbsp; 
							<label class="form-field-select-3"
								for="form-field-1">只装箱不打印</label> <label> <input
								name="switch-field-5" class="ace ace-switch ace-switch-7" onchange="switchButtons()"
								type="checkbox" id="print" checked="checked"/> <span class="lbl"></span>
							</label>
							<label class="form-field-select-3"
								for="form-field-1">满箱后自动装箱</label> <label> <input
								name="switch-field-2" class="ace ace-switch ace-switch-7"
								type="checkbox" id="autoprint" checked="checked"/> <span class="lbl"></span>
							</label>
							&nbsp;&nbsp;&nbsp;
							<button class="btn btn-sm btn-info" onclick="pack();" id="pack" disabled="disabled">
									装箱<i class="icon-print  align-top bigger-125 icon-on-right"></i>
							</button>
							&nbsp;&nbsp;&nbsp;
							<button class="btn btn-sm btn-info" type="button" id="printAgain"
								onclick="printAgain();" disabled="disabled">
								<i class="icon-ok bigger-110"></i> 再次打印
							</button>
						</div>
						<br />
						<div id="barCodeDiv" role="alert">
							<div class="form-group">
								<label class="col-sm-1 control-label no-padding-right"
									for="barCode">箱码：</label> <input type="text" id="barCode"
									placeholder="箱码录入后，请按回车键或点击确定按钮；支持扫描枪扫描录入"
									class="col-xs-5 col-sm-5" onkeydown='if(event.keyCode==13){getBoxPate();}'/> &nbsp;&nbsp;
								<button class="btn btn-sm btn-success" onclick="getBoxPate()" id="barcodeconfirm1">
									<i class="icon-ok"></i>确定
								</button>
								<br/>
								</div>
						</div>
						<div id="ebelnAnumDiv" role="alert">
							<div class="form-group">
								<label class="col-sm-1 control-label no-padding-right"
									for="barCode">订单号：</label> <input type="text" id="ebeln"
									placeholder="请录入订单号"
									class="col-xs-2 col-sm-2"/> &nbsp;&nbsp;
								<label class="col-sm-1 control-label no-padding-right"
									for="barCode">箱号：</label> <input type="text" id="orderNum" onkeydown='if(event.keyCode==13){getBoxPate()}'
									placeholder="录入箱号回车"
								class="col-xs-2 col-sm-2"/> &nbsp;&nbsp;
								<label for="form-field-select-4">箱码类型:</label>
								<select
									class="chosen-select" style="width:180px;"
									data-placeholder="箱码类型" id="pateType">
									<option value="Standard">整箱箱码</option>
									<option value="Remainder">尾箱箱码</option>
									<option value="Mix">直配混款混色箱码</option>
								</select>&nbsp;&nbsp;
								<button class="btn btn-sm btn-success" onclick="getBoxPate()" id="barcodeconfirm2">
									<i class="icon-ok"></i>确定
								</button>
								<br/>
							</div>
						</div>
						<div>
							<label class="col-sm-1 control-label no-padding-right"
									for="ean1">单品条码：</label> <input type="text"
									id="ean1" placeholder="单品条码录入后，请按回车键或点添加货品按钮；支持扫描枪扫描录入"
									class="col-xs-5 col-sm-5" onkeydown='if(event.keyCode==13){addItem()}' disabled="disabled"/> &nbsp;&nbsp;
								<button class="btn btn-sm btn-warning" onclick="addItem()" disabled="disabled" id="addItem1">
									<i class="icon-fire bigger-110"></i><span
										class="bigger-110 no-text-shadow">添加货品</span>
								</button>
							<br/>
							<br/>
							<div class="row">
								<div class="col-xs-12">
									<!-- PAGE CONTENT BEGINS -->

									<div class="row">
										<div class="col-xs-12">
											<div class="table-responsive">
												<table id="sample-table-1"
													class="table table-striped table-bordered table-hover">
													<thead>
														<tr>
															<th>货号</th>
															<th>尺码</th>
															<th>颜色</th>
															<th>装箱量</th>
															<th>装箱规格</th>
															<th>单品装箱量</th>
															<th>未扫描数量</th>
															<th>已扫描数量</th>
															<th>单品条码</th>
														</tr>
													</thead>

													<tbody id="tbody">
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-xs-12" style="padding-left: 0px;">
							<!-- PAGE CONTENT BEGINS -->
							<table id="grid-table"></table>
							<div id="grid-pager"></div>
							<!-- PAGE CONTENT ENDS -->
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
								<h4 class="modal-title" id="myModalLabel">确认废弃箱码</h4>
							</div>
							<div class="modal-body" id="messageTip">
								箱码废弃后，对应的订单要重新生成部分或全部箱码或箱贴，确认废弃？</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">关闭</button>
								<button type="button" class="btn btn-primary" id="create"
									onclick="scrapBarcodes();">废弃</button>
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal -->

				</div>
				<!-- /.page-content -->
			</div>
			<div style="display:none">
				<div id="to_print"></div>
				<input type="button" id="print_button" value="Print"
					onclick="document.getElementById('FILEtoPrint').focus(); document.getElementById('FILEtoPrint').contentWindow.print();" />
			</div>
			<!-- /.main-container -->
		</div>
	</div>
	<script type="text/javascript">
		var map={};
		var i=0;
		var packNum=0;
		var eangoodcodeStr="";
		var ids = new Array();
		
		function switchButtons()
		{
			$("#tbody").html("");
			if($("#print").is(':checked'))
			{
// 				$("#autoprint").attr("disabled",true);
				$("#printAgain").attr("disabled",true);
			}else if ($("#FILEtoPrint").length > 0)
			{
// 				$("#autoprint").attr("disabled",false);
				$("#printAgain").attr("disabled",false);
			}
		}
		
		function playError()
		{
			if(error_player.paused)
			{
				error_player.play();
			}else{
				error_player.pause();
			}
		}
		
		function playSuccess()
		{
			if(success_player.paused)
			{
				success_player.play();
			}else{
				success_player.pause();
			}
		}
		
		function switchDiv()
		{
			if($("#boxes").val()=="barCode")
			{
				$("#ebelnAnumDiv").attr("hidden",true);
				$("#barCodeDiv").attr("hidden",false);
				if(!$("#print").is(':checked'))
					$("#print").trigger("click");
			}else if($("#boxes").val()=="ebelnAnum")
			{
				$("#barCodeDiv").attr("hidden",true);
				$("#ebelnAnumDiv").attr("hidden",false);
				if($("#print").is(':checked'))
					$("#print").trigger("click");
			}
		}
		
		function addItem()
		{
			if(packNum==0)
			{
				playError();
				alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable", "错误","已达最大装箱量，请包装！");
				$("#ean1").val("");
				
				return false;
			}
			
			var val=$.trim($("#ean1").val());
			
			if(eangoodcodeStr.indexOf(val+",")<0)
			{
				playError();
				alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable", "错误","该箱码不包含该货品!");
				$("#ean1").val("");
				return false;
			}
			
			if(map[val]==0)
			{
				playError();
				alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable", "错误","该货品在该包装箱中已最大量！不能再扫描该类货品！");
				$("#ean1").val("");
				return false;
			}else if(map[val]>0)
			{
				var temp=map[val];
				temp=temp-1;
				delete map[val]; 
				map[val] = temp;
				$("#unpack"+val).html(temp);
				temp=parseInt($("#pack"+val).html());
				$("#pack"+val).html(temp+1);
			}
			$("#ean1").val("");
			packNum--;
			
			if(packNum==0 && $("#autoprint").is(':checked'))
			{
				playSuccess();
				pack();
				if($("#boxes").val()=="barCode")
					$("#barCode").focus();
				else
					$("#orderNum").focus();
			}else if(packNum==0)
			{
				playSuccess();
				$("#pack").attr("disabled",false);
				if($("#boxes").val()=="barCode")
					$("#barCode").focus();
				else
					$("#orderNum").focus();
				$("#addItem1").attr("disabled",true);
				$("#ean1").attr("disabled",true);
			}
			
		}
		function pack() {
			$("#tbody").html("");
			$("#pack").attr("disabled",true);
			if($("#print").is(':checked'))
				$("#printAgain").attr("disabled",true);
			else
				$("#printAgain").attr("disabled",false);
			$("#ean1").val("");
			$("#ean1").attr("disabled",true);
			$("#addItem1").attr("disabled",true);
			
			if($("#boxes").val()=="barCode")
			{
				$("#barCode").attr("disabled",false);
				$("#barcodeconfirm1").attr("disabled",false);
				$("#barCode").val("");
			}else if($("#boxes").val()=="ebelnAnum")
			{
				$("#ebeln").attr("disabled",false);
				$("#orderNum").attr("disabled",false);
				$("#barcodeconfirm2").attr("disabled",false);
// 				$("#ebeln").val("");
				$("#orderNum").val("");
			}

			
			var fileName= Date.parse(new Date());
			$.ajax({
				url : basePath + "print/packPates",
				method : "post",
				data : {
					Ids : ids,
					fileName:fileName,
					onlyPack:$("#print").is(':checked')
				},
				dataType : "json",
				success : function(data) {
					$.each(data, function(id, item) {
						if(id=="message")
						{
							if (item == "success") {
								alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","装箱成功！");
							} else if (item == "error") {
								playError();
								alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","装箱失败！！！");
							}
						}else if(id=="fileName")
						{
							var filePath='<%=basePath %>downfile/'+item;
							$("#to_print").html("<iframe src="+filePath+" id='FILEtoPrint'></iframe>");
							
							$("#FILEtoPrint").attr("src",filePath);
							
						    setTimeout(function(){$("#print_button").click();}, 100);
						}
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					playError();
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！！！");
				}
			});
		}

		function printAgain() {
			if ($("#FILEtoPrint").length == 0) {
				playError();
				//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
				alertMsg($("#alertMsg"),
						"alert alert-danger alert-dismissable", "错误",
						"请先进行装箱!");
				return false;
			}

			setTimeout(function() {
				$("#print_button").click();
			}, 10);
		}

		function getBoxPate() {
			closeAlertMsg();
			var val=$.trim($("#barCode").val());
			var ebeln=$.trim($("#ebeln").val());
			var orderNum=$.trim($("#orderNum").val());
			var pateType=$.trim($("#pateType").val());
			if($("#boxes").val()=="barCode")
			{
				if(val.length==0)
				{
					playError();
					alertMsg($("#alertMsg"),
							"alert alert-danger alert-dismissable", "错误",
							"请输入箱码!");
					$("#barCode").focus();
					return false;
				}
			}
			else if($("#boxes").val()=="ebelnAnum")
			{
				if(ebeln.length==0||orderNum.length==0)
				{
					playError();
					alertMsg($("#alertMsg"),
							"alert alert-danger alert-dismissable", "错误",
							"请输入订单号及箱号!");
					$("#orderNum").focus();
					return false;
				}
			}
			
			$.ajax({
						method : "post",
						url : basePath + "print/getBoxPate",
						dataType : "json",
						data : {
							barcode : val,
							ebeln : ebeln,
							orderNum : orderNum,
							pateType : pateType
						},
						success : function(data) {
							$.each(
											data,
											function(id, item) {
												if (item != "error") {
													i=0;
													map={};
													packNum=0;
													eangoodcodeStr="";
													for (i = 0; i < item.length; i++) {
														var htm = "<tr id='row"+i+"'><td id='"+item[i].eanGoodCode+"'>"
																+ item[i].MATNR
																+ "</td><td>"
																+ item[i].sizeNUM
																+ "</td><td>"
																+ item[i].zcolor
																+ "</td><td>"
																+ item[i].packNum
																+ "</td><td>"
																+ item[i].boxName
																+ "</td><td>"
																+ item[i].goodNum
																+ "</td><td style='color:red' id='unpack"+item[i].eanGoodCode+"'>"
																+ item[i].goodNum
																+ "</td><td id='pack"+item[i].eanGoodCode+"'>"
																+ 0
																+ "</td><td>"
																+ item[i].eanGoodCode
																+ "</td></tr>";
														$("#tbody").append(htm);
														eangoodcodeStr=eangoodcodeStr+item[i].eanGoodCode+",";
														map[item[i].eanGoodCode]=item[i].goodNum;
													}
													packNum=item[0].packNum;
													ids[0]=item[0].id;
													$("#ean1").attr("disabled",false);
													$("#addItem1").attr("disabled",false);
													$("#ean1").focus();
													if($("#boxes").val()=="barCode")
													{
														$("#barCode").attr("disabled",true);
														$("#pack").attr("disabled",true);
														$("#barcodeconfirm1").attr("disabled",true);
													}else if($("#boxes").val()=="ebelnAnum")
													{
														$("#ebeln").attr("disabled",true);
														$("#orderNum").attr("disabled",true);
														$("#pack").attr("disabled",true);
														$("#barcodeconfirm2").attr("disabled",true);
													}
													
												} else if (item == "error") {
													playError();
													alertMsg(
															$("#alertMsg"),
															"alert alert-danger alert-dismissable",
															"失败",
															"查找装箱信息失败，请确认对应的箱码是否已经‘装箱’、‘失效’、箱码类型选择错误或不存在该箱码！");
													$("#barCode").val("");
													$("#ean1").val("");
													$("#barCode").focus();
												}
											});
						},
						error : function errorCallback(xmlhttpRequest,
								textStatus, errorThrown) {
							playError();
							alertMsg($("#alertMsg"),
									"alert alert-danger alert-dismissable",
									"失败", "系统出错，请联系管理员！");
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
			$("#ebelnAnumDiv").attr("hidden",true);
		});
	</script>
</body>
</html>