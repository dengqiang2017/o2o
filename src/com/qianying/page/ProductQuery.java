package com.qianying.page;

import org.apache.commons.lang.StringUtils;

public class ProductQuery extends ObjectQuery {

	private String type_id;
	private String item_type;
	private String type_name;
	
	private String class_card;
	private String easy_id;
	private String goods_origin;
	private String item_color;
	private String item_name;
	private String item_spec;
	private String item_style;
	private String peijian_id;
	private String quality_class;	
	private String serve_name;
	private String employeeId;//员工内码
	private String com_id;
	private String customer_id; 
	private String beginTime; 
	private String endTime; 
	private String sd_order_direct;//周计划 
	private String ditch_type;//周计划 
	private Integer client; 
	private String discount_ornot; 
	
	@Override
	public void addParams() {
	}
	public String getType_id() {
		if (StringUtils.isNotBlank(type_id)) {
			return type_id;
		}else {
			return null;
		}
	}
	public void setType_id(String type_id) {
		this.type_id = type_id;
	}
	public String getItem_type() {
		if (StringUtils.isNotBlank(item_type)&&!"null".equals(item_type)) {
			return "%"+item_type+"%";
		}else {
			return null;
		}
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public String getType_name() {
		if (StringUtils.isNotBlank(type_name)&&!"null".equals(type_name)) {
			return "%"+type_name+"%";
		}else {
			return null;
		}
	}

	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public String getClass_card() {
		return likeparam(class_card);
	}
	public void setClass_card(String class_card) {
		this.class_card = class_card;
	}
	public String getEasy_id() {
		return likeparam(easy_id);
	}
	public void setEasy_id(String easy_id) {
		this.easy_id = easy_id;
	}
	public String getGoods_origin() {
		return likeparam(goods_origin);
	}
	public void setGoods_origin(String goods_origin) {
		this.goods_origin = goods_origin;
	}
	public String getItem_color() {
		return likeparam(item_color);
	}
	public void setItem_color(String item_color) {
		this.item_color = item_color;
	}
	public String getItem_name() {
		return likeparam(item_name);
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public String getItem_spec() {
		return likeparam(item_spec);
	}
	public void setItem_spec(String item_spec) {
		this.item_spec = item_spec;
	}
	public String getItem_style() {
		return likeparam(item_style);
	}
	public void setItem_style(String item_style) {
		this.item_style = item_style;
	}
	public String getPeijian_id() {
		return likeparam(peijian_id);
	}
	public void setPeijian_id(String peijian_id) {
		this.peijian_id = peijian_id;
	}
	public String getQuality_class() {
		return likeparam(quality_class);
	}
	public void setQuality_class(String quality_class) {
		this.quality_class = quality_class;
	}
	public String getServe_name() {
		return likeparam(serve_name);
	}
	public void setServe_name(String serve_name) {
		this.serve_name = serve_name;
	}
	public String getEmployeeId() {
		return employeeId;
	}
	public void setEmployeeId(String employeeId) {
		this.employeeId = employeeId;
	}
	public String getCom_id() {
		return com_id;
	}
	public void setCom_id(String com_id) {
		this.com_id = com_id;
	}
	public String getCustomer_id() {
		return customer_id;
	}
	public void setCustomer_id(String customer_id) {
		this.customer_id = customer_id;
	}
	public String getBeginTime() {
		return beginTime;
	}
	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getSd_order_direct() {
		return sd_order_direct;
	}
	public void setSd_order_direct(String sd_order_direct) {
		this.sd_order_direct = sd_order_direct;
	}
	public String getDitch_type() {
		return ditch_type;
	}
	public void setDitch_type(String ditch_type) {
		this.ditch_type = ditch_type;
	}
	public Integer getClient() {
		return client;
	}
	public void setClient(Integer client) {
		this.client = client;
	}
	public String getDiscount_ornot() {
		return discount_ornot;
	}
	public void setDiscount_ornot(String discount_ornot) {
		this.discount_ornot = discount_ornot;
	}
 
}
