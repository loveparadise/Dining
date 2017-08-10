package com.loveparadise.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.loveparadise.model.User;

public class NoLoginInterceptor implements HandlerInterceptor {

	private static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();

		User user = (User) session.getAttribute("curUser");
		String requestUri = request.getRequestURI().toString();
		String url = request.getQueryString();
		if (url != null && url.length() > 0 && url.indexOf("url=") > -1) {
			url = url.split("&")[0];
			url = "," + url.substring(4) + ",";
		} else {
			url = null;
		}
		if (user != null)
			logger.info("requestUriInfo requestUri:" + requestUri
					+ " requestaddress:" + request.getRemoteAddr() + " host:"
					+ request.getRemoteHost() + " port:"
					+ request.getRemotePort() + " user:" + user.getAccount()
					+ " name:" + user.getName());
		else
			logger.info("requestUriInfo requestUri:" + requestUri
					+ " requestaddress:" + request.getRemoteAddr() + " host:"
					+ request.getRemoteHost() + " port:"
					+ request.getRemotePort() + " user:"
					+ request.getRemoteAddr());
		if (user == null && !requestUri.endsWith("/user/login")) {
			// response.sendRedirect("/" + requestUri.split("/")[1]);
			response.sendRedirect("/");
			return false;
		}
		if (url != null && user.getAuthority().indexOf(url) < 0) {
			response.sendRedirect("/common/index");
			return false;
		}

		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub

	}

}
