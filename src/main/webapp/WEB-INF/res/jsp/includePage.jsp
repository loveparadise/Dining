<%@ page language="java" import="java.util.*,com.loveparadise.model.Page" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
	+ request.getServerName() + ":" + request.getServerPort()
	+ path + "/";
%>
<c:if test="${page !=null}">
	<tr>
		<td>共计 ${page.recordCount} 条记录, 第 <c:if
				test="${page.totalPage > 0}">
				<select name="currentPage" id="currentPage" size="1"
					onchange="javascript:setPage(this.value);">
					<%
						Page p = (Page) session.getAttribute("page");
						for(int i=1;i<=p.getTotalPage();i++)
							if(p.getCurrentPage()==i)
								out.write("<option value="+i+" selected='selected'>"+i+"</option>");
							else
								out.write("<option value="+i+">"+i+"</option>");
					%>
				</select>
			</c:if> 页 / 共 ${page.totalPage} 页
		</td>
	</tr>
</c:if>