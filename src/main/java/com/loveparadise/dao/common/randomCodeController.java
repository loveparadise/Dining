package com.loveparadise.dao.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.loveparadise.util.RandomValidateCode;

@Controller
@RequestMapping("/image")
public class randomCodeController {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");

	@RequestMapping(value = "/randomCode")
	public ModelAndView image(HttpServletResponse response,
			HttpServletRequest request, HttpSession session) {

		response.setContentType("image/jpeg");// ������Ӧ����,������������������ΪͼƬ
		response.setHeader("Pragma", "No-cache");// ������Ӧͷ��Ϣ�������������Ҫ���������
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expire", 0);
		RandomValidateCode randomValidateCode = new RandomValidateCode();
		try {
			randomValidateCode.getRandcode(request, response);// ���ͼƬ����
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
		}

		return null;
	}
}
