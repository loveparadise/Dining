package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*订餐*/
@Entity(name = "Book")
public class Book implements Serializable {

	private static final long serialVersionUID = -1468987004931539010L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** 餐厅id */
	@Column(name = "diningRoom_id", length = 50, nullable = false)
	private String diningRoom_id;

	/** 餐厅名 */
	@Column(name = "diningRoom_name", length = 50, nullable = false)
	private String diningRoom_name;

	/** 菜单日期 */
	@Column(name = "dayDate", nullable = false)
	private Date dayDate;

	/** 预订日期 */
	@Column(name = "bookDateTime", nullable = false)
	private Date bookDateTime;

	/** 取消日期 */
	@Column(name = "cancelDateTime")
	private Date cancelDateTime;

	/** 状态 */
	@Column(name = "status", nullable = true)
	private Integer status;

	/** 用餐人数 */
	@Column(name = "number", nullable = true)
	private Integer number;

	/** 用餐时段 */
	@Column(name = "mealType", length = 50)
	private String mealType;

	/** 评价人 */
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
