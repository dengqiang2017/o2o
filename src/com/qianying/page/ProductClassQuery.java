package com.qianying.page;

public class ProductClassQuery extends ObjectQuery {
	private String sort_name;
	private String easy_id;
	private String sort_id;
	private String find;
	@Override
	public void addParams() {
	}
	public String getSort_name() {
		return sort_name;
	}
	public void setSort_name(String sort_name) {
		this.sort_name = sort_name;
	}
	public String getEasy_id() {
		return easy_id;
	}
	public void setEasy_id(String easy_id) {
		this.easy_id = easy_id;
	}
	public String getSort_id() {
		return sort_id;
	}
	public void setSort_id(String sort_id) {
		this.sort_id = sort_id;
	}
	public String getFind() {
		return find;
	}
	public void setFind(String find) {
		this.find = find;
	}

}
