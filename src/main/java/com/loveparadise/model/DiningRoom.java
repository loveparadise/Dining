package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*餐厅*/
@Entity(name = "DiningRoom")
public class DiningRoom implements Serializable {

	private static final long serialVersionUID = -6570530946511779734L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** 餐厅名 */
	@Column(name = "name", length = 50, nullable = false)
	private String name;

	/** 状态 */
	@Column(name = "status", nullable = true)
	private Integer status;

	/** 是否可订餐状态 */
	@Column(name = "bookFlag", nullable = true)
	private Integer bookFlag;

	/** 可用餐人数 */
	@Column(name = "number", nullable = true)
	private Integer number;

	/** 更新日期 */
	@Column(name = "updateDate", nullable = false)
	private Date updateDate;

	/** 更新人 */
	@Column(name = "updater", length = 50)
	private String updater;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getUpdater() {
		return updater;
	}

	public void setUpdater(String updater) {
		this.updater = updater;
	}

	public Integer getBookFlag() {
		return bookFlag;
	}

	public void setBookFlag(Integer bookFlag) {
		this.bookFlag = bookFlag;
	}

}
