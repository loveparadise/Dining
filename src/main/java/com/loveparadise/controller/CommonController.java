package com.loveparadise.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.loveparadise.model.Book;
import com.loveparadise.model.DiningRoom;
import com.loveparadise.model.JudgeMeal;
import com.loveparadise.model.LimitedMealNumber;
import com.loveparadise.model.Meal;
import com.loveparadise.model.MealType;
import com.loveparadise.model.Page;
import com.loveparadise.model.Search;
import com.loveparadise.model.Type;
import com.loveparadise.model.User;
import com.loveparadise.service.impl.BookService;
import com.loveparadise.service.impl.DiningRoomService;
import com.loveparadise.service.impl.JudgeMealService;
import com.loveparadise.service.impl.LimitedMealNumberService;
import com.loveparadise.service.impl.MealService;
import com.loveparadise.service.impl.MenuService;
import com.loveparadise.service.impl.TypeService;
import com.loveparadise.service.impl.UserService;
import com.loveparadise.util.DateTransfer;
import com.loveparadise.util.IgnoreFieldProcessorImpl2;

@Controller
@RequestMapping("/common")
public class CommonController {

	private static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");

	public static final String FILE_SEPARATOR = System.getProperties()
			.getProperty("file.separator");

	@Resource(name = "menuService")
	public MenuService menuService;

	@Resource(name = "bookService")
	public BookService bookService;

	@Resource(name = "typeService")
	public TypeService typeService;

	@Resource(name = "diningRoomService")
	public DiningRoomService diningRoomService;

	@Resource(name = "userService")
	public UserService userService;

	@Resource(name = "judgeMealService")
	public JudgeMealService judgeMealService;

	@Resource(name = "mealService")
	public MealService mealService;

	@Resource(name = "limitedMealNumberService")
	public LimitedMealNumberService limitedMealNumberService;

	DateTransfer dt = new DateTransfer();

