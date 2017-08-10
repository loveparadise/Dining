package com.loveparadise.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.loveparadise.model.DiningRoom;
import com.loveparadise.model.Meal;
import com.loveparadise.model.MealType;
import com.loveparadise.model.Menu;
import com.loveparadise.model.Page;
import com.loveparadise.model.Search;
import com.loveparadise.model.Type;
import com.loveparadise.model.User;

@Controller
@RequestMapping("/menu")
public class MenuController extends CommonController {

	private static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");

	/** 加入菜单 */
	@RequestMapping(value = "/createMeal", method = RequestMethod.POST)
	public void createMeal(HttpServletRequest request,
			HttpServletResponse response, HttpSession session) {
		String Ids = "";
		String dingRoomId = "";
		String mealTypeStr = "";
		String dayDate = "";

		Integer res = 0;
		Map map = request.getParameterMap();
		User curUser = (User) session.getAttribute("curUser");

		for (Object key : map.keySet()) {
			if (String.valueOf(key).equalsIgnoreCase("Ids[]")) {
				String[] strs = (String[]) map.get(key);
				for (String str : strs)
					Ids = Ids + str + ",";
			} else if (String.valueOf(key).equalsIgnoreCase("dingRoomId")) {
				String[] strs = (String[]) map.get(key);
				for (String str : strs)
					dingRoomId = str;
			} else if (String.valueOf(key).equalsIgnoreCase("mealTypeStr")) {
				String[] strs = (String[]) map.get(key);
				for (String str : strs)
					mealTypeStr = str;
			} else if (String.valueOf(key).equalsIgnoreCase("dayDate")) {
				String[] strs = (String[]) map.get(key);
				for (String str : strs)
					dayDate = str;
			}
		}
		String tempIds = Ids.replace(",", "','");
		MealType mealType = MealType.valueOf(mealTypeStr);
		tempIds = "'" + tempIds.substring(0, tempIds.length() - 2);
		String sql = "select * from Meal where dayDate='" + dayDate
				+ "' and diningRoom_id='" + dingRoomId + "' and mealType='"
				+ mealType.toString() + "' and menu_id in(" + tempIds + ")";

		List<Meal> meals = (List<Meal>) mealService
				.selectBySql(sql, new Meal());
		Ids = "," + Ids;
		if (meals != null)
			for (Meal meal : meals) {
				meal.setStatus(0);
				meal.setUpdateDate(new Date());
				meal.setUpdater(curUser.getName());
				mealService.saveOrUpdate(meal);
				Ids = Ids.replace("," + meal.getMenu_id() + ",", ",");
			}
		if (Ids.length() != 1) {
			Ids = Ids.substring(1, Ids.length() - 1);
			sql = "select * from menu where id in(" + Ids + ") and status>-1";
			List<Menu> menus = (List<Menu>) menuService.selectBySql(sql,
					new Menu());

			DiningRoom diningRoom = diningRoomService.getObject(dingRoomId,
					"id");
			if (menus != null && menus.size() > 0) {
				for (Menu menu : menus) {
					Meal meal = new Meal();
					meal.setDayDate(dt.strToData(dayDate));
					meal.setDiningRoom_id(diningRoom.getId().toString());
					meal.setDiningRoom_name(diningRoom.getName());
					meal.setMealType(mealType.toString());
					meal.setMenu_name(menu.getName());
					meal.setMenu_id(menu.getId().toString());
					meal.setPicture(menu.getPicture());
					meal.setType_id(menu.getType_id());
					meal.setType_name(menu.getType_name());
					meal.setStatus(0);
					meal.setUpdateDate(new Date());
					meal.setUpdater(curUser.getName());
					meal.setScore(0);
					meal.setRecommend(0);
					mealService.saveOrUpdate(meal);
				}
				res = Integer.valueOf(1);
			}
		}
		response.setContentType("application/json; charset=utf8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			if (res > 0) {
				writer.print("{\"message\":\"success\"}");
			} else {
				writer.print("{\"message\":\"error\"}");
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
			writer.print("{\"message\":\"error\"}");
		} finally {
			writer.flush();
			writer.close();
		}
	}

