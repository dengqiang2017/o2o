package com.qianying.service;

import java.util.List;
import java.util.Map;

public interface IOrderService {
	/**
	 * 加入购物车
	 * @param request
	 * @return
	 */
	String addShopping(Map<String, Object> map);
	/**
	 *  获取购物车列表
	 * @param request
	 * @return
	 */
	List<Map<String, Object>> getShopping(Map<String, Object> map);
	/**
	 * 货到付款
	 * @param request
	 * @return
	 */
	String cashDelivery(Map<String, Object> map);
	/**
	 * 微信支付成功,生成订单主表,生成金币抵扣表,生成收款确认记录
	 * @param map
	 * @return
	 */
	String savePayInfo(Map<String, Object> map);


}
