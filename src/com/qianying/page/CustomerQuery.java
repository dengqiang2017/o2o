package com.qianying.page;

import org.apache.commons.lang.StringUtils;


public class CustomerQuery extends ObjectQuery {
	private String customer_id;
	private String corp_name;
	private String easy_id;
	private String com_id;
	private String clerk_id;

	@Override
	public void addParams() {
	}

	public String getCustomer_id() {
		return customer_id;
	}

	public void setCustomer_id(String customer_id) {
		this.customer_id = customer_id;
	}

	public String getCorp_name() {
		if (StringUtils.isNotBlank(corp_name)&&!"null".equals(corp_name)) {
			return "%"+corp_name+"%";
		}else {
			return null;
		}
	}

	public void setCorp_name(String corp_name) {
		this.corp_name = corp_name;
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

	public String getCom_id() {
		return com_id;
	}

	public void setCom_id(String com_id) {
		this.com_id = com_id;
	}

	public String getClerk_id() {
		return clerk_id;
	}

	public void setClerk_id(String clerk_id) {
		this.clerk_id = clerk_id;
	}
	
}
