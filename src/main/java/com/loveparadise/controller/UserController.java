package com.loveparadise.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.loveparadise.common.LDAPValidator;
import com.loveparadise.model.User;
import com.loveparadise.service.impl.UserService;

@Controller
@RequestMapping("/user")
public class UserController extends CommonController {

	private static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");

	@Resource(name = "userService")
	private UserService userService;

	/** 登录 */
	@RequestMapping(value = "/login")
	public String login(@ModelAttribute("user") User user,
			HttpServletRequest request, HttpSession session) {
		logger.info("loginInfo address:" + request.getRemoteAddr() + " host:"
				+ request.getRemoteHost() + " port:" + request.getRemotePort()
				+ " user:" + request.getRemoteUser());
		String randomCode = (String) session
				.getAttribute("RANDOMVALIDATECODEKEY");
//		if (user.getRandomCode() == null || user.getRandomCode().length() != 4
//				|| !user.getRandomCode().equalsIgnoreCase(randomCode)) {
//			user.setRandomCode("-1");
//			session.setAttribute("errorValue", 1);
//			return "redirect:/";
//		}
		String account = user.getAccount();
		String password = user.getPassword();

		User loginUser = new User();
		loginUser.setAccount(account);
		loginUser.setStatus(0);
		loginUser = userService.getObject(loginUser);

		if (loginUser != null) {

//			LDAPValidator ua = new LDAPValidator();
//			boolean flag = false;
//			try {
//				flag = ua.authenricate(account, password);
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//				logger.error(e.getMessage(), e);
//			}
//			if (flag) {
				user=userService.getObject(account, "account");
				session.setAttribute("curUser", user);
				return "redirect:/menu/index";
//			} else {
//				user = new User();
//				user.setRandomCode("-2");
//				session.setAttribute("errorValue", 2);
//				return "redirect:/";
//			}
		} else {
			user = new User();
			user.setRandomCode("-2");
			session.setAttribute("errorValue", 2);
			return "redirect:/";
		}
	}

	/** 登出 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpSession session) {
		session.setAttribute("curUser", null);
		return "redirect:/";
	}
}