	/** 菜单列表 */
	@RequestMapping(value = "/listMenu")
	public void template(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		Menu menu = new Menu();
		Map<String, Object> serObj = getSearchObject(map, menu);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		menu = (Menu) serObj.get(menu.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<Menu> menus = null;
		try {
			if (menu.getStatus() != null && menu.getStatus() == -99) {
				menu.setStatus(null);
				search.getOps().remove("status");
			}
			if (menu.getType_name() != null
					&& menu.getType_name().equalsIgnoreCase("-99")) {
				menu.setType_name(null);
				search.getOps().remove("type_name");
			} else if (menu.getType_name() != null) {
				menu.setType_id(menu.getType_name());
				// menu.setType_name(null);
				search.getOps().remove("type_name");
				search.getOps().put("type_id", "eq");
			}

			Object[] objs = menuService.Search(menu, page, search);
			menus = (List<Menu>) objs[0];
			page = (Page) objs[1];
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}

		PrintWriter writer = null;
		response.setHeader("Content-type", "text/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		try {
			writer = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}
		if (menus != null) {
			JSONArray jsonObject = new JSONArray();
			if (menus.size() == 0) {
				menu.setId(0L);
				menu.setType_name("无匹配数据，请查询");
				menu.setStatus(-1);
				menus.add(menu);
			}
			for (Menu m : menus) {
				JSONObject json = new JSONObject();
				json.put("id", m.getId());
				json.put("name", m.getName());
				json.put("type_name", m.getType_name());
				json.put("picture", m.getPicture());
				if (m.getUpdateDate() != null)
					json.put("updateDate", m.getUpdateDate().toString());
				else
					json.put("updateDate", null);
				json.put("updater", m.getUpdater());
				json.put("remark", m.getRemark());
				json.put("status", m.getStatus());

				// 添加新加字段
				jsonObject.add(json);
			}

			JSONObject jsondata = new JSONObject();
			jsondata.put("page", page.getCurrentPage());
			jsondata.put("total", page.getTotalPage());
			jsondata.put("records", page.getRecordCount());
			jsondata.put("rows", jsonObject);

			writer.print(jsondata.toString());
		} else {
			writer.print("{\"message\":\"notExist\"}");
		}

	}

	/** 更新菜类 */
	@RequestMapping(value = "/saveOrUpdateMenu")
	public void saveOrUpdateMenu(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		User curUser = (User) session.getAttribute("curUser");

		Menu menu = new Menu();

		Map<String, Object> serObj = getOperationsAndfields(map, menu);
		String oper = serObj.get("oper").toString();
		menu = (Menu) serObj.get("object");
		if (oper.equalsIgnoreCase("del")) {
			String[] strs = (String[]) map.get("id");
			if (strs.length > 0 && strs[0].indexOf(",") > 0) {
				String sql = "";
				sql = "select * from menu where id in(" + strs[0] + ")";
				List<Menu> menus = (List<Menu>) menuService.selectBySql(sql,
						menu);
				Menu tempMenu = null;
				for (Menu m : menus) {
					tempMenu = m;
					tempMenu.setStatus(-1);
					tempMenu.setUpdateDate(new Date());
					tempMenu.setUpdater(curUser.getName());
					menuService.saveOrUpdate(tempMenu);
				}
			} else {

				menu = menuService.getObject(menu.getId().toString(), "id");
				menu.setStatus(-1);
				menu.setUpdateDate(new Date());
				menu.setUpdater(curUser.getName());
				menuService.saveOrUpdate(menu);
			}
		} else if (oper.equalsIgnoreCase("edit")) {
			Menu tempMenu = menuService
					.getObject(menu.getId().toString(), "id");
			tempMenu.setUpdateDate(new Date());
			tempMenu.setUpdater(curUser.getName());
			tempMenu.setStatus(menu.getStatus());
			tempMenu.setRemark(menu.getRemark());
			Type type = typeService.getObject(menu.getType_name(), "id");
			tempMenu.setType_name(type.getName());
			tempMenu.setType_id(type.getId().toString());
			menuService.saveOrUpdate(tempMenu);
		}
	}

	@RequestMapping(value = "/uploadImg", method = RequestMethod.POST)
	private void uploadImg(
			@RequestParam(value = "file", required = false) MultipartFile file,
			HttpServletRequest request, HttpServletResponse response,
			HttpSession session) {
		String typeId = (String) request.getParameter("type");

		String path = System.getProperty("user.dir").replace("bin",
				"uploadMenu\\");
		String tempPath = this.getClass().getResource("/").toString()
				.replace("classes/", "uploadMenu/").replace("file:/", "");

		String fileName = file.getOriginalFilename().trim();
		User curUser = (User) session.getAttribute("curUser");
		File targetFile = new File(path);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		}
		// 保存
		try {
			targetFile = new File(path, fileName);
			file.transferTo(targetFile);

			File temp = new File(tempPath);
			if (!temp.exists()) {
				temp.mkdirs();
			}
			temp = new File(path + fileName);
			FileInputStream input = new FileInputStream(temp);
			FileOutputStream output = new FileOutputStream(tempPath + fileName);
			byte[] b = new byte[1024 * 5];
			int len;
			while ((len = input.read(b)) != -1) {
				output.write(b, 0, len);
			}
			output.flush();
			output.close();
			input.close();

			Menu menu = new Menu();
			menu = menuService.getObject(fileName.split("\\.")[0], "name");
			Type type = typeService.getObject(typeId, "id");
			if (menu == null) {
				menu = new Menu();
			}
			menu.setName(fileName.split("\\.")[0]);
			menu.setPicture(fileName);
			menu.setStatus(0);
			menu.setType_id(typeId);
			menu.setType_name(type.getName());
			menu.setUpdateDate(new Date());
			menu.setUpdater(curUser.getName());
			menuService.saveOrUpdate(menu);

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}
	}

	public void copyFolder(String oldPath, String newPath) {

		try {
			(new File(newPath)).mkdirs(); // 如果文件夹不存在 则建立新文件夹
			File a = new File(oldPath);
			String[] file = a.list();
			File temp = null;
			for (int i = 0; i < file.length; i++) {
				if (oldPath.endsWith(File.separator)) {
					temp = new File(oldPath + file[i]);
				} else {
					temp = new File(oldPath + File.separator + file[i]);
				}

				if (temp.isFile()) {
					FileInputStream input = new FileInputStream(temp);
					FileOutputStream output = new FileOutputStream(newPath
							+ "/" + (temp.getName()).toString());
					byte[] b = new byte[1024 * 5];
					int len;
					while ((len = input.read(b)) != -1) {
						output.write(b, 0, len);
					}
					output.flush();
					output.close();
					input.close();
				}
				if (temp.isDirectory()) {// 如果是子文件夹
					copyFolder(oldPath + "/" + file[i], newPath + "/" + file[i]);
				}
			}
		} catch (Exception e) {
			System.out.println("复制整个文件夹内容操作出错");
			e.printStackTrace();
		}

	}

	public static Object setter(Object obj, String att, Object value,
			Class<?> type) {
		try {
			Method method = obj.getClass().getMethod("set" + att, type);
			method.invoke(obj, value);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}

		return obj;
	}

}