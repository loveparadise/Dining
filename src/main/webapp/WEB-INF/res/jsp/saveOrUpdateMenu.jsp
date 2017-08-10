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
<link href="<%=basePath%>assets/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet"
	href="<%=basePath%>assets/css/font-awesome.min.css" />

<!-- <link rel="stylesheet" -->
<!-- 	href="<%=basePath%>assets/css/jquery-ui-1.10.3.full.min.css" /> -->
<link rel="stylesheet" href="<%=basePath%>assets/css/ace.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/ace-rtl.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/ace-skins.min.css" />
<link rel="stylesheet" href="<%=basePath%>assets/css/jquery.gritter.css" />

<script src="<%=basePath%>assets/js/ace-extra.min.js"></script>

<script src="<%=basePath%>assets/js/jquery-2.0.3.min.js"></script>
<script src="<%=basePath%>assets/js/bootstrap.min.js"></script>
<script src="<%=basePath%>assets/js/ace.min.js"></script>
<link rel="stylesheet" href="<%=basePath%>assets/css/chosen.css" />
<script src="<%=basePath%>assets/js/chosen.jquery.min.js"></script>
<script type="text/javascript"
	src="<%=basePath%>res/uploadify/jquery.uploadify.min.js"></script>
<link href="<%=basePath%>res/uploadify/uploadify.css" rel="stylesheet"
	type="text/css" />

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
						<li class="active">上传更新菜单</li>
					</ul>
					<!-- .breadcrumb -->

				</div>
				<div class="page-content">
					<div class="row">
						<div id="alertMsg" class="alert alert-danger hidden" role="alert">
							<strong>提示标题：</strong>具体提示信息
						</div>
						<div class="alert alert-info" style="margin-bottom: 0px;">
							<label for="form-field-select-3">分类选择:</label> <select
								class="chosen-select" style="width:180px;"
								data-placeholder="分类选择" id="type">
								<option value="null"></option>
								<c:forEach items="${types}" var="type">
									<option value="${type.id}">${type.name}</option>
								</c:forEach>
							</select>
							</br>
							</br>
								<div id="fileQueue"></div>
								<span id="uploadfile"></span>
							</br>
							 <a
								href="javascript:checkAndUpload()">上传菜单</a> | <a href="javascript:$j('#uploadfile').uploadify('stop','*')">停止上传</a>
						</div>

					</div>
				</div>
				
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		var $j = jQuery.noConflict(); 
		var basePath='<%=basePath%>';
		 
		 function alertMsg(obj,clas,title,detail)
		 {
			 var str="<button type='button' class='close'  aria-hidden='true' onclick='closeAlertMsg()'> &times; </button>";
			 $j(obj).attr("class",clas).html(str+"<strong>"+title+":</strong>"+detail);
		 }
		 
		 function closeAlertMsg()
		 {
			 $j("#alertMsg").attr("class","hidden");
		 }
	
	 
		function trimSpace(obj)
		{
			$j(obj).val($j.trim($j(obj).val()));
		}
		
		$j(function() {
			$j(".chosen-select").chosen();
			$j("#uploadfile").uploadify({
				debug			: false, 
				swf 			: '<%=basePath%>res/uploadify/uploadify.swf?random=' + (new Date()).getTime(), 
				method			: 'post',	// 提交方式
				uploader		: '<%=basePath%>menu/uploadImg',
				preventCaching	: false,		// 加随机数到URL后,防止缓存
				auto            : false,

				buttonCursor	: 'hand',	// 上传按钮Hover时的鼠标形状
			//	buttonImage		: 'img/.....png',	// 按钮的背景图片,会覆盖文字
				buttonText		: '选择图片'	, //按钮上显示的文字，默认”SELECTFILES”
				height			: 30	, // 30 px
				width			: 120	, // 120 px

				fileObjName		: 'file',	//文件对象名称, 即属性名
				fileSizeLimit	: 1000000000	,		// 文件大小限制, 100 KB
				fileTypeDesc    : '支持格式:jpg/gif/jpeg/png/bmp.', //如果配置了以下的'fileExt'属性，那么这个属性是必须的    
				fileTypeExts    : '*.jpg;*.gif;*.jpeg;*.png;*.bmp',//允许的格式     
				formData		: {'type':0} , //指定上传文件附带的其他数据。也动态设置。可通过getParameter()获取
				
				multi			: true ,	// 多文件上传
				progressData	: 'speed',	// 进度显示, speed-上传速度,percentage-百分比	
				queueID			: 'fileQueue',//上传队列的DOM元素的ID号
				queueSizeLimit	: 99	,	// 队列长度
				removeCompleted : false	,	// 上传完成后是否删除队列中的对应元素
				removeTimeout	: 10	,	//上传完成后多少秒后删除队列中的进度条, 
				requeueErrors	: true,	// 上传失败后重新加入队列
				uploadLimit		: 99,	// 最多上传文件数量

				successTimeout	: 30	,//表示文件上传完成后等待服务器响应的时间。超过该时间，那么将认为上传成功。
	            onComplete: function (event, queueID, fileObj, response, data) {     
	            	  alertMsg($j("#alertMsg"),"alert alert-success alert-dismissable","成功","已上传所有图片!");
	              },  
	            onCancel: function(event, queueID, fileObj){     
	            	  alertMsg($j("#alertMsg"),"alert alert-warning alert-dismissable","警告","已取消上传图片!");    
	              },	              
	            onUploadError : function(file, errorCode, errorMsg, errorString){     
	            	  alertMsg($j("#alertMsg"),"alert alert-danger alert-dismissable","失败",file.name +"上传失败！");
	              },  
                onUploadSuccess: function(file, data, response) {   
                	  alertMsg($j("#alertMsg"),"alert alert-success alert-dismissable","成功", file.name +"上传成功！");
                 }  
			});
		})
		
	 function checkAndUpload(){
		 if($j("#type").val()==null||$j("#type").val()=="null")
		 {
			 alertMsg($j("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择分类!");
			 return false;
		 }
       if($j(".uploadify-queue-item").size()==0) {
			alertMsg($j("#alertMsg"),"alert alert-warning alert-dismissable","警告","请选择上传图片!");
			return false;
    	}
       $j('#uploadfile').uploadify('settings', 'formData', {'type':$j("#type").val()});
       $j('#uploadfile').uploadify('upload', '*');
	 }
	</script>
</body>
</html>