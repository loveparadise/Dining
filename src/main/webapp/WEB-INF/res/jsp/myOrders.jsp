<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html>
<head>
<link rel="stylesheet" href="<%=basePath%>res/css/ordergird1.css"
	type="text/css">

<style type="text/css">
textarea {
	margin: 0 0 0 10px;
	height: 36px;
	width: 500px;
	border-radius: 5px;
	border: 1px solid #b3b3b3;
	background: #fff;
	font-size: 15px;
	font-size: 1.071rem;
	line-height: 1.25em;
	line-height: 34px\9;
	padding: 0;
	color: #333;
	box-sizing: border-box;
	text-indent: 10px;
	appearance: none;
	transition: border-color 0.3s ease;
	position: relative;
}
</style>

<jsp:include page="basic.jsp"></jsp:include>
<script type="text/javascript">
	var auditStr = ",";

	function checkAll(obj) {
		if ($j(obj).is(':checked') == true) {
			$j("input[status='audit']").each(function() {
				$j(this).prop("checked", true);
				auditStr = auditStr + $j(this).val() + ",";
			});
		} else {
			$j("input[status='audit']").removeAttr("checked");
			auditStr = ",";
		}
	}

	function check(obj) {
		if ($j(obj).is(':checked') == true) {
			$j(obj).prop("checked", true);
			auditStr = auditStr + $j(obj).val() + ",";
		} else {
			$j(obj).removeAttr("checked");
			auditStr = auditStr.replace("," + $j(obj).val() + ",", ",");
		}
	}

	function reply(val) {
		if(auditStr==",")
		{
			Alert("请选择订单！！！");
			return false;
		}
		$j.ajax({
			url : basePath + "order/reply/" + val,
			method : "get",
			data : {
				auditStr : auditStr
			},
			dataType : "json",
			success : function(data) {
				$j.each(data, function(id, item) {
					if (item == "success") {
						$j("input[status='audit']").removeAttr("checked");
						$j("#selectall").removeAttr("checked");
						auditStr = ",";
						Alert("操作成功。。。");
						location.reload();
					} else {
						if (val != 1)
							Alert("操作失败。。。");
						else
							Alert("供应商未确认的订单不能审核！")
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				if (val != 1)
					Alert("操作失败。。。");
				else
					Alert("供应商未确认的订单不能审核！")
			}
		});
	}

	function synMaterialDetail() {
		if(auditStr==",")
		{
			Alert("请选择订单！！！");
			return false;
		}
		showBg();
		$j.ajax({
			url : basePath + "order/synMaterialDetail",
			method : "post",
			data : {
				auditStr : auditStr
			},
			dataType : "json",
			success : function(data) {
				$j.each(data, function(id, item) {
					if (item == "success") {
						$j("input[status='audit']").removeAttr("checked");
						$j("#selectall").removeAttr("checked");
						auditStr = ",";
						Alert("操作成功。。。");
						loadingHide();
						location.reload();
					} else {
						Alert("操作失败,该订单是否已同步？");
						loadingHide();
					}
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				Alert("服务器错误，操作失败。。。");
				loadingHide();
			}
		});
	}

	function setPage(page) {
		$j("#currentPage").val(page);
		$j("form").submit();
	};
</script>
</head>
<header class="table-row">
	<jsp:include page="head.jsp"></jsp:include>
</header>
<body>
	<div class="welcome" id="stdpage">

		<div id="content">
			<div id="main">
				<div class="layout2c">
					<div class="col first">
						<div class="datatable">
							<div class="title">
								<form action="<%=basePath%>order/myOrders" id="serform"
									method="post">
								<input type="hidden" name="currentPage" id="currentPage" value="${page.currentPage}" />
									<table>
										<tr>
											<td style="background-color: #eaeef2;">订单号：</td>
											<td style="background-color: #eaeef2;"><input
												type="text" name="serOrderId"
												value="${searchForm.serOrderId }" onblur="trimSpace(this);"/></td>
											<td style="background-color: #eaeef2;">订单状态：</td>
											<td style="background-color: #eaeef2;"><select
												style="margin:0 0 0 10px;width: 250px;height:38px;border-radius: 5px;border: 1px solid #b3b3b3;"
												name="serOrderStatus">
													<option value="-99"
														<c:if test="${searchForm.serOrderStatus==-99}">selected="selected"</c:if>>所有</option>
													<option value="${itemStatus.UNAUDIT}"
														<c:if test="${searchForm.serOrderStatus==0 }">selected="selected"</c:if>>供应商已确认</option>
													<option value="${itemStatus.AUDIT}"
														<c:if test="${searchForm.serOrderStatus==1 }">selected="selected"</c:if>>采购员已确认</option>
													<option value="${itemStatus.UNREPLY}"
														<c:if test="${searchForm.serOrderStatus==-2 }">selected="selected"</c:if>>供应商未回复
													</option>
													<option value="${itemStatus.REPLY}"
														<c:if test="${searchForm.serOrderStatus==-1 }">selected="selected"</c:if>>供应商已回复</option>
											</select></td>
										</tr>
										<tr>
											<td style="background-color: #eaeef2;">起始日期：</td>
											<td style="background-color: #eaeef2;"><input
												type="text" name="serOrderStart" class="calendar"
												onclick="pop(this)" value="${startDate }" /></td>
											<td style="background-color: #eaeef2;">截止日期：</td>
											<td style="background-color: #eaeef2;"><input
												type="text" name="serOrderEnd" class="calendar"
												onclick="pop(this)" value="${endDate }" /></td>
										</tr>
										<tr>
											<td style="background-color: #eaeef2;">供应商号：</td>
											<td style="background-color: #eaeef2;"><input
												type="text" name="serOrderAccount"
												value="${searchForm.serOrderAccount }"  onblur="trimSpace(this);"/></td>
											<td style="background-color: #eaeef2;">订单明细同步状态：</td>
											<td style="background-color: #eaeef2;"><select
												style="margin:0 0 0 10px;width: 250px;height:38px;border-radius: 5px;border: 1px solid #b3b3b3;"
												name="synFlag">
													<option value="-1"
														<c:if test="${searchForm.synFlag=='-1'}"> selected="selected"</c:if>>所有</option>
													<option value="0"
														<c:if test="${searchForm.synFlag=='0'}">selected="selected"</c:if>>未同步</option>
													<option value="1"
														<c:if test="${searchForm.synFlag=='1' }">selected="selected"</c:if>>已同步</option>
											</select></td>
										</tr>
										<tr>
											<td style="background-color: #eaeef2;"></td>
											<td style="background-color: #eaeef2;"></td>
											<td style="background-color: #eaeef2;">操作：</td>
											<td style="background-color: #eaeef2;"><input
												type="submit" value="查詢" class="button"
												style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:red;" /></td>
										</tr>
										<tr>
											<c:if test="${curUser!=null&&!curUser.isAdmin}">
												<td style="background-color: #eaeef2;">操作：</td>
												<td style="background-color: #eaeef2;"><input
													type="button" value="回复" class="button"
													style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:blue;"
													onclick="reply(-1)" /> &nbsp;&nbsp;<input type="button"
													value="确认" class="button"
													style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:blue;"
													onclick="reply(0)" /> &nbsp;&nbsp;<input type="button"
													value="重置回复" class="button"
													style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:blue;"
													onclick="reply(-2)" />&nbsp;&nbsp;<input type="button"
													value="同步明细" class="button"
													style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:blue;"
													onclick="synMaterialDetail()" /></td>
											</c:if>
											<c:if test="${curUser!=null && curUser.isAdmin}">
												<td style="background-color: #eaeef2;">操作：</td>
												<td style="background-color: #eaeef2;"><input
													type="button" value="审核" class="button"
													style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:blue;"
													onclick="reply(1)" /> &nbsp;&nbsp;<input type="button"
													value="同步明细" class="button"
													style="margin:5px auto auto 10px;background-image: url(<%=basePath%>res/img/btn_bg_sprite.gif);color:blue;"
													onclick="synMaterialDetail()" /></td>
											</c:if>
											<td style="background-color: #eaeef2;">&nbsp;&nbsp;</td>
											<td style="background-color: #eaeef2;">&nbsp;&nbsp;</td>
										</tr>

									</table>
								</form>
							</div>
							<div class="tableWrapper" id="tableWrapperID"
								style="overflow: visible;">
								<table id="transactionTable">
									<thead>
										<tr>
											<th><input type="checkbox" onclick="checkAll(this)"
												id="selectall" /></th>
											<th>行号</th>
											<th>采购员</th>
											<th>采购订单号</th>
											<th>供应商名称</th>
											<th>创建时间</th>
											<th>订单审核日期</th>
											<th>发送日期</th>
											<th>发送次数</th>
											<th>订单状态</th>
											<th>供应商回复时间</th>
											<th>采购员回复时间</th>
											<th>明细同步状态</th>
										</tr>
									</thead>
									<tbody>

										<c:if test="${psOrders==null||empty psOrders}">
											<tr>
												<td class="noResults" headers="details" colspan="13">-还未同步采购订单-</td>
											</tr>
										</c:if>
										<c:if test="${psOrders!=null&& not empty psOrders}">
											<c:forEach var="psOrder" items="${psOrders }" varStatus="status">
												<tr>
													<td><input type="checkbox" status="audit"
														value="${psOrder.id }" onclick="check(this)" /></td>
													<td>${status.count }</td>
													<td>${psOrder.purchaser }</td>
													<td><a
														href="<%=basePath%>order/listOrderDetail/${psOrder.orderNum}">${psOrder.orderNum}</a></td>
													<td>${psOrder.providerName }</td>
													<td>${psOrder.createDate }</td>
													<td>${psOrder.auditDate }</td>
													<td>${psOrder.sendDate }</td>
													<td>${psOrder.sendAccount }</td>
													<td><c:choose>
															<c:when test="${psOrder.applyStatus==itemStatus.AUDIT}">采购员已确认</c:when>
															<c:otherwise>
																<c:choose>
																	<c:when
																		test="${psOrder.applyStatus==itemStatus.UNAUDIT}">供应商已确认</c:when>
																	<c:when
																		test="${psOrder.applyStatus==itemStatus.UNREPLY}">供应商未回复</c:when>
																	<c:when test="${psOrder.applyStatus==itemStatus.REPLY}">供应商已回复</c:when>
																</c:choose>
															</c:otherwise>
														</c:choose></td>
													<td>${psOrder.applyDate }</td>
													<td>${psOrder.confirmDate }</td>
													<td><c:choose>
															<c:when test="${psOrder.synFlag==true}">已同步</c:when>
															<c:otherwise>
																未同步
															</c:otherwise>
														</c:choose></td>
												</tr>
											</c:forEach>
										</c:if>
									</tbody>
								</table>
								<div style="text-align:right;"><jsp:include page="includePage.jsp" /></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>