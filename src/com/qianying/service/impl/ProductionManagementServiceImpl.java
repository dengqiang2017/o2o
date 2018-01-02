package com.qianying.service.impl;

import java.io.File;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.qianying.dao.interfaces.IProductionManagementDAO;
import com.qianying.page.PageList;
import com.qianying.service.IProductionManagementService;
import com.qianying.util.ConfigFile;
import com.qianying.util.LoggerUtils;
@Service
public class ProductionManagementServiceImpl extends BaseServiceImpl implements
		IProductionManagementService {

	@Autowired
	private IProductionManagementDAO productionManagementDao;

	@Override
	public PageList<Map<String, Object>> initialMaintenancePage(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=1000;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if(getTotalRecord(map, currentPage, pageRecord)!=null){
			totalRecord=productionManagementDao.initialMaintenanceCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows=productionManagementDao.initialMaintenancePage(map);
		pages.setRows(rows);
		return pages;
	}
	@Override
	public List<Map<String, Object>> getWareList(
			Map<String, Object> map) {
		return productionManagementDao.getWareList(map);
	}
	@Override
	public Map<String, Object> initialMaintenanceInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return productionManagementDao.initialMaintenanceInfo(map);
	}
	@Override
	public PageList<Map<String, Object>> getWarePage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (isNotMapKeyNull(map, "type_id")) {
			map.put("type_id", map.get("type_id")+"%");
		}
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionManagementDao.getWarePageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productionManagementDao.getWarePageList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> initialReceivablePage(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=1000;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if(getTotalRecord(map, currentPage, pageRecord)!=null){
			totalRecord=productionManagementDao.initialReceivableCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows=productionManagementDao.initialReceivablePage(map);
		pages.setRows(rows);
		return pages;
	}
	@Override
	public Map<String, Object> initialReceivableInfo(Map<String, Object> map) {
		 
		return productionManagementDao.initialReceivableList(map).get(0);
	}
	@Override
	public PageList<Map<String, Object>> initialPayablePage(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=1000;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if(getTotalRecord(map, currentPage, pageRecord)!=null){
			totalRecord=productionManagementDao.initialPayableCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows=productionManagementDao.initialPayablePage(map);
		pages.setRows(rows);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> inventoryAllocationFind(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=1000;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if(getTotalRecord(map, currentPage, pageRecord)!=null){
			totalRecord=productionManagementDao.findInventoryAllocationCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows=productionManagementDao.findInventoryAllocationFindQuery(map);
		pages.setRows(rows);
		return pages;
	}

	@Override
	public String sp_baseinitStore(Map<String, Object> map) {
		 try {
			 productionManagementDao.sp_baseinitStore(map);
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return null;
	}
	
	@Override
	public PageList<Map<String, Object>> wareinitPage(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=1000;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if(getTotalRecord(map, currentPage, pageRecord)!=null){
			totalRecord=productionManagementDao.wareinitCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows=productionManagementDao.wareinitPage(map);
		pages.setRows(rows);
		return pages;
	}
	
	/**
	 * 获取生产计划单号
	 */
	@Override
	public String productionPlanSdOrderID(Map<String, Object> map) {
		return getOrderNo(customerDao, "生产作业进度", map.get("com_id").toString());
	}

	/**
	 * 查询所有状态为使用的产品信息
	 */
	@Override
	public PageList<Map<String, Object>> getProductInfo(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		
		getPageInfo(map,totalRecord,currentPage,pageRecord);
		totalRecord=productionManagementDao.getProductInfoCount(map);
		map.put("totalRecord", totalRecord);
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=productionManagementDao.getProductInfoList(map);
		pages.setRows(list);
		return pages;
	}

	/**
	 * 查询所有订单,状态不为待支付、支付中
	 * @param map
	 * @return
	 */
	@Override
	public PageList<Map<String, Object>> getOrderInfo(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		
		getPageInfo(map,totalRecord,currentPage,pageRecord);
		totalRecord=productionManagementDao.getOrderInfoCount(map);
		map.put("totalRecord", totalRecord);
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=productionManagementDao.getOrderInfoList(map);
		pages.setRows(list);
		return pages;
	}
/**
 * 获取计划类型
 * @return
 */
private String getDemand_type() {
	if(ConfigFile.PlanSource == 0){
		return "计划生产";
	}else if(ConfigFile.PlanSource == 1){
		return "销售订单生产";
	}else{
		return "定制订单生产";
	}
}
	/**
	 * 新增生产计划
	 * @param jsons
	 * @param map
	 */
	@Override
	public void addProductionPlan(JSONArray jsons, Map<String, Object> map) {
		SimpleDateFormat formattime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		String ivt_oper_listing=productionPlanSdOrderID(map);
		map.put("ivt_oper_listing", ivt_oper_listing);
		if (isMapKeyNull(map, "sd_order_id")) {
			map.put("sd_order_id", ivt_oper_listing);
		}
		if(map.get("ivt_oper_listing")!=null){
			Integer flag = productionManagementDao.getYieM02010Count(map.get("com_id").toString(),
					map.get("ivt_oper_listing").toString());
			if(flag<1){
				//生产计划主表
				Map<String, Object> mainTable = new HashMap<String, Object>();
				mainTable.put("com_id", map.get("com_id"));
				mainTable.put("ivt_oper_listing", map.get("ivt_oper_listing"));
				if(!isMapKeyNull(map, "sd_order_id")){
					mainTable.put("sd_order_id", map.get("sd_order_id"));
				}else {
					mainTable.put("sd_order_id", map.get("ivt_oper_listing"));
				}
				mainTable.put("send_date", map.get("send_date"));
				mainTable.put("plan_end_date",map.get("plan_end_date"));
				mainTable.put("batch_mark",map.get("batch_mark"));
				mainTable.put("send_oq",1);
				mainTable.put("comfirm_flag", "Y");
				mainTable.put("ivt_oper_cfm", map.get("clerk_id"));
				mainTable.put("ivt_oper_cfm_time", nowdate);
				mainTable.put("mainten_clerk_id", map.get("clerk_id"));
				mainTable.put("mainten_datetime", nowdate);
				mainTable.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
				mainTable.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
				mainTable.put("Bill_type", "生产作业进度");
				mainTable.put("finacial_datetime", nowdate);
				mainTable.put("Main_plan_begin", map.get("send_date"));
				mainTable.put("Main_plan_end", map.get("plan_end_date"));
				mainTable.put("demand_type", getDemand_type());
				mainTable.put("dept_id", map.get("dept_id"));
				mainTable.put("clerk_id", map.get("clerk_id"));
				customerDao.insertSql(getInsertSql("YieM02010", mainTable));
			}
		}
		
		//生产计划从表
		if (jsons.size()>0) {
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				Map<String, Object> fromTableMap = new HashMap<String, Object>();
				String PH = "";
				if(json.has("PH")){
					PH = json.getString("PH");
					Integer PHNum = productionManagementDao.getPHNum(PH);
					if(PHNum>0){
						PH = map.get("ivt_oper_listing").toString().substring(5,16) 
								+ productionManagementDao.getPHTail(map.get("com_id").toString(),map.get("ivt_oper_listing").toString());
					}
				}else{
					PH = map.get("ivt_oper_listing").toString().substring(5,16) 
							+ productionManagementDao.getPHTail(map.get("com_id").toString(),map.get("ivt_oper_listing").toString());
				}
				
				String customer_id="";
//				Map<String, Object> customerMap = null;
				if(StringUtils.isNotBlank(json.getString("customer_id"))){
					customer_id = json.getString("customer_id");
//					customerMap = customerDao.getCustomerByCustomer_id(customer_id, map.get("com_id").toString());
				}
				fromTableMap.put("com_id", map.get("com_id"));
				fromTableMap.put("ivt_oper_listing", map.get("ivt_oper_listing"));
				fromTableMap.put("sd_order_id", map.get("sd_order_id"));
				fromTableMap.put("PH", PH);
				if(ConfigFile.PlanSource!=2){
					Map<String, Object> prodInfo = productionManagementDao.getProdInfoByItemId(json.getString("item_id").toString(),
							map.get("com_id").toString());
					fromTableMap.put("item_id", prodInfo.get("item_id"));
					fromTableMap.put("item_name", prodInfo.get("item_name"));
					fromTableMap.put("unit_id", prodInfo.get("item_unit"));
					fromTableMap.put("cYS", prodInfo.get("item_color"));
					fromTableMap.put("cGG", prodInfo.get("item_type"));
					fromTableMap.put("cXH", prodInfo.get("item_spec"));
				}else{
					fromTableMap.put("item_id", json.get("item_id"));
				}
				
				if(json.has("JHSL")){
					fromTableMap.put("JHSL", new BigDecimal(json.getString("JHSL").toString()));
				}
				fromTableMap.put("XQLX", getDemand_type());
				if (json.has("auto_mps_id")) {
					fromTableMap.put("auto_mps_id", json.getString("auto_mps_id"));
				}
				if(json.has("mps_id")){
					fromTableMap.put("mps_id", json.getString("mps_id"));
				}
				if(json.has("orderNo")){
					fromTableMap.put("auto_mps_id", json.getString("orderNo"));
					fromTableMap.put("mps_id", json.getString("orderNo"));
				}
				if(json.has("mps_seeds_id")){
					fromTableMap.put("mps_seeds_id", Integer.parseInt(json.getString("mps_seeds_id").toString()));
				}
				if(json.has("seeds_id")){
					fromTableMap.put("seeds_id", Integer.parseInt(json.getString("seeds_id").toString()));
				}
				fromTableMap.put("customer_id", customer_id);
//				if(customerMap!=null){
//					fromTableMap.put("CusName", customerMap.get("corp_name"));
//				}
				if(json.has("JHSL")){
					fromTableMap.put("send_qty", new BigDecimal(json.getString("JHSL").toString()));
				}
				
				if(json.has("c_memo")||
				json.has("memo_color")||
				json.has("memo_other")){
					fromTableMap.put("if_anomaly", "异形");
					fromTableMap.put("c_edition", "异形");
				}else if(ConfigFile.PlanSource==2){
					fromTableMap.put("if_anomaly", "定制");
					fromTableMap.put("c_edition", "定制");
				}else{
					fromTableMap.put("if_anomaly", "标准");
					fromTableMap.put("c_edition", "标准");
				}
				if(json.has("c_memo")){
					fromTableMap.put("c_memo", json.getString("c_memo").toString());
				}
				if(json.has("memo_color")){
					fromTableMap.put("memo_color", json.getString("memo_color").toString());
				}
				if(json.has("memo_other")){
					fromTableMap.put("memo_other", json.getString("memo_other").toString());
				}
				fromTableMap.put("status", "0");
				customerDao.insertSql(getInsertSql("YieM02011", fromTableMap));
				////将生产计划编号更新到order从表中//
				map.put("st_auto_no", ivt_oper_listing);
				map.put("item_id", json.get("item_id"));
				map.put("orderNo", json.get("orderNo"));
				employeeDao.updateOrderPurchasing(map);
				///保存生产计划历史///
				savePMHistory(ivt_oper_listing,json.get("item_id"),"产品已经下计划等待派工");
			}
		}
		//发送微信消息
		StringBuffer msg = new StringBuffer();
		try {
			msg.append("生产计划单号：").append(map.get("ivt_oper_listing")).append("\n");
			/*msg.append("排产编号：").append(getMsg(fromTableMap, "PH")).append("\n");
					msg.append("产品：").append(getMsg(prodInfo, "item_name")).append("【").append(getMsg(prodInfo, "item_id")).append("】").append("\n");
					if(json.getString("JHSL")!=null){
						msg.append("计划数量：").append(Double.valueOf(json.getString("JHSL").toString())).append("\n");
					}
					if(nowdate!=null){
						msg.append("计划日期：").append(nowdate.toString().substring(0,10)).append("\n");
					}
					msg.append("交货日期：").append(getMsg(map, "plan_end_date").length()>=10
							?getMsg(map, "plan_end_date").substring(0,10):getMsg(map, "plan_end_date")).append("\n");
					if(ConfigFile.PlanPush ==1){
						HashMap<String, Object> mapQry = new HashMap<String, Object>();
						mapQry.put("com_id", map.get("com_id"));
						mapQry.put("No_serial", 1);
						mapQry.put("work_type", prodInfo.get("work_type"));
						Map<String, Object> processMap = productionManagementDao.getProductionProcessByNoSerial(mapQry);
						if(processMap.get("work_id")!=null && processMap.get("work_name")!=null){
							msg.append("工序：").append(getMsg(processMap, "work_id")).append("【").append(getMsg(processMap, "work_name")).append("】").append("\n");
						}
					}
					if(json.getString("c_memo")!=null){
						msg.append("制造要求：").append(json.getString("c_memo").toString()).append("\n");
					}
					if(json.getString("memo_color")!=null){
						msg.append("工艺要求：").append(json.getString("memo_color").toString()).append("\n");
					}
					if(json.getString("memo_other")!=null){
						msg.append("其他要求：").append(json.getString("memo_other").toString()).append("\n");
					}*/
		} catch (Exception e) {
			msg = new StringBuffer();
			e.printStackTrace();
		}
		Map<String, Object> msgMap = new HashMap<String, Object>();
		msgMap.put("title", "你有新的派工任务需要处理");
		msgMap.put("description", msg);
		msgMap.put("url", "pm/toDispatchingWork.do?ivt_oper_listing="+ivt_oper_listing);
		msgMap.put("headship", "计调员");
		msgMap.put("processName", "派工");
		msgMap.put("dept_id", map.get("dept_id"));
		sendMSG(msgMap);
	}
	/***
	 * 保存生产计划历史
	 * @param pmNo 生产计划编号
	 * @param item_id 产品编号
	 * @param content 历史内容
	 */
	private void savePMHistory(Object pmNo, Object item_id,
			String content) {
		// TODO Auto-generated method stub
		//获取生产计划历史消息文件路径
		String path=getPMHistoryPath(pmNo,item_id);
		saveFile(path, content, true);
	}
	
	/**
	 * 查询所有已增加生产计划
	 */
	@Override
	public PageList<Map<String, Object>> getProductionPlanInfo(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if(map.get("pageRecord")!=null){
			pageRecord = Integer.valueOf(map.get("pageRecord").toString());
		}
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionManagementDao.getProductionPlanInfoCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=productionManagementDao.getProductionPlanInfoList(map);
		
		pages.setRows(list);
		return pages;
	}
	@Override
	public PageList<Map<String, Object>> getProductionPlanTailorInfo(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if(map.get("pageRecord")!=null){
			pageRecord = Integer.valueOf(map.get("pageRecord").toString());
		}
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productionManagementDao.getProductionPlanTailorInfoCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=productionManagementDao.getProductionPlanTailorInfo(map);
		
		pages.setRows(list);
		return pages;
	}
	/**
	 * 删除生产计划
	 * @param jsons
	 * @param map
	 */
	@Override
	public void delProductionPlan(JSONArray jsons, Map<String, Object> map) {
		String com_id = map.get("com_id").toString();
		if (jsons.size()>0) {
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				Map<String,Object> delMap = new HashMap<String, Object>();
				delMap.put("com_id", com_id);
				delMap.put("seeds_id", json.getString("seeds_id"));
				productionManagementDao.delProductionPlan(delMap);
			}
		}
	}
	
	/**
	 * 作废生产计划
	 * @param jsons
	 * @param map
	 */
	@Override
	public void unuseProductionPlan(Map<String, Object> map) {
		productionManagementDao.unuseProductionPlan(map);
	}

	/**
	 * 获取工序
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getProductionProcessInfo(Map<String, Object> map) {
		return productionManagementDao.getProductionProcessInfo(map);
	}
	
	/**
	 *  获取当前工段最大工序号
	 * @param map
	 * @return
	 */
	@Override
	public Double getMaxNoSerial(Map<String, Object> map) {
		return productionManagementDao.getMaxNoSerial(map);
	}

	/**
	 * 增加工序
	 * @param map
	 */
	@Override
	public String addProductionProcessInfo(Map<String, Object> map) {
		//1.判断sort_id是否存在
		String work_id = "";
		if (isNotMapKeyNull(map, "sort_id")) {
			//1.1存在执行更新
			//1.1.1判断更新类型-上下移动
			//1.1.2数据更新
			managerDao.insertSql(getUpdateSql(map, "B_001", "sort_id", map.get("sort_id").toString()));
//			productionManagementDao.updateProductionProcessInfo(map);
		}else{
			//1.2不存在执行插入
			Integer maxID = productionManagementDao.getProductionProcessMaxID(map);
			if(null == maxID){
				maxID = 1;
			}else{
				maxID = maxID + 1;
			}
			work_id = "WK"+String.format("%04d",maxID);
			map.put("sort_id", work_id);
			if (isMapKeyNull(map, "work_id")) {
				map.put("work_id", work_id);
			}
			customerDao.insertSql(getInsertSql("B_001", map));
		}
		
		
//		Map<String,Object> process = productionManagementDao.getProductionProcessByNoSerial(map);
//		Map<String,Object> insertMap = new HashMap<String, Object>();
//		if(process != null){
//			productionManagementDao.updateProductionProcessInfo(map);
//			work_id = process.get("work_id").toString();
//		}else{
//			Integer maxID = productionManagementDao.getProductionProcessMaxID(map);
//			if(null == maxID){
//				maxID = 1;
//			}else{
//				maxID = maxID + 1;
//			}
//			work_id = "WK"+String.format("%04d",maxID);
//			insertMap.put("com_id", map.get("com_id"));
//			insertMap.put("sort_id", work_id);
//			insertMap.put("work_id", work_id);
//			insertMap.put("work_name", map.get("work_name"));
//			insertMap.put("No_serial", map.get("No_serial"));
//			insertMap.put("work_type", map.get("work_type"));
//			insertMap.put("working_procedure_section", map.get("working_procedure_section"));
//			customerDao.insertSql(getInsertSql("B_001", insertMap));	
//		}
		return work_id;
	}

	/**
	 * 删除工序
	 * @param map
	 */
	@Override
	public void delProductionProcessInfo(Map<String, Object> map) {
		productionManagementDao.delProductionProcessInfo(map);
	}
	
	/**
	 * 移动工序
	 * @param map
	 */
	@Override
	public void moveProductionProcessInfo(Map<String, Object> map) {
		productionManagementDao.moveProductionProcessInfo(map);
	}
	
	/**
	 * 获取生产计划
	 * @param map
	 * @return
	 */
	@Override
	public Map<String, Object> getProductionPlanning(Map<String, Object> map) {
		return productionManagementDao.getProductionPlanning(map);
	}
	
	/**
	 * 获取paigong_id
	 */
	@Override
	public String getPaiGongID(Map<String, Object> map) {
		return getOrderNo(customerDao, "派工单", map.get("com_id").toString()).toString();
	}

	/**
	 * 查询已派工信息by排产编号
	 * @param map
	 * @return
	 */
	@Override
	public List<Object> getDispatchingWork(Map<String, Object> map) {
		return productionManagementDao.getDispatchingWork(map);
	}

	/**
	 * 生产派工
	 * @param jsons
	 * @param map
	 */
	@Override
	public void addProductionProcess(Map<String, Object> map) {
		
		SimpleDateFormat formattime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		
		String ivt_oper_listing = getOrderNo(customerDao, "生产作业单", map.get("com_id").toString()).toString();
		
		//获取生产计划
		Map<String, Object> productionPlanningMap = productionManagementDao.getProductionPlanning(map);
		//获取产品信息
		Map<String,Object> prodMap = productionManagementDao.getProdInfoByItemId(productionPlanningMap.get("item_id").toString(),
				map.get("com_id").toString());
		//通过派工单号查询生产流程卡主表信息
		Map<String, Object> dispatchingWorkMain = productionManagementDao.getDispatchingWorkMain(map);
		
		if(dispatchingWorkMain==null&&map.get("seeds_id")==null){
			//生产生产计划主表信息
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("send_date", productionPlanningMap.get("send_date"));
			mainMap.put("plan_end_date", productionPlanningMap.get("plan_end_date"));
			mainMap.put("dept_id", map.get("dept_id"));
			mainMap.put("clerk_id", map.get("clerk_id"));
			mainMap.put("auto_mps_id", productionPlanningMap.get("auto_mps_id"));
			mainMap.put("mps_id", productionPlanningMap.get("mps_id"));
			mainMap.put("item_id", productionPlanningMap.get("item_id"));
			mainMap.put("peijian_id", prodMap.get("peijian_id"));
			mainMap.put("batch_mark", productionPlanningMap.get("batch_mark"));
			mainMap.put("send_oq", productionPlanningMap.get("JHSL"));
			mainMap.put("comfirm_flag", "Y");
			mainMap.put("ivt_oper_cfm", map.get("clerk_id"));
			mainMap.put("ivt_oper_cfm_time", nowdate);
			mainMap.put("mainten_clerk_id", map.get("clerk_id"));
			mainMap.put("mainten_datetime", nowdate);
			mainMap.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			mainMap.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));		
			mainMap.put("auto_paigong_id", map.get("auto_paigong_id"));
			mainMap.put("paigong_id", map.get("paigong_id"));
			mainMap.put("Bill_type", "生产作业单");
			mainMap.put("mps_seeds_id", productionPlanningMap.get("mps_seeds_id"));
			mainMap.put("allsend_oq", 0);
			mainMap.put("demand_type", productionPlanningMap.get("demand_type"));
			mainMap.put("auto_PGDBH", productionPlanningMap.get("ivt_oper_listing"));
			mainMap.put("PGDBH", productionPlanningMap.get("sd_order_id"));
			mainMap.put("PH", map.get("PH"));
			customerDao.insertSql(getInsertSql("YieM02030", mainMap));
		}
		
		//如果存在seeds_id，视为修改派工任务
		if(map.get("seeds_id")!=null){
			productionManagementDao.editDispatchingWork(map);
		}else {
			//生产生产计划从表信息
			dispatchingWorkMain = productionManagementDao.getDispatchingWorkMain(map);
			Map<String, Object> fromMap = new HashMap<String, Object>();
			fromMap.put("com_id", map.get("com_id"));
			fromMap.put("ivt_oper_listing", dispatchingWorkMain.get("ivt_oper_listing"));
			fromMap.put("sd_order_id", dispatchingWorkMain.get("sd_order_id"));
			fromMap.put("JJSJ", "");
			fromMap.put("JCGXID", map.get("work_id"));
			fromMap.put("JHGR", map.get("JHGR"));
			fromMap.put("Item_ID", productionPlanningMap.get("item_id"));				
			fromMap.put("Item_Name", prodMap.get("item_name"));
			fromMap.put("PH", productionPlanningMap.get("PH"));	
			fromMap.put("unit_id", productionPlanningMap.get("unit_id"));
			fromMap.put("JJSL", 0);
			fromMap.put("cYS", productionPlanningMap.get("cYS"));
			fromMap.put("cPP", productionPlanningMap.get("cPP"));
			fromMap.put("cGG", productionPlanningMap.get("cGG"));
			fromMap.put("customer_id", productionPlanningMap.get("customer_id"));
			fromMap.put("if_anomaly", productionPlanningMap.get("if_anomaly"));
			fromMap.put("c_memo", productionPlanningMap.get("c_memo"));
			fromMap.put("memo_color", productionPlanningMap.get("memo_color"));
			fromMap.put("memo_other", productionPlanningMap.get("memo_other"));
			fromMap.put("PGSL", map.get("PGSL"));	
			fromMap.put("PGSJ", nowdate);
			fromMap.put("WGSJ", map.get("WGSJ")); 		
			fromMap.put("status", "0");
			fromMap.put("mainTable_seeds_ID", dispatchingWorkMain.get("seeds_id"));
			customerDao.insertSql(getInsertSql("YieM02031", fromMap));
			//修改生产计划从表状态为生产中
			productionManagementDao.updateYieM02031Status(fromMap);
		}
	}
	
	/**
	 * 删除派工
	 * @param map
	 */
	@Override
	public void delDispatchingWork(Map<String, Object> map) {
		productionManagementDao.delDispatchingWork(map);
	}
	
	/**
	 * 作废派工
	 * @param map
	 */
	@Override
	public void unusedDispatchingWork(Map<String, Object> map) {
		productionManagementDao.unusedDispatchingWork(map);
	}
	
	/**
	 * 生产派工微信通知
	 */
	@Override
	public void dispatchingWorkSendInfo(Map<String, Object> map) {
		List<Object> list = productionManagementDao.getDispatchingWork(map);
		JSONArray jsons = JSONArray.fromObject(list);
		if(jsons.size()>0){
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				String status = json.getString("status");
				String JHGR = json.getString("JHGR");
				if(status!=null && status.equals("0")){
					if(JHGR!=null){
						//发送微信消息
						StringBuffer msg = new StringBuffer();
						try {
							msg.append("排产编号：").append(json.getString("PH")).append("\n");
							msg.append("派工单号：").append(json.getString("paigong_id")).append("\n");
							msg.append("产品：").append(json.getString("item_name")).append("【").append(json.getString("Item_ID")).append("】").append("\n");
							if(json.getString("JCGXID") != null){
								HashMap<String, Object> mapQry = new HashMap<String, Object>();
								mapQry.put("com_id", map.get("com_id"));
								mapQry.put("work_id", json.getString("JCGXID"));
								mapQry.put("work_type", json.getString("work_type"));
								Map<String, Object> processMap = productionManagementDao.getProductionProcessByWorkID(mapQry);
								if(processMap.get("work_id")!=null && processMap.get("work_name")!=null){
									msg.append("工序：").append(getMsg(processMap, "work_id")).append("【").append(getMsg(processMap, "work_name")).append("】").append("\n");
								}
							}
							if(json.getString("PGSL")!=null){
								msg.append("派工数量：").append(Double.valueOf(json.getString("PGSL").toString())).append("\n");
							}
							if(json.getString("WGSJ")!=null && json.getString("WGSJ").toString()!=""){
								msg.append("要求完工时间：").append(json.getString("WGSJ_10")).append("\n");
							}
							msg.append("制造要求：").append(json.getString("c_memo")).append("\n");
							msg.append("工艺要求：").append(json.getString("memo_color")).append("\n");
							msg.append("其他要求：").append(json.getString("memo_other")).append("\n");
						} catch (Exception e) {
							msg = new StringBuffer();
							e.printStackTrace();
						}
						Map<String, Object> msgMap = new HashMap<String, Object>();
						msgMap.put("title", "你有新的生产任务需要处理，详细如下：");
						msgMap.put("msg", msg);
						msgMap.put("url", "pm/informQC.do");
						msgMap.put("headship", "");
						msgMap.put("clerk_id", json.getString("JHGR").toString());
						msgMap.put("work_id", "");
						sendMSG(msgMap);
					}
				}
			}
		}
	}
	
	/**
	 * 待通知质检项查询
	 */
	@Override
	public List<Object> getInformQC(Map<String, Object> map) {
		return productionManagementDao.getInformQC(map);
	}
	
	/**
	 * 开始生产
	 */
	@Override
	public void beginWork(Map<String, Object> map) {
		productionManagementDao.beginWork(map);
	}
	
	/**
	 * 通知质检
	 */
	@Override
	public void sendInformQC(Map<String, Object> map) {
		//查询条件
		HashMap<String, Object> mapQry = new HashMap<String, Object>();
		mapQry.put("seeds_id", map.get("seeds_id"));
		mapQry.put("com_id", map.get("com_id"));
		mapQry.put("PH", map.get("PH"));
		mapQry.put("item_id", map.get("item_id"));
		mapQry.put("work_id", map.get("work_id"));
		mapQry.put("work_type", map.get("work_type"));
		mapQry.put("No_serial", map.get("No_serial"));
				
		//获取产品信息【com_id、item_id】
		Map<String,Object> prodMap = productionManagementDao.getProdInfoByItemId(map.get("item_id").toString(),map.get("com_id").toString());
		
		//获取生产计划【com_id、PH】
		Map<String, Object> productionPlan = productionManagementDao.getProductionPlanning(mapQry);
		System.out.println("生产计划：");
		System.out.println(productionPlan);
				
		//获取当前派工单【com_id、seeds_id】
		Map<String, Object> dispatchingWork = productionManagementDao.getDispatchingWorkBySeedsID(mapQry);
		System.out.println("生产派工单：");
		System.out.println(dispatchingWork);
				
		//获取当前工序【com_id、work_type、work_id】
		Map<String, Object> nowProcess = productionManagementDao.getProductionProcessByWorkID(mapQry);
		System.out.println("当前工序：");
		System.out.println(nowProcess);
				
		//获取最后一道工序【com_id、work_type、No_serial】
		Double maxNoSerial = productionManagementDao.getMaxNoSerial(mapQry);
		Map<String, Object> lastProcess = null;
		if(maxNoSerial!=null){
			mapQry.put("No_serial", maxNoSerial);
			lastProcess = productionManagementDao.getProductionProcessByNoSerial(mapQry);
			mapQry.put("No_serial", nowProcess.get("No_serial"));
		}
		System.out.println("最后一道工序：");
		System.out.println(lastProcess);
				
		//获取下一工序【com_id、work_type、No_serial】
		Map<String, Object> nextProcess = null;
		if(!nowProcess.get("work_id").toString().equals(lastProcess.get("work_id").toString())){
			mapQry.put("No_serial", Double.valueOf(nowProcess.get("No_serial").toString())+1);
			nextProcess = productionManagementDao.getProductionProcessByNoSerial(mapQry);
			mapQry.put("No_serial", nowProcess.get("No_serial"));
		}
		System.out.println("下一工序：");
		System.out.println(nextProcess);
		
		if(ConfigFile.QCWay == 0){
			//下工序质检上工序
			System.out.println("下工序质检上工序");
			
			//非最后一道工序，微信消息推送给下一工序
			if(!nowProcess.get("work_id").equals(lastProcess.get("work_id"))){
				//微信推送消息给下工序员工
				System.out.println("微信推送消息给下工序员工");
				StringBuffer msg = new StringBuffer();
				try {
					msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
					msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
					msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
					msg.append("工序：").append(getMsg(nowProcess, "work_id")).append("【").append(getMsg(nowProcess, "work_name")).append("】").append("\n");
					msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
					msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
							?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
							:getMsg(dispatchingWork, "WGSJ")).append("\n");
					msg.append("制造要求：").append(getMsg(dispatchingWork, "c_memo")).append("\n");
					msg.append("工艺要求：").append(getMsg(dispatchingWork, "memo_color")).append("\n");
					msg.append("其他要求：").append(getMsg(dispatchingWork, "memo_other")).append("\n");
				} catch (Exception e) {
					msg = new StringBuffer();
					e.printStackTrace();
				}
				Map<String, Object> msgMap = new HashMap<String, Object>();
				msgMap.put("title", "你有新的质检任务需要处理，详细如下：");
				msgMap.put("msg", msg);
				msgMap.put("url", "pm/qualityTesting.do?seeds_id="+map.get("seeds_id").toString());
				msgMap.put("headship", "");
				msgMap.put("clerk_id", "");
				msgMap.put("work_id", nextProcess.get("work_id"));
				sendMSG(msgMap);
			}
		}else {
			//专业人员质检
			System.out.println("专业人员质检");
			
			//微信推送消息给专业质检员
			System.out.println("微信推送消息给专业质检员");
			StringBuffer msg = new StringBuffer();
			try {
				msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
				msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
				msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
				msg.append("工序：").append(getMsg(nowProcess, "work_id")).append("【").append(getMsg(nowProcess, "work_name")).append("】").append("\n");
				msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
				msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
						?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
						:getMsg(dispatchingWork, "WGSJ")).append("\n");
				msg.append("制造要求：").append(getMsg(dispatchingWork, "c_memo")).append("\n");
				msg.append("工艺要求：").append(getMsg(dispatchingWork, "memo_color")).append("\n");
				msg.append("其他要求：").append(getMsg(dispatchingWork, "memo_other")).append("\n");
			} catch (Exception e) {
				msg = new StringBuffer();
				e.printStackTrace();
			}
			Map<String, Object> msgMap = new HashMap<String, Object>();
			msgMap.put("title", "你有新的质检任务需要处理，详细如下：");
			msgMap.put("msg", msg);
			msgMap.put("url", "pm/qualityTesting.do?seeds_id="+map.get("seeds_id").toString());
			msgMap.put("headship", "质检员");
			msgMap.put("clerk_id", "");
			msgMap.put("work_id", "");
			sendMSG(msgMap);
		}
	}
	
	/**
	 * 质检查询
	 */
	@Override
	public List<Object> getQualityTesting(Map<String, Object> map) {
		return productionManagementDao.getQualityTesting(map);
	}
	
	/**
	 * 通过com_id、seeds_id获取派工信息
	 */
	@Override
	public Map<String, Object> getDispatchingWorkBySeedsID(
			Map<String, Object> map) {
		return productionManagementDao.getDispatchingWorkBySeedsID(map);
	}

	/**
	 * 质检
	 */
	@Override
	public void qualityTest(Map<String, Object> map) {
		SimpleDateFormat formattime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		
		//将质检结果更新到派工单
		map.put("JJSJ", nowdate);
		productionManagementDao.qualityTest(map);
		
		//查询条件
		HashMap<String, Object> mapQry = new HashMap<String, Object>();
		mapQry.put("seeds_id", map.get("seeds_id"));
		mapQry.put("com_id", map.get("com_id"));
		mapQry.put("PH", map.get("PH"));
		mapQry.put("item_id", map.get("item_id"));
		mapQry.put("work_id", map.get("work_id"));
		mapQry.put("work_type", map.get("work_type"));
		mapQry.put("No_serial", map.get("No_serial"));
				
		//获取产品信息【com_id、item_id】
		Map<String,Object> prodMap = productionManagementDao.getProdInfoByItemId(map.get("item_id").toString(),map.get("com_id").toString());
		
		//获取生产计划【com_id、PH】
		Map<String, Object> productionPlan = productionManagementDao.getProductionPlanning(mapQry);
		System.out.println("生产计划：");
		System.out.println(productionPlan);
				
		//获取当前派工单【com_id、seeds_id】
		Map<String, Object> dispatchingWork = productionManagementDao.getDispatchingWorkBySeedsID(mapQry);
		System.out.println("生产派工单：");
		System.out.println(dispatchingWork);
				
		//获取当前工序【com_id、work_type、work_id】
		Map<String, Object> nowProcess = productionManagementDao.getProductionProcessByWorkID(mapQry);
		System.out.println("当前工序：");
		System.out.println(nowProcess);
				
		//获取最后一道工序【com_id、work_type、No_serial】
		Double maxNoSerial = productionManagementDao.getMaxNoSerial(mapQry);
		Map<String, Object> lastProcess = null;
		if(maxNoSerial!=null){
			mapQry.put("No_serial", maxNoSerial);
			lastProcess = productionManagementDao.getProductionProcessByNoSerial(mapQry);
			mapQry.put("No_serial", nowProcess.get("No_serial"));
		}
		System.out.println("最后一道工序：");
		System.out.println(lastProcess);
				
		//获取下一工序【com_id、work_type、No_serial】
		Map<String, Object> nextProcess = null;
		if(!nowProcess.get("work_id").toString().equals(lastProcess.get("work_id").toString())){
			mapQry.put("No_serial", Double.valueOf(nowProcess.get("No_serial").toString())+1);
			nextProcess = productionManagementDao.getProductionProcessByNoSerial(mapQry);
			mapQry.put("No_serial", nowProcess.get("No_serial"));
		}
		System.out.println("下一工序：");
		System.out.println(nextProcess);
		
		//获取当前工序总完工数量【com_id、PH、work_id】		
		Double nowJjslAll = productionManagementDao.getJJSLALL(mapQry);
		System.out.println("当前工序总完工数量：");
		System.out.println(nowJjslAll);
				
		//获取下一工序总完工数量【com_id、PH、work_id】
		Double nextJjslAll = null;
		if(nextProcess!=null){
			mapQry.put("work_id", nextProcess.get("work_id"));
			nextJjslAll = productionManagementDao.getJJSLALL(mapQry);
			mapQry.put("work_id", nowProcess.get("work_id"));
		}
		System.out.println("下一工序总完工数量：");
		System.out.println(nextJjslAll);
		
		//判断当前工序是否完工
		if((Double.valueOf(productionPlan.get("JHSL").toString()) - nowJjslAll) < 0.0001){
			//已完工
			System.out.println("当前工序已完工");
			
			if(ConfigFile.PlanPush == 0){
				//离散型企业
				System.out.println("离散型企业");
				
				//计算各工序完工数量【com_id、PH】
				List<Map<String, Object>> eachProcessJJSLALL = productionManagementDao.getEachProcessJJSLALL(mapQry);
				System.out.println("各工序完工数量：");
				System.out.println(eachProcessJJSLALL);
				Integer falishFlag = 1;
				for (int i =0 ; i<eachProcessJJSLALL.size(); i++) {
					if(Double.valueOf(productionPlan.get("JHSL").toString()) 
							- Double.valueOf(eachProcessJJSLALL.get(i).get("JJSL_All").toString()) > 0.0001){
						falishFlag = 0;
						break;
					}
				}  
				
				if(falishFlag == 0){
					//未完工
					System.out.println("未完工");
					
					//微信消息推送到当前工序工人
					System.out.println("微信消息推送到当前工序工人");
					StringBuffer msg = new StringBuffer();
					try {
						msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
						msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
						msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
						msg.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
						msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
						msg.append("完工数量：").append(Double.valueOf(getMsg(dispatchingWork, "JJSL"))).append("\n");
						msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
								?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
								:getMsg(dispatchingWork, "WGSJ")).append("\n");
						msg.append("实际完工日期：").append(nowdate.substring(0, 10)).append("\n");
					} catch (Exception e) {
						msg = new StringBuffer();
						e.printStackTrace();
					}
					Map<String, Object> msgMap = new HashMap<String, Object>();
					msgMap.put("title", "你提请质检的结果如下：");
					msgMap.put("msg", msg);
					msgMap.put("url", "pm/informQC.do");
					msgMap.put("headship", "");
					msgMap.put("clerk_id", dispatchingWork.get("JHGR").toString());
					msgMap.put("work_id", "");
					sendMSG(msgMap);
				}else{
					//已完工
					System.out.println("已完工");
					
					//更新生产计划已完工数量为计划数量【com_id、PH、JHSL】
					Map<String, Object> allsend_oq = new HashMap<String, Object>();
					allsend_oq.put("com_id", mapQry.get("com_id"));
					allsend_oq.put("PH", mapQry.get("PH"));
					allsend_oq.put("allsend_oq", productionPlan.get("JHSL"));
					productionManagementDao.updateAllsendOQ(allsend_oq);
					
					//生产入库
					System.out.println("入库");
					RK(prodMap,productionPlan);
					
					
					//微信消息推送到当前工序工人
					System.out.println("微信消息推送到当前工序工人");
					StringBuffer msg = new StringBuffer();
					try {
						msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
						msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
						msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
						msg.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
						msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
						msg.append("完工数量：").append(Double.valueOf(getMsg(dispatchingWork, "JJSL"))).append("\n");
						msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
								?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
								:getMsg(dispatchingWork, "WGSJ")).append("\n");
						msg.append("实际完工日期：").append(nowdate.substring(0, 10)).append("\n");
					} catch (Exception e) {
						msg = new StringBuffer();
						e.printStackTrace();
					}
					Map<String, Object> msgMap = new HashMap<String, Object>();
					msgMap.put("title", "你提请质检的结果如下：");
					msgMap.put("msg", msg);
					msgMap.put("url", "pm/informQC.do");
					msgMap.put("headship", "pm/informQC.do");
					msgMap.put("clerk_id", dispatchingWork.get("JHGR").toString());
					msgMap.put("work_id", "");
					sendMSG(msgMap);
				}
			}else {
				//流程型企业
				System.out.println("流程型企业");
				
				if(nowProcess.get("work_id").toString().equals(lastProcess.get("work_id").toString())){
					//最后一道工序
					System.out.println("最后一道工序");
					
					//更新生产计划完工数量
					Map<String, Object> allsend_oq = new HashMap<String, Object>();
					allsend_oq.put("com_id", mapQry.get("com_id"));
					allsend_oq.put("PH", mapQry.get("PH"));
					allsend_oq.put("allsend_oq", productionPlan.get("JHSL"));
					productionManagementDao.updateAllsendOQ(allsend_oq);
					
					//生产入库
					System.out.println("入库");
					RK(prodMap,productionPlan);
					
					//微信消息推送到当前工序工人
					System.out.println("微信消息推送到当前工序工人");
					StringBuffer msg = new StringBuffer();
					try {
						msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
						msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
						msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
						msg.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
						msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
						msg.append("完工数量：").append(Double.valueOf(getMsg(dispatchingWork, "JJSL"))).append("\n");
						msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
								?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
								:getMsg(dispatchingWork, "WGSJ")).append("\n");
						msg.append("实际完工日期：").append(nowdate.substring(0, 10)).append("\n");
					} catch (Exception e) {
						msg = new StringBuffer();
						e.printStackTrace();
					}
					Map<String, Object> msgMap = new HashMap<String, Object>();
					msgMap.put("title", "你提请质检的结果如下：");
					msgMap.put("msg", msg);
					msgMap.put("url", "pm/informQC.do");
					msgMap.put("headship", "");
					msgMap.put("clerk_id", dispatchingWork.get("JHGR").toString());
					msgMap.put("work_id", "");
					sendMSG(msgMap);
				}else {
					//非最后一道工序
					System.out.println("非最后一道工序");
					
					//获取下工序可派工数量
					Double nextJjsl = nowJjslAll;
					if(nextJjslAll!=null){
						nextJjsl = nowJjslAll - nextJjslAll;
						System.out.println("下工序可派工数量：");
						System.out.println(nextJjsl);
					}
					
					//微信消息推送到计调员
					System.out.println("微信消息推送到计调员");
					StringBuffer msg0 = new StringBuffer();
					try {
						msg0.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
						msg0.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
						msg0.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
						msg0.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
						msg0.append("计划数量：").append(Double.valueOf(getMsg(productionPlan, "JHSL"))).append("\n");
						msg0.append("可派工数量：").append(Double.valueOf(nextJjsl.toString())).append("\n");
						msg0.append("计划日期：").append(getMsg(productionPlan, "send_date").length()>=10
								?getMsg(productionPlan, "send_date").substring(0, 10)
								:getMsg(productionPlan, "send_date")).append("\n");
						msg0.append("完工日期：").append(getMsg(productionPlan, "plan_end_date").length()>=10
								?getMsg(productionPlan, "plan_end_date").substring(0, 10)
								:getMsg(productionPlan, "plan_end_date")).append("\n");
						msg0.append("制造要求：").append(getMsg(productionPlan, "c_memo")).append("\n");
						msg0.append("工艺要求：").append(getMsg(productionPlan, "memo_color")).append("\n");
						msg0.append("其他要求：").append(getMsg(productionPlan, "memo_other")).append("\n");
					} catch (Exception e) {
						msg0 = new StringBuffer();
						e.printStackTrace();
					}
					
					Map<String, Object> msgMap0 = new HashMap<String, Object>();
					msgMap0.put("title", "你有新的派工任务需要处理，详细如下：");
					msgMap0.put("msg", msg0);
					msgMap0.put("url", "pm/toDispatchingWork.do?PH="+productionPlan.get("PH").toString());
					msgMap0.put("headship", "计调员");
					msgMap0.put("clerk_id", "");
					msgMap0.put("work_id", "");
					sendMSG(msgMap0);
					
					//微信消息推送到当前工序工人
					System.out.println("微信消息推送到当前工序工人");
					StringBuffer msg = new StringBuffer();
					try {
						msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
						msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
						msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
						msg.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
						msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
						msg.append("完工数量：").append(Double.valueOf(getMsg(dispatchingWork, "JJSL"))).append("\n");
						msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
								?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
								:getMsg(dispatchingWork, "WGSJ")).append("\n");
						msg.append("实际完工日期：").append(nowdate.substring(0, 10)).append("\n");
					} catch (Exception e) {
						msg = new StringBuffer();
						e.printStackTrace();
					}
					Map<String, Object> msgMap = new HashMap<String, Object>();
					msgMap.put("title", "你提请质检的结果如下：");
					msgMap.put("msg", msg);
					msgMap.put("url", "pm/informQC.do");
					msgMap.put("headship", "");
					msgMap.put("clerk_id", dispatchingWork.get("JHGR").toString());
					msgMap.put("work_id", "");
					sendMSG(msgMap);
				}
			}
		}else {
			//未完工
			System.out.println("当前工序未完工");
			
			//获取下工序可派工数量
			Double nextJjsl = nowJjslAll;
			if(nextJjslAll!=null){
				nextJjsl = nowJjslAll - nextJjslAll;
			}
			System.out.println("下工序可派工数量：");
			System.out.println(nextJjsl);
			
			//微信消息推送到计调员
			System.out.println("微信消息推送到计调员");
			StringBuffer msg0 = new StringBuffer();
			try {
				msg0.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
				msg0.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
				msg0.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
				msg0.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
				msg0.append("计划数量：").append(Double.valueOf(getMsg(productionPlan, "JHSL"))).append("\n");
				msg0.append("可派工数量：").append(Double.valueOf(nextJjsl.toString())).append("\n");
				msg0.append("计划日期：").append(getMsg(productionPlan, "send_date").length()>=10
						?getMsg(productionPlan, "send_date").substring(0, 10)
						:getMsg(productionPlan, "send_date")).append("\n");
				msg0.append("完工日期：").append(getMsg(productionPlan, "plan_end_date").length()>=10
						?getMsg(productionPlan, "plan_end_date").substring(0, 10)
						:getMsg(productionPlan, "plan_end_date")).append("\n");
				msg0.append("制造要求：").append(getMsg(productionPlan, "c_memo")).append("\n");
				msg0.append("工艺要求：").append(getMsg(productionPlan, "memo_color")).append("\n");
				msg0.append("其他要求：").append(getMsg(productionPlan, "memo_other")).append("\n");
			} catch (Exception e) {
				msg0 = new StringBuffer();
				e.printStackTrace();
			}
			Map<String, Object> msgMap0 = new HashMap<String, Object>();
			msgMap0.put("title", "你有新的派工任务需要处理，详细如下：");
			msgMap0.put("msg", msg0);
			msgMap0.put("url", "pm/toDispatchingWork.do?PH="+productionPlan.get("PH").toString());
			msgMap0.put("headship", "计调员");
			msgMap0.put("clerk_id", "");
			msgMap0.put("work_id", "");
			sendMSG(msgMap0);
			
			//微信消息推送到当前工序工人
			System.out.println("微信消息推送到当前工序工人");
			StringBuffer msg = new StringBuffer();
			try {
				msg.append("排产编号：").append(getMsg(dispatchingWork, "PH")).append("\n");
				msg.append("派工单号：").append(getMsg(dispatchingWork, "paigong_id")).append("\n");
				msg.append("产品：").append(getMsg(prodMap, "item_name")).append("【").append(getMsg(prodMap, "item_id")).append("】").append("\n");
				msg.append("工序：").append(getMsg(nowProcess, "work_name")).append("【").append(getMsg(nowProcess, "work_id")).append("】").append("\n");
				msg.append("派工数量：").append(Double.valueOf(getMsg(dispatchingWork, "PGSL"))).append("\n");
				msg.append("完工数量：").append(Double.valueOf(getMsg(dispatchingWork, "JJSL"))).append("\n");
				msg.append("要求完工日期：").append(getMsg(dispatchingWork, "WGSJ").length()>=10
						?getMsg(dispatchingWork, "WGSJ").substring(0, 10)
						:getMsg(dispatchingWork, "WGSJ")).append("\n");
				msg.append("实际完工日期：").append(nowdate.substring(0, 10)).append("\n");
			} catch (Exception e) {
				msg = new StringBuffer();
				e.printStackTrace();
			}
			Map<String, Object> msgMap = new HashMap<String, Object>();
			msgMap.put("title", "你提请质检的结果如下：");
			msgMap.put("msg", msg);
			msgMap.put("url", "pm/informQC.do");
			msgMap.put("headship", "");
			msgMap.put("clerk_id", dispatchingWork.get("JHGR").toString());
			msgMap.put("work_id", "");
			sendMSG(msgMap);
		}
	}
	
	/**
	 * 获取工序树形
	 */
	@Override
	public List<Map<String, Object>> getWorkProcessTree(Map<String, Object> map) {
		return productionManagementDao.getProductionProcessInfo(map);
	}
	
	/**
	 * 获取工人树形
	 */
	@Override
	public List<Object> getWorkerTree(Map<String, Object> map) {
		return productionManagementDao.getWorkerTree(map);
	}

	/**
	 * 计算各工序完工数量
	 */
	@Override
	public List<Map<String, Object>> getEachProcessJJSLALL(Map<String, Object> map) {
		return productionManagementDao.getEachProcessJJSLALL(map);
	}
	
	/**
	 * 获取字符串消息
	 * @param map 参数对象
	 * @param fied 字段名
	 * @param preWord 前置文本
	 * @return
	 */
	private String getMsg(Map<String, Object> map,String fied){
		String msg = "";
		if(map!=null){
			if(fied!=null && !fied.toString().equals("")){
				if(map.get(fied)!=null){
					msg = map.get(fied).toString();
				}
			}
		}
		return msg;
	}
	
	/**
	 * 微信消息推送
	 * @param headship
	 * @param omrtype 订单消息发送类型
	 * @param orderStepRecipient 消息接收人员属性中是否参加
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
				map.put("processName", msgMap.get("orderStepRecipient"));
				map.put("dept_id", "%"+msgMap.get("dept_id")+"%");
				List<Map<String, String>> headshipList = employeeDao.getPersonnelNeiQing(map);
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", msgMap.get("title"));
				mapMsg.put("description",msgMap.get("description"));
				if (msgMap.get("url")!=null) {
					mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+msgMap.get("url").toString());
				}
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
				news.add(mapMsg);
				for (int i = 0; i < headshipList.size(); i++) {
					Map<String, String> item=headshipList.get(i);
					String add=msgMap.get("headship")+":"+item.get("clerk_name");
					String msg=add+news.get(0).get("title");
					news.get(0).put("title",msg);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						sendMessageNews(news,item.get("weixinID"));
					}
					news.get(0).put("title",msg.replaceAll(add, ""));
				}
			}
		} catch (Exception e) {
//			writeLog(getRequest(), "生产计划发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 入库
	 * @param prodMap 产品信息
	 * @param productionPlanMap 生产计划信息
	 */
	private void RK(Map<String, Object> prodMap, Map<String, Object> productionPlanMap) {
		SimpleDateFormat formattime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		String ivt_oper_listing = getOrderNo(customerDao, "生产入库", productionPlanMap.get("com_id").toString());
		
		if(prodMap!=null&&productionPlanMap!=null){
			//主表
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("com_id", productionPlanMap.get("com_id"));
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			mainMap.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			mainMap.put("ivt_oper_id", "入库");
			mainMap.put("store_date", nowdate);
			mainMap.put("comfirm_flag", "Y");
			mainMap.put("ivt_oper_cfm", productionPlanMap.get("ivt_oper_cfm"));
			mainMap.put("ivt_oper_cfm_time", nowdate);
			mainMap.put("mainten_clerk_id", productionPlanMap.get("mainten_clerk_id"));
			mainMap.put("maintenance_datetime", nowdate);
			customerDao.insertSql(getInsertSql("Yie04010", mainMap));
			
			//从表
			Map<String, Object> fromMap = new HashMap<String, Object>();
			fromMap.put("com_id", productionPlanMap.get("com_id"));	
			fromMap.put("ivt_oper_listing", ivt_oper_listing);
			fromMap.put("item_id", prodMap.get("item_id"));
			fromMap.put("unit_id", prodMap.get("item_unit"));
			fromMap.put("oper_oq", productionPlanMap.get("JHSL"));	
			fromMap.put("oper_price", prodMap.get("item_cost"));
			fromMap.put("oper_sum", 0); 			
			fromMap.put("store_struct_id", prodMap.get("store_struct_id"));												
			fromMap.put("auto_mps_id", productionPlanMap.get("auto_mps_id"));
			fromMap.put("mps_id", productionPlanMap.get("mps_id"));
			fromMap.put("PH", productionPlanMap.get("PH"));					
			fromMap.put("if_anomaly", productionPlanMap.get("if_anomaly"));
			fromMap.put("c_memo", productionPlanMap.get("c_memo"));
			fromMap.put("memo_color", productionPlanMap.get("memo_color"));
			fromMap.put("memo_other", productionPlanMap.get("memo_other"));
			fromMap.put("sid_id", productionPlanMap.get("mps_seeds_id"));
			customerDao.insertSql(getInsertSql("Yie04011", fromMap));
			
			//通过store_struct_id、item_id、auto_mps_id、sid_id更新库存信息
			Map<String, Object> storeMap = productionManagementDao.getStoreInfo(fromMap);
			if(storeMap!=null){
				productionManagementDao.updateStoreInfo(fromMap);
			}else {
				if(fromMap.get("store_struct_id")!=null
						&&!fromMap.get("store_struct_id").equals("")){
					storeMap = new HashMap<String, Object>();
					storeMap.put("com_id", fromMap.get("com_id"));
					storeMap.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
					storeMap.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
					storeMap.put("store_struct_id", fromMap.get("store_struct_id"));
					storeMap.put("item_id", fromMap.get("item_id"));
					storeMap.put("oh", 0);
					storeMap.put("i_price", prodMap.get("item_cost"));
					storeMap.put("accn_ivt", fromMap.get("oper_oq"));
					storeMap.put("maintenance_datetime", nowdate);
					storeMap.put("mps_seeds_id", fromMap.get("sid_id"));
					storeMap.put("mps_id", fromMap.get("auto_mps_id"));
					customerDao.insertSql(getInsertSql("ivtd01302", storeMap));
				}
			}
		}
	}
	
	/**
     * 删除单个文件
     * @param sPath被删除文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
	@Override
    public boolean deleteFile(String sPath) {
        boolean flag = false;
        File file = new File(sPath);
        //路径为文件且不为空则进行删除
        if (file.isFile() && file.exists()) {
            file.delete();
            flag = true;
        }
        return flag;
    }

	/**
     * 删除目录（文件夹）以及目录下的文件
     * @param   sPath被删除目录的文件路径
     * @return  目录删除成功返回true，否则返回false
     */
	@Override
    public boolean deleteDirectory(String sPath) {
        //如果sPath不以文件分隔符结尾，自动添加文件分隔符
        if (!sPath.endsWith(File.separator)) {
            sPath = sPath + File.separator;
        }
        File dirFile = new File(sPath);
        //如果对应的文件不存在，或者不是一个目录，则退出
        if (!dirFile.exists() || !dirFile.isDirectory()) {
            return false;
        }
        boolean flag = true;
        //删除文件夹下的所有文件(包括子目录)
        File[] files = dirFile.listFiles();
        for (int i = 0; i < files.length; i++) {
            //删除子文件
            if (files[i].isFile()) {
                flag = deleteFile(files[i].getAbsolutePath());
                if (!flag) break;
            } //删除子目录
            else {
                flag = deleteDirectory(files[i].getAbsolutePath());
                if (!flag) break;
            }
        }
        if (!flag) return false;
        //删除当前目录
        if (dirFile.delete()) {
            return true;
        } else {
            return false;
        }
    }
	
	/**
     * 获取目录下的所有文件名
     * @param sPath目录的路径
     * @return List
     */
	@Override
    public List<String> getFileName(String sPath) {
		List<String> list = new ArrayList<String>();
		//如果sPath不以文件分隔符结尾，自动添加文件分隔符
        if(!sPath.endsWith(File.separator)){
            sPath = sPath + File.separator;
        }
        File dirFile = new File(sPath);
        if(!dirFile.exists() || !dirFile.isDirectory()){
            return list;
        }
        //获取文件夹下的所有文件
        File[] files = dirFile.listFiles();
        for(int i = 0; i < files.length; i++){
            if(files[i].isFile()){
                list.add(files[i].getName());
            }
        }
        return list;
    }
///////////////////////////////////////////////////	
 
}
