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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=basePath%>assets/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="<%=basePath%>assets/css/datepicker.css" />
<script src="<%=basePath%>assets/js/jquery-2.0.3.min.js"></script>
<script src="<%=basePath%>assets/js/bootstrap.min.js"></script>
<script src="<%=basePath%>assets/js/ace-extra.min.js"></script>
<script
	src="<%=basePath%>assets/js/date-time/bootstrap-datepicker.min.js"></script>
</head>

<body style="text-align: center">
	<div class="main-container" id="main-container">
		<div class="main-container-inner">
			<a class="menu-toggler" id="menu-toggler" href="#"> <span
				class="menu-text"></span>
			</a>

			<div class="main-content" >
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger hidden" role="alert">
							<strong>提示标题：</strong>具体提示信息
						</div>
						<div class="alert alert-info" id="conditionDiv"	style="margin-bottom:0px;margin-right:0px;height:100% ; width:100%; position:absolute;">
							<label for="form-field-select-3">餐厅选择:</label> <select  onchange="checkIsBook()"
								class="chosen-select" style="width:180px;"
								data-placeholder="餐厅选择" id="diningRoom">
								<option value="null"></option>
								<c:forEach items="${diningRooms}" var="diningRoom">
									<option value="${diningRoom.id}">${diningRoom.name}</option>
								</c:forEach>
							</select></br>
							
							<label for="form-field-select-3">用餐时段:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="用餐时段" id="mealType" onchange="checkIsBook()">
								<option value="null"></option>
								<c:forEach items="${mealTypes}" var="mealType">
									<option value="${mealType}">${mealType.getText()}</option>
								</c:forEach>
							</select></br>
							
							<label for="form-field-select-3">用餐日期:</label> <input
								id="dayDate" type="text" data-date-format="yyyy-mm-dd"
								placeholder="yyyy-mm-dd 可不填" onchange="checkIsBook()"/>&nbsp;&nbsp;</br>
								
							<label for="form-field-select-3">用餐人数:</label> <input
								id="number" type="text" placeholder="用餐人数" onchange="checkIsBook()"/>&nbsp;&nbsp;</br></br>
							
							<a href="javascript:checkAndBookMeal()" id="book">预订用餐</a>
							<a href="javascript:cancelBook()" hidden="hidden" id="cancel">取消订餐</a>
							</br>
						</div>

						<!-- /.col -->
					</div>
					<!-- /.row -->
				</div>
			</div>
		</div>
	</div>
	<!-- inline scripts related to this page -->

	<script type="text/javascript">
			 var $ = jQuery.noConflict(); 
			 var basePath = "<%=basePath%>";
			 var datePick = function(elem)
			  {
					jQuery(elem).datepicker({format:'yyyy-mm-dd' , autoclose:true});
			  }
			 
			 function alertMsg(obj,clas,title,detail)
			 {
				 var str="<button type='button' class='close'  aria-hidden='true' onclick='closeAlertMsg()'> &times; </button>";
				 jQuery(obj).attr("class",clas).html(str+"<strong>"+title+":</strong>"+detail);
			 }
			 
			 function closeAlertMsg()
			 {
				 jQuery("#alertMsg").attr("class","hidden");
			 }
			 
			 function trimSpace(obj)
			{
				$(obj).val($.trim($(obj).val()));
			}
			
			 function checkIsBook()
			 {
				 if($("#diningRoom").val()=="null")
				 {
					 return false;
				 }
				 
				 if($("#mealType").val()=="null")
				 {
					 return false;
				 }
				 
				 
				 if($.trim($("#dayDate").val())=="")
				 {
					 return false;
				 }
				 
				 if($.trim($("#dayDate").val())!="")
				 {
					 var DATE_FORMAT = /^[0-9]{4}-[0-1]?[0-9]{1}-[0-3]?[0-9]{1}$/;
					 var dayDate = $.trim($("#dayDate").val());
				 	 if(!DATE_FORMAT.test(dayDate)){
						  	alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","日期格式有误!");
						  	return false;
					 }
				 }
				 
				$.ajax({
					url : basePath + "common/checkIsBook/",
					method : "post",
					data : {
						diningRoom_id : $("#diningRoom").val(),
						mealType:$("#mealType").val(),
						dayDate:$.trim($("#dayDate").val()),
						Auser:'18659230287'
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if(id=="message")
							{
								if (item == "success") {
									$("#cancel").attr("hidden","hidden");
									$("#book").removeAttr("hidden");
									closeAlertMsg();
								} else if (item == "error") {
									alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","查询是否已订餐失败！");
								}
							}else if(id=="number")
							{
								var msg="您已预订过"+$.trim($("#dayDate").val())+$("#diningRoom").find("option:selected").text()+"的"+$("#mealType").find("option:selected").text() +",预订用餐人数为："+item;
								alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告",msg);
								$("#book").attr("hidden","hidden");
								$("#cancel").removeAttr("hidden");
							}
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","查询是否已订餐失败！");
					}
				});

			 }
			 
			 function cancelBook()
			 {
					$.ajax({
						url : basePath + "common/cancelBook/",
						method : "post",
						data : {
							diningRoom_id : $("#diningRoom").val(),
							mealType:$("#mealType").val(),
							dayDate:$.trim($("#dayDate").val()),
							number:$("#number").val(),
							Auser:'18659230287'
						},
						dataType : "json",
						success : function(data) {
							$.each(data, function(id, item) {
								if(id=="message")
								{
									if (item == "success") {
										alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","查询不到订餐信息！！");
										$("#cancel").attr("hidden","hidden");
										$("#book").removeAttr("hidden");
									} else if (item == "error") {
										alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","失败","取消订餐失败！");
									}
								}else if(id=="number")
								{
									var msg="您已成功取消"+$.trim($("#dayDate").val())+$("#diningRoom").find("option:selected").text()+"的"+$("#mealType").find("option:selected").text() +",原预订用餐人数为："+item;
									alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功",msg);
									$("#cancel").attr("hidden","hidden");
									$("#book").removeAttr("hidden");
									$("#diningRoom").val("null");
									$("#mealType").val("null");
									$("#number").val("");
								}
							});
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","订餐失败！");
						}
					});
			 }
			
			 function checkAndBookMeal()
			 {
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
				 

				 
				 if($.trim($("#dayDate").val())!="")
				 {
					 var DATE_FORMAT = /^[0-9]{4}-[0-1]?[0-9]{1}-[0-3]?[0-9]{1}$/;
					 var dayDate = $.trim($("#dayDate").val());
				 	 if(!DATE_FORMAT.test(dayDate)){
						  	alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","日期格式有误!");
						  	return false;
					 }
				 }
				 
				 if($.trim($("#number").val())!="")
				 {
					 var reg=/^[0-9]*[1-9][0-9]*$/;
					 if(!reg.test($.trim($("#number").val())))
					 {
						  	alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","用餐人数请填为正整数!");
						  	return false;
					 }
				 }else
				 {
					 alertMsg($("#alertMsg"),"alert alert-warning alert-dismissable","警告","请确认用餐人数!");
					  	return false;
				 }
				 
				$.ajax({
					url : basePath + "common/bookMeal/",
					method : "post",
					data : {
						diningRoom_id : $("#diningRoom").val(),
						mealType:$("#mealType").val(),
						dayDate:$.trim($("#dayDate").val()),
						number:$("#number").val(),
						Auser:'18659230287'
					},
					dataType : "json",
					success : function(data) {
						$.each(data, function(id, item) {
							if (item == "success") {
								alertMsg($("#alertMsg"),"alert alert-success alert-dismissable","成功","已预订餐成功!");
								$("#diningRoom").val("null");
								$("#mealType").val("null");
								$("#number").val("");
							} else {
								alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","订餐失败！");
							}
						});
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alertMsg($("#alertMsg"),"alert alert-danger alert-dismissable","出错","订餐失败！");
					}
				});
			 }
			 
			$('#dayDate').datepicker({autoclose:true}).next().on(ace.click_event, function(){
				$(this).prev().focus();
			});
			
			$(function(){
				Date.prototype.pattern=function(fmt) {           
				    var o = {           
				    "M+" : this.getMonth()+1, //月份           
				    "d+" : this.getDate(), //日           
				    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时           
				    "H+" : this.getHours(), //小时           
				    "m+" : this.getMinutes(), //分           
				    "s+" : this.getSeconds(), //秒           
				    "q+" : Math.floor((this.getMonth()+3)/3), //季度           
				    "S" : this.getMilliseconds() //毫秒           
				    };           
				    var week = {           
				    "0" : "/u65e5",           
				    "1" : "/u4e00",           
				    "2" : "/u4e8c",           
				    "3" : "/u4e09",           
				    "4" : "/u56db",           
				    "5" : "/u4e94",           
				    "6" : "/u516d"          
				    };           
				    if(/(y+)/.test(fmt)){           
				        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));           
				    }           
				    if(/(E+)/.test(fmt)){           
				        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);           
				    }           
				    for(var k in o){           
				        if(new RegExp("("+ k +")").test(fmt)){           
				            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));           
				        }           
				    }           
				    return fmt;           
				}         
				       
				var date = new Date();   
				$("#dayDate").val(date.pattern("yyyy-MM-dd"));
			});
		</script>



</body>
</html>