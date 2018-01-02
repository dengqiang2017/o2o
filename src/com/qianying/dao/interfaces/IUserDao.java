package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface IUserDao {

	/**
	 * 通过id获取用户的密码并返回
	 * @param customerId
	 * @param oldPwd
	 * @return
	 */
	String checkCustomerPwd(@Param("id")String id, @Param("com_id")String comId) throws Exception;

	/**
	 * 通过id获取员工的密码并返回
	 * @param customerId
	 * @param oldPwd
	 * @return
	 */
	String checkEmployeePwd(@Param("id")String id, @Param("com_id")String comId) throws Exception;

	/**
	 * 通过id获取管理员的密码并返回
	 * @param customerId
	 * @param oldPwd
	 * @return
	 */
	String checkManagerPwd(@Param("id")String id, @Param("com_id")String comId) throws Exception;
	
	/**
	 * 将客户的旧密码更新为新密码
	 * @param id
	 * @param newPwd
	 */
	void updateCustomerPwd(@Param("id")String id, @Param("newPwd")String newPwd, @Param("com_id")String comId) throws Exception;

	/**
	 * 将员工的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateEmployeePwd(@Param("id")String id, @Param("newPwd")String newPwd, @Param("com_id")String comId) throws Exception;

	/**
	 * 将管理员的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateManagerPwd(@Param("id")String id, @Param("newPwd")String newPwd, @Param("com_id")String comId) throws Exception;

	/**
	 * 校验管理员输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	Integer checkManagerPhone(@Param("mobileNum")String mobileNum, @Param("com_id")String comId);

	/**
	 * 校验员工输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	Integer checkEmployeePone( @Param("mobileNum")String mobileNum, @Param("com_id")String comId);

	/**
	 * 校验客户输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	Integer checkCustomerPone(@Param("mobileNum")String mobileNum, @Param("com_id")String comId);

	/**
	 * 将管理员的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateForgetManagerPwd(@Param("mobileNum")String mobileNum, @Param("newPwd")String newPwd, @Param("com_id")String comId);

	/**
	 * 将员工的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateForgetEmployeePwd(@Param("mobileNum")String mobileNum, @Param("newPwd")String newPwd, @Param("com_id")String comId);

	/**
	 * 将客户的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	void updateForgetCustomerPwd(@Param("mobileNum")String mobileNum, @Param("newPwd")String newPwd, @Param("com_id")String comId);

	Integer getWorking_status(@Param("mobileNum")String mobileNum, @Param("com_id")String comId);

	List<Map<String, Object>> getEmployeeWeixinID(Map<String, Object> map);

	List<Map<String, Object>> getCustomerWeixinID(Map<String, Object> map);
	
	String getKfWeixinID( @Param("com_id")String comId);

	String updateWeixin(Map<String, String> map);

	String checkEvalPone(Map<String,Object> map);
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
	 * 更新客户司机
	 * @param clientdrive 客户编码
	 * @param com_id 
	 * @param customer_id 司机编码
	 */
	void updateClientDriveId(@Param("customer_id")Object clientdrive, @Param("com_id")Object com_id, @Param("driveId")Object customer_id);
	/**
	 * 根据职务获取平台员工电话
	 * @param headship 员工职务
	 * @return 对应职务的员工姓名和电话
	 */
	List<Map<String, String>> getPlatformsPhone(Map<String, Object> map);
	/**
	 * 检查运营商司机是否注册
	 * @param mobileNum
	 * @return
	 */
	Integer checkOperatePone(@Param("mobileNum")String mobileNum);

	List<Map<String, Object>> checkLoginEwm(@Param("name")String name, @Param("table")String table);
	
	Map<String, Object> checkedLogin(@Param("name")String name, @Param("com_id")String com_id, @Param("table")String table);
	/**
	 * 保存员工或者客户的姓名
	 * @param map
	 * @return
	 */
	Integer saveUserInfo(Map<String, Object> map);

	List<Map<String, Object>> getDesigner(Map<String, Object> map);

}
