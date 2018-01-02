package com.qianying.page;

import org.apache.commons.lang.StringUtils;

public class WarehouseQuery extends ObjectQuery {
private String sort_id;
private String store_struct_name;
private String store_struct_type;
private String easy_id;
private String find;
private String com_id;
	@Override
	public void addParams() {

	}
	public String getSort_id() {
		return sort_id;
	}
	public void setSort_id(String sort_id) {
		this.sort_id = sort_id;
	}
	public String getStore_struct_name() {
		if (StringUtils.isNotBlank(store_struct_name)) {
			return "%"+store_struct_name+"%";
		}
		return null;
	}
	public void setStore_struct_name(String store_struct_name) {
		this.store_struct_name = store_struct_name;
	}
	public String getStore_struct_type() {
		if (StringUtils.isBlank(store_struct_type)) {
			return null;
		}
		return store_struct_type;
	}
	public void setStore_struct_type(String store_struct_type) {
		this.store_struct_type = store_struct_type;
	}
	public String getEasy_id() {
		if (StringUtils.isNotBlank(easy_id)) {
			return "%"+easy_id+"%";
		}
		return null;
	}
	public void setEasy_id(String easy_id) {
		this.easy_id = easy_id;
	}
	public String getFind() {
		return find;
	}
	public void setFind(String find) {
		this.find = find;
	}
	public String getCom_id() {
		return com_id;
	}
	public void setCom_id(String com_id) {
		this.com_id = com_id;
	}

}
