package com.loveparadise.util;

import java.io.UnsupportedEncodingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StrUtil {
	public static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");
	public static String utf8Str(String str) {
		if (str != null) {
			try {
				str = new String(str.getBytes("ISO-8859-1"), "UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				logger.error(e.getMessage(),e);
			} finally {
				return str;
			}
		} else
			return null;
	}

	public static String urlDecodeStr(String str) {
		try {
			str = java.net.URLDecoder.decode(str, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
		} finally {
			return str;
		}
	}
}