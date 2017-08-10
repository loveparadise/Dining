package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*菜单*/
@Entity(name = "Menu")
public class Menu implements Serializable {

	private static final long serialVersionUID = 813278130424164124L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** 餐厅id */
	@Column(name = "diningRoom_id", length = 50, nullable = true)
	private String diningRoom_id;

	/** 餐厅名 */
	@Column(name = "diningRoom_name", length = 50, nullable = true)
	private String diningRoom_name;

	/** 类型id */
	@Column(name = "type_id", length = 50, nullable = false)
	private String type_id;

	/** 分类名 */
	@Column(name = "type_name", length = 50, nullable = false)
	private String type_name;

	/** 菜名 */
	@Column(name = "name", length = 50, nullable = false)
	private String name;

	/** 图片 */
	@Column(name = "picture", length = 50, nullable = false)
	private String picture;

	/** 更新日期 */
	@Column(name = "updateDate", nullable = false)
	private Date updateDate;

	/** 更新人 */
	@Column(name = "updater", length = 50)
	private String updater;

	/** 备注 */
	@Column(name = "remark", length = 50)
	private String remark;

	/** 状态 */
	@Column(name = "status", nullable = true)
	private Integer status;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getType_name() {
		return type_name;
	}

	public void setType_name(String type_name) {
		this.type_name = type_name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPicture() {
		return picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
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

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getDiningRoom_id() {
		return diningRoom_id;
	}

	public void setDiningRoom_id(String diningRoom_id) {
		this.diningRoom_id = diningRoom_id;
	}

	public String getDiningRoom_name() {
		return diningRoom_name;
	}

	public void setDiningRoom_name(String diningRoom_name) {
		this.diningRoom_name = diningRoom_name;
	}

	public String getType_id() {
		return type_id;
	}

	public void setType_id(String type_id) {
		this.type_id = type_id;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
