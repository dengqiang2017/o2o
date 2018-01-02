package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface ISaiYuDao {
	//获取位置信息
	List<Map<String, Object>> getPositionList(Map<String, Object> map);
	//获取维修历史记录
	Integer getRepairHistoryCount(Map<String, Object> map);
	//获取维修历史记录
	List<Map<String, Object>> getRepairHistoryList(Map<String, Object> map); 
	//获取采购审批详细信息
	Map<String, Object> getPurchaseApproval(Map<String, Object> map);
	//获取品牌
	List<Map<String, Object>> getItemBrand(Map<String, Object> map);
	//获取体检表 信息
	String getTijianInfo(Map<String, Object> map);
	//获取体检表最大seeds_id
	Integer getMaxSeeds_id();
	//获取维修最大编号
	String getWeixiuMaxNo(String comId);
	//获取客户审批流程的id
	Map<String, Object> getApprovalProcess(Map<String, Object> map);
	//获取报修信息
	Map<String, Object> getRepairInfo(Map<String, Object> map);
	//
	List<Map<String, String>> getProductOneFiledlist(Map<String, Object> map);
	/**
	 * 获取下一个审批客户的id,微信通讯录账号weixinID,手机号,除员工以外
	 * @param mapParam
	 * @return
	 */
	Map<String,Object> getNextOA_whom(Map<String, String> mapParam);
	//获取推荐产品信息
	List<Map<String, Object>> getSuggest(Map<String, Object> map);
	//获取审批指定步骤的手机号和微信通讯录账号
	List<Map<String, String>> getApprovalPerson(Map<String, Object> mapparam);
	//获取供应商采购订单信息
	List<Map<String, Object>> getGysOrderList(Map<String, Object> map);
	Integer getGysOrderCount(Map<String, Object> map);
	//获取司机weixinID
	List<Map<String, String>> getDriverElectricianWeixinID(@Param("com_id")String comId, @Param("type")Integer type);
	List<Map<String, Object>> getOrderList(Map<String, Object> map);
	///
	Integer getElectricianPageCount(Map<String, Object> map);
	//
	List<Map<String, Object>> getElectricianPageList(Map<String, Object> map);
	List<Map<String, Object>> getOAhistryList(Map<String, Object> map);
	Integer getOrderPageCount(Map<String, Object> map);
	List<Map<String, Object>> getOrderPageList(Map<String, Object> map);
	String getOrderSumsi(Map<String, Object> mapparam);
	List<Map<String, Object>> getOrderDetails(Map<String, Object> map);
	Map<String, Object> getOrderInfo(Map<String, Object> map);
	/**
	 * 根据seeds_id获取订单信息不包括已发货的产品
	 * @param ids seeds_id值
	 * @return
	 */
	List<Map<String, Object>> getOrderInfoByIds(@Param("ids")String ids);
	/**
	 * 更新维修从表中的状态
	 * @param mapweixiu
	 */
	void updateWeixiuState(Map<String, Object> mapweixiu);
	void updateWeixiuData(Map<String, Object> mapweixiu);
	/**
	 * 获取报修人id
	 * @param mapParam
	 * @return
	 */
	Map<String, Object> getRepairCustomer(Map<String, String> mapParam);
	/**
	 * 获取体检表中的订单信息
	 * @param ivts 
	 * @param com_id 
	 * @return
	 */
	List<Map<String, Object>> getProductOrder(Map<String,Object> map);
	/**
	 * 获取订单编号从审批记录中
	 * @param map
	 * @return
	 */
	Map<String,Object> getOrderNoToApprovalInfo(Map<String, Object> map);
	/**
	 * 确认收货
	 * @param map
	 */
	void confimShouhuo(Map<String, Object> map);
	/**
	 * 查询提前预约信息
	 * @param map
	 * @return
	 */
	Map<String, Object> findTiqianYuYueInfo(Map<String, Object> map);
	/**
	 * 获取所有电工的weixinID和手机号
	 * @param comId
	 * @param dian_customer_id 
	 * @return
	 */
	List<Map<String, Object>> getElectricianWeixinID(@Param("com_id")String comId, @Param("dian_customer_id")Object dian_customer_id);
	/**
	 * 电工确认安装
	 * @param map
	 * @return  客户的微信和电话
	 */
	Map<String, Object> confirmanz(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getLatlng(Map<String, Object> map);
	void updateTjNum(Map<String, Object> map);
	/**
	 * 根据seeds_id获取司机提货信息
	 * @param ids
	 * @return 提货地点,收货地点联系人
	 */
	List<Map<String, Object>> getOrderInfoByIdsDrive(@Param("ids")String ids);
	/**
	 * 取消推荐产品
	 * @param maptijian
	 */
	void quxiaoProduct(Map<String, Object> maptijian);
	/**
	 * 更新订单状态为已预约
	 * @param map
	 */
	void updateOrderToDemand(Map<String, Object> map);
	/**
	 * 检查登录
	 * @param map
	 * @return
	 */
	Map<String, Object> checkLogin(Map<String, Object> map);
	Map<String, String> getWeixinIDCustomerAndEval(Map<String, Object> map);
	Integer getEvalOrderInfoCount(Map<String, Object> map);
	/**
	 * 获取电工的安装列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEvalOrderInfo(Map<String, Object> map);
	/**
	 * 获取
	 * @param type
	 * @return
	 */
	String getMaxCustomer_id(@Param("type")Integer type);
	/**
	 * 生成电工安装单
	 * @param map
	 */
	void insertDemand(Map<String, Object> map);
	/**
	 * 获取订单中电工安装费
	 * @param orderNo
	 * @param comId
	 * @return
	 */
	String getElecOrderSumsi(@Param("orderNo")String orderNo, @Param("com_id")String comId);
	/**
	 * 验收完成后更新订单和安装表
	 * @param map
	 * @return
	 */
	Map<String, Object> updateElecState(Map<String, Object> map);
	/**
	 * 电工安装完成确认
	 * @param map
	 * @return
	 */
	Map<String, Object> anzconfirm(Map<String, Object> map);
	Map<String, Object> getElectricianInfo(Map<String, Object> maprows);
	/**
	 * 获取司机微信
	 * @param map
	 */
	void getDriverWeixinID(Map<String, Object> map);

}
