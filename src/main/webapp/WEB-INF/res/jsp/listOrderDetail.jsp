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
						<li><i class="icon-home home-icon"></i> <a
							href="<%=basePath%>common/index">首页</a></li>
						<li class="active">订单明细列表</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">

						<div class="col-xs-12">
							<!-- PAGE CONTENT BEGINS -->
							<table id="grid-table"></table>
							<div id="grid-pager"></div>
							<!-- PAGE CONTENT ENDS -->
						</div>
						<!-- /.col -->
					</div>
					<!-- /.row -->
				</div>
				<!-- /.page-content -->
			</div>
			<!-- /.main-container -->

			<script type="text/javascript">
			var refreshFlag=false;//一旦点了左下角的刷新按钮，查询栏不再放入点链接带过来的订单号
			
			function exportExcel() {
				//获取grid参数
				var url1=$(grid_selector).jqGrid('getGridParam', 'url');
				var timestamp = Date.parse(new Date());
				//设定grid参数
				$(grid_selector).jqGrid('setGridParam', {url:basePath + "order/exportOrderDetails"});
				var postData= {fileName:timestamp};
				$(grid_selector).jqGrid('setGridParam',{postData:postData});
				//重新发送请求到后台
				$(grid_selector)[0].triggerToolbar();
				
				$(grid_selector).jqGrid('setGridParam', {url:url1});
				window.open(basePath + "common/downloadFile?fileName=detailExcelExport\\"+timestamp+".xlsx",timestamp+"excel下载");
			}
			
			 function getColProperties(){
				 var b = jQuery(grid_selector)[0];
				 var params = b.p.colModel;
				 var cols = params[0].name;
				 for ( var i = 1; i < params.length; i++) 
				 {
					 cols += "," + params[i].name+","+params[i].value;
			     }
				 return cols;
			} 
			 
				//将对象数值转换显示中文，在jqgrid定义列对象时用到
			 function formatSynFlag(cellvalue)
			 {
				 if(cellvalue==true)
					 return "已同步";
				 else
					 return "未同步";
			 }
			
			 function formatOrderClassification(cellvalue)
			 {
				 if(cellvalue=="Material")
					 return "材料订单";
				 else
					 return "箱码打印订单";
			 }	
					 
			 function formatOrderStatus(cellvalue)
			 {
				 if(cellvalue=="-1")
					 return "失效";
				 else if(cellvalue=="0")
					 return "有效";
				 else if(cellvalue=="1")
					 return "有更新";
				 else if(cellvalue=="2")
					 return "有生成";
				 else if(cellvalue=="3")
					 return "已生成";
			 }
				
			jQuery(function($) {
				//注意每个页面都要在“jQuery(function($) {”加入如下resize function
				 jQuery("#breadcrumbs").resize(function(){
						jQuery("#grid-table").setGridWidth(jQuery("#breadcrumbs").width()-18);
				  }); 
				 var url1=basePath+"order/listOrderDetail";
				 <c:if test="${id!=null}">
					url1=basePath+"order/listOrderDetail"+"?id="+<c:out	value="${id }"></c:out>;
				 </c:if>
				
				var btnStr="";
				
					btnStr="<button class='btn btn-xs btn-yellow' onclick='exportExcel()'>导出成Excel</button>";
					//&nbsp;&nbsp;<button class='btn btn-danger' id='gritter-error'>Error</button>
			
				jQuery(grid_selector).jqGrid({
					url:url1,
					datatype: "json",
					height:350,
					shrinkToFit:false,
					colNames:[' ',
					          'ID',
					          '采购订单','订单分类','品牌','种类','订单状态',					          
					          '供应商号',
					          '货号/物料号',
					          '交货日期',
							  '物料组',
							  '成品货号',
							  '销售订单号',
							  'SKU',
							  '订单行项目',
							  '计划行',
							  '品名/物料名称',
					          '物料长文本',
					          '网络值',
					          '颜色长文本',
					          '网格值描述',
					          '已计划SKU数量',
					          '已计划数量',
					          '已交货数量',
					          '未交货数量',
					          '销售的成品货号',
					          '成品颜色',
					          '销售行项目号',
					          '业务员/用友旧订单号',
					          '国家代码',
					          '订货会编号',
					          '框架合同',
					          '系列',
					          '品牌/物料类型',
					          '使用部位',
					          '国家名称',
					          '订单类型',
					          '采购订单类型描述',
					          '含税总价',
					          '材料规格',
					          '采购组',
					          '采购组描述',
					          '订单SKU总数量',
					          '入库DC/工厂',
					          '入库工厂名称',
					          '单品数量',
					          '税',
					          '帐户分配类别',
					          '项目类别',
					          '类别名称',
					          '公司代码',
					          '退货项目',
					          '凭证创建日期',
					          '订单总数量',
					          '订单单位',
					          '订单单位描述',
					          '免费/预补标识',
					          '删除',
					          'SKU描述',
					          '库位',
					          '物料组描述'],
					colModel:[
					     //定义表格里的操作按钮列，及对该列的属性进行设置，该页面因无操作需求，该列hidden:true,所以没显示
						{name:'myac',index:'', width:100, fixed:true, sortable:false, resize:false,search:false,hidden:true,
							formatter:'actions', 
							formatoptions:{ 
								keys:true,
								
								delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
								//editformbutton:true, editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
							}
						},
						{name:'id',index:'id',  sorttype:"int", editable:false,hidden:true},
						{name:'EBELN',index:'EBELN',  editable:true, searchoptions: {sopt: ['in']}},
						{name:'orderClassification',orderClassification:'synFlag',sortable:false,editable:false,formatter:formatOrderClassification,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;Print:箱码订单;Material:材料订单"}},
						{name:'brandName',index:'brandName',sortable:false,editable:false,stype:"select",searchoptions:{sopt:["eq"],
							value:"-99:全部;大货:大货;海外:海外;赞助:赞助;FILA-大货:FILA-大货;运动生活:运动生活;儿童:儿童;店铺形象物品:店铺形象物品;鞋材辅材:鞋材辅材;广宣用品:广宣用品;电商:电商;NBA大货:NBA大货;NBA儿童:NBA儿童;原材料:原材料;半成品:半成品;易耗品:易耗品;模具:模具;虚拟物料:虚拟物料;FILA-广宣用品:FILA-广宣用品;FILA-儿童:FILA-儿童;FILA-赞助:FILA-赞助"}},
						{name:'typeName',index:'typeName',sortable:false,editable:false,stype:"select",searchoptions:{sopt:["eq"],
							value:"-99:全部;服装:服装;鞋类:鞋类;配件:配件;通用:通用;广宣用品:广宣用品;服材:服材;鞋材:鞋材;其它:其它"}},
						{name:'orderDetailStatus',index:'orderDetailStatus',sortable:false,editable:false,formatter:formatOrderStatus,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;-1:失效;0:生效;1:有更新;2:有生成;3:已生成 "}},
						{name:'providerCode',index:'providerCode', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'MATNR',index:'MATNR', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'WEBAZ',index:'WEBAZ', search:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},editable:false,formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'MATKL',index:'MATKL', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'CMATNR',index:'CMATNR', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'VBELN',index:'VBELN', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'LMEIN',index:'LMEIN', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'EBELP',index:'EBELP', search:false,editable:false},
						{name:'ETENR',index:'ETENR', search:false,editable:false},
						{name:'TXZ01',index:'TXZ01', search:false,editable:false},
						{name:'ZTEXT1',index:'ZTEXT1', search:false,editable:false},
						{name:'SIZENum',index:'SIZENum', search:false,editable:false},
						{name:'ZTEXT3',index:'ZTEXT3', search:false,editable:false},
						{name:'ATWTB',index:'ATWTB', search:false,editable:false},
						{name:'JHMNG',index:'JHMNG', search:false,editable:false},
						{name:'ETMNG',index:'ETMNG', search:false,editable:false},
						{name:'WEMNG',index:'WEMNG', search:false, editable:false},
						{name:'WJMNG',index:'WJMNG', search:false,editable:false},
						{name:'ZTEXT12',index:'ZTEXT12', search:false,editable:false},
						{name:'ZTEXT13',index:'ZTEXT13', search:false,editable:false},
						{name:'VBELP',index:'VBELP', search:false,editable:false},
						{name:'VERKF',index:'VERKF', search:false,editable:false},
						{name:'KSCAT',index:'KSCAT', search:false,editable:false},
						{name:'ZDHHBH',index:'ZDHHBH', search:false,editable:false},
						{name:'TEXT',index:'TEXT', search:false,editable:false},
						{name:'ZSERIES',index:'ZSERIES', search:false,editable:false},
						{name:'MTBEZ',index:'MTBEZ', search:false,editable:false},
						{name:'SORTF',index:'SORTF', search:false,editable:false},
						{name:'CNAME',index:'CNAME', search:false,editable:false},
						{name:'BSART',index:'BSART', search:false,editable:false},
						{name:'ZTEXT8',index:'ZTEXT8', search:false,editable:false},
						{name:'TOTWR',index:'TOTWR', search:false,editable:false},
						{name:'ZTEXT2',index:'ZTEXT2', search:false,editable:false},
						{name:'EKGRP',index:'EKGRP', search:false,editable:false},
						{name:'EKNAM',index:'EKNAM', search:false,editable:false},
						{name:'SKMNG',index:'SKMNG', search:false,editable:false},
						{name:'WERKS',index:'WERKS', search:false,editable:false},
						{name:'WNAME',index:'WNAME', search:false,editable:false},
						{name:'TOTAL',index:'TOTAL', search:false,editable:false},
						{name:'MWSKZ',index:'MWSKZ', search:false,editable:false},
						{name:'KNTTP',index:'KNTTP', search:false,editable:false},
						{name:'ZTEXT6',index:'ZTEXT6', search:false,editable:false},
						{name:'ZTEXT7',index:'ZTEXT7', search:false,editable:false},
						{name:'BUKRS',index:'BUKRS', search:false,editable:false},
						{name:'RETPO',index:'RETPO', search:false,editable:false},
						{name:'AEDAT',index:'AEDAT', search:false,editable:false},
						{name:'MENGE',index:'MENGE', search:false,editable:false},
						{name:'ETMIN',index:'ETMIN',search:false, editable:false},
						{name:'MEINT',index:'MEINT', search:false,editable:false},
						{name:'ZTEXT14',index:'ZTEXT14',search:false, editable:false},
						{name:'LOEKZ',index:'LOEKZ', search:false,editable:false},
						{name:'MSEHT',index:'MSEHT',search:false, editable:false},
						{name:'LGORT',index:'LGORT',search:false, editable:false},
						{name:'WGBEZ',index:'WGBEZ', search:false,editable:false}
						
					], 
			
					viewrecords : true,
					rowNum:300,
					multiselect: false,
					rowList:[300,400,500],
					pager : pager_selector,
					altRows: true,
					//toppager: true,
					
					//multikey: "ctrlKey",
			        //multiboxonly: true,
					onSelectRow: function (rowId, status, e) {//勾选时要执行的方法
						rowIds= $(grid_selector).jqGrid('getGridParam', 'selarrrow');//勾选 或去勾选 时，刷新选择的对象结果
					},	
					onPaging:function(){//翻页时要执行的方法
						 $(grid_selector).jqGrid('setGridParam', {_search:false});//如果是翻页，则置标识，该操作不是新的查询动作
					},
					loadComplete : function() {//表格加载完毕要执行的方法
						var total=$(grid_selector).jqGrid('getGridParam','lastpage');//获取总页数
						var records=$(grid_selector).jqGrid('getGridParam','records');//获取总记录数
						$(grid_selector).jqGrid('setGridParam',{url:basePath+"order/listOrderDetail"});
						
						if(records>0)
						{
							var postData= {totalPage:total,recordCount:records};
							$(grid_selector).jqGrid('setGridParam',{postData:postData});//设置传输后台时要手动增加的参数
							<c:if test="${id!=null}">
								var rowData = $(grid_selector).jqGrid("getRowData")[0];
					        	var val= rowData.EBELN; //获得制定列的值 （auditStatus 为colModel的name）
								
					        	if(!refreshFlag)
					        	$("#gs_EBELN").val(val);
							</c:if>
						}
					
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
			
					caption: btnStr,//表格前头设值
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
							refreshFlag=true;
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