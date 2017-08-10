package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.MealDao;
import com.loveparadise.model.Meal;
import com.loveparadise.service.common.AbstractService;

@Service("mealService")
public class MealService extends AbstractService<Meal> {

	@Resource(name = "mealDao")
	private MealDao dao;

	public MealService() {
		super();
	}

	@Override
	protected IOperations<Meal> getDao() {
		return this.dao;
	}

	public void setDao(MealDao dao) {
		this.dao = dao;
	}
}