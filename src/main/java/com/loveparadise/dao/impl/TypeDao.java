package com.loveparadise.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Example;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.springframework.stereotype.Repository;

import com.loveparadise.dao.common.AbstractHibernateDao;
import com.loveparadise.model.Type;
import com.loveparadise.model.Page;

@Repository("typeDao")
public class TypeDao extends AbstractHibernateDao<Type> {

	public TypeDao() {
		super();

		setClazz(Type.class);
	}

	@Override
	public Type getObject(Type obj) {
		List<Type> objs = getObjects(obj);
		if (objs != null && objs.size() > 0)
			return objs.get(0);
		else
			return null;
	}

	@Override
	public List<Type> getObjects(Type obj) {
		Example example = Example.create(obj).ignoreCase()
				.enableLike(MatchMode.ANYWHERE);
		return getCurrentSession().createCriteria(Type.class).add(example)
				.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY).list();
	}

	@Override
	/**单个忽略（或关注）查詢对象字段（非值）*/
	public Type getObject(Type obj, String excludeField, String type) {
		List<Type> objs = getObjects(obj, excludeField, type);
		if (objs != null && objs.size() > 0)
			return objs.get(0);
		else
			return null;
	}

	@Override
	/**集合忽略（或关注）查詢对象字段（非值）*/
	public List<Type> getObjects(Type obj, String excludeField, String type) {
		Criteria criteria = getCurrentSession().createCriteria(Type.class);
		Example exmple = Example.create(obj);
		String strs[] = excludeField.split(",");
		for (String str : strs) {
			exmple = exmple.excludeProperty(str);
		}
		return criteria.add(exmple).list();
	}

	@Override
	public Object[] Search(Type entity, Page page,
			com.loveparadise.model.Search search) {
		Criteria criteria = getCurrentSession().createCriteria(Type.class);
		if (search.is_search() && search.getSidx() != null
				&& search.getSidx().length() > 0 && search.getSord() != null
				&& search.getSord().length() > 0) {
			if (search.getSord().equalsIgnoreCase("asc"))
				criteria.addOrder(Order.asc(search.getSidx()));
			else
				criteria.addOrder(Order.desc(search.getSidx()));
		}

		criteria = getCriteria(criteria, entity, search);


		if (page.getTotalPage() == 0) {
			// 查询记录总数
			criteria.setProjection(Projections.rowCount());
			try {
				page.setRecordCount(Integer.valueOf(criteria.uniqueResult()
						.toString()));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.error(e.getMessage(),e);
			}
			// 查询记录
			criteria.setProjection(null);// 清空projection，以便取得记录
			criteria.setFirstResult(
					(page.getCurrentPage() - 1) * page.getPageSize())
					.setMaxResults(
							page.getCurrentPage() >= page.getTotalPage() ? (page
									.getRecordCount() - (page.getCurrentPage() - 1)
									* page.getPageSize())
									: page.getPageSize());
		} else {
			criteria.setProjection(null);// 清空projection，以便取得记录
			criteria.setFirstResult(
					(page.getCurrentPage() - 1) * page.getPageSize())
					.setMaxResults(
							page.getCurrentPage() >= page.getTotalPage() ? (page
									.getRecordCount() - (page.getCurrentPage() - 1)
									* page.getPageSize())
									: page.getPageSize());
		}
		criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		Object[] objs = new Object[2];
		objs[0] = criteria.list();
		objs[1] = page;
		return objs;
	}
}