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
						<li class="active">尾箱、配件混款混色手动快捷处理</li>
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
							<label for="form-field-select-3">箱规选择:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="箱规选择" id="boxes">
								<option value="null">   </option>
								<c:forEach items="${boxes}" var="box">
									<option value="${box.id}">${box.name}</option>
								</c:forEach>
							</select> &nbsp;&nbsp; <label class="form-field-select-3"
								for="form-field-1">装箱量:</label> <input type="text" id="packNum" onblur="validateNum();"
								placeholder="请录入整数" title="没手动录入数字情况下，以导入的装箱量进行装箱!" />
							&nbsp;&nbsp; <label for="form-field-select-3">箱贴类型:</label> <select
								class="chosen-select" style="width:180px;" onchange="switchSelect()"
								data-placeholder="箱贴类型" id="pateType">
<!-- 								<option value="Standard">整箱箱码</option> -->
								<option value="Remainder">尾箱（或拼装箱）箱码</option>
								<option value="Mix">配件混款混色箱码</option>
								<option value="MixOfShoes">鞋类混款混色箱码</option>
							</select>&nbsp;&nbsp;
							<button type="button" class="btn btn-sm btn-success"
								onclick="checkAndCreateBarCodes()">
								生成箱码 <i class="icon-arrow-right icon-on-right bigger-110"></i>
							</button>
