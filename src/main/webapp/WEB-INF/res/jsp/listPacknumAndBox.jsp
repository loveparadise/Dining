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
						<li class="active">箱规、装箱量导入</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger" role="alert">
							<strong>导入注意：(一款只需导一个货号的全尺码即可)</strong><br/>1、除配件（配件有尺码货品不包含在内，如内裤），网络值、导入装箱量、导入箱规各项都必填
													<br/>2、公式产生的数据必须转成文本格式
													<br/>3、箱规必须提前在系统中维护好；即如果要使用 100*100*100 箱规，则该箱规必须提前在系统的‘装箱规格维护’建立，否则系统不给予导入
													<br/>4、同一款最多只能有两个箱规，且两个箱规高度必须相同(鞋品除外)，相同尺码要有一样的箱规
													<br/>5、同一款中，不同货号，相同尺码要有一样的装箱量，所以也要保证同一款，不同货号，相同尺码的要有一样的装箱量
													<br/>6、导入装箱量时，如果一个货号对应的所有尺码都是一样的‘箱规’、‘装箱量’，在导入表格中可只填写一行，并在‘网络值’一列录入 *  ，并维护好其他列信息，则系统自动将该货号所有尺码都维护成一样的’箱规‘，’装箱量’,如果有一个尺码的‘箱规’、‘装箱量’不一样，将该尺码数据放*数据行后面，系统自动将之前数据覆盖
													<br/>7、服装和配件sku重量必填，单位为kg,维护数据最多只能保留两位小数且不要带单位
						</div>
						<div class="alert alert-info" id="requirement"
							style="margin-bottom: 0px;text-align: right;disaply:inline;">
							<form id='fileUpload' action="<%=basePath %>print/uploadExcel" enctype='multipart/form-data' method='post'>
