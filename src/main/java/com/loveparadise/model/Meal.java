package com.loveparadise.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/*每餐菜单*/
@Entity(name = "Meal")
public class Meal implements Serializable {

	private static final long serialVersionUID = 1724409240293010096L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id", nullable = false)
	private Long id;

	/** 餐厅id */
	@Column(name = "diningRoom_id", length = 50, nullable = false)
	private String diningRoom_id;

	/** 菜单id */
	@Column(name = "menu_id", length = 50, nullable = false)
	private String menu_id;

	/** 类型id */
	@Column(name = "type_id", length = 50, nullable = false)
	private String type_id;

	/** 餐厅名 */
	@Column(name = "diningRoom_name", length = 50, nullable = false)
	private String diningRoom_name;

	/** 分类名 */
	@Column(name = "type_name", length = 50, nullable = false)
	private String type_name;

	/** 菜名 */
	@Column(name = "menu_name", length = 50, nullable = false)
	private String menu_name;

	/** 图片 */
	@Column(name = "picture", length = 50, nullable = true)
	private String picture;

	/** 菜单日期 */
	@Column(name = "dayDate", nullable = false)
	private Date dayDate;

	/** 更新时间 */
	@Column(name = "updateDate", length = 50)
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

	/** 用餐时段 */
	@Column(name = "mealType", length = 50)
	private String mealType;

	/** 推荐 */
	@Column(name = "recommend", nullable = true,columnDefinition = "int(11) default 0")
	private Integer recommend;

	/** 评分 */
	@Column(name = "score", nullable = true, columnDefinition = "int(11) default 0")
	private Integer score;

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

	public String getPicture() {
		return picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
	}

	public Date getDayDate() {
		return dayDate;
	}

	public void setDayDate(Date dayDate) {
		this.dayDate = dayDate;
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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public Integer getScore() {
		return score;
	}

	public void setScore(Integer score) {
		this.score = score;
	}

	public Integer getRecommend() {
		return recommend;
	}

	public void setRecommend(Integer recommend) {
		this.recommend = recommend;
	}

}
