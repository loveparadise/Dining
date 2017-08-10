package com.loveparadise.model;

import java.io.Serializable;
import java.util.Map;

public class Search implements Serializable {

	private static final long serialVersionUID = 8078584175802617162L;

	/** 排序列 */
	private String sidx;

	/** 排序顺序 */
	private String sord;

	/** 是否查询 */
	private boolean _search;

	/**
	 * 表示已经发送请求的次数的参数名称;参考：http://blog.csdn.net/seng3018/article/details/7756433
	 */
	private String nd;

	/**
	 * 查询条件组合
	 * */
	private Map<String, String> ops;

	private String groupOp;

	public String getSidx() {
		return sidx;
	}

	public void setSidx(String sidx) {
		this.sidx = sidx;
	}

	public String getSord() {
		return sord;
	}

	public void setSord(String sord) {
		this.sord = sord;
	}

	public boolean is_search() {
		return _search;
	}

	public void set_search(boolean _search) {
		this._search = _search;
	}

	public String getNd() {
		return nd;
	}

	public void setNd(String nd) {
		this.nd = nd;
	}

	public Map<String, String> getOps() {
		return ops;
	}

	public void setOps(Map<String, String> ops) {
		this.ops = ops;
	}

	public String getGroupOp() {
		return groupOp;
	}

	public void setGroupOp(String groupOp) {
		this.groupOp = groupOp;
	}

}
