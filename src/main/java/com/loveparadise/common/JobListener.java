package com.loveparadise.common;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class JobListener implements ServletContextListener {
	
	private static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// Scheduler job = (Scheduler) SpringBeanLoader
		// .getSpringBean("quartzScheduler");
		// try {
		// if (job.isStarted()) {
		// job.shutdown();
		// Thread.sleep(1000);
		// }
		// } catch (SchedulerException e) {
		// e.printStackTrace();
		// } catch (InterruptedException e) {
		// e.printStackTrace();
		// }

		WebApplicationContext webApplicationContext = null;
		try {
			// webApplicationContext = (WebApplicationContext) arg0
			// .getServletContext().getAttribute(
			// WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
			webApplicationContext=WebApplicationContextUtils.getWebApplicationContext(arg0
					.getServletContext());
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
		}
		org.quartz.impl.StdScheduler startQuertz = null;
		try {

			String[] beans = webApplicationContext.getBeanDefinitionNames();
			for (int i = 0; i < beans.length; i++) {
				System.out.println(beans[i]);
			}
			startQuertz = (org.quartz.impl.StdScheduler) webApplicationContext
					.getBean("startQuertz");
		} catch (Exception e1) {
			e1.printStackTrace();
			logger.error(e1.getMessage(),e1);
		}
		if (startQuertz != null) {
			startQuertz.shutdown();
		}
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
		}
		System.out.println("JobListener end...");
	}

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("JobListener start...");

	}

}
