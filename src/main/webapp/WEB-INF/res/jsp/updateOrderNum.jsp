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
						<li class="active">实际下单量调整</li>
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
							<button type="button" class="btn btn-sm btn-success"
								onclick="check()">
								保存修改 <i class="icon-arrow-right icon-on-right bigger-110"></i>
							</button>
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
								<h4 class="modal-title" id="myModalLabel">确认修改下单量</h4>
							</div>
							<div class="modal-body" id="messageTip">
								实际下单量调整后，对应数据行的状态有可能产生变化？</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">关闭</button>
								<button type="button" class="btn btn-primary" id="create"
									onclick="updateOrderNum();">修改下单量</button>
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
			var rowIds="";
			var values=new Array(10);
							
			function check()
			{
				rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				if(rowIds=="")
				{
					//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择操作订单!");
					return false;
				}
				
				for(var i=0;i<rowIds.length;i++)
				{
					values[i]=$(grid_selector).jqGrid('getRowData', rowIds[i]).updateOrderNum;
					console.log(values[i]);
				}
				
				closeAlertMsg();
				$('#confirmModal').modal('show');
			}
			
			function updateOrderNum()
			{
				//隐藏对话框
				$("#confirmModal").modal('hide');
				$.ajax({
					url : basePath + "print/toChangeOrderNum/",
					method : "post",
					data : {
						rowIds : rowIds,
						values:values
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if (item == "success") {
								//$("input[class='cbox']").removeAttr("checked");
								alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","修改实际下单量成功！");
								//location.reload();
								//重新加载数据
								$(grid_selector).trigger("reloadGrid");
							} else {
									alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","修改实际下单量失败！");//现阶段只支持鞋、服、配的 整箱箱码及鞋类尾箱的箱码！
// 									$("input[class='cbox']").removeAttr("checked");
// 									$("#cb_grid-table").attr("checked","checked");
// 									$("#cb_grid-table").removeAttr("checked");
							}
							rowIds="";
							values=new Array(10);
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
					}
				});
			}
			
			
            function myelem (value, options) {
                var el = document.createElement("input");
                el.type="text";
                el.value = value;
                return el;
              }
               
              //获取值
              function myvalue(elem) {
                return $(elem).val();
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
				 else
					 return cellvalue;
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
					url:basePath+"print/updateOrderNum",
					datatype: "json",
					height:350,
					shrinkToFit:false,
					colNames:['ID',
					          '供应商号',
					          '订单状态',
					          '种类',
					          '品牌',
					          '是否直配',
					          '采购订单',
					          '季度',
					          '款号',
					          '货号/物料号',
					          '网络值',
					          '颜色',
					          '品名/物料名称',
					          '交货日期',
					          'SAP下单数量',
					          '现下单数量',
					          '调整下单数量',
					          '剩余量',
					          '整箱装箱量',
					          '整箱箱规',
					          '订单行项目',
					          '导入装箱量',
					          '导入箱规',
					          '导入重量',
					          '国家',
					          '单品条码',
					          '执行标准',
					          '创建日期',
					          '订单单位',
					          '主网格',
					          '计划行',
					          '网格值描述',
					          '下单单品数量',					          
					          '面料',
					          '底料'
					          ],
					colModel:[
						{name:'id',index:'id',  sorttype:"int", editable:false,hidden:true},
						{name:'providerCode',index:'providerCode',width:100, editable:false,searchoptions: {sopt: ['in']}},
						{name:'orderDetailStatus',index:'orderDetailStatus',width:70,sortable:false,editable:false,formatter:formatOrderStatus,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;-1:失效;0:有效;1:有更新;2:有生成 ;3:已生成"}},//;3:已生成
						{name:'typeName',index:'typeName',sortable:false,width:70,editable:false,stype:"select",searchoptions:{sopt:["eq"],
							value:"-99:全部;服装:服装;鞋类:鞋类;配件:配件;通用:通用;广宣用品:广宣用品;服材:服材;鞋材:鞋材;其它:其它"}},
						{name : 'brandName',index : 'brandName',sortable : false,width:70,editable : false,stype : "select",	searchoptions : { sopt : [ "eq" ],
							value : "-99:全部;大货:大货;海外:海外;赞助:赞助;FILA-大货:FILA-大货;运动生活:运动生活;儿童:儿童;店铺形象物品:店铺形象物品;鞋材辅材:鞋材辅材;广宣用品:广宣用品;电商:电商;NBA大货:NBA大货;NBA儿童:NBA儿童;原材料:原材料;半成品:半成品;易耗品:易耗品;模具:模具;虚拟物料:虚拟物料;FILA-广宣用品:FILA-广宣用品;FILA-儿童:FILA-儿童;FILA-赞助:FILA-赞助"}},
						{name : 'MixFlag',index : 'MixFlag',editable : false,width:100,stype : "select",searchoptions : {sopt : [ "eq" ],value : "-99:全部;门店直配:门店直配;非门店直配:非门店直配;总部电商:总部电商"}},
						{name:'EBELN',index:'EBELN',  editable:false,width:100, searchoptions: {sopt: ['in']}},
						{name :'ZDHHBH',index : 'ZDHHBH',width:100,editable : false,searchoptions : {sopt : [ 'cn' ]}},
						{name :'productCode',index : 'productCode',width:100,editable : false,searchoptions : {sopt : [ 'cn' ]}},
						{name:'MATNR',index:'MATNR', editable:false,width:100,searchoptions: {sopt: ['in']}},
						{name:'SIZENum',index:'SIZENum', search:true,width:70,searchoptions: {sopt: ['eq']},editable:false},
						{name:'zcolor',index:'zcolor', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}},
						{name:'stock_name',index:'stock_name', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}},
						{name:'WEBAZ',index:'WEBAZ', width:100,sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'ETMNG1',index:'ETMNG1', search:true,width:70,searchoptions: {sopt: ['ge']},editable:false},
						{name:'ETMNG',index:'ETMNG', search:true,width:70,searchoptions: {sopt: ['ge']},editable:false},
						{name:'updateOrderNum',index:'updateOrderNum',search:false,width:100, editable:true, edittype:'custom', editoptions:{custom_element: myelem, custom_value:myvalue},editrules:{required:true,integer:true} },
						{name:'allowance',index:'allowance', editable:false,width:50,search:true,searchoptions: {sopt: ['ge']}},
						{name:'packNum',index:'packNum',  sorttype:"int",width:70, editable:false,searchoptions: {sopt: ['eq']}},
						{name:'boxName',index:'boxName',  editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'EBELP',index:'EBELP', search:true,width:100,searchoptions: {sopt: ['cn']},editable:false},
						{name:'zcarvol',index:'zcarvol', search:true,editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'selfBoxName',index:'selfBoxName', search:true,editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'weight',index:'weight', editable:false,search:true,width:100,searchoptions: {sopt: ['ge']}},
						{name : 'CNAME',index : 'CNAME',editable : false,width:100,hidden : false,searchoptions : {sopt : [ 'eq' ]}},
						{name : 'eanGoodCode',index : 'eanGoodCode',editable : false,width:100,hidden : false,searchoptions : {sopt : [ 'in' ]}},
						{name:'zzxbz',index:'zzxbz', search:true,editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'createDate',index:'createDate', width:100,sorttype:"date", editable:true,searchoptions: {dataInit:datePick,sopt: ['eq','le','ge'],attr:{title:"选择日期"}},formatter:'date',
							formatoptions:{srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d'}},
						{name:'ETMIN',index:'ETMIN',search:true,width:100,searchoptions: {sopt: ['cn']}, editable:false},
						{name:'J_3AMGNR',index:'J_3AMGNR', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}},
						{name:'ETENR',index:'ETENR', search:true,width:100,searchoptions: {sopt: ['cn']},editable:false},
						{name:'ATWTB',index:'ATWTB', search:true,width:70,searchoptions: {sopt: ['eq']},editable:false},
						{name:'JHMNG',index:'JHMNG', search:true,width:70,searchoptions: {sopt: ['ge']},editable:false},
						{name:'zfabric',index:'zfabric', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}},
						{name:'zsureface',index:'zsureface', search:true,width:100,editable:false,searchoptions: {sopt: ['cn']}}
					], 
			
					viewrecords : true,
					rowNum:300,
					forceFit : true,
					cellEdit:true,
					cellsubmit: 'clientArray',
				    afterSaveCell : function(rowid,name,val,iRow,iCol) {
				    	var allowance=parseInt($(grid_selector).jqGrid('getRowData', rowid).allowance);
				    	var ETMNG=parseInt($(grid_selector).jqGrid('getRowData', rowid).ETMNG);
						if(val<(ETMNG-allowance))
						{
							$(grid_selector).setCell(rowid, 'updateOrderNum', ETMNG);
						}
				     },
					multiselect: true,
					rowList:[300,400,500],
					pager : pager_selector,
					altRows: true,
					footerrow:true,
					onSelectRow: function (rowId, status, e) {//勾选时要执行的方法
						closeAlertMsg();
						if (status) {
							if($("#pateType").val()=="Standard")
							{	
								var num = $(grid_selector).jqGrid(
										'getRowData', rowId).packNum;
								var boxName=$(grid_selector).jqGrid(
										'getRowData', rowId).boxName;
								if (num > 0) {
									$("#packNum").val(num);
									$("#packNum").attr("disabled",true); 
								} else {
									$("#packNum").attr("disabled",false);
									$("#packNum").val("");
								}
								
								if(boxName!="")
								{
									$($(".chosen-single span")[0]).html(boxName);
									$("#boxes option:contains('"+boxName+"')").attr("selected", true);
									//$("#boxes").val(1);
									//$("#boxes").find("option[text='"+boxName+"']").attr("selected",true);
								}else
								{
									$($(".chosen-single span")[0]).html("<span>箱规选择</span>");
								}
							}
							zcarvol=$(grid_selector).jqGrid(
									'getRowData', rowId).zcarvol;
						}
					},	
					onPaging:function(){//翻页时要执行的方法
						 $(grid_selector).jqGrid('setGridParam', {_search:false});//如果是翻页，则置标识，该操作不是新的查询动作
					},
					gridComplete:function(){
			            var rowNum=parseInt($(this).getGridParam("records"),10);
			            if(rowNum>0){
			                $(".ui-jqgrid-sdiv").show();
			                var ETMNG=$(this).getCol("ETMNG",false,"sum");
			                var allowance=$(this).getCol("allowance",false,"sum");
			                var JHMNG=$(this).getCol("JHMNG",false,"sum");
			                $(this).footerData("set",{"providerCode":"单页合计","allowance":allowance,"ETMNG":ETMNG,"JHMNG":JHMNG});                               //将合计值显示出来
			            }else{
			                $(".ui-jqgrid-sdiv").hide();
			            }
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
					shrinkToFit:false,
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