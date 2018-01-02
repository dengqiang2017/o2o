package com.qianying.service.impl;

import java.io.File;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.ISaiYuDao;
import com.qianying.page.PageList;
import com.qianying.service.IManagerService;
import com.qianying.service.ISaiYuService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;

@Service
@Scope("prototype")
public class SaiYuServiceImpl extends BaseServiceImpl implements ISaiYuService {

	@Autowired
	private ISaiYuDao saiYuDao;
	
	@Autowired
	private IManagerService managerService;

	@Override
	public List<Map<String, Object>> getPosition(Map<String, Object> map) {
		return saiYuDao.getPositionList(map);
	}	
	
	@Override
	@Transactional
	public String saveRepair(Map<String, Object> map)throws Exception{
		//3.保存维修记录从表
		//3.1获取维修记录编号
		String no="NO."+DateTimeUtils.getNowDateTimeS();
//		String no = getSortId("SDd02010_saiyu","TJ",managerService);
//		if(StringUtils.isBlank(no)){
//			no="NO."+DateTimeUtils.getNowDateTimeS();
//		}
		if (getCustomerId(getRequest())==null) {
			throw new RuntimeException("登录超时,请重新登录!");
		}
		JSONArray array=JSONArray.fromObject(map.get("items"));
		StringBuffer position_big=new StringBuffer();
		for (int i = 0; i < array.size(); i++) {
			//1.根据位置和类型判断体检表中是否存在
			//2.存在就取出编号
			JSONObject json= array.getJSONObject(i);
			Map<String,Object> mapdetail=new HashMap<String, Object>();
			mapdetail.put("ivt_oper_listing", no);
			json.put("bx_oper_listing", no);
			mapdetail.put("sd_order_id", no);
			mapdetail.put("com_id", map.get("com_id"));
			if (json.get("bx_customer_id")==null) {
				mapdetail.put("bx_customer_id", getCustomerId(getRequest()));
			}
			position_big.append(json.getString("position")).
			append(json.getString("position_big"));//.append(",").append(json.getString("item_name"))
//			.append(",损坏数量:").append(json.getString("num")).append("&");
//			mapdetail.put("position_big", json.get("position_big"));
//			mapdetail.put("position", json.get("position"));
			if (json.has("date")) {
				mapdetail.put("repair_datetime", json.get("date"));
			}else{
				mapdetail.put("repair_datetime", getNow());
			}
			mapdetail.put("sd_oq", json.get("num"));
			mapdetail.put("tj_oper_listing", getTijianNO(json));//获取体检数据库表 
			mapdetail.put("customer_id", getUpperCustomerId(getRequest()));
			mapdetail.put("c_memo", map.get("c_memo"));
			mapdetail.put("mainten_clerk_id", getCustomerId(getRequest()));
			mapdetail.put("mainten_datetime", getNow());
			productDao.insertSql(getInsertSql("SDd02021_saiyu", mapdetail));
		}
		//4.保存维修记录主表
		Map<String,Object> mapmain=new HashMap<String, Object>();
		mapmain.put("ivt_oper_listing", no);
		mapmain.put("com_id", map.get("com_id"));
		mapmain.put("sd_order_id", no);
		mapmain.put("customer_id", getUpperCustomerId(getRequest()));
		mapmain.put("repair_datetime", getNow());
		mapmain.put("c_memo", map.get("c_memo"));
		mapmain.put("mainten_clerk_id", getCustomerId(getRequest()));
		mapmain.put("mainten_datetime", getNow());
		productDao.insertSql(getInsertSql("SDd02020_saiyu", mapmain));
		///////////////////
		//保存审批记录 
		//获取客户审批流id
		map.put("approval_step", 1);
		map.put("upper_customer_id", getUpperCustomerId(getRequest()));
		Map<String,Object> process=saiYuDao.getApprovalProcess(map);
		if (process==null) {
			throw new RuntimeException("没有找到该类型的相关审批流程,请联系管理员创建该类型的审批流程!");
		}else{
			///
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss",
					Locale.CHINA);
			Integer opidn = getApprovalNo(format.format(new Date()));
			String sd_order_id = "SPNR" + format.format(new Date())
					+ String.format("%03d", opidn);
			Map<String,Object> mapOA=new HashMap<String, Object>();
			mapOA.put("com_id", map.get("com_id"));
			mapOA.put("item_id", process.get("item_id"));
			Object OA_whom=null;
			if(!isMapKeyNull(process, "headship")){
				OA_whom=process.get("headship");
			}else if(!isMapKeyNull(process, "customer_id")){
				OA_whom=process.get("customer_id");
			}else{
				OA_whom=process.get("clerk_id");
			}
			mapOA.put("OA_whom", OA_whom);
			mapOA.put("noticeResult", process.get("noticeResult"));
			mapOA.put("OA_who", getCustomerId(getRequest()));
			mapOA.put("headship", process.get("headship"));
					
			mapOA.put("upper_customer_id",getUpperCustomerId(getRequest()));
			mapOA.put("sd_order_id", sd_order_id);
			mapOA.put("ivt_oper_listing", sd_order_id);
			mapOA.put("mainten_clerk_id", getCustomerId(getRequest()));
			mapOA.put("maintenance_datetime", getNow());
			mapOA.put("store_date", getNow());
			mapOA.put("approval_step", map.get("approval_step"));
			String description=position_big.append("|单号:").append(no).toString();
			mapOA.put("content", description);
			mapOA.put("OA_what", description);
			employeeDao.insertSql(getInsertSql("OA_ctl03001_approval", mapOA));
			//报修确认第二步
			if(OA_whom.toString().contains("C")){
				Object weixinID= process.get("weixinID");
				map.put("weixinID", weixinID);
			}else{
				Map<String,String> mapempl=employeeDao.getPersonnelWeixinID(OA_whom.toString(), getComId());
				map.put("weixinID", mapempl.get("weixinID"));
				sendOAMessageNews(OA_whom, "报修采购申请", description);
				return sd_order_id;
			}
			sendApprovalOA(map,sd_order_id,description);
			return sd_order_id;
		}
}
	@Override
	public String postRepair(Map<String, Object> map) throws Exception {
		map.put("approval_step", 1);
		map.put("upper_customer_id", getUpperCustomerId(getRequest()));
		Map<String,Object> process=saiYuDao.getApprovalProcess(map);
		if (process==null) {
			throw new RuntimeException("没有找到该类型的相关审批流程,请联系管理员创建该类型的审批流程!");
		}else{
			///
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss",
					Locale.CHINA);
			Integer opidn = getApprovalNo(format.format(new Date()));
			String sd_order_id = "SPNR" + format.format(new Date())
					+ String.format("%03d", opidn);
			Map<String,Object> mapOA=new HashMap<String, Object>();
			mapOA.put("com_id", map.get("com_id"));
			mapOA.put("item_id", process.get("item_id"));
			mapOA.put("OA_whom", process.get("customer_id"));
			mapOA.put("noticeResult", process.get("noticeResult"));
			mapOA.put("OA_who", getCustomerId(getRequest()));
			
			mapOA.put("customer_id", getCustomerId(getRequest()));
			mapOA.put("headship", getCustomer(getRequest()).get("headship"));
			
			mapOA.put("upper_customer_id",getUpperCustomerId(getRequest()));
			mapOA.put("sd_order_id", sd_order_id);
			mapOA.put("ivt_oper_listing", sd_order_id);
			mapOA.put("mainten_clerk_id", getCustomerId(getRequest()));
			mapOA.put("maintenance_datetime", getNow());
			mapOA.put("store_date", getNow());
			mapOA.put("approval_step", 2);
			String description=map.get("position_big")+"|"+map.get("position")+"|"+DateTimeUtils.dateToStr()+"|"+sd_order_id;
			mapOA.put("content",description );
			mapOA.put("OA_what", description);
			employeeDao.insertSql(getInsertSql("OA_ctl03001_approval", mapOA));
			//报修确认第二步
			return sd_order_id;
		}
	}
	
	/**
	 * 发送审批协同OA记录
	 * @param request
	 * @param map
	 * @param step 审批步骤
	 * @param url 跳转地址
	 * @param params
	 */
	private String sendApprovalOA(Map<String,Object> map,String params,String description) {
		//1.获取客户审批第一步人员微信id
//		Map<String,Object> mapparam=new HashMap<String, Object>();
//		mapparam.put("com_id", getComId());
//		mapparam.put("upper_customer_id", getUpperCustomerId(getRequest()));
//		mapparam.put("approval_step",map.get("approval_step"));
//		Map<String,String> personInfo= getApprovalPerson(mapparam);
//		if (personInfo==null) {
//			return "没有找到该流程步骤对应的信息";
//		}
		//2.获取组合标题title 否 标题description 否 描述url 否 点击后跳转的链接。
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title","您有一条报修采购申请需要协同!");
		newmap.put("description",description);
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?baoxiu|ivt_oper_listing="+params);
		news.add(newmap);
		sendMessageNews(news, map.get("weixinID").toString());
		return null;
	}
	/**
	 * 获取体检数据表编码  不存在就保存,存在就更新
	 * @param json
	 * @return
	 */
	private String getTijianNO(JSONObject json) {
		json.put("customer_id", getUpperCustomerId(getRequest()));
		json.put("com_id", getComId());
		String ivt_oper_listing=saiYuDao.getTijianInfo(json);
		if (StringUtils.isBlank(ivt_oper_listing)) {
			Integer  seedsId=saiYuDao.getMaxSeeds_id();
			ivt_oper_listing=String.format("TJ%06d", seedsId+1);
			Map<String,Object> maptj=new HashMap<String, Object>();
			maptj.put("com_id",getComId());
			maptj.put("ivt_oper_listing", ivt_oper_listing);
			maptj.put("sd_order_id", ivt_oper_listing);
			maptj.put("customer_id", getUpperCustomerId(getRequest()));
			maptj.put("position_big", json.get("position_big"));
			maptj.put("position", json.get("position"));
			maptj.put("item_name", json.get("item_name"));
			maptj.put("mainten_clerk_id",getCustomerId(getRequest()));
			maptj.put("mainten_datetime", getNow());
			maptj.put("bx_oper_listing",json.get("bx_oper_listing"));
			maptj.put("work_state", "报修中");
			if (json.has("num")) {
				maptj.put("damage_num_g",json.get("num"));
			}
			//2.2不存在就存储,然后获取编号
			productDao.insertSql(getInsertSql("SDd02010_saiyu", maptj));
		}else{
			//更新体检表数据状态
			Map<String,Object> maptijian=new HashMap<String, Object>();
			maptijian.put("ivt_oper_listing", ivt_oper_listing);
			if (json.has("num")) {
				maptijian.put("damage_num_g",json.get("num"));
			}
			if (json.has("damage_num_g")) {
				maptijian.put("damage_num_g",json.get("damage_num_g"));
			}
			maptijian.put("bx_oper_listing",json.get("bx_oper_listing"));
			maptijian.put("work_state", "报修中");
			maptijian.put("com_id", getComId());
			productDao.insertSql(getUpdateSql(maptijian, "SDd02010_saiyu", "ivt_oper_listing", ivt_oper_listing, true));
		}
		return ivt_oper_listing;
	}
	
	@Override
	public Map<String, String> getApprovalPerson(Map<String, Object> mapparam) {
		 List<Map<String,String>> list= saiYuDao.getApprovalPerson(mapparam);
		Map<String,Object> mapcus= customerDao.getCustomerByCustomer_id(mapparam.get("upper_customer_id")+"", getComId());
		 if (list!=null&&list.size()>0) {
			 Map<String,String> map=new HashMap<String, String>();
			 if (mapcus.get("addr1")!=null) {
				 map.put("addr1", mapcus.get("addr1")+"");
			}
			 if (list.size()>1) {
				 StringBuffer phone=new StringBuffer();
				 StringBuffer weixinID=new StringBuffer();
				 StringBuffer corp_sim_name=new StringBuffer();
				 for (int i = 0; i < list.size(); i++) {
					 Map<String, String> mapphone=list.get(i);
					if (i==(list.size()-1)) {
						phone.append(mapphone.get("phone"));
						weixinID.append(mapphone.get("weixinID"));
						corp_sim_name.append(mapphone.get("corp_sim_name"));
					}else{
						phone.append(mapphone.get("phone")).append("|");
						weixinID.append(mapphone.get("weixinID")).append("|");
						corp_sim_name.append(mapphone.get("corp_sim_name")).append("|");
					}
				}
				 map.put("phone", phone.toString());
				 map.put("weixinID", weixinID.toString());
				 map.put("corp_sim_name", corp_sim_name.toString());
				 return map;
			 }else{
				 map.putAll(list.get(0));
				 return map;
			 }
		}
		 return null;
	}
	@Override
	public PageList<Map<String, Object>> getRepairHistory(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=saiYuDao.getRepairHistoryCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(saiYuDao.getRepairHistoryList(map));
		return pages;
	}

	@Override
	public Map<String, Object> getPurchaseApproval(Map<String, Object> map) {
		 
		return saiYuDao.getPurchaseApproval(map);
	}
  
	@Override
	public List<Map<String, Object>> getSuggest(Map<String, Object> map) {
		return saiYuDao.getSuggest(map);
	}
	/**
	 * 
	 * @param map2
	 * @param key
	 * @param keyext
	 * @return
	 */
	private Map<String,Object> getOrderDataToTijian(Map<String,Object> map2,String key,String keyext){
		if(!isMapKeyNull(map2, "item_id"+key+keyext)){
//			if(!isMapKeyNull(map2, "sd_oq"+key+keyext)
//					&&!isMapKeyNull(map2, "sd_unit_price"+key+keyext)
//					&&!isMapKeyNull(map2, "item_id"+key+keyext)){
			Map<String,Object> item=new HashMap<String, Object>();
			item.put("item_id",map2.get("item_id"+key+keyext));
			if(isMapKeyNull(map2, "sd_unit_price"+key+keyext)){
				item.put("sd_unit_price", "0");
			}else{
				item.put("sd_unit_price", map2.get("sd_unit_price"+key+keyext));
			}
			if(isMapKeyNull(map2, "sd_oq"+key+keyext)){
				item.put("num", 0);
			}else{
				item.put("num", map2.get("sd_oq"+key+keyext));
			}
			
			BigDecimal sd_unit_price=new BigDecimal(item.get("sd_unit_price").toString());
			BigDecimal num=new BigDecimal(item.get("num").toString());
			if(num.compareTo(BigDecimal.ZERO)>0&&sd_unit_price.compareTo(BigDecimal.ZERO)>0){
				return item;
			}else{
				return null;
			}
		}else{
			return null;
		}
	}
	/**
	 * 
	 * @param map2
	 * @param orderList
	 * @param key
	 * @param keyext
	 */
	private void getOrderDataToTijian(Map<String, Object> map2, List<Map<String,Object>> orderList,String key,String keyext) {
		if(getOrderDataToTijian(map2,key,keyext)!=null){
			orderList.add(getOrderDataToTijian(map2,key,keyext));
		}
	}
	/**
	 * 
	 * @param map2
	 * @return
	 */
	private List<Map<String,Object>> getOrderDataToTijian(Map<String, Object> map2) {
		List<Map<String,Object>> orderList=new ArrayList<Map<String,Object>>();
		getOrderDataToTijian(map2, orderList,"_g_g", "j1");
		getOrderDataToTijian(map2, orderList,"_g_g", "j2");
		getOrderDataToTijian(map2, orderList,"_g_g", "n1");
		getOrderDataToTijian(map2, orderList,"_g_g", "n2");
		getOrderDataToTijian(map2, orderList,"_g_g", "n3");
		getOrderDataToTijian(map2, orderList,"_d_g", "j1");
		getOrderDataToTijian(map2, orderList,"_d_g", "j2");
		getOrderDataToTijian(map2, orderList,"_d_g", "n1");
		getOrderDataToTijian(map2, orderList,"_d_g", "n2");
		getOrderDataToTijian(map2, orderList,"_d_g", "n3");
		 return orderList;
	}
	@Override
	public String savePurchaseOrder(Map<String, Object> map, String[] list)
			throws Exception {
		String ivts=Arrays.toString(list);
		if(list.length>0){
			ivts=ivts.replaceAll("\\[", "").replaceAll("\\]", "");
		}
		map.put("ivts", list);
		 List<Map<String,Object>> productList= saiYuDao.getProductOrder(map);
		 List<Map<String,Object>> orderList=new ArrayList<Map<String,Object>>();
		 for (Map<String, Object> map2 : productList) {
			 orderList.addAll(getOrderDataToTijian(map2));
			 updateWeixiuState(map2.get("bx_oper_listing").toString(), "审批中");
			if (!isMapKeyNull(map2, "bx_oper_listing")) {
				map.put("ivt_oper_listing", map2.get("bx_oper_listing"));
			}
		}
//		 if(orderList.size()<=0){
//			 
//		 }
		JSONArray jsons=JSONArray.fromObject(orderList); 
		return savePurchaseApproval(jsons, map);
	}
	
	@Override
	public String savePurchaseApproval(JSONArray jsons,Map<String,Object> map) throws Exception {
		// 第四步保存采购下订单数据
		//2.保存审批采购订单产品
		//2.1从产品中获取到产品的相关数据
		String comId=getComId();
		String customer_id=getUpperCustomerId(getRequest());
		String no = getOrderNo(customerDao, "销售开单", comId);
		 String ivt_oper_listing=map.get("ivt_oper_listing").toString();
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		if(jsons.size()==0){
			throw new RuntimeException("没有找到具体的产品");
		}
		BigDecimal sum_si=new BigDecimal("0");
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject item=jsons.getJSONObject(i);
			Map<String, Object> mapDetail = getOrderDetail(comId, item, customer_id);
			mapDetail.put("com_id",comId);
			mapDetail.put("ivt_oper_listing", no);
			mapDetail.put("sd_order_id", no);
			
			mapDetail.put("ivt_oper_bill", ivt_oper_listing);
			mapDetail.put("Status_OutStore", "待支付");
			sum_si=sum_si.add(new BigDecimal(mapDetail.get("sum_si").toString()));
			if (getEmployee(getRequest())!=null) {
				mapDetail.put("Status_OutStore", getProcessName(getRequest(), 0));
			}
			mapDetail.put("customer_id", customer_id);
			mapDetail.put("clerk_id_sid", getCustomerId(getRequest()));
			getJsonVal(mapDetail, item, "sd_unit_price", "sd_unit_price");
			getJsonVal(mapDetail, item, "sd_oq", "sd_oq");
			productDao.insertSql(getInsertSql("SDd02021", mapDetail));
		}
		Map<String, Object> mapcus = customerDao.getCustomerByCustomer_id(
				getCustomerId(getRequest()), comId);
		// 1.2组合主表数据
		Map<String, Object> mainmap = new HashMap<String, Object>();
		mainmap.put("com_id",comId);
		mainmap.put("sd_order_direct", "发货");
		mainmap.put("ivt_oper_bill", "发货");
		mainmap.put("ivt_oper_listing", no);
		mainmap.put("dept_id", mapcus.get("dept_id"));
		mainmap.put("sd_order_id", no);
		mainmap.put("comfirm_flag", "N");
		mainmap.put("customer_id", customer_id);
		mainmap.put("regionalism_id", mapcus.get("regionalism_id"));
		mainmap.put("dept_id", mapcus.get("dept_id"));
		mainmap.put("so_consign_date", nowdate);
		mainmap.put("at_term_datetime", nowdate);
		Calendar c = Calendar.getInstance();
		mainmap.put("finacial_y", c.get(Calendar.YEAR));
		mainmap.put("finacial_m", c.get(Calendar.MONTH));
		mainmap.put("all_oq", jsons.size());
		mainmap.put("mainten_clerk_id", getCustomerId(getRequest()));
		mainmap.put("mainten_datetime", nowdate);
		mainmap.put("settlement_type_id","JS001JS004");
		mainmap.put("transport_AgentClerk_Reciever", mapcus.get("delivery_Add"));
		mainmap.put("HJJS", jsons.size());
		productDao.insertSql(getInsertSql("SDd02020", mainmap));
		//3.保存审批并推送微信消息给下一步人员财务审批  订单号加报修单号
		Map<String,String> mapApproval=new HashMap<String, String>();
		mapApproval.put("approval_step","4");
		mapApproval.put("spyj", map.get("spyj")+"");
		mapApproval.put("spNo", map.get("spNo")+"");
		mapApproval.put("ivt_oper_listing", map.get("ivt_oper_listing")+"");
		mapApproval.put("spyijcontent", map.get("spyijcontent")+"");
		mapApproval.put("position", map.get("position")+"");
		if (getNoticeResult(mapApproval)){
		Map<String,String> mapParam=new HashMap<String, String>();
		mapParam.put("ivt_oper_listing", no+"|"+ivt_oper_listing);
		mapParam.put("orderNo", no);
		mapParam.put("bxNo", ivt_oper_listing);
		mapParam.put("approval_step", map.get("approval_step").toString());
		mapParam.put("sum_si", sum_si.toString());
		mapParam.put("url", "financialApproval");
		mapParam.put("OA_what", "采购订单审批,金额"+sum_si.setScale(2, BigDecimal.ROUND_HALF_UP).toString()+"|采购单号:"+no+"");
		mapParam.put("content ", "采购单号:"+no+",报修单号:"+ivt_oper_listing);
		mapParam.put("spNo",getValByMapObj(map, "spNo"));
		mapParam.put("upper_customer_id", getValByMapObj(map, "upper_customer_id"));
		mapParam.put("spyj",getValByMapObj(map, "spyj"));
		mapParam.put("approvaler",getCustomerId(getRequest()));
		return saveAndSendApprovalInfo(mapParam);
		}
		return null;
	}
	private Map<String, Object> getOrderDetail(String com_id, JSONObject item,
			String customer_id) throws Exception {
		JSONObject json = JSONObject.fromObject(item);
		String item_id = json.getString("item_id");
		Map<String, String> mapParam = new HashMap<String, String>();
		String ivt_oper_listing = null;
//		mapParam.put("ivt_oper_listing", ivt_oper_listing);
		mapParam.put("item_id", item_id);
		mapParam.put("com_id", com_id);
		Map<String, Object> mapPro = productDao.getProductByItem_id(mapParam); 
		if (mapPro == null) {
			throw new RuntimeException("没有找到该产品信息!");
		} 
		// /订单明细数据封装
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item_id", item_id);
		map.put("ivt_oper_listing", ivt_oper_listing);
		map.put("sid", mapPro.get("seeds_id"));
		map.put("discount_ornot", mapPro.get("discount_ornot"));
		map.put("sd_unit_price_UP", mapPro.get("sd_unit_price_UP"));
		map.put("sd_unit_price_DOWN", mapPro.get("sd_unit_price_DOWN"));
		map.put("discount_time_begin", mapPro.get("discount_time_begin"));
		map.put("sd_oq", json.getString("num"));
		//计算金额
		getJsonVal(map, json, "sd_unit_price", "sd_unit_price");
		BigDecimal sd_unit_price=new BigDecimal(json.getString("sd_unit_price"));
		BigDecimal num=new BigDecimal(json.getString("num"));
		BigDecimal sum_si=num.multiply(sd_unit_price);
		map.put("sum_si",sum_si);
		
		getJsonVal(map, json, "c_memo", "c_memo");
		map.put("sd_unit_price", sd_unit_price);
		map.put("pack_num", mapPro.get("pack_unit"));
		map.put("pack_unit", mapPro.get("casing_unit"));
		map.put("unit_id", mapPro.get("item_unit"));
		map.put("memo_color", mapPro.get("memo_color"));
		map.put("memo_other", mapPro.get("memo_other"));
		map.put("discount_time", mapPro.get("discount_time"));
		map.put("item_id", mapPro.get("item_id"));
		map.put("peijian_id", mapPro.get("peijian_id"));
		map.put("ivt_oper_bill", mapPro.get("ivt_oper_listing"));
		map.put("unit_id", mapPro.get("unit_id"));
		map.put("price_prefer", mapPro.get("price_prefer"));// 现金折扣
		map.put("price_otherDiscount", mapPro.get("price_otherDiscount"));

		map.put("discount_rate", mapPro.get("discount_rate"));
		map.put("tax_rate", mapPro.get("tax_rate"));
		map.put("tax_sum_si", mapPro.get("tax_sum_si"));
		return map;
	}
	
	@Override
	public void saveApprovalInfo(Map<String, String> map) throws Exception {
		// 第五...N步 财务,经理等审批 
		if (getNoticeResult(map)){
			Map<String,String> mapParam=new HashMap<String, String>();
			mapParam.put("ivt_oper_listing", map.get("ivt_oper_listing"));
			mapParam.put("approval_step", map.get("approval_step"));
			mapParam.put("url", map.get("url"));
//			mapParam.put("OA_what", "采购订单审批,金额"+sum_si.setScale(2, BigDecimal.ROUND_HALF_UP).toString());
//			mapParam.put("content ", "采购单号:["+no+"],报修单号:["+ivt_oper_listing+"]");
			mapParam.put("spNo",getValByMap(map, "spNo"));
			mapParam.put("upper_customer_id",getUpperCustomerId(getRequest()));
			mapParam.put("spyj",getValByMap(map, "spyj"));
			mapParam.put("approvaler",getCustomerId(getRequest()));
			saveAndSendApprovalInfo(mapParam);
		}
	}
 
	private boolean getNoticeResult(Map<String,String> map) {
		String approval_step=map.get("approval_step");
		String spyij=map.get("spyj");
		String ivt_oper_listing=map.get("ivt_oper_listing");
		String spNo=map.get("spNo");
		String spyijcontent=map.get("spyijcontent");
		String position=map.get("position");
		///获取推送结果消息的人员微信ID
		if (!"同意".equals(spyij)){
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("com_id", getComId());
		mapparam.put("upper_customer_id", getUpperCustomerId(getRequest()));
		if (ConfigFile.NoticeResultAll) {
			mapparam.put("approvalStep",approval_step);
		}
		mapparam.put("noticeResult", "是");
		///////////////////////////////
		//发送审批协同消息
		//1.获取客户审批第一步人员微信id 
		/////获取消息接受处理人员
		Map<String,String> spiinfo=getApprovalPerson(mapparam);
		if (spiinfo.get("weixinID")==null) {//没有找到要推送结果的人
			return false;
		}
		//2.获取组合标题title 否 标题description 否 描述url 否 点击后跳转的链接。
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title","您有一条报修申请审批没有通过!");
		if (StringUtils.isNotBlank(ivt_oper_listing)) {
			newmap.put("description","报修单号:"+ivt_oper_listing);
		}else{
			newmap.put("description", "报修位置:"+position);
		}
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/repairHistory.do?"+ivt_oper_listing);
		news.add(newmap);
		///////////////////////
		Map<String,Object> mapupdate=new HashMap<String, Object>();
		mapupdate.put("approval_YesOrNo", spyij);//审批意见是否同意
		mapupdate.put("approvaler",getCustomerId(getRequest()));
		mapupdate.put("approval_suggestion",spyijcontent);
		mapupdate.put("maintenance_datetime",getNow());
		mapupdate.put("mainten_clerk_id",getCustomerId(getRequest()));
		productDao.insertSql(getUpdateSql(mapupdate, "OA_ctl03001_approval", "ivt_oper_listing", spNo, true));
		////////////////////////
		sendMessageNews(news, spiinfo.get("weixinID"));
		return false;
		}
		return true;
	}
	
	@Override
	public List<Map<String, Object>> getItemBrand(Map<String, Object> map) {
		
		return saiYuDao.getItemBrand(map);
	}
	
	@Override
	public Map<String, Object> getRepairInfo(Map<String, Object> map) {
		return saiYuDao.getRepairInfo(map);
	}
	@Override
	public List<Map<String, String>> getProductOneFiledlist(Map<String, Object> map) {
		return saiYuDao.getProductOneFiledlist(map);
	}
	
	@Override
	public void saveSuggest(JSONArray jsons,Map<String,Object> map) {
		//1.存储数据到采购推荐表中  员工操作后台
		// 第三步赛宇根据报修消息,推荐客户购买产品类型和数量
		String ivt_oper_listing=map.get("bxNo").toString();//报修单号
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json= jsons.getJSONObject(i);
			Map<String,Object> mapitem=new HashMap<String, Object>();
			mapitem.put("com_id", getComId());
			mapitem.put("ivt_oper_listing", ivt_oper_listing);//报修单号
			mapitem.put("customer_id", map.get("upper_customer_id"));
			getJsonVal(mapitem, json, "item_id", "item_id");
			getJsonVal(mapitem, json, "num", "num");
			getJsonVal(mapitem, json, "c_memo", "c_memo");
			getJsonVal(mapitem, json, "sd_unit_price", "sd_unit_price");
			mapitem.put("mainten_clerk_id", getEmployeeId(getRequest()));
			mapitem.put("mainten_datetime", getNow());
			productDao.insertSql(getInsertSql("SDd02012_saiyu", mapitem));
		}
		Map<String,String> mapParam=new HashMap<String, String>();
		mapParam.put("ivt_oper_listing", ivt_oper_listing);
		mapParam.put("approval_step","2");
		mapParam.put("url", "purchaseApproval");
		mapParam.put("spNo",getValByMapObj(map, "spNo"));
		mapParam.put("spyj",getValByMapObj(map, "spyj"));
		mapParam.put("approvaler",getEmployeeId(getRequest()));
		mapParam.put("upper_customer_id", getValByMapObj(map, "upper_customer_id"));
		saveAndSendApprovalInfo(mapParam);
	}
	@Override
	public String quxiaoProduct(Map<String, Object> map) {
		String item_id=map.get("item_id").toString();
		String ivt_oper_listing=map.get("ivt_oper_listing").toString();
		String item_id_name=map.get("item_id_name").toString();
		///sd_unit_price,item_name,sd_oq,use_oq
		String item_name=item_id_name.replace("item_id", "item_name");
		String sd_unit_price=item_id_name.replace("item_id", "sd_unit_price");
		String sd_oq=item_id_name.replace("item_id", "sd_oq");
		String use_oq=item_id_name.replace("item_id", "use_oq");
		
		Map<String,Object> maptijian=new HashMap<String, Object>();
		maptijian.put("com_id", getComId());
		maptijian.put("item_id", item_id);
		maptijian.put("item_id_name", item_id_name);
		maptijian.put("ivt_oper_listing", ivt_oper_listing);
		maptijian.put("item_name", item_name);
		maptijian.put("sd_unit_price", sd_unit_price);
		maptijian.put("sd_oq", sd_oq);
		maptijian.put("use_oq", use_oq);
		saiYuDao.quxiaoProduct(maptijian);
		return null;
	}

	public String getValByMap(Map<String, String> mapParam,String key) {
		if (mapParam.get(key)!=null) {
			return mapParam.get(key);
		}else{
			return null;
		}
	}
	/**
	 * 
	 * @param ivt_oper_listing 订单号+|+审批编号
	 * @param approval_step 流程步骤
	 * @param url 处理页面url
	 * @param OA_what 协同事情
	 * @param content 协同内容
	 * @param spNo 审批编号
	 * @param upper_customer_id 所属客户编码
	 */
	private String saveAndSendApprovalInfo(Map<String, String> mapParam) {
		////////////////////////////
		String approvalStep=getValByMap(mapParam,"approval_step");
		Integer approval_step=0;
		if (StringUtils.isNotBlank(approvalStep)) {
			approval_step=Integer.parseInt(approvalStep);
		}
//		String url=getValByMap(mapParam,"url");
		String OA_what=getValByMap(mapParam,"OA_what");
		String content=getValByMap(mapParam,"content");
		String spNo=getValByMap(mapParam,"spNo");
		String upper_customer_id=getValByMap(mapParam,"upper_customer_id");
		////////////////////////////////
		mapParam.put("com_id",getComId());
		mapParam.put("ivt_oper_listing", spNo);
		//查看当前步骤是否最后一步
		Integer maxStep=employeeDao.getMaxStep(mapParam);
		///准备更新OA记录数据
		mapParam.put("approval_step_new", (approval_step+1)+"");
		Map<String,Object> mapinfo=employeeDao.getOASpInfo(mapParam);
		mapParam.put("approvaler", getCustomerId(getRequest()));
		Map<String,Object> mapupdate=getApprovalInfo(mapParam);
		if (approval_step==maxStep) {//当前步骤等于最后一步直接到出纳进行订单支付
			if (getEmployee(getRequest())!=null) {
				mapupdate.put("mainten_clerk_id", getEmployeeId(getRequest()));
			}else{
				mapupdate.put("mainten_clerk_id", getCustomerId(getRequest()));
			}
			String orderNo="";
			if(mapParam.get("orderNo")!=null){
				orderNo="?orderNo="+mapParam.get("orderNo");
				mapupdate.put("OA_what", "采购单号:"+mapParam.get("orderNo")+",报修单号:"+mapParam.get("bxNo"));
			}
			employeeDao.updateApproval(mapupdate);
			return "cashierPayment.do"+orderNo;
		}

		mapParam.put("item_id", mapinfo.get("item_id").toString());
		//获取下一个审批的编码
		mapParam.put("approval_step_new",(approval_step+1)+"");
		Map<String,Object> mapnextinfo=saiYuDao.getNextOA_whom(mapParam);
		String OA_whom=null;
		 if (!isMapKeyNull(mapnextinfo, "customer_id")) {
			OA_whom=mapnextinfo.get("customer_id").toString();
		}else if (!isMapKeyNull(mapnextinfo, "headship")) {
			OA_whom=mapnextinfo.get("headship").toString();
		}else{
			OA_whom=mapnextinfo.get("clerk_id").toString();
		}
		Map<String,Object> mapnext=getApprovalInfoNext(mapParam, mapinfo);
		mapnext.put("OA_whom",OA_whom);
		mapnext.put("sum_si",mapParam.get("sum_si"));
		mapnext.put("headship",mapnextinfo.get("headship"));
		mapnext.put("customer_id", mapnextinfo.get("customer_id"));
		Integer step=approval_step+1;
		mapnext.put("approval_step",step);
		if (StringUtils.isNotBlank(OA_what)) {
			mapnext.put("OA_what",OA_what);
		}else{
			OA_what=mapnext.get("OA_what").toString();
		}
		if (StringUtils.isNotBlank(content)) {
			mapnext.put("content",content);
		}else{
			content=mapnext.get("content").toString();
		}
		if (getEmployee(getRequest())!=null) {
			mapnext.put("mainten_clerk_id", getEmployeeId(getRequest()));
		}else{
			mapnext.put("mainten_clerk_id", getCustomerId(getRequest()));
		}
		mapnext.put("upper_customer_id", upper_customer_id);
		mapnext.remove("sum_si");
		employeeDao.insertSql(getInsertSql("OA_ctl03001_approval", mapnext));
		//发送审批协同消息
		/////获取消息接受处理人员
		if (getEmployee(getRequest())!=null) {
			mapupdate.put("mainten_clerk_id", getEmployeeId(getRequest()));
		}else{
			mapupdate.put("mainten_clerk_id", getCustomerId(getRequest()));
		}
		employeeDao.updateApproval(mapupdate);
		//2.获取组合标题title 否 标题description 否 描述url 否 点击后跳转的链接。
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		if (OA_whom.startsWith("C")) {
			Map<String,Object> newmap=new HashMap<String, Object>();
			newmap.put("title","您有一条报修采购申请需要协同,请到【我的协同】中进行处理!");
			newmap.put("description", OA_what.replaceAll("&", "\n"));
			newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?baoxiu");
			newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			news.add(newmap);
		}else{
			sendOAMessageNews(OA_whom, "报修采购申请", OA_what.replaceAll("&", "\n"));
			return "";
		}
//		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/"+url+".do?"+mapnext.get("ivt_oper_listing"));
		///发送维修消息
		//1.获取客户审批第一步人员微信id
//		Map<String,Object> mapparam=new HashMap<String, Object>();
//		mapparam.put("com_id", getComId());
//		mapparam.put("upper_customer_id", upper_customer_id);
//		mapparam.put("approval_step",step);
//		Map<String, Object> spiinfo=null;
		sendMessageNews(news, mapnextinfo.get("weixinID")+"");
//		if (OA_whom.startsWith("C")) {
//			spiinfo=getApprovalPerson(mapparam);
//			spiinfo=customerDao.getCustomerByCustomer_id(OA_whom, getComId());
//		}else{
//			spiinfo=employeeDao.getPersonnelWeixinID(OA_whom, getComId());
//		}
		return "";
	}
	
	@Override
	public List<Map<String, Object>> getOrderList(Map<String, Object> map) {
		// 获取订单详细
		if ("order".equals(map.get("type"))) {
			return saiYuDao.getOrderList(map);
		}else{
			return saiYuDao.getOAhistryList(map);
		}
	}
	///////////////////////////
	@Override
	public PageList<Map<String, Object>> getGysOrderList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=saiYuDao.getGysOrderCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(saiYuDao.getGysOrderList(map));
		return pages;
	}  
	
	////////////////////////////////////////
	@Override
	public String getDriverElectricianWeixinID(String comId,int type) {
		// 获取司机的weixinID
		List<Map<String,String>> list=saiYuDao.getDriverElectricianWeixinID(comId,type);
		if (list!=null&&list.size()>0) {
			 if (list.size()>1) {
				 StringBuffer phone=new StringBuffer();
				 StringBuffer weixinID=new StringBuffer();
				 for (int i = 0; i < list.size(); i++) {
					 Map<String, String> map=list.get(i);
					if (i==(list.size()-1)) {
						phone.append(map.get("phone"));
						weixinID.append(map.get("weixinID"));
					}else{
						phone.append(map.get("phone")).append("|");
						weixinID.append(map.get("weixinID")).append("|");
					}
				}
				 Map<String,String> map=new HashMap<String, String>();
				 map.put("phone", phone.toString());
				 map.put("weixinID", weixinID.toString());
				 return weixinID.toString();
			 }else{
				 return list.get(0).get("weixinID");
			 }
		}
		return null;
	}
	@Override
	public void getDriverElectricianWeixinID(Map<String, Object> map, int type) {
		List<Map<String,String>> list=saiYuDao.getDriverElectricianWeixinID(map.get("com_id").toString(),type);
		for (Map<String, String> map2 : list) {
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> newmap=new HashMap<String, Object>();
			Map<String,Object> mapcus=customerDao.getCustomerByCustomer_id(getUpperCustomerId(getRequest()), getComId());
			newmap.put("title","您有一条来自["+getComName()+"客户-"+mapcus.get("corp_name")+"]安装需求!");
			newmap.put("description","订单编号:"+map.get("orderNo"));
			newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/evalUpAddress.do?param=|ivt_oper_listing="+
					map.get("orderNo")+"|customer_id="+getUpperCustomerId(getRequest())+"|lat="+map.get("lat")+"|lng="+map.get("lat"));
			news.add(newmap);
			sendMessageNews(news, map2.get("weixinID"));
		}
	}
	
	@Override
	public String saveDriverElectrician(Map<String, Object> map,int type) throws Exception {
		// 保存司机或者电工信息
		String prex="E";
		if("1".equals(map.get("isclient"))){
			prex="D";
		}
		if (isMapKeyNull(map, "customer_id")) {
			String customer_id=getSortId("Sdf00504_saiyu",prex,managerService);
			map.put("customer_id", customer_id);
		}else{
			type=1;
		}
		if (isMapKeyNull(map, "self_id")) {
			map.put("self_id", map.get("customer_id"));
		}
		map.remove("math");
		Object clientdrive=map.get("clientdrive");map.remove("clientdrive");
		if (type==0) {
			managerDao.insertSql(getInsertSql("Sdf00504_saiyu", map));
		}else{
			managerDao.insertSql(getUpdateSql(map, "Sdf00504_saiyu", "customer_id", map.get("customer_id")+"", true));
		}
		//有客户编码和新增
		if(clientdrive!=null&&type==0){
			userDao.updateClientDriveId(clientdrive,map.get("com_id"),map.get("customer_id"));
			return map.get("customer_id")+"";
		}
		try {
			if(type==1){//更新因存在的就不发送消息
				return  map.get("customer_id")+"";
			}
			String url="driver.do";
			String name="司机";
			if("0".equals(map.get("isclient"))){
				name="电工";
				url="electrician.do";
			}
			///获取职位是内勤的所有人员
			Map<String,Object> mapparams=new HashMap<String, Object>();
			mapparams.put("com_id", getComId());
			mapparams.put("headship", "%客服%");
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title",name+"注册核实" );
			String description="@comName@Eheadship@clerkName：有"+name+"注册,请核实其身份并完善资料和授权,注册手机号:"+map.get("movtel");
			mapMsg.put("description",description);
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/manager/"+url+"?customer_id="+map.get("customer_id"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
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
		return map.get("customer_id")+"";
	}
	@Override
	public void uploadLocation(Map<String, Object> map) throws Exception {
		// 电工或者司机上报实时位置
		managerDao.insertSql(getInsertSql("upaddress_saiyu", map));
	}
	
	@Override
	public PageList<Map<String, Object>> getElectricianPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=saiYuDao.getElectricianPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(saiYuDao.getElectricianPageList(map));
		return pages;
	}
	
	@Override
	public void savePaymoney(Map<String, Object> updatemap,Map<String,Object> map) {
		Object c_memo=map.get("c_memo");
		map.remove("json");
		customerDao.insertSql(getInsertSql("ARd02051", map));
		StringBuffer buffer=new StringBuffer(c_memo.toString()); 
		String params=map.get("recieved_id")+"";
		if (!"微信支付".equals(map.get("sum_si_origin"))&&!"支付宝".equals(map.get("sum_si_origin"))) {
				saveOrder(updatemap);
				sendMessageOAARD02051(buffer,params,null);
 		}else{
			saveFile(getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id")),map.get("json").toString());
			saveFile(getPayMsgFilePath(map.get("customer_id"),map.get("recieved_id")), map.get("json").toString());
		}
	}
	@Override
	public String saveEvalOrderPay(Map<String, Object> map,Map<String,Object> mapdemand) {
		Object c_memo=map.get("buffer");map.remove("buffer");
		customerDao.insertSql(getInsertSql("ARd02051", map));
		StringBuffer buffer=new StringBuffer("@comName-@Eheadship-@clerkName:"); 
		buffer.append(c_memo.toString());
		String params=map.get("recieved_id")+"";
		if (!"微信支付".equals(map.get("sum_si_origin"))&&!"支付宝".equals(map.get("sum_si_origin"))) {
				saveDemand_saiyu(mapdemand);
				sendMessageOAARD02051("",buffer.toString(),params,null);
 		}else{
			saveFile(getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id")),map.get("json").toString());
			saveFile(getPayMsgFilePath(map.get("customer_id"),map.get("recieved_id")), map.get("json").toString());
		}
		return null;
	}
	private void saveDemand_saiyu(Map<String, Object> map) {
		 Map<String,Object> mapdemand=new HashMap<String, Object>();
		 mapdemand.put("com_id", map.get("com_id"));
		 mapdemand.put("ivt_oper_listing", map.get("ivt_oper_listing"));
		 mapdemand.put("customer_id", map.get("customer_id"));
		 mapdemand.put("anz_datetime", map.get("anz_datetime"));
		 mapdemand.put("dian_customer_id", map.get("dian_customer_id"));
		 mapdemand.put("up_datetime", getNow());
		 customerDao.insertSql(getInsertSql("demand_saiyu", mapdemand));
		 map.put("orderNo", map.get("ivt_oper_listing"));
		 map.put("Status_OutStore", "已支付");
		 saiYuDao.updateOrderToDemand(map);
		List<Map<String,Object>> list= saiYuDao.getElectricianWeixinID(map.get("com_id")+"", map.get("dian_customer_id"));
		if (list!=null&&list.size()>0) {
			for (Map<String, Object> map2 : list) {
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", "电工【"+map2.get("corp_sim_name")+"】您的安装订单客户已经支付");
				mapMsg.put("description","订单编号:"+map.get("ivt_oper_listing"));
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/evel.do?"+map.get("ivt_oper_listing") );
				mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
				news.add(mapMsg);
				sendMessageNews(news,map2.get("weixinID")+"");
				break;
			}
		}
		
	}

	@Override
	public void saveOrder(Map<String, Object> updatemap) {
		String proceessStr=getFileTextContent(getSalesOrderProcessNamePath(getRequest()));
		  if (StringUtils.isNotBlank(proceessStr)&&proceessStr.startsWith("[")) {
			  JSONArray proceess=JSONArray.fromObject(proceessStr);
			  JSONObject json=proceess.getJSONObject(0);
			  Map<String,Object> mapupdate=new HashMap<String, Object>();
			  StringBuffer sql=new StringBuffer("update sdd02021 set Status_OutStore=#{Status_OutStore}"); 
			  if (updatemap.get("transport_AgentClerk_Reciever")!=null) {
				  sql.append(",transport_AgentClerk_Reciever=#{transport_AgentClerk_Reciever}");
				  mapupdate.put("transport_AgentClerk_Reciever", updatemap.get("transport_AgentClerk_Reciever"));
			  }
			  if (updatemap.get("HYS")!=null) {
				  sql.append(",HYS=#{HYS}");
				  mapupdate.put("HYS",updatemap.get("Kar_Driver")+","+updatemap.get("Kar_Driver_Msg_Mobile"));
			  }
			  if (updatemap.get("beizhu")!=null) {
				  sql.append(",beizhu=#{beizhu}");
				  mapupdate.put("beizhu",updatemap.get("beizhu")+","+updatemap.get("beizhu"));
			  }
			  if (updatemap.get("FHDZ")!=null) {
				  sql.append(",FHDZ=#{FHDZ}");
				  mapupdate.put("FHDZ", updatemap.get("FHDZ"));
			  }
			  if (updatemap.get("Kar_paizhao")!=null) {
				  sql.append(",Kar_paizhao=#{Kar_paizhao}");
				  mapupdate.put("Kar_paizhao", updatemap.get("Kar_paizhao"));
			  }
			  String pro=json.getString("processName");// updatemap.get("Status_OutStore").toString();
			  sql.append(",Kar_paizhao=#{Kar_paizhao}");
			  mapupdate.put("Kar_paizhao", updatemap.get("Kar_paizhao"));
			  sql.append("where ivt_oper_listing=#{ivt_oper_listing} ");
			  mapupdate.put("sSql", sql);
			  mapupdate.put("Status_OutStore",pro);
			  mapupdate.put("ivt_oper_listing", updatemap.get("orderNo"));
			  productDao.insertSqlByPre(mapupdate);
			  ////审批通过通知
			  noticeTongguo(updatemap);
			  
			  String imgName="msg.png";
			  if(json.has("imgName")){
				  imgName=json.getString("imgName");
			  }
			  if(!"打欠条".equals(updatemap.get("Status_OutStore"))){
//			  if(pro.contains("款")){
//				  headship="财务";  
//			  }
				  StringBuffer msg=new StringBuffer("您有订单编号为:").append(updatemap.get("orderNo"));
				  msg.append("(客户下订单),请尽快为客户[").append(updatemap.get("customerName")).append("]")
				  .append(pro);
				  sendMessageNewsNeiQing(pro, msg.toString(), json.getString("Eheadship"),imgName);
			  }
		  }
	}
	/**
	 * 审批通过通知
	 * @param updatemap
	 */
	private void noticeTongguo(Map<String,Object> updatemap) {
		/////////通知所有人///审批流程已经结束///////////
		String approvalStep=null;
		if(updatemap.get("approval_step")!=null){
			approvalStep=updatemap.get("approval_step").toString();
		}else{
			Map<String,String> map=new HashMap<String, String>();
			map.put("com_id", getComId());
			map.put("orderNo", "%"+updatemap.get("orderNo")+"%");
			Integer i=employeeDao.getMaxStep(map);
			approvalStep=i+"";
		}
	    Map<String,Object> oaupdate=new HashMap<String, Object>();
	    oaupdate.put("approval_YesOrNo", updatemap.get("spyj"));//审批意见是否同意
	    oaupdate.put("mainten_clerk_id",getCustomerId(getRequest()));
		oaupdate.put("approvaler",getCustomerId(getRequest()));
//		oaupdate.put("approval_suggestion",map.get("spyijcontent"));
		oaupdate.put("maintenance_datetime",getNow());
		oaupdate.put("approval_time",getNow());
		oaupdate.put("approval_step_now",approvalStep);
		oaupdate.put("ivt_oper_listing", updatemap.get("spNo"));
	    
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("com_id", getComId());
		mapparam.put("upper_customer_id", getUpperCustomerId(getRequest()));
		mapparam.put("noticeResult", "是");
		Map<String,String> spiinfo=getApprovalPerson(mapparam);
		employeeDao.updateApproval(oaupdate);
		if (spiinfo!=null&&spiinfo.get("weixinID")!=null) {//没有找到要推送结果的人
			//2.获取组合标题title 否 标题description 否 描述url 否 点击后跳转的链接。
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> newmap=new HashMap<String, Object>();
			newmap.put("title","您有一条报修申请已通过!");
			Object ivt_oper_listing="";
			if (isNotMapKeyNull(updatemap, "bxNo")) {
				ivt_oper_listing=updatemap.get("bxNo");
			}
//			newmap.put("description","报修单号:"+ivt_oper_listing);
			newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/repairHistory.do?"+ivt_oper_listing);
			news.add(newmap);
			sendMessageNews(news, spiinfo.get("weixinID"));
		}
	}
	
	@Override
	public String alipayClose(Map<String, Object> map) {
		File orderinfo=getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id"));
		if (orderinfo.exists()) {
			String str=getFileTextContent(orderinfo);
			JSONObject json=JSONObject.fromObject(str);
			Map<String,Object> mapupdate=new HashMap<String, Object>();
			String sql="update sdd02021 set Status_OutStore=#{Status_OutStore} where ivt_oper_listing=#{ivt_oper_listing}";
			mapupdate.put("sSql", sql);
			mapupdate.put("Status_OutStore","待支付");
			mapupdate.put("ivt_oper_listing", json.getString("orderNo"));
			productDao.insertSqlByPre(mapupdate);
		}
		return null;
	}
	@Override
	public String alipayComplete(Map<String, Object> map) {
		File orderinfo=getPayInfoFilePath(map.get("customer_id"),map.get("recieved_id"));
		if (orderinfo.exists()) {
			String str=getFileTextContent(orderinfo);
			JSONObject json=JSONObject.fromObject(str);
			saveOrder(json);
		}
		File msg=getPayMsgFilePath(map.get("customer_id"),map.get("recieved_id"));
		if (msg.exists()) {
			String str=getFileTextContent(msg);
			JSONObject json=JSONObject.fromObject(str);
			sendMessageOAARD02051(new StringBuffer(json.get("buffer")+""),json.getString("params"),null);
		}
		return null;
	}
	@Override
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
			String msgtxt="申请欠条审批,金额:"+map.get("order_je")+",订单号:"+map.get("orderNo");
			item.put("content",msgtxt);
			item.put("com_id",map.get("com_id"));
			item.put("approval_step",1);
			item.put("mainten_clerk_id",map.get("com_id"));
			item.put("maintenance_datetime",getNow());
			item.put("OA_what",msgtxt);
			item.put("OA_je", map.get("order_je"));
//			item.put("OA_who", map.get("customer_id"));
			item.put("OA_who", getUpperCustomerId(getRequest()));
//			item.put("upper_customer_id", getUpperCustomerId(getRequest()));
			item.put("OA_whom", clerk_idAccountApprover);//客户审批人
			customerDao.insertSql(getInsertSql("OA_ctl03001_approval", item));
			////////////////
			sendOAMessageNews(clerk_idAccountApprover,"客户欠条审批", msgtxt);
			///////////////
			map.put("Status_OutStore", "打欠条");
			map.put("spyj", "同意");
			saveOrder(map);
			return op_id;
		}
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getOrderPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		map.put("com_id", map.get("com_id"));
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=saiYuDao.getOrderPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(saiYuDao.getOrderPageList(map));
		return pages;
	}
	@Override
	public String getOrderSumsi(Map<String, Object> mapparam) {
		 
		return saiYuDao.getOrderSumsi(mapparam);
	}
	@Override
	public String getElecOrderSumsi(String orderNo, String comId) {
		return saiYuDao.getElecOrderSumsi(orderNo,comId);
	}
	@Override
	public List<Map<String, Object>> getOrderDetails(Map<String, Object> map) {
		return saiYuDao.getOrderDetails(map);
	}
	@Override
	public Map<String, Object> getOrderInfo(Map<String, Object> map) {
		return saiYuDao.getOrderInfo(map);
	}
	
	@Override
	public List<Map<String, Object>> getOrderInfoByIds(String ids) {
		return saiYuDao.getOrderInfoByIds(ids);
	}
	 
	@Override
	public List<Map<String, Object>> getOrderInfoByIdsDrive(String ids) {
		return saiYuDao.getOrderInfoByIdsDrive(ids);
	}
	@Override
	public void noticeShippingManager(Map<String, Object> map) throws Exception {
		employeeDao.updateOrderchuku(map);
		  String buf="库管"+map.get("clerk_name")+"已经完成装货,并发货!";
		  sendMessageNewsByHeadship(map.get("proName").toString(), map.get("seeds_id").toString(), map.get("headship")+"",buf);
		String[] ses=map.get("seeds_id").toString().split(",");
		for (String seeds_id : ses) {
			saveOrderHistory(seeds_id, buf);
		}
	}

	@Override
	public void addRepair(Map<String, Object> map, String[] list)
			throws Exception {
		StringBuffer buffer=new StringBuffer();
		String no ="NO."+DateTimeUtils.getNowDateTimeS();
		 for (String item : list) {
			JSONObject json=JSONObject.fromObject(item);
			String ivt_oper_listing=json.getString("ivt_oper_listing");
			//判断当前是否是光源报修
			//1.获取位置
			buffer.append(json.getString("position")).append(json.getString("position_big"));
			int damage_num_g=0;
			if (json.has("damage_num_g")) {
				damage_num_g=json.getInt("damage_num_g");
				//2.获取损坏类型
//				buffer.append(json.getString("item_name_g")).append(",原装数量:").append(json.getString("item_num_g"));
				//3.报修数量
//				buffer.append(",损坏数量:").append(damage_num_g);
			}
			//判断当前是否是电器报修
			int damage_num_d=0;
			if (json.has("damage_num_d")) {
				damage_num_d=json.getInt("damage_num_d");
				//2.获取损坏类型
//				buffer.append(json.getString("item_name_d")).append(",原装数量:").append(json.getString("item_num_d")).append(",损坏数量");
				//3.报修数量
				if(damage_num_d>0){
//				buffer.append("损坏数量:").append(damage_num_d);
				}
			}
				Map<String,Object> mapdetail=new HashMap<String, Object>();
				mapdetail.put("ivt_oper_listing", no);
				mapdetail.put("sd_order_id", no);
				mapdetail.put("com_id", map.get("com_id"));
				mapdetail.put("bx_customer_id", getCustomerId(getRequest()));
				if (json.has("date")) {
					mapdetail.put("repair_datetime", json.get("date"));
				}else{
					mapdetail.put("repair_datetime", getNow());
				}
				mapdetail.put("sd_oq", damage_num_g+damage_num_d);
				mapdetail.put("c_memo", "光源数量:"+damage_num_g+",电器数量"+damage_num_d);
				mapdetail.put("tj_oper_listing", ivt_oper_listing);//获取体检数据库表 
				mapdetail.put("customer_id", getUpperCustomerId(getRequest()));
				mapdetail.put("mainten_clerk_id", getCustomerId(getRequest()));
				mapdetail.put("mainten_datetime", getNow());
				mapdetail.put("work_state", "报修中");
				productDao.insertSql(getInsertSql("SDd02021_saiyu", mapdetail));
				//更新体检表数据状态
				Map<String,Object> maptijian=new HashMap<String, Object>();
				maptijian.put("ivt_oper_listing", ivt_oper_listing);
				maptijian.put("damage_num_d", damage_num_d);
				maptijian.put("damage_num_g", damage_num_g);
				maptijian.put("bx_oper_listing", no);
				maptijian.put("work_state", "报修中");
				maptijian.put("com_id", getComId());
				productDao.insertSql(getUpdateSql(maptijian, "SDd02010_saiyu", "ivt_oper_listing", ivt_oper_listing, true));
			}
			//4.保存维修记录主表in
			Map<String,Object> mapmain=new HashMap<String, Object>();
			mapmain.put("ivt_oper_listing", no);
			mapmain.put("com_id", map.get("com_id"));
			mapmain.put("sd_order_id", no);
			mapmain.put("customer_id", getUpperCustomerId(getRequest()));
			mapmain.put("repair_datetime", getNow());
			mapmain.put("c_memo", map.get("c_memo"));
			mapmain.put("mainten_clerk_id", getCustomerId(getRequest()));
			mapmain.put("mainten_datetime", getNow());
			productDao.insertSql(getInsertSql("SDd02020_saiyu", mapmain));
			///////////////////
			//保存审批记录 
			//获取客户审批流id
			map.put("approval_step", 1);
			map.put("upper_customer_id", getUpperCustomerId(getRequest()));
			Map<String,Object> process=saiYuDao.getApprovalProcess(map);
			if (process==null) {
				throw new RuntimeException("没有找到该类型的相关审批流程,请联系管理员创建该类型的审批流程!");
			}else{
				///
				SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss",
						Locale.CHINA);
				Integer opidn = getApprovalNo(format.format(new Date()));
				String sd_order_id = "SPNR" + format.format(new Date())
						+ String.format("%03d", opidn);
				Map<String,Object> mapOA=new HashMap<String, Object>();
				mapOA.put("com_id", map.get("com_id"));
				mapOA.put("item_id", process.get("item_id"));
				Object OA_whom=null;
				if(!isMapKeyNull(process, "headship")){
					OA_whom=process.get("headship");
				}else if(!isMapKeyNull(process, "customer_id")){
					OA_whom=process.get("customer_id");
				}else{
					OA_whom=process.get("clerk_id");
				}
				mapOA.put("OA_whom", OA_whom);
				mapOA.put("noticeResult", process.get("noticeResult"));
				mapOA.put("OA_who", getCustomerId(getRequest()));
				mapOA.put("headship", process.get("headship"));
						
				mapOA.put("upper_customer_id",getUpperCustomerId(getRequest()));
				mapOA.put("sd_order_id", sd_order_id);
				mapOA.put("ivt_oper_listing", sd_order_id);
				mapOA.put("mainten_clerk_id", getCustomerId(getRequest()));
				mapOA.put("maintenance_datetime", getNow());
				mapOA.put("store_date", getNow());
				mapOA.put("approval_step", 1);
				String description=buffer.append("|单号:").append(no).toString();
				mapOA.put("content", description);
				mapOA.put("OA_what", description);
				employeeDao.insertSql(getInsertSql("OA_ctl03001_approval", mapOA));
				if(OA_whom.toString().contains("C")){
					Object weixinID= process.get("weixinID");
					map.put("weixinID", weixinID);
				}else{
					Map<String,String> mapempl=employeeDao.getPersonnelWeixinID(OA_whom.toString(), getComId());
					map.put("weixinID", mapempl.get("weixinID"));
					sendOAMessageNews(OA_whom, "报修采购申请", description);
					return;
				}
				//报修第一步
				sendApprovalOA(map,sd_order_id,description);
			}
	}
	
	@Override
	public void repairConfim(Map<String, Object> map, String[] list)
			throws Exception {
		if ("0".equals(map.get("type"))) {
			//更新体检表的结果为已修复
			for (String ivt_oper_listing : list) {
				//更新体检表数据状态
				updateWeixiuState(ivt_oper_listing, "已修复");
				Map<String,Object> maptijian=new HashMap<String, Object>();
				maptijian.put("ivt_oper_listing", ivt_oper_listing);
				maptijian.put("work_state", "运行中");
				maptijian.put("com_id", getComId());
				productDao.insertSql(getUpdateSql(maptijian, "SDd02010_saiyu", "ivt_oper_listing", ivt_oper_listing, true));
			}
			Map<String,String> mapParam=new HashMap<String, String>();
			mapParam.put("approval_YesOrNo", "已修复");//审批意见是否同意
			mapParam.put("mainten_clerk_id",getCustomerId(getRequest()));
			mapParam.put("approvaler",getCustomerId(getRequest()));
			mapParam.put("approval_suggestion","已修复");
			mapParam.put("maintenance_datetime",getNow());
			mapParam.put("approval_time",getNow());
			mapParam.put("approval_step_now", "1");
			mapParam.put("ivt_oper_listing", map.get("spNo").toString());
			if(isMapKeyNull(map, "spNo")){
			Map<String,Object> mapupdate=getApprovalInfo(mapParam);
			employeeDao.updateApproval(mapupdate);
			}
			//2.获取组合标题title 否 标题description 否 描述url 否 点击后跳转的链接。
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> newmap=new HashMap<String, Object>();
			newmap.put("title","您的报修已经成功修复!");
			newmap.put("description", "您的报修已经成功修复");
			newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do");
			news.add(newmap);
			Map<String, Object> mapOrder=new HashMap<String, Object>();
			mapOrder.put("com_id",getComId());
			Map<String,Object> mapcus=saiYuDao.getRepairCustomer(mapParam);
			sendMessageNews(news, mapcus.get("weixinID")+"");
		}else{
			//流程向下进行
			for (String item : list) {
				JSONObject json=JSONObject.fromObject(item);
				String c_memo=null;
				int damage_num_g=0;
				if(json.has("damage_num_g")){
					damage_num_g=json.getInt("damage_num_g");
					c_memo="光源数量:"+json.getString("damage_num_g");
				}
				int damage_num_d=0;
				if (json.has("damage_num_d")) {
					damage_num_d=json.getInt("damage_num_d");
					c_memo=",电器数量:"+json.getString("damage_num_d");
				}
				Map<String,Object> mapweixiu=new HashMap<String, Object>();
				mapweixiu.put("sd_oq", damage_num_g+damage_num_d);
				mapweixiu.put("c_memo", c_memo);
				mapweixiu.put("tj_oper_listing", json.get("ivt_oper_listing"));
				mapweixiu.put("com_id", getComId());
				mapweixiu.put("mainten_clerk_id", getCustomerId(getRequest()));
				mapweixiu.put("mainten_datetime", getNow());
				saiYuDao.updateWeixiuData(mapweixiu);
				Map<String,Object> maptj=new HashMap<String, Object>();
				maptj.put("damage_num_g", damage_num_g);
				maptj.put("damage_num_d", damage_num_d);
				maptj.put("ivt_oper_listing", json.get("ivt_oper_listing"));
				maptj.put("com_id", getComId());
				saiYuDao.updateTjNum(maptj);
			}
			//向下一步生成审批数据
			Map<String,String> mapParam=new HashMap<String, String>();
			mapParam.put("approval_step",getValByMapObj(map, "approval_step"));
			mapParam.put("spNo",getValByMapObj(map, "spNo"));
			mapParam.put("spyj","同意");
			mapParam.put("approvaler",getCustomerId(getRequest()));
			mapParam.put("upper_customer_id", getValByMapObj(map, "upper_customer_id"));
			saveAndSendApprovalInfo(mapParam);
			//发送微信消息
		}
	}
	
	/**
	 * 更新维修从表中的状态
	 * @param ivt_oper_listing  体检表单号
	 * @param work_state 状态值
	 */
	private void updateWeixiuState(String ivt_oper_listing,String work_state) {
		Map<String,Object> mapweixiu=new HashMap<String, Object>();
		mapweixiu.put("work_state", work_state);
		mapweixiu.put("tj_oper_listing", ivt_oper_listing);
		mapweixiu.put("mainten_clerk_id", getCustomerId(getRequest()));
		mapweixiu.put("mainten_datetime", getNow());
		mapweixiu.put("com_id", getComId());
		saiYuDao.updateWeixiuState(mapweixiu);
	}
	
	@Override
	public void qrtjProduct(String[] infolist,Map<String,Object> map) throws Exception {
		String upper_customer_id=null;
		for (String item : infolist) {
			JSONObject json=JSONObject.fromObject(item);
			json.remove("seeds_id");
			managerDao.insertSql(getUpdateSql(json, "SDd02010_saiyu", "ivt_oper_listing", json.getString("ivt_oper_listing"), true));
			updateWeixiuState(json.getString("ivt_oper_listing"), "采购中");
			upper_customer_id=json.getString("customer_id");
		}
		////
		Map<String,String> mapParam=new HashMap<String, String>();
		mapParam.put("approval_step",map.get("approval_step").toString());
		mapParam.put("spNo",getValByMapObj(map, "spNo"));
		mapParam.put("spyj","同意");
		mapParam.put("approvaler",getEmployeeId(getRequest()));
		mapParam.put("upper_customer_id", upper_customer_id);
		saveAndSendApprovalInfo(mapParam);
	}
	@Override
	public Map<String,Object> getOrderNoToApprovalInfo(Map<String, Object> map) {
		return saiYuDao.getOrderNoToApprovalInfo(map);
	}
	
	@Override
	public void confimShouhuo(Map<String, Object> map) throws Exception {
		saiYuDao.confimShouhuo(map);
	}
	
	@Override
	public void tiqianYuYue(Map<String, Object> map) throws Exception {
		Map<String,Object> mapinfo= saiYuDao.findTiqianYuYueInfo(map);
		if (mapinfo!=null) {
			managerDao.insertSql(getUpdateSql(map, "demand_saiyu", "ivt_oper_listing", map.get("ivt_oper_listing").toString(), true));
		}else{
			map.put("up_datetime", getNow());
//			map.put("ivt_oper_listing", "NO."+DateTimeUtils.getNowDateTimeS());
			managerDao.insertSql(getInsertSql("demand_saiyu", map));
		}
		////向所有电工发送消息
		List<Map<String,Object>> list= saiYuDao.getElectricianWeixinID(getComId(),null);
		StringBuffer weixinID=new StringBuffer();
		for (Map<String, Object> map2 : list) {
			weixinID.append(map2.get("weixinID")).append("|");
		}
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title","您有一条来自【"+getComName()+"客户:"+getCustomer(getRequest()).get("clerk_name")+"】的安装需求");
		newmap.put("description","联系人:"+map.get("lxr")+",安装地点:"+map.get("address")+",联系电话:"+map.get("movtel"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/eval.do?ivt_oper_listing="+map.get("ivt_oper_listing"));
		news.add(newmap);
		sendMessageNews(news, weixinID.substring(0, weixinID.length()-1));
	}
	@Override
	public Map<String, Object> findTiqianYuYueInfo(String orderNo, String comId) {
		 Map<String,Object> map=new HashMap<String, Object>();
		 map.put("ivt_oper_listing", orderNo);
		 map.put("com_id", comId);
		 if (StringUtils.isBlank(orderNo)) {
			return null;
		}
		return saiYuDao.findTiqianYuYueInfo(map);
	}
	
	@Override
	public void cyanz(Map<String, Object> map) throws Exception {
		map.put("up_datetime", getNow());
		managerDao.insertSql(getInsertSql("upaddress_saiyu", map));
	}
	@Override//确认安装--1
	public void confirmSelectEval(Map<String, Object> map) throws Exception {
		saiYuDao.insertDemand(map);
		//通知电工客户已经选择他,请他确认安装
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title","电工:您有一条来自【"+getComName()+"-客户"+map.get("corp_sim_name")+"】的安装需求,客户已经确认,进尽快进行安装!");
		newmap.put("description","联系人:"+map.get("lxr")+",联系电话:"+map.get("movtel")+",安装地点:"+map.get("address"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/eval.do?ivt_oper_listing="+map.get("ivt_oper_listing"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
		sendMessageNews(news, map.get("weixinID").toString());
		/////////////通知客户的出纳等职务
		news=new ArrayList<Map<String,Object>>();
		newmap=new HashMap<String, Object>();
		newmap.put("title","客户:您有一条电工安装订单已经由【"+getCustomer(getRequest()).get("clerk_name")+"】确认电工!");
		newmap.put("description","电工姓名:"+map.get("name")+",联系电话:"+map.get("phone"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order="+map.get("ivt_oper_listing"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
//		sendMessageNews(news, getCustomerWeixinIDByHeadship(map.get("upper_customer_id"), ConfigFile.clientElecHeadship));
		Map<String,Object> mapsms=getSystemParamsByComId();
		sendclientmsg(mapsms.get("clientElecHeadship")+"", news,map.get("upper_customer_id").toString(),null);
		//////////////////通知赛宇的财务等职务
		news=new ArrayList<Map<String,Object>>();
		newmap=new HashMap<String, Object>();
		newmap.put("title","员工:客户【"+map.get("corp_sim_name")+"】的电工安装订单已经确认电工!");
		newmap.put("description","订单编号:"+map.get("ivt_oper_listing")+"电工姓名:"+map.get("name")+",联系电话:"+map.get("phone"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?ivt_oper_listing="+map.get("ivt_oper_listing"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
//		sendMessageNews(news, getPersonnelWeixinIDByHeadship(ConfigFile.employeeElecHeadship));
		sendemployeemsg(mapsms.get("employeeElecHeadship")+"", news,null,null);
	}
	@Override
	public void confirmanz(Map<String, Object> map) throws Exception {
		Map<String,Object> weixin=saiYuDao.confirmanz(map);
		//通知客户电工已经确认安装
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title",weixin.get("corp_sim_name")+"客户:您有的安装需求,电工已经确认,请等待电工进行安装!");
		newmap.put("description","电工联系人:"+map.get("corp_sim_name")+",电工联系电话:"+map.get("phone"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order");
		news.add(newmap);
		sendMessageNews(news,weixin.get("weixinID").toString());
	}
	
	@Override///已结验收并评价---3
	public void updateElecState(Map<String, Object> map) {
		 //1.更新订单表中的电工状态,更新电工安装表中的数据为未支付
		Map<String,Object> mapelec= saiYuDao.updateElecState(map);
		Object corp_sim_name=getCustomer(getRequest()).get("clerk_name");
		//通知电工客户已经验收
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title","电工:"+mapelec.get("corp_sim_name")+"您有一条来自【"+getComName()+"-客户"+corp_sim_name+"】的电工安装,客户已经验收确认!");
		newmap.put("description","订单编号:"+map.get("orderNo"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/eval.do?ivt_oper_listing="+map.get("orderNo"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
		sendMessageNews(news, mapelec.get("weixinID").toString());
		//通知客户的出纳等职务
		news=new ArrayList<Map<String,Object>>();
		newmap=new HashMap<String, Object>();
		newmap.put("title","客户:您有一条电工安装订单已经由【"+corp_sim_name+"】验收确认!请尽快支付安装费");
		newmap.put("description","订单编号:"+map.get("orderNo"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order="+map.get("orderNo"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
		Map<String,Object> mapsms=getSystemParamsByComId();
		sendclientmsg(mapsms.get("acceptanceNoticeClientHeadship")+"", news,getUpperCustomerId(getRequest()),null);
		//通知赛宇的财务等职务
		news=new ArrayList<Map<String,Object>>();
		newmap=new HashMap<String, Object>();
		newmap.put("title","员工:客户【"+mapelec.get("clientName")+"】的电工安装已经由客户员工["+corp_sim_name+"]确认验收!");
		newmap.put("description","订单编号:"+map.get("orderNo"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?ivt_oper_listing="+map.get("orderNo"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
		sendemployeemsg(mapsms.get("acceptanceNoticeElpoyeeHeadship")+"", news,null,null);
	}
	
	@Override///电工安装确认--2
	public void anzconfirm(Map<String, Object> map) {
		 //1.更新订单表中的电工状态,更新电工安装表中的数据为已结束
		Map<String,Object> mapelec= saiYuDao.anzconfirm(map);
		//电工姓名
		Object clerk_name=getCustomer(getRequest()).get("corp_name");
		//通知电工客户已经选择他,请他确认安装
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>(); 
		//通知客户的出纳等职务 
		newmap.put("title","客户:电工["+clerk_name+"]已经完成安装,邀请您进行安装验收评价!");
		newmap.put("description","电工姓名:"+clerk_name+",联系电话:"+mapelec.get("phone"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order="+map.get("orderNo"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
		Map<String,Object> mapsms=getSystemParamsByComId();
		sendclientmsg(mapsms.get("elecClientHeadship")+"", news, mapelec.get("upper_customer_id")+"",null);
		//通知赛宇的财务等职务
		news=new ArrayList<Map<String,Object>>();
		newmap=new HashMap<String, Object>();
		newmap.put("title","员工:客户【"+mapelec.get("clientName")+"】的电工安装订单已经由电工已经确认安装完成!");
		newmap.put("description","订单编号:"+map.get("orderNo")+"电工姓名:"+clerk_name+",联系电话:"+mapelec.get("phone"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?ivt_oper_listing="+map.get("orderNo"));
		newmap.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		news.add(newmap);
		sendemployeemsg(mapsms.get("elecEmployeeHeadship")+"", news,null,null); 
	}
	@Override
	public List<Map<String, Object>> getLatlng(Map<String, Object> map) {
		return saiYuDao.getLatlng(map);
	}
	
	@Override
	public Map<String, Object> checkLogin(Map<String,Object> map) {
		return saiYuDao.checkLogin(map);
	}
	
	@Override
	public Map<String, String> getWeixinIDCustomerAndEval(
			Map<String, Object> map) {
		map.put("headship", "%客服%");
		List<Map<String, String>> list= employeeDao.getPersonnelNeiQing(map);
		Map<String,String> weixin= saiYuDao.getWeixinIDCustomerAndEval(map);
		 if(list!=null&&list.size()>0){
			 weixin.put("weixinID", list.get(0).get("weixinID"));
		 }
		return weixin;
	}

	@Override
	public PageList<Map<String, Object>> getEvalOrderInfo(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=saiYuDao.getEvalOrderInfoCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(saiYuDao.getEvalOrderInfo(map));
		return pages;
	}

	@Override
	public String getMaxCustomer_id(int type) {
		 
		return saiYuDao.getMaxCustomer_id(type);
	}
	
	@Override
	public Map<String, Object> getElectricianInfo(Map<String, Object> maprows) {
		return saiYuDao.getElectricianInfo(maprows);
	}
}
