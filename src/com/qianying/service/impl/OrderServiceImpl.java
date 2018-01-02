package com.qianying.service.impl;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.service.IOrderService;
@Service
@Transactional
public class OrderServiceImpl extends BaseServiceImpl implements IOrderService {

	@Override
	public String addShopping(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Map<String, Object>> getShopping(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String cashDelivery(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String savePayInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		//1.生成订单主表
		//2.生成金币抵扣记录
		//3.生成收款确认记录
		return null;
	}
	/**
	 * 微信支付收款记录生成
	 * @param map
	 * @param request
	 * @return
	 */
//	private String saveWeixinPayInfo(Map<String,Object> map) {
//		Object orderNo=map.get("orderNo");
//		if (!orderNo.toString().contains("NO")) {
//			orderNo="NO."+orderNo;
//		}
//		//1.从外部文件中获取订单seeds_id
//		String seeds_id=getFileTextContent(getPayOrderInfo(getRequest(), orderNo));
//		seeds_id=seeds_id.replace("[", "");
//		seeds_id=seeds_id.replace("]", "");
//		//2.获取订单信息
//		String customer_id=getUpperCustomerId(getRequest());
//		Map<String,Object> param=new HashMap<>();
//		param.put("com_id", getComId());
//		param.put("customer_id", customer_id);
//		Map<String,Object> order=customerService.getSimpleOrderPayInfo(param);
//		//3.生成付款单数据
//		Map<String,Object> fkdmap=new HashMap<>();
//		Calendar c = Calendar.getInstance();
//		fkdmap.put("com_id", getComId());
//		fkdmap.put("finacial_y", c.get(Calendar.YEAR));
//		fkdmap.put("finacial_m", c.get(Calendar.MONTH));
//		fkdmap.put("finacial_d", getNow());
//		fkdmap.put("recieved_direct", "收款");
//		fkdmap.put("recieved_auto_id",orderNo);
//		fkdmap.put("recieved_id", orderNo);
//		fkdmap.put("customer_id",customer_id);
//		fkdmap.put("recieve_type","微信支付");
//		fkdmap.put("rcv_hw_no", "微信支付");
//		if(isNotMapKeyNull(order, "sum_si")){
//			fkdmap.put("sum_si", order.get("sum_si"));
//		}else{
//			fkdmap.put("sum_si",map.get("total_fee"));
//		}
//		fkdmap.put("rejg_hw_no",seeds_id);
//		fkdmap.put("comfirm_flag", "N");
//		fkdmap.put("mainten_clerk_id", getCustomerId(getRequest()));
//		fkdmap.put("mainten_datetime", getNow());
//		return null;
//	}
}
