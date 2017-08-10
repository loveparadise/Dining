package com.loveparadise.model;

public enum MealType {
	breakfast("早餐"), lunch("午餐"), dinner("晚餐"), afternoonTea("下午茶");
	private String text;

	MealType(String text) {
		this.text = text;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
}