	/** 评价餐单 */
	@RequestMapping(value = "/judgeMeal")
	public void judgeMeal(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {

		String meal_id = request.getParameter("mealId");
		String mealType = request.getParameter("mealType");
		String dayDate = request.getParameter("dayDate");

		String score = request.getParameter("score");

		String Auser = request.getParameter("Auser");
		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from judgeMeal where meal_id='" + meal_id
				+ "' and mealType='" + mealType + "' and dayDate='" + dayDate
				+ "' and status>-1 and Auser='" + Auser + "'";
		List<JudgeMeal> judgeMeals = (List<JudgeMeal>) judgeMealService
				.selectBySql(sql, new JudgeMeal());
		if (judgeMeals != null && judgeMeals.size() > 0) {
			JudgeMeal judgeMeal = judgeMeals.get(0);
			judgeMeal.setScore(Integer.valueOf(score));
			judgeMeal.setUpdateDate(new Date());
			judgeMealService.saveOrUpdate(judgeMeal);
		} else {
			Meal meal = mealService.getObject(meal_id, "id");
			JudgeMeal judgeMeal = new JudgeMeal();
			judgeMeal.setUpdateDate(new Date());
			judgeMeal.setAuser(Auser);
			judgeMeal.setDayDate(dt.strToData(dayDate));
			judgeMeal.setDiningRoom_id(meal.getDiningRoom_id());
			judgeMeal.setDiningRoom_name(meal.getDiningRoom_name());
			judgeMeal.setMeal_id(meal.getId().toString());
			judgeMeal.setMealType(meal.getMealType());
			judgeMeal.setMenu_id(meal.getMenu_id());
			judgeMeal.setMenu_name(meal.getMenu_name());
			judgeMeal.setScore(Integer.valueOf(score));
			judgeMeal.setStatus(0);
			judgeMeal.setType_id(meal.getType_id());
			judgeMeal.setType_name(meal.getType_name());
			judgeMealService.saveOrUpdate(judgeMeal);
		}

		response.setContentType("application/json; charset=utf8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			writer.print("{\"message\":\"success\"}");

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
			writer.print("{\"message\":\"error\"}");
		} finally {
			writer.flush();
			writer.close();
		}
	}

	/** 餐菜单 */
	@RequestMapping(value = "/showMeal")
	public ModelAndView showMeal(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		String diningRoom_id = request.getParameter("diningRoom_id");

		String mealType = request.getParameter("mealType");

		if (dt.isInDate(new Date(), "00:00:00", "09:00:00")) {
			mealType = MealType.breakfast.toString();
		} else if (dt.isInDate(new Date(), "09:00:00", "13:00:00")) {
			mealType = MealType.lunch.toString();
		} else {
			mealType = MealType.dinner.toString();
		}

		String Auser = request.getParameter("Auser");
		String dayDate = request.getParameter("dayDate");
		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from meal where diningRoom_id='"
				+ (diningRoom_id == null ? 1 : diningRoom_id)
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1";
		List<Meal> meals = (List<Meal>) mealService
				.selectBySql(sql, new Meal());

		sql = "select * from judgeMeal where diningRoom_id='"
				+ diningRoom_id
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1 and Auser='" + Auser
				+ "'";
		List<JudgeMeal> judgeMeals = (List<JudgeMeal>) judgeMealService
				.selectBySql(sql, new JudgeMeal());

		for (JudgeMeal judgeMeal : judgeMeals) {
			for (Meal meal : meals)
				if (judgeMeal.getMeal_id().equalsIgnoreCase(
						meal.getId().toString())) {
					meal.setScore(judgeMeal.getScore());
					break;
				}
		}

		List<DiningRoom> diningRooms = diningRoomService.getObjects("0",
				"status", "ge");
		List<DiningRoom> diningRoomsTemp = new ArrayList<DiningRoom>();
		for (DiningRoom diningRoom : diningRooms) {
			if (diningRoom.getStatus() > -1)
				diningRoomsTemp.add(diningRoom);
		}

		String diningRoomsStr = "";

		for (DiningRoom dr : diningRooms) {
			diningRoomsStr = diningRoomsStr + dr.getId() + ":" + dr.getName()
					+ ",";
		}

		diningRoomsStr = diningRoomsStr.substring(0,
				diningRoomsStr.length() - 1);

		ModelAndView mv = new ModelAndView();
		mv.addObject("diningRooms", diningRoomsStr);

		mv.addObject("meals", meals);
		if (meals == null || meals.size() == 0)
			mv.addObject("diningRoom", diningRooms.get(0));
		else
			mv.addObject("diningRoom", diningRoomService.getObject(meals.get(0)
					.getDiningRoom_id(), "id"));
		mv.addObject("mealType", MealType.valueOf(mealType));

		mv.setViewName("showMeal");

		return mv;
	}

	/** 餐菜单 */
	@RequestMapping(value = "/getMeals")
	public void getMeals(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		String diningRoom_id = request.getParameter("diningRoom_id");

		String mealType = "";

		if (dt.isInDate(new Date(), "00:00:00", "09:00:00")) {
			mealType = MealType.breakfast.toString();
		} else if (dt.isInDate(new Date(), "09:00:00", "13:00:00")) {
			mealType = MealType.lunch.toString();
		} else {
			mealType = MealType.dinner.toString();
		}

		String Auser = request.getParameter("Auser");
		String dayDate = request.getParameter("dayDate");
		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from meal where diningRoom_id='"
				+ diningRoom_id
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1";
		List<Meal> meals = (List<Meal>) mealService
				.selectBySql(sql, new Meal());

		sql = "select * from judgeMeal where diningRoom_id='"
				+ diningRoom_id
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1 and Auser='" + Auser
				+ "'";
		List<JudgeMeal> judgeMeals = (List<JudgeMeal>) judgeMealService
				.selectBySql(sql, new JudgeMeal());

		for (JudgeMeal judgeMeal : judgeMeals) {
			for (Meal meal : meals)
				if (judgeMeal.getMeal_id().equalsIgnoreCase(
						meal.getId().toString())) {
					meal.setScore(judgeMeal.getScore());
					break;
				}
		}

		JSONArray json = IgnoreFieldProcessorImpl2.ArrayJsonConfig(new String[] {
				"id", "menu_name", "mealType", "remark", "type_name",
				"picture", "score", "dayDate" }, meals);
		String str = json.toString();// 把json转换为String

		response.setContentType("application/json; charset=utf8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			if (meals != null && meals.size() > 0)
				writer.print(str);
			else
				writer.print("{\"message\":\"empty\"}");

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
			writer.print("{\"message\":\"error\"}");
		} finally {
			writer.flush();
			writer.close();
		}
	}

	/** 餐菜单 */
	@RequestMapping(value = "/showMeal_")
	public ModelAndView showMeal_(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		String diningRoom_id = request.getParameter("diningRoom_id");

		String mealType = request.getParameter("mealType");

		String Auser = request.getParameter("Auser");
		String dayDate = request.getParameter("dayDate");
		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from meal where diningRoom_id='"
				+ diningRoom_id
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1";
		List<Meal> meals = (List<Meal>) mealService
				.selectBySql(sql, new Meal());

		sql = "select * from judgeMeal where diningRoom_id='"
				+ diningRoom_id
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1 and Auser='" + Auser
				+ "'";
		List<JudgeMeal> judgeMeals = (List<JudgeMeal>) judgeMealService
				.selectBySql(sql, new JudgeMeal());

		for (JudgeMeal judgeMeal : judgeMeals) {
			for (Meal meal : meals)
				if (judgeMeal.getMeal_id().equalsIgnoreCase(
						meal.getId().toString())) {
					meal.setScore(judgeMeal.getScore());
					break;
				}
		}

		ModelAndView mv = new ModelAndView();

		mv.addObject("meals", meals);
		mv.addObject("mealType", MealType.valueOf(mealType));

		mv.setViewName("showMeal");

		return mv;
	}

	/** 是否已订餐 */
	@RequestMapping(value = "/checkIsBook")
	public void checkIsBook(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		String diningRoom_name = request.getParameter("diningRoom_id");

		String mealType = request.getParameter("mealType");

		String Auser = request.getParameter("Auser");
		String dayDate = request.getParameter("dayDate");

		String bookMsg = request.getParameter("bookMsg");
		String number = request.getParameter("number");

		String msg[] = bookMsg.split(" ");
		if (msg != null && msg.length > 0) {
			dayDate = msg[0];
			diningRoom_name = msg[1];

			for (MealType meal : MealType.values()) {
				if (meal.getText().equalsIgnoreCase(msg[2])) {
					mealType = meal.toString();
					break;
				}
			}
		}

		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from book where diningRoom_name='"
				+ diningRoom_name
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1 and Auser='" + Auser
				+ "'";
		List<Book> books = (List<Book>) bookService
				.selectBySql(sql, new Book());

		Book book = null;
		if (books != null && books.size() > 0) {
			book = books.get(0);
		}

		response.setContentType("application/json; charset=utf8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			if (book != null)
				writer.print("{\"message\":\"success\"" + ",\"number\":\""
						+ book.getNumber() + "\"}");
			else
				writer.print("{\"message\":\"success\"}");

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
			writer.print("{\"message\":\"error\"}");
		} finally {
			writer.flush();
			writer.close();
		}

	}

	/** 取消订餐 */
	@RequestMapping(value = "/cancelBook")
	public void cancelBook(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		String diningRoom_name = request.getParameter("diningRoom_id");

		String mealType = request.getParameter("mealType");

		String Auser = request.getParameter("Auser");
		String dayDate = request.getParameter("dayDate");

		String bookMsg = request.getParameter("bookMsg");
		String number = request.getParameter("number");

		String msg[] = bookMsg.split(" ");
		if (msg != null && msg.length > 0) {
			dayDate = msg[0];
			diningRoom_name = msg[1];

			for (MealType meal : MealType.values()) {
				if (meal.getText().equalsIgnoreCase(msg[2])) {
					mealType = meal.toString();
					break;
				}
			}
		}

		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from book where diningRoom_name='"
				+ diningRoom_name
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1 and Auser='" + Auser
				+ "'";
		List<Book> books = (List<Book>) bookService
				.selectBySql(sql, new Book());

		Book book = null;
		if (books != null && books.size() > 0) {
			book = books.get(0);
			book.setStatus(-1);
			book.setCancelDateTime(new Date());
			bookService.saveOrUpdate(book);
		}

		response.setContentType("application/json; charset=utf8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			if (book != null)
				writer.print("{\"message\":\"success\"" + ",\"number\":\""
						+ book.getNumber() + "\"}");
			else
				writer.print("{\"message\":\"success\"}");

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
			writer.print("{\"message\":\"error\"}");
		} finally {
			writer.flush();
			writer.close();
		}

	}

	/** 预订用餐 */
	@RequestMapping(value = "/bookMeal")
	public void bookMeal(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		String diningRoom_name = request.getParameter("diningRoom_id");

		String mealType = request.getParameter("mealType");

		String Auser = request.getParameter("Auser");
		String bookMsg = request.getParameter("bookMsg");
		String dayDate = request.getParameter("dayDate");
		String number = request.getParameter("number");

		String msg[] = bookMsg.split(" ");
		if (msg != null && msg.length > 0) {
			dayDate = msg[0];
			diningRoom_name = msg[1];

			for (MealType meal : MealType.values()) {
				if (meal.getText().equalsIgnoreCase(msg[2])) {
					mealType = meal.toString();
					break;
				}
			}
		}

		if (Auser == null)
			Auser = "18659230287";

		String sql = "select * from book where diningRoom_name='"
				+ diningRoom_name
				+ "' and mealType='"
				+ mealType
				+ "' and dayDate='"
				+ (dayDate == null || dayDate == "" ? dt.dataToStr2(new Date())
						: dayDate) + "' and status>-1 and Auser='" + Auser
				+ "'";
		List<Book> books = (List<Book>) bookService
				.selectBySql(sql, new Book());

		if (books != null && books.size() > 0) {
			for (Book book : books) {
				book.setNumber(Integer.valueOf(number));
				book.setBookDateTime(new Date());
				bookService.saveOrUpdate(book);
			}
		} else {
			DiningRoom diningRoom = diningRoomService.getObject(
					diningRoom_name, "name");
			Book book = new Book();
			book.setNumber(Integer.valueOf(number));
			book.setBookDateTime(new Date());
			book.setAuser(Auser);
			book.setDayDate(dt.strToData(dayDate));
			book.setDiningRoom_id(diningRoom.getId().toString());
			book.setDiningRoom_name(diningRoom.getName());
			book.setMealType(mealType);
			book.setStatus(0);
			bookService.saveOrUpdate(book);
		}

		response.setContentType("application/json; charset=utf8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			writer.print("{\"message\":\"success\"}");

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
			writer.print("{\"message\":\"error\"}");
		} finally {
			writer.flush();
			writer.close();
		}

	}

	/** 选择餐单 */
	@RequestMapping(value = "/chooseMeal")
	public ModelAndView chooseMeal(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {

		ModelAndView mv = new ModelAndView();
		String sql = "SELECT * from meal WHERE dayDate='"
				+ dt.dataToStr2(new Date())
				+ "' and status>-1 GROUP BY diningRoom_id,mealType";

		List<Meal> meals = (List<Meal>) mealService
				.selectBySql(sql, new Meal());
		List<Meal> mealsTemp = new ArrayList<Meal>();
		Meal meal = new Meal();
		if (meals != null && meals.size() > 0) {
			for (int i = 0; i < meals.size(); i++) {
				if (meals.get(i).getRecommend() == 0) {
					sql = "SELECT * from meal WHERE dayDate='"
							+ dt.dataToStr2(new Date())
							+ "' and diningRoom_id='"
							+ meals.get(i).getDiningRoom_id()
							+ "' and mealType='" + meals.get(i).getMealType()
							+ "' and recommend=1 and status>-1";
					mealsTemp = (List<Meal>) mealService.selectBySql(sql,
							new Meal());
					if (mealsTemp != null && mealsTemp.size() > 0) {
						mealsTemp.get(0)
								.setRemark(
										MealType.valueOf(
												mealsTemp.get(0).getMealType())
												.getText());
						meals.set(i, mealsTemp.get(0));
					} else {
						meal = meals.get(i);
						meal.setRemark(MealType.valueOf(meal.getMealType())
								.getText());
						meals.set(i, meal);
					}
				} else {
					meal = meals.get(i);
					meal.setRemark(MealType.valueOf(meal.getMealType())
							.getText());
					meals.set(i, meal);
				}

			}
		}
		mv.addObject("meals", meals);

		mv.setViewName("chooseMeal");

		return mv;
	}

	/** 进入预订用餐 */
	@RequestMapping(value = "/preBook")
	public ModelAndView preBook(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {

		ModelAndView mv = new ModelAndView();

		List<DiningRoom> diningRooms = diningRoomService.getObjects("0",
				"bookFlag", "eq");
		List<DiningRoom> diningRoomsTemp = new ArrayList<DiningRoom>();
		for (DiningRoom diningRoom : diningRooms) {
			if (diningRoom.getStatus() > -1)
				diningRoomsTemp.add(diningRoom);
		}
		List<Type> types = typeService.getObjects("0", "status", "eq");
		MealType[] mealTypes = { MealType.afternoonTea, MealType.lunch,
				MealType.breakfast, MealType.dinner };
		String colStr = "[{textAlign: 'center',values:[";

		Date dayDate = new Date();
		for (int i = 0; i < 3; i++) {
			colStr = colStr + "'" + dt.dataToStr2(dt.afterToday(dayDate, i))
					+ "',";
		}
		colStr = colStr.substring(0, colStr.length() - 1)
				+ "]},{ textAlign: 'center',values: [";

		for (DiningRoom dr : diningRooms) {
			colStr = colStr + "'" + dr.getName() + "',";
		}

		colStr = colStr.substring(0, colStr.length() - 1)
				+ "]},{ textAlign: 'center',values: [";

		for (MealType mt : mealTypes) {
			colStr = colStr + "'" + mt.getText() + "',";
		}

		colStr = colStr.substring(0, colStr.length() - 1) + "]}]";

		mv.addObject("colStr", colStr);

		mv.setViewName("preBook");

		return mv;
	}

	/** 每餐餐单 */
	@RequestMapping(value = "/listMeal")
	public void listMeal(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		Meal meal = new Meal();
		Map<String, Object> serObj = getSearchObject(map, meal);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		meal = (Meal) serObj.get(meal.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<Meal> meals = null;
		try {
			if (meal.getStatus() != null && meal.getStatus() == -99) {
				meal.setStatus(null);
				search.getOps().remove("status");
			}

			if (meal.getRecommend() != null && meal.getRecommend() == -99) {
				meal.setRecommend(null);
				search.getOps().remove("recommend");
			}

			if (meal.getType_name() != null
					&& meal.getType_name().equalsIgnoreCase("-99")) {
				meal.setType_name(null);
				search.getOps().remove("type_name");
			} else if (meal.getType_name() != null) {
				meal.setType_id(meal.getType_name());
				// meal.setType_name(null);
				search.getOps().remove("type_name");
				search.getOps().put("type_id", "eq");
			}

			if (meal.getDiningRoom_name() != null
					&& meal.getDiningRoom_name().equalsIgnoreCase("-99")) {
				meal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
			} else if (meal.getDiningRoom_name() != null) {
				meal.setDiningRoom_id(meal.getDiningRoom_name());
				// meal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
				search.getOps().put("diningRoom_id", "eq");
			}

			if (meal.getMealType() != null
					&& meal.getMealType().equalsIgnoreCase("-99")) {
				meal.setMealType(null);
				search.getOps().remove("mealType");
			}

			Object[] objs = mealService.Search(meal, page, search);
			meals = (List<Meal>) objs[0];
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
		if (meals != null) {
			JSONArray jsonObject = new JSONArray();

			for (Meal o : meals) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("diningRoom_name", o.getDiningRoom_name());
				json.put("type_name", o.getType_name());
				json.put("menu_name", o.getMenu_name());
				json.put("mealType", MealType.valueOf(o.getMealType())
						.getText());
				json.put("dayDate", o.getDayDate().toString());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("updater", o.getUpdater());
				json.put("remark", o.getRemark());
				json.put("picture", o.getPicture());
				json.put("recommend", o.getRecommend());
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

	/** 删除餐菜单 */
	@RequestMapping(value = "/saveOrUpdateMeal")
	public void saveOrUpdateMeal(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		User curUser = (User) session.getAttribute("curUser");

		Meal meal = new Meal();

		Map<String, Object> serObj = getOperationsAndfields(map, meal);
		String oper = serObj.get("oper").toString();
		if (oper.equalsIgnoreCase("edit")) {
			meal = (Meal) serObj.get("object");
			Meal mealTemp = new Meal();
			String sql = "";
			sql = "select * from meal where id=" + meal.getId();

			List<Meal> meals = (List<Meal>) mealService.selectBySql(sql, meal);
			if (meals.size() > 0) {
				mealTemp = meals.get(0);
				mealTemp.setStatus(meal.getStatus());
				mealTemp.setRecommend(meal.getRecommend());
				mealTemp.setRemark(meal.getRemark());
				mealTemp.setUpdateDate(new Date());
				mealTemp.setUpdater(curUser.getName());
				mealService.saveOrUpdate(mealTemp);
			}
		} else if (oper.equalsIgnoreCase("del")) {
			meal = (Meal) serObj.get("object");
			Meal mealTemp = new Meal();
			String sql = "";
			sql = "select * from meal where id=" + meal.getId();

			String[] strs = (String[]) map.get("id");
			if (strs.length > 0 && strs[0].indexOf(",") > 0) {
				sql = "select * from meal where id in(" + strs[0] + ")";
				List<Meal> meals = (List<Meal>) mealService.selectBySql(sql,
						meal);
				for (Meal m : meals) {
					mealTemp = m;
					mealTemp.setStatus(-1);
					mealTemp.setUpdateDate(new Date());
					mealTemp.setUpdater(curUser.getName());
					mealService.saveOrUpdate(mealTemp);
				}
			} else {
				List<Meal> meals = (List<Meal>) mealService.selectBySql(sql,
						meal);
				mealTemp = meals.get(0);
				mealTemp.setStatus(-1);
				mealTemp.setUpdateDate(new Date());
				mealTemp.setUpdater(curUser.getName());
				mealService.saveOrUpdate(mealTemp);
			}
		}
	}

	/** 订餐详情 */
	@RequestMapping(value = "/listBook")
	public void listBook(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		Book book = new Book();
		Map<String, Object> serObj = getSearchObject(map, book);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		book = (Book) serObj.get(book.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<Book> books = null;
		try {
			if (book.getStatus() != null && book.getStatus() == -99) {
				book.setStatus(null);
				search.getOps().remove("status");
			}

			if (book.getMealType() != null
					&& book.getMealType().equalsIgnoreCase("-99")) {
				book.setMealType(null);
				search.getOps().remove("mealType");
			}

			if (book.getDiningRoom_name() != null
					&& book.getDiningRoom_name().equalsIgnoreCase("-99")) {
				book.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
			} else if (book.getDiningRoom_name() != null) {
				book.setDiningRoom_id(book.getDiningRoom_name());
				// meal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
				search.getOps().put("diningRoom_id", "eq");
			}

			Object[] objs = bookService.Search(book, page, search);
			books = (List<Book>) objs[0];
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
		if (books != null) {
			JSONArray jsonObject = new JSONArray();

			for (Book o : books) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("diningRoom_name", o.getDiningRoom_name());
				json.put("number", o.getNumber());
				json.put("mealType", MealType.valueOf(o.getMealType())
						.getText());
				json.put("dayDate", o.getDayDate().toString());
				json.put("bookDateTime", o.getBookDateTime().toString());
				if (o.getCancelDateTime() != null)
					json.put("cancelDateTime", o.getCancelDateTime().toString());
				else
					json.put("cancelDateTime", "");
				json.put("Auser", o.getAuser());
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

	/** 评价汇总 */
	@RequestMapping(value = "/summaryJudge")
	public void summaryJudge(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		JudgeMeal judgeMeal = new JudgeMeal();
		Map<String, Object> serObj = getSearchObject(map, judgeMeal);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		judgeMeal = (JudgeMeal) serObj.get(judgeMeal.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<JudgeMeal> judgeMeals = null;
		try {
			if (judgeMeal.getStatus() != null && judgeMeal.getStatus() == -99) {
				judgeMeal.setStatus(null);
				search.getOps().remove("status");
			}

			if (judgeMeal.getType_name() != null
					&& judgeMeal.getType_name().equalsIgnoreCase("-99")) {
				judgeMeal.setType_name(null);
				search.getOps().remove("type_name");
			} else if (judgeMeal.getType_name() != null) {
				judgeMeal.setType_id(judgeMeal.getType_name());
				// menu.setType_name(null);
				search.getOps().remove("type_name");
				search.getOps().put("type_id", "eq");
			}

			if (judgeMeal.getMealType() != null
					&& judgeMeal.getMealType().equalsIgnoreCase("-99")) {
				judgeMeal.setMealType(null);
				search.getOps().remove("mealType");
			}

			if (judgeMeal.getDiningRoom_name() != null
					&& judgeMeal.getDiningRoom_name().equalsIgnoreCase("-99")) {
				judgeMeal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
			} else if (judgeMeal.getDiningRoom_name() != null) {
				judgeMeal.setDiningRoom_id(judgeMeal.getDiningRoom_name());
				// meal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
				search.getOps().put("diningRoom_id", "eq");
			}

			Object[] objs = judgeMealService.Search(judgeMeal, page, search);
			judgeMeals = (List<JudgeMeal>) objs[0];
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
		if (judgeMeals != null) {
			JSONArray jsonObject = new JSONArray();

			for (JudgeMeal o : judgeMeals) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("type_name", o.getType_name());
				json.put("diningRoom_name", o.getDiningRoom_name());
				json.put("score", o.getScore());
				json.put("menu_name", o.getMenu_name());
				json.put("mealType", MealType.valueOf(o.getMealType())
						.getText());
				json.put("dayDate", o.getDayDate().toString());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("Auser", o.getAuser());
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

	/** 评价详情列表 */
	@RequestMapping(value = "/listJudge")
	public void listJudge(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		JudgeMeal judgeMeal = new JudgeMeal();
		Map<String, Object> serObj = getSearchObject(map, judgeMeal);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		judgeMeal = (JudgeMeal) serObj.get(judgeMeal.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<JudgeMeal> judgeMeals = null;
		try {
			if (judgeMeal.getStatus() != null && judgeMeal.getStatus() == -99) {
				judgeMeal.setStatus(null);
				search.getOps().remove("status");
			}

			if (judgeMeal.getType_name() != null
					&& judgeMeal.getType_name().equalsIgnoreCase("-99")) {
				judgeMeal.setType_name(null);
				search.getOps().remove("type_name");
			} else if (judgeMeal.getType_name() != null) {
				judgeMeal.setType_id(judgeMeal.getType_name());
				// menu.setType_name(null);
				search.getOps().remove("type_name");
				search.getOps().put("type_id", "eq");
			}

			if (judgeMeal.getMealType() != null
					&& judgeMeal.getMealType().equalsIgnoreCase("-99")) {
				judgeMeal.setMealType(null);
				search.getOps().remove("mealType");
			}

			if (judgeMeal.getDiningRoom_name() != null
					&& judgeMeal.getDiningRoom_name().equalsIgnoreCase("-99")) {
				judgeMeal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
			} else if (judgeMeal.getDiningRoom_name() != null) {
				judgeMeal.setDiningRoom_id(judgeMeal.getDiningRoom_name());
				// meal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
				search.getOps().put("diningRoom_id", "eq");
			}

			Object[] objs = judgeMealService.Search(judgeMeal, page, search);
			judgeMeals = (List<JudgeMeal>) objs[0];
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
		if (judgeMeals != null) {
			JSONArray jsonObject = new JSONArray();

			for (JudgeMeal o : judgeMeals) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("type_name", o.getType_name());
				json.put("diningRoom_name", o.getDiningRoom_name());
				json.put("score", o.getScore());
				json.put("menu_name", o.getMenu_name());
				json.put("mealType", MealType.valueOf(o.getMealType())
						.getText());
				json.put("dayDate", o.getDayDate().toString());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("Auser", o.getAuser());
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

	/** 用户列表 */
	@RequestMapping(value = "/listUser")
	public void listUser(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		User user = new User();
		Map<String, Object> serObj = getSearchObject(map, user);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		user = (User) serObj.get(user.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<User> users = null;
		try {
			if (user.getStatus() != null && user.getStatus() == -99) {
				user.setStatus(null);
				search.getOps().remove("status");
			}
			Object[] objs = userService.Search(user, page, search);
			users = (List<User>) objs[0];
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
		if (users != null) {
			JSONArray jsonObject = new JSONArray();

			for (User o : users) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("account", o.getAccount());
				json.put("name", o.getName());
				json.put("authority", o.getAuthority());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("updater", o.getUpdater());
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

	/** 更新用户 */
	@RequestMapping(value = "/saveOrUpdateUser")
	public void saveOrUpdateUser(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		User curUser = (User) session.getAttribute("curUser");

		User user = new User();

		Map<String, Object> serObj = getOperationsAndfields(map, user);
		String oper = serObj.get("oper").toString();
		user = (User) serObj.get("object");
		User userTemp;
		String sql = "";
		if (oper.equalsIgnoreCase("add")) {
			sql = "select * from user where account='"
					+ user.getAccount().trim() + "'";
			List<User> users = (List<User>) userService.selectBySql(sql, user);
			if (users.size() > 0)
				userTemp = users.get(0);
			else
				userTemp = null;
			if (userTemp == null) {
				user.setUpdateDate(new Date());
				user.setUpdater(curUser.getName());
				userService.saveOrUpdate(user);
			} else {
				if (user.getStatus() == 0)
					userTemp.setStatus(0);
				else
					userTemp.setStatus(-1);
				userTemp.setUpdateDate(new Date());
				userTemp.setUpdater(curUser.getName());
				userService.saveOrUpdate(userTemp);
			}

		} else if (oper.equalsIgnoreCase("del")) {
			String[] strs = (String[]) map.get("id");
			if (strs.length > 0 && strs[0].indexOf(",") > 0) {
				sql = "select * from user where id in(" + strs[0] + ")";
				List<User> users = (List<User>) userService.selectBySql(sql,
						user);
				User tempUser = null;
				for (User m : users) {
					tempUser = m;
					tempUser.setStatus(-1);
					tempUser.setUpdateDate(new Date());
					tempUser.setUpdater(curUser.getName());
					userService.saveOrUpdate(tempUser);
				}
			} else {
				user = userService.getObject(user.getId().toString(), "id");
				user.setStatus(-1);
				user.setUpdateDate(new Date());
				user.setUpdater(curUser.getName());
				userService.saveOrUpdate(user);
			}
		} else if (oper.equalsIgnoreCase("edit")) {
			sql = "select * from user where account='"
					+ user.getAccount().trim() + "'";
			List<User> users = (List<User>) userService.selectBySql(sql, user);
			if (users.size() > 0)
				userTemp = users.get(0);
			else
				userTemp = null;
			if (user.getStatus() == -1) {
				user.setUpdateDate(new Date());
				user.setUpdater(curUser.getName());
				userService.saveOrUpdate(user);
			} else if (userTemp == null) {
				user.setUpdateDate(new Date());
				user.setUpdater(curUser.getName());
				userService.saveOrUpdate(user);
			} else if (userTemp.getId() != user.getId()) {
				userTemp.setStatus(0);
				userTemp.setAccount(user.getAccount().trim());
				userTemp.setName(user.getName().trim());
				userTemp.setUpdateDate(new Date());
				userTemp.setUpdater(curUser.getName());
				userService.saveOrUpdate(userTemp);
				user.setStatus(-1);
				user.setUpdateDate(new Date());
				user.setUpdater(curUser.getName());
				userService.saveOrUpdate(user);

			} else {
				userTemp.setStatus(0);
				userTemp.setAccount(user.getAccount().trim());
				userTemp.setName(user.getName().trim());
				userTemp.setUpdateDate(new Date());
				userTemp.setUpdater(curUser.getName());
				userService.saveOrUpdate(userTemp);
			}
		}
	}

	/** 限餐列表 */
	@RequestMapping(value = "/listLimitedMealNumber")
	public void listLimitedMealNumber(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		LimitedMealNumber limitedMealNumber = new LimitedMealNumber();
		Map<String, Object> serObj = getSearchObject(map, limitedMealNumber);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		limitedMealNumber = (LimitedMealNumber) serObj.get(limitedMealNumber
				.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<LimitedMealNumber> limitedMealNumbers = null;
		try {
			if (limitedMealNumber.getStatus() != null
					&& limitedMealNumber.getStatus() == -99) {
				limitedMealNumber.setStatus(null);
				search.getOps().remove("status");
			}
			if (limitedMealNumber.getMealType() != null
					&& limitedMealNumber.getMealType().equalsIgnoreCase("-99")) {
				limitedMealNumber.setMealType(null);
				search.getOps().remove("mealType");
			}

			if (limitedMealNumber.getDiningRoom_name() != null
					&& limitedMealNumber.getDiningRoom_name().equalsIgnoreCase(
							"-99")) {
				limitedMealNumber.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
			} else if (limitedMealNumber.getDiningRoom_name() != null) {
				limitedMealNumber.setDiningRoom_id(limitedMealNumber
						.getDiningRoom_name());
				// meal.setDiningRoom_name(null);
				search.getOps().remove("diningRoom_name");
				search.getOps().put("diningRoom_id", "eq");
			}

			Object[] objs = limitedMealNumberService.Search(limitedMealNumber,
					page, search);
			limitedMealNumbers = (List<LimitedMealNumber>) objs[0];
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
		if (limitedMealNumbers != null) {
			JSONArray jsonObject = new JSONArray();

			for (LimitedMealNumber o : limitedMealNumbers) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("diningRoom_id", o.getDiningRoom_id());
				json.put("diningRoom_name", o.getDiningRoom_name());
				json.put("number", o.getNumber());
				json.put("remark", o.getRemark());
				json.put("mealType", MealType.valueOf(o.getMealType())
						.getText());
				json.put("dayDate", o.getDayDate().toString());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("updater", o.getUpdater());
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

	/** 更新餐厅 */
	@RequestMapping(value = "/saveOrUpdateLimitedMealNumber")
	public void saveOrUpdateLimitedMealNumber(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		User curUser = (User) session.getAttribute("curUser");

		LimitedMealNumber limitedMealNumber = new LimitedMealNumber();

		Map<String, Object> serObj = getOperationsAndfields(map,
				limitedMealNumber);
		String oper = serObj.get("oper").toString();
		limitedMealNumber = (LimitedMealNumber) serObj.get("object");
		LimitedMealNumber limitedMealNumberTemp = new LimitedMealNumber();
		String sql = "";
		if (oper.equalsIgnoreCase("add")) {
			sql = "select * from limitedMealNumber where diningRoom_id='"
					+ limitedMealNumber.getDiningRoom_name()
					+ "' and mealType='" + limitedMealNumber.getMealType()
					+ "' and dayDate='" + limitedMealNumber.getDayDate() + "'";
			List<LimitedMealNumber> lmns = (List<LimitedMealNumber>) limitedMealNumberService
					.selectBySql(sql, limitedMealNumber);
			if (lmns.size() > 0)
				limitedMealNumberTemp = lmns.get(0);
			else
				limitedMealNumberTemp = null;
			if (limitedMealNumberTemp == null) {
				DiningRoom diningRoomTemp = diningRoomService.getObject(
						limitedMealNumber.getDiningRoom_name().trim(), "id");
				limitedMealNumber.setDiningRoom_id(diningRoomTemp.getId()
						.toString());
				limitedMealNumber.setDiningRoom_name(diningRoomTemp.getName());
				limitedMealNumber.setUpdateDate(new Date());
				limitedMealNumber.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumber);
			} else {
				limitedMealNumberTemp.setStatus(0);
				limitedMealNumberTemp.setUpdateDate(new Date());
				limitedMealNumberTemp.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumberTemp);
			}

		} else if (oper.equalsIgnoreCase("del")) {
			String[] strs = (String[]) map.get("id");
			if (strs.length > 0 && strs[0].indexOf(",") > 0) {
				sql = "select * from limitedMealNumber where id in(" + strs[0]
						+ ")";
				List<LimitedMealNumber> limitedMealNumbers = (List<LimitedMealNumber>) limitedMealNumberService
						.selectBySql(sql, limitedMealNumber);
				LimitedMealNumber tempLimitedMealNumber = null;
				for (LimitedMealNumber m : limitedMealNumbers) {
					tempLimitedMealNumber = m;
					tempLimitedMealNumber.setStatus(-1);
					tempLimitedMealNumber.setUpdateDate(new Date());
					tempLimitedMealNumber.setUpdater(curUser.getName());
					limitedMealNumberService
							.saveOrUpdate(tempLimitedMealNumber);
				}
			} else {

				limitedMealNumber = limitedMealNumberService.getObject(
						limitedMealNumber.getId().toString(), "id");
				limitedMealNumber.setStatus(-1);
				limitedMealNumber.setUpdateDate(new Date());
				limitedMealNumber.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumber);
			}
		} else if (oper.equalsIgnoreCase("edit")) {
			sql = "select * from limitedMealNumber where diningRoom_id='"
					+ limitedMealNumber.getDiningRoom_name()
					+ "' and mealType='" + limitedMealNumber.getMealType()
					+ "' and dayDate='"
					+ dt.dataToStr2(limitedMealNumber.getDayDate()) + "'";

			List<LimitedMealNumber> lmns = (List<LimitedMealNumber>) limitedMealNumberService
					.selectBySql(sql, limitedMealNumber);
			if (lmns.size() > 0)
				limitedMealNumberTemp = lmns.get(0);
			else
				limitedMealNumberTemp = null;
			if (limitedMealNumber.getStatus() == -1) {
				limitedMealNumber.setUpdateDate(new Date());
				limitedMealNumber.setUpdater(curUser.getName());
				try {
					limitedMealNumberService.saveOrUpdate(limitedMealNumber);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else if (limitedMealNumberTemp == null) {
				DiningRoom diningRoomTemp = diningRoomService.getObject(
						limitedMealNumber.getDiningRoom_name().trim(), "id");
				limitedMealNumber.setDiningRoom_id(diningRoomTemp.getId()
						.toString());
				limitedMealNumber.setDiningRoom_name(diningRoomTemp.getName());
				limitedMealNumber.setUpdateDate(new Date());
				limitedMealNumber.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumber);
			} else if (limitedMealNumberTemp.getId() != limitedMealNumber
					.getId()) {
				limitedMealNumberTemp.setStatus(0);
				limitedMealNumberTemp.setNumber(limitedMealNumber.getNumber());
				limitedMealNumberTemp.setRemark(limitedMealNumber.getRemark());
				limitedMealNumberTemp.setUpdateDate(new Date());
				limitedMealNumberTemp.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumberTemp);
				limitedMealNumber.setStatus(-1);
				limitedMealNumber.setUpdateDate(new Date());
				limitedMealNumber.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumber);

			} else {
				limitedMealNumberTemp.setStatus(0);
				limitedMealNumberTemp.setNumber(limitedMealNumber.getNumber());
				limitedMealNumberTemp.setRemark(limitedMealNumber.getRemark());
				limitedMealNumberTemp.setUpdateDate(new Date());
				limitedMealNumberTemp.setUpdater(curUser.getName());
				limitedMealNumberService.saveOrUpdate(limitedMealNumberTemp);
			}
		}
	}

	/** 餐厅列表 */
	@RequestMapping(value = "/listDiningRoom")
	public void listDiningRoom(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		DiningRoom diningRoom = new DiningRoom();
		Map<String, Object> serObj = getSearchObject(map, diningRoom);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		diningRoom = (DiningRoom) serObj.get(diningRoom.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<DiningRoom> diningRooms = null;
		try {
			if (diningRoom.getStatus() != null && diningRoom.getStatus() == -99) {
				diningRoom.setStatus(null);
				search.getOps().remove("status");
			}
			if (diningRoom.getBookFlag() != null
					&& diningRoom.getBookFlag() == -99) {
				diningRoom.setBookFlag(null);
				search.getOps().remove("bookFlag");
			}
			Object[] objs = diningRoomService.Search(diningRoom, page, search);
			diningRooms = (List<DiningRoom>) objs[0];
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
		if (diningRooms != null) {
			JSONArray jsonObject = new JSONArray();

			for (DiningRoom o : diningRooms) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("name", o.getName());
				json.put("number", o.getNumber());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("updater", o.getUpdater());
				json.put("bookFlag", o.getBookFlag());
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

	/** 更新餐厅 */
	@RequestMapping(value = "/saveOrUpdateDiningRoom")
	public void saveOrUpdateDiningRoom(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		User curUser = (User) session.getAttribute("curUser");

		DiningRoom diningRoom = new DiningRoom();

		Map<String, Object> serObj = getOperationsAndfields(map, diningRoom);
		String oper = serObj.get("oper").toString();
		diningRoom = (DiningRoom) serObj.get("object");
		DiningRoom diningRoomTemp;
		if (oper.equalsIgnoreCase("add")) {
			diningRoomTemp = diningRoomService.getObject(diningRoom.getName()
					.trim(), "name");
			if (diningRoomTemp == null) {
				diningRoom.setStatus(0);
				diningRoom.setName(diningRoom.getName().trim());
				diningRoom.setUpdateDate(new Date());
				diningRoom.setUpdater(curUser.getName());
				diningRoomService.saveOrUpdate(diningRoom);
			} else {
				diningRoomTemp.setStatus(0);
				diningRoomTemp.setNumber(diningRoom.getNumber());
				diningRoomTemp.setBookFlag(diningRoom.getBookFlag());
				diningRoomTemp.setUpdateDate(new Date());
				diningRoomTemp.setUpdater(curUser.getName());
				diningRoomService.saveOrUpdate(diningRoomTemp);
			}

		} else if (oper.equalsIgnoreCase("del")) {
			String[] strs = (String[]) map.get("id");
			if (strs.length > 0 && strs[0].indexOf(",") > 0) {
				String sql = "";
				sql = "select * from diningRoom where id in(" + strs[0] + ")";
				List<DiningRoom> dinings = (List<DiningRoom>) diningRoomService
						.selectBySql(sql, diningRoom);
				DiningRoom tempDining = null;
				for (DiningRoom dining : dinings) {
					tempDining = dining;
					tempDining.setStatus(-1);
					tempDining.setUpdateDate(new Date());
					tempDining.setUpdater(curUser.getName());
					diningRoomService.saveOrUpdate(tempDining);
				}
			} else {
				diningRoom = diningRoomService.getObject(diningRoom.getId()
						.toString(), "id");
				diningRoom.setStatus(-1);
				diningRoom.setUpdateDate(new Date());
				diningRoom.setUpdater(curUser.getName());
				diningRoomService.saveOrUpdate(diningRoom);
			}
		} else if (oper.equalsIgnoreCase("edit")) {
			diningRoomTemp = diningRoomService.getObject(diningRoom.getName()
					.trim(), "name");
			if (diningRoomTemp == null
					|| diningRoomTemp.getStatus() != diningRoom.getStatus()) {
				diningRoom.setName(diningRoom.getName().trim());
				diningRoom.setUpdateDate(new Date());
				diningRoom.setUpdater(curUser.getName());
				diningRoomService.saveOrUpdate(diningRoom);
			} else {
				diningRoomTemp.setUpdateDate(new Date());
				diningRoomTemp.setUpdater(curUser.getName());
				diningRoomTemp.setNumber(diningRoom.getNumber());
				diningRoomTemp.setBookFlag(diningRoom.getBookFlag());
				diningRoomService.saveOrUpdate(diningRoomTemp);
				diningRoom.setStatus(-1);
				diningRoom.setUpdateDate(new Date());
				diningRoom.setUpdater(curUser.getName());
				diningRoomService.saveOrUpdate(diningRoom);
			}
		}
	}

	/** 分类列表 */
	@RequestMapping(value = "/listType")
	public void listType(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		Map map = request.getParameterMap();

		Type type = new Type();
		Map<String, Object> serObj = getSearchObject(map, type);

		Page page = (Page) serObj.get("page");
		Search search = (Search) serObj.get("search");
		type = (Type) serObj.get(type.getClass().getName());

		User curUser = (User) session.getAttribute("curUser");

		List<Type> types = null;
		try {
			if (type.getStatus() != null && type.getStatus() == -99) {
				type.setStatus(null);
				search.getOps().remove("status");
			}
			Object[] objs = typeService.Search(type, page, search);
			types = (List<Type>) objs[0];
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
		if (types != null) {
			JSONArray jsonObject = new JSONArray();

			for (Type o : types) {
				JSONObject json = new JSONObject();

				json.put("id", o.getId());
				json.put("status", o.getStatus());
				json.put("name", o.getName());
				json.put("updateDate", o.getUpdateDate().toString());
				json.put("updater", o.getUpdater());
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

	/** 更新分类 */
	@RequestMapping(value = "/saveOrUpdateType")
	public void saveOrUpdateType(HttpServletRequest request,
			HttpSession session, HttpServletResponse response) {
		Map map = request.getParameterMap();

		User curUser = (User) session.getAttribute("curUser");

		Type type = new Type();

		Map<String, Object> serObj = getOperationsAndfields(map, type);
		String oper = serObj.get("oper").toString();
		type = (Type) serObj.get("object");
		Type tempType;
		if (oper.equalsIgnoreCase("add")) {
			tempType = typeService.getObject(type.getName().trim(), "name");
			if (tempType == null) {
				type.setStatus(0);
				type.setName(type.getName().trim());
				type.setUpdateDate(new Date());
				type.setUpdater(curUser.getName());
				typeService.saveOrUpdate(type);
			}

		} else if (oper.equalsIgnoreCase("del")) {
			String[] strs = (String[]) map.get("id");
			if (strs.length > 0 && strs[0].indexOf(",") > 0) {
				String sql = "";
				sql = "select * from User where id in(" + strs[0] + ")";
				List<Type> types = (List<Type>) typeService.selectBySql(sql,
						type);
				for (Type t : types) {
					tempType = t;
					tempType.setStatus(-1);
					tempType.setUpdateDate(new Date());
					tempType.setUpdater(curUser.getName());
					typeService.saveOrUpdate(tempType);
				}
			} else {

				type = typeService.getObject(type.getId().toString(), "id");
				type.setStatus(-1);
				type.setUpdateDate(new Date());
				type.setUpdater(curUser.getName());
				typeService.saveOrUpdate(type);
			}
		} else if (oper.equalsIgnoreCase("edit")) {
			tempType = typeService.getObject(type.getName().trim(), "name");
			if (tempType == null || tempType.getStatus() != type.getStatus()) {
				type.setName(type.getName().trim());
				type.setUpdateDate(new Date());
				type.setUpdater(curUser.getName());
				typeService.saveOrUpdate(type);
			}
		}
	}

	public static boolean isNumeric(String str) {
		if (str == null || str.length() <= 0)
			return false;
		Pattern pattern = Pattern.compile("[0-9]*");
		return pattern.matcher(str).matches();
	}

	public static Date StrToDate(String str) {

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = format.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}
		return date;
	}

	public static String dateFormat(Date date) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");// 可以方便地修改日期格式

		return dateFormat.format(date);

	}

	public Map<String, Object> getSearchObject(Map map, Object obj) {
		Class<?> demo = null;
		Object object = null;
		try {
			demo = Class.forName(obj.getClass().getName());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}

		try {
			object = demo.newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}

		Page page = new Page();
		Search search = new Search();
		search.setOps(new HashMap<String, String>());
		Field[] fs = object.getClass().getDeclaredFields();

		for (Object key : map.keySet()) {
			String[] strs = (String[]) map.get(key);
			for (String str : strs) {
				// System.out.println("key=" + key + ",value=" + str);
				String op = key.toString();
				switch (Op.getOp(op)) {
				case _search:
					if (str != null && str.length() > 1) {
						search.set_search(Boolean.parseBoolean(str));
					} else
						search.set_search(false);
					break;
				case nd:
					if (str != null && str.length() > 1) {
						search.setNd(str);
					}
					break;
				case rows:
					if (str != null && str.length() > 1) {
						page.setPageSize(Integer.valueOf(str));
					} else
						page.setPageSize(300);
					break;
				case page:
					if (str != null) {
						page.setCurrentPage(Integer.valueOf(str));
					} else
						page.setCurrentPage(1);
					break;
				case sidx:
					if (str != null && str.length() > 1) {
						search.setSidx(str);
					}
					break;
				case sord:
					if (str != null && str.length() > 1) {
						search.setSord(str);
					}
					break;
				case totalPage:
					if (str != null && str.length() > 1 && !search.is_search()) {
						page.setTotalPage(Integer.valueOf(str));
					} else
						page.setTotalPage(0);
					break;
				case recordCount:
					if (str != null && str.length() > 1 && !search.is_search()) {
						page.setRecordCount(Integer.valueOf(str));
					} else {
						page.setRecordCount(0);
					}
					break;
				case filters:
					if (str != null && str.length() > 1) {
						JSONObject jsonObject = JSONObject.fromObject(str);

						Iterator iterator = jsonObject.keys();
						String k = null;
						String v = null;
						while (iterator.hasNext()) {
							k = (String) iterator.next();
							v = jsonObject.getString(k);
							if (k.toString().equalsIgnoreCase("groupOp")) {
								search.setGroupOp(v);
							} else if (k.toString().equalsIgnoreCase("rules")) {
								if (v == null || v.length() == 0
										|| v.equalsIgnoreCase("[]"))
									continue;
								v = v.substring(1, v.length() - 1);
								String[] rules = v.split("}");
								for (String s : rules) {
									s = s + "}";
									if (s.subSequence(0, 1).toString()
											.equalsIgnoreCase(","))
										s = s.substring(1, s.length());
									JSONObject json = JSONObject.fromObject(s);
									Iterator iter = json.keys();
									String keys = null;
									String field = null;
									String operation = null;
									String data = null;
									while (iter.hasNext()) {
										keys = (String) iter.next();
										if (keys.toString().equalsIgnoreCase(
												"field"))
											field = json.getString(keys);
										else if (keys.toString()
												.equalsIgnoreCase("op"))
											operation = json.getString(keys);
										else if (keys.toString()
												.equalsIgnoreCase("data"))
											data = json.getString(keys);
									}
									for (Field f : fs) {
										if (field.equalsIgnoreCase(f.getName())) {
											search.getOps().put(f.getName(),
													operation);
											try {
												setFieldValueByName(f, object,
														data, f.getType());

											} catch (Exception e) {
												e.printStackTrace();
												logger.error(e.getMessage(), e);
											}

											break;
										}
									}
								}
							}
						}
					}
					break;
				default:
					System.out.println("execute defualt case,info:");
					System.out.println("key=" + key + ",value=" + str);
					break;
				}
			}
		}

		Map<String, Object> res = new HashMap<String, Object>();
		res.put("page", page);
		res.put("search", search);
		res.put(obj.getClass().getName(), object);
		return res;
	}

	@RequestMapping(value = "/index")
	public ModelAndView index(HttpServletRequest request, HttpSession session) {

		String id = request.getParameter("id");
		User curUser = (User) session.getAttribute("curUser");

		String url = request.getParameter("url");

		ModelAndView mv = new ModelAndView();
		List<DiningRoom> diningRooms = diningRoomService.getObjects("0",
				"status", "eq");
		List<Type> types = typeService.getObjects("0", "status", "eq");
		MealType[] mealTypes = { MealType.afternoonTea, MealType.breakfast,
				MealType.lunch, MealType.dinner };
		mv.addObject("curUser", curUser);
		mv.addObject("diningRooms", diningRooms);
		mv.addObject("mealTypes", mealTypes);
		mv.addObject("types", types);
		mv.addObject("id", id);

		if (url == null) {
			mv.setViewName("listMenu");
		} else
			mv.setViewName(url);
		return mv;
	}

	@RequestMapping(value = "/downloadFile")
	public void downloadFile(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		String type = request.getParameter("type");
		String path = "";
		String fileName = request.getParameter("fileName");
		path = System.getProperty("user.dir").replace("bin", "") + fileName;

		try {
			// path是指欲下载的文件的路径。
			File file = null;
			if (path.indexOf(",,") < 0)
				file = new File(path);
			else {
				file = new File(path.split(",,")[0]);
				path = path.split(",,")[0];
			}
			File newfile = null;
			// 取得文件名。
			fileName = file.getName();

			InputStream fis = null;
			while (fis == null) {
				Thread current = Thread.currentThread();
				try {
					int i = 0;
					while (!file.renameTo(file) && i < 50) {
						System.out.println(file.getName() + "文件被占用" + i);
						try {
							current.sleep(2000);
						} catch (InterruptedException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
							logger.error(e1.getMessage(), e1);
						}
						i++;
					}
					if (i >= 50)
						break;
					fis = new BufferedInputStream(new FileInputStream(path));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					logger.error(e.getMessage(), e);
					try {
						current.sleep(2000);
					} catch (InterruptedException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						logger.error(e1.getMessage(), e1);
					}
				}
			}

			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename="
					+ new String(fileName.getBytes()));
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(
					response.getOutputStream());
			if (path.endsWith(".xlsx"))
				response.setContentType("application/vnd.ms-excel;charset=utf-8");
			else if (path.endsWith(".pdf"))
				response.setContentType("application/pdf;charset=utf-8");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
		} catch (IOException ex) {
			ex.printStackTrace();
			logger.error(ex.getMessage());
		}
	}

	private void setFieldValueByName(Field f, Object object, String v,
			Class<?> type) {
		try {
			v = v.trim();
			String firstLetter = f.getName().substring(0, 1).toUpperCase();
			String setter = "set" + firstLetter + f.getName().substring(1);
			Method method = object.getClass().getDeclaredMethod(setter, type);
			if (type.toString().equalsIgnoreCase("class java.lang.String"))
				method.invoke(object, String.valueOf(v).trim());
			else if (type.toString()
					.equalsIgnoreCase("class java.lang.Integer")) {
				method.invoke(object, Integer.valueOf(v));
			} else if (type.toString().equalsIgnoreCase(
					"class java.lang.Double"))
				method.invoke(object, Double.valueOf(v));
			else if (type.toString()
					.equalsIgnoreCase("class java.lang.Boolean")) {
				if (v.equalsIgnoreCase("0") || v.equalsIgnoreCase("false"))
					method.invoke(object, false);
				else if (v.equalsIgnoreCase("1") || v.equalsIgnoreCase("true"))
					method.invoke(object, true);
			} else if (type.toString().equalsIgnoreCase("class java.util.Date")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date d = sdf.parse(v);
				method.invoke(object, d);
			} else if (type.toString()
					.equalsIgnoreCase("class java.lang.Short"))
				method.invoke(object, Short.valueOf(v));
			else if (type.toString().equalsIgnoreCase("class java.lang.Char"))
				method.invoke(object, v.toCharArray()[0]);
			else if (type.toString().equalsIgnoreCase("class java.lang.Float"))
				method.invoke(object, Float.valueOf(v));
			else if (type.toString().equalsIgnoreCase("class java.lang.Long"))
				method.invoke(object, Long.valueOf(v));
			else if (type.toString().equalsIgnoreCase("class java.lang.Byte"))
				method.invoke(object, Byte.valueOf(v));
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}
	}

	enum Op {
		_search, nd, rows, page, sidx, sord, totalPage, recordCount, filters, others;

		public static Op getOp(String op) {
			try {
				return valueOf(op);
			} catch (Exception e) {
				return valueOf("others");
			}
		}
	}

	protected Map<String, Object> getOperationsAndfields(Map map, Object obj) {
		Class<?> demo = null;
		Object object = null;
		try {
			demo = Class.forName(obj.getClass().getName());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}

		try {
			object = demo.newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		}
		Field[] fs = object.getClass().getDeclaredFields();
		Map<String, Object> res = new HashMap<String, Object>();
		for (Object key : map.keySet()) {
			String[] strs = (String[]) map.get(key);
			if (key.toString().equals("oper")) {
				res.put("oper", strs[0]);
			} else {
				if (strs.length > 0) {
					String str = strs[0];
					if (str.equalsIgnoreCase("_empty"))
						continue;
					for (Field f : fs) {
						if (f.getName().equalsIgnoreCase(key.toString())) {
							setFieldValueByName(f, object, str, f.getType());
							break;
						}
					}

				}
			}
		}
		res.put("object", object);
		return res;
	}
}
