package com.qianying.page;

import org.apache.commons.lang.StringUtils;

public class SupplierQuery extends ObjectQuery {
	private String corp_id;
	private String corp_name;
	private String easy_id;
	private String com_id;
	
	public String getCorp_id() {
		return corp_id;
	}

	public void setCorp_id(String corp_id) {
		this.corp_id = corp_id;
	}

	public String getCorp_sim_name() {
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

	@Override
	public void addParams() {
		
	}
	
}
