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
		<title>${meals.get(0).getDiningRoom_name() }${mealType.getText()}</title>
		<link href="<%=basePath%>res/phone/style.css" rel='stylesheet' type='text/css' />
		<meta name="viewport" content="width=device-width, initial-scale=1">
		</script>
		<!----webfonts---->
		<!----//webfonts---->
		<!-- Global CSS for the page and tiles -->
  		<link rel="stylesheet" href="<%=basePath%>res/phone/main.css">
  		<link rel="stylesheet" href="<%=basePath%>res/phone/layer.css">
  		<!-- //Global CSS for the page and tiles -->
		<!---start-click-drop-down-menu----->
		<script src="<%=basePath%>assets/js/jquery-2.0.3.min.js"></script>
        <!----start-dropdown--->
         <script type="text/javascript">
			var $ = jQuery.noConflict();
		</script>
        <!----//End-dropdown--->
		<!---//End-click-drop-down-menu----->
		<style type="text/css">
        .stars i{ color: #D3D3D3;}
        .stars .on{ color: #FF8000;}
		</style>
	</head>
	<body>
		<!---start-wrap---->
		<!---start-content---->
		<div class="content">
			<div class="wrap">
			 <div id="main" role="main" style="margin-top:1em;">
			      <ul id="tiles">
			      <c:if test="${empty meals}">
			          <div align="center" >
			           	<span style="color:#FF0000">还没有餐单呢！</span>
			          </div>
					</c:if>
			        <!-- These are our grid blocks -->
			        <c:forEach items="${meals}" var="meal">
			        <li>
			        	<img src="<%=basePath%>uploadMenu/${meal.picture}" width="200" height="200">
			        	<div class="post-info">
			        		<div class="post-basic-info">
				        		<h3><a>${meal.menu_name}</a></h3>
				        		<span><a><label> </label>${meal.type_name}</a></span>
				        		<p style="font-style:oblique;"><i>${meal.remark}</i></p>
			        		</div>
			        		<div class="post-info-rate-share">
			        			<div class="stars" mealId="${meal.id }" mealType="${meal.mealType }" dayDate="${meal.dayDate }">
								    <i>★</i>
								    <i>★</i>
								    <i>★</i>
								    <i>★</i>
								    <i>★</i>
								    <input type="hidden" value="${meal.score }"/>
								</div>
			        			<div class="clear"> </div>
			        		</div>
			        	</div>
			        </li>
			        </c:forEach>
			        <!-- End of grid blocks -->
			      </ul>
			    </div>
			    <div hidden="hidden">
				    <span id="successMsg"> layer.open({
					    content: '评价成功！'
					    ,skin: 'msg'
					    ,time: 1
					  });
					</span>
					<span id="errorMsg"> layer.open({
					    content: '评价失败！'
					    ,skin: 'msg'
					    ,time: 1
					  });
					</span>
				</div>
			</div>
		</div>
		<!---//End-content---->
		<!----wookmark-scripts---->
		  <script src="<%=basePath%>res/phone/jquery.imagesloaded.js"></script>
		  <script src="<%=basePath%>res/phone/jquery.wookmark.js"></script>
		  <script src="<%=basePath%>res/phone/layer.js"></script>
		  <script type="text/javascript">
		  	var basePath = "<%=basePath%>";
		    (function ($){
		      var $tiles = $('#tiles'),
		          $handler = $('li', $tiles),
		          $main = $('#main'),
		          $window = $(window),
		          $document = $(document),
		          options = {
		            autoResize: true, // This will auto-update the layout when the browser window is resized.
		            container: $main, // Optional, used for some extra CSS styling
		            offset: 20, // Optional, the distance between grid items
		            itemWidth:280 // Optional, the width of a grid item
		          };
		      /**
		       * Reinitializes the wookmark handler after all images have loaded
		       */
		      function applyLayout() {
		        $tiles.imagesLoaded(function() {
		          // Destroy the old handler
		          if ($handler.wookmarkInstance) {
		            $handler.wookmarkInstance.clear();
		          }
		
		          // Create a new layout handler.
		          $handler = $('li', $tiles);
		          $handler.wookmark(options);
		        });
		      }
		      /**
		       * When scrolled all the way to the bottom, add more tiles
		       */
		       
		      function onScroll() {
		        // Check if we're within 100 pixels of the bottom edge of the broser window.
		        var winHeight = window.innerHeight ? window.innerHeight : $window.height(), // iphone fix
		            closeToBottom = ($window.scrollTop() + winHeight > $document.height() - 100);
		
		        if (closeToBottom) {
		          // Get the first then items from the grid, clone them, and add them to the bottom of the grid
		          var $items = $('li', $tiles),
		              $firstTen = $items.slice(0, 10);
		          $tiles.append($firstTen.clone());
		
		          applyLayout();
		        }
		      };
		
		      // Call the layout function for the first time
		      applyLayout();
		
		    })(jQuery);
		    
		    $(function(){
		        /*
		        * 鼠标点击，该元素包括该元素之前的元素获得样式,并给隐藏域input赋值
		        * 鼠标移入，样式随鼠标移动
		        * 鼠标移出，样式移除但被鼠标点击的该元素和之前的元素样式不变
		        * 每次触发事件，移除所有样式，并重新获得样式
		        * */
		        var stars = $('.stars');
		        var Len = stars.length;
		        //遍历每个评分的容器
		        for(j=0;j<Len;j++){
		            //每次触发事件，清除该项父容器下所有子元素的样式所有样式
		            function clearAll(obj){
		                obj.parent().children('i').removeClass('on');
		            }
		            stars.eq(j).find('i').click(function(){
		                var num = $(this).index();
		                clearAll($(this));
		                //当前包括前面的元素都加上样式
		                $(this).addClass('on').prevAll('i').addClass('on');
		                if($(this).siblings('input').val()!=num+1)
		                {
			                //给隐藏域input赋值
			                $(this).siblings('input').val(num+1);
							$.ajax({
								url : basePath + "common/judgeMeal/",
								method : "post",
								data : {
									mealId : $(this).parent().attr("mealId"),
									mealType:$(this).parent().attr("mealType"),
									dayDate:$(this).parent().attr("dayDate"),
									score:num+1,
									Auser:'18659230287'
								},
								dataType : "json",
								success : function(data) {
									$.each(data, function(id, item) {
										if (item == "success") {
											new Function(successMsg.innerHTML)();
										} else {
											new Function(errorMsg.innerHTML)();
										}
									});
								},
								error : function(jqXHR, textStatus, errorThrown) {
									new Function(errorMsg.innerHTML)();
								}
							});
		                }
		            });
		            stars.eq(j).find('i').mouseover(function(){
		                clearAll($(this));
		                //当前包括前面的元素都加上样式
		                $(this).addClass('on').prevAll('i').addClass('on');
		            });
		            stars.eq(j).find('i').mouseout(function(){
		                clearAll($(this));
		                //触发点击事件后input有值
		                var score = $(this).siblings('input').val();
		                for(k=0;k<score;k++){
		                    $(this).parent().find('i').eq(k).addClass('on');
		                }
		            });
		            

	                var score = stars.eq(j).find('input').eq(0).val();
	                for(l=0;l<score;l++){
	                	stars.eq(j).find('i').eq(l).addClass('on');
	                }
		        }
		    });
		  </script>
		<!----//wookmark-scripts---->
		<!----start-footer--->
		<!---//End-wrap---->
	</body>
</html>

