package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.LimitedMealNumberDao;
import com.loveparadise.model.LimitedMealNumber;
import com.loveparadise.service.common.AbstractService;

@Service("limitedMealNumberService")
public class LimitedMealNumberService extends AbstractService<LimitedMealNumber> {

	@Resource(name = "limitedMealNumberDao")
	private LimitedMealNumberDao dao;

	public LimitedMealNumberService() {
		super();
	}

	@Override
	protected IOperations<LimitedMealNumber> getDao() {
		return this.dao;
	}

	public void setDao(LimitedMealNumberDao dao) {
		this.dao = dao;
	}
}