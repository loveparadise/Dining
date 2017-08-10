package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*�޶��ò�����*/
@Entity(name = "limitedMealNumber")
public class LimitedMealNumber implements Serializable {

	private static final long serialVersionUID = 6815154358632233675L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** ����id */
	@Column(name = "diningRoom_id", length = 50, nullable = false)
	private String diningRoom_id;

	/** ������ */
	@Column(name = "diningRoom_name", length = 50, nullable = false)
	private String diningRoom_name;

	/** �˵����� */
	@Column(name = "dayDate", nullable = false)
	private Date dayDate;

	/** �ò����� */
	@Column(name = "number", nullable = true)
	private Integer number;

	/** �ò�ʱ�� */
	@Column(name = "mealType", length = 50)
	private String mealType;

	/** ��ע */
	@Column(name = "remark", length = 50)
	private String remark;

	/** ״̬ */
	@Column(name = "status", nullable = true)
	private Integer status;

	/** �������� */
	@Column(name = "updateDate", nullable = false)
	private Date updateDate;

	/** ������ */
	@Column(name = "updater", length = 50)
	private String updater;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDiningRoom_name() {
		return diningRoom_name;
	}

	public void setDiningRoom_name(String diningRoom_name) {
		this.diningRoom_name = diningRoom_name;
	}

	public Date getDayDate() {
		return dayDate;
	}

	public void setDayDate(Date dayDate) {
		this.dayDate = dayDate;
	}

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public String getMealType() {
		return mealType;
	}

	public void setMealType(String mealType) {
		this.mealType = mealType;
	}

	public String getDiningRoom_id() {
		return diningRoom_id;
	}

	public void setDiningRoom_id(String diningRoom_id) {
		this.diningRoom_id = diningRoom_id;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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
