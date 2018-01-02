package com.qianying.service;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import com.qianying.page.PageList;

public interface ISaiYuService {
	
	/**
	 * 获取位置信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPosition(Map<String, Object> map);
	/**
	 * 保存报修信息
	 * @param map
	 * @return 
	 * @throws Exception
	 */
	String saveRepair(Map<String, Object> map)throws Exception;
	/**
	 * 获取维修历史记录
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getRepairHistory(Map<String, Object> map);
	/**
	 * 获取采购审批详细信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getPurchaseApproval(Map<String, Object> map);
	/**
	 * 保存采购审批记录
	 * @param jsons 获取产品id集合
	 * @param ivt_oper_listing 报修单号
	 * @return 
	 * @throws Exception
	 */
	String savePurchaseApproval(JSONArray jsons, Map<String, Object> map) throws Exception;
	/**
	 * 保存财务经理审批记录
	 * @param map
	 */
	void saveApprovalInfo(Map<String, String> map)throws Exception;
	/**
	 * 获取品牌
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getItemBrand(Map<String, Object> map);
//	/**
//	 * 获取客户审批流程id
//	 * @param map
//	 * @return
//	 */
//	String getApprovalProcess(Map<String, Object> map);
	/**
	 * 获取报修信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getRepairInfo(Map<String, Object> map);
	/**
	 * 获取一个产品字段列表
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getProductOneFiledlist(Map<String, Object> map);
	/**
	 * 保存推荐产品
	 * @param json
	 * @param map
	 */
	void saveSuggest(JSONArray json, Map<String, Object> map);
	/**
	 * 获取推荐的产品
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSuggest(Map<String, Object> map);
	/**
	 * 获取客户审批指定步骤人员信息
	 * @param mapparam
	 * @return phone-手机号,weixinID微信通讯录账号
	 */
	Map<String, String> getApprovalPerson(Map<String, Object> mapparam);
	/**
	 * 获取司机的weixinID
	 * @param comId
	 * @param type 0-电工,1-司机
	 * @return
	 */
	String getDriverElectricianWeixinID(String comId, int type);
	/**
	 * 保存司机或者电工的信息
	 * @param map
	 * @param type 
	 * @return 
	 * @throws Exception
	 */
	String saveDriverElectrician(Map<String, Object> map, int type)throws Exception;
	/**
	 * 上报实时位置
	 * @param map
	 * @throws Exception
	 */
	void uploadLocation(Map<String, Object> map)throws Exception;
	/**
	 * 获取订单信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderList(Map<String, Object> map);
	/**
	 * 获取电工分页列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getElectricianPage(Map<String, Object> map);
	String postRepair(Map<String, Object> map)throws Exception;
	void saveOrder(Map<String, Object> mapupdate)throws Exception;
	String saveIouOA_ctl03001_approval(Map<String, Object> map);
	/**
	 * 订单分页列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getOrderPage(Map<String, Object> map);
	String getOrderSumsi(Map<String, Object> mapparam);
	void savePaymoney(Map<String, Object> mapupdate, Map<String, Object> map)throws Exception;
	String alipayClose(Map<String, Object> map);

	String alipayComplete(Map<String, Object> map);
	/**
	 * 获取的详细信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderDetails(Map<String, Object> map);
	Map<String,Object> getOrderInfo(Map<String, Object> map);
	/**
	 * 根据seeds_id获取订单信息
	 * @param ids
	 * @param com_id 
	 * @param proName 
	 * @return 订单信息列表
	 */
	List<Map<String, Object>> getOrderInfoByIds(String ids);
	void noticeShippingManager(Map<String, Object> map) throws Exception;
	PageList<Map<String, Object>> getGysOrderList(Map<String, Object> map);
	/**
	 * 增加保修信息
	 * @param map
	 * @param list
	 */
	void addRepair(Map<String, Object> map, String[] list)throws Exception;
	void repairConfim(Map<String, Object> map, String[] list)throws Exception;
	/**
	 * 员工推荐产品
	 * @param infolist
	 * @param map 
	 * @throws Exception
	 */
	void qrtjProduct(String[] infolist, Map<String, Object> map) throws Exception;
	/**
	 * 采购确认推荐,并生成采购订单
	 * @param map
	 * @param list
	 * @return 
	 * @throws Exception
	 */
	String savePurchaseOrder(Map<String, Object> map, String[] list) throws Exception;
	/**
	 * 获取审批记录中的订单编号
	 * @param map
	 * @return
	 */
	Map<String,Object> getOrderNoToApprovalInfo(Map<String, Object> map);
	/**
	 * 确认收货
	 * @param map
	 * @throws Exception
	 */
	void confimShouhuo(Map<String, Object> map)throws Exception;
	/**
	 * 保存提前预约电工信息
	 * @param map
	 * @throws Exception
	 */
	void tiqianYuYue(Map<String, Object> map)throws Exception;
	Map<String, Object> findTiqianYuYueInfo(String orderNo, String comId);
	/**
	 * 电工参与安装上报地址
	 * @param map
	 * @throws Exception
	 */
	void cyanz(Map<String, Object> map)throws Exception;
	/**
	 * 客户确认选择电工
	 * @param map
	 * @throws Exception
	 */
	void confirmSelectEval(Map<String, Object> map)throws Exception;
	/**
	 * 电工确认安装
	 * @param map
	 * @throws Exception
	 */
	void confirmanz(Map<String, Object> map) throws Exception ;
	/**
	 * 获取司机电工
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getLatlng(Map<String, Object> map);
	/**
	 * 获取司机需要查看的客户信息
	 * @param ids seeds_id
	 * @return
	 */
	List<Map<String, Object>> getOrderInfoByIdsDrive(String ids);
		/**
	 * 取消推荐产品
	 * @param map
	 * @return
	 */
	String quxiaoProduct(Map<String, Object> map);
	/**
	 * 保存电工安装费用
	 * @param map
	 * @param mapdemand 
	 * @return
	 */
	String saveEvalOrderPay(Map<String, Object> map, Map<String, Object> mapdemand);
	Map<String, Object> checkLogin(Map<String, Object> maplogin);
	/**
	 * 获取客户和电工的微信id
	 * @param map
	 * @return
	 */
	Map<String, String> getWeixinIDCustomerAndEval(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getEvalOrderInfo(Map<String, Object> map);
	/**
	 * 获取电工
	 * @param type
	 * @return
	 */
	String getMaxCustomer_id(int type);
	/**
	 * 获取订单中电工安装费用
	 * @param orderNo
	 * @param comId
	 * @return
	 */
	String getElecOrderSumsi(String orderNo, String comId);
	void updateElecState(Map<String, Object> map);
	void anzconfirm(Map<String, Object> map);
	/**
	 * 获取电工信息根据
	 * @param maprows
	 * @return
	 */
	Map<String, Object> getElectricianInfo(Map<String, Object> maprows);
	void getDriverElectricianWeixinID(Map<String, Object> map, int type);
}