<!-- 							&nbsp;&nbsp; -->
<!-- 							<button class="btn btn-sm btn-info" type="button" -->
<!-- 								onclick="checkAndCreatePates();"> -->
<!-- 								<i class="icon-ok bigger-110"></i> 生成箱贴 -->
<!-- 							</button> -->
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
								<h4 class="modal-title" id="myModalLabel">确认生成箱贴</h4>
							</div>
							<div class="modal-body" id="messageTip">
								生成箱贴后，所选数据行不能再生成箱码，确认生成箱贴？</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">关闭</button>
								<button type="button" class="btn btn-primary" id="create"
									onclick="createCodesOrPates();">生成箱贴</button>
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
			var idTmr = "";
			var rowIds="";
			var statusFlag1=false;//记录是否选择了有生成的数据
			
			var zcarvol = ""//自带箱规装箱量
			var allowance=0;//所选货品的总余量
			var boxNum=0;//一次添加货品可生成箱贴的数量
			var typeName="";//记录所选择的种类
			var prePackNum=",";//记录各数据行分配的‘处理数量’
			var grid="";//记录所选主网格
			
			function switchSelect(obj) {
				//$(grid_selector).jqGrid('resetSelection');
				$("#packNum").val("");
				$("#packNum").attr("disabled",false); 
			}
			
			function validateNum()
			{
				if(isNaN($("#packNum").val())||$("#packNum").val()=="0")
				{
					$("#packNum").val("");
					$("#packNum").focus();
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请输入非0整数！");
					return false;
				}
				
				closeAlertMsg();
			}
			
			function createCodesOrPates()
			{
				//隐藏对话框
				$("#confirmModal").modal('hide');
				
				if($("#create").html()=="生成箱贴")
				{
					createPates();
				}else
				{
					createBarCodes();
				}
			}
			
			function showModal(obj)
			{
				if(obj=='boxpate')
				{
					$("#myModalLabel").html("确认生成箱贴");
					var str=""
						if($("#boxes").val()==null||$("#boxes").val()=="null")
						{
							str="确认选定的数据行将用各自<font color='red'>‘导入的箱规’</font>，";
						}else
						{
							str="确认选定的数据行将用选择的箱规<font color='red'>‘"+$("#boxes  option:selected").text()+"’</font>，";
						}
						
						if($.trim($("#packNum").val())=="")
						{
							str=str+"并用各自<font color='red'>‘导入的装箱量’</font>进行生成<font color='red'>‘"+$("#pateType  option:selected").text()+"’</font>？生成箱贴后，所选数据行<font color='red'>不能</font>再生成箱码，确认生成箱贴？";
						}else
						{
							str=str+"并用设定的装箱量<font color='red'>‘"+$("#packNum").val()+"’</font>进行生成<font color='red'>‘"+$("#pateType  option:selected").text()+"’</font>？生成箱贴后，所选数据行<font color='red'>不能</font>再生成箱码，确认生成箱贴？";
						}
					$("#messageTip").html(str);
					$("#create").html("生成箱贴");
				}else
				{
					$("#myModalLabel").html("确认生成箱码");
					var str=""
					if($("#boxes").val()==null||$("#boxes").val()=="null")
					{
						str="确认选定的数据行将用各自<font color='red'>‘导入的箱规’</font>，";
					}else
					{
						str="确认选定的数据行将用选择的箱规<font color='red'>‘"+$("#boxes  option:selected").text()+"’</font>，";
					}
					
					if($.trim($("#packNum").val())=="")
					{
						str=str+"并用各自<font color='red'>‘导入的装箱量’</font>进行生成<font color='red'>‘"+$("#pateType  option:selected").text()+"’</font>？";
					}else
					{
						str=str+"并用设定的装箱量<font color='red'>‘"+$("#packNum").val()+"’</font>进行生成<font color='red'>‘"+$("#pateType  option:selected").text()+"’</font>？";
					}
					$("#messageTip").html(str);
					$("#create").html("生成箱码");
				}
				$('#confirmModal').modal('show');
			}
			
			function checkAndCreateBarCodes()
			{
				if(!check())
					return false;
				closeAlertMsg();
				showModal('barcode');
			}
			
			function checkAndCreatePates()
			{

				if(!check())
					return false;
				
// 				if(statusFlag1)
// 				{
// 					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","提前生成箱贴只能勾选状态为‘有效’的数据！！！");
// 					return false;
// 				}
				closeAlertMsg();
				showModal('boxpate');
			}
					
			function check()
			{
				rowIds=$(grid_selector).jqGrid('getGridParam', 'selarrrow');
				if(rowIds=="")
				{
					//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
					alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择操作订单!");
					return false;
				}
				
				var zcarvolFlag=false;//有数据行没有默认装箱量标示
				var selfBoxNameFlag=false;//有数据行没有默认箱规标示
				var matnrFlag=false;//数据行不同货号标示
				var ebelnFlag=false;//数据行不同订单标示
				var statusFlag=false;//数据行含非有效、有生成标示外的数据
				statusFlag1=false;// 提前生成箱贴的只能选择有效数据，该变量记录所选数据是否包含‘有生成’数据
				var boxFlag=false;//数据行是否含有含以箱为单位的数据
				var etminFlag=false;//数据行是否混合了不同单位的数据
				var product=false;//数据行是否混合了不同单位的款号
				var mixType=false;//数据行是否混合了不同种类的数据
				var mixGrid=false;//配件是否混合了配码与不配码情况
				var girdType=false;//配件是否要按码处理
				var cnameFlag=false;//是否混国家

				var matnrNum=0;//记录所选择数据行包含了多少个货号
				var sizeNum1=0;
				var sizeNum2=0;
				var sizeNum3=0;
				
				var sumval=0;
				
				typeName="";
				var matnr="";
				var ebeln="";
				var etmin="";
				var matnrStr="";
				var sizeStr1="";
				var sizeStr2="";
				var sizeStr3="";
				var productStr="";
				prePackNum=",";
				grid="";
				var cname="";

				var matnrSizeNum=0;//记录所选数据行包含了多少货号+尺码为基准的行
				var matnrSizeStr="";
				
				for(var i=0;i<rowIds.length;i++)
				{
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).allowance!=0)
					{
						allowance=allowance+$(grid_selector).jqGrid('getRowData', rowIds[i]).allowance;
					}
					
					sumval=sumval+parseInt($(grid_selector).jqGrid('getRowData', rowIds[i]).perPackNum);
					prePackNum=prePackNum+rowIds[i]+":"+$(grid_selector).jqGrid('getRowData', rowIds[i]).perPackNum+",";
					
					if(i==0)
					{
						matnr=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR;
						ebeln=$(grid_selector).jqGrid('getRowData', rowIds[i]).EBELN;
						etmin=$(grid_selector).jqGrid('getRowData', rowIds[i]).ETMIN;
						matnrStr=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+",";
						typeName=$(grid_selector).jqGrid('getRowData', rowIds[i]).typeName;
						grid=$(grid_selector).jqGrid('getRowData', rowIds[i]).J_3AMGNR;
						cname=$(grid_selector).jqGrid('getRowData', rowIds[i]).CNAME;
						matnrNum=1;
						matnrSizeNum=1;
						sizeNum1=1;
						productStr=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR.split("-")[0]+"-";
						sizeStr1=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
						matnrSizeStr=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).typeName!=typeName)//数据行出现不同种类的数据
					{
						mixType=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).J_3AMGNR!=grid)//数据行出现主网格的数据
					{
						mixGrid=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).ETMIN!=etmin)//数据行出现不同单位的数据
					{
						etminFlag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR.indexOf(productStr)<0)//数据行出现不同款号的数据
					{
						product=true;
					}
					
					
					//数据行勾选了有效、有生成之外的数据
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).orderDetailStatus!="有效" && $(grid_selector).jqGrid('getRowData', rowIds[i]).orderDetailStatus!="有生成")
					{
						statusFlag=true;
					}
