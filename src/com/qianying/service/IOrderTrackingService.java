package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.PageList;

public interface IOrderTrackingService {
	/**
	 * 根据seeds_id获取订单信息
	 * @param ids
	 * @param proName 
	 * @param com_id 
	 * @return 订单信息列表
	 */
	List<Map<String, Object>> getOrderInfoByIds(String ids);

	/**
	 * 获取司机需要查看的提货信息与客户信息
	 * @param ids
	 * @return
	 */
	List<Map<String, Object>> getOrderInfoByIdsDrive(String ids);
	/**
	 * 通知发货管理员
	 * @param seeds_ids
	 * @param type
	 * @return
	 * @throws Exception 
	 */
	void noticeShippingManager(Map<String, Object> map) throws Exception;
	/**
	 * 确认收货
	 * @param request
	 * @return
	 */
	void confimShouhuo(Map<String, Object> map);
	/**
	 * 向内勤发送消息
	 * @param map
	 */
	void noticeNeiqing(Map<String, Object> map);
	/**
	 * 通知已经出厂
	 * @param map
	 */
	void noticeOutedFactory(Map<String, Object> map);
	/**
	 * 通知库管
	 * @param map
	 */
	void noticeKuguan(Map<String, Object> map);
	/**
	 * 通知司机
	 * @param map
	 */
	void noticeDrive(Map<String, Object> map);
	/**
	 * 更新订单状态
	 * @param map
	 */
	void updateOrderState(Map<String, Object> map);
	/**
	 * 采购确认供应商有货,通知安排物流
	 * @param map
	 */
	void noticeAnPaiWuliu(Map<String, Object> map);

	String saveHandle(Map<String, Object> map);
	/**
	 * 物流经办人提交司机拉货信息
	 * @param map
	 */
	void postWuliu(Map<String, Object> map);
	/**
	 * 获取司机信息从订单从表中
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWuliuByOrder(Map<String, Object> map);
	/**
	 * 根据订单编号获取生产计划历史消息
	 * @param map
	 * @return
	 */
	Map<String,Object> getProductionPlanPH(Map<String, Object> map);
	/**
	 * 通知下采购订单或者下生产计划
	 * @param map
	 * @return
	 */
	String noticePurchasingOrPPlan(Map<String, Object> map);
	/**
	 * 获取待处理订单信息
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getWaitingHandleOrderPage(
			Map<String, Object> map);

}
