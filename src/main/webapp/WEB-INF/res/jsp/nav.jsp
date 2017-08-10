<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html>
<div class="sidebar" id="sidebar">
	<script type="text/javascript">
		try {
			ace.settings.check('sidebar', 'fixed')
		} catch (e) {

		}
	</script>

	<div class="sidebar-shortcuts" id="sidebar-shortcuts">
		<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
		</div>

	</div>
	<!-- #sidebar-shortcuts -->

	<ul class="nav nav-list">

		<li><c:choose>
				<c:when test="${fn:indexOf(curUser.authority,',menu-,')>-1}">
					<a href="#" class="dropdown-toggle"> <i class="icon-desktop"></i>
						<span class="menu-text">菜单维护 </span> <b
						class="arrow icon-angle-down"></b>
					</a>
				</c:when>
			</c:choose>

			<ul class="submenu">
				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',listMenu,')>-1}">
							<li><a href="<%=basePath%>common/index?url=listMenu"> <i
									class="icon-double-angle-right"></i> 菜单列表
							</a></li>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when
						test="${fn:indexOf(curUser.authority,',saveOrUpdateMenu,')>-1}">
							<li><a href="<%=basePath%>common/index?url=saveOrUpdateMenu">
									<i class="icon-double-angle-right"></i> 上传更新菜单
							</a></li>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',listMeal,')>-1}">
							<li><a href="<%=basePath%>common/index?url=listMeal"> <i
									class="icon-double-angle-right"></i> 每餐菜单
							</a></li>
					</c:when>
				</c:choose>

			</ul></li>


		<li><c:choose>
				<c:when test="${fn:indexOf(curUser.authority,',diningRoom-,')>-1}">
					<a href="#" class="dropdown-toggle"> <i class="icon-list-alt"></i>
						<span class="menu-text">餐厅、分类、限餐管理</span> <b
						class="arrow icon-angle-down"></b>
					</a>
				</c:when>
			</c:choose>

			<ul class="submenu">
				<c:choose>
					<c:when
						test="${fn:indexOf(curUser.authority,',listDiningRoom,')>-1}">
						<li><a href="<%=basePath%>common/index?url=listDiningRoom">
								<i class="icon-double-angle-right"></i> 餐厅列表
						</a></li>
					</c:when>
				</c:choose>

				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',listType,')>-1}">
						<li><a href="<%=basePath%>common/index?url=listType"> <i
								class="icon-double-angle-right"></i> 分类列表
						</a></li>
					</c:when>
				</c:choose>

				<c:choose>
					<c:when
						test="${fn:indexOf(curUser.authority,',listLimitedMealNumber,')>-1}">
						<li><a
							href="<%=basePath%>common/index?url=listLimitedMealNumber"> <i
								class="icon-double-angle-right"></i> 临时调整用餐人数
						</a></li>
					</c:when>
				</c:choose>
			</ul></li>

		<li><c:choose>
				<c:when test="${fn:indexOf(curUser.authority,',user-,')>-1}">
					<a href="#" class="dropdown-toggle"> <i class="icon-edit"></i>
						<span class="menu-text"> 用户管理 </span> <b
						class="arrow icon-angle-down"></b>
					</a>
				</c:when>
			</c:choose>

			<ul class="submenu">
				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',listUser,')>-1}">
						<li><a href="<%=basePath%>common/index?url=listUser"> <i
								class="icon-double-angle-right"></i> 用户列表
						</a></li>
					</c:when>
				</c:choose>
			</ul></li>



		<li><c:choose>
				<c:when test="${fn:indexOf(curUser.authority,',bookAndJudge-,')>-1}">
					<a href="#" class="dropdown-toggle"> <i class="icon-file-alt"></i>
						<span class="menu-text"> 订餐、评价管理 </span> <b
						class="arrow icon-angle-down"></b>
					</a>
				</c:when>
			</c:choose>
			<ul class="submenu">
				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',listJudge,')>-1}">
						<li><a href="<%=basePath%>common/index?url=listJudge"> <i
								class="icon-double-angle-right"></i> 评价详情
						</a></li>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',summaryJudge,')>-1}">
						<li><a href="<%=basePath%>common/index?url=summaryJudge">
								<i class="icon-double-angle-right"></i> 评价汇总
						</a></li>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${fn:indexOf(curUser.authority,',listBook,')>-1}">
						<li><a href="<%=basePath%>common/index?url=listBook"> <i
								class="icon-double-angle-right"></i> 订餐详情
						</a></li>
					</c:when>
				</c:choose>
			</ul></li>

	</ul>
	<!-- /.nav-list -->



	<div class="sidebar-collapse" id="sidebar-collapse">
		<i class="icon-double-angle-left" data-icon1="icon-double-angle-left"
			data-icon2="icon-double-angle-right"></i>
	</div>

	<script type="text/javascript">
		try {
			ace.settings.check('sidebar', 'collapsed')
		} catch (e) {
		}
	</script>
</div>
</html>
