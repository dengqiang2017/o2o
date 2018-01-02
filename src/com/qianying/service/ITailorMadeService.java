package com.qianying.service;

import java.util.Map;

import com.qianying.page.PageList;

public interface ITailorMadeService {
	/**
	 * 保存定制需求信息
	 * @param map
	 * @return
	 */
	String saveTailorMadeInfo(Map<String, Object> map);
	/**
	 * 获取报价单信息 
	 * @param request
	 * @return 按照金额降序
	 */
	PageList<Map<String, Object>> getTailorMadeInfoPage(Map<String, Object> map);
	/**
	 * 删除订单需求
	 * @param orderNo
	 * @return 下过订单的返回false,没有下过订单的返回true
	 */
	boolean delTailorMade(String orderNo);
	/**
	 * 保存员工报价金额
	 * @param map
	 */
	void saveSum_si(Map<String, Object> map);
	/**
	 *  获取客户的支付金额百分比
	 * @param map
	 * @return 百分比数字
	 */
	Map<String, Object> getPayPercentage(Map<String, Object> map);
	/**
	 * 客户订单分页
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getTailorMadeOrderPage(Map<String, Object> map);

}
