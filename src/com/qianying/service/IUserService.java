package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.PageList;

import net.sf.json.JSONArray;

public interface IUserService{

	/**
	 * 校验客户密码是否和输入的旧密码一致
	 * @param customerId
	 * @return
	 */
	boolean checkCustomerPwd(String id, String oldPwd, String comId) throws Exception;
	
	/**
	 * 校验员工密码是否和输入的旧密码一致
	 * @param customerId
	 * @return
	 */
	boolean checkEmployeePwd(String employeeId, String value, String comId) throws Exception;

	/**
	 * 校验管理员密码是否和输入的旧密码一致
	 * @param customerId
	 * @return
	 */
	boolean checkManagerPwd(String managerId, String value, String comId) throws Exception;

	/**
	 * 将客户的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateCustomerPwd(String id, String newPwd, String comId) throws Exception;

	/**
	 * 将员工的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateEmployeePwd(String employeeId, String newPwd, String comId) throws Exception;

	/**
	 * 将管理员的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateManagerPwd(String managerId, String newPwd, String comId) throws Exception;

	/**
	 * 校验管理员输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	boolean checkManagerPhone(String mobileNum, String comId);

	/**
	 * 校验员工输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return 存在返回true,不存在返回false
	 */
	boolean checkEmployeePone(String mobileNum, String comId);

	/**
	 * 校验客户输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	boolean checkCustomerPone(String mobileNum, String comId);

	/**
	 * 将管理员的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateForgetManagerPwd(String mobileNum, String newPwd, String comId);

	/**
	 * 将员工的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateForgetEmployeePwd(String mobileNum, String newPwd, String comId);

	/**
	 * 将客户的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateForgetCustomerPwd(String mobileNum, String newPwd, String comId);
	/**
	 * 获取员工状态
	 * @param mobileNum
	 * @param comId
	 * @return
	 */
	int getWorking_status(String mobileNum, String comId);

	List<Map<String, Object>> getEmployeeWeixinID(Map<String, Object> map);

	List<Map<String, Object>> getCustomerWeixinID(Map<String, Object> map);
	/**
	 * 获取客服微信id
	 * @param comId
	 * @return
	 */
	String getKfWeixinID(String comId);

	List<String> getPersonnelNeiQing(Map<String, Object> mapper);

	String updateWeixin(Map<String, String> map);

	void savePhone(Map<String, Object> map);

	boolean checkPassword(Map<String,Object> map);

	void updatePassword(Map<String, Object> map) throws Exception;
	/**
	 * 检查电工账号是否存在
	 * @param value 手机号
	 * @param com_id 
	 * @param type 类型0电工,1司机
	 * @return 存在返回true,不存在返回false
	 */
	boolean checkEvalPone(String value, String com_id, int type);
	/**
	 * 获取订单产品的历史记录
	 * @param orderNo 订单编号
	 * @param item_id 订单产品内码
	 * @return
	 */
	JSONArray getOrderProductHistory(Map<String, Object> map);
	/**
	 * 获取客户的司机信息
	 * @param searchKey 查询关键词
	 * @param driveId 所属客户编码
	 * @return 该客户的司机信息
	 */
	List<Map<String, Object>> getClientDriver(Map<String, Object> map);
	/**
	 * 提交客户的司机编码
	 * @param customer_id 
	 * @param driveId 
	 */
	void postCientDriveId(Map<String, Object> map);
	/**
	 * 根据职务获取平台员工电话
	 * @param headship 员工职务
	 * @return 对应职务的员工姓名和电话
	 */
	List<Map<String, String>> getPlatformsPhone(Map<String, Object> map);
	/**
	 * 司机通知内勤准备提前备货
	 * @param request
	 * @return
	 */
	void noticeNeiqing(Map<String, Object> map);
	/**
	 * 检查运营商手机号是否注册
	 * @param value
	 * @return 存在返回true,不存在返回false
	 */
	boolean checkOperatePone(String value);

	List<Map<String, Object>> checkLoginEwm(String name, String table);

	Map<String, Object> checkedLogin(String name, String com_id, String table);
	String saveNoticeInfo(Map<String, Object> map);

	PageList<Map<String, Object>> getNoticeInfoPage(Map<String, Object> map);
	/**
	 * 获取客户或者员工基础信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getUserInfo(Map<String, Object> map);
	/**
	 * 保存员工或者客户的姓名
	 * @param map
	 * @return
	 */
	String saveUserInfo(Map<String, Object> map);
	/**
	 * 获取员工列表中设计师
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getDesigner(Map<String, Object> map);
}
