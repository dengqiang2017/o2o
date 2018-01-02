package com.qianying.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.service.IChartService;
import com.qianying.util.DateTimeUtils;

@Controller
@RequestMapping("/chartData")
public class ChartDataController extends FilePathController{

	@Autowired
	private IChartService chartService;
	
	/**
	 * 获取指定时间段产品浏览总数与下单总数
	 * @param request
	 * @return
	 */
	@RequestMapping("productViewAndOrder")
	@ResponseBody
	public List<Map<String,Object>> productViewAndOrder(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return chartService.productViewAndOrder(map);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("salesCount")
	@ResponseBody
	public List<Map<String,Object>> salesCount(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isMapKeyNull(map, "type")) {
			map.put("type", 7);
		}
		return chartService.salesCount(map);
	}
	
}
