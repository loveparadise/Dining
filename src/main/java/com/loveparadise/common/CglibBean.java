package com.loveparadise.common;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.cglib.beans.BeanGenerator;
import org.springframework.cglib.beans.BeanMap;


public class CglibBean {

	/**
	 * 实体Object
	 */
	public Object object = null;

	/**
	 * 属性map
	 */
	public BeanMap beanMap = null;
	
	/**
	 * 属性list
	 */
	public List<String> propertyList;

	public CglibBean() {
		super();
	}

	@SuppressWarnings("unchecked")
	public CglibBean(List<String[]> propertyMap) throws ClassNotFoundException {
		this.object = generateBean(propertyMap);
		this.beanMap = BeanMap.create(this.object);
	}

	/**
	 * 给bean属性赋值
	 * 
	 * @param property
	 *            属性名
	 * @param value
	 *            值
	 */
	public void setValue(String property, Object value) {
		beanMap.put(property, value);
	}

	/**
	 * 通过属性名得到属性值
	 * 
	 * @param property
	 *            属性名
	 * @return 值
	 */
	public Object getValue(String property) {
		return beanMap.get(property);
	}

	/**
	 * 得到该实体bean对象
	 * 
	 * @return
	 */
	public Object getObject() {
		return this.object;
	}

	@SuppressWarnings("unchecked")
	private Object generateBean(List<String[]> propertyMap) throws ClassNotFoundException {
		BeanGenerator generator = new BeanGenerator();
		propertyList=new ArrayList<String>();
		for (int i=0;i<propertyMap.size();i++) {
			propertyList.add(propertyMap.get(i)[0]);
			generator.addProperty(propertyMap.get(i)[0],Class.forName(propertyMap.get(i)[1]));
		}
		return generator.create();
	}
}