// 					else if($(grid_selector).jqGrid('getRowData', rowIds[i]).orderDetailStatus=="有生成")
// 					{
// 						statusFlag1=true;
// 					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).CNAME!=cname)//数据行包含不同国家
					{
						cnameFlag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).EBELN!=ebeln)//数据行包含不同订单
					{
						ebelnFlag=true;
					}
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).zcarvol=="")//数据行包含 导入装箱量为空的数据行
					{
						zcarvolFlag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).selfBoxName=="")//数据行包含 导入箱规为空的数据行
					{
						selfBoxNameFlag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).ETMIN=="KAR")//数据行包含了以箱为单位的数据
					{
						boxFlag=true;
					}
					
					if($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR!=matnr)//计算数据行有多个货号 及记录前三个货号的 尺码范围
					{
						matnrFlag=true;
						if(matnrStr.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR)<0)//未包含该货号
						{
							matnrStr=matnrStr+$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+",";
							matnrNum++;
							if(sizeNum2==0)
							{
								sizeNum2=1;
								sizeStr2=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
							}
							if(sizeNum3==0)
							{
								sizeNum3=1;
								sizeStr3=$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
							}
						}else if(matnrNum<4)//货号种类未超过三个
						{
							if(sizeStr1.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR)>=0)
							{
								if(sizeStr1.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",")<0)
								{
									sizeStr1=sizeStr1+$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
									sizeNum1++;
								}
							}else	if(sizeStr2.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR)>=0)
							{
								if(sizeStr2.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",")<0)
								{
									sizeStr2=sizeStr2+$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
									sizeNum2++;
								}
							}else  if(sizeStr3.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR)>=0)
							{
								if(sizeStr3.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",")<0)
								{
									sizeStr3=sizeStr3+$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
									sizeNum3++;
								}
							}
						}
					}

					//计算货号+尺码为基准的记录数
					if(matnrSizeStr.indexOf($(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",")<0)
					{
						matnrSizeStr=matnrSizeStr+$(grid_selector).jqGrid('getRowData', rowIds[i]).MATNR+"-"+$(grid_selector).jqGrid('getRowData', rowIds[i]).SIZENum+",";
						matnrSizeNum++;
					}
				}
				
				if(typeName!="配件"&&$("#pateType").val()=="Mix")
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","‘服装’或‘鞋类’不可选择‘配件混款混色’！");
					return false;
				}

				if(typeName!="鞋类"&&$("#pateType").val()=="MixOfShoes")
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","‘服装’或‘配件’不可选择‘鞋类混款混色’！");
					return false;
				}
				
				if(statusFlag)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选择'有效'或'有生成'数据！");
					return false;
				}
				
				if($("#pateType").val()!="Standard")//非整箱箱情况处理
				{
					if($("#boxes").val()==null||$("#boxes").val()=="null")
					{
						//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选择箱规或先到‘箱规列表’页面添加箱规！");
						return false;
					}
					
					if(ebelnFlag)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","尾箱、直配混款混色箱请选择同一订单数据");
						return false;
					}
					if(boxFlag)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","尾箱、直配混款混色箱不能选择以‘箱’为订单单位的数据");
						return false;
					}
