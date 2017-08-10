package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*�˵�*/
@Entity(name = "judgeMeal")
public class JudgeMeal implements Serializable {
	private static final long serialVersionUID = 1116776777119803769L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** ÿ�Ͳ˵�id */
	@Column(name = "meal_id", length = 50, nullable = false)
	private String meal_id;

	/** ������ */
	@Column(name = "diningRoom_name", length = 50, nullable = false)
	private String diningRoom_name;

	/** ������ */
	@Column(name = "type_name", length = 50, nullable = false)
	private String type_name;

	/** ���� */
	@Column(name = "menu_name", length = 50, nullable = false)
	private String menu_name;

	/** ����id */
	@Column(name = "diningRoom_id", length = 50, nullable = false)
	private String diningRoom_id;

	/** �˵�id */
	@Column(name = "menu_id", length = 50, nullable = false)
	private String menu_id;

	/** ����id */
	@Column(name = "type_id", length = 50, nullable = false)
	private String type_id;

	/** �˵����� */
	@Column(name = "dayDate", nullable = false)
	private Date dayDate;

	/** ����ʱ�� */
	@Column(name = "updateDate", length = 50)
	private Date updateDate;

	/** ״̬ */
	@Column(name = "status", nullable = true)
	private Integer status;

	/** ���� */
	@Column(name = "score", nullable = true)
	private Integer score;

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

	public String getType_name() {
		return type_name;
	}

	public void setType_name(String type_name) {
		this.type_name = type_name;
	}

	public String getMenu_name() {
		return menu_name;
	}

	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}

	public Date getDayDate() {
		return dayDate;
	}

	public void setDayDate(Date dayDate) {
		this.dayDate = dayDate;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
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

	public Integer getScore() {
		return score;
	}

	public void setScore(Integer score) {
		this.score = score;
	}

	public String getDiningRoom_id() {
		return diningRoom_id;
	}

	public void setDiningRoom_id(String diningRoom_id) {
		this.diningRoom_id = diningRoom_id;
	}

	public String getMenu_id() {
		return menu_id;
	}

	public void setMenu_id(String menu_id) {
		this.menu_id = menu_id;
	}

	public String getType_id() {
		return type_id;
	}

	public void setType_id(String type_id) {
		this.type_id = type_id;
	}

	public String getMeal_id() {
		return meal_id;
	}

	public void setMeal_id(String meal_id) {
		this.meal_id = meal_id;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

}
