package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

public interface IOrderTrackingDAO {

	void confimShouhuo(Map<String, Object> map);

	Integer updateOrderStatus(Map<String,Object> map);
	/**
	 * 获取订单信息
	 * @param map
	 * @return 
	 */
	List<Map<String, Object>> getOrderInfoByCaiguo(Map<String, Object> map);
	/**
	 * 根据seeds_id获取订单信息
	 * @param seeds_id
	 * @param customer
	 * @param vendor
	 * @return
	 */
	List<Map<String,String>> getOrderInfoBySeeds_id(Map<String,Object> map);

	void updateStdm02001(Map<String, Object> map);
	/**
	 * 根据订单id和采购订单号和产品名称
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getCaigouOrderInfoByOrderSeeds_id(
			Map<String, Object> map);

	String getOrderInfoStatus_OutStoreBySeeds_id(Map<String, Object> map);
	/**
	 * 获取司机信息从订单从表中
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWuliuByOrder(Map<String, Object> map);
	/**
	 * 根据订单编号和产品内码获取生产计划历史消息
	 * @param map
	 * @return 排产编号
	 */
	Map<String,Object> getProductionPlanPH(Map<String, Object> map);
	/**
	 * 获取待处理订单数据
	 * @param map
	 * @return
	 */
	Integer getWaitingHandleOrderCount(Map<String, Object> map);
	/**
	 * 获取待处理订单数据
	 * @param map
	 * @param type 生产或者采购
	 * @return
	 */
	List<Map<String, Object>> getWaitingHandleOrderList(Map<String, Object> map);

}