// 					if(etminFlag)
// 					{
// 						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","所选择的数据行的订单单位不一致！");
// 						return false;
// 					}
					if($.trim($("#packNum").val())=="")
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请输入尾箱、直配混款混色箱的装箱量!");
						return false;
					}else if(sumval!=parseInt($.trim($("#packNum").val())))
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","所选择数据行的‘处理数量’之和与装箱量不同，请确认！");
						return false;
					}
				}else 
				{
					if($.trim($("#packNum").val())=="" && zcarvolFlag)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","所选择数据行有数据没有维护‘导入装箱量’，请输入装箱量或不要选中没有维护‘导入装箱量’的数据行!");
						return false;
					}
					
					if(($("#boxes").val()==null||$("#boxes").val()=="null")&&selfBoxNameFlag)
					{
						//显示提示信息参数分别表示：信息要显示的DIV对象，显示样式，消息标题，消息内容
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","所选择数据行有数据没有维护‘导入箱规’，请选择箱规或不要选中没有维护‘导入箱规’的数据行!");
						return false;
					}
				}
					
				if($("#pateType").val()=="Remainder")//如果是尾箱
				{
					if(mixType)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选中同一‘种类’的数据行！！！");
						return false;
					}
					
					if(cnameFlag)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选中同一‘国家’的数据行！！！");
						return false;
					}
					
					if(product)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","尾箱请选择同款货品！！！");
						return false;
					}
					
					if(typeName=="鞋类")
					{
						if(matnrNum>1)
						{
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","鞋类尾箱最多只能包含1个货号");
							return false;
						}else if(sizeNum1>8)
						{
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","鞋类尾箱最多只能包含1个货号8个尺码！！！");
							return false;
						}
					}
					
					if(typeName=="配件"&& mixGrid )
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","有尺码跟没尺码的数据行不能同时处理，即‘主网格’数据列要一致！");
						return false;
					}
					
					if(typeName=="配件"&& grid!="NO GRID")
					{
						girdType=true;
					}
					
					if(typeName=="服装"||girdType==true)
					{
						if(matnrNum>3)
						{
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","服装尾箱、有尺码配件最多只能包含3个货号！！！");
							return false;
						}else if(sizeNum1>9||sizeNum2>9||sizeNum3>9)
						{
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","服装尾箱、有尺码配件最多只能包含3个货号，各货号最多只能有9个尺码！！！");
							return false;
						}
					}
					
					if(typeName=="配件"&&girdType==false)
					{
						if(matnrNum>3)
						{
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","配件尾箱最多只能包含3个货号！！！");
							return false;
						}else if(sizeNum1>1||sizeNum2>1||sizeNum3>1)
						{
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","配件尾箱最多只能包含3个货号，各货号最多只能有1个尺码！！！");
							return false;
						}
					}

				}

				if($("#pateType").val()=="Mix")//如果是直配
				{
					if(mixType)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选中同一‘种类’的数据行！！！");
						return false;
					}
					
					if(cnameFlag)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选中同一‘国家’的数据行！！！");
						return false;
					}
					
					if(matnrNum>12)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","直配混款混色箱最多只能包含12个货号！！！");
						return false;
					}else if(sizeNum1>1||sizeNum2>1||sizeNum3>1)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","直配混款混色箱最多只能包含12个货号，各货号最多只能有1个尺码！！！");
						return false;
					}
				}

				if($("#pateType").val()=="MixOfShoes")//如果是鞋混款混色
				{
					if(mixType)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选中同一‘种类’的数据行！！！");
						return false;
					}

					if(cnameFlag)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","请选中同一‘国家’的数据行！！！");
						return false;
					}

					if(matnrSizeNum>12)
					{
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","鞋类混款混色箱最多只能包含12个货号加尺码！！！");
						return false;
					}
				}
				
				
				if($("#packNum").val()>0&&boxFlag)
				{
					boxNum=allowance;
				}else if($("#packNum").val()>0)
				{
					boxNum=allowance/$("#packNum").val();
				}else if($("#packNum").val().length==0&&zcarvol>0)
				{
					boxNum=allowance/zcarvol;
				}
					
				if(boxNum<1)
				{
					alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","错误","所选择数据行的总剩余量小于装箱量！！");
					return false;
				}
				
				return true;
			}
			
			function createBarCodes()
			{
				var pateType = $("#pateType").val();
				if(pateType == "MixOfShoes")
					pateType = "Mix";
				$.ajax({
					url : basePath + "print/createBoxPateCodes/",
					method : "post",
					data : {
						Ids : rowIds,
						boxId:$("#boxes").val(),
						packNum:$("#packNum").val(),
						pateType:pateType,
						typeName:typeName,
						prePackNum:prePackNum
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if (item == "success") {
								//$("input[class='cbox']").removeAttr("checked");
								alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","所选择的数据行符合条件的已经生成箱码！");
								//location.reload();
								//重新加载数据
								$(grid_selector).trigger("reloadGrid");
							} else {
									alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","‘剩余量’小于装箱量、或服装和配件的SKU重量未维护都会造成生成失败！");//现阶段只支持鞋、服、配的 整箱箱码及鞋类尾箱的箱码！
// 									$("input[class='cbox']").removeAttr("checked");
// 									$("#cb_grid-table").attr("checked","checked");
// 									$("#cb_grid-table").removeAttr("checked");
							}
							rowIds="";
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
					}
				});
			}
			
			function createPates()
			{
				$.ajax({
					url : basePath + "print/createPreBoxPates/",
					method : "post",
					data : {
						Ids : rowIds,
						boxId:$("#boxes").val(),
						packNum:$("#packNum").val(),
						pateType:$("#pateType").val(),
						typeName:typeName
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if(id=="message")
							{
								if (item == "success") {
									alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","所选择的数据行符合条件的已经生成箱贴！");
								} else if (item == "error") {
									alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","确认是否‘剩余量’小于装箱量也会造成生成失败！");
								}
							}else if(id=="res")
							{
								alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","所选择的数据行共生成了"+item+"个箱贴！");
								$(grid_selector).trigger("reloadGrid");
							}
							rowIds="";
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","访问服务器错误，请重新登录系统，如果还是报该错误，请联系管理员！！");
					}
				});
			}
			
			function Cleanup() {
				window.clearInterval(idTmr);
				CollectGarbage();
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
				 else
					 return cellvalue;
			 }
			 
			 function formatWorkStatus(cellvalue)
			 {
				 if(cellvalue==1)
					 return "作业中";
				 else
					 return "未作业";
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
					url:basePath+"print/quickRemainder",
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
					          '下单量',
					          '剩余量',
					          '整箱装箱量',
					          '处理数量',
					          '整箱箱规',
					          '订单行项目',
					          '导入装箱量',
					          '导入箱规',
					          '导入重量',
						      '导入SKU重量',
					          '国家',
					          '作业状态',
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
						{name:'orderDetailStatus',index:'orderDetailStatus',width:70,sortable:false,editable:false,formatter:formatOrderStatus,stype:"select",searchoptions:{sopt:["eq"],value:"-99:全部;-1:失效;0:有效;1:有更新;2:有生成 "}},//;3:已生成
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
						{name:'ETMNG',index:'ETMNG', search:true,width:70,searchoptions: {sopt: ['ge']},editable:false},
						{name:'allowance',index:'allowance', editable:false,width:50,search:true,searchoptions: {sopt: ['ge']}},
						{name:'packNum',index:'packNum',  sorttype:"int",width:70, editable:false,searchoptions: {sopt: ['eq']}},
						{name:'perPackNum',index:'perPackNum',search:false,sortable:false,width:70, editable:true, edittype:'custom', editoptions:{custom_element: myelem, custom_value:myvalue},editrules:{required:true,integer:true} },
						{name:'boxName',index:'boxName',  editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'EBELP',index:'EBELP', search:true,width:100,searchoptions: {sopt: ['cn']},editable:false},
						{name:'zcarvol',index:'zcarvol', search:true,editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'selfBoxName',index:'selfBoxName', search:true,editable:false,width:100,searchoptions: {sopt: ['cn']}},
						{name:'weight',index:'weight', editable:false,search:true,width:100,searchoptions: {sopt: ['ge']}},
						{name:'skuweight',index:'skuweight', editable:false,search:true,width:100,searchoptions: {sopt: ['ge']}},
						{name : 'CNAME',index : 'CNAME',editable : false,width:100,hidden : false,searchoptions : {sopt : [ 'eq' ]}},
						{name : 'workStatus',index : 'workStatus',editable : false,width:100,formatter:formatWorkStatus,stype : "select",searchoptions : {sopt : [ "eq" ],value : "-99:全部;-1:未作业;1:作业中"}},
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
						if(val>allowance||val<0)
						{
							$(grid_selector).setCell(rowid, 'perPackNum', allowance);;
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