package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*菜类*/
@Entity(name = "Type")
public class Type implements Serializable {

	private static final long serialVersionUID = 1987798007932319222L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** 种类名 */
	@Column(name = "name", length = 50, nullable = false)
	private String name;

	/** 状态 */
	@Column(name = "status", nullable = true)
	private Integer status;

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

}