<!-- 								<a href="<%=basePath%>file/Box_PackNumTemplate.xlsx">模板下载</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
								<button class='btn btn-xs btn-yellow' onclick="return exportExcel();">下载模板数据</button>&nbsp;&nbsp;&nbsp;
								<input id='excelFile' name='file' type='file' class="btn btn-xs btn-yellow" style="display:inline;width:300px;m"/>
							&nbsp;&nbsp;<label class="form-field-select-3"
								for="form-field-1">覆盖上传</label> <label> <input
								name="switch-field-2" class="ace ace-switch ace-switch-7"
								type="checkbox" id="update"/> <span class="lbl"></span>
							</label>&nbsp;&nbsp;
								<button class='btn btn-xs btn-yellow' type="button" onclick="uploadExcel()">上传EXCEL</button>
							</form>
						</div>						
						<div class="col-xs-12" style="padding-left:0px;">
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
				<!-- /.main-container -->

			</div>
		</div>
	</div>

	<!-- inline scripts related to this page -->

	<script type="text/javascript">
	
			function exportExcel() {
					//获取grid参数
					var url1=$(grid_selector).jqGrid('getGridParam', 'url');
					var timestamp = Date.parse(new Date());
// 					设定grid参数
					$(grid_selector).jqGrid('setGridParam', {url:basePath + "print/exportUploadBasicExcel"});
					var postData= {fileName:timestamp};
					$(grid_selector).jqGrid('setGridParam',{postData:postData});
// 					重新发送请求到后台
					$(grid_selector)[0].triggerToolbar();
					
					$(grid_selector).jqGrid('setGridParam', {url:url1});
					window.open(basePath + "common/downloadFile?fileName=detailExcelExport\\"+timestamp+".xlsx","_blank");
					return false;
			}
	

			 function uploadExcel(){
			       var excelFile = $("#excelFile").val();
			       if(excelFile=='') {
						alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择上传EXCEL文件!");
						return false;
			    	}else  if(excelFile.indexOf('.xlsx')==-1){
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","文件格式不正确，请选择正确的Excel文件(后缀名.xlxs)！");
						return false;
			    	}else 
			    	{
			    		var url=basePath+"print/uploadExcel";
			    		if($("#update").is(':checked'))
		    			{
		    				url=url+"?update=true";
		    			}
			    		var formData = new FormData($("#fileUpload")[0]);
			    		$.ajax({
			    		     url : url,
			    		     type: 'POST',
			    		     data: formData,
			    		     async: true,
			    		     cache: false,
			    		     contentType: false,
			    		     processData: false,
							 dataType : "json",
							 success : function(data) {
								$.each(data, function(id, item) {
									if(id=="message")
									{
										if (item == "success") {
											alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","已导入相关数据！");
										} else if (item == "error") {
											alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","确认导入的货品是否已经生成过箱码或箱贴！");
										}
									}else if(id=="res")
									{
										alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","上传excel文件中第"+item+"行导入失败！");
									}else if(id=="update")
									{
										alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告",item+";如果要覆盖之前已维护（不包含已使用）的数据，请选择‘覆盖上传’为‘是’。");
									}
								});
							},
							error : function(jqXHR, textStatus, errorThrown) {
								alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
							}
			    		});
			    	}
			 }
			 
			 function formatUploadStatus(cellvalue)
			 {
				 if(cellvalue==-1)
					 return "未维护";
				 else if(cellvalue==0)
					 return "已维护";
				 else if(cellvalue==1)
				 	return "已使用";
				 else
					 return "未维护";
			 }
			
			jQuery(function($) {
				//注意每个页面都要在“jQuery(function($) {”加入如下resize function
				 jQuery("#breadcrumbs").resize(function(){
						jQuery("#grid-table").setGridWidth(jQuery("#breadcrumbs").width()-18);
						jQuery("#requirement").width(jQuery("#breadcrumbs").width()-50);
				  }); 
				jQuery("#requirement").width(jQuery("#breadcrumbs").width()-72);
				//增加select
				 
				//判断管理员跟供应商，设定不同功能按钮
				//var btnStr="<div class='widget-main'><input type='file' id='id-input-file-2' /></div>";
				//var btnStr="<button class='btn btn-xs btn-yellow' onclick='synPrintOrder()'>同步箱码订单</button>&nbsp;&nbsp;<button class='btn btn-xs btn-yellow'  onclick='synDetail()'>同步明细</button>";
				jQuery(grid_selector).jqGrid({
					url:basePath+"print/listPacknumAndBox",
					datatype: "json",
					height:350,
					colNames:['ID','种类','订单号','供应商号','货号/物料号','网络值', '交货日期','导入装箱量', '导入箱规','导入整箱重量（kg）','导入SKU重量（kg）','导入日期','维护状态','导入人'],
					colModel:[
						{name:'id',index:'id',  sorttype:"int", editable:false,hidden:true},
						{name:'typeName',index:'typeName',sortable:true,editable:false,stype:"select",searchoptions:{sopt:["eq"],
							value:"-99:全部;服装:服装;鞋类:鞋类;配件:配件;通用:通用;广宣用品:广宣用品;服材:服材;鞋材:鞋材;其它:其它"}},
						{name:'EBELN',index:'EBELN',  editable:true, searchoptions: {sopt: ['in']}},
						{name:'providerCode',index:'providerCode', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'MATNR',index:'MATNR', editable:true,searchoptions: {sopt: ['cn']}},
						{name:'SIZENum',index:'SIZENum', search:true,searchoptions: {sopt: ['eq']},editable:false},
						{name:'WEBAZ',index:'WEBAZ', search:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},editable:false,formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'zcarvol',index:'zcarvol', search:true,editable:false,searchoptions: {sopt: ['eq']}},
						{name:'selfBoxName',index:'selfBoxName', search:true,editable:false,searchoptions: {sopt: ['eq']}},
						{name:'weight',index:'weight', search:true,editable:false,searchoptions: {sopt: ['ge']}},
						{name:'skuweight',index:'skuweight', search:true,editable:false,searchoptions: {sopt: ['ge']}},
						{name:'uploadDate',index:'uploadDate', sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'uploadStatus',index:'uploadStatus',sortable:true,editable:false,formatter:formatUploadStatus,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;-1:未维护;0:已维护;1:已使用 "}},
						{name:'uploader',index:'uploader', search:true,editable:false,searchoptions: {sopt: ['eq']}}
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
			
// 					caption: btnStr,//表格前头设值
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
				)
			
			
				
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