package com.qianying.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.service.IOrderService;

@Controller
@RequestMapping("/order")
public class OrderController extends FilePathController {
	
	@Autowired
	private IOrderService orderService;
	
	/**
	 * 加入购物车
	 * @param request
	 * @return
	 */
	@RequestMapping("shopping")
	@ResponseBody
	public ResultInfo shopping(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getCustomerId(request)==null){
				msg="请登录后在操作!";
			}else{
				Map<String,Object> map=getKeyAndValue(request);
				orderService.addShopping(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	 
	/**
	 *  获取购物车列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getShopping")
	@ResponseBody
	public List<Map<String,Object>> getShopping(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return orderService.getShopping(map);
	}
	/**
	 * 货到付款
	 * @param request
	 * @return
	 */
	@RequestMapping("cashDelivery")
	@ResponseBody
	public ResultInfo cashDelivery(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderService.cashDelivery(map);
			orderService.savePayInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	
	
}
