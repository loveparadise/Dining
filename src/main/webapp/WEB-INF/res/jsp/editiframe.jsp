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

<script type="text/javascript">
	function hideFrame() {
		window.parent.hideFrame();
	}
</script>

</head>

<body>
	<div class="main-container" id="main-container">
		<div class="main-container-inner">
			<div class="main-content">
				<div class="page-content">
					<div class="row">
						<div class="col-xs-12">

							<!-- PAGE CONTENT BEGINS -->

							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header no-padding">
										<div class="table-header">
											<button type="button" class="close" data-dismiss="modal"
												aria-hidden="true">
												<span class="white">&times;</span>
											</button>
											编辑订单明细
										</div>
									</div>

									<div class="modal-body no-padding" style="overflow:auto">
										<table
											class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
											<thead>
												<tr>
													<th>序号</th>
													<th>订单号</th>
													<th>订单行项目</th>
													<th>物料号</th>
													<th>物料名称</th>
													<th>物料组</th>
													<th>网络值</th>
													<th>计划行</th>
													<th>已计</th>
													<th>已交</th>
													<th>未交</th>
													<c:if test="${sprocedures!=null && sprocedures!=null }">
														<c:forEach var="procedure" items="${sprocedures }">
															<th>${procedure.name }</th>
														</c:forEach>
													</c:if>
												</tr>
											</thead>

											<tbody>
												<c:if test="${orderDetails==null||empty orderDetails}">
													<tr>
														<td class="noResults" headers="details" colspan="11">-数据加载中，请稍后-</td>
													</tr>
												</c:if>
												<c:if test="${orderDetails!=null&& not empty orderDetails}">
													<c:forEach var="orderDetail" items="${orderDetails }"
														varStatus="status">
														<tr>
															<td>${status.count }</td>
															<td>${orderDetail.EBELN}</td>
															<td>${orderDetail.EBELP}</td>
															<td>${orderDetail.MATNR}</td>
															<td>${orderDetail.TXZ01}</td>
															<td>${orderDetail.MATKL}</td>
															<td>${orderDetail.SIZENum}</td>
															<td>${orderDetail.ETENR}</td>
															<td>${orderDetail.ETMNG }</td>
															<td>${orderDetail.WEMNG }</td>
															<td>${orderDetail.WJMNG }</td>
															<c:if
																test="${orderDetail.crafts!=null && not empty orderDetail.crafts }">
																<c:forEach var="procedure" items="${sprocedures }">
																	<c:set value="0" var="flag"></c:set>
																	<c:forEach var="craft" items="${orderDetail.crafts }">
																		<c:if test="${procedure.id==craft.sProcedure.id }">
																			<c:set value="1" var="flag"></c:set>
																			<td><input type="text" oid="${orderDetail.id}"
																				oldVal="${craft.valueNum}" cid="${craft.id}"
																				value="${craft.valueNum}" style="width: 90px;"
																				onblur="save(this)" onkeyup="checkNum(this)" /></td>
																		</c:if>
																	</c:forEach>
																	<c:if test="${flag==0 }">
																		<td><input type="text" oid="${orderDetail.id}"
																			oldVal="0" cid="0" pid="${procedure.id}"
																			style="width: 90px;" onblur="save(this)"
																			onkeyup="checkNum(this)" /></td>
																	</c:if>
																</c:forEach>
															</c:if>
															<c:if
																test="${orderDetail.crafts==null || empty orderDetail.crafts }">
																<c:forEach var="procedure" items="${sprocedures }">
																	<td><input type="text" oid="${orderDetail.id}"
																		oldVal="0" cid="0" pid="${procedure.id}"
																		style="width: 90px;" onblur="save(this)"
																		onkeyup="checkNum(this)" /></td>
																</c:forEach>
															</c:if>
														</tr>
													</c:forEach>
												</c:if>
											</tbody>
										</table>
									</div>

									<div class="modal-footer no-margin-top">
										<button class="btn btn-sm btn-danger pull-left"
											data-dismiss="modal" onclick="hideFrame()">
											<i class="icon-remove"></i> 关闭
										</button>

									</div>
								</div>
								<!-- /.modal-content -->
							</div>
							<!-- /.modal-dialog -->

							<!-- PAGE CONTENT ENDS -->
						</div>
						<!-- /.col -->
					</div>
					<!-- /.row -->
				</div>
				<!-- /.page-content -->
			</div>
			<!-- /.main-content -->


		</div>
	</div>
	<!-- /.main-container -->

	<script type="text/javascript">
		function checkNum(obj) {
			$(obj).val($(obj).val().replace(/[^\d|.]/g, ''));
		}
		function save(obj) {
			if (!$(obj).val() || $.trim($(obj).val()).length == 0)
				return false;
			if (!$.isNumeric($(obj).val())) {
				$(obj).val("");
				return false;
			}
			if ($.trim($(obj).val()) == $(obj).attr("oldVal"))
				return false;
			var val = $(obj).val();
			var oid = $(obj).attr("oid");
			var cid = $(obj).attr("cid");
			var pid = $(obj).attr("pid");

			$.ajax({
				url : basePath + "procedure/updateOrSaveCraft",
				method : "post",
				data : {
					oid : oid,
					cid : cid,
					pid : pid,
					val : val
				},
				dataType : "json",
				success : function(data) {
					$.each(data, function(id, item) {
						if (id == "cid") {
							if (id == "cid") {
								$(obj).attr("cid", item);
								$(obj).attr("oldVal", $(obj).val());
							}
						} else {
							alert("信息保存失败！");
						}
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					if (val != 1)
						alert("操作失败。。。");
					else
						alert("服务器出现错误！")
				}
			});
		}

		jQuery(function($) {

			$('table th input:checkbox').on(
					'click',
					function() {
						var that = this;
						$(this).closest('table').find(
								'tr > td:first-child input:checkbox').each(
								function() {
									this.checked = that.checked;
									$(this).closest('tr').toggleClass(
											'selected');
								});

					});

			$('[data-rel="tooltip"]').tooltip({
				placement : tooltip_placement
			});
			function tooltip_placement(context, source) {
				var $source = $(source);
				var $parent = $source.closest('table')
				var off1 = $parent.offset();
				var w1 = $parent.width();

				var off2 = $source.offset();
				var w2 = $source.width();

				if (parseInt(off2.left) < parseInt(off1.left)
						+ parseInt(w1 / 2))
					return 'right';
				return 'left';
			}


		})
	</script>

</body>
</html>
