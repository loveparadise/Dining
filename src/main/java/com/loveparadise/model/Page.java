package com.loveparadise.model;

import java.io.Serializable;

public class Page implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4422823269563392931L;

	public static final int DEFAULT_PAGE_SIZE = 300;

	/** page record size */
	private int pageSize = DEFAULT_PAGE_SIZE;

	/** totoal record count */
	private int recordCount;

	/** total page */
	private int totalPage;

	/** current page */
	private int currentPage = 1;

	public int getCurrentPage() {
		return currentPage < 1 ? 1 : currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getRecordCount() {
		return recordCount;
	}

	public void setRecordCount(int recordCount) {
		this.recordCount = recordCount;
		this.totalPage = (recordCount % getPageSize()) > 0 ? recordCount
				/ getPageSize() + 1 : recordCount / getPageSize();
		this.currentPage = (this.totalPage > this.currentPage || this.totalPage == 0) ? this.currentPage
				: this.totalPage;
	}

	public boolean isLast() {
		return getCurrentPage() == totalPage;
	}

	public boolean isFirst() {
		return getCurrentPage() == 1;
	}

	public int getNextPage() {
		return getCurrentPage() + 1;
	}

	public int getPrePage() {
		return getCurrentPage() - 1;
	}

	public int[] iterate() {
		int[] result = new int[totalPage];
		for (int i = 1; i <= totalPage; i++) {
			result[i - 1] = i;
		}
		return result;
	}
}
