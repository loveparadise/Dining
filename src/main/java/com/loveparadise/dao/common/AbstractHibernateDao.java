package com.loveparadise.dao.common;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.base.Preconditions;
import com.loveparadise.model.Search;

@SuppressWarnings("unchecked")
public abstract class AbstractHibernateDao<T extends Serializable> implements
		IOperations<T> {

	private Class<T> clazz;
	
	public static final Logger logger = LoggerFactory
			.getLogger("LOGISTICS-COMPONENT");

	@Resource(name = "sessionFactory")
	private SessionFactory sessionFactory;

	protected void setClazz(Class<T> clazzToSet) {
		this.clazz = Preconditions.checkNotNull(clazzToSet);
	}

	protected Session getCurrentSession() {
		return sessionFactory.getCurrentSession();
	}

	protected Session openSession() {
		return sessionFactory.openSession();
	}

	@Override
	public T findOne(long id) {
		return (T) getCurrentSession().get(clazz, id);
	}

	@Override
	public List<T> findAll() {
		return getCurrentSession().createQuery("from " + clazz.getName())
				.list();
	}

	@Override
	public void create(T entity) {
		Preconditions.checkNotNull(entity);
		// getCurrentSession().persist(entity);
		Session session = getCurrentSession();
		try {
			session.saveOrUpdate(entity);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			logger.error(e.getMessage(),e);
			System.out.println(e.toString());
		}
	}

	@Override
	public T update(T entity) {
		Preconditions.checkNotNull(entity);
		getCurrentSession().update(entity);
		return entity;
		// return (T)getCurrentSession().merge(entity);
	}

	@Override
	public void delete(T entity) {
		Preconditions.checkNotNull(entity);
		getCurrentSession().delete(entity);
	}

	@Override
	public void deleteById(long entityId) {
		T entity = findOne(entityId);
		Preconditions.checkState(entity != null);
		delete(entity);
	}

	@Override
	public T getObject(String value, String field) {
		String hql = "";
		if (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false"))
			hql = "from " + clazz.getName() + " where " + field + "=" + value;
		else
			hql = "from " + clazz.getName() + " where " + field + "='" + value
					+ "'";
		List<T> objects = getCurrentSession().createQuery(hql).list();
		if (objects != null && objects.size() > 0)
			return objects.get(0);
		else
			return null;
	}

	@Override
	public List<T> getObjects(String value, String field, String type) {
		String sql = "";
		boolean flag = isNumeric(value);
		if (type.equalsIgnoreCase("eq")) {
			if (flag || value.equalsIgnoreCase("true")
					|| value.equalsIgnoreCase("false")) {
				sql = "from " + clazz.getName() + " obj where obj." + field
						+ "=" + value + " order by id";
			} else {
				sql = "from " + clazz.getName() + " obj where obj." + field
						+ "='" + value + "'" + " order by id";
			}
		} else {
			sql = "from " + clazz.getName() + " obj where obj." + field
					+ " in(" + value + ")" + " order by id";
		}
		Query query = getCurrentSession().createQuery(sql);
		List<T> objects = query.list();
		return objects;
	}

	@Override
	public void saveOrUpdate(T entity) {
		try {
			getCurrentSession().saveOrUpdate(entity);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
			System.out.println(e.getMessage());
		} finally {
			getCurrentSession().flush();
		}
	}

	public boolean isNumeric(String str) {
		if (str.indexOf(",") > 0) {
			if (str.indexOf("'") > 0)
				return false;
			else
				return true;
		} else {
			for (int i = str.length(); --i >= 0;) {
				int chr = str.charAt(i);
				if (chr < 48 || chr > 57)
					return false;
			}
		}
		return true;
	}

	public Date afterDay(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		cal.add(Calendar.DAY_OF_MONTH, 1);
		return cal.getTime();
	}

	public Date beforeDay(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 23);
		cal.set(Calendar.MINUTE, 59);
		cal.set(Calendar.SECOND, 59);
		cal.set(Calendar.MILLISECOND, 999);
		cal.add(Calendar.DAY_OF_MONTH, -1);
		return cal.getTime();
	}

	public Criteria getCriteria(Criteria criteria, Object obj, Search search) {
		Field[] fields = obj.getClass().getDeclaredFields();
		for (Field f : fields) {
			if (f.getName().equalsIgnoreCase("serialVersionUID"))
				continue;
			Object o = getFieldValueByName(f, obj);
			if (o != null) {
				String op = search.getOps().get(f.getName());
				if (op != null) {
					/**
					 * [
					 * 'eq','ne','lt','le','gt','ge','bw','bn','in','ni','ew','en','cn'
					 * , ' n c ' ] ['equal','not equal', 'less', 'less or
					 * equal','greater','greater or equal', 'begins with','does
					 * not begin with','is in','is not in','ends with','does not
					 * end with','contains','does not contain']
					 * */
					switch (Op.getOp(op)) {
					case eq:
						criteria.add(Restrictions.eq(f.getName(), o));
						break;
					case ne:
						criteria.add(Restrictions.ne(f.getName(), o));
						break;
					case lt:
						criteria.add(Restrictions.lt(f.getName(), o));
						break;
					case le:
						criteria.add(Restrictions.le(f.getName(), o));
						break;
					case gt:
						criteria.add(Restrictions.gt(f.getName(), o));
						break;
					case ge:
						criteria.add(Restrictions.ge(f.getName(), o));
						break;
					case bw:
						criteria.add(Restrictions.like(f.getName(),
								o.toString(), MatchMode.START));
						break;
					// case bn:criteria.add(Restrictions.like(f.getName(),
					// o.toString(),MatchMode.START));break;
					case in:
						if (o.getClass().getName()
								.equalsIgnoreCase("java.lang.String")) {
							String str = (String) o;
							String[] strs = str.split("/");
							criteria.add(Restrictions.in(f.getName(), strs));
						}
						break;
					// case ni:criteria.add(Restrictions.eq(f.getName(),
					// o));break;
					case ew:
						criteria.add(Restrictions.like(f.getName(),
								o.toString(), MatchMode.END));
						break;
					// case en:criteria.add(Restrictions.eq(f.getName(),
					// o));break;
					case cn:
						criteria.add(Restrictions.like(f.getName(),
								"%" + o.toString() + "%"));
						break;
					// case "nc":
					// criteria.add(Restrictions.like(f.getName(),
					// o.toString(), MatchMode.EXACT));break;
					}
				}
			}
		}
		return criteria;
	}

	private Object getFieldValueByName(Field f, Object o) {
		try {
			String firstLetter = f.getName().substring(0, 1).toUpperCase();
			String getter = "get" + firstLetter + f.getName().substring(1);
			Method method = o.getClass().getDeclaredMethod(getter);
			Object value = method.invoke(o);
			return value;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
			return null;
		}
	}

	enum Op {
		eq, ne, lt, le, gt, ge, bw, bn, in, ni, ew, en, cn, nc;

		public static Op getOp(String op) {
			return valueOf(op);
		}
	}

	public int excuteSql(String sql) {

		int result;
		SQLQuery query = this.getCurrentSession().createSQLQuery(sql);
		if (sql.indexOf("update") >= 0)
			result = query.executeUpdate();
		else
			result = Integer.valueOf(query.uniqueResult().toString());

		return result;
	}

	public Object selectBySql(String sql, Object obj) {
		SQLQuery query = this.getCurrentSession().createSQLQuery(sql);
		query.addEntity(obj.getClass().getName());
		try {
			return query.list();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
			return null;
		}
	}
	
	public List<Object[]> selectBySql(String sql) {
		List<Object[]> list = this.getCurrentSession().createSQLQuery(sql).list();
		try {
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage(),e);
			return null;
		}
	}

}