package com.loveparadise.service.common;

import java.io.Serializable;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.loveparadise.dao.common.IOperations;
import com.loveparadise.model.Page;
import com.loveparadise.model.Search;

@Transactional
public abstract class AbstractService<T extends Serializable> implements
		IOperations<T> {

	protected abstract IOperations<T> getDao();

	@Override
	public T findOne(final long id) {
		return getDao().findOne(id);
	}

	@Override
	@Transactional(readOnly = true, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public List<T> findAll() {
		return getDao().findAll();
	}

	@Override
	@Transactional(readOnly = false, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public void create(final T entity) {
		getDao().create(entity);
	}

	@Override
	@Transactional(readOnly = false, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public T update(final T entity) {
		return getDao().update(entity);
	}

	@Override
	@Transactional(readOnly = false, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public void delete(final T entity) {
		getDao().delete(entity);
	}

	@Override
	@Transactional(readOnly = false, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public void deleteById(long entityId) {
		getDao().deleteById(entityId);
	}

	@Override
	@Transactional(readOnly = true, rollbackFor = { RuntimeException.class,
			Exception.class })
	public T getObject(String value, final String field) {
		return getDao().getObject(value, field);
	}

	@Override
	@Transactional(readOnly = true, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public List<T> getObjects(String value, final String field, String type) {
		return getDao().getObjects(value, field, type);
	}

	@Override
	@Transactional(readOnly = false, rollbackForClassName = {
			"RuntimeException", "Exception" })
	public void saveOrUpdate(final T entity) {
		getDao().saveOrUpdate(entity);
	}

	@Override
	public T getObject(final T obj) {
		return getDao().getObject(obj);
	}

	@Override
	public List<T> getObjects(final T obj) {
		return getDao().getObjects(obj);
	}

	@Override
	public T getObject(final T obj, String excludeField, String type) {
		return getDao().getObject(obj, excludeField, type);
	}

	@Override
	public List<T> getObjects(final T obj, String excludeField, String type) {
		return getDao().getObjects(obj, excludeField, type);
	}

	@Override
	public Object[] Search(T entity, Page page, Search search) {
		return getDao().Search(entity, page, search);
	}

	public int excuteSql(String sql) {

		return getDao().excuteSql(sql);
	}

	public Object selectBySql(String sql, Object obj) {

		return getDao().selectBySql(sql, obj);
	}
	
	public List<Object[]> selectBySql(String sql) {
		
		return getDao().selectBySql(sql);
	}
}