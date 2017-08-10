package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*����*/
@Entity(name = "Book")
public class Book implements Serializable {

	private static final long serialVersionUID = -1468987004931539010L;

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

	/** Ԥ������ */
	@Column(name = "bookDateTime", nullable = false)
	private Date bookDateTime;

	/** ȡ������ */
	@Column(name = "cancelDateTime")
	private Date cancelDateTime;

	/** ״̬ */
	@Column(name = "status", nullable = true)
	private Integer status;

	/** �ò����� */
	@Column(name = "number", nullable = true)
	private Integer number;

	/** �ò�ʱ�� */
	@Column(name = "mealType", length = 50)
	private String mealType;

	/** ������ */
	@Column(name = "Auser", length = 50, nullable = false)
	private String Auser;

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

	public Date getBookDateTime() {
		return bookDateTime;
	}

	public void setBookDateTime(Date bookDateTime) {
		this.bookDateTime = bookDateTime;
	}

	public Date getCancelDateTime() {
		return cancelDateTime;
	}

	public void setCancelDateTime(Date cancelDateTime) {
		this.cancelDateTime = cancelDateTime;
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


	public String getMealType() {
		return mealType;
	}

	public void setMealType(String mealType) {
		this.mealType = mealType;
	}

	public String getAuser() {
		return Auser;
	}

	public void setAuser(String auser) {
		Auser = auser;
	}

	public String getDiningRoom_id() {
		return diningRoom_id;
	}

	public void setDiningRoom_id(String diningRoom_id) {
		this.diningRoom_id = diningRoom_id;
	}

}
