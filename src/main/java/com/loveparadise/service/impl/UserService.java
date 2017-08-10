package com.loveparadise.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.UserDao;
import com.loveparadise.model.Page;
import com.loveparadise.model.User;
import com.loveparadise.service.common.AbstractService;

@Service("userService")
public class UserService extends AbstractService<User> {

	@Resource(name = "userDao")
	private UserDao dao;

	public UserService() {
		super();
	}

	@Override
	protected IOperations<User> getDao() {
		return this.dao;
	}

	public Integer updatePrintDate(String str) {
		return dao.updatePrintDate(str);
	}

	public void setDao(UserDao dao) {
		this.dao = dao;
	}

	public List<User> getObjects(User obj) {
		return dao.getObjects(obj);
	}

	public User getObject(User obj, String excludeField, String type) {
		return dao.getObject(obj, excludeField, type);
	}

	public List<User> getObjects(User obj, String excludeField, String type) {
		return dao.getObjects(obj, excludeField, type);
	}

	public Object[] Search(User entity, Page page,
			com.loveparadise.model.Search search) {
		return dao.Search(entity, page, search);
	}
}