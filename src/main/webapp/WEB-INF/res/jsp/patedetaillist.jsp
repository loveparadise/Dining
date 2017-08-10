<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
				<div class="breadcrumbs" id="breadcrumbs">
					<ul class="breadcrumb">
						<li><i class="icon-home home-icon"></i> <a
							href="<%=basePath%>common/index">首页</a></li>
						<li class="active">箱码打印、箱码废除、箱码拆箱</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger hidden" role="alert">
							<strong>提示标题：</strong>具体提示信息
						</div>
						<div class="alert alert-info" id="requirement"
							style="margin-bottom: 0px;text-align: right;">
							<button class="btn btn-sm btn-info" type="button"
								onclick="printPates()">
								<i class="icon-ok bigger-110"></i> 打印箱贴
							</button>
						<c:choose>
							<c:when test="${!fn:endsWith(curUser.authority,',print-,patedetaillist,')}">							
							&nbsp;&nbsp;
								<button class="btn btn-sm btn-danger" onclick="check1()">
									<i class="icon-bolt bigger-110"></i>
									废弃箱码
									<i class="icon-arrow-right icon-on-right"></i>
								</button>
							</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${fn:contains(curUser.authority,'unPack,')}">							
							&nbsp;&nbsp;
								<button class="btn btn-sm btn-warn" onclick="check3()">
									包装箱拆箱
									<i class="icon-arrow-right icon-on-right bigger-110"></i>
								</button>
							</c:when>
						</c:choose>
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
								<h4 class="modal-title" id="myModalLabel">箱码打印确认</h4>
							</div>
							<div class="modal-body" id="messageTip">
								所选数据中包含‘已打印’或‘已包装’数据行，是否重新打印？</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">关闭</button>
								<button type="button" class="btn btn-primary" id="create"
									onclick="confirmPrint();">打印</button>
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal -->

				</div>
				
				<!-- 模态框（Modal） -->
				<div class="modal fade" id="confirmModal2" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel2">确认拆箱</h4>
							</div>
							<div class="modal-body" id="messageTip2">
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
				
				<!-- 模态框（Modal） -->
				<div class="modal fade" id="confirmModal3" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel2">确认废弃箱码</h4>
							</div>
							<div class="modal-body" id="messageTip3">
								箱码拆箱后，对应的箱码要重新进行装箱操作，确认装箱？</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">关闭</button>
								<button type="button" class="btn btn-primary" id="create"
									onclick="unPack();">拆箱</button>
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal -->

				</div>
				<!-- /.page-content -->
			</div>
			<div style="zoom:100%;display:none;">
				<div id="to_print" style="zoom:100%;"></div>
				<input type="button" id="print_button" value="Print" onclick="document.getElementById('FILEtoPrint').focus(); document.getElementById('FILEtoPrint').contentWindow.print();" />
			</div>
			<!-- /.main-container -->
		</div>
	</div>
	<script type="text/javascript">
			 var rowIds="";
			 var IdStr="";
			 function check()
			 {
				rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				if(rowIds=="")
				{
					//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择操作订单!");
					return false;
				}
				
				closeAlertMsg();
				$('#confirmModal').modal('show');
			 }
			 
			 function check3()
			 {
				rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				if(rowIds=="")
				{
					//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择操作订单!");
					return false;
				}
				var stateValue="";	
				for(var i=0;i<rowIds.length;i++)
				{
					IdStr=IdStr+rowIds[i]+",";
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).boxPateStatus!='已装箱')//数据行出现不同箱贴类型的数据
					{
						stateValue="other";
					}
				}
				
				if(stateValue=="other")
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","只可拆箱状态为‘已装箱’的箱贴！");
					return false;
				}
				
				closeAlertMsg();
				$('#confirmModal3').modal('show');
			 }
			 
			 function check1()
			 {
				rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				if(rowIds=="")
				{
					//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择操作订单!");
					return false;
				}
				
				var typeValue="";	
				for(var i=0;i<rowIds.length;i++)
				{
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).pateType=='整箱')//数据行出现不同箱贴类型的数据
					{
						typeValue="Standard";
					}
				}
				
				if(typeValue=="Standard"&&rowIds.length>1)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","当前页面只可一个个废除整箱箱码，批量废除整箱箱码请使用‘按货期、尺码批量废除未包装整箱’功能页！");
					return false;
				}
				
				closeAlertMsg();
				$('#confirmModal2').modal('show');
			 }
			 
				function unPack()
				{
					$('#confirmModal3').modal('hide');
					$.ajax({
						url : basePath + "print/unPack/",
						method : "post",
						data : {
							Ids : IdStr
						},
						dataType : "json",
						success : function(data) {
							$.each(data, function(id, item) {
								if (item == "success") {
									//$("input[class='cbox']").removeAttr("checked");
									alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","所选择的符合条件的箱码已拆箱！");
									//location.reload();
									//重新加载数据
									$(grid_selector).trigger("reloadGrid");
								} else {
										alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","所选择的箱码后台作业中不可拆箱，稍后再试！");//现阶段只支持鞋、服、配的 整箱箱码及鞋类尾箱的箱码！
//	 									$("input[class='cbox']").removeAttr("checked");
//	 									$("#cb_grid-table").attr("checked","checked");
//	 									$("#cb_grid-table").removeAttr("checked");
								}
								rowIds="";
								IdStr="";
							});
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
						}
					});
				}
				
			 function printPates()
			 {
				 rowIds="";
				 rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				if(rowIds=="")
				{
					//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择操作订单!");
					return false;
				}
				closeAlertMsg();
				
				var pateTypeflag=false;//箱贴类型标识
				var typeflag=false;//种类标识
				var mixGrid=false;//有尺码混选
				var rePrint=false;//包含已打印或已包装数据行
				var brandTypeflag=false;//品牌标识
				
				
				var pateType="";
				var typeName="";
				var brandName="";
				var sizeNUM="";
				var stateValue="";	
				
				for(var i=0;i<rowIds.length;i++)
				{				
					if(i==0)
					{
						pateType=$(grid_selector).jqGrid('getRowData', rowIds[i]).pateType;
						typeName=$(grid_selector).jqGrid('getRowData', rowIds[i]).typeName;
						brandName=$(grid_selector).jqGrid('getRowData', rowIds[i]).brandName;
						sizeNUM=$(grid_selector).jqGrid('getRowData', rowIds[i]).sizeNUM;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).typeName!=typeName)//数据行出现不同种类的数据
					{
						typeflag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).sizeNUM!=sizeNUM &&
							(sizeNUM==""||$(grid_selector).jqGrid('getRowData', rowIds[i]).sizeNUM==""))//数据行出现主网格的数据
					{
						mixGrid=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).pateType!=pateType)//数据行出现不同箱贴类型的数据
					{
						pateTypeflag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).brandName!=brandName)//数据行出现不同箱贴类型的数据
					{
						brandTypeflag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).boxPateStatus=="已打印"||
							$(grid_selector).jqGrid('getRowData', rowIds[i]).boxPateStatus=="已包装")//数据行出现不同箱贴类型的数据
					{
						rePrint=true;
					}else if($(grid_selector).jqGrid('getRowData', rowIds[i]).boxPateStatus=="失效")
					{
						stateValue="失效";
					}
				}
				
				if(mixGrid)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","配件有尺码与无尺码的箱贴不能一起打印！");
					return false;
				}
				
				if(pateTypeflag)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选择'箱贴类型'一致的数据行！");
					return false;
				}
				
				if(brandTypeflag)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选择'品牌'一致的数据行！");
					return false;
				}
				
				if(stateValue=="失效")
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","不要选择‘失效’的箱码进行打印！");
					return false;
				}
				
				
				if(typeflag)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选择'种类'一致的数据行！");
					return false;
				}
				
				if(rePrint)
				{
					$('#confirmModal').modal('show');
				}else
				{
					confirmPrint();
				}
			 }
			 
			 function confirmPrint()
			 {
					$('#confirmModal').modal('hide');
					var fileName=loginAccount+Date.parse(new Date());
					$.ajax({
						url : basePath + "print/printPates",
						method : "post",
						data : {
							Ids : rowIds,
							fileName:fileName
						},
						dataType : "json",
						success : function(data) {
							$.each(data, function(id, item) {
								if(id=="message")
								{
									if (item == "success") {
										alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","已生成打印资料！");
									} else if (item == "error") {
										alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","生成打印资料失败！！！");
									}
								}else if(id=="fileName")
								{
									var filePath='<%=basePath %>downfile/'+item;
									$("#to_print").html("<iframe src="+filePath+" id='FILEtoPrint'></iframe>");
									
									$("#FILEtoPrint").attr("src",filePath);
									
								    setTimeout(function(){$("#print_button").click();}, 500);
								}
							});
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！！！");
						}
					});
			 }
			 
			 function scrapBarcodes()
			 {
				 $("#confirmModal2").modal('toggle');
				 $.ajax({
						method : "post",
	                    url: basePath+"print/scrapBarcodes",
	                    dataType: "json",
						data : {
							Ids : rowIds
						},
	                    success:  function (data) {
							$.each(data, function(id, item) {
								if (item == "success") {
									alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","已将所选的一些箱码进行废除，请校验所选箱码是否都成功废除！");
									//重新加载数据
									$(grid_selector).trigger("reloadGrid");
								} else {
										alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","废弃箱码失败，请确认网络连接是否正常或长时间未操作系统自动退出登录状或选择了已经失效、已包装的箱码 或 所选的箱码真在废除中！");
								}
								rowIds="";
							});
	                    },
	                    error: function errorCallback(xmlhttpRequest, textStatus, errorThrown) {
	                    	alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","系统出错，请联系管理员！");
	                    }
	                });
			 }
				 
			 function formatOrderStatus(cellvalue)
			 {
				 if(cellvalue=="-1")
					 return "失效";
				 else if(cellvalue=="0")
					 return "未打印";
				 else if(cellvalue=="1")
					 return "有更新";
				 else if(cellvalue=="2")
					 return "有生成";
				 else if(cellvalue=="3")
					 return "已生成";
				 else if(cellvalue=="4")
					 return "已打印";
				 else if(cellvalue=="5")
					 return "已装箱";
				 else
					 return cellvalue;
			 }
			 
			 function formatPateType(cellvalue)
			 {
				 if(cellvalue=="Standard")
					 return "整箱";
				 else if(cellvalue=="Remainder")
					 return "尾箱";
				 else if(cellvalue=="Mix")
					 return "直配混款混色";
				 else
					 return cellvalue;
			 }
			 
			 function formatSyn(cellvalue)
			 {
				 if(cellvalue=="1")
					 return "已传";
				 else
					 return "未传";
			 }
			 
			 function getBoxes()
			 {
				 $.ajax({
	                    type: "POST",
	                    contentType: "application/json; charset=utf-8",
	                    url: basePath+"print/getBoxes",
	                    dataType: "json",
	                    success:  function (data) {
	                    	var str=data.toString();
	                    	var boxes=str.split(",");
	                    	for(var i=0;i<boxes.length;i++){
	                            var value = boxes[i];
	                            var text =  boxes[i];
	                            $("#boxes").append("<option value='"+value+"'>"+text+"</option>");
	                    	}
	                    },
	                    error: function errorCallback(xmlhttpRequest, textStatus, errorThrown) {
	                        alert(errorThrown + ":" + textStatus);
	                    }
	                });
			 }
				
			jQuery(function($) {
				//注意每个页面都要在“jQuery(function($) {”加入如下resize function
				 jQuery("#breadcrumbs").resize(function(){
						jQuery("#grid-table").setGridWidth(jQuery("#breadcrumbs").width()-18);
						jQuery("#requirement").width(jQuery("#breadcrumbs").width()-50);
				  }); 
				jQuery("#requirement").width(jQuery("#breadcrumbs").width()-72);
				jQuery(".chosen-select").chosen();
				jQuery(grid_selector).jqGrid({
					url:basePath+"print/patedetaillist",
					datatype: "json",
					height:350,
					shrinkToFit:false,
					colNames:['ID',
					          '供应商号',
					          '箱码',
					          '箱贴状态',
					          '箱贴类型',
					          '种类',
					          '品牌',
					          '是否直配',
					          '采购订单',
					          '货号/物料号',
					          '网络值',
					          '颜色',
					          '品名/物料名称',
					          '订单行项目',
					          '交货日期',
					          '国家代码',
							  '箱规',
					          '装箱量',
							  '箱号',
					          '关联明细',
					          '重量',
					          '网格值描述',
					          '打印日期',
					          '包装日期',
					          '创建日期',
					          '回传防窜',
					          '回传SAP'
					          ],
					colModel:[
						{name:'id',index:'id',  sorttype:"int", editable:false,hidden:true},
						{name:'providerCode',index:'providerCode',width:100, editable:false,searchoptions: {sopt: ['in']}},
						{name:'barCode',index:'barCode',  editable:false,searchoptions: {sopt: ['eq']}},
						{name:'boxPateStatus',index:'boxPateStatus',sortable:false,width:70, editable:false,formatter:formatOrderStatus,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;-1:失效;0:未打印;4:已打印;5:已装箱"}},
						{name:'pateType',index:'pateType',sortable:false,editable:false,search:true,width:70,formatter:formatPateType,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;Standard:整箱;Remainder:尾箱;Mix:直配混款混色"}},	
						{name:'typeName',index:'typeName',sortable:false,width:70,editable:false,stype:"select",searchoptions:{sopt:["eq"],
							value:"-99:全部;服装:服装;鞋类:鞋类;配件:配件;通用:通用;广宣用品:广宣用品;服材:服材;鞋材:鞋材;其它:其它"}},
						{name : 'brandName',index : 'brandName',sortable : false,width:70,editable : false,stype : "select",	searchoptions : { sopt : [ "eq" ],
							value : "-99:全部;大货:大货;海外:海外;赞助:赞助;FILA-大货:FILA-大货;运动生活:运动生活;儿童:儿童;店铺形象物品:店铺形象物品;鞋材辅材:鞋材辅材;广宣用品:广宣用品;电商:电商;NBA大货:NBA大货;NBA儿童:NBA儿童;原材料:原材料;半成品:半成品;易耗品:易耗品;模具:模具;虚拟物料:虚拟物料;FILA-广宣用品:FILA-广宣用品;FILA-儿童:FILA-儿童;FILA-赞助:FILA-赞助"}},
						{name : 'MixFlag',index : 'MixFlag',editable : false,width:100,stype : "select",searchoptions : {sopt : [ "eq" ],value : "-99:全部;门店直配:门店直配;非门店直配:非门店直配;总部电商:总部电商"}},
						{name:'EBELN',index:'EBELN',  editable:false,width:100, searchoptions: {sopt: ['in']}},
						{name:'MATNR',index:'MATNR', editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'sizeNUM',index:'sizeNUM', search:true,width:70,searchoptions: {sopt: ['eq']},editable:false},
						{name:'zcolor',index:'zcolor', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}},
						{name:'stock_name',index:'stock_name', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}},
						{name:'EBELP',index:'EBELP', search:true,searchoptions: {sopt: ['eq']},editable:false},
						{name:'WEBAZ',index:'WEBAZ', width:100,sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'KSCAT',index:'KSCAT', editable:false,width:70,searchoptions: {sopt: ['eq']}},
						{name:'boxSpecificationName',index:'boxSpecificationName', editable:false,searchoptions: {sopt: ['cn']}},
						{name:'packNum',index:'packNum', editable:false,width:70,searchoptions: {sopt: ['eq']}},
						{name:'orderNum',index:'orderNum',  editable:false,width:70,searchoptions: {sopt: ['eq']}},
						{name:'relation',index:'relation',  editable:false,searchoptions: {sopt: ['cn']}},
						{name:'weight',index:'weight', editable:false,search:true,width:70,searchoptions: {sopt: ['ge']}},
						{name:'ATWTB',index:'ATWTB', editable:false,search:true,searchoptions: {sopt: ['eq']}},
						{name:'printDate',index:'printDate', sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'packDate',index:'packDate', sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'createDate',index:'createDate', sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'synFlag1',index:'synFlag1',sortable:false,width:70, editable:false,formatter:formatSyn,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;1:已传;0:未传"}},
						{name:'synFlag2',index:'synFlag2',sortable:false,width:70, editable:false,formatter:formatSyn,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;1:已传;0:未传"}},
					], 
			
					viewrecords : true,
					rowNum:300,
					multiselect: true,
					rowList:[50,100,300,400,500],
					pager : pager_selector,
					altRows: true,
					onSelectRow: function (rowId, status, e) {//勾选时要执行的方法
						closeAlertMsg();
					},	
					onPaging:function(){//翻页时要执行的方法
						 $(grid_selector).jqGrid('setGridParam', {_search:false});//如果是翻页，则置标识，该操作不是新的查询动作
					},
					loadComplete : function() {//表格加载完毕要执行的方法
						var total=$(grid_selector).jqGrid('getGridParam','lastpage');//获取总页数
						var records=$(grid_selector).jqGrid('getGridParam','records');//获取总记录数
						var postData= {totalPage:total,recordCount:records};
						$(grid_selector).jqGrid('setGridParam',{postData:postData});//设置传输后台时要手动增加的参数
						var table = this;
						setTimeout(function(){
							styleCheckbox(table);
							
							updateActionIcons(table);
							updatePagerIcons(table);
							enableTooltips(table);
						}, 0);
						//使表格前面的操作按钮在右边显示
						$(grid_selector).closest("div.ui-jqgrid-view").children("div.ui-jqgrid-titlebar").css("text-align", "right").children("span.ui-jqgrid-title").css("float", "right");
					},
			
					autowidth: true			
				});
			
				//在表格前增加搜索栏
				jQuery(grid_selector).jqGrid('filterToolbar',{searchOperators : false,defaultSearch:true,stringResult:true,searchOnEnter: true, enableClear: false});
				
				//enable search/filter toolbar
				//jQuery(grid_selector).jqGrid('filterToolbar',{defaultSearch:true,stringResult:true})
			
				//switch element when editing inline
				function aceSwitch( cellvalue, options, cell ) {
					setTimeout(function(){
						$(cell) .find('input[type=checkbox]')
								.wrap('<label class="inline" />')
							.addClass('ace ace-switch ace-switch-5')
							.after('<span class="lbl"></span>');
					}, 0);
				}
				//enable datepicker
				function pickDate( cellvalue, options, cell ) {
					setTimeout(function(){
						$(cell) .find('input[type=text]')
								.datepicker({format:'yyyy-mm-dd' , autoclose:true}); 
					}, 0);
				}
			
			
				//navButtons，编辑、增加、删除按钮等是否在表格左下角显示，根据需求在这里设置 true或false
				jQuery(grid_selector).jqGrid('navGrid',pager_selector,
					{ 	//navbar options
						edit: false,
						editicon : 'icon-pencil blue',
						add: false,
						addicon : 'icon-plus-sign purple',
						del: false,
						delicon : 'icon-trash red',
						search: false,
						searchicon : 'icon-search orange',
						refresh: true,
						refreshicon : 'icon-refresh green',
						view: true,
						viewicon : 'icon-zoom-in grey',
						beforeRefresh: function () {
							var postData= {totalPage:0,recordCount:0,_search:true};
							$(grid_selector).jqGrid('setGridParam',{postData:postData});//设置传输后台时要手动增加的参数
					    }
					},
					{
						//edit record form
						//closeAfterEdit: true,
						recreateForm: true,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_edit_form(form);
						}
					},
					{
						//new record form
						closeAfterAdd: true,
						recreateForm: true,
						viewPagerButtons: false,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_edit_form(form);
						}
					},
					{
						//delete record form
						recreateForm: true,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							if(form.data('styled')) return false;
							
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_delete_form(form);
							
							form.data('styled', true);
						},
						onClick : function(e) {
							alert(1);
						}
					},
					{
						//search form
						recreateForm: true,
						afterShowSearch: function(e){
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
							style_search_form(form);
						},
						afterRedraw: function(){
							style_search_filters($(this));
						}
						,
						multipleSearch: true,
						sopt: ['ge','le','cn','eq'],
						/**
						multipleGroup:true,
						showQuery: true
						*/
					},
					{
						//view record form
						recreateForm: true,
						beforeShowForm: function(e){
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
						}
					}
				);
			
				
				function style_edit_form(form) {
					//enable datepicker on "sdate" field and switches for "stock" field
					form.find('input[name=sdate]').datepicker({format:'yyyy-mm-dd' , autoclose:true})
						.end().find('input[name=stock]')
							  .addClass('ace ace-switch ace-switch-5').wrap('<label class="inline" />').after('<span class="lbl"></span>');
			
					//update buttons classes
					var buttons = form.next().find('.EditButton .fm-button');
					buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
					buttons.eq(0).addClass('btn-primary').prepend('<i class="icon-ok"></i>');
					buttons.eq(1).prepend('<i class="icon-remove"></i>')
					
					buttons = form.next().find('.navButton a');
					buttons.find('.ui-icon').remove();
					buttons.eq(0).append('<i class="icon-chevron-left"></i>');
					buttons.eq(1).append('<i class="icon-chevron-right"></i>');		
				}
			
				function style_delete_form(form) {
					var buttons = form.next().find('.EditButton .fm-button');
					buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
					buttons.eq(0).addClass('btn-danger').prepend('<i class="icon-trash"></i>');
					buttons.eq(1).prepend('<i class="icon-remove"></i>')
				}
				
				function style_search_filters(form) {
					form.find('.delete-rule').val('X');
					form.find('.add-rule').addClass('btn btn-xs btn-primary');
					form.find('.add-group').addClass('btn btn-xs btn-success');
					form.find('.delete-group').addClass('btn btn-xs btn-danger');
				}
				function style_search_form(form) {
					var dialog = form.closest('.ui-jqdialog');
					var buttons = dialog.find('.EditTable')
					buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'icon-retweet');
					buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'icon-comment-alt');
					buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'icon-search');
				}
				
				function beforeDeleteCallback(e) {
					var form = $(e[0]);
					if(form.data('styled')) return false;
					
					form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
					style_delete_form(form);
					
					form.data('styled', true);
				}
				
				function beforeEditCallback(e) {
					var form = $(e[0]);
					form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
					style_edit_form(form);
				}
			
			
			
				//it causes some flicker when reloading or navigating grid
				//it may be possible to have some custom formatter to do this as the grid is being created to prevent this
				//or go back to default browser checkbox styles for the grid
				function styleCheckbox(table) {
				/**
					$(table).find('input:checkbox').addClass('ace')
					.wrap('<label />')
					.after('<span class="lbl align-top" />')
			
			
					$('.ui-jqgrid-labels th[id*="_cb"]:first-child')
					.find('input.cbox[type=checkbox]').addClass('ace')
					.wrap('<label />').after('<span class="lbl align-top" />');
				*/
				}
				
			
				//unlike navButtons icons, action icons in rows seem to be hard-coded
				//you can change them like this in here if you want
				function updateActionIcons(table) {
					/**
					var replacement = 
					{
						'ui-icon-pencil' : 'icon-pencil blue',
						'ui-icon-trash' : 'icon-trash red',
						'ui-icon-disk' : 'icon-ok green',
						'ui-icon-cancel' : 'icon-remove red'
					};
					$(table).find('.ui-pg-div span.ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					})
					*/
				}
				
				//replace icons with FontAwesome icons like above
				function updatePagerIcons(table) {
					var replacement = 
					{
						'ui-icon-seek-first' : 'icon-double-angle-left bigger-140',
						'ui-icon-seek-prev' : 'icon-angle-left bigger-140',
						'ui-icon-seek-next' : 'icon-angle-right bigger-140',
						'ui-icon-seek-end' : 'icon-double-angle-right bigger-140'
					};
					$('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
						
						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					});
				}
			
				function enableTooltips(table) {
					$('.navtable .ui-pg-button').tooltip({container:'body'});
					$(table).find('.ui-pg-div').tooltip({container:'body'});
				}
			
				//var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');
			
			
			});
		</script>


	<script type="text/javascript">
			jQuery(function($) {
				$('.easy-pie-chart.percentage').each(function(){
					var $box = $(this).closest('.infobox');
					var barColor = $(this).data('color') || (!$box.hasClass('infobox-dark') ? $box.css('color') : 'rgba(255,255,255,0.95)');
					var trackColor = barColor == 'rgba(255,255,255,0.95)' ? 'rgba(255,255,255,0.25)' : '#E2E2E2';
					var size = parseInt($(this).data('size')) || 50;
					$(this).easyPieChart({
						barColor: barColor,
						trackColor: trackColor,
						scaleColor: false,
						lineCap: 'butt',
						lineWidth: parseInt(size/10),
						animate: /msie\s*(8|7|6)/.test(navigator.userAgent.toLowerCase()) ? false : 1000,
						size: size
					});
				});
			
				$('.sparkline').each(function(){
					var $box = $(this).closest('.infobox');
					var barColor = !$box.hasClass('infobox-dark') ? $box.css('color') : '#FFF';
					$(this).sparkline('html', {tagValuesAttribute:'data-values', type: 'bar', barColor: barColor , chartRangeMin:$(this).data('min') || 0} );
				});
			
			
			
			
			  var placeholder = $('#piechart-placeholder').css({'width':'90%' , 'min-height':'150px'});
			  var data = [
				{ label: "social networks",  data: 38.7, color: "#68BC31"},
				{ label: "search engines",  data: 24.5, color: "#2091CF"},
				{ label: "ad campaigns",  data: 8.2, color: "#AF4E96"},
				{ label: "direct traffic",  data: 18.6, color: "#DA5430"},
				{ label: "other",  data: 10, color: "#FEE074"}
			  ];
			  function drawPieChart(placeholder, data, position) {
			 	  $.plot(placeholder, data, {
					series: {
						pie: {
							show: true,
							tilt:0.8,
							highlight: {
								opacity: 0.25
							},
							stroke: {
								color: '#fff',
								width: 2
							},
							startAngle: 2
						}
					},
					legend: {
						show: true,
						position: position || "ne", 
						labelBoxBorderColor: null,
						margin:[-30,15]
					}
					,
					grid: {
						hoverable: true,
						clickable: true
					}
				 });
			 }
			 drawPieChart(placeholder, data);
			
			 /**
			 we saved the drawing function and the data to redraw with different position later when switching to RTL mode dynamically
			 so that's not needed actually.
			 */
			 placeholder.data('chart', data);
			 placeholder.data('draw', drawPieChart);
			
			
			
			  var $tooltip = $("<div class='tooltip top in'><div class='tooltip-inner'></div></div>").hide().appendTo('body');
			  var previousPoint = null;
			
			  placeholder.on('plothover', function (event, pos, item) {
				if(item) {
					if (previousPoint != item.seriesIndex) {
						previousPoint = item.seriesIndex;
						var tip = item.series['label'] + " : " + item.series['percent']+'%';
						$tooltip.show().children(0).text(tip);
					}
					$tooltip.css({top:pos.pageY + 10, left:pos.pageX + 10});
				} else {
					$tooltip.hide();
					previousPoint = null;
				}
				
			 });
			
				var d1 = [];
				for (var i = 0; i < Math.PI * 2; i += 0.5) {
					d1.push([i, Math.sin(i)]);
				}
			
				var d2 = [];
				for (var i = 0; i < Math.PI * 2; i += 0.5) {
					d2.push([i, Math.cos(i)]);
				}
			
				var d3 = [];
				for (var i = 0; i < Math.PI * 2; i += 0.2) {
					d3.push([i, Math.tan(i)]);
				}
				
			
				var sales_charts = $('#sales-charts').css({'width':'100%' , 'height':'220px'});
				$.plot("#sales-charts", [
					{ label: "Domains", data: d1 },
					{ label: "Hosting", data: d2 },
					{ label: "Services", data: d3 }
				], {
					hoverable: true,
					shadowSize: 0,
					series: {
						lines: { show: true },
						points: { show: true }
					},
					xaxis: {
						tickLength: 0
					},
					yaxis: {
						ticks: 10,
						min: -2,
						max: 2,
						tickDecimals: 3
					},
					grid: {
						backgroundColor: { colors: [ "#fff", "#fff" ] },
						borderWidth: 1,
						borderColor:'#555'
					}
				});
			
			
				$('#recent-box [data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('.tab-content')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
			
			
				$('.dialogs,.comments').slimScroll({
					height: '300px'
			    });
				
				
				//Android's default browser somehow is confused when tapping on label which will lead to dragging the task
				//so disable dragging when clicking on label
				var agent = navigator.userAgent.toLowerCase();
				if("ontouchstart" in document && /applewebkit/.test(agent) && /android/.test(agent))
				  $('#tasks').on('touchstart', function(e){
					var li = $(e.target).closest('#tasks li');
					if(li.length == 0)return;
					var label = li.find('label.inline').get(0);
					if(label == e.target || $.contains(label, e.target)) e.stopImmediatePropagation() ;
				});
			
				$('#tasks').sortable({
					opacity:0.8,
					revert:true,
					forceHelperSize:true,
					placeholder: 'draggable-placeholder',
					forcePlaceholderSize:true,
					tolerance:'pointer',
					stop: function( event, ui ) {//just for Chrome!!!! so that dropdowns on items don't appear below other items after being moved
						$(ui.item).css('z-index', 'auto');
					}
					}
				);
				$('#tasks').disableSelection();
				$('#tasks input:checkbox').removeAttr('checked').on('click', function(){
					if(this.checked) $(this).closest('li').addClass('selected');
					else $(this).closest('li').removeClass('selected');
				});
				
			
			});
		</script>
</body>
</html>