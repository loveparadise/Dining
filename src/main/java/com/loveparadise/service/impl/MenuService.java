package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.MenuDao;
import com.loveparadise.model.Menu;
import com.loveparadise.service.common.AbstractService;

@Service("menuService")
public class MenuService extends AbstractService<Menu> {

	@Resource(name = "menuDao")
	private MenuDao dao;

	public MenuService() {
		super();
	}

	@Override
	protected IOperations<Menu> getDao() {
		return this.dao;
	}

	public void setDao(MenuDao dao) {
		this.dao = dao;
	}
}