package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.TypeDao;
import com.loveparadise.model.Type;
import com.loveparadise.service.common.AbstractService;

@Service("typeService")
public class TypeService extends AbstractService<Type> {

	@Resource(name = "typeDao")
	private TypeDao dao;

	public TypeService() {
		super();
	}

	@Override
	protected IOperations<Type> getDao() {
		return this.dao;
	}

	public void setDao(TypeDao dao) {
		this.dao = dao;
	}
}