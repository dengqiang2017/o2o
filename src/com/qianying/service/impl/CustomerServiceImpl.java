package com.qianying.service.impl;

import java.io.File;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.bean.ResultInfo;
import com.qianying.dao.interfaces.ICustomerDAO;
import com.qianying.dao.interfaces.IEmployeeDAO;
import com.qianying.dao.interfaces.IProductDAO;
import com.qianying.dao.interfaces.IStatisticalRreportDAO;
import com.qianying.page.CustomerQuery;
import com.qianying.page.PageList;
import com.qianying.page.PersonnelQuery;
import com.qianying.page.ProductQuery;
import com.qianying.page.SupplierQuery;
import com.qianying.service.IClientService;
import com.qianying.service.ICustomerService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.SendSmsUtil;

@Service
@Scope("prototype")
public class CustomerServiceImpl extends BaseServiceImpl implements
		ICustomerService {
	@Resource
	private ICustomerDAO customerDao;
	@Resource//尽量在Service中使用dao
	private IProductDAO productDao;
	@Resource
	private IStatisticalRreportDAO statisticalRreportDao;
	@Resource
	private IEmployeeDAO employeeDao;
	@Resource
	private IClientService clientService;
	
	@Override
	@Transactional
	public void save(Map<String, Object> map) {
		String customer_id = getMaxCustomer_id();
		if(StringUtils.isBlank(customer_id)){
			customer_id="0";
		}
		customer_id = String.format("C%06d",
				Integer.parseInt(customer_id) + 1);
		map.put("customer_id", map.get("upper_customer_id")+customer_id);
		if (isNotMapKeyNull(map, "openid")) {
			if(MapUtils.getString(map, "openid").length()<20){
				map.remove("openid");
			}
		}
		customerDao.insertSql(getInsertSql("SDf00504", map));
		try {
			map.put("type", "注册");
			clientService.saveJinbiInfo(map);
			///获取职位是内勤的所有人员
			Map<String,Object> mapparams=new HashMap<String, Object>();
			mapparams.put("com_id", getComId());
			mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
			mapparams.put("headship", "%客服%");
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			String name="客户";
			if("CS1C001".equals(map.get("upper_customer_id"))){
				name="养殖户";
			}else if("CS1C001".equals(map.get("upper_customer_id"))){
				name="贩购方";
			}
			name=name+":【"+map.get("corp_name");
			mapMsg.put("title",name+"】注册核实" );
			String description=null;
			if (isNotMapKeyNull(mapMsg, "movtel")) {
				description="@comName-@Eheadship-@clerkName：有"+name+"】注册,请核实其身份并完善资料和授权,注册手机号:"+map.get("movtel");
			}else{
				description="@comName-@Eheadship-@clerkName：有"+name+"】注册,请核实其身份并完善资料和授权,注册方式:通过服务号进入系统自动注册";
			}
			mapMsg.put("description",description);
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/manager/client.do?customer_id="+map.get("customer_id"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			for (int i = 0; i < touserList.size(); i++) {
				Map<String,String> item=touserList.get(i);
				String newdes=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", "客服")
						.replaceAll("@clerkName", item.get("clerk_name"));
				news.get(0).put("description",newdes);
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,map.get("com_id")+"",item.get("weixinID"),"员工");
				}
				news.get(0).put("description",description);
			}
		} catch (Exception e) {
//			writeLog(getRequest(), "订单跟踪发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}

	@Override
	@Transactional
	public void update(Map<String, Object> map) {
		customerDao.insertSql(getUpdateSql(map, "SDf00504", "customer_id",
				null, false));
	}

	@Override
	@Transactional
	public void delete(Long id) {
		customerDao.deleteByID(id);
	}

	@Override
	public Map<String, Object> get(Long id) {
		return customerDao.queryByID(id);
	}

	@Override
	public List<Map<String, Object>> getAll() {
		return customerDao.getAll();
	}

	@Override
	public List<Map<String, Object>> findBySql(Map<String, Object> map) {
		return customerDao.queryBySql(map);
	}
	@Override
	public String getCustomerName(String customerId, String comId) {
		Map<String,String> map=customerDao.getCustomerName(customerId,comId);
		if(map!=null){
			if (StringUtils.isNotBlank(map.get("corp_sim_name"))) {
				return map.get("corp_sim_name");
			}
			return map.get("corp_name");
		}
		return "";
	}
	@Override
	public PageList<Map<String, Object>> findQuery(CustomerQuery query) {
		int count = customerDao.count(query);
		PageList<Map<String, Object>> pages = getPageList(query, count);
		// new
		// PageList<Map<String,Object>>(query.getPage(),query.getRows(),count);
		// pages.setCurrentPage(query.getPage());
		// pages.setTotalRecord(count);
		// query.setPage(query.getPage()*query.getRows()+1);
		List<Map<String, Object>> rows = null;
		try {
			rows = customerDao.findQuery(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		pages.setRows(rows);
		return pages;
	}

	@Override
	public boolean checkPhone(String phone,String com_id) {
		Integer i = customerDao.checkPhone(phone,com_id);
		if (i == 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public String getMaxCustomer_id() {
		return customerDao.getMaxCustomer_id();
	}

	@Override
	@Transactional
	public void saveOrder(Map<String, Object> map) throws Exception {
		customerDao.saveOrder(map);
	}

	@Override
	public Map<String, Object> checkLogin(String name, String com_id) {
		Map<String,Object> map=customerDao.checkLogin(name,com_id);
		if (map!=null) {
			if ("消费者".equals(map.get("ditch_type"))) {//消费者上级编码就是自己的编码
				map.put("upper_customer_id",map.get("customer_id"));
				map.put("upper_corp_name",map.get("corp_sim_name"));
			}else{//经销商
				map.put("com_id", com_id);
				//1.判断是否还有下级
				String upper=customerDao.getCustomerNext(map);
				if (StringUtils.isNotBlank(upper)) {//如果有下级表示,使用单位的账号进行登录
					map.put("upper_customer_id",upper);
//					map.put("upper_customer_id",map.get("customer_id"));
				}//没有就直接使用数据中自带的上级客户编码
			}
			return map;
		}
		return null;
	}
	
	@Override
	public Map<String, Object> checkedLogin(String name,String com_id) {
		Map<String,Object> map=customerDao.checkLogin(name,com_id);
		if (map!=null) {
			if ("消费者".equals(map.get("ditch_type"))) {//消费者上级编码就是自己的编码
				map.put("upper_customer_id",map.get("customer_id"));
			}else{//经销商
				map.put("com_id", com_id);
				//1.判断是否还有下级
				String upper=customerDao.getCustomerNext(map);
				if (StringUtils.isNotBlank(upper)) {//如果有下级表示,使用单位的账号进行登录
					map.put("upper_customer_id",upper);
//					map.put("upper_customer_id",map.get("customer_id"));
				}//没有就直接使用数据中自带的上级客户编码
			}
			return map;
		}
		return null;
	}
	
	@Override
	public List<Map<String, Object>> checkLoginEwm(Map<String,Object> map) {
		
		return customerDao.checkLoginEwm(map);
	}
	private Map<String, Object> getParams(JSONObject json,
			String customer_id) {
		Map<String, Object> map = null;
		String item_id = json.getString("item_id");
		Integer i = 0;
		SimpleDateFormat format = new SimpleDateFormat(ConfigFile.DATE_FORMAT,
				Locale.CHINA);
		Map<String, Object> mapparam = new HashMap<String, Object>();
		mapparam.put("item_id", item_id);
		mapparam.put("customer_id", customer_id);
		mapparam.put("com_id", getComId());
		mapparam.put("item_color", json.get("item_color"));
		mapparam.put("item_type", json.get("item_type"));
		i = customerDao.getCustomerProductByItem_id(mapparam);
		if (i <= 0) {
			map = new HashMap<String, Object>();
			Map<String, Object> mappro = productDao.getByItemId(item_id,getComId());
			// /////////////产品相关数据存放到map中begin///////////////////
			// unit_id
			// //////////////////end////////////////
			if(json.has("sd_unit_price_DOWN")){
				map.put("sd_unit_price_DOWN", new BigDecimal(json.getString("sd_unit_price_DOWN")));
			}
			if(json.has("sd_unit_price_UP")){
				map.put("sd_unit_price_UP",json.getString("sd_unit_price_UP"));
			}
			if(json.has("discount_time")){
				map.put("discount_time",json.getString("discount_time"));
			}
			if(json.has("discount_time_begin")){
				map.put("discount_time_begin",json.getString("discount_time_begin"));
			}
			map.put("item_id", item_id);
			map.put("peijian_id", item_id);
			map.put("discount_ornot",  json.getString("discount_ornot"));
			BigDecimal price_display=new BigDecimal(getJsonVal0(json,"price_display"));//对外标价
			BigDecimal price_prefer=new BigDecimal(getJsonVal0(json,"price_prefer"));//现金折扣
			BigDecimal price_otherDiscount=new BigDecimal(getJsonVal0(json, "price_otherDiscount"));
			map.put("price_display",price_display);//对外标价
			map.put("price_prefer",price_prefer);//现金折扣
			map.put("price_otherDiscount", price_otherDiscount);
			if (price_display.compareTo(zeroBig)==1) {//大于0
				map.put("sd_unit_price",price_display.subtract(price_prefer).subtract(price_otherDiscount));
			}else{
				if (json.has("sd_unit_price")) {
					map.put("sd_unit_price",  json.getString("sd_unit_price"));
				}else{
					map.put("sd_unit_price",0);
				}
			}
			map.put("discount_rate", 1);
			map.put("prefer", 0);
			map.put("tax_sum_si", mappro.get("item_cost"));
			map=getItemByJson(map, json);
		}
		return map;
	}
	private Map<String, Object> getParams(String item,
			String customer_id) {
		return getParams( JSONObject.fromObject(item), customer_id);
	}

	@Override
	@Transactional
	public String addProduct(Map<String, Object> map)throws Exception {
		///TODO 生成报价单
		String msg=null;
		if (isMapKeyNull(map, "item_ids")) {
			msg="产品信息为空";
		}else if(isMapKeyNull(map,"customer_ids")){
			msg="客户信息为空";
		}else{
			String customer_id = map.get("customer_ids").toString();
			String comId = map.get("com_id").toString();
			Map<String,Object> mapcus=customerDao.getCustomerByCustomer_id(customer_id,comId);
			String price_type ="零售";//ditch_type
			if (mapcus!=null&&mapcus.get("ditch_type")!=null) {
				if (mapcus.get("ditch_type").toString().indexOf("协议")>0) {
					price_type="协议";
				}else if (mapcus.get("ditch_type").toString().indexOf("经销商")>0) {
					price_type="批发";
				}
			}
			String clerk_id = map.get("clerk_id").toString();
			if (StringUtils.isNotBlank(customer_id)) {
				String no = getOrderNo(customerDao, "销售订单", comId);
				int index = 0;
				JSONArray jsons=JSONArray.fromObject(map.get("item_ids"));
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					Map<String, Object> mapdetail = getParams(json,customer_id);
					if (mapdetail != null) {
						mapdetail.put("com_id", comId);
						mapdetail.put("m_flag", "0");
//						mapdetail.put("sd_order_direct", "发货");
						mapdetail.put("ivt_oper_listing", no);
						mapdetail.put("mainten_clerk_id", clerk_id);
						mapdetail.put("mainten_datetime", getNow());
						mapdetail.put("customer_id", customer_id);
						getJsonVal(mapdetail, json, "client_item_name", "client_item_name");
						getJsonVal(mapdetail, json, "peijian_id", "peijian_id");
						getJsonVal(mapdetail, json, "no", "no");
						customerDao.insertSql(getInsertSql("SDd02011", mapdetail));
						index += 1;
					}
				}
				if (index > 0) {
					Map<String, Object> main = new HashMap<String, Object>();
					main.put("com_id", comId);
					main.put("sd_order_direct", "发货");
					main.put("ivt_oper_bill", "发货");
					main.put("ivt_oper_listing", no);
					main.put("sd_order_id", no);
					main.put("price_type", price_type);
					main.put("sd_order_id", no);
					main.put("customer_id", customer_id);
					main.put("clerk_id", clerk_id);
					main.put("dept_id", map.get("dept_id"));
					main.put("mainten_clerk_id", clerk_id);
					main.put("so_effect_datetime", getNow());
					main.put("mainten_datetime", getNow());
					// customerDao.addProduct(main);
					customerDao.insertSql(getInsertSql("SDd02010", main));
				}else{
					msg="该产品已经报过价,请到已增加中进行修改!";
				}
			}else{
				msg="客户信息为空";
			}
		}
		return msg;
	}

	@Override
	public List<Map<String, Object>> getCustomerProduct(Object customer_id) {
		if (customer_id != null && customer_id != "") {
			return customerDao.getCustomerProduct(customer_id.toString());
		} else {
			return customerDao.getCustomerProduct(null);
		}
	}

	@Override
	public List<String> getCustomerAddedProduct(Object customer_id,
			String com_id) {
		List<String> list = customerDao.getCustomerAddedProduct(
				customer_id.toString(), com_id);
		return list;
	}

	@Override
	public Map<String, Object> getCustomerByCustomer_id(String customer_id,String comId) {
		return customerDao.getCustomerByCustomer_id(customer_id,comId);
	}
	@Override
	public Map<String, Object> getCustomerSimpleInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return customerDao.getCustomerSimpleInfo(map);
	}
	@Override
	public List<Map<String, Object>> getCustomerTree(Map<String, Object> map) {
		return customerDao.getCustomerTree(map);
	}

	@Override
	public List<Map<String, Object>> getCustomerAndEmployeeTree(
			Map<String, Object> map) {
		map.put("com_id", getComId());
		return customerDao.getCustomerAndEmployeeTree(map);
	}

	@Override
	public PageList<Map<String, Object>> getCustomerAndEmployeePage(
			PersonnelQuery query) {
		query.setCom_id(getComId());
		int count = customerDao.getCustomerAndEmployeeCount(query);
		PageList<Map<String, Object>> pages = getPageList(query, count);
		List<Map<String, Object>> rows = null;
		try {
			rows = customerDao.getCustomerAndEmployeePage(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		pages.setRows(rows);
		return pages;
	}

	@Override
	public List<Map<String, Object>> getCustomerTreeByEmployeeId(
			Map<String, Object> map) {
		return customerDao.getCustomerTreeByEmployeeId(map);
	}

	@Override
	public String getOrderNo(String orderName, String comId) {
		return getOrderNo(customerDao, orderName, comId);
	}

	@Override
	public PageList<Map<String, Object>> getOrderRecord(String type,
			String customerId, ProductQuery query) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("customer_id", customerId);
		// 设置客户的支付中的态为待支付
		if ("0".equals(type)) {
			String sSql = "update SDd02021 set Status_OutStore='待支付' where Status_OutStore='支付中' and  ivt_oper_listing in (select ivt_oper_listing from sdd02020 where customer_id='"+ customerId + "')";
			customerDao.insertSql(sSql);
		}
		map.put("query", query);
		if (StringUtils.isNotBlank(query.getSearchKey())) {
			map.put("searchKey","%"+ query.getSearchKey()+"%");
		}
		int totalRecord = customerDao.getOrderRecordCount(map);
		PageList<Map<String, Object>> pages = getPageList(query, totalRecord);
		List<Map<String, Object>> rows = customerDao.getOrderRecordPage(map);
		pages.setRows(rows);
		return pages;
	}

	@Override
	@Transactional
	public void orderSelectConfirm(String[] set) {
		for (String orderId : set) {
			JSONObject json = JSONObject.fromObject(orderId);
			String sql = "update SDd02021 set Status_OutStore='待支付',pack_num="
					+ json.getString("num") + " where seeds_id="
					+ json.getString("seeds_id");
			customerDao.insertSql(sql);
		}
	}

	@Override
	public Map<String, Object> getPayOderRecord(String customerId, String comId) {
		// 1.获取分组订单总金额
		List<Map<String, Object>> list = customerDao
				.getPayOderRecord(customerId,getComId());
		// 2.获取所有订单总金额
		Map<String, Object> mapCount = customerDao.getOrderCount(customerId,getComId());
		// 3.获取客户发货信息
		Map<String, Object> mapinfo = customerDao
				.getCustomerByCustomer_id(customerId,comId);
		// 4.获取客户账户余额
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("com_id", comId);
//		params.put("StartDate",getNow().split(" ")[0]+" 00:00:00.000");
		params.put("StartDate",getNow()+".999");
		params.put("EndDate",getNow()+".999");
		params.put("Zero", "");
		params.put("clerk_id", "");
		params.put("dept_id", "");
		params.put("Where", "");
		params.put("tjfs", 0);
		params.put("customer_id", customerId);
		params.put("settlement_sortID", "额度款");
		/// 获取结算方式最后一级
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", comId);
		List<Map<String, Object>> jsfslsit = customerDao.getSettlementLast(map);
		/// 获取用户信息
		String sourceBegin=getNow();
		String sourceEnd=getNow().split(" ")[0]+" 23:59:59.999";
		map.put("beginTime", sourceBegin);
		map.put("endTime",  sourceEnd);
		if (map.get("clerk_id")==null) {
			map.put("clerk_id", "");
		}
		map.put("client_id", customerId);
		if (map.get("client_id")==null) {
			map.put("client_id", "");
		}
		if (map.get("dept_id")==null) {
			map.put("dept_id", "");
		}
		if (map.get("tjfs")==null) {
			map.put("tjfs", "");
		}
				
		if (map.get("customer_id")==null) {
			map.put("customer_id", "");
		}

		if (map.get("settlement_sortID")==null) {
			map.put("settlement_sortID", "");
		}
		if (map.get("Zero")==null) {
			map.put("Zero", 2);
		}
		List<Map<String, Object>> accounts = statisticalRreportDao.accountsReceivableLedgerList(map);
		Map<String, Object> maporder = new HashMap<String, Object>();
		if (accounts!=null&&accounts.size()>0) {
			maporder.put("accounts",  accounts.get(accounts.size()-1));
		}
		maporder.put("list", list);
		maporder.put("jsfslsit", jsfslsit);
		maporder.put("customerinfo", mapinfo);
		maporder.put("ordercount", mapCount);
		///获取所有已收款确认未发货的订单总金额
		String noDeliveryje=customerDao.getNoDeliveryOrderSum_si(customerId,getComId());
		maporder.put("noDeliveryje", noDeliveryje);
		return maporder;
	}

	@Override
	public List<Map<String, Object>> getOrderStatusPaying(
			Map<String, Object> map) {
		 
		return customerDao.getPayOderRecord(map.get("customer_id").toString(),map.get("com_id").toString());
	}
	
	@Override
	@Transactional
	public void orderPay(String[] seeds_ids) {
		for (String orderId : seeds_ids) {
			JSONObject json = JSONObject.fromObject(orderId);
			String sql = "update SDd02021 set Status_OutStore='支付中',sd_oq="
					+ json.getString("num") + ",sum_si="+json.getString("sum_si")+"  where seeds_id="
					+ json.getString("seeds_id");
			LoggerUtils.info(sql);
			customerDao.insertSql(sql);
		}
	}
	@Override
	@Transactional
	public String saveIouOA_ctl03001_approval(Map<String, Object> map) {
		if (map.get("orderlist")!=null) {
			Map<String, Object> item=new HashMap<String, Object>();
			Integer opid=getApprovalNo(DateTimeUtils.getNowDateTime());
			String op_id="SPNR"+DateTimeUtils.getNowDateTime()+String.format("%03d", opid++);
			//1.获取欠条的审批流程编码信息
			Map<String,Object> process=getProcessInfoByName("客户欠条审批","asc",productDao);
			//2.获取流程中对应的员工信息
			Object clerk_idAccountApprover=setClerk_idAccountApprover(process.get("clerk_id"), map); 
			item.put("item_id", process.get("item_id"));
			item.put("ivt_oper_listing", op_id);
			item.put("sd_order_id",op_id);
			item.put("store_date",getNow());
			StringBuffer buffer=new StringBuffer();
			buffer.append(map.get("customerName")).append(",")//.append(map.get("customer_id"))
			.append("金额:").append(map.get("order_je"));
			if(!map.get("orderlist").toString().startsWith("[")){
				map.put("orderlist","["+map.get("orderlist")+"]");
			}
//			String msgtxt=buffer.toString();
			JSONArray orders=JSONArray.fromObject(map.get("orderlist"));
			///////////////
			map.put("Status_OutStore", "打欠条");
			String orderNo=null;
			if ("tailorOrder".equals(map.get("order"))) {
				try {
					  orderNo=saveOrder(map.get("order"), map.get("orderlist"), map);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				orderPayment(map);
			}
			/////////////////////
			if ("tailorOrder".equals(map.get("order"))) {
				buffer.append("订单号:").append(orderNo);
				item.put("content",buffer);
			}else{
				buffer.append(",").append("[");
				for (int i = 0; i < orders.size(); i++) {
					JSONObject json= orders.getJSONObject(i);
					buffer.append(json.getString("ivt_oper_listing")).append("_").append(json.getString("seeds_id")).append(",");
				}
				item.put("content",buffer.append("]"));
			}
			item.put("com_id",map.get("com_id"));
			item.put("approval_step",1);
			item.put("mainten_clerk_id",map.get("customer_id"));
			item.put("maintenance_datetime",getNow());
//			map.put("Status_preIN", "否");
//			String ardid=saveARD02051(map,"JS001JS004","-"+map.get("ddzje"));//+"["+ardid+"]"
			item.put("OA_what", "申请欠条审批,金额:"+map.get("order_je"));
			item.put("OA_je", map.get("order_je"));
			item.put("OA_who", map.get("customer_id"));
			item.put("OA_whom", clerk_idAccountApprover);//客户审批人
			
			customerDao.insertSql(getInsertSql("OA_ctl03001_approval", item));
			////////////////
//			sendOAMessageNews(clerk_idAccountApprover,"客户欠条审批", msgtxt);
			if (clerk_idAccountApprover!=null) {
				Map<String,String> mapemployee= employeeDao.getPersonnelWeixinID(clerk_idAccountApprover.toString(), getComId());
				if (mapemployee!=null) {
//					String msg=mapemployee.get("clerk_name")+",您有一条【"+OAName+"】记录需要协同,请尽快到【我的协同】中去处理";
					String description="@comName@clerkName:有客户【"+map.get("customerName")+"】申请打欠条，请及时审批。欠条金额:"+map.get("order_je")+",申请时间:"+getNow();
					List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
					Map<String,Object> mapmsg=new HashMap<String, Object>();
					mapmsg.put("title", "客户欠条审批");
					String newds=description.replaceAll("@comName", getComName()).replaceAll("@clerkName", mapemployee.get("clerk_name"));
					mapmsg.put("description", newds);
					mapmsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/myOA.do");
					mapmsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
					if(getCustomer(getRequest())!=null){
						mapmsg.put("sendRen", getCustomerId(getRequest()));
					}else if(getEmployee(getRequest())!=null){
						mapmsg.put("sendRen", getEmployeeId(getRequest()));
					}
					news.add(mapmsg);
					sendMessageNews(news,getComId(), mapemployee.get("weixinID"),"员工");
				}
			}
			return op_id;
		}
		return null;
	}	
	/**
	 * 保存账上款扣减金额到收款表中
	 * @param map
	 * @param request 
	 */
	private void saveZSKARd02051(Map<String,Object> map){
		Object jiesList=map.get("jiesList");
		 if (jiesList!=null&&!"".equals(jiesList.toString().trim())) {
			 if(!map.get("jiesList").toString().startsWith("[")){
					map.put("jiesList","["+map.get("jiesList")+"]");
			}
			 jiesList=map.get("jiesList");///用于当只有一项的时候在首位加[]后再次取出新的数据
			 JSONArray jsons=JSONArray.fromObject(jiesList);
			 StringBuffer buffer=new StringBuffer();
			 for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				map.put("paystyletxt", "订单支付");
				String no=saveARD02051(map, json.getString("jies_no"),"-"+json.getString("jies_je"));
				if (buffer.indexOf(no)<0) {
					buffer.append(no).append(",");
				}
			}
			 
			 Object customerName=map.get("customerName");
			 if (customerName!=null) {
				 String params=utf8to16(customerName+"");
				 sendMessageOAARD02051("",buffer.toString(),params,null);
			}
		 }
	}
	/**
	 * 保存预存款扣减金额到收款表并生成审批记录
	 * @param map
	 * @param request 
	 */
	private void saveYCKARd02051(Map<String,Object> map ){
		Object jiesList=map.get("jiesListYCK");
		 if (jiesList!=null&&!"".equals(jiesList.toString().trim())) {
			 if(!map.get("jiesListYCK").toString().startsWith("[")){
					map.put("jiesListYCK","["+map.get("jiesListYCK")+"]");
			}
			 jiesList=map.get("jiesListYCK");
			 JSONArray jsons=JSONArray.fromObject(jiesList);
			 for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				//预存款 金额 负数 在存入到账上款中      jies_no=结算方式编码    jies_je=金额
				map.put("paystyletxt", "订单支付预存款转出");
				map.put("Status_preIN", "否");
				String recieved_auto_id=saveARD02051(map, json.getString("jies_no"),"-"+json.getString("jies_je"));
				//账上款存入        jies_no=结算方式编码    jies_je=金额
				map.put("paystyletxt", "订单支付预存款转入账上款");
				recieved_auto_id+=","+saveARD02051(map, "JS001JS003",json.getString("jies_je"));
				if (map.get("fuddje")!=null) {
					map.put("paystyletxt", "订单支付账上款扣减");
					recieved_auto_id+=","+saveARD02051(map,"JS001JS003","-"+json.getString("jies_je"));
				}
				map.put("order_je", json.getString("jies_je"));
				postYCKOA(map,recieved_auto_id);
				
			}
		 }
		///生成预存款审批记录
		
	}
	/**
	 * 提交预存款审批
	 * @param map
	 * @param recieved_auto_id  需要至Y的收款单号
	 */
	private void postYCKOA(Map<String, Object> map, String recieved_auto_id) {
		Map<String, Object> item=new HashMap<String, Object>();
		//1.获取欠条的审批流程编码
		SimpleDateFormat format=new SimpleDateFormat("yyyyMMddHHmmss",Locale.CHINA);
			Integer opid=getApprovalNo(format.format(new Date()));
		String op_id="SPNR"+format.format(new Date())+String.format("%03d", opid++);
		Map<String,Object> process=getProcessInfoByName("预存款","asc",productDao);
		//////////
//		Map<String,Object> cus= employeeDao.getPersonnel(process.get("clerk_id")+"", getComId());
//		Object clerk_idAccountApprover=map.get("clerk_idAccountApprover");
//		if (!"客户审批员".equals(cus.get("clerk_name"))) {
//			clerk_idAccountApprover=process.get("clerk_id");
//		}
		Object clerk_idAccountApprover=setClerk_idAccountApprover(process.get("clerk_id"), map);
		//////////////
		item.put("item_id", process.get("item_id"));
		item.put("ivt_oper_listing", op_id);
		item.put("sd_order_id",op_id);
		item.put("store_date",getNow());
		StringBuffer buffer=new StringBuffer();
		buffer.append(map.get("customerName")).append(",")//.append(map.get("customer_id"))
		.append("金额:").append(map.get("order_je"));
		if(!map.get("orderlist").toString().startsWith("[")){
			map.put("orderlist","["+map.get("orderlist")+"]");
		}
		String msgtxt=buffer.toString();
		JSONArray orders=JSONArray.fromObject(map.get("orderlist"));
		buffer.append(",").append("[");
		for (int i = 0; i < orders.size(); i++) {
			JSONObject json= orders.getJSONObject(i);
			buffer.append(json.getString("ivt_oper_listing")).append("_").append(json.getString("seeds_id")).append(",");
		}
		item.put("content",buffer.append("]"));
		item.put("com_id",map.get("com_id"));
		item.put("approval_step",1);
		item.put("mainten_clerk_id",map.get("com_id"));
		item.put("maintenance_datetime",getNow());
		item.put("OA_what", "预存款审批,金额:"+map.get("order_je")+"["+recieved_auto_id+"]");
		item.put("OA_je", map.get("order_je"));
		item.put("OA_who", map.get("customer_id"));
		item.put("OA_whom", clerk_idAccountApprover);//客户审批人
		customerDao.insertSql(getInsertSql("OA_ctl03001_approval", item));
//		Object customerName=map.get("customerName");
		sendOAMessageNews(clerk_idAccountApprover, "预存款", msgtxt);
	}

	private String saveARD02051(Map<String,Object> map,String jies_no,String jies_je){
		Map<String,Object> mapjies=new HashMap<String, Object>();
		String recieved_auto_id = getOrderNo("销售收款",getComId());
		mapjies.put("com_id", getComId());
		Calendar c = Calendar.getInstance();
		mapjies.put("finacial_y", c.get(Calendar.YEAR));
		mapjies.put("finacial_m", c.get(Calendar.MONTH));
		mapjies.put("finacial_d", getNow());
		mapjies.put("recieved_direct", "收款");
		mapjies.put("recieved_auto_id", recieved_auto_id);
		 
		if(!map.get("orderlist").toString().startsWith("[")){
			map.put("orderlist","["+map.get("orderlist")+"]");
		}
		JSONArray orders=JSONArray.fromObject(map.get("orderlist"));
		StringBuffer buffer=new StringBuffer();
		for (int i = 0; i < orders.size(); i++) {
			JSONObject json= orders.getJSONObject(i);
			buffer.append(json.getString("ivt_oper_listing")).append(",");
		}
		if (buffer.length()>1000) {
			buffer=new StringBuffer(buffer.substring(0, 29));
		}
		mapjies.put("rejg_hw_no", buffer.toString());
		
		mapjies.put("recieved_id", recieved_auto_id);
		mapjies.put("recieve_type", "应收款");
		mapjies.put("customer_id", map.get("customer_id"));
		mapjies.put("rcv_hw_no", jies_no);// 结算方式内码
		mapjies.put("sum_si",jies_je);// 存正数到数据表中
		mapjies.put("sum_si_origin", "账面支付");// 收款通路
		mapjies.put("comfirm_flag", "N");
		mapjies.put("mainten_clerk_id", map.get("com_id"));
		mapjies.put("Status_preIN", map.get("Status_preIN"));
		mapjies.put("mainten_datetime", getNow());
//		mapjies.put("c_memo", map.get("orderlist"));
		buffer=new StringBuffer(map.get("customerName").toString());
		buffer.append(getNow().split(" ")[0]).append("收款单号");
		buffer.append("[").append(recieved_auto_id).append("]").append(map.get("paystyletxt"));
//		mapjies.put("c_memo", buffer.toString());
		
		File file=getRecievedMemo(getRequest(), recieved_auto_id,map.get("customer_id").toString());
		if (map.get("orderlist")!=null) {
//			buffer.append(map.get("orderlist").toString());
		} 
		saveFile(file, buffer.toString());
		
		customerDao.insertSql(getInsertSql("ARd02051", mapjies));
		return recieved_auto_id;
	}
	@Override
	@Transactional
	public String cashDelivery(Map<String, Object> map) {
		//在支付成功后更改订单状态时生成一个新订单并更新到订单中
		//1.判断当前支付的订单编号是否完全一样
		//2.不一样就生成一个新订单编号
		//3.更新订单编号和订单状态
		//TODO 货到付款
	 	//2.获取支付中订单xx
		List<Integer> list=customerDao.getPayOrderSeeds_id(map);
		Integer check=customerDao.checkPayOrderNoSame(map);
		String orderNo=null;
		if(check>1){
			orderNo=getOrderNo("销售开单", getComId());
		}
		//3.更新订单
		String seeds="";
		JSONArray jsons=getJSONArrayByTxt(getRequest());
		JSONObject json0=jsons.getJSONObject(0);//0-订单审核
		for (Integer seeds_id : list) {
			seeds=seeds_id+","+seeds;
			saveOrderHistory(seeds_id,"客户:"+map.get("customerName")+",下订单,付款方式:货到付款,订单编号: "+map.get("orderNo"));
		}
		String description=map.get("description").toString().replaceAll("@customerName", map.get("customerName").toString());
		description=description.replaceAll("@orderNo", map.get("orderNo").toString());
		map.put("seeds", seeds.substring(0, seeds.length()-1));
		//4.发送核货消息
		if(orderNo!=null){
			map.put("newOrderNo", orderNo);
			//生成新的订单主表
			Map<String, Object> mainmap = new HashMap<String, Object>();
			mainmap.put("com_id", map.get("com_id"));
			mainmap.put("sd_order_direct", "发货");
			mainmap.put("ivt_oper_bill", "发货");
			mainmap.put("ivt_oper_listing", orderNo);
			mainmap.put("dept_id", map.get("dept_id"));
			mainmap.put("sd_order_id", orderNo);
			mainmap.put("comfirm_flag", "Y");
			mainmap.put("customer_id", map.get("customer_id"));
			mainmap.put("so_consign_date", getNow());
			mainmap.put("at_term_datetime", getNow());
			Calendar c = Calendar.getInstance();
			mainmap.put("finacial_y", c.get(Calendar.YEAR));
			mainmap.put("finacial_m", c.get(Calendar.MONTH));
			mainmap.put("settlement_type_id","JS001JS004");
			productDao.insertSql(getInsertSql("SDd02020", mainmap));
		}
		map.put("Status_OutStore", json0.get("processName"));
		customerDao.updateOrderStatus(map);
		clientService.updateJinbiXiaofei(map);
		String Eurl=json0.getString("Eurl");
		if (Eurl.contains("?")) {
			Eurl=Eurl+"|customer_id="+map.get("customer_id")+"|processName="+utf8to16(json0.getString("processName"));
		}else{
			Eurl=Eurl+"?customer_id="+map.get("customer_id")+"|processName="+utf8to16(json0.getString("processName"));
		}
		json0.put("description", description);
		List<Map<String, String>> touserList=sendMessageNewsEmployee(map.get("title")+"", description, map.get("headship")+"",json0.getString("imgName"),Eurl, getComId());
		if (json0.has("salesperson")&&json0.getBoolean("salesperson")) {
			Map<String,String> mapempl=sendMsgToYewuyuan("客户下订单通知", description, map.get("customer_id"), null);
			List<Map<String,String>> yewuyuan=new ArrayList<>();
			yewuyuan.add(mapempl);
			map.put("first","业务员"+mapempl.get("clerk_name")+":你好,你的客户【"+map.get("customerName")+"】下了一笔新订单:");
			sendNewOrderMsgToEmpl(map, Eurl,"货到付款",json0.getString("template_id"), yewuyuan);
			map.remove("first");
		}
		/////////////////////
		sendNewOrderMsgToEmpl(map, Eurl,"货到付款",json0.getString("template_id"), touserList);
		return null;
	}
	
	@Override
	@Transactional
	public void orderPayment(Map<String, Object> map) {
		 Object orderlist=map.get("orderlist");
		 if (orderlist!=null) {
			 if(!map.get("orderlist").toString().startsWith("[")){
					map.put("orderlist","["+map.get("orderlist")+"]");
			}
			 Object yfk=map.get("yfk");map.remove("yfk");
			 saveZSKARd02051(map);
			 saveYCKARd02051(map);
			 orderlist=map.get("orderlist");
			 JSONArray jsons=JSONArray.fromObject(orderlist);
			 StringBuffer buffer=new StringBuffer();
			 Set<String> comid=new HashSet<String>();
			  for (int i = 0; i < jsons.size(); i++) {
				  JSONObject json=jsons.getJSONObject(i);
				  //{"ivt_oper_listing":"NO.20151007008XSKD","seeds_id":12516,"item_id":"CP000052"}
//				  {transport_AgentClerk_Reciever=客户自提, orderlist=[Ljava.lang.String;@9cb9124, com_id=001, Kar_paizhao=川A1232323, Kar_Driver=来超, FHDZ=, customer_id=CS1C000839, Kar_Driver_Msg_Mobile=13123213123, orderlist[]={"ivt_oper_listing":"NO.20151007008XSKD","seeds_id":12516,"item_id":"CP000052"}}
				  Map<String,Object> mapupdate=new HashMap<String, Object>();
				  StringBuffer sql=new StringBuffer("update sdd02021 set com_id=#{com_id}"); 
				  mapupdate.put("com_id", json.get("com_id"));
				  comid.add(json.getString("com_id"));
				  if (map.get("Status_OutStore")!=null) {
					  sql.append(",Status_OutStore=#{Status_OutStore}");
					  mapupdate.put("Status_OutStore", map.get("Status_OutStore"));
				  }
				  if (map.get("transport_AgentClerk_Reciever")!=null) {
					  sql.append(",transport_AgentClerk_Reciever=#{transport_AgentClerk_Reciever}");
					  mapupdate.put("transport_AgentClerk_Reciever", map.get("transport_AgentClerk_Reciever"));
				  }
				  if (map.get("HYS")!=null) {
					  sql.append(",HYS=#{HYS}");
					  mapupdate.put("HYS",map.get("Kar_Driver")+","+map.get("Kar_Driver_Msg_Mobile"));
				  }
//				  if (map.get("beizhu")!=null) {
//					  sql.append(",beizhu=#{beizhu}");
//					  mapupdate.put("beizhu",map.get("beizhu"));
//				  }
				  if (map.get("FHDZ")!=null) {
					  sql.append(",FHDZ=#{FHDZ}");
					  mapupdate.put("FHDZ", map.get("FHDZ"));
				  }
				  if (map.get("Kar_paizhao")!=null) {
					  sql.append(",Kar_paizhao=#{Kar_paizhao}");
					  mapupdate.put("Kar_paizhao", map.get("Kar_paizhao"));
				  }
				  if (json.get("num")!=null) {
					  sql.append(",sd_oq=#{num}");
					  mapupdate.put("num", json.get("num"));
				  }
				  sql.append("where seeds_id=#{seeds_id} and ivt_oper_listing=#{ivt_oper_listing} ");
				  if (json.get("item_id")!=null) {
					  sql.append("and item_id=#{item_id}");
					  mapupdate.put("item_id", json.get("item_id"));
				  }
				  mapupdate.put("sSql", sql);
				  mapupdate.put("Status_OutStore", map.get("Status_OutStore"));
				  mapupdate.put("seeds_id",json.getInt("seeds_id"));
				  
				  mapupdate.put("ivt_oper_listing", json.getString("ivt_oper_listing"));
				  productDao.insertSqlByPre(mapupdate);
				  String sSql="update sdd02020 set  mainten_datetime=#{mainten_datetime},comfirm_flag='Y' where ivt_oper_listing=#{ivt_oper_listing} and com_id=#{com_id}";
				  mapupdate=new HashMap<String, Object>();
				  mapupdate.put("sSql", sSql);
				  mapupdate.put("com_id",json.get("com_id"));
				  mapupdate.put("ivt_oper_listing",json.getString("ivt_oper_listing"));
				  mapupdate.put("mainten_datetime",getNow());
				  productDao.insertSqlByPre(mapupdate);
				  if (buffer.indexOf(json.getString("ivt_oper_listing"))<0) {
					  buffer.append(json.getString("ivt_oper_listing")).append(",");
				  }
				  saveOrderHistory(json.getInt("seeds_id"), "订单确认,"+getMapKey(map, "sum_si_origin")+",确认人:"+getCustomer(getRequest()).get("clerk_name"));
			}
			if(yfk!=null){
			  String[] Imgheadships=getProcessName("imgName",getRequest());//流程对应消息的图片
				String imgName="msg.png";
				if(Imgheadships.length>1){
					imgName=Imgheadships[0];
				}
			  try {
				  if (map.get("Status_OutStore")!=null&&map.get("Status_OutStore").equals(getProcessName(getRequest(), 0))) {
					  String Status_OutStore=getProcessName(getRequest(), 0);
					  StringBuffer msg=new StringBuffer("您有订单编号为:");
					  msg.append(buffer);
					  msg.append("(客户下订单),请尽快为客户[").append(map.get("customerName")).append("]")
					  .append(Status_OutStore.substring(1, Status_OutStore.length()));
					  String[] Eheadships=getProcessName("Eheadship", getRequest());
					  String headship ="";
					  if(Eheadships!=null){
						  headship =Eheadships[0];
					  }
//					  String headship ="内勤";
//					  if (Status_OutStore.contains("款")) {
//						  headship="出纳";
//					  }
					  Map<String,Object> mapsms=getSystemParamsByComId();
					  if(map.get("mapseeds")!=null){
						  List<Map<String,Object>> mapseeds=(List<Map<String, Object>>) map.get("mapseeds");
						  for (Map<String, Object> map2 : mapseeds) {
							  if (ConfigFile.NoticeStyle.contains("0")) {
								  sendMessageNewsNeiQingHead(map2.get("com_sim_name"),Status_OutStore, msg.toString(), headship,map2.get("com_id"),imgName);
							  }
							  if (ConfigFile.NoticeStyle.contains("1")) {
								  Map<String,Object> mapper=new HashMap<String, Object>();
								  mapper.put("com_id", map2.get("com_id"));
								  mapper.put("movtel","movtel");
								  mapper.put("headship", "%"+headship+"%");
								  mapper.put("processName", "%"+Status_OutStore+"%");
								  mapper.put("ordersMessageReceivedType",getSystemParam("ordersMessageReceivedType"));
								  List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapper);
								  for (Map<String, String> movtel : touserList) {
									  if (StringUtils.isNotBlank(movtel.get("movtel"))) {
										  SendSmsUtil.sendSms2(movtel.get("movtel"), null, "运营商:"+map2.get("com_sim_name")+","+msg.toString(),mapsms);
									  }
								  }
							  }
						}
					  }else{
						  for (String com_id : comid) {
							  if (ConfigFile.NoticeStyle.contains("0")) {
								  sendMessageNewsNeiQingHead("",Status_OutStore, msg.toString(), headship,com_id,imgName);
							  }
							  if (ConfigFile.NoticeStyle.contains("1")) {
								  Map<String,Object> mapper=new HashMap<String, Object>();
								  mapper.put("com_id", com_id);
								  mapper.put("movtel","movtel");
								  mapper.put("headship", "%"+headship+"%");
								  mapper.put("processName", "%"+Status_OutStore+"%");
								  mapper.put("ordersMessageReceivedType", getSystemParam("ordersMessageReceivedType"));
								  List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapper);
								  for (Map<String, String> movtel : touserList) {
									  if (StringUtils.isNotBlank(movtel.get("movtel"))) {
										  SendSmsUtil.sendSms2(movtel.get("movtel"), null, msg.toString(),mapsms);
									  }
								  }
							  }
						  }
					  }
					  
				  }
			} catch (Exception e) {
//				writeLog(getRequest(), "客户下订单发微信", e.getMessage());
				LoggerUtils.error(e.getMessage());
				e.printStackTrace();
			}
			}
		}
	}

	public void sendSmsNeiQing() {
		
	}
	
	@Override
	public Integer getApprovalNo(String nowdate) {
		nowdate = nowdate + "%";
		String no = customerDao.getApprovalNo(nowdate);
		if (StringUtils.isBlank(no)) {
			return 1;
		} else {
			return Integer.parseInt(no.substring(no.length() - 4,
					no.length() - 1)) + 1;
		}
	}

	@Override
	@Transactional
	public void postApproval(Map<String, Object> mapsp) {
		customerDao.insertSql(getInsertSql("OA_ctl03001_approval", mapsp));
	}

	@Override
	@Transactional
	public ResultInfo orderPaymentTwo(Map<String, String[]> mapjson,
			Map<String, String> maporder) {
		boolean success = false;
		String msg = null;
		try {
			String com_id=getComId(getRequest());
			if (StringUtils.isBlank(maporder.get("orderzje"))) {
				msg = "订单错误!";
			} else if (StringUtils.isBlank(maporder.get("delivery_Add"))) {
				msg = "请填写发货地址!";
			} else {
				// 1.计算总金额和总付款金额是否符合条件
				BigDecimal orderzje = new BigDecimal(maporder.get("orderzje"));
				String[] zsklsit = mapjson.get("zsklsit");
				String[] orderjsonlist = mapjson.get("orderjsonlist");
				// 1.1计算账上款总金额
				BigDecimal zskje = sumJsje(zsklsit,"je");
				String recieved_auto_id = getOrderNo("销售收款", com_id);
				// 获取订单号字符串
				// 订单集合字符串
				String orderlist = "";
				List<JSONObject> ivt_oper_listings = new ArrayList<JSONObject>();
				for (String item : orderjsonlist) {
					JSONObject json = JSONObject.fromObject(item);
					orderlist += json.getString("ivt_oper_listing") + ",";
					ivt_oper_listings.add(json);
				}
                //先扣去账上款余额
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("recieved_auto_id", recieved_auto_id);//收款单号
				map.put("orderlist", orderlist);//订单号字符串集合
				map.put("comfirm_flag", "Y");
				// 1.2比较订单总金额是否大于总付款金额
				if (orderzje.compareTo(zskje) == 1) {// 大于总付款金额
					saveSkd_dayu(zsklsit, map);
					map.put("comfirm_flag", "N");
					String[] yckjsonlist = mapjson.get("yckjsonlist");
					String[] edkjsonlist = mapjson.get("edkjsonlist");
					BigDecimal yckje = sumJsje(yckjsonlist,"je");
					// 计算订单总金额减去账上款差额
					BigDecimal cha=orderzje.subtract(zskje);
					//比较预存款与差额
					Integer approvalIndex=null;
					Map<String,Object> process=getProcessInfoByName("预存款","asc",productDao);
					String item_id=process.get("item_id").toString();
					map.put("item_id", item_id);
					if (cha.compareTo(yckje)==1) {//差额 大于预存款金额
						//1.扣去预存款金额
						saveSkd_dayu(yckjsonlist, map);
						//2.提交审批
						approvalIndex=saveApproval(yckjsonlist,"预存款", map,approvalIndex);
						//3.计算额度款总金额
						BigDecimal edkje = sumJsje(edkjsonlist,"je");
						//4.计算扣去预存款的差额
						BigDecimal yck_cha=cha.subtract(yckje);
						//5.比较扣去预存款剩余金额与额度款金额
						//5.1获取额度款结算方式编码
						map.put("item_id", item_id);
						if (yck_cha.compareTo(edkje)==1) {//扣去预存款剩余金额大于额度款
						//扣去额度款金额
						saveSkd_dayu(edkjsonlist, map);
						BigDecimal edk_cha=yck_cha.subtract(edkje);
						//保存到收款单一条差额数据
						saveSkd_xiaoyu_sq(edkjsonlist, edk_cha, map);
						//保存到审批记录一条记录
						approvalIndex=saveApproval(edkjsonlist,"信用额度", map,approvalIndex);
						}else{//扣去预存款剩余金额小于等于额度款
							//扣去额度款差额部分
							saveSkd_xiaoyu(edkjsonlist,yck_cha, map);
							approvalIndex=saveApproval(edkjsonlist,"信用额度", map,approvalIndex);
						}
					}else{//差额小于预存款
						//扣去预存款差额部分
						saveSkd_xiaoyu(yckjsonlist,cha, map);
						approvalIndex=saveApproval(yckjsonlist,"预存款", map,approvalIndex);
					}
				}else{//账上款大于订单总金额,
					saveSkd_xiaoyu(zsklsit,orderzje, map);
				}
				updateOrderType(maporder,ivt_oper_listings);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 计算结算列表累加金额值
	 * @param jslist 结算列表
	 * @param fieldname 字段名称
	 * @return 累加后值
	 */
	private BigDecimal sumJsje(String[] jslist,String fieldname) {
		BigDecimal edkje=new BigDecimal("0");
		if (jslist==null) {
			return edkje;
		}
		for (String item : jslist) {
			JSONObject json = JSONObject.fromObject(item);
			if (StringUtils.isNotBlank(json.getString(fieldname))) {
				BigDecimal je=new BigDecimal(json.getString(fieldname)) ;
				edkje=edkje.add(je);
			}
		}
		return edkje;
	}
  /**
  * 保存审批记录
  * @param jslsit 结算方式列表
  * @param typeName 结算方式中文名称
  * @param params 存放收款单号等map
 * @param request 
  * @param request
  */
	private Integer saveApproval(String[] jslsit, String typeName,
			Map<String, Object> params,Integer opidn) {
		if (jslsit==null) {
			return 0;
		}
		SimpleDateFormat format=new SimpleDateFormat("yyyyMMddHHmmss",Locale.CHINA);
		for (String item : jslsit) {
			JSONObject json = JSONObject.fromObject(item);
			BigDecimal sqje= new BigDecimal(json.getString("sqje"));
			if (sqje.compareTo(new BigDecimal(0))==1) {
				Map<String, Object> mapsp = new HashMap<String, Object>();
				mapsp.put("com_id", getComId(getRequest()));
				if (opidn==null) {
					Integer opid=getApprovalNo(format.format(new Date()));
					opidn=opid;
				}
				String op_id="SPNR"+format.format(new Date())+String.format("%03d", opidn++);
				mapsp.put("ivt_oper_listing",op_id);
				mapsp.put("sd_order_id",op_id);
				mapsp.put("item_id",params.get("item_id"));
				mapsp.put("store_date", getNow());
				mapsp.put("mainten_clerk_id",getComId(getRequest()));
				mapsp.put("maintenance_datetime",getNow());
				mapsp.put("content","收款单号为:"+ params.get("recieved_auto_id")+",进行"+typeName+"申请,金额:"+sqje.toString()+"元");							
				mapsp.put("approval_step", 1);
				mapsp.put("OA_what", "申请"+typeName+","+ params.get("recieved_auto_id")+","+sqje.toString());
				mapsp.put("OA_je", sqje.toString());
				mapsp.put("OA_who", getCustomerId(getRequest()));
				customerDao.insertSql(getInsertSql("OA_ctl03001_approval", mapsp));
			}
		}
		return opidn;
	}

	/**
	 * 保存收款单 差额大于付款金额
	 * @param jslsit 结算方式列表
	 * @param params 存放收款单号等map
	 * @param request
	 */
	private void saveSkd_dayu(String[] jslsit, Map<String, Object> params) {
		if (jslsit==null) {
			return;
		}
		for (String item : jslsit) {
			JSONObject json = JSONObject.fromObject(item);
			BigDecimal je= new BigDecimal(json.getString("je"));
			if (je.compareTo(new BigDecimal(0))==1) {
				Map<String, Object> map = new HashMap<String, Object>();
				Calendar c = Calendar.getInstance();
				map.put("com_id", getComId());
				map.put("finacial_y", c.get(Calendar.YEAR));
				map.put("finacial_m", c.get(Calendar.MONTH));
				map.put("finacial_d", getNow());
				map.put("recieved_direct", "收款");
				map.put("recieved_auto_id", params.get("recieved_auto_id"));
				map.put("rejg_hw_no", params.get("orderlist"));
				map.put("recieved_id", params.get("recieved_auto_id"));
				map.put("recieve_type", "预收款");
				map.put("customer_id", getCustomerId(getRequest()));
				map.put("rcv_hw_no", json.getString("jsfssort_id"));// 结算方式内码
				map.put("sum_si",je.multiply(new BigDecimal(-1)));// 存负数到数据表中
				map.put("sum_si_origin", "账面支付");// 收款通路
				map.put("comfirm_flag", "N");
				map.put("mainten_clerk_id", getComId());
				map.put("mainten_datetime", getNow());
//				map.put("c_memo", params.get("orderlist"));
				customerDao.insertSql(getInsertSql("ARd02051", map));
			}
		}
	}
	/**
	 * 保存收款单 差额小于大于付款金额
	 * @param jslsit 结算方式列表
	 * @param orderzje2 付款金额
	 * @param params 存放收款单号等map
	 * @param request
	 */
	private void saveSkd_xiaoyu(String[] jslsit,BigDecimal orderzje2, Map<String, Object> params) {
		//订单总金额
		BigDecimal orderzje=orderzje2;
		if (jslsit==null) {
			return;
		}
		String com_id=getComId();
		for (String item : jslsit) {
			JSONObject json = JSONObject.fromObject(item);
			BigDecimal je=new BigDecimal(json.getString("je"));
			if (je.compareTo(new BigDecimal(0))==1) {
				Map<String, Object> map = new HashMap<String, Object>();
				Calendar c = Calendar.getInstance();
				map.put("com_id", com_id);
				map.put("finacial_y", c.get(Calendar.YEAR));
				map.put("finacial_m", c.get(Calendar.MONTH));
				map.put("finacial_d", getNow());
				map.put("recieved_direct", "收款");
				map.put("recieved_auto_id", params.get("recieved_auto_id"));
				map.put("rejg_hw_no", params.get("orderlist"));
				map.put("recieved_id", params.get("recieved_auto_id"));
				map.put("recieve_type", "预收款");
				map.put("customer_id", com_id);
				map.put("rcv_hw_no", json.getString("jsfssort_id"));// 结算方式内码
				boolean b=false;
				if (orderzje.compareTo(je)==1) {//订单总金额大于该结算方式总金额,扣去该结算方式的全部金额
					orderzje=orderzje.subtract(je);//订单总金额减去金额等于剩余支付金额
					map.put("sum_si", je.multiply(new BigDecimal(-1)));// 存负数到数据表中
				}else{//订单总金额小于,等于该结算方式总金额,直接存订单总金额
					map.put("sum_si", orderzje.multiply(new BigDecimal(-1)));// 存负数到数据表中
					b=true;
				}
				map.put("sum_si_origin", "账面支付");// 收款通路
				map.put("comfirm_flag", params.get("comfirm_flag"));
				map.put("mainten_clerk_id", com_id);
				map.put("mainten_datetime", getNow());
//				map.put("c_memo", params.get("orderlist"));
				customerDao.insertSql(getInsertSql("ARd02051", map));
				if (b) {//一次扣完就不再执行第二次
					break;
				}
			}
		}
	}
	/**
	 * 保存收款单当申请金额大于等于订单金额
	 * @param jslsit 结算方式列表
	 * @param cha 剩余的金额
	 * @param params 存放收款单号等map
	 * @param request
	 */
	private void saveSkd_xiaoyu_sq(String[] jslsit, BigDecimal cha,
			Map<String, Object> params) {
		//订单总金额
		BigDecimal orderzje=cha;
		if (jslsit==null) {
			return;
		}
		for (String item : jslsit) {
			JSONObject json = JSONObject.fromObject(item);
			if (StringUtils.isNotBlank(json.getString("sqje"))) {
				BigDecimal je=new BigDecimal(json.getString("sqje"));
				if (je.compareTo(new BigDecimal(0))==1) {
					Map<String, Object> map = new HashMap<String, Object>();
					Calendar c = Calendar.getInstance();
					map.put("com_id", getComId(getRequest()));
					map.put("finacial_y", c.get(Calendar.YEAR));
					map.put("finacial_m", c.get(Calendar.MONTH));
					map.put("finacial_d", getNow());
					map.put("recieved_direct", "收款");
					map.put("recieved_auto_id", params.get("recieved_auto_id"));
					map.put("rejg_hw_no", params.get("orderlist"));
					map.put("recieved_id", params.get("recieved_auto_id"));
					map.put("recieve_type", "预收款");
					map.put("customer_id", getCustomerId(getRequest()));
					map.put("rcv_hw_no", json.getString("jsfssort_id"));// 结算方式内码
					boolean b=false;
					if (orderzje.compareTo(je)==1) {//扣除后订单总金额大于该结算方式申请金额 
						orderzje=orderzje.subtract(je);//扣除后订单总金额减去申请金额等于剩余支付金额
						map.put("sum_si", je.multiply(new BigDecimal(-1)));// 存负数到数据表中
					}else{//订单总金额小于,等于该结算方式总金额,直接存订单总金额
						map.put("sum_si", orderzje.multiply(new BigDecimal(-1)));// 存负数到数据表中
						b=true;
					}
						map.put("sum_si", orderzje.multiply(new BigDecimal(-1)));// 存负数到数据表中
					map.put("sum_si_origin", "账面支付");// 收款通路
					map.put("comfirm_flag", "N");
					map.put("mainten_clerk_id", getComId(getRequest()));
					map.put("mainten_datetime", getNow());
//					map.put("c_memo", params.get("orderlist"));
					customerDao.insertSql(getInsertSql("ARd02051", map));
					if (b) {//一次扣完就不再执行第二次
						break;
					}
				}
			} 
		}
	}
	/**
	 * 更新订单相关信息
	 * @param maporder 参数存放map
	 * @param ivt_oper_listings 去重复后的订单列表
	 */
	public void updateOrderType(Map<String, String> maporder, List<JSONObject> ivt_oper_listings) {
		// 更新订单列表中的状态为已完成
		// 将待完成订单数据状态改为已完成
		Set<String> orderIds = new HashSet<String>();
		for (JSONObject orderId : ivt_oper_listings) {
			if (StringUtils.isNotBlank(orderId
					.getString("ivt_oper_listing"))) {
				orderIds.add(orderId.getString("ivt_oper_listing"));
				String sql = "update SDd02021 set Status_OutStore='已支付',discount_ornot='N' where seeds_id="
						+ orderId.getInt("seeds_id") + "";
				LoggerUtils.info(sql);
				customerDao.insertSql(sql);
			}
		}
		// 更新订单主表中的发货地址和运输方式数据
		for (String orderId : orderIds) {
			String sqlmain = "update SDd02020 set comfirm_flag='N',delivery_Add='"
					+ maporder.get("delivery_Add")
					+ "',transport_AgentClerk_Reciever='"
					+ maporder.get("transport_AgentClerk_Reciever")
					+ "' where ivt_oper_listing='" + orderId + "'";
			customerDao.insertSql(sqlmain);
		}
	}

	@Override
	public boolean checkClientSelfId(String comId, String self_id) {
		Integer i=customerDao.checkClientSelfId(comId,self_id);
		 if (i>0) {
			 return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 获取订单评价和欠条
	 * @param list
	 * @param map
	 * @return
	 */
private List<Map<String, Object>> getOrderPingjiaAndIou(List<Map<String,Object>> list,Map<String,Object> map) {
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
	return list;
}
	@Override
	public PageList<Map<String, Object>> orderTrackingRecord(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=customerDao.orderTrackingRecordCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=customerDao.orderTrackingRecord(map);
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
	public List<Map<String, Object>> getOrderStateRecord(Map<String, Object> map) {
		List<Map<String,Object>> list=customerDao.getOrderStateRecord(map);
		for (Iterator<Map<String,Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 =  iterator.next();
			///查询是否已经评价
			File file=getOrderEvalFilePath(getRequest(),map2.get("com_id").toString().trim(), map2.get("ivt_oper_listing").toString().trim(), map2.get("item_id").toString().trim());
			if(file.exists()){
				iterator.remove();
			} 
		}
		return list;
	}
	 @Override
	 @Transactional
	public void updateOrder_Process(String comId, String salesOrder_Process) {
		 customerDao.updateOrder_Process(comId,salesOrder_Process);
	}

	@Override
	public List<Map<String, Object>> getSettlementList(Map<String, Object> map) {
		 
		return customerDao.getSettlementLast(map);
	}
	
	private String saveOrder(Object order,Object orderlist,Map<String,Object> map) throws Exception {
		String customer_id=map.get("customer_id").toString();
		if(order!=null&&orderlist!=null){
			Object ditch_type=getCustomer(getRequest()).get("ditch_type");
			if(!orderlist.toString().startsWith("[")){
				orderlist="["+orderlist+"]";
			}
			JSONArray jsons=JSONArray.fromObject(orderlist);
			Map<String,Object> mapcom=new HashMap<String, Object>();
			StringBuffer orderNo=new StringBuffer();
			for (int i = 0; i < jsons.size(); i++) {//将同一个com_id值得数据以","叠加放在map中
				JSONObject json=jsons.getJSONObject(i);
				Object da=mapcom.get(json.getString("com_id"));
				if (da==null) {
					mapcom.put(json.getString("com_id"),  json.toString());
				}else{
					mapcom.put(json.getString("com_id"),  json.toString()+","+da);
				}
			}
			Object[] keys = mapcom.keySet().toArray();//以数组方式获取出map中的com_id
			String clerk_name=getCustomer(getRequest()).get("clerk_name").toString();
			for (int i = 0; i < keys.length; i++) {//循环每个com_id,以com_id为key取出叠加数据
				String no = getOrderNo(customerDao, "销售开单",getComId());
				Object com_id=keys[i];
				Object val=mapcom.get(com_id);
				boolean b=val.toString().endsWith(",");
				if(b){
					val=val.toString().substring(0, val.toString().length()-1);
				}
				val="["+val+"]";//然后组合成json数组
				JSONArray arr=JSONArray.fromObject(val);
				StringBuffer sql=new StringBuffer();
				for (int j = 0; j < arr.size(); j++) {//循环json数组生产sql语句并放入StringBuffer
					JSONObject json=arr.getJSONObject(j);
					Map<String,Object> mapDetail=null;
					String item_id= json.getString("item_id");
					if("neworder".equals(order)){
						 mapDetail= saveSDd02021(json.getString("com_id"), item_id, customer_id,json.getString("zsum"), no);
					}else if("tailorOrder".equals(order)){
						mapDetail=getTailorOrder(no,customer_id,json.get("ivt_oper_bill"),item_id,json.get("sum_si"));
					}
					if (map.get("Status_OutStore")==null) {//用于区分打欠条预存款
						mapDetail.put("Status_OutStore", getProcessName(getRequest(), 0));
					}else{
						mapDetail.put("Status_OutStore", map.get("Status_OutStore"));
					}
					if (isMapKeyNull(mapDetail, "sd_unit_price")) {
					mapDetail.put("sd_unit_price", json.getString("sd_unit_price"));
					}
					mapDetail.put("FHDZ", map.get("FHDZ"));
					if (isMapKeyNull(map, "transport_AgentClerk_Reciever")) {
						mapDetail.put("transport_AgentClerk_Reciever", map.get("transport_AgentClerk_Reciever"));
					}
					sql.append(getInsertSql("sdd02021", mapDetail)).append(";");
					saveOrderHistory(no, item_id,"客户"+ clerk_name+",下订单并支付");
				}
				productDao.insertSql(sql.toString());//执行StringBuffer中的从表数据保存sql语句
				saveSDd02020(com_id, no, customer_id);//保存主表
				orderNo.append(no).append(",");
			}
			return orderNo.substring(0, orderNo.length()-1);
		}
		return null;
	}
	@Override
	@Transactional
	public String savePayInfo(Map<String, Object> map) {
		//TODO 微信支付
		customerDao.insertSql(getInsertSql("ARd02051", map));
		//4.更新订单状态
		JSONArray jsons=getJSONArrayByTxt(getRequest());
		//4.1 获取订单流程第一步消息数据
		JSONObject json0=jsons.getJSONObject(0);
		//4.2获取订单流程第二步流程名称
		String[] seeds_id=MapUtils.getString(map, "rejg_hw_no").split(",");
		String clerk_name=getCustomer(getRequest()).get("clerk_name").toString();
		String desc="客户:"+clerk_name+",下单并支付,支付方式微信支付.";
		if (seeds_id.length>1) {
			map.put("seeds", map.get("rejg_hw_no"));
			for (String id : seeds_id) {
				saveOrderHistory(id, desc);
			}
		}else{
			map.put("seeds_id", map.get("rejg_hw_no"));
			saveOrderHistory(seeds_id[0],desc);
		}
		map.put("Status_OutStore", json0.getString("processName"));
		//4.3更新订单流程
		customerDao.updateOrderStatus(map);
		//更新金币消费为正式
		map.put("skdh", map.get("recieved_auto_id"));
		clientService.updateJinbiXiaofei(map);
//		clientService.updat
		String Econtent=json0.getString("Econtent");
		Econtent=Econtent.replaceAll("@customerName", clerk_name+"");
		Econtent=Econtent.replaceAll("@orderNo", map.get("recieved_id")+"");
		Econtent=Econtent.replaceAll("@recieveType",getMapKey(map, "recieve_type"));
		String Eurl=json0.getString("Eurl");
		if (Eurl.contains("?")) {
			Eurl=Eurl+"|customer_id="+map.get("customer_id")+"|processName="+json0.get("processName");
		}else{
			Eurl=Eurl+"?customer_id="+map.get("customer_id")+"|processName="+json0.get("processName");
		}
		List<Map<String, String>> touserList= sendMessageNewsEmployee(json0.getString("Etitle"), Econtent, json0.getString("Eheadship"), json0.getString("imgName"),Eurl ,getComId());
		if (json0.has("salesperson")&&json0.getBoolean("salesperson")) {
			sendMsgToYewuyuan("客户下订单通知",desc,map.get("customer_id"),null);
		}
		///////////////////
		StringBuffer description=new StringBuffer("@comName-@Eheadship-@clerkName:客户【");
		description.append(getCustomer(getRequest()).get("clerk_name")).append("】下单并支付,支付方式微信支付");
		description.append(",请进行客户收款确认操作，落实款项到账情况。订单金额");
		description.append(map.get("sum_si")).append(",收款单号单号：").append(map.get("recieved_id"));
		sendMessageOAARD02051(clerk_name, description.toString(),"recieved_id="+map.get("recieved_id").toString(),getComId());
		//////
		map.put("seeds_id",strChuli(map.get("recieved_id").toString()));
		if (json0.has("salesperson")&&json0.getBoolean("salesperson")) {
			Map<String,String> mapempl=sendMsgToYewuyuan("客户下订单通知", description.toString(), map.get("customer_id"), null);
			List<Map<String,String>> yewuyuan=new ArrayList<>();
			yewuyuan.add(mapempl);
			map.put("first","业务员"+mapempl.get("clerk_name")+":你好,你的客户【"+clerk_name+"】下了一笔新订单:");
			sendNewOrderMsgToEmpl(map, Eurl,"微信支付",json0.getString("template_id"), yewuyuan);
		}
		sendNewOrderMsgToEmpl(map, Eurl,"微信支付",json0.getString("template_id"), touserList);
		return null;
	}
	
	@Override
	@Transactional
	public void savePaymoney(Map<String, Object> map,Map<String,Object> maporder) throws Exception {
		Object upper_corp_name=map.get("upper_corp_name");
		Object customerName=map.get("customerName");
		if(upper_corp_name==null||"".equals(upper_corp_name.toString().trim())){
			upper_corp_name=customerName;
		}
		String params=utf8to16(map.get("recieved_id")+"");
		/////////////
		map.remove("ddje");
		map.remove("customerName");
		map.remove("upper_corp_name");
		map.remove("fuddje");
//		Object paystyletxt=map.get("paystyletxt");
		map.remove("paystyletxt");
		map.remove("FHDZ");
		map.remove("spNo");
		map.remove("spyj");
		map.remove("ivt_oper_listing");
		map.remove("orderlist[]");
		Object sum_si=map.get("sum_si");
		Object order=map.get("order");map.remove("order");
		if(maporder==null){
			customerDao.insertSql(getInsertSql("ARd02051", map));
			StringBuffer description=new StringBuffer();
			if(!"打欠条".equals(map.get("recieve_type"))){
				description.append("@comName-@Eheadship-@clerkName:有客户【").append(upper_corp_name).append("】支付完成");
			if (!customerName.equals(upper_corp_name)) {
				description.append(",操作人:").append(customerName);
			}
			description.append(",请进行客户收款确认操作，落实款项到账情况。金额");
				description.append(map.get("sum_si")).append(",收款单号：").append(map.get("recieved_id"));
			}
			sendMessageOAARD02051(upper_corp_name, description.toString(),params,getComId());
			return;
		}
		//保存订单如果是直接下订单并支付方式
		String orderNo=saveOrder(order,maporder.get("orderlist"), maporder);
		///向客户所对应的业务员发送客户下单消息//
		if (StringUtils.isNotBlank(orderNo)) {
			///更新收款表订单编号
			map.put("rejg_hw_no", orderNo);
		}
		String desc="客户:【"+getCustomer(getRequest()).get("clerk_name");
		sendMsgToYewuyuan("客户下订单通知",desc+"】下了一笔订单,订单编号:"+map.get("rejg_hw_no"),map.get("customer_id"),null);
		/////
		customerDao.insertSql(getInsertSql("ARd02051", map));
		StringBuffer buffer=new StringBuffer(map.get("recieved_id").toString());
		buffer.append(",支付通路:").append(map.get("sum_si_origin")); 
		buffer.append(",订单总金额:").append(sum_si);
		maporder.put("sum_si_origin", map.get("sum_si_origin"));
		if (!"微信支付".equals(map.get("sum_si_origin"))&&!"支付宝".equals(map.get("sum_si_origin"))) {
//			sendMessageOAARD02051("运营商:"+getComName(),buffer.toString(),params,null);
			StringBuffer description=new StringBuffer(getComName());
			description.append("-@Eheadship-@clerkName:有客户【").append(upper_corp_name).append("】支付完成");
			if (!customerName.equals(upper_corp_name)) {
				description.append(",操作人:").append(customerName);
			}
			description.append(",请进行客户收款确认操作，落实款项到账情况。订单金额");
			description.append(map.get("sum_si")).append(",收款单号单号：").append(map.get("recieved_id")).append(",发生时间:").append(getNow());
			sendMessageOAARD02051(getComName(), description.toString(),params,map.get("com_id"));
			/////////////
			if (maporder!=null&&maporder.get("orderlist")!=null) {
				maporder.put("customerName", upper_corp_name);
				if (StringUtils.isBlank(orderNo)) {
					orderPayment(maporder);
				}
			}
		}else{
			if (maporder!=null&&maporder.get("orderlist")!=null) {
				maporder.put("customerName", upper_corp_name);
				JSONObject json=JSONObject.fromObject(maporder);
				maporder.put("Status_OutStore", null);
				if (StringUtils.isBlank(orderNo)) {
					orderPayment(maporder);
				}
				saveFile(getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id")), json.toString());
			}
			JSONObject json=new JSONObject();
			json.put("buffer", buffer);
			json.put("params", params);
			saveFile(getPayMsgFilePath(map.get("customer_id"),map.get("recieved_id")), json.toString());
		}
	}

	@Override
	public List<Map<String, Object>> getCustomerToWeixin(Map<String, Object> map) {
		 
		return customerDao.getCustomerToWeixin(map);
	}
	
	@Override
	public String getClerk_idAccountApprover(String comId) {
		 
		return customerDao.getClerk_idAccountApprover(comId);
	}

	@Override
	@Transactional
	public String alipayCancel(Map<String, Object> map) {
		File orderinfo=getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id"));
//		File msg=getPayMsgFilePath(map.get("customer_id"),map.get("recieved_id"));
		if (orderinfo.exists()) {
			String str=getFileTextContent(orderinfo);
			JSONObject json=JSONObject.fromObject(str);
			updateOrderBack(json);
		}
		customerDao.deletePayInfo(map);
		return null;
	}
	/**
	 * 订单回退到待支付
	 * @param json
	 */
	private void updateOrderBack(JSONObject json) {
		JSONArray jsons=json.getJSONArray("orderlist");
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject item=jsons.getJSONObject(i);
			Map<String,Object> mapupdate=new HashMap<String, Object>();
			String sql="update sdd02021 set Status_OutStore=#{Status_OutStore} where seeds_id=#{seeds_id} and ivt_oper_listing=#{ivt_oper_listing}";
			mapupdate.put("sSql", sql);
			mapupdate.put("Status_OutStore","待支付");
			mapupdate.put("seeds_id",item.getInt("seeds_id"));
			mapupdate.put("ivt_oper_listing", item.getString("ivt_oper_listing"));
			productDao.insertSqlByPre(mapupdate);
		}
	}

	@Override
	public String alipayOK(Map<String, Object> map) {
		File orderinfo=getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id"));
		if (orderinfo.exists()) {
			String str=getFileTextContent(orderinfo);
			JSONObject json=JSONObject.fromObject(str);
			orderPayment(json);
		}
		File msg=getPayMsgFilePath(map.get("customer_id"),map.get("recieved_id"));
		if (msg.exists()) {
			String str=getFileTextContent(msg);
			JSONObject json=JSONObject.fromObject(str);
			sendMessageOAARD02051(getComName(),json.get("buffer")+"",json.getString("params"),null);
		}
		return null;
	}
	private Map<String, Object> getOrderDetail(String com_id, String item_id,
			String customer_id) throws Exception {
//		Map<String, Object> mapParam = new HashMap<String, Object>();
//		mapParam.put("customer_id",customer_id);
//		mapParam.put("item_id", item_id);
//		mapParam.put("com_id", com_id);
//		LoggerUtils.error("getOrderDetail-begin"+DateTimeUtils.getNowDateTimeS());
//		Map<String, Object> mapPro = productDao.getAddProDetailInfo(mapParam);
//		if (mapPro == null) {
//			throw new RuntimeException("没有获取到客户价单表信息!");
//		}
//		LoggerUtils.error("getOrderDetail-getAddProDetailInfo"+DateTimeUtils.getNowDateTimeS());
		// /订单明细数据封装
		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("item_id", item_id);
//		map.put("ivt_oper_listing", mapPro.get("ivt_oper_listing"));
//		map.put("sid", mapPro.get("seeds_id"));
//		try {
//			map.put("discount_ornot", mapPro.get("discount_ornot"));
//			map.put("sd_unit_price_UP", mapPro.get("sd_unit_price_UP"));
//			map.put("sd_unit_price_DOWN", mapPro.get("sd_unit_price_DOWN"));
//			map.put("discount_time_begin", mapPro.get("discount_time_begin"));
//		} catch (Exception e) {}
//		map.put("pack_num", mapPro.get("pack_num"));
//		map.put("pack_unit", mapPro.get("pack_unit"));
//		map.put("unit_id", mapPro.get("unit_id"));
//		map.put("c_memo", mapPro.get("c_memo"));
//		map.put("memo_color", mapPro.get("memo_color"));
//		map.put("memo_other", mapPro.get("memo_other"));
		
//		map.put("discount_time", mapPro.get("discount_time"));
//		map.put("item_id",item_id);
//		map.put("peijian_id", mapPro.get("peijian_id"));
//		map.put("ivt_oper_bill", mapPro.get("ivt_oper_listing"));
//		map.put("unit_id", mapPro.get("unit_id"));
//		map.put("sd_unit_price", mapPro.get("sd_unit_price"));
//		map.put("price_prefer", mapPro.get("price_prefer"));// 现金折扣
//		map.put("price_otherDiscount", mapPro.get("price_otherDiscount"));

//		map.put("discount_rate", mapPro.get("discount_rate"));
//		map.put("tax_rate", mapPro.get("tax_rate"));
//		map.put("tax_sum_si", mapPro.get("tax_sum_si"));
		return map;
	}
	/**
	 * 产品详情页面-立即购买
	 * @param map
	 * @return
	 * @throws Exception
	 */
	private boolean saveOrderByZERO(Map<String,String> map) throws Exception {
		if(StringUtils.isNotBlank(map.get("item_id"))){///首页产品详情下订单
			String no = getOrderNo(customerDao, "销售开单",getComId());
			map.put("orderpay",map.get("item_id")+"_"+map.get("num"));
			map.put("ZERO", "ZERO");
			int index=saveSDd02021(map.get("com_id"), map.get("customer_id"), no, map);
			//从表保存完成后保存主表
			if (index>0) {
				saveSDd02020(map.get("com_id"), no, map.get("customer_id"));
			}
			return true;
		}
		return false;
	}
	/**
	 * 检查产品是否已经被购买
	 * @param map
	 * @return
	 */
	private boolean checkSN(Map<String,String> map) {
		if(StringUtils.isNotBlank(map.get("s_n"))){
			Integer i=customerDao.checkSN(map);
			if(i>0){
				return false;
			}
		}
		return true;
	}
	@Override
	@Transactional
	public void saveOrderBYShopping(Map<String, String> map) throws Exception {
		 JSONArray jsons=JSONArray.fromObject(map.get("list"));
		 customerDao.updateOrderStatusBycustomer_id(map);
		 for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			customerDao.updateOrderStatusPay(json);
		}
	}
	@Override
	@Transactional
	public void saveOrderAndPay(Map<String, String> map) throws Exception {
		LoggerUtils.error("begin-"+DateTimeUtils.getNowDateTimeS());
		boolean b=checkSN(map);
		if(!b){
			throw new RuntimeException("该产品已被购买");
		}
		//更新客户未支付订单状态未待支付
		customerDao.updateOrderStatusBycustomer_id(map);
		////////////////////////////////////////////
		String orderpay=map.get("orderpay");
		String[] orderpays=orderpay.split(",");
		Map<String,Object> mapcom=new HashMap<String, Object>();
		///////////////////////////////////////////////////////////
		//产品详情页面-立即购买
		//TODO 生成订单
		String operatorType=systemParamsDao.checkSystemDef("operatorType", "b-c", getComId());
		if ("b-c".equals(operatorType)) {
			b=saveOrderByZERO(map);
			if(b){
				return;
			}
		}else{
			generateQuotation(map);
		}
		for (String item : orderpays) {//将同一个comid的产品使用","连接在一起,以com_id值作为map的key值,item为val值,
			String com_id=item.split("_")[0];
			mapcom.put(com_id,item+","+getMapKey(mapcom, com_id));
		}
		//循环获取map中的key值即com_id值,以数组方式获取所有key值
		Object[] keys = mapcom.keySet().toArray();
		for (int i = 0; i < keys.length; i++) {//循环出每一个com_id
			//获取订单编号
			String no = getOrderNo(customerDao, "销售开单",getComId());
			//获取叠加在一起的数据
			Object com_id=keys[i];
			Object val=mapcom.get(com_id);
			b=val.toString().endsWith(",");
			if(b){//判断最后一位是否是","是就去掉
				val=val.toString().substring(0, val.toString().length()-1);
			}
			//以","进行分割val值
			String[] arr=val.toString().split(",");
			int index=0;
			for (int j = 0; j < arr.length; j++) {
				String item=arr[i];//获取分割后的值按照传入时的数据格式进行分割取数
				map.put("orderpay", item.split("_")[1]+"_"+item.split("_")[2]);
				index+=saveSDd02021(item.split("_")[0], map.get("customer_id"), no, map);
			}
			//从表保存完成后保存主表
			if (index>0) {
				saveSDd02020(com_id, no, map.get("customer_id"));
			}
		}
	}
	/**
	 * 客户下订单时检查是否有报价单,没有就增加
	 * @param map
	 * @param customer_id
	 * @param com_id
	 * @param item_id
	 */
	private void generateQuotation(Map<String, String> map) {
		// TODO 生成客户报价单
		//1.该客户该产品的报价单是否存在,
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("customer_id",map.get("customer_id"));
		mapParam.put("com_id", map.get("com_id"));
		mapParam.put("item_id", map.get("item_id"));
		Map<String, Object> mapPro = productDao.getAddProDetailInfo(mapParam);
		//1.2 不存在获取零售客户报价单中的单价
		if (mapPro==null) {
			//2.根据页面参数产品编码+颜色,生成该客户的报价单数据
			String customer_id = map.get("customer_id").toString();
			String comId = map.get("com_id").toString();
			Map<String,Object> mapcus=customerDao.getCustomerByCustomer_id(customer_id,comId);
			String price_type ="零售";//ditch_type
			if (mapcus!=null&&mapcus.get("ditch_type")!=null) {
				if (mapcus.get("ditch_type").toString().indexOf("协议")>0) {
					price_type="协议";
				}else if (mapcus.get("ditch_type").toString().indexOf("经销商")>0) {
					price_type="批发";
				}
			}
			String clerk_id =customer_id; 
				if (StringUtils.isNotBlank(customer_id)) {
					String no = getOrderNo(customerDao, "销售订单", comId);
					int index = 0;
						Map<String, Object> mapinfo = getParams(map.get("item_id").toString(),
								customer_id);
						if (mapinfo != null) {
							mapinfo.put("com_id", comId);
//							mapinfo.put("sd_order_direct", "发货");
							mapinfo.put("ivt_oper_listing", no);
							mapinfo.put("mainten_clerk_id", customer_id);
							mapinfo.put("mainten_datetime", getNow());
							if (StringUtils.isNotBlank(map.get("item_color"))) {
								mapinfo.put("item_color", map.get("item_color"));
							}
							mapinfo.put("customer_id", customer_id);
							customerDao.insertSql(getInsertSql("SDd02011", mapinfo));
							index += 1;
						}
					if (index > 0) {
						Map<String, Object> main = new HashMap<String, Object>();
						main.put("com_id", comId);
						main.put("sd_order_direct", "发货");
						main.put("ivt_oper_bill", "发货");
						main.put("ivt_oper_listing", no);
						main.put("sd_order_id", no);
						main.put("price_type", price_type);
						main.put("sd_order_id", no);
						main.put("customer_id", customer_id);
						main.put("clerk_id", clerk_id);
//						main.put("dept_id", map.get("dept_id"));
						main.put("mainten_clerk_id", clerk_id);
						main.put("so_effect_datetime", getNow());
						main.put("mainten_datetime", getNow());
						// customerDao.addProduct(main);
						customerDao.insertSql(getInsertSql("SDd02010", main));
					}
				}
		}
	}

	private int saveSDd02021(String comId, String customer_id, Object no, Map<String,String> map) throws Exception {
		String orderpay=map.get("orderpay");
		String item_id=orderpay.split("_")[0];//产品编码+数量
		if (StringUtils.isBlank(item_id)) {
			return 0;
		}
		String num=orderpay.split("_")[1];
		String customer_id2=customer_id;
		if (StringUtils.isNotBlank(map.get("ZERO"))) {///首页产品下单
			customer_id2="CS1_ZEROM";
		}
		Map<String, Object> mapDetail =saveSDd02021(comId, item_id, customer_id2, num, no);
		//1.判断该产品是否已经加入过购物车
		mapDetail.put("customer_id", customer_id);
		mapDetail.put("customer_id2", customer_id);
		if (StringUtils.isNotBlank(map.get("s_n"))) {
			mapDetail.put("S_N", map.get("s_n"));
		}
		mapDetail.put("item_id", item_id);
		mapDetail.put("customer_id", customer_id);
		if (StringUtils.isNotBlank(map.get("Status_OutStore"))) {
			mapDetail.put("Status_OutStore", map.get("Status_OutStore"));
		}
		if (StringUtils.isNotBlank(map.get("item_color"))) {
			mapDetail.put("item_color",map.get("item_color"));
		}
		if (StringUtils.isNotBlank(map.get("item_type"))) {
			mapDetail.put("item_type",map.get("item_type"));
		}
		if (isMapKeyNull(mapDetail, "sd_unit_price")) {
			mapDetail.put("sd_unit_price",map.get("sd_unit_price"));
		}
		if (StringUtils.isNotBlank(map.get("memo_color"))) {
			mapDetail.put("memo_color",map.get("memo_color")+getMapKey(mapDetail, "memo_color"));
		}
		mapDetail.put("so_require_date", getNow());
		mapDetail.put("at_term_datetime_Act", getNow());
		Map<String,Object> mappro=productDao.getProductAdded(mapDetail);
		//判断是否已经在购物车中
		if(mappro!=null){
			//存在就更新数量
			productDao.updateAddProduct(mapDetail);
			return 0;
		}else{
			mapDetail.remove("customer_id2");
			productDao.insertSql(getInsertSql("SDd02021", mapDetail));
			return 1;
		}
	}
	/**
	 * 组合订单从表数据
	 * @param comId
	 * @param item_id
	 * @param customer_id
	 * @param num
	 * @param no
	 * @param ditch_type
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object> saveSDd02021(String comId, String item_id, String customer_id, String num, Object no) throws Exception {
		Map<String, Object> mapDetail = getOrderDetail(comId, item_id, customer_id);
		mapDetail.put("com_id", comId);
		mapDetail.put("ivt_oper_listing", no);
		mapDetail.put("sd_order_id", no);
		mapDetail.put("Status_OutStore", "支付中");
		mapDetail.put("customer_id", customer_id);
		mapDetail.put("clerk_id_sid", comId);
		mapDetail.put("sd_oq",num);
//		BigDecimal sum_si=new BigDecimal(num).multiply(new BigDecimal(mapDetail.get("sd_unit_price")+""));
//		mapDetail.put("sum_si", sum_si);
		return mapDetail;
	}
	/**
	 * 获取定制订单需要保存的数据
	 * @param no
	 * @param customer_id
	 * @param orderNo
	 * @param sum_si
	 * @param object 
	 * @return
	 */
	private Map<String,Object> getTailorOrder(Object no, Object customer_id,Object ivt_oper_bill,String item_id, Object sum_si) {
		Map<String, Object> mapDetail = new HashMap<String, Object>();
		mapDetail.put("com_id", getComId());
		mapDetail.put("ivt_oper_listing", no);
		mapDetail.put("item_id", item_id);
		mapDetail.put("ivt_oper_bill", ivt_oper_bill);
		mapDetail.put("peijian_id", item_id);
		mapDetail.put("sd_order_id", no); 
		mapDetail.put("customer_id", customer_id);
		mapDetail.put("clerk_id_sid", getComId());
		mapDetail.put("sd_oq",1);
		mapDetail.put("sd_unit_price", sum_si);
		mapDetail.put("sum_si", sum_si);
		return mapDetail;
	}
	private void saveSDd02020(Object comId, Object no, Object customer_id) {
		// 1.2组合主表数据
		Map<String, Object> mainmap = new HashMap<String, Object>();
		mainmap.put("com_id", comId);
		mainmap.put("sd_order_direct", "发货");
		mainmap.put("ivt_oper_bill", "发货");
		mainmap.put("ivt_oper_listing", no);
		mainmap.put("sd_order_id", no);
		mainmap.put("comfirm_flag", "N");
		mainmap.put("customer_id", customer_id);
		mainmap.put("so_consign_date", getNow());
		mainmap.put("at_term_datetime", getNow());
		Calendar c = Calendar.getInstance();
		mainmap.put("finacial_y", c.get(Calendar.YEAR));
		mainmap.put("finacial_m", c.get(Calendar.MONTH));
		mainmap.put("all_oq", 1);
		mainmap.put("mainten_clerk_id", getComId());
		mainmap.put("mainten_datetime", getNow());
		mainmap.put("settlement_type_id","JS001JS004");
		mainmap.put("HJJS", 1);
		productDao.insertSql(getInsertSql("SDd02020", mainmap));
	}
	@Override
	@Transactional
	public void saveOrderToShopping(Map<String, String> map) throws Exception {
		LoggerUtils.error("shopping-begin->"+DateTimeUtils.getNowDateTimeS());
		boolean b=checkSN(map);
		if(!b){
			throw new RuntimeException("该产品已被购买");
		}
		//TODO 加入购物车
		String operatorType=systemParamsDao.checkSystemDef("operatorType", "b-c", getComId());
		if ("b-b".equals(operatorType)) {
			generateQuotation(map);
		}
		String shopping=map.get("shopping");
		String customer_id=map.get("customer_id");
		String[] shoppings=shopping.split(",");
		if (shoppings!=null&&shoppings.length>0) {
			customerDao.updateOrderStatusBycustomer_id(map);
			////////////////////////////////////////////
			if(StringUtils.isNotBlank(map.get("item_id"))){///首页产品详情下订单
				String no = getOrderNo(customerDao, "销售开单",getComId());
				map.put("orderpay",map.get("item_id")+"_"+map.get("zsum"));
				if ("b-c".equals(operatorType)) {
					map.put("ZERO", "ZERO");
				}
				int index=saveSDd02021(map.get("com_id"),  customer_id, no, map);
				//从表保存完成后保存主表
				if (index>0) {
					saveSDd02020(map.get("com_id"), no, customer_id);
				}
				return;
			}
			////////////////////////////////////////
			Map<String,Object> mapcom=new HashMap<String, Object>();
			///////////////////////////////////////////////////////////
			for (String item : shoppings) {//将同一个comid的产品使用","连接在一起,以com_id值作为map的key值,item为val值,
			String com_id=item.split("_")[0];
			mapcom.put(com_id,item+","+getMapKey(mapcom, com_id));
			}
			//循环获取map中的key值即com_id值,以数组方式获取所有key值
			Object[] keys = mapcom.keySet().toArray();
			for (int i = 0; i < keys.length; i++) {//循环出每一个com_id
			//获取订单编号
			String no = getOrderNo(customerDao, "销售开单",getComId());
			//获取叠加在一起的数据
			Object com_id=keys[i];
			Object val=mapcom.get(com_id);
			b=val.toString().endsWith(",");
			if(b){//判断最后一位是否是","是就去掉
			val=val.toString().substring(0, val.toString().length()-1);
			}
			//以","进行分割val值
			String[] arr=val.toString().split(",");
			int index=0;
			for (int j = 0; j < arr.length; j++) {
				String item=arr[i];//获取分割后的值按照传入时的数据格式进行分割取数
				map.put("orderpay", item.split("_")[1]+"_"+item.split("_")[2]);
				index+=saveSDd02021(item.split("_")[0], customer_id, no, map);
			}
			//从表保存完成后保存主表
			if (index>0) {
				saveSDd02020(com_id, no, customer_id);
			}
			}
		}
		LoggerUtils.error("shopping-end->"+DateTimeUtils.getNowDateTimeS());
	}
	
	@Override
	public void sendMsg(String customerId, String comId,String msginfo) {
		
	}
	@Override
	public String getUpper_customer_id(String customer_id, String comId) {
		 Map<String,Object> map=new HashMap<String, Object>();
		 map.put("customer_id", customer_id);
		 map.put("com_id", comId);
		 String cus=customerDao.getUpper_customer_id(map);
		 if (StringUtils.isNotBlank(cus)) {
			 if ("CS1".equals(cus)) {
				 cus=customer_id;
			 }
			 return cus;
		}else{
			return customer_id;
		}
	}
	@Override
	@Transactional
	public void confimShouhuo(Map<String,Object> map2) throws Exception {
		StringBuffer sql=new StringBuffer();
		String seeds=null;
		if (isMapKeyNull(map2, "orders")) {
			sql.append("update sdd02021 set Status_OutStore='已结束',at_term_datetime_Act='"+getNow()+"' where seeds_id="+map2.get("seeds_id")).append(";");
			managerDao.insertSql(sql.toString());
			seeds=map2.get("seeds_id").toString();
		}else{
			JSONArray jsons=JSONArray.fromObject(map2.get("orders"));
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json= jsons.getJSONObject(i);
				if (seeds==null) {
					seeds=json.getString("seeds_id");
				}else{
					seeds=json.get("seeds_id")+","+seeds;
				}
			}
			sql.append("update sdd02021 set Status_OutStore='已结束',at_term_datetime_Act='"+getNow()+"' where seeds_id in ("+seeds).append(");");
			managerDao.insertSql(sql.toString());
		}
		///更新采购订单为已收货///
		map2.put("seeds_id", seeds);
		List<Map<String, String>> list= orderTrackingDao.getCaigouOrderInfoByOrderSeeds_id(map2);
		Set<String> coms=new HashSet<String>();
		if(list!=null&&list.size()>0){
			for (Map<String, String> map : list) {
				map2.put("st_hw_no", map.get("st_hw_no"));
				map2.put("item_id", map.get("item_id"));
				map2.put("mps_id", map.get("orderNo"));////
				map2.put("com_id", map.get("com_id"));////
				coms.add(map.get("com_id"));
				orderTrackingDao.updateStdm02001(map2);
			}
		}
		//////////根据物流方式生成验收入库单//////////////
		///////////////////////
		for (String com_id : coms) {
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("com_id", com_id);
			List<Map<String, String>> touserList=null;
			Map<String,Object> mapsms=getSystemParamsByComId();
			if(isNotMapKeyNull(mapsms, "acceptanceNoticeElpoyeeHeadship")){
				map.put("headship", "%"+mapsms.get("acceptanceNoticeElpoyeeHeadship")+"%");
				touserList=employeeDao.getPersonnelNeiQing(map);
			}else{
				touserList=new ArrayList<Map<String,String>>();
			}
			map.put("customer_id", map2.get("customer_id"));
			Map<String,String> mapempl =employeeDao.getEmployeeByCustomerId(map);
			touserList.add(mapempl);
			if(touserList.size()>0){
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", "客户已收货通知");
				String description="客户【"+mapempl.get("corp_sim_name")+"】订单产品已确认验收";
				mapMsg.put("description",description);
				mapMsg.put("picurl ",ConfigFile.urlPrefix+"/"+getComId()+"/qianming/"+map.get("orderNo")+"/"+map.get("item_id")+".png");
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?seeds_id="+seeds+"|processName="+utf8to16("已结束"));
				news.add(mapMsg);
				for (int i = 0; i < touserList.size(); i++) {
					Map<String,String> item=touserList.get(i);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						news.get(0).put("description",item.get("com_sim_name")+mapsms.get("Eheadshiped")+item.get("clerk_name")+":"+description);
						sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
					}
					news.get(0).put("description",description);
				}
			}
			if(isNotMapKeyNull(map2, "orderNo")){
				saveOrderHistory(map2.get("orderNo"), map2.get("item_id"),  "订单产品已确认验收,收货人:"+getCustomer(getRequest()).get("clerk_name"));
			}else{
				saveOrderHistory(map2.get("seeds_id"),"订单产品已确认验收,收货人:"+getCustomer(getRequest()).get("clerk_name"));
			}
		}
	}
	
	@Override
	public List<Map<String, Object>> findOrderBySeeds_id(String seeds_ids) {
		 
		return customerDao.findOrderBySeeds_id(seeds_ids);
	}
	@Override
	@Transactional
	public String confirmQianming(JSONArray jsons, Map<String, Object> map) {
		StringBuffer sql=new StringBuffer();
		StringBuffer no=new StringBuffer(":客户已经对账,对账人:").append(map.get("customerName"));
		StringBuffer seedsids=new StringBuffer();
		Date date=DateTimeUtils.strToDateTime(getNow());
		String filename=date.getTime()+"";
		String datestr=DateTimeUtils.dateTimeToStr(date);
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			if (json.has("no")&&json.getString("no").startsWith("NO")) {
				if (json.getString("no").contains("XSKD")) {//更新订单从表信息
					sql.append("update sdd02021 set qianming='已对账',qianmingTime='").append(datestr).append("' where seeds_id=").append(json.getInt("seeds_id")).append(";");
//					sql.append("update sdd02021 set qianming='").append(map.get("customer_id")).append("',qianmingTime='").append(getNow()).append("' where seeds_id=").append(json.getInt("seeds_id")).append(";");
				}else{
					sql.append("update ARd02051 set qianming='已对账',qianmingTime='").append(datestr).append("' where seeds_id=").append(json.getInt("seeds_id")).append(";");
//					sql.append("update ARd02051 set qianming='").append(map.get("customer_id")).append("',qianmingTime='").append(getNow()).append("' where seeds_id=").append(json.getInt("seeds_id")).append(";");
				}
//				if(json.has("no")){
//					no.append(json.get("no")).append(",");
//				}
				seedsids.append(json.get("seeds_id")).append(",");
			}
		}
		managerDao.insertSql(sql.toString());
		Map<String,Object> map2=new HashMap<String, Object>();
		map2.put("com_id", getComId());
		map2.put("headship", "%出纳%");
		List<Map<String,String>> touserList=employeeDao.getPersonnelNeiQing(map2);
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		String description=no.toString();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", "客户对账单已签字确认通知");
		mapMsg.put("description",description);
		mapMsg.put("picurl ",ConfigFile.urlPrefix+"/"+getComId()+"/qianming/ard/"+ seedsids+".png");
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/report/accountStatement.do?seeds_id="+seedsids );
		news.add(mapMsg);
		for (int i = 0; i < touserList.size(); i++) {
			Map<String, String> item=touserList.get(i);
			news.get(0).put("description",getComName()+"出纳"+item.get("clerk_name")+description);
			sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
			news.get(0).put("description",description);
		}
		return filename;
	}
	@Override
	@Transactional
	public void updateLoginTime(Map<String, Object> map) {
		map.put("loginTime", new Date());
		customerDao.updateLoginTime(map);
	}
	@Override
	public Map<String, Object> getCustomerInfoByOpenid(String com_id,
			Object openid,String type) {
		Map<String, Object> map=new HashMap<>();
		map.put("com_id", com_id);
		if("企业号".equals(type)){
			map.put("weixinID", openid);
		}else{
			map.put("openid", openid);
		}
		return customerDao.getCustomerInfoByOpenid(map);
	}
	@Override
	public void noticeEmployee(Map<String, Object> map) {
		Map<String,Object> mapsms=getSystemParamsByComId();
		if (isMapKeyNull(mapsms, "loginNoticeHeadship")) {
			return;
		}
		String description="@comName@Eheadship@clerkName:有客户【"+map.get("clerk_name")+"】登录系统，请注意跟进。客户登录时间:"+getNow();
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title","客户登录跟进");
		mapMsg.put("description",description);
//		mapMsg.put("addName","description");
//		mapMsg.put("description","登录时间:"+getNow()+",登录账号:"+map.get("user_id")+",请注意服务跟进");
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/manager/client.do?com_id="+getComId()+"|customer_id="+getCustomerId(getRequest()));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
//		String weixinID=getPersonnelWeixinIDByHeadship(ConfigFile.loginNoticeHeadship);
		Map<String,Object> mapparams=new HashMap<String, Object>();
		mapparams.put("com_id", getComId());
		mapparams.put("headship", "%"+mapsms.get("loginNoticeHeadship")+"%");
		mapparams.put("omrtype",  mapsms.get("ordersMessageReceivedType"));
		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
		for (int i = 0; i < touserList.size(); i++) {
			Map<String, String> item=touserList.get(i);
			String ds=news.get(0).get("description").toString();
			String newds=ds.replaceAll("@comName", getComName()).
					replaceAll("@Eheadship",mapsms.get("loginNoticeHeadship")+"").
					replaceAll("@clerkName", item.get("clerk_name"));
			news.get(0).put("description",newds);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
			}
			news.get(0).put("description",ds);
		}
	}
	
	@Override
	public String getOrderPayState(Map<String, Object> map) {
		return customerDao.getOrderPayState(map);
	}
	
	@Override
	public Map<String,Object> getComIdByAddress(Map<String, Object> map) {
		Map<String,Object> mapcom=customerDao.getComIdByAddress(map);
		if(mapcom!=null){
			return mapcom;
		}else{
			map.put("address", null);
			return customerDao.getComIdByAddress(map);
		}
	}
	
	@Override
	@Transactional
	public void updatOrderCustomerId(Map<String, Object> map) {
		customerDao.updatOrderCustomerId(map);
	}
	
	@Override
	public Map<String, Object> getMembersInfo(Map<String, Object> map) {
		//获取发送者的名称
		Object touserid=map.get("touser");
		Object sendRenid=map.get("sendRen");
		map.remove("sendRen");
		map.put("rid", touserid);
		String touser=customerDao.getMembersInfo(map);
		//获取接收者的名称
		String sendRen="001";
		if(!"001".equals(sendRenid)){
			map.remove("touser");
			map.put("rid", sendRenid);
			sendRen=customerDao.getMembersInfo(map);
		}
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("touser", touser);
		mapparam.put("sendRen", sendRen);
		return mapparam;
	}
	//更新客户收货地址
	@Override
	@Transactional
	public void updateFhdz(JSONObject json) {
		 customerDao.updateFhdz(json);
	}
	@Override
	public void noticeDrive(Map<String, Object> map){
		///更新订单状态和司机信息
		customerDao.updateClientOrderDriveInfo(map);
		///发送通知消息
		String description=map.get("description").toString().replaceAll("@coustomerName", map.get("clerk_name")+"");
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", map.get("title"));
		mapMsg.put("description",description);
		mapMsg.put("picurl",ConfigFile.urlPrefix+"/weixinimg/driveShou.png");
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/waybill.do?seeds_id="+map.get("seeds"));
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		if (!isMapKeyNull(map, "weixinID")) {
			sendMessageNews(news,getComId(), map.get("weixinID").toString(),"司机");
		}
		String qrUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/driverWaybillDetail.do?seeds_id="+map.get("seeds");
		//生成二维码
		QRCodeUtil.generateQRCode(qrUrl, getRealPath(getRequest())+"/001/qrcode/"+map.get("seeds")+".jpg",getRealPath(getRequest())+"pc/image/logo.png");
		Map<String,Object> mapsms=getSystemParamsByComId();
		SendSmsUtil.sendSms2(getMapKey(map, "user_id"), null,map.get("title")+":"+description,mapsms);
		saveOrderHistory(map.get("seeds"), map.get("clerk_name")+"客户通知司机"+map.get("corp_sim_name")+"拉货");
	}
	@Override
	public PageList<Map<String, Object>> findSupplier(SupplierQuery query) {
		int count = customerDao.getSupplierCount(query);
		PageList<Map<String, Object>> pages = getPageList(query, count);
		List<Map<String, Object>> rows = null;
		try {
			rows = customerDao.findSupplier(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		pages.setRows(rows);
		return pages;
	}
	@Override
	@Transactional
	public void savePayProcurement(Map<String, Object> map, Map<String, Object> maporder) throws Exception {
		map.remove("ddje");
		map.remove("customerName");
		map.remove("fuddje");
		map.remove("paystyletxt");
		map.remove("FHDZ");
		map.remove("spNo");
		map.remove("spyj");
		map.remove("ivt_oper_listing");
		map.remove("orderlist[]");
		customerDao.insertSql(getInsertSql("ARd02051", map));
	}
	@Override
	@Transactional
	public void postdzdMemo(Map<String, Object> map) {
		StringBuffer sql=new StringBuffer();
		if (map.get("sd_order_id").toString().contains("XSKD")) {
			sql.append("update sdd02021 set beizhu='").append(map.get("c_memo")).append("' where seeds_id=").append(map.get("seeds_id")).append(";");
		}else{
			sql.append("update ARd02051 set c_memo='").append(map.get("c_memo")).append("' where seeds_id=").append(map.get("seeds_id")).append(";");
		}
		customerDao.insertSql(sql.toString());
	}

	@Override
	public Map<String, Object> getCustomerWeixinID(Map<String, Object> map) {
		return customerDao.getCustomerWeixinID(map);
	}

	@Override
	@Transactional
	public String updateOrderStatus(Map<String, Object> map) {
		customerDao.updateOrderStatus(map);
		return null;
	}
	@Override
	@Transactional
	public String updateOrderSdOq(Map<String, Object> map) {
		Integer i=customerDao.updateOrderSdOq(map);
		return i+"";
	}
	/**
	 * 获取带计划数的产品分页列表
	 */
	@Override
	public PageList<Map<String, Object>> getPlanProductPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=customerDao.getPlanProductPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> list=customerDao.getPlanProductPage(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public PageList<Map<String, Object>> collectionConfirmList(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=customerDao.collectionConfirmListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> list=customerDao.collectionConfirmList(map);
		pages.setRows(list);
		return pages;
	}
	
	/**
	 * 获取带有昨日计划数和零售价的产品详细
	 */
	@Override
	public Map<String, Object> getPlanProductInfo(Map<String, Object> map) {
		return customerDao.getPlanProductInfo(map);
	}
	
	@Override
	public Map<String, Object> getSimpleOrderPayInfo(Map<String, Object> map) {
		List<String> list=customerDao.getSimpleOrderPayInfoOrderNo(map);
		Map<String, Object> info=customerDao.getSimpleOrderPayInfo(map);
		String orderNo="";
		for (String no : list) {
			orderNo=orderNo+","+no;
		}
		if(StringUtils.isNotBlank(orderNo)){
			info.put("ivt_oper_listing", orderNo.substring(1, orderNo.length()));
		}
		return info;
	}
	
	@Override
	public List<String> getPayOrderProductName(
			Map<String, Object> map) {
		 
		return customerDao.getPayOrderProductName(map);
	}
	@Override
	public List<Integer> getPayOrderSeeds_id(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return customerDao.getPayOrderSeeds_id(map);
	}
	@Override
	public Map<String, Object> getCustomerInfoByWeixinID(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return customerDao.getCustomerInfoByWeixinID(map);
	}
	@Override
	@Transactional
	public String updateFHDZToOrder(Map<String, Object> map) {
		return customerDao.updateFHDZToOrder(map)+"";
	}
	
	@Override
	@Transactional
	public String delPayInfo(Map<String, Object> map) {
		// TODO 删除付款记录
		//1.查询该付款记录是否已经确认
		String comfirm_flag=customerDao.getPayInfoFlag(map);
		if ("N".equals(comfirm_flag)) {
			//1.2未确认删除 
			String sSql="delete from ARd02051 where ltrim(rtrim(isnull(com_id,'')))=#{com_id} and ltrim(rtrim(isnull(recieved_id,''))) =#{no}";
			map.put("sSql", sSql);
			productDao.insertSqlByPre(map);
			return null;
		}else{
			//1.1确认直接返回
			return "已收款确认,不能进行删除!";
		}
	}
	@Override
	@Transactional
	public String saveEditPayInfo(Map<String, Object> map) {
		//1.查询该付款记录是否已经确认
		String comfirm_flag=customerDao.getPayInfoFlag(map);
		if ("N".equals(comfirm_flag)) {
			//1.2未确认更新
			map.put("sSql", getUpdateSql(map, "ARd02051", "recieved_id", map.get("recieved_id")+""));
			productDao.insertSqlByPre(map);
			return null;
		}else{
			//1.1确认直接返回
			return "已收款确认,不能进行删除!";
		}
	}

	@Override
	public Map<String, String> getSalesInfo(Map<String, Object> map) {
		List<Map<String, Object>> news=new ArrayList<>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", map.get("title"));
		String description=map.get("description").toString().replaceAll("@comName", getComName());
		description=description.replaceAll("@customerName", getCustomer(getRequest()).get("clerk_name")+"");
		mapMsg.put("description",description); 
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/addFileList.do?customer_id="+map.get("customer_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getCustomerId(getRequest()));
		if (isNotMapKeyNull(map, "upper_customer_id")) {
			mapMsg.put("upper_customer_id",map.get("upper_customer_id"));
		}
		news.add(mapMsg);
		Map<String,String> info=employeeDao.getSalespersonInfo(map);
		if(info==null){
		  List<Map<String,String>> list=employeeDao.getPersonnelNeiQing(map);
		  for (Map<String, String> map2 : list) {
			  String msg=description.replaceAll("@Eheadship",map2.get("headship")).replaceAll("@clerkName", info.get("clerk_name"));
			  mapMsg.put("description",msg); 
			  sendMessageNews(news, info.get("weixinID"));
		}
		}else{
			String msg=description.replaceAll("@Eheadship","业务员").replaceAll("@clerkName", info.get("clerk_name"));
			mapMsg.put("description",msg); 
			sendMessageNews(news, info.get("weixinID"));
		}
		
		return null;
	}
}
