package com.loveparadise.dao.common;

import java.io.Serializable;
import java.util.List;

import com.loveparadise.model.Page;
import com.loveparadise.model.Search;

/*
 * 通用的操作接口
 */
public interface IOperations<T extends Serializable> {

	T findOne(long id);

	T getObject(String value, String field);

	T getObject(T obj);

	T getObject(T obj, String excludeField, String type);

	List<T> getObjects(T obj, String excludeField, String type);

	List<T> getObjects(T obj);

	List<T> getObjects(String value, String field, String type);

	List<T> findAll();

	void create(T entity);

	T update(T entity);

	void delete(T entity);

	void deleteById(long entityId);

	void saveOrUpdate(T entity);

	Object[] Search(T entity, Page page, Search search);

	public int excuteSql(String sql);

	public Object selectBySql(String sql, Object obj);
	
	public List<Object[]> selectBySql(String sql);
}
