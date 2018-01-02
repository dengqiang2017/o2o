package com.qianying.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IProductionManagementDAO;
import com.qianying.dao.interfaces.IProductionPlanDao;
import com.qianying.page.PageList;
import com.qianying.service.IProductionPlanService;
import com.qianying.util.ConfigFile;
import com.qianying.util.LoggerUtils;

@Service
@Transactional
public class ProductionPlanServiceImpl extends BaseServiceImpl implements IProductionPlanService {

	@Resource
	private IProductionPlanDao productionPlanDao;
	@Resource
	private IProductionManagementDAO productionManagementDao;
	@Override
	public PageList<Map<String, Object>> getProductionPlanInfo(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionPlanDao.getProductionPlanInfoCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			List<Map<String,Object>> list=productionPlanDao.getProductionPlanInfoList(map);
			pages.setRows(list);
		}
		return pages;
	}
	
	@Override
	public PageList<Map<String, Object>> getProductInfo(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		//定制订单///销售订单
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionPlanDao.getPlanSourceOrderCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			List<Map<String,Object>> list=productionPlanDao.getPlanSourceOrderList(map);
			pages.setRows(list);
		}
		return pages;
	}
	
	@Override
	public List<Map<String, Object>> getProductionProcessInfo(Map<String, Object> map) {
		
		return productionPlanDao.getProductionProcessInfo(map);
	}
	
	@Override
	public String saveProductionPlan(Map<String, Object> map) {
		String ivt_oper_listing=getOrderNo(customerDao, "生产作业进度", map.get("com_id").toString());
		if (isMapKeyNull(map, "sd_order_id")) {
			map.put("sd_order_id", ivt_oper_listing);
		}
		///保存生产计划从表
		JSONArray jsons=JSONArray.fromObject(map.get("dataArr"));
		Set<String> customer_id=new HashSet<String>();
		String PHs="";
		String XQLX="";
		StringBuffer item_ids=new StringBuffer();
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			Map<String,Object> mapdetail=new HashMap<String, Object>();
			String PH = "";
			if(json.has("PH")){
				PH = json.getString("PH");
				int len=PH.length();
				if(len<14){
					PH=ivt_oper_listing.substring(5,5+(14-len))+PH;
				}
			}else{
//				String phnum=productionManagementDao.getPHTail(map.get("com_id").toString(),ivt_oper_listing);
//				if(StringUtils.isBlank(phnum)){
//					phnum="001";
//				}
//				PH = ivt_oper_listing.substring(5,16) 
//						+phnum ;
			}
			mapdetail.put("ivt_oper_listing", ivt_oper_listing);
			mapdetail.put("com_id", map.get("com_id"));
			mapdetail.put("sd_order_id", map.get("sd_order_id"));
			mapdetail.put("JFRQ", map.get("plan_end_date"));
			mapdetail.put("PH", PH);
			mapdetail.put("status", 0);
			mapdetail.put("allsend_oq", 0);
			getJsonVal(mapdetail, json, "customer_id", "customer_id");
			if(json.has("customer_id")&&!"".equals(json.getString("customer_id"))){
				customer_id.add(json.getString("customer_id")+","+json.getString("auto_mps_id"));
			}
			getJsonVal(mapdetail, json, "item_id", "item_id");
			getJsonVal(mapdetail, json, "item_name", "item_name");
			getJsonVal(mapdetail, json, "JHSL", "JHSL");
			getJsonVal(mapdetail, json, "c_memo", "c_memo");
			getJsonVal(mapdetail, json, "memo_color", "memo_color");
			getJsonVal(mapdetail, json, "memo_other", "memo_other");
			getJsonVal(mapdetail, json, "auto_mps_id", "auto_mps_id");//销售订单号(内码)  
			getJsonVal(mapdetail, json, "mps_id", "auto_mps_id");//销售订单号(内码)  
			getJsonVal(mapdetail, json, "CusName", "corp_name");
			getJsonVal(mapdetail, json, "pack_unit", "pack_unit");
			getJsonVal(mapdetail, json, "pack_num", "pack_num");
			getJsonVal(mapdetail, json, "send_qty", "send_qty");//销售订单中的总数量：订货数   
			getJsonVal(mapdetail, json, "cYS", "cYS");//产品属性：颜色
			getJsonVal(mapdetail, json, "cPP", "cPP");//产品属性：品牌
			getJsonVal(mapdetail, json, "cZL", "cZL");//产品属性：重量 
			if(json.has("c_memo")||
			json.has("memo_color")||
			json.has("memo_other")){
				mapdetail.put("if_anomaly", "异形");
				mapdetail.put("c_edition", "异形");
				XQLX= "订单生产";
			} 
			if(isNotMapKeyNull(mapdetail, "auto_mps_id")){
				mapdetail.put("if_anomaly", "定制");
				mapdetail.put("c_edition", "定制");
				XQLX= "订单生产";
			}else{
				mapdetail.put("if_anomaly", "标准");
				mapdetail.put("c_edition", "标准");
				XQLX= "批量生产";
			}
			mapdetail.put("XQLX", XQLX);
			mapdetail.put("sSql",getInsertSqlByPre("YieM02011", mapdetail));
			productDao.insertSqlByPre(mapdetail);
			///标识订单状态为开始生产
			if(isNotMapKeyNull(mapdetail, "item_id")){
//				updateOrderProductionBegin(mapdetail);
				item_ids.append(mapdetail.get("item_id")).append(",");
			}
			if (isNotMapKeyNull(mapdetail, "PH")) {
				PHs=PH+","+PHs;
			}
			if(json.has("auto_mps_id")&&StringUtils.isNotBlank(json.getString("auto_mps_id"))){
				getJsonVal(mapdetail, json, "ivt_oper_listing", "auto_mps_id");
				mapdetail.put("st_auto_no", ivt_oper_listing);
				employeeDao.updateOrderPurchasing(mapdetail);
			}
		}
		///保存主表数据
		Map<String,Object> mapmain=new HashMap<String, Object>();
		mapmain.put("ivt_oper_listing", ivt_oper_listing);
		mapmain.put("com_id", map.get("com_id"));
		mapmain.put("sd_order_id", map.get("sd_order_id"));
		mapmain.put("send_date", getNow());
		mapmain.put("plan_end_date", map.get("plan_end_date"));
		mapmain.put("dept_id", map.get("dept_id"));
		mapmain.put("clerk_id", map.get("clerk_id"));
		mapmain.put("batch_mark", map.get("batch_mark"));
		mapmain.put("comfirm_flag", "Y");
		mapmain.put("demand_type", XQLX);
		mapmain.put("mainten_clerk_id", map.get("clerk_id"));
		mapmain.put("mainten_datetime",getNow());
		mapmain.put("c_memo", map.get("c_memo"));
		Calendar c = Calendar.getInstance();
		mapmain.put("finacial_y", c.get(Calendar.YEAR));
		mapmain.put("finacial_m", c.get(Calendar.MONTH));
		mapmain.put("sSql",getInsertSqlByPre("YieM02010", mapmain));
		productDao.insertSqlByPre(mapmain);
		//发送微信消息
		Map<String, Object> msgMap = new HashMap<String, Object>();
		msgMap.put("title", map.get("title"));
		msgMap.put("description", map.get("description").toString().replaceAll("@comName", getComName()));
		msgMap.put("url", map.get("url")+ivt_oper_listing);
		msgMap.put("headship", map.get("headship"));
		sendMSG(msgMap);
		if(customer_id.size()>0){
			////向客户发送微信消息
			for (String cus : customer_id) {
				String cusid=cus.split(",")[0];
				String orderNo=cus.split(",")[1];
				noticeCustomer(cusid,orderNo,map);
			}
		}
		if(StringUtils.isNotBlank(PHs)){
			String[] phlist=PHs.split(",");
			String[] itemlist=item_ids.toString().split(",");
			for (int i = 0; i < phlist.length; i++) {
				savePplanLog(phlist[i],itemlist[i], "内勤:"+map.get("clerk_name")+",下生产计划");
			}
		}
		return PHs;
	}
	private void updateOrderProductionBegin(Map<String, Object> mapdetail) {
		// TODO 更新订单开始生产
		//1.获取订单下一步流程
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("com_id", mapdetail.get("com_id"));
		map.put("orderNo", mapdetail.get("auto_mps_id"));
		map.put("item_id", mapdetail.get("item_id"));
		Map<String,Object> mapinfo=productionPlanDao.getOrderProcessName(map);
		//1.1获取订单当前流程
		
		//2.获取包含拉货所在流程
		Map<String, String[]> mappro=getProcessName();
		String[] processName=mappro.get("processName");
		Integer index=0;
		for (int i = 0; i < processName.length; i++) {
			String item=processName[i];
			if(item.equals(mapinfo.get("Status_OutStore"))){
				index=i;
				break;
			}
		}
		//获取流程名称和职务
		//1.2当前流程加1
		String proName=processName[index+1];
		map.put("processName",proName);
		map.put("st_auto_no", mapdetail.get("ivt_oper_listing"));
		productionPlanDao.updateOrderProductionBegin(map);
	}

	/**
	 * 通知客户已下生产计划
	 * @param cusid 客户编码
	 * @param orderNo 订单编号
	 * @param mapinfo
	 * @param processName
	 * @param c_title
	 * @param c_description
	 * @param c_url
	 */
	private void noticeCustomer(String cusid, String orderNo,Map<String,Object> mapinfo) {
		Map<String,Object> params=new HashMap<String, Object>();
		params.put("processName","%"+mapinfo.get("processName")+"%");
		params.put("headship","%"+mapinfo.get("headship")+"%");
		params.put("com_id", getComId());
		params.put("upper_customer_id",cusid);
		params.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String,String>> cuslist=customerDao.getCustomerWeixinByHeadship(params);
		for (Map<String, String> map : cuslist) {
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", mapinfo.get("c_title"));
			String description=mapinfo.get("c_description").toString().
					replaceAll("@customerName", map.get("corp_sim_name")).
					replaceAll("@orderNo", orderNo);
			mapMsg.put("description", description);
			if (mapinfo.get("c_url")!=null) {
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+mapinfo.get("c_url"));
			}
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
			news.add(mapMsg);
			sendMessageNews(news, map.get("weixinID"));
		}
	}
	/**
	 * 向员工发送消息
	 * @param msgMap
	 * @param headship
	 * @param orderStepRecipient 流程名称
	 * @param dept_id 部门id
	 * @param title
	 * @param description
	 * @param url
	 */
	private void sendMSG(Map<String, Object> msgMap) {
		try {
			//通过职位获取员工微信号
			if(!isMapKeyNull(msgMap, "headship")){
				Map<String,Object> map=new HashMap<String, Object>();
				map.put("com_id", getComId());
				map.put("headship", "%"+msgMap.get("headship").toString()+"%");
				map.put("omrtype", getSystemParam("ordersMessageReceivedType"));
				if(isNotMapKeyNull(msgMap, "orderStepRecipient")){
					map.put("processName", msgMap.get("orderStepRecipient"));
				}
				if(isNotMapKeyNull(msgMap, "dept_id")){
					map.put("dept_id", "%"+msgMap.get("dept_id")+"%");
				}
				List<Map<String, String>> headshipList = employeeDao.getPersonnelNeiQing(map);
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", msgMap.get("title"));
				String description=msgMap.get("description").toString();
				mapMsg.put("description", description);
				if (msgMap.get("url")!=null) {
					mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+msgMap.get("url"));
				}
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
				news.add(mapMsg);
				for (int i = 0; i < headshipList.size(); i++) {
					Map<String, String> item=headshipList.get(i);
					String msg=description.replaceAll("@clerkName",item.get("clerk_name"));
					news.get(0).put("description",msg);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						sendMessageNews(news,item.get("weixinID"));
					}
					news.get(0).put("description",description);
				}
			}
		} catch (Exception e) {
//			writeLog(getRequest(), "生产计划发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
//	@Override
//	public String getOrderNo(String orderName, String comId) {
//		 
//		return getOrderNo(customerDao, orderName, comId);
//	}
	@Override
	public PageList<Map<String, Object>> getProductionTrackingPage(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionPlanDao.getProductionTrackingPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			List<Map<String,Object>> list=productionPlanDao.getProductionTrackingPage(map);
			Map<String,Object> gxmap=new HashMap<String, Object>();
			if (list!=null&&list.size()>0) {
				List<String> phs=new ArrayList<String>();
				List<String> itemids=new ArrayList<String>();
				for (Map<String, Object> map2 : list) {
					phs.add(map2.get("PH").toString());
					itemids.add(map2.get("item_id").toString());
				}
				map.put("phs", phs);
				map.put("itemids", itemids);
				List<Map<String,Object>> zuoyelist=productionPlanDao.getProductionTrackingYieM02030(map);
				gxmap.put("zuoyelist", zuoyelist);
				list.add(gxmap);
				pages.setRows(list);
			}
		}
		return pages;
	}
	
	@Override
	public String savePaigong(Map<String, Object> map) {
		//判断是否有派工单号,没有就保存主表
		String pgdh=null;
		boolean b=false;
		if(isNotMapKeyNull(map, "pgdh")){
			pgdh=map.get("pgdh").toString();
		}else{
			pgdh=getOrderNo(customerDao, "生产作业单", map.get("com_id").toString());
			b=true;
		}
		//组合从表数据
		JSONArray jsons=JSONArray.fromObject(map.get("JSGR"));
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			Map<String,Object> mapdetail=new HashMap<String, Object>();
			mapdetail.put("com_id", map.get("com_id"));
			mapdetail.put("PGSL", json.get("PGSL"));
			mapdetail.put("PGSJ", getNow());
//			mapdetail.put("WGSJ", map.get("WGSJ"));//存放质检完成时间JJSJ--工人提交质检时间
			mapdetail.put("status", map.get("status"));
			mapdetail.put("auto_mps_id", map.get("auto_mps_id"));
			mapdetail.put("item_id", map.get("item_id"));
			mapdetail.put("customer_id", map.get("customer_id"));
			mapdetail.put("JSGXID", map.get("work_id"));
			mapdetail.put("PH", map.get("PH"));
			mapdetail.put("JSGR", json.get("clerkid"));
			mapdetail.put("ivt_oper_listing", pgdh);
			mapdetail.put("sd_order_id", pgdh);
			if(json.has("pgdh")&&StringUtils.isNotBlank(json.getString("pgdh"))){
				productDao.insertSql(getUpdateSql(mapdetail, "YieM02031", "ivt_oper_listing",pgdh)
						+" and JSGXID='"+map.get("work_id")+"' and JSGR='"+json.get("clerkid")+"'");
			}else{
				mapdetail.put("sSql",getInsertSqlByPre("YieM02031", mapdetail));
				productDao.insertSqlByPre(mapdetail);
				mapdetail.put("working_procedure_section", map.get("working_procedure_section"));
				mapdetail.put("ivt_oper_listing", map.get("ivt_oper_listing"));
				productionManagementDao.updateYieM02011(mapdetail);
				if(isNotMapKeyNull(mapdetail, "auto_mps_id")&&isNotMapKeyNull(mapdetail, "item_id")){
					savePplanLog(map.get("PH"),map.get("item_id"), "计调员:"+map.get("clerk_name")+",安排生产");
				}
			}
		}
		if(b){
			//组合主表数据
			Map<String,Object> mapmain=new HashMap<String, Object>();
			mapmain.put("com_id", map.get("com_id"));
			mapmain.put("ivt_oper_listing", pgdh);
			mapmain.put("sd_order_id", pgdh);
			mapmain.put("PH", map.get("PH"));
			mapmain.put("plan_end_date", map.get("plan_end_date"));
			mapmain.put("auto_mps_id", map.get("auto_mps_id"));
			mapmain.put("work_id", map.get("work_id"));
			mapmain.put("item_id", map.get("item_id"));
			mapmain.put("batch_mark", map.get("batch_mark"));
			mapmain.put("auto_PGDBH", map.get("PGDBH"));
			mapmain.put("PGDBH", map.get("PGDBH"));
			mapmain.put("comfirm_flag","Y");
			mapmain.put("mainten_clerk_id",getEmployeeId(getRequest()));
			mapmain.put("mainten_datetime",getNow());
			mapmain.put("sSql",getInsertSqlByPre("YieM02030", mapmain));
			productDao.insertSqlByPre(mapmain);
		}
		return pgdh;
	}

	@Override
	public String noticeProduction(Map<String, Object> map) {
		List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", map.get("title"));
		String description=map.get("description").toString();
		mapMsg.put("description", description);
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/pPlan/paigongdan.do");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		if(ConfigFile.PlanPush==0){//离散型
			//去掉第一个流程限制,直接获取所有流程
			map.remove("work_id");
			map.remove("work");
			map.put("work_type", 1);
		}else{
			map.put("work_type", 0);
		}
		Object work=map.get("work");
		if(work!=null){
			String[] works=work.toString().split(",");
			for (String workid : works) {
				if(StringUtils.isNotBlank(workid)){
					map.put("work_id", workid);
					List<Map<String,String>> list=productionPlanDao.getPaigongEmployee(map);
					for (Map<String, String> map2 : list) {
						news.get(0).put("description",description.replaceAll("@comName",getComName()).replaceAll("@clerkName", map2.get("clerk_name")));
						sendMessageNews(news, map2.get("weixinID"));
						news.get(0).put("description",description);
					}
				}
			}
		}else{
			List<Map<String,String>> list=productionPlanDao.getPaigongEmployee(map);
			for (Map<String, String> map2 : list) {
				news.get(0).put("description",description.replaceAll("@comName",getComName()).replaceAll("@clerkName", map2.get("clerk_name")));
				sendMessageNews(news, map2.get("weixinID"));
				news.get(0).put("description",description);
			}
		}
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getWorkerProductionList(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionPlanDao.getWorkerProductionCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			pages.setRows(productionPlanDao.getWorkerProductionList(map));
		}
		return pages;
	}
	@Override
	public String beginProduction(Map<String, Object> map) {
		productionPlanDao.beginProduction(map);
		return null;
	}
	@Override
	public String noticeQualityCheck(Map<String, Object> map) {
		//1.获取质检员
		List<Map<String,String>> list=null;
		Object work_id=map.get("work_id");
		if(ConfigFile.QCWay==0){
			//1.1质检方式：下工序检上工序  当前工序加1的工序人员
			 list=productionPlanDao.getNextWorkEmployee(map);
		}else{
			//1.2质检方式：质检员质检 质检员所属工序+[质检员]职务=质检的员工
			map.put("headship", "%"+map.get("headship")+"%");
			map.put("work_id", "%"+work_id+"%");
			list=productionPlanDao.getQualityEmployee(map);
		}
		//2.通知质检员
		List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", map.get("title"));
		String description=map.get("description").toString();
		mapMsg.put("description", description);
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/pPlan/qualityCheck.do?"+map.get("ivt_oper_listing")+"|"+map.get("work_id")+"|"+map.get("item_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		for (Map<String, String> map2 : list) {
			news.get(0).put("description",description.replaceAll("@comName",getComName()).replaceAll("@clerkName", map2.get("clerk_name")));
			sendMessageNews(news, map2.get("weixinID"));
			news.get(0).put("description",description);
		}
		//3.更新作业流程表通知质检
		map.put("work_id", work_id);
		productionPlanDao.beginProduction(map);
		savePplanLog(map.get("PH"),map.get("item_id"), "工序:"+map.get("work_name")+",生产工人:"+map.get("clerk_name")+",提请质检");
		return null;
	}
	@Override
	public String qualityChecked(Map<String, Object> map) {
		//1.判断派工数量是否等于完工数量(已完工数量+质检通过数量)
		Integer PGSL=Integer.parseInt(map.get("PGSL").toString());
		Integer num=Integer.parseInt(map.get("num").toString());
		Integer WGSL=Integer.parseInt(map.get("WGSL").toString());
		Integer sysl=PGSL-(num+WGSL);//剩余数量
		map.put("JJSJ", getNow());
		if(PGSL==(num+WGSL)){
			//全部通过表示为已完成
			map.put("status", 3);
			productionPlanDao.beginProduction(map);
		}else{
			//1.1不等于通知本工序工人继续生产
			Map<String,String> touser= employeeDao.getPersonnelWeixinID(map.get("clerk_id")+"", map.get("com_id")+"");
			List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", map.get("title_check"));
			String description=map.get("description_check").toString().replaceAll("@sysl", sysl+"");
			mapMsg.put("description", description.replaceAll("@comName",getComName()).replaceAll("@clerkName", touser.get("clerk_name")));
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/pPlan/paigongdan.do");
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
			news.add(mapMsg);
			sendMessageNews(news, touser.get("weixinID"));
			map.put("status", 1);
			productionPlanDao.beginProduction(map);
		}
		///获取当前工序的下一道工序
//		Map<String,Object> mapwork=productionPlanDao.getNextWorkInfo(map);
		List<Map<String, String>> list=getWorkEmployee(map);
//		if(mapwork!=null){
			//2.通知下工序工人继续生产
//			map.put("work_id", mapwork.get("work_id"));
//			List<Map<String, String>> list=productionPlanDao.getNextWorkEmployee(map);
			if(list!=null&&list.size()>0){
				List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", map.get("title"));
				String description=map.get("description").toString();
				mapMsg.put("description", description);
				mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/pPlan/paigongdan.do");
				mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
				news.add(mapMsg);
				for (Map<String, String> map2 : list) {
					news.get(0).put("description",description.replaceAll("@comName",getComName()).replaceAll("@clerkName", map2.get("clerk_name")));
					sendMessageNews(news, map2.get("weixinID"));
					news.get(0).put("description",description);
					map.put("work_id", map2.get("work_id"));
					map.put("clerk_id", map2.get("clerk_id"));
					map.put("status", 0);
					map.put("JJSJ", getNow());
					map.remove("num");
					productionPlanDao.noticeProduction(map);
				}
				//4.记录历史
				String msg=map.get("work_name")+",质检通过:"+num+",剩余:"+sysl
						+",生产工人:"+map.get("clerk_name")+",质检员:"+getEmployee(getRequest()).get("clerk_name");
				savePplanLog(map.get("PH"),map.get("item_id"), msg);
//			}
		}else{
			
			//为空表示是最后一道工序完成,进入入库操作
			if(PGSL==(num+WGSL)){//入库操作
				//生产标识为已完成
				productionPlanDao.productionEnd(map);
				//调用入库存储过程
				autoStorage(map);
				///向员工和客户发送生产完成消息
				noticeProductionEnd(map);
				savePplanLog(map.get("PH"),map.get("item_id"), "全部工序生产完成并入库,质检员:"+getEmployee(getRequest()).get("clerk_name"));
			}
		}
		return null;
	}
	
	private List<Map<String, String>> getWorkEmployee(Map<String, Object> map) {
		//1.获取工序总长度
		Integer len=productionPlanDao.getProductionProcessCount(map);
		Map<String,Object> mapwork=productionPlanDao.getNextWorkInfo(map);
		if(mapwork==null){
			return null;
		}
		Integer No_serial=Integer.parseInt(mapwork.get("No_serial").toString());
		List<Map<String, String>> list=null;
		Integer ser=No_serial-1;
		for (int i = ser; i < len; i++) {
			//获取指定工序的下级
			map.put("work_id", mapwork.get("work_id"));
			if(i>ser){
				mapwork=productionPlanDao.getNextWorkInfo(map);
				if(mapwork==null){
					break;
				}
			}
			map.put("work_id", mapwork.get("work_id"));
			list=productionPlanDao.getNextWorkEmployee(map);
			if(list!=null&&list.size()>0){
				break;
			}
			//如果没有就继续循环
			//直到整个流程均没有
		}
		return list;
	}
	
	/**
	 * 自动入库
	 * @param map
	 */
	private void autoStorage(Map<String, Object> map) {
		// TODO 自动入库
		
	}

	/**
	 * 通知生产已结束
	 * @param map
	 */
	private void noticeProductionEnd(Map<String, Object> map) {
		// TODO 通知生产已结束
		//1.根据PH获取该生产计划对应的客户编码和订单编号,产品编码
		Map<String,Object> mapinfo= productionPlanDao.getProductionPlanInfo(map);
		//2.获取包含拉货所在流程
		Map<String, String[]> mappro=getProcessName();
		String[] processName=mappro.get("processName");
		Integer index=0;
		for (int i = 0; i < processName.length; i++) {
			String item=processName[i];
			if(item.contains("拉货")){
				index=i;
				break;
			}
		}
		//获取流程名称和职务
		String proName=processName[index];
		mapinfo.put("processName", proName);
		productionPlanDao.updateOrderProductionBegin(mapinfo);
		String Eheadship=mappro.get("Eheadship")[index];
		String headship=mappro.get("headship")[index];
		Map<String, Object> msgMap=new HashMap<String, Object>();
		msgMap.put("headship", Eheadship);
		msgMap.put("orderStepRecipient", proName);
		msgMap.put("title", "客户订单生产完工通知");
		msgMap.put("description", getComName()+"-"+Eheadship+"-@clerkName,订单编号为:"
		+mapinfo.get("orderNo")+",已经完成生产,请"+proName);
		msgMap.put("url", "/employee/orderTracking.do?"+utf8to16(proName)+"|"+mapinfo.get("orderNo"));
		this.sendMSG(msgMap);
		//
		Map<String, Object> mapcus=new HashMap<String, Object>();
		mapcus.put("processName", proName);
		mapcus.put("headship", headship);
		mapcus.put("c_title", "订单生产完工通知");
		mapcus.put("c_description", "尊敬的客户:@customerName,您的订单产品已经完成生产,订单编号:"+mapinfo.get("orderNo"));
		mapcus.put("c_url", "/customer/myorder.do?"+mapinfo.get("orderNo"));
		this.noticeCustomer(mapinfo.get("customer_id")+"", mapinfo.get("orderNo")+"", mapcus);
	}

	/**
	 * 保存生产计划流程日志
	 * @param PH 排产编号
	 * @param msg 日志内容 
	 * @param string 
	 */
	public void savePplanLog(Object PH, Object item_id,String msg){
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", getComId());
		map.put("PH", PH);
		map.put("item_id", item_id);
		Map<String,Object> mapinfo= productionPlanDao.getProductionPlanInfo(map);
		saveOrderHistory(mapinfo.get("orderNo"), mapinfo.get("item_id"), msg);
	}
	
	@Override
	public List<Map<String, Object>> getQualityCheckList(Map<String, Object> map) {
		Map<String,Object> mapempl=null;
		if(!"001".equals(map.get("clerk_id"))){
			 mapempl=productionPlanDao.getQualityWork_id(map);
		}
		if(mapempl!=null||"001".equals(map.get("clerk_id"))){
			if(mapempl!=null&&!"".equals(mapempl.get("work_id"))){//不等于空,查询该质检员能够质检的信息,等于空质检所有的信息
				map.put("work_id", mapempl.get("work_id"));
			}
			return productionPlanDao.getQualityCheckList(map);
		}
		return null;
	}
	/////////工人工价统计/////////////
	@Override
	public Map<String, Object> getWorkPriceList(Map<String, Object> map) {
		//1.获取员工名字
		List<Map<String,Object>> employeelist=productionPlanDao.getProductionEmpoyee(map);
		if(employeelist!=null&employeelist.size()>0){
			//2.获取左边部分数据
			List<Map<String,Object>> leftlist=productionPlanDao.getWorkPriceLeftList(map);
			if(leftlist!=null&&leftlist.size()>0){
				//3.获取工资部分数据
				List<Map<String,Object>> pricelist= productionPlanDao.getWorkPriceList(map);
				Map<String,Object> mapret=new HashMap<String, Object>();
				mapret.put("employeelist", employeelist);
				mapret.put("leftlist", leftlist);
				mapret.put("pricelist", pricelist);
				return mapret;
			}
		}
		return null;
	}
	@Override
	public Map<String, Object> getWorkSumPriceList(Map<String, Object> map) {
		List<Map<String,Object>> leftlist= productionPlanDao.getWorkSumPriceLeftList(map);
		List<Map<String,Object>> pricelist= productionPlanDao.getWorkSumPriceList(map);
		Map<String,Object> mapret=new HashMap<String, Object>();
		mapret.put("leftlist", leftlist);
		mapret.put("pricelist", pricelist);
		return mapret;
	}
}
