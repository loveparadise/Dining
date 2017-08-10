package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.DiningRoomDao;
import com.loveparadise.model.DiningRoom;
import com.loveparadise.service.common.AbstractService;

@Service("diningRoomService")
public class DiningRoomService extends AbstractService<DiningRoom> {

	@Resource(name = "diningRoomDao")
	private DiningRoomDao dao;

	public DiningRoomService() {
		super();
	}

	@Override
	protected IOperations<DiningRoom> getDao() {
		return this.dao;
	}

	public void setDao(DiningRoomDao dao) {
		this.dao = dao;
	}
}