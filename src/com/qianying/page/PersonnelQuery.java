package com.qianying.page;

import org.apache.commons.lang.StringUtils;

public class PersonnelQuery extends ObjectQuery {
	private   String clerk_id;
	private   String clerk_name;
	private   String dept_name;
	private   String easy_id;
	private   String dept_id;
	private   String type_id;
	private   String regionalism_id;
	private   String customer_id;
	private   String user_id;
	private   String ditch_type;
	private Integer nowRecord;
	private String com_id;
	@Override
	public void addParams() {
		 
	}
	public String getClerk_name() {
		if (StringUtils.isNotBlank(clerk_name)&&!"null".equals(clerk_name)) {
			return "%"+clerk_name+"%";
		}else {
			return null;
		}
	}
	public void setClerk_name(String clerk_name) {
		this.clerk_name = clerk_name;
	}
	public String getDept_name() {
		if (StringUtils.isNotBlank(dept_name)&&!"null".equals(dept_name)) {
			return "%"+dept_name+"%";
		}else {
			return null;
		}
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	public String getEasy_id() {
		if (StringUtils.isNotBlank(easy_id)&&!"null".equals(easy_id)) {
			return "%"+easy_id+"%";
		}else {
			return null;
		}
	}
	public void setEasy_id(String easy_id) {
		this.easy_id = easy_id;
	}
	public String getDept_id() {
		return dept_id;
	}
	public void setDept_id(String dept_id) {
		this.dept_id = dept_id;
	}
	public String getType_id() {
		return type_id;
	}
	public void setType_id(String type_id) {
		this.type_id = type_id;
	}
	public String getRegionalism_id() {
		if (StringUtils.isBlank(regionalism_id)) {
		return null;
		}else{
			return regionalism_id;
		}
	}
	public void setRegionalism_id(String regionalism_id) {
		this.regionalism_id = regionalism_id;
	}
	public String getCustomer_id() {
		return customer_id;
	}
	public void setCustomer_id(String customer_id) {
		this.customer_id = customer_id;
	}
	public String getUser_id() {
		if (StringUtils.isNotBlank(user_id)&&!"null".equals(user_id)) {
			return "%"+user_id+"%";
		}else {
			return null;
		}
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getClerk_id() {
		return clerk_id;
	}
	public void setClerk_id(String clerk_id) {
		this.clerk_id = clerk_id;
	}
	public Integer getNowRecord() {
		if (nowRecord==null) {
			return 0;
		}
		return nowRecord;
	}
	public void setNowRecord(Integer nowRecord) {
		this.nowRecord = nowRecord;
	}
	public String getDitch_type() {
		if (StringUtils.isBlank(ditch_type)) {
			return null;
		}
		return ditch_type;
	}
	public void setDitch_type(String ditch_type) {
		this.ditch_type = ditch_type;
	}
	public String getCom_id() {
		return com_id;
	}
	public void setCom_id(String com_id) {
		this.com_id = com_id;
	}
	
}
