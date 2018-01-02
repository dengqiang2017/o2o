package com.qianying.service;

import java.util.List;
import java.util.Map;

public interface IChartService {
	/**
	 * 获取指定时间段产品浏览总数与下单总数
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> productViewAndOrder(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> salesCount(Map<String, Object> map);

}
