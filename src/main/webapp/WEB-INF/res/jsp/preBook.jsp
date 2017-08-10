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
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>预订用餐</title>
    <meta name="description" content="MSUI: Build mobile apps with simple HTML, CSS, and JS components.">
    <meta name="viewport" content="initial-scale=1, maximum-scale=1">
    <link rel="shortcut icon" href="<%=basePath%>assets/avatars/logo1.gif">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">

    <!-- Google Web Fonts -->

    <link rel="stylesheet" href="<%=basePath%>res/phone/sm.css">
    <link rel="stylesheet" href="<%=basePath%>res/phone/sm-extend.css">

    <link rel="apple-touch-icon-precomposed" href="<%=basePath%>res/img/aoms.png">
    <script src="<%=basePath%>res/phone/zepto.js"></script>
    <script>
    var basePath = "<%=basePath%>";
    function strToJson(str){ 
   		var json = eval('(' + str + ')'); 
   		return json; 
    } 
    
    $(function() {
    	var colStr="${colStr}";
    	  $(document).on("pageInit", function() {
    	    $("#picker").picker({
    	      toolbarTemplate: '<header class="bar bar-nav">\
    	      <button class="button button-link pull-right close-picker">确定</button>\
    	      <h1 class="title">请确定用餐人数</h1>\
    	      </header>',
    	      cols: [
    	        {
    	          textAlign: 'center',
    	          values: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    	        }
    	      ]
    	    });
    	    $("#picker-name").picker({
    	      toolbarTemplate: '<header class="bar bar-nav">\
    	      <button class="button button-link pull-right close-picker">确定</button>\
    	      <h1 class="title">请确认用餐信息</h1>\
    	      </header>',
    	      cols: strToJson(colStr)
    	    });
    	  });
    	  $.init();
    	});
    
	 function checkIsBook()
	 {
		 
		 if($("#picker-name").val()=="null"||$("#picker-name").val()=="")
		 {
			 return false;
		 }
		 
		$.ajax({
			url : basePath + "common/checkIsBook",
			method : "post",
			data : {
				bookMsg : $("#picker-name").val(),
				Auser:'18659230287'
			},
			dataType : "json",
			success : function(data) {
				$.each(data, function(id, item) {
					if(id=="message")
					{
						if (item == "success") {
							$("#cancelBtn").attr("hidden","hidden");
							$("#conformBtn").removeAttr("hidden");
							$("#alertMsg").attr("hidden","hidden");
						} else if (item == "error") {
							$.toast("查询是否已订餐失败！");
							$("#cancelBtn").attr("hidden","hidden");
							$("#conformBtn").removeAttr("hidden");
						}
					}else if(id=="number")
					{
						$("#alertMsg").removeAttr("hidden");
						$("#alertMsg").html("已经预订过"+$('#picker-name').val()+",用餐人数为："+item);
						$.toast("您已预订过！");
						$("#alertMsg").removeAttr("hidden");
						$("#conformBtn").attr("hidden","hidden");
						$("#cancelBtn").removeAttr("hidden");
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				$.toast("查询是否已订餐失败！");
			}
		});

	 }
	 
	 function cancelBook()
	 {
		 if($("#picker-name").val()=="null"||$("#picker-name").val()=="")
		 {
			 return false;
		 }
			$.ajax({
				url : basePath + "common/cancelBook",
				method : "post",
				data : {
					bookMsg : $("#picker-name").val(),
					Auser:'18659230287'
				},
				dataType : "json",
				success : function(data) {
					$.each(data, function(id, item) {
						if(id=="message")
						{
							if (item == "success") {
								$("#cancelBtn").attr("hidden","hidden");
								$("#conformBtn").removeAttr("hidden");
							} else if (item == "error") {
								$.toast("取消订餐失败！");
								$("#alertMsg").html("取消订餐失败！");
							}
						}else if(id=="number")
						{
							$.toast("成功取消订餐！");
							$("#alertMsg").html("已取消"+$('#picker-name').val()+",用餐人数为："+item);
							$("#cancelBtn").attr("hidden","hidden");
							$("#conformBtn").removeAttr("hidden");
						}
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					$.toast("订餐失败！");
				}
			});
	 }
	
	 function checkAndBookMeal()
	 {
		 if($("#picker-name").val()=="null"||$("#picker-name").val()=="")
		 {
			 $.toast("请确认餐厅详情！");
			 return false;
		 }
		 
		 if($("#picker").val()=="null"||$("#picker").val()=="")
		 {
			 $.toast("请确认用餐人数！");
			 return false;
		 }
		 
		$.ajax({
			url : basePath + "common/bookMeal",
			method : "post",
			data : {
				bookMsg : $("#picker-name").val(),
				number : $("#picker").val(),
				Auser:'18659230287'
			},
			dataType : "json",
			success : function(data) {
				$.each(data, function(id, item) {
					if (item == "success") {
						$.toast("您已成功订餐！");
						$("#alertMsg").html("成功订餐"+$('#picker-name').val()+",用餐人数为："+$('#picker').val());
						$("#conformBtn").attr("hidden","hidden");
						$("#cancelBtn").removeAttr("hidden");
					} else {
						$.toast("订餐失败！");
						$("#alertMsg").html("订餐失败！");
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				$.toast("订餐失败！");
				$("#alertMsg").html("订餐失败！");
			}
		});
	 }

</script>

  </head>
  <body>
    <div class="page-group">
    <div class="page">
  <div class="content">
   	<div class="content-block" >
      <p id="alertMsg" hidden="hidden"><a href="#" class="alert-text"></a></p>
    </div>
    <div class="content-block-title">人数确定</div>
    <div class="content-block">
      <div class="list-block">
        <ul>
          <!-- Text inputs -->
          <li>
            <div class="item-content">
              <div class="item-inner">
                <div class="item-input">
                  <input type="text" placeholder="人数确定" id='picker' />
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    <div class="content-block-title">订餐详情</div>
    <div class="content-block">
      <div class="list-block">
        <ul>
          <!-- Text inputs -->
          <li>
            <div class="item-content">
              <div class="item-inner">
                <div class="item-input">
                  <input type="text" placeholder="订餐详情" id='picker-name' onchange="checkIsBook()"/>
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  <div class="content-block" id="conformBtn">
    <p onclick="checkAndBookMeal()"><a href="#" class="button button-light button-round" style="text-decoration:none">预订用餐</a></p>
  </div>
   <div class="content-block" id="cancelBtn" hidden="hidden">
    <p onclick="cancelBook()"><a href="#" class="button button-light button-round" style="text-decoration:none">取消订餐</a></p>
  </div>
  </div>
</div>
    </div>
    <script src="<%=basePath%>res/phone/sm.js"></script>
    <script src="<%=basePath%>res/phone/sm-extend.js"></script>
  </body>
</html>
