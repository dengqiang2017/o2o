package com.qianying.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.ITailorMadeDao;
import com.qianying.page.PageList;
import com.qianying.service.ITailorMadeService;
import com.qianying.util.ConfigFile;
@Service
@Transactional
public class TailorMadeServiceImpl extends BaseServiceImpl implements
		ITailorMadeService {
	@Autowired
	private ITailorMadeDao tailorMadeDao;
	
	@Override
	@Transactional
	public String saveTailorMadeInfo(Map<String, Object> map) {
			String no = getOrderNo(customerDao, "销售订单", map.get("com_id").toString());
		Map<String,Object> mapdetail=new HashMap<String, Object>();
		mapdetail.put("com_id", map.get("com_id"));
		mapdetail.put("ivt_oper_listing", no);
		mapdetail.put("mainten_clerk_id", map.get("clerk_id"));
		mapdetail.put("mainten_datetime", getNow());
		mapdetail.put("customer_id", map.get("customer_id"));
		mapdetail.put("item_id", map.get("item_id"));
		mapdetail.put("peijian_id", map.get("item_id"));
		mapdetail.put("c_memo", map.get("demandInfo"));
		mapdetail.put("at_term_datetime", map.get("deliveryDate"));
		mapdetail.put("discount_rate", 1);
		mapdetail.put("sd_oq", 1);
		mapdetail.put("prefer", 0);
		customerDao.insertSql(getInsertSql("SDd02011", mapdetail));
		Map<String, Object> main = new HashMap<String, Object>();
		main.put("com_id", map.get("com_id"));
		main.put("sd_order_direct", "发货");
		main.put("ivt_oper_bill", "发货");
		main.put("ivt_oper_listing", no);
		main.put("sd_order_id", no);
	//	main.put("price_type", map.get("price_type"));
		main.put("customer_id", map.get("customer_id"));
		main.put("clerk_id", map.get("clerk_id"));
	//	main.put("dept_id", map.get("dept_id"));
		main.put("mainten_clerk_id", map.get("clerk_id"));
		main.put("so_effect_datetime", getNow());
		main.put("mainten_datetime",  getNow());
		customerDao.insertSql(getInsertSql("SDd02010", main));
		////向内勤发送可以已上传需求消息
		String description=map.get("description").toString().replaceAll("@customerName", map.get("clerk_name")+"");
		sendMessageNewsEmployee(map.get("title")+"", description, map.get("Eheadship")+"", "msg.png",map.get("url")+"", getComId());
		return no;
	}
	@Override
	public PageList<Map<String, Object>> getTailorMadeInfoPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=tailorMadeDao.getTailorMadeInfoPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=tailorMadeDao.getTailorMadeInfoPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public PageList<Map<String, Object>> getTailorMadeOrderPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=tailorMadeDao.getTailorMadeOrderPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=tailorMadeDao.getTailorMadeOrderPage(map);
		for (Iterator<Map<String,Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 =  iterator.next();
			////查询审批记录表
			if ("是".equals(map2.get("ifUseCredit"))) {
				map2.put("com_id", map2.get("com_id").toString().trim());
				String ivt_oper_listing=customerDao.getIoupathByOA(map2);
				if (StringUtils.isNotBlank(ivt_oper_listing)) {
					Object customer_id=map2.get("customer_id");
					map2.put("ioupath", "../"+map.get("com_id")+"/"+customer_id+"/iou/"+ivt_oper_listing+".html");
				}
			}
			///查询是否已经评价
			File file=getOrderEvalFilePath(getRequest(),map2.get("com_id").toString().trim(), map2.get("ivt_oper_listing").toString().trim(), map2.get("item_id").toString().trim());
			if(file.exists()){
				map2.put("pingjiaed", "pingjiaed");
			}
		}
		pages.setRows(list);
		return pages;
	}
	@Override
	public boolean delTailorMade(String orderNo) {
			Integer i= tailorMadeDao.delTailorMade(orderNo);
			if (i>0) {
				return false;
			}else{
				return true;
			}
	}
	
	@Override
	public void saveSum_si(Map<String, Object> map) {
		JSONArray jsons=JSONArray.fromObject(map.get("orderlist"));
		map.put("jsons", jsons);
		tailorMadeDao.saveSum_si(map);
		////向客户发送已经报价消息
		String description=map.get("description").toString().replaceAll("@comName", getComName());
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("title"));
		mapMsg.put("description",description);
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+map.get("url"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getCustomerId(getRequest()));
		news.add(mapMsg);
		Set<String>	set=new HashSet<String>();
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			set.add(json.getString("customer_id"));
		}
		for (String customer_id : set) {
			zuheclientsendmsg("", news, customer_id, "报价通知","客户");
		}
	}
	@Override
	public Map<String,Object> getPayPercentage(Map<String, Object> map) {
		 
		return tailorMadeDao.getPayPercentage(map);
	}
}
