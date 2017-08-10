package com.loveparadise.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.dao.impl.BookDao;
import com.loveparadise.model.Book;
import com.loveparadise.service.common.AbstractService;

@Service("bookService")
public class BookService extends AbstractService<Book> {

	@Resource(name = "bookDao")
	private BookDao dao;

	public BookService() {
		super();
	}

	@Override
	protected IOperations<Book> getDao() {
		return this.dao;
	}

	public void setDao(BookDao dao) {
		this.dao = dao;
	}
}