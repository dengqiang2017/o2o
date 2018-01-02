package com.qianying.bean;

import java.io.Serializable;
import java.util.Date;
/**
 * 验证码存放
 * @author Administrator
 *
 */
public class VerificationCode implements Serializable{
	private static final long serialVersionUID = -7466028129556501874L;
	public VerificationCode() {}
	public VerificationCode(String code) {
		super();
		this.code = code;
	}
	private String code;//验证码
	private Date generateDate=new Date();//生成时间
	private String phone;//需要验证的手机号
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public Date getGenerateDate() {
		return generateDate;
	}
	public void setGenerateDate(Date generateDate) {
		this.generateDate = generateDate;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
}
