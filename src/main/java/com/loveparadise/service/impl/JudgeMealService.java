package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.JudgeMealDao;
import com.loveparadise.model.JudgeMeal;
import com.loveparadise.service.common.AbstractService;

@Service("judgeMealService")
public class JudgeMealService extends AbstractService<JudgeMeal> {

	@Resource(name = "judgeMealDao")
	private JudgeMealDao dao;

	public JudgeMealService() {
		super();
	}

	@Override
	protected IOperations<JudgeMeal> getDao() {
		return this.dao;
	}

	public void setDao(JudgeMealDao dao) {
		this.dao = dao;
	}
}