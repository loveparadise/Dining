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
							<label for="form-field-select-3">餐厅选择:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="餐厅选择" id="diningRoom">
								<option value="null"></option>
								<c:forEach items="${diningRooms}" var="diningRoom">
									<option value="${diningRoom.id}">${diningRoom.name}</option>
								</c:forEach>
							</select></br>
							
							<label for="form-field-select-3">用餐时段:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="用餐时段" id="mealType">
								<option value="null"></option>
								<c:forEach items="${mealTypes}" var="mealType">
									<option value="${mealType}">${mealType.getText()}</option>
								</c:forEach>
							</select></br>
							
							<label for="form-field-select-3">用餐日期:</label> <input
								id="dayDate" type="text" data-date-format="yyyy-mm-dd"
								placeholder="yyyy-mm-dd 可不填" />&nbsp;&nbsp;</br></br>
							
							<a href="javascript:checkAndShowMeal()" style="">看看餐单</a>
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
			
			
			 function checkAndShowMeal()
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

			 	 var url='<%=basePath%>common/showMeal?diningRoom_id='+$("#diningRoom").val()+'&mealType='+$("#mealType").val()+'&dayDate='+$.trim($("#dayDate").val())+'&Auser=18659230287';
			 	 window.location=url;
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