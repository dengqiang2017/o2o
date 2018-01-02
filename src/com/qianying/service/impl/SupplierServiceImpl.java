package com.qianying.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
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

import com.qianying.dao.interfaces.ISupplierDao;
import com.qianying.page.PageList;
import com.qianying.service.ISupplierService;
import com.qianying.util.ConfigFile;
import com.qianying.util.LoggerUtils;
import com.qianying.util.SendSmsUtil;
@Service
@Transactional
public class SupplierServiceImpl extends BaseServiceImpl implements
		ISupplierService {

	@Autowired
	private ISupplierDao supplierDao;
	
	@Override
	public Map<String, Object> checkLogin(String name, String comId) {
		
		return supplierDao.checkLogin(name,comId);
	}

	@Override
	public boolean checkPhone(String phone) {
		Integer i = supplierDao.checkPhone(phone);
		if (i == 0) {
			return true;
		} else {
			return false;
		}
	}
	@Override
	public Map<String, Object> getGysInfoByOpenid(String com_id, Object openid,String type) {
		Map<String, Object> map=new HashMap<>();
		map.put("com_id", com_id);
		if("企业号".equals(type)){
			map.put("weixinID", openid);
		}else{
			map.put("openid", openid);
		}
		return supplierDao.getGysInfoByOpenid(map);
	}
	@Override
	public String getMaxSupplier() {
		return supplierDao.getMaxSupplier();
	}
	
	@Override
	public void save(Map<String, Object> map) {
		managerDao.insertSql(getInsertSql("Ctl00504", map));
		try {
			///获取职位是内勤的所有人员
			Map<String,Object> mapparams=new HashMap<String, Object>();
			mapparams.put("com_id", getComId());
			mapparams.put("headship", "%客服%");
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title","供应商注册核实" );
			String description="@comName@Eheadship@clerkName：有供应商注册,请核实其身份并完善资料和授权,注册手机号:"+map.get("movtel");
			mapMsg.put("description",description);
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/manager/vendor.do?corp_id="+map.get("corp_id"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			for (int i = 0; i < touserList.size(); i++) {
				Map<String, String> item=touserList.get(i);
				String newdes=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", "客服")
						.replaceAll("@clerkName", item.get("clerk_name"));
				news.get(0).put("description",newdes);
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,item.get("weixinID"),"员工");
				}
				news.get(0).put("description",description);
			}
		} catch (Exception e) {
			LoggerUtils.error(e.getMessage());
		}
	}
	@Override
	public PageList<Map<String, Object>> getGysOrderList(Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=supplierDao.getGysOrderCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=supplierDao.getGysOrderList(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public List<Map<String,Object>> gysOrderInfo(Map<String, Object> map) {
		 
		return supplierDao.gysOrderInfo(map);
	}
	@Override
	public void orderReceipt(Map<String, Object> map) throws Exception {
		JSONArray arr=JSONArray.fromObject(map.get("list"));
		Set<String> set=new HashSet<String>();		
 		for (int i = 0; i < arr.size(); i++) {
			JSONObject json= arr.getJSONObject(i);
			json.put("com_id", map.get("com_id"));
			String wuliudx=supplierDao.orderReceipt(json);
			if(StringUtils.isNotBlank(wuliudx)){
				set.add(json.getString("st_auto_no")+"|"+wuliudx);
			}else{
				set.add(json.getString("st_auto_no"));
			}
			map.put("st_auto_no", json.getString("st_auto_no"));
		}
		///////////////
//			String[] str=item.split("\\|");
			///发送微信消息给采购
			String dis="有货并准备发货";
			String url="/employee/purchasingOrder.do?st_auto_no="+map.get("st_auto_no");
			String headship ="采购";
			if ("3".equals(map.get("type"))) {
				dis="无货";
				headship ="采购";
				url="/employee/purchasingOrder.do?st_auto_no="+map.get("st_auto_no");
			}else if("4".equals(map.get("type"))){
				for (String item : set) {
				dis="供应商已发货";
				if(item.contains("公司仓库")){
					headship="库管";
					url="/employee/receiving.do?st_auto_no="+map.get("st_auto_no");
				}else{
					headship="库管";
					dis="供应商已发货给客户";
					url="/employee/receiving.do?st_auto_no="+map.get("st_auto_no");
				}
			}
		}
		String clerk_name=getMapKey(getCustomer(getRequest()), "clerk_name");
//		sendMessageNewsNeiQingUrl("供应商["+clerk_name+"]已反馈采购订单消息,"+dis,dis, headship, url);
		String des=map.get("description").toString().replaceAll("@gys", clerk_name);
		map.put("description", des);
		sendMessageNewsEmployee(map.get("title")+"",map.get("description")+"", headship, null, url, null);
		
	}
	
	@Override
	public void noticeGysWuliu(Map<String, Object> map) {
		//1.保存物流信息
		Map<String,String> mapgys= supplierDao.updateGysWuliu(map);
		StringBuffer buffer=new StringBuffer();
		buffer.append("订单编号:").append(map.get("st_auto_no"));
		if("0".equals(map.get("index"))||"2".equals(map.get("index"))){
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", map.get("title"));
			mapMsg.put("description",map.get("description").toString().replaceAll("@comName",getComName()).replaceAll("@clerkName", map.get("clerk_name")+""));
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/supplier.do?st_auto_no="+map.get("st_auto_no")+"|type=9");
			Object imgName=map.get("imgName");
			if(imgName==null){
				imgName="msg.png";
			}
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/"+imgName);
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			if(StringUtils.isNotBlank(mapgys.get("weixinID"))){
				sendMessageNews(news, mapgys.get("weixinID"),"供应商");
			}
		}
		if("1".equals(map.get("index"))||"2".equals(map.get("index"))){
			Map<String,Object> mapsms=getSystemParamsByComId();
			SendSmsUtil.sendSms2(mapgys.get("phone"), null,"您有来自["+getComName()+"]采购订单物流消息,"+ buffer.toString(),mapsms);
		}
		
	}
	
	@Override
	public void noticeShippingManager(Map<String, Object> map) {
		//1.更新订单已出库
		employeeDao.updateOrderchuku(map);
		//2.更新采购订单已发货
		List<Map<String, String>> list=orderTrackingDao.getCaigouOrderInfoByOrderSeeds_id(map);
		for (Map<String, String> map2 : list) {
			map.put("item_id", map2.get("item_id"));
			map.put("st_hw_no", map2.get("st_hw_no"));
			map.put("mps_id", map2.get("orderNo"));////
			orderTrackingDao.updateStdm02001(map);
		}
		String buf="库管:"+map.get("clerk_name")+map.get("msg");
		//3.向客户发送产品已发货通知]
		map.put("customer", "customer");///先标识查询的对象
		List<Map<String, String>> cus=orderTrackingDao.getOrderInfoBySeeds_id(map);
		for (Map<String, String> map2 : cus) {
			//3.1获取订单中的客户信息
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", map.get("msg"));
			mapMsg.put("addName", map.get("addName"));
			mapMsg.put("description",map.get("description"));
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do?seeds_id="+map.get("seeds_id")+"|"+utf8to16("已发货"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/"+map.get("imgName"));
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			sendclientmsg(map.get("headship")+"", news, map2.get("customer_id")+"", map.get("proName")+"");
		}
		String[] ses=map.get("seeds_id").toString().split(",");
		for (String seeds_id : ses) {
			saveOrderHistory(seeds_id, "供应商"+buf);
		}
	}
	
	
	@Override
	public List<Map<String, Object>> getCustomerOrderList(
			Map<String, Object> map) {
		 
		return supplierDao.getCustomerOrderList(map);
	}
	
	@Override
	public List<Map<String, Object>> getItemOrderList(Map<String, Object> map) {
		// TODO 按产品汇总-类别查询
		return supplierDao.getItemOrderList(map);
	}
	@Override
	public List<Map<String, Object>> getSupplierItemList(Map<String, Object> map) {
		 
		return supplierDao.getSupplierItemList(map);
	}
	
	@Override
	public String saveUpPrice(Map<String, Object> map) {
		// TODO Auto-generated method stub
		Object title=map.get("title");map.remove("title");
		Object description=map.get("description");map.remove("description");
		Object headship=map.get("headship");map.remove("headship");
		String ivt_oper_listing="NO."+new Date().getTime();
		map.put("ivt_oper_listing", ivt_oper_listing);
		managerDao.insertSql(getInsertSql("stdM02010", map));
		//向管理端发送已报价消息
//		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
//		Map<String,Object> mapMsg=new HashMap<String, Object>();
//		mapMsg.put("title", map.get("title"));
//		mapMsg.put("description",map.get("description"));
//		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/upItemInfo.do?item_id="+map.get("item_id")+"|"+map.get("vendor_id"));
//		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/"+map.get("imgName"));
//		if(getCustomer(getRequest())!=null){
//			mapMsg.put("sendRen", getCustomerId(getRequest()));
//		}
//		news.add(mapMsg);
//		sendemployeemsg(map.get("headship")+"", news, getComId(), "");
		map.put("title", title);
		map.put("description", description);
		map.put("headship", headship);
		String url= "/employee/upItemInfo.do?"+map.get("ivt_oper_listing");
		sendMessageNewsEmployee(title+"", description+"", headship+"", "", url, getComId());
		return null;
	}
	@Override
	public String saveSupplierInfo(Map<String, Object> map) {
		StringBuffer sSql=new StringBuffer("update ctl00504 set ");
		Set<String> set= map.keySet();
		for (String key : set) {
			if (StringUtils.isNotBlank(key)) {
				key=key.toString().trim();
				if(!"com_id".equals(key)&&!"com_id".equals(key)){
					sSql.append(key).append("=#{").append(key).append("} ").append(",");
				}
			}
		}
		sSql=new StringBuffer(sSql.substring(0, sSql.length()-1));
		sSql.append(" where ltrim(rtrim(isnull(com_id,'')))=#{com_id} and ltrim(rtrim(isnull(corp_id,'')))=#{corp_id}");
		map.put("sSql",sSql);
		productDao.insertSqlByPre(map);
		return null;
	}

	@Override
	public PageList<Map<String, Object>> getReceiptPage(Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=supplierDao.getReceiptCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=supplierDao.getReceiptList(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 = iterator.next();
			 File file=new File(getComIdPath(getRequest())+"certificate/"+map2.get("no")+".jpg");
			 if (file.exists()&&file.isFile()) {
				map2.put("imgpath", "/"+map.get("com_id")+"/certificate/"+map2.get("no")+".jpg");
			}
		}
		pages.setRows(list);
		return pages;
	}
}
