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
						<li class="active"> 菜单列表</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger hidden" role="alert">
							<strong>提示标题：</strong>具体提示信息
						</div>
						<div class="alert alert-info" id="conditionDiv"
							style="margin-bottom: 0px;">
							<label for="form-field-select-3">餐厅选择:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="餐厅选择" id="diningRoom">
								<option value="null">   </option>
								<c:forEach items="${diningRooms}" var="diningRoom">
									<option value="${diningRoom.id}">${diningRoom.name}</option>
								</c:forEach>
							</select> &nbsp;&nbsp;
							<label for="form-field-select-3">用餐时段:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="用餐时段" id="mealType">
								<option value="null">   </option>
								<c:forEach items="${mealTypes}" var="mealType">
									<option value="${mealType}">${mealType.getText()}</option>
								</c:forEach>
							</select> &nbsp;&nbsp;
							<label for="form-field-select-3">用餐日期:</label>
								<input id="dayDate" type="text" data-date-format="yyyy-mm-dd"
									placeholder="日期：yyyy-mm-dd"/>&nbsp;&nbsp;
							<button type="button" class="btn btn-sm btn-success"
								onclick="checkAndCreateMeal()">
								加入餐单 <i class="icon-arrow-right icon-on-right bigger-110"></i>
							</button>
							</br>
						</div>
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

				<!-- /.main-container -->
			</div>
		</div>
	</div>
	<!-- inline scripts related to this page -->

	<script type="text/javascript">
			var rowIds="";
			var typeStr="";
			var editTypeStr="";
			
			
			 function checkAndCreateMeal()
			 {
				 rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				 if(rowIds=="")
				 {
					 alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择菜单!");
					 return false;
				 }
				 if($("#diningRoom").val()=="null")
				 {
					 alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择餐厅!"); 
					 return false;
				 }
				 
				 if($("#mealType").val()=="null")
				 {
					 alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择用餐时段!"); 
					 return false;
				 }
				 if($("#dayDate").val()=="null"||$.trim($("#dayDate").val())=="")
				 {
					 alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择用餐日期!"); 
					 return false;
				 }
				 
				 var DATE_FORMAT = /^[0-9]{4}-[0-1]?[0-9]{1}-[0-3]?[0-9]{1}$/;
				 var dayDate = $.trim($("#dayDate").val());
			 	 if(!DATE_FORMAT.test(dayDate)){
				  	alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","日期格式用误!");
				  	return false;
			   	 }
				 
				 createMeal();
			 }
			 
				function createMeal()
				{
					$.ajax({
						url : basePath + "menu/createMeal/",
						method : "post",
						data : {
							Ids : rowIds,
							dingRoomId:$("#diningRoom").val(),
							mealTypeStr:$("#mealType").val(),
							dayDate:$("#dayDate").val()
						},
						dataType : "json",
						success : function(data) {
							$.each(data, function(id, item) {
								if (item == "success") {
									//$("input[class='cbox']").removeAttr("checked");
									alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","所选择的菜单已加入指定餐单！");
									//location.reload();
									//重新加载数据
									$(grid_selector).trigger("reloadGrid");
								} else {
										alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","菜单加入餐单失败");
//	 									$("input[class='cbox']").removeAttr("checked");
//	 									$("#cb_grid-table").attr("checked","checked");
//	 									$("#cb_grid-table").removeAttr("checked");
								}
								rowIds="";
							});
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
						}
					});
				}
			 
			 function formatStatus(cellvalue)
			 {
				 if(cellvalue=="-1")
					 return "无效";
				 else if(cellvalue=="0")
					 return "有效";
			 }
			 
			 function formatterImg(cellvalue)
			 {
				 if(cellvalue==undefined||cellvalue=="undefined")
				 {
				 	return  "";
				 }
				 return "<img src='<%=basePath%>uploadMenu/"+cellvalue+"' style='width:225px;height:200px;' />";
			 }
			 
			$('#dayDate').datepicker({autoclose:true}).next().on(ace.click_event, function(){
				$(this).prev().focus();
			});
			
			jQuery(function($) {
				//注意每个页面都要在“jQuery(function($) {”加入如下resize function
				 jQuery("#breadcrumbs").resize(function(){
						jQuery("#grid-table").setGridWidth(jQuery("#breadcrumbs").width()-18);
				  }); 
				
				 jQuery(".chosen-select").chosen();
				 
				 
				 if(typeStr=="")
				{
					 
					 var array = new Array();  
					 <c:forEach items="${types}" var="t">  
					 array.push('${t.id}'+":"+'${t.name}'+";"); //js中可以使用此标签，将EL表达式中的值push到数组中  
					 </c:forEach>  
					 for(var i=0;i<array.length;i++)  
					 {  
						 typeStr=typeStr+array[i];
					 }
					 editTypeStr=typeStr.substring(0,typeStr.length-1);
					 typeStr="-99:全部;"+typeStr.substring(0,typeStr.length-1);
				}
				
				jQuery(grid_selector).jqGrid({
					url:basePath+"menu/listMenu",
					datatype: "json",
					height:600,
					colNames:['ID','分类','菜名', '图片', '更新人','更新时间','状态','备注'],
					colModel:[
						{name:'id',index:'id',  sorttype:"int", editable:false,hidden:true},
						{name:'type_name',index:'type_name',sortable:false,
							stype:"select",
							searchoptions:{sopt:["eq"],value:typeStr},
							editable:true,
							edittype:"select",
							editoptions:{value:editTypeStr}
						},
						{name:'name',index:'name',editable:true,searchoptions: {sopt: ['cn']}},
						{name:'picture',index:'picture',width:230,editable:false,search:false,formatter:formatterImg},
						{name:'updater',index:'updater',  editable:false,searchoptions: {sopt: ['cn']}},
						{name:'updateDate',index:'updateDate', sorttype:"date", editable:false,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'status',index:'status',sortable:false,
							formatter:formatStatus,
							stype:"select",
							searchoptions:{sopt:["eq"],value:"-99:全部;-1:无效;0:有效 "},
							editable:true,
							edittype:"select",
							editoptions:{value:"0:有效;-1:无效"}
						},
						{name:'remark',index:'remark',editable:true,searchoptions: {sopt: ['cn']}}
					], 
			
					viewrecords : true,
					rowNum:300,
					multiselect: true,
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
			
					editurl: basePath+"menu/saveOrUpdateMenu",//新增，修改，删除所提交的路径，根据不动页面设置 不同值，有可能要动态来改变，达到操作需求
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
						edit: true,
						editicon : 'icon-pencil blue',
						add: false,
						addicon : 'icon-plus-sign purple',
						del: true,
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
							$("#name").attr("disabled","disabled");
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
							console.log(1);
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
				
				function afterDeleteCallback(e){
					//$(grid_selector).jqGrid('setCell',rowid,icol,data); 
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