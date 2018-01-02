package com.qianying.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IManagerDAO;
import com.qianying.dao.interfaces.IOperatorsDAO;
import com.qianying.dao.interfaces.SqlExecDao;
import com.qianying.page.PageList;
import com.qianying.service.IManagerService;
import com.qianying.util.CheckPhoneUtil;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;
import com.qianying.util.SendSmsUtil;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;

@Service
@Transactional
public class ManagerServiceImpl extends BaseServiceImpl implements IManagerService {

	@Autowired
	IManagerDAO managerDao;
	@Autowired
	IOperatorsDAO operatorsDao;
	@Autowired
	SqlExecDao  sqlExecDao;
	@Override
	public void save(Map<String, Object> map) {
		managerDao.insert(map); 
	}

	@Override
	public void update(Map<String, Object> map) {
		managerDao.updateByID(map);
	}

	@Override
	public void delete(Long id) {
		managerDao.deleteByID(id);
	}

	@Override
	public Map<String, Object> get(Long id) {
		return managerDao.queryByID(id);
	}

	@Override
	public List<Map<String, Object>> getAll() {
		return managerDao.getAll();
	}

	@Override
	public List<Map<String, Object>> findBySql(Map<String, Object> map) {
		return managerDao.queryBySql(map);
	}

	@Override
	public Map<String, Object> checkLogin(String name,String com_id) {
		return managerDao.checkLogin(name,com_id);
	}

	@Override
	public List<Map<String, Object>> getDeptByUpper_dept_id(Map<String,Object> map) {
		return managerDao.getDeptByUpper_dept_id(map);
	}

	@Override
	public String getMaxDeptSort_id() {
		return managerDao.getMaxDeptSort_id();
	}

	@Override
	public void saveDept(Map<String, Object> map, int type) {
		if (type==0) {
			managerDao.saveDept(map);
		}else{
			managerDao.updateDept(map);
		}
	}

	@Override
	public void deleteDept(String sort_id) {
		 managerDao.deleteDept(sort_id);;
	}

	@Override
	public List<Map<String, Object>> getDeptEmployee(Map<String, Object> map) {
		return managerDao.getDeptEmployee(map);
	}

	@Override
	public List<Map<String, Object>> getRegionalismTree(Map<String,Object> map) {
		return managerDao.getRegionalismTree(map);
	}
///////////////////////////////////////////////////////////////////

	@Override
	public List<Map<String, Object>> getWarehouseTree(Map<String,Object> map) {
		return managerDao.getWarehouseTree(map);
	}

	@Override
	public Map<String, Object> getWarehouse(String sort_id,String com_id) {
		return managerDao.getWarehouse(sort_id,com_id);
	}

	@Override
	public PageList<Map<String, Object>> getWarehouseByPage(Map<String,Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=managerDao.getWarehouseByPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=managerDao.getWarehouseByPage(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public int getMaxSeeds_id(String tableName, String filedName) {
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("tableName", tableName);
		map.put("filedName", filedName);
		return managerDao.getMaxSeeds_id(map);
	}

	@Override
	@Transactional
	public void insertSql(Map<String, Object> map, int type, String table, String findName,String id) {
		if (type==1) {
			managerDao.insertSql(getUpdateSql(map, table, findName,id, false));
		}else{
			managerDao.insertSql(getInsertSql(table, map));
		}
	}

	@Override
	public String saveUserInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		productDao.insertSql(getUpdateSql(map, "ctl00801","clerk_id",map.get("clerk_id").toString()));
		return null;
	}
	
	@Override
	public List<Map<String, Object>> getSettlementList(Map<String,Object> map) {
		return managerDao.getSettlementList(map);
	}

	@Override
	public Map<String, Object> getSettlement(Map<String,Object> map) {
		return managerDao.getSettlement(map);
	}

	@Override
	public Map<String, Object> getDeptBySortId(String sort_id) {
		return managerDao.getDeptBySortId(sort_id,getComId());
	}

	@Override
	public String getUpperId(Map<String,Object> map) {
		return managerDao.getUpperId(map);
	}
	@Override
	public Map<String, Object> getDataInfo(String table, String idName,
			String idVal) {
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("table", table);
		map.put("idName", idName);
		map.put("idVal", idVal);
		map.put("com_id", getComId());
		return managerDao.getDataInfo(map);
	}

	@Override
	public Map<String, Object> getRegionalismInfo(String sort_id) {
		return managerDao.getRegionalismInfo(sort_id);
	}

	@Override
	public void deleteRecord(String table, String fieldName,String upperName ,String val, String com_id) {
		if ("CS1".equals(val)||"CS1_ERROR".equals(val)||"CS1_ZEROM".equals(val)) {
			throw new RuntimeException("此客户为软件默认的系统级别的虚拟客户，不能删除！");
		}
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("table", table);
		map.put("idName", fieldName);
		map.put("upperName", upperName);
		map.put("idVal", val);
		map.put("com_id", com_id);
		 managerDao.deleteRecord(map);
//		Map<String,Object> mapinfo=managerDao.getMemberInfo("sdf00504","user_id",val);
		 //1.判断其它运营商里面是否有该客户
		 //1.1有就不删除微信通讯录里面的账号
//		 if(mapinfo==null){
//			 //1.2没有就删除微信通讯录里面的账号记录
//		 WeixinUtil wei=new WeixinUtil();
//		 wei.deleteEmployee(val);
//		 }
	}

	@Override
	public Integer getApproval_step(Map<String, Object> map) {
		Integer i= managerDao.getApproval_step(map);
		if (i==null) {
			return 1;
		}else{
			return i+1;
		}
	}
	@Override
	public void saveProcessDetail(Map<String, Object> map) {
		if (map.get("item_name") != null && map.get("item_name") != "") {
			Map<String, Object> mapparam = new HashMap<String, Object>();
			mapparam.put("com_id", getComId());
			mapparam.put("table", "OA_ctl03001");
			mapparam.put("showFiledName", "id");
			String pa="";
			if(!isMapKeyNull(map, "upper_customer_id")){
				pa=" and upper_customer_id='"+map.get("upper_customer_id")+"'";
			}
			mapparam.put("findFiled", "item_name='" + map.get("item_name") + "' and approval_step="+map.get("approval_step")+pa);
			Object seeds_id = managerDao.getOneFiledNameByID(mapparam);
			map.remove("id");
			if (seeds_id != null) {
				map.remove("item_id");
				if(isMapKeyNull(map, "customer_id")){
					map.put("customer_id", "");
				}
				managerDao.insertSql(getUpdateSql(map, "OA_ctl03001", "id", seeds_id.toString(),false));
			}else{
				String item_id=null;
				if (!isMapKeyNull(map, "item_id")) {
					item_id=map.get("item_id").toString();
				}else{
					String item=managerDao.getMaxApproval(map);
					if (StringUtils.isNotBlank(item)) {
						Integer i= Integer.parseInt(item.split("OP")[1]);
						item_id=String.format("OP%04d", i+1);
					}else{
						item_id=String.format("OP%04d", 1);
					}
				}
				map.put("item_id", item_id);
				map.put("peijian_id", item_id);
				managerDao.insertSql(getInsertSql("OA_ctl03001", map));
			}
		}
	}

	@Override
	public void moveProcess(Map<String, Object> map) { 
		if ("up".equals(map.get("type"))) {
			//上移,item_name=? and approval_step=?
			map.put("approval_stepN", Integer.parseInt(map.get("approval_step").toString())-1);
				managerDao.moveProcess(map);
		}else{
			Integer max=managerDao.getMaxApproval_step(map);
			if (map.get("approval_step").toString().equals(max+"")) {
				throw new RuntimeException("已经是最后一步,不能在向下移!");
			}else{
				map.put("approval_stepN", Integer.parseInt(map.get("approval_step").toString())+1);
				managerDao.moveProcess(map);
			}
		}
	}

	@Override
	public Map<String, Object> getProcess(Integer seeds_id,String type) {
		if (StringUtils.isNotBlank(type)) {
			Map<String,Object> map=new HashMap<>();
			map.put("seeds_id", seeds_id);
			List<Map<String,Object>> list= managerDao.getChaosong(map);
			StringBuffer clerk_id=new StringBuffer(); 
			StringBuffer clerk_name=new StringBuffer(); 
			Map<String,Object> map3=new HashMap<>();
			for (Map<String, Object> map2 : list) {
				clerk_id.append(map2.get("clerk_id")).append(",");
				clerk_name.append(map2.get("clerk_name")).append(",");
				map3.put("item_id",map2.get("item_id"));
			}
			map3.put("seeds_id", seeds_id);
			map3.put("clerk_id", clerk_id.toString());
			map3.put("clerk_name", clerk_name.toString());
			list.add(map3);
			return map3;
		}else{
			return managerDao.getProcessInfo(seeds_id);
		}
	}

	@Override
	public void delProcess(Map<String, Object> map) {
//		String sql="delete from OA_ctl03001 where id=?";
//		sql="update OA_ctl03001 set approval_step=approval_step-1 where item_name=? and  approval_step=?";
		managerDao.delProcess(map);
	}

	@Override
	public List<Map<String, Object>> getProcessList(Map<String,Object> map) {
		List<Map<String,Object>> list= managerDao.getChaosong(map);
		List<Map<String,Object>> pros=managerDao.getProcessList(map);
		if (list!=null&&list.size()>0) {
			StringBuffer clerk_id=new StringBuffer(); 
			StringBuffer clerk_name=new StringBuffer(); 
			Map<String,Object> map3=new HashMap<>();
			for (Map<String, Object> map2 : list) {
				clerk_id.append(map2.get("clerk_id")).append(",");
				clerk_name.append(map2.get("clerk_name")).append(",");
				map3.put("item_id",map2.get("item_id"));
				map3.put("ID",map2.get("ID"));
			}
			map3.put("clerk_id", clerk_id.toString());
			map3.put("clerk_name", clerk_name.toString());
			pros.add(map3);
		}
		return pros;
	}

	@Override
	public Object getOneFiledNameByID(String table, String showFiledName,
			String findFiled,String com_id) {
		 Map<String,Object> map=new HashMap<String, Object>();
		 map.put("table", table);
		 map.put("showFiledName", showFiledName);
		 map.put("findFiled", findFiled);
		 map.put("com_id", com_id);
		return managerDao.getOneFiledNameByID(map);
	}

	@Override
	public Map<String, Object> getSystemParams(String comId) {
		 
		return managerDao.getSystemParams(comId);
	}

	@Override
	public void saveSystemParams(Map<String, Object> map) {
		 Map<String,Object> mapold=managerDao.getSystemParams(map.get("com_id").toString());
		 Map<String,Object> map2=new HashMap<String, Object>();
		String fileds= "com_id, coin_id, cuur_unit_name, ivt_if_ivt_oper_listing, ivt_if_d_setacct, sd_sob, ivt_if_m_setacct, ivt_if_y_setacct, ivt_y_auto_setacct,"
         +"ivt_m_auto_setacct, ivt_d_auto_setacct, ivt_days_saveoperdata, ivt_if_forced_oper_out, ivt_if_negative, ivt_if_forced_oper_in, ivt_init_flag, ar_init_flag, "
         +"sd_if_corp_to_client, sd_if_auto_client_id, sd_if_auto_so_id, sd_if_auto_si_id, sd_pay_style, sd_if_auto_si, sd_if_auto_soi, sd_if_auto_rsi, sd_if_auto_sii, "
         +"sd_if_auto_ri, sd_plan_time_style, sd_plan_org_style, if_taxdetail, if_returnpay, ar_style, is_presell, st_if_repno, st_if_ord, st_if_rcv, is_reptoorder, is_autoInstore, "
        +" Apinit_flag, is_updateIvt, iscorp_to_vendor, MSGTIME, if_sendtax, bysendbill, isprvdeptdata, isinv_rev, mainten_clerk_id, mainten_datetime, subject_series, "
        +" subject_frame, sd_if_llpg, pricebit, moneybit, YYSL, st_if_product, quality_class_A, quality_class_B, quality_class_C, electric_rates, if_DepotLock, sessionTimer, "
        +" Certificate_code_msgTimer, sd_unit_priceHow, dayN1_SdOutStore_Of_SdPlan, dayN2_SdOutStore_Of_SdPlan, dayM1_SdOutStore_Of_SdPlan, "
        +" dayM2_SdOutStore_Of_SdPlan, dayTime_Of_SdPlan, salesOrder_Process, corpid, corpsecret, sd_tax, if_stockAlarm_recordStoreroom, MoveStore_Style, "
        +"  if_Edit_sd_order_id, if_Delete_sd_order_id, if_BtnPreview_After_BtnAud, Productenterstore_if_Auto_In, ProductOutstore_if_Auto_Out, "
        +"  GoodsSplitAndGoodsGroup_if_Auto, if_Origenal_Auto, if_Origenal_Delete_History, if_Origenal_InsertIn_History, if_Origenal_SaveDataOf_NotAffectAccount";
		String[] filedlist=fileds.split(",");
		 for (String key : filedlist) {
			 if ( map.get(key)!=null) {
				 map2.put(key, map.get(key));
			}
		}
		if (mapold==null) {
			//managerDao.insertSql(getInsertSql("CTLf01000", map2));
		}else{
			managerDao.insertSql(getUpdateSql(map2, "CTLf01000","com_id", map.get("com_id").toString(), true));
		}
		map.remove("processNameList");
		map.remove("com_id");
		map.put("appBase", "webapps");
		Object[] keys =  map.keySet().toArray();
		for (int i = 0; i < keys.length; i++) {
			//检查参数是否存在
			Map<String,Object> param=managerDao.checkSystem(keys[i]+"",getComId());
			//保存参数
			if(param==null){
			    param=new HashMap<String, Object>();
			}
			///
			boolean b=false;//不存在就插入
			if(isNotMapKeyNull(param, "param_name")){//存在就更新
				b=true;
			}
			boolean u=true;//如果值不变就跳过
			if(param.get("param_val")!=null&&param.get("param_val").equals(map.get(keys[i]))){
				u=false;
			}
			param.put("com_id", getComId());
			param.put("param_name", keys[i]);
			param.put("param_val", map.get(keys[i]));
			param.put("mainten_clerk_id", getEmployeeId(getRequest()));
			param.put("mainten_datetime", getNow());
			if(b){
				//如果值不变就跳过
				if(u){
					managerDao.insertSql(getUpdateSql(param, "CTLf01001","param_name", param.get("param_name").toString()));
				}
			}else{//不存在就插入
				managerDao.insertSql(getInsertSql("CTLf01001", param));
			}
		}
	}
	@Override
	public Map<String, Object> checkSystemSet(String param_name, String comId) {
		return managerDao.checkSystem(param_name,comId);
	}
	@Override
	public Map<String, Object> getSystemParamsByComIdSet(String comId) {
		List<Map<String,Object>> list=managerDao.getSystemParamsByComId(comId); 
		Map<String,Object> map=new HashMap<String, Object>();
		for (Map<String, Object> map2 : list) {
			map.put(map2.get("param_name")+"", map2.get("param_val"));
		}
		return map;
	}
	
	
	@Override
	public Map<String, Object> getClerkIdTo9003(String clerk_id, String comId) {
		 
		return managerDao.getClerkIdTo9003(clerk_id,comId);
	}

	@Override
	public List<Map<String, Object>> getEmployeeInfo(Map<String, Object> map) {
		
		return managerDao.getEmployeeInfo(map);
	}
	@Override
	public String sp_BaseIsUsed(Map<String, Object> map)throws Exception {
		 String res=managerDao.sp_BaseIsUsed(map);
		 LoggerUtils.info(map);
		 if (!"5".equals(map.get("output"))) {
			 
		}
		return res;
	}
	@Override
	public List<Map<String, Object>> getGysTree(Map<String, Object> map) {
		 
		return managerDao.getGysTree(map);
	}

	@Override
	public PageList<Map<String, Object>> getGysPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=managerDao.getGysPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(managerDao.getGysPageList(map));
		return pages;
	}
	
	@Override
	public PageList<Map<String, Object>> getOperatePage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		map.put("com_id", map.get("com_id")+"%");
		if (isMapKeyNull(map, "rows")) {
			map.put("rows", 10);
		}
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=managerDao.getOperatePageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(managerDao.getOperatePageList(map));
		return pages;
	}
	
	@Override
	public List<Map<String, Object>> getOperateTree(Map<String, Object> map) {
//		map.remove("com_id");
		if (map.get("comId")!=null) {
			map.put("com_id", map.get("comId")+"%");
		}
		return managerDao.getOperateTree(map);
	}
	
	@Override
	public boolean checkPhone(String phone, String table,String sqlwhere) {
		Integer i=managerDao.checkPhone(phone,table,sqlwhere);
		if (i == 0) {
			return true;
		} else {
			return false;
		}
	}
	@Override
	public Map<String, Object> getElectricianInfo(Map<String, Object> map) {
		
		return managerDao.getElectricianInfo(map);
	}

	@Override
	public PageList<Map<String, Object>> getCustomerTijian(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
//		map.put("com_id", map.get("com_id")+"%");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=managerDao.getCustomerTijianCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(managerDao.getCustomerTijianList(map));
		return pages;
	}
	
	@Override
	public List<Map<String, Object>> getThirdPartyPersonnelTree(
			Map<String, Object> map) {
		return managerDao.getThirdPartyPersonnelTree(map);
	}
	

	@Override
	public List<Map<String, Object>> findMeteringUnit(Map<String, Object> map) {
		return managerDao.findMeteringUnit(map);
	}

	@Override
	public void addMeteringUnit(Map<String, Object> map) {
		if(map.get("oper_flag").equals("0")){
			managerDao.addMeteringUnit(map);
		}
		if(map.get("oper_flag").equals("1")){
			managerDao.editMeteringUnit(map);
		}
		if(map.get("oper_flag").equals("2")){
			managerDao.delMeteringUnit(map);
		}
	}
	
	@Override
	public List<Map<String, Object>> getProducarea(Map<String, Object> map) {
		return managerDao.getProducarea(map);
	}

	@Override
	public void addProducarea(Map<String, Object> map) {
		if(map.get("oper_flag").equals("0")){
			managerDao.addProducarea(map);
		}
		if(map.get("oper_flag").equals("1")){
			managerDao.editProducarea(map);
		}
		if(map.get("oper_flag").equals("2")){
			managerDao.delProducarea(map);
		}
	}
	
	@Override
	public List<Map<String, Object>> getAccountingSubjects(Map<String, Object> map) {
		return managerDao.getAccountingSubjects(map);
	}

	@Override
	public void addAccountingSubjects(Map<String, Object> map) {
		if(map.get("oper_flag").equals("0")){
			managerDao.addAccountingSubjects(map);
		}
		if(map.get("oper_flag").equals("1")){
			managerDao.editAccountingSubjects(map);
		}
		if(map.get("oper_flag").equals("2")){
			managerDao.delAccountingSubjects(map);
		}
	}
	@Override
	public Map<String, Object> getTijianInfo(Map<String, Object> map) {
		return managerDao.getTijianInfo(map);
	}

	@Override
	public Integer getOperateId(String idVal) {
		return managerDao.getOperateId(idVal);
	}
	
	@Override
	public String sendSpreadMsg(Map<String, Object> map) { 
		if("gys".equals(map.get("type"))){
			
		}else{
			Map<String,Object> mapsms=getSystemParamsByComId();
			if("1".equals(map.get("datatype"))){//1-单个,0-全部,2-筛选出的多个
				Map<String,String> mapcus=managerDao.getCustomerInfo(map).get(0);
				StringBuffer msgtxt=new StringBuffer();
				msgtxt.append(mapcus.get("corp_name")).append(",你好，很荣幸通过你").append(mapcus.get("c_source"))
				.append("经理介绍认识您，互联网+，创新经营方面，看看今年，我们有结合点不，请抽时间思考和碰撞一下思想哈......祝").append(map.get("blessing"));
				SendSmsUtil.sendSms3(mapcus.get("user_id"), null, msgtxt.toString(),mapsms);
			}else if("2".equals(map.get("datatype"))){
				 List<Map<String,String>> list= managerDao.getCustomerInfo(map);
				 for (Map<String, String> mapcus : list) {
					 StringBuffer msgtxt=new StringBuffer();
						msgtxt.append(mapcus.get("corp_name")).append(",你好，很荣幸通过你").append(mapcus.get("c_source"))
						.append("经理介绍认识您，互联网+，创新经营方面，看看今年，我们有结合点不，请抽时间思考和碰撞一下思想哈......祝").append(map.get("blessing"));
						
						SendSmsUtil.sendSms3(mapcus.get("user_id"), null, msgtxt.toString(),mapsms);
				}
			}else{
				
			}
		}
		return null;
	}
	
	@Override
	public void deltijian(Map<String, Object> map) {
		managerDao.deltijian(map);
	}
	@Override
	public void updateTijian(Map<String, Object> map) {
		managerDao.updateTijian(map);
	}
	@Override
	public synchronized Integer saveTijian(Map<String,Object> map) {
		return managerDao.saveTijian(map);
	}
	
	@Override
	public void scctl00190(String com_id) {
		Integer comId=managerDao.getctl00190bycomid(com_id);
		if(comId==0){
			List<Map<String,Object>> list=managerDao.getctl00190by001(com_id);
			if (list!=null&&list.size()>0) {
				for (Map<String, Object> map : list) {
					map.remove("rule_seeds_id");
					map.put("com_id", com_id);
					map.put("i_currentValue", 0);
					map.put("d_currentDate", DateTimeUtils.dateToStr());
					managerDao.insertSql(getInsertSql("ctl00190", map));
				}
			}
		}
	}
	@Override
	@Transactional
	public String addPurchasingCheck(Map<String, Object> map) {
		JSONArray itemjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="STDM03001";//主表
		String itemtable="STD03001";//从表
		Calendar c = Calendar.getInstance();
		for(int i=0;i<itemjsons.size();i++){
			JSONArray jsonitems= JSONArray.fromObject(itemjsons.get(i));
			String rcv_auto_no=getOrderNo(
					customerDao, "采购进货", map.get("com_id").toString());
			JSONObject json=null;
			for(int j=0;j<jsonitems.size();j++){
				//存放从表数据
				json=jsonitems.getJSONObject(j);
				Map<String,Object> mapitem=new HashMap<String, Object>();
				mapitem.put("com_id",map.get("com_id"));
				mapitem.put("rcv_auto_no",rcv_auto_no);
				mapitem.put("rcv_hw_no",rcv_auto_no);
				mapitem.put("at_term_datetime",getNow());
				mapitem.put("finacial_d",getNow());
				mapitem.put("c_memo",map.get("c_memo"));
				getJsonVal(mapitem, json, "discount_rate", "discount_rate");
				getJsonVal(mapitem, json, "price", "price");
				getJsonVal(mapitem, json, "rep_qty", "rep_qty");
				getJsonVal(mapitem, json, "st_sum", "st_sum");
				getJsonVal(mapitem, json, "store_struct_id", "store_struct_id");
				getJsonVal(mapitem, json, "st_auto_no", "st_auto_no");
				getJsonVal(mapitem, json, "store_struct_name", "store_struct_name");
				getJsonVal(mapitem, json, "lot_number", "lot_number");
				getJsonVal(mapitem, json, "rkAmount", "rkAmount");
				getJsonVal(mapitem, json, "item_id", "item_id");
				getJsonVal(mapitem, json, "item_color", "item_color");
				getJsonVal(mapitem, json, "item_type", "item_type");
				getJsonVal(mapitem, json, "item_Hight", "item_Hight");
				getJsonVal(mapitem, json, "item_Lenth", "item_Lenth");
				getJsonVal(mapitem, json, "item_Width", "item_Width");
				mapitem.remove("rkAmount");
				mapitem.remove("store_struct_name");
				managerDao.insertSql(getInsertSql(itemtable, mapitem));
				if(json.has("st_auto_no")){
					Map<String,Object> param=new HashMap<>();
					param.put("com_id", getComId());
					param.put("clerk_id", map.get("clerk_id"));
					param.put("nowTime", getNow());
					getJsonVal(param, json, "st_auto_no", "st_auto_no");
					getJsonVal(param, json, "item_id", "item_id");
					getJsonVal(param, json, "item_type", "item_type");
					managerDao.updatePurOrderFlag(param);
				}
			}
			Map<String,Object> mapmain=new HashMap<String, Object>();
			mapmain.put("com_id",map.get("com_id"));
			mapmain.put("rcv_auto_no",rcv_auto_no);
			mapmain.put("rcv_hw_no",rcv_auto_no);
			mapmain.put("mainten_datetime", getNow());
			mapmain.put("stock_type", "进货");
			mapmain.put("comfirm_flag", "N");
			mapmain.put("vendor_id", json.getString("vendor_id"));
			mapmain.put("vendor_name", json.getString("vendor_name"));
			mapmain.put("c_memo", map.get("c_memo"));
			mapmain.put("st_auto_no", json.get("st_auto_no"));
			mapmain.put("store_struct_id", json.getString("store_struct_id"));
			mapmain.put("clerk_id", map.get("clerk_id"));
			mapmain.put("dept_id", map.get("dept_id"));
			mapmain.put("mainten_clerk_id", map.get("mainten_clerk_id"));
			mapmain.put("ivt_oper_cfm", map.get("clerk_id"));
			mapmain.put("ivt_oper_cfm_time", getNow());
			mapmain.put("store_date", getNow());
			mapmain.put("finacial_y", c.get(Calendar.YEAR));
			mapmain.put("finacial_m", c.get(Calendar.MONTH));
			managerDao.insertSql(getInsertSql(maintable, mapmain));
		}
		return null;
	}

	@Override
	@Transactional
	public String delPurchasingCheck(Map<String,Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("checkIn"));
		String maintable="STDM03001";//主表
		String itemtable="STD03001";//从表
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains= mainjsons.getJSONArray(i);
			for(int j=0;j<jsonmains.size();j++){
				JSONObject json=jsonmains.getJSONObject(j);
				Map<String,Object> itemMap=new HashMap<String,Object>();
				//删除采购退货单更新已入库产品数量
//				if("cgth".equals(json.get("client"))){
//					itemMap.put("rcv_auto_no",json.getString("st_auto_no"));
//					itemMap.put("item_id",json.getString("item_id"));
//					itemMap.put("store_struct_id",json.getString("store_struct_id"));
//					itemMap.put("com_id",map.get("com_id"));
//					
//					Double rkNum=managerDao.selRkNum(itemMap);
//					Double rep_qty=Double.valueOf(json.getString("thNum"));
//					Double price=Double.valueOf(json.getString("price"));
//					
//					BigDecimal st_sum=BigDecimal.valueOf((rep_qty+rkNum)*price);
//					itemMap.put("rep_qty", rep_qty+rkNum);
//					itemMap.put("st_sum",st_sum );
//					managerDao.updateRkcp(itemMap);
//				}
				itemMap.clear();
				itemMap.put("table", itemtable);
				itemMap.put("rcv_auto_no", json.getString("rcv_auto_no"));
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("item_id", json.getString("item_id"));
				managerDao.delPurchasingCheck(itemMap);
				
				//根据rcv_auto_no判断从表是否还有相同的入库单号
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", itemtable);
				mapquery.put("com_id",map.get("com_id"));
				mapquery.put("showFiledName", "rcv_auto_no");
				mapquery.put("findFiled","rcv_auto_no='"+json.getString("rcv_auto_no")+"' ");
				Object obj = productDao.getOneFiledNameByID(mapquery);
				if(obj==null){
					//没有则根据rcv_auto_no删除主表对应数据行
					Map<String,Object> mainMap=new HashMap<String,Object>();
					mainMap.put("table", maintable);
					mainMap.put("rcv_auto_no", json.getString("rcv_auto_no"));
					mainMap.put("com_id", map.get("com_id"));
					mainMap.put("item_id", null);
					managerDao.delPurchasingCheck(mainMap);
				}
				
				//删除采购入库单时回退采购订单收货数量,状态
//				if("2".equals(json.get("client"))&&json.get("st_auto_no")!=""){
//					mapquery.clear();
//					mapquery.put("table", "STD02001");
//					mapquery.put("com_id",map.get("com_id"));
//					mapquery.put("showFiledName", "m_flag");
//					mapquery.put("findFiled","st_auto_no='"+json.get("st_auto_no")+
//							"'and item_id= '"+json.get("item_id")+"' ");
//					Object flag = productDao.getOneFiledNameByID(mapquery);
//					if("5".equals(flag)){
//						Map<String,Object> cgdd=new HashMap<String,Object>();
//						cgdd.put("m_flag", "4");
//						cgdd.put("st_auto_no", json.getString("st_auto_no"));
//						cgdd.put("item_id", json.getString("item_id")); 
//						cgdd.put("com_id", map.get("com_id")); 
//						managerDao.updateFlagByNo(cgdd);
//					}
//				}
			}
		}
		return null;
	}
	@Override
	@Transactional
	public String purchaseReturn(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		Calendar c=Calendar.getInstance();
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains=  JSONArray.fromObject(mainjsons.get(i));
			String rcv_auto_no=getOrderNo(
					customerDao, "采购退货", map.get("com_id").toString());
			JSONObject json=null;
			for(int j=0;j<jsonmains.size();j++){
				json=jsonmains.getJSONObject(j);
				if(StringUtils.isNotBlank(json.getString("rcv_auto_no"))){
					Map<String,Object>itemMap=new HashMap<String,Object>();
					itemMap.put("com_id", map.get("com_id"));
					itemMap.put("c_memo", map.get("c_memo"));
					itemMap.put("rcv_auto_no", rcv_auto_no);
					itemMap.put("rcv_hw_no", rcv_auto_no);
					itemMap.put("st_auto_no", json.getString("rcv_auto_no"));
					itemMap.put("rep_qty", json.getString("thNum"));
					itemMap.put("lot_number", json.getString("item_spec"));
					itemMap.put("price", json.getString("item_cost"));
					itemMap.put("discount_rate", json.getString("discount_rate"));
					itemMap.put("st_sum", json.getString("st_sum"));
					itemMap.put("store_struct_id", json.getString("store_struct_id"));
					itemMap.put("store_struct_name", json.getString("store_struct_name"));
					itemMap.put("item_type", json.getString("item_type"));
					itemMap.put("at_term_datetime",getNow());
					itemMap.put("finacial_d",getNow());
					getJsonVal(itemMap, json, "item_id", "item_id");
					getJsonVal(itemMap, json, "item_color", "item_color");
					getJsonVal(itemMap, json, "item_Hight", "item_Hight");
					getJsonVal(itemMap, json, "item_Lenth", "item_Lenth");
					getJsonVal(itemMap, json, "item_type", "item_type");
					getJsonVal(itemMap, json, "item_Width", "item_Width");
					managerDao.insertSql(getInsertSql("STD03001", itemMap));
				}
			}
			//存放主表数据
			Map<String,Object>mainMap=new HashMap<String,Object>();
			mainMap.put("dept_id", map.get("dept_id"));
			mainMap.put("clerk_id", map.get("clerk_id"));
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("c_memo", map.get("c_memo"));
			mainMap.put("rcv_auto_no", rcv_auto_no);
			mainMap.put("rcv_hw_no", rcv_auto_no);
			mainMap.put("st_auto_no",json.getString("rcv_auto_no"));
			mainMap.put("vendor_id", json.getString("vendor_id"));
			mainMap.put("vendor_name", json.getString("vendor_name"));
			mainMap.put("store_struct_id", json.getString("store_struct_id"));
			mainMap.put("mainten_clerk_id", map.get("clerk_id"));
			mainMap.put("ivt_oper_cfm", map.get("clerk_id"));
			mainMap.put("stock_type", "退货");
			mainMap.put("comfirm_flag", "N");
			mainMap.put("mainten_datetime",getNow());
			mainMap.put("ivt_oper_cfm_time", getNow());
			mainMap.put("finacial_y", c.get(Calendar.YEAR));
			mainMap.put("finacial_m", c.get(Calendar.MONTH));
			mainMap.put("store_date", getNow());
			managerDao.insertSql(getInsertSql("STDM03001", mainMap));
		}
		return null;
	}
	@Override
	@Transactional
	public String saveAccount(Map<String, Object> map) throws Exception {
		if (isNotMapKeyNull(map, "rcv_auto_no")) {
			return Sp_stockStock(map);
		}
		JSONArray mainjsons=JSONArray.fromObject(map.get("checkIn"));
		Calendar c=Calendar.getInstance();
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains= mainjsons.getJSONArray(i);
			Map<String,Object> kcMap=new HashMap<String,Object>();
			JSONObject json=null;
			for(int j=0;j<jsonmains.size();j++){
				json=jsonmains.getJSONObject(j);				
				kcMap.put("in_store_struct_id", json.get("store_struct_id"));//调出仓库
				kcMap.put("com_id", map.get("com_id"));
				kcMap.put("item_id", json.get("item_id"));
				Integer accn_ivt1=employeeDao.selectItemByStore(kcMap);
				kcMap.clear();
				if(accn_ivt1!=null){
					Double accn_ivt2=Double.valueOf(json.getString("accn_ivt"));
					kcMap.put("item_id",json.getString("item_id"));
					kcMap.put("store_struct_id",json.getString("store_struct_id"));
					kcMap.put("i_price",json.getString("i_price"));
					kcMap.put("com_id",map.get("com_id"));
					kcMap.put("accn_ivt",accn_ivt1+accn_ivt2);
					kcMap.put("use_oq",accn_ivt1+accn_ivt2);
					managerDao.updateKcById(kcMap);
				}else{
					kcMap.put("store_struct_id",json.getString("store_struct_id"));
					kcMap.put("finacial_datetime",getNow());
					kcMap.put("item_id",json.getString("item_id"));
					kcMap.put("i_price",json.getString("i_price"));
					kcMap.put("accn_ivt",json.getString("accn_ivt"));//该产品当前实际库存数
					kcMap.put("use_oq",json.getString("accn_ivt"));//该产品当前可用库存数
					kcMap.put("customer_id",json.getString("customer_id"));//供应商
					kcMap.put("ivt_oper_listing",json.getString("rcv_auto_no"));//采购入库单号
					kcMap.put("com_id",map.get("com_id"));
					kcMap.put("maintenance_datetime",getNow());
					kcMap.put("finacial_y", c.get(Calendar.YEAR));
					kcMap.put("finacial_m", c.get(Calendar.MONTH)+1);
					managerDao.insertSql(getInsertSql("IVTd01302", kcMap));
				}
			}
			//更新采购主表comfirm_flag为Y
			kcMap.clear();
			kcMap.put("comfirm_flag", "Y");
			kcMap.put("rcv_auto_no", json.get("rcv_auto_no"));
			kcMap.put("item_id", json.get("item_id"));
			kcMap.put("com_id", map.get("com_id"));
			managerDao.updateRkzbByFlag(kcMap);
		}
		return null;
	}
	private String Sp_stockStock(Map<String, Object> map)throws Exception {
		// TODO 采购入库审核与弃审
		String rcv_auto_no=MapUtils.getString(map, "rcv_auto_no");
		if (isNotMapKeyNull(map, "rcv_auto_no")) {
			if (rcv_auto_no.startsWith(",")) {
				rcv_auto_no=rcv_auto_no.substring(1, rcv_auto_no.length());
			}
			if (rcv_auto_no.endsWith(",")) {
				rcv_auto_no=rcv_auto_no.substring(0, rcv_auto_no.length()-1);
			}
			String[] rcvs=rcv_auto_no.split(",");
			for (String rcv : rcvs) {
				map.put("rcv_auto_no", rcv);
				Object obj= managerDao.Sp_stockStock(map);
				LoggerUtils.info(obj);
				managerDao.updateRkzbByFlag(map);
			}
			return null;
		}
		throw new RuntimeException("参数错误");
	}

	@Override
	public String updateOperateOk(Map<String, Object> map) {
		
		return managerDao.updateOperateOk(map);
	}
	
	@Override
	public String getComIdWeixinID(String com_id,Integer amount) {
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", com_id);
		map.put("amount", amount);
		return managerDao.getComIdWeixinID(map);
	}
	@Override
	public List<Map<String, Object>> getOperateNoWorkList() {
		 
		return managerDao.getOperateNoWorkList();
	}

	@Override
	@Transactional
	public String delOrderByNo(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains= mainjsons.getJSONArray(i);
			for(int j=0;j<jsonmains.size();j++){
				JSONObject json=jsonmains.getJSONObject(j);
				String maintable="STDM02001";//主表
				String itemtable="STD02001";//从表
				Map<String,Object> itemMap=new HashMap<String,Object>();
				itemMap.put("table", itemtable);
				itemMap.put("st_auto_no", json.getString("st_auto_no"));//rcv_auto_no
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("item_id", json.getString("item_id"));
				managerDao.delOrder(itemMap);
				//根据rcv_auto_no判断从表是否还有相同的入库单号
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", itemtable);
				mapquery.put("com_id",map.get("com_id"));
				mapquery.put("showFiledName", "st_auto_no");
				mapquery.put("findFiled","st_auto_no='"+json.getString("st_auto_no")+"' ");
				Object obj = productDao.getOneFiledNameByID(mapquery);
				if(obj==null){
					//没有则根据rcv_auto_no删除主表对应数据行
					Map<String,Object> mainMap=new HashMap<String,Object>();
					mainMap.put("table", maintable);
					mainMap.put("st_auto_no", json.getString("st_auto_no"));
					mainMap.put("com_id", map.get("com_id"));
					mainMap.put("item_id", null);
					managerDao.delOrder(mainMap);
				}
			}
		}
		return null;
	}

	@Override
	public void updatekcTable(Map<String, Object> map) {
			 managerDao.updatekcTable(map);
	}
	@Override
	public Map<String, Object> getTableFiled(String table) {
		
		return managerDao.getTableFiled(table);
	}

	@Override
	public List<Map<String, Object>> getFiledList(Map<String, Object> map) {
		return managerDao.getFiledList(map);
	}
	@Override
	public String updateProPrice(Map<String, Object> map) {
		// TODO 更新产品采购价
		return managerDao.updateProPrice(map)+"";
	}
	
	@Override
	public void updateWeixinState() {
		// TODO 更新微信状态
		//1.从微信中获取已关注成员列表
		WeixinUtil wei=new WeixinUtil();
		List<Map<String,Object>> list=operatorsDao.getAll();
		for (Map<String, Object> map : list) {
			String agentDeptId=systemParamsDao.checkSystem("agentDeptId", map.get("com_id")+"");
			String empl=wei.getEmployeeSimplelist(1, 1, 1,map.get("com_id")+"",agentDeptId);
			if(StringUtils.isNotBlank(empl)){
				JSONArray empls=JSONArray.fromObject(empl);
				//2.从数据库中获取已关注成员列表
				List<String> weixinlist=managerDao.getWeixinState(map.get("com_id")+"");
				if(weixinlist!=null&&weixinlist.size()>0){
					//3.去除数据库中已经关注的成员
					for (int i = 0; i < empls.size(); i++) {
						JSONObject json =empls.getJSONObject(i);
						for (String weixinID : weixinlist) {
							if (StringUtils.isNotBlank(weixinID)) {
								if(weixinID.equals(json.getString("userid"))){
									empls.remove(i);
								}
							}
						}
					}
					if(empls.size()>0){
						//更新数据库
						Map<String,Object> emplmap=new HashMap<>();
						emplmap.put("weixins", empls);
						managerDao.updateWeixinState(emplmap);
					}
				}
			}
		}
	}
	@Override
	public String confirmReturn(Map<String, Object> map)throws Exception {
		if (isNotMapKeyNull(map, "rcv_auto_no")) {
			return Sp_stockQuitGoods(map);
		}
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains = mainjsons.getJSONArray(i);
			JSONObject json = null;
			Map<String, Object> thMap = new HashMap<String, Object>();
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//更新库存
				thMap.put("store_struct_id", json.getString("store_struct_id"));
				thMap.put("item_id", json.getString("item_id"));
				thMap.put("com_id", map.get("com_id"));
				Double accn_kc = Double.valueOf(managerDao.getAccivt(thMap));//获取库存数量
				Double accn_th = Double.valueOf(json.getString("thNum"));//退货数量
				thMap.put("accn_ivt", accn_kc - accn_th);
				thMap.put("use_oq", accn_kc - accn_th);
				thMap.put("finacial_datetime", getNow());
				thMap.put("maintenance_datetime", getNow());
				thMap.put("finacial_y", c.get(Calendar.YEAR));
				thMap.put("finacial_m", c.get(Calendar.MONTH)+1);
				managerDao.updateKcReturn(thMap);
			}
			//更新审核状态
			thMap.clear();
			thMap.put("rcv_auto_no", json.get("rcv_auto_no"));
			thMap.put("com_id", map.get("com_id"));
			thMap.put("comfirm_flag", "Y");
			managerDao.updateReturnFlag(thMap);
		} 
		return null;
	}

	private String Sp_stockQuitGoods(Map<String, Object> map)throws Exception {
		// TODO 采购退货审核
		String rcv_auto_no=MapUtils.getString(map, "rcv_auto_no");
		if (isNotMapKeyNull(map, "rcv_auto_no")) {
			if (rcv_auto_no.startsWith(",")) {
				rcv_auto_no=rcv_auto_no.substring(1, rcv_auto_no.length());
			}
			if (rcv_auto_no.endsWith(",")) {
				rcv_auto_no=rcv_auto_no.substring(0, rcv_auto_no.length()-1);
			}
			String[] rcvs=rcv_auto_no.split(",");
			for (String rcv : rcvs) {
				map.put("rcv_auto_no", rcv);
				Object obj= managerDao.Sp_stockQuitGoods(map);
				LoggerUtils.info(obj);
				managerDao.updateRkzbByFlag(map);
			}
			return null;
		}
		throw new RuntimeException("参数错误");
	}

	@Override
	public String itemReturn(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains = mainjsons.getJSONArray(i);
			String rcv_auto_no = getOrderNo(customerDao, "采购退货", map.get("com_id").toString());
			JSONObject json = null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//生成从表信息
				Map<String, Object> itemMap = new HashMap<String, Object>();
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("c_memo", map.get("c_memo"));
				itemMap.put("rcv_auto_no", rcv_auto_no);
				itemMap.put("rcv_hw_no", rcv_auto_no);
				itemMap.put("item_id", json.get("item_id"));
				itemMap.put("rep_qty", json.getString("thNum"));
				itemMap.put("lot_number", json.get("lot_number"));//
				itemMap.put("price", json.get("price"));
				itemMap.put("discount_rate", json.get("discount_rate"));
				itemMap.put("st_sum", json.getString("st_sum"));
				itemMap.put("store_struct_id", json.get("store_struct_id"));
				itemMap.put("store_struct_name", json.get("store_struct_name"));//
				itemMap.put("item_name", json.get("item_name"));//
				itemMap.put("item_type", json.get("item_type"));//
				itemMap.put("at_term_datetime", json.get("at_term_datetime"));
				itemMap.put("finacial_d", getNow());
				managerDao.insertSql(getInsertSql("STD03001", itemMap));
			}
			//存放主表数据
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("dept_id", map.get("dept_id"));
			mainMap.put("clerk_id", map.get("clerk_id"));
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("c_memo", map.get("c_memo"));
			mainMap.put("rcv_auto_no", rcv_auto_no);
			mainMap.put("rcv_hw_no", rcv_auto_no);
			mainMap.put("mainten_datetime", getNow());
			mainMap.put("mainten_clerk_id", map.get("clerk_id"));
			mainMap.put("ivt_oper_cfm", map.get("clerk_id"));
			mainMap.put("ivt_oper_cfm_time", getNow());
			mainMap.put("finacial_y", c.get(Calendar.YEAR));
			mainMap.put("finacial_m", c.get(Calendar.MONTH));
			mainMap.put("vendor_id", json.get("vendor_id"));//
			mainMap.put("vendor_name", json.get("vendor_name"));//
			mainMap.put("store_struct_id", json.get("store_struct_id"));
			mainMap.put("stock_type", "退货");
			mainMap.put("comfirm_flag", "N");
			mainMap.put("store_date", getNow());
			managerDao.insertSql(getInsertSql("STDM03001", mainMap));
		} 
		return null;
	}

	@Override
	public Integer checkDelCilent(Map<String, Object> map) throws Exception {
		return managerDao.checkDelCilent(map);
	}
	@Override
	public JSONArray saveWeixinTemplateMessageInfo(Map<String, Object> map) {
		WeiXinServiceUtil service=new WeiXinServiceUtil();
		JSONArray jsons= service.get_all_private_template(MapUtils.getString(map, "com_id"));
		if (jsons!=null&&jsons.size()>0) {
			for (int i = 0; i < jsons.size(); i++) {
				String msg=jsons.getJSONObject(i).toString();
				msg=msg.split("example")[0];
				JSONObject js=JSONObject.fromObject(msg.substring(0, msg.length()-2)+"}");
				map.put("json", js);
				Integer count=managerDao.saveWeixinTemplateMessageInfo(map);
				LoggerUtils.info(count);
			}
		}
		return jsons;
	}

	@Override
	public String returnAccount(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("checkIn"));
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains= mainjsons.getJSONArray(i);
			JSONObject json=null;
			Map<String,Object> kcMap=new HashMap<String,Object>();
			for(int j=0;j<jsonmains.size();j++){
				json=jsonmains.getJSONObject(j);
				kcMap.put("item_id", json.get("item_id"));
				kcMap.put("com_id", map.get("com_id"));
				kcMap.put("in_store_struct_id", json.get("store_struct_id"));
				Integer useOq=employeeDao.selectItemByStore(kcMap);
				Integer oper_qty = Integer.valueOf(json.getString("accn_ivt"));
				kcMap.put("accn_ivt", useOq - oper_qty);
				kcMap.put("use_oq", useOq - oper_qty);
				kcMap.put("store_struct_id", json.get("store_struct_id"));
				managerDao.updateKcReturn(kcMap);
				if(useOq - oper_qty==0){
					managerDao.delKcItem(kcMap);
				}
			}
			kcMap.clear();
			kcMap.put("comfirm_flag", "N");
			kcMap.put("rcv_auto_no", json.get("rcv_auto_no"));
			kcMap.put("com_id", map.get("com_id"));
			managerDao.updateRkzbByFlag(kcMap);
		}
		return null;
	}

	@Override
	public String returnConfirm(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains = mainjsons.getJSONArray(i);
			JSONObject json = null;
			Map<String, Object> thMap = new HashMap<String, Object>();
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//更新库存
				thMap.put("store_struct_id", json.getString("store_struct_id"));
				thMap.put("item_id", json.getString("item_id"));
				thMap.put("com_id", map.get("com_id"));
				Double accn_kc = Double.valueOf(managerDao.getAccivt(thMap));//获取库存数量
				Double accn_th = Double.valueOf(json.getString("thNum"));//退货数量
				thMap.put("accn_ivt", accn_kc + accn_th);
				thMap.put("use_oq", accn_kc + accn_th);
				managerDao.updateKcReturn(thMap);
			}
			//更新审核状态
			thMap.clear();
			thMap.put("rcv_auto_no", json.get("rcv_auto_no"));
			thMap.put("com_id", map.get("com_id"));
			thMap.put("comfirm_flag", "N");
			managerDao.updateReturnFlag(thMap);
		} 
		return null;
	}

	@Override
	public String updateOrderStatus(Map<String, Object> map) {
		// TODO 更新订单状态
		return managerDao.updateOrderStatus(map)+"";
	}
	@Override
	public Map<String, Object> getGysInfo(Map<String, Object> map) {
		// TODO 获取供应商信息
		return managerDao.getGysInfo(map);
	}
	///////////////
	@Override
	public String initKucunShenhe(Map<String, Object> map) throws Exception{
		managerDao.initKucunShenhe(map);
		map.put("shenheType", "kucun");
		managerDao.updateShenhe(map);
		return null;
	}
	@Override
	public String initKuanxiangShenhe(Map<String, Object> map) {
		if ("yfk".equals(map.get("shenheType"))) {
			managerDao.initYfkShenHe(map);
		}else if ("ysk".equals(map.get("shenheType"))){
			managerDao.initYskShenHe(map);
		}else{
		}
		managerDao.updateShenhe(map);
		return null;
	}
	/////////////////////基础资料同步更新//////////////////////////
	@Override
	public String updateProductAndEmployee(String sort_id, String newsort_id)
			throws Exception {
		//1.更新产品表
		managerDao.updateProductByClass(getComId(),sort_id,newsort_id);
		//2.更新员工表
		//2.1获取员工表中类别字段值包含旧编码
		List<Map<String,Object>> type_id=managerDao.getEmployeeType_id(getComId(),"%"+sort_id+"%");
		//2.2判断是否为空和是否包含旧编码
		if (type_id!=null&&type_id.size()>0) {
			for (Map<String, Object> map2 : type_id) {
				String id=MapUtils.getString(map2, "type_id");
				if (StringUtils.isNotBlank(id)) {
					//2.3替换生成新的type_id值
					id=id.replaceAll(sort_id, newsort_id);
					map2.put("type_id", id);
					//2.4更新员工表
					managerDao.updateEmployeeType_idById(map2);
				}
			}
		}
		return null;
	}
	@Override
	public String updateWeixinOpenid(Map<String, Object> map) {
		Integer i=managerDao.updateWeixinOpenid(map);
		return i+"";
	}
	/////////////文章信息存储///////
	@Override
	public String saveArticleToTable(JSONObject json)throws Exception {
		json.put("mainten_clerk_id", getEmployeeId(getRequest()));
		json.put("maintenance_datetime", getNow());
		json.put("com_id", getComId());
		JSONObject jsoninfo= managerDao.getArticleInfo(json);
		Integer i=0;
		if (!json.has("projectName")||!json.has("htmlname")) {
			throw new RuntimeException("参数不全!");
		}
		if(jsoninfo!=null){
			i=managerDao.insertSql(getUpdateSql(json, "t_article", "", "")+" and id="+jsoninfo.get("id"));
		}else{
			i=managerDao.insertSql(getInsertSql("t_article", json));
		}
		LoggerUtils.info(i);
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getArticlePage(Map<String, Object> map)
			throws Exception {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=managerDao.getArticleCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		pages.setRows(managerDao.getArticlePage(map));
		return pages;
	}
	@Override
	public Map<String, Object> getArticleInfoData(Map<String, Object> map)
			throws Exception {
		return managerDao.getArticleInfoData(map);
	}
	@Override
	public String delArticle(Map<String, Object> map) throws Exception {
		// TODO 删除文章
		return managerDao.delArticle(map)+"";
	}
	@Override
	public Integer updateOpenid(Map<String, Object> map) {
		
		return managerDao.updateOpenid(map);
	}
	
	@Override
	public List<Map<String, String>> getOpenidById(String id, String com_id,
			String table) {
		Map<String,Object> map=new HashMap<>();
		map.put("id", id);
		map.put("com_id", com_id);
		map.put("table", table);
		return managerDao.getOpenidById(map);
	}
	
	@Override
	public String tongbuWeixinTemplate(JSONArray jsons) {
		managerDao.insertSql("delete from t_weixin_template where ltrim(rtrim(isnull(com_id,'')))='"+getComId()+"'");
		Map<String,Object> map=new HashMap<>();
		map.put("com_id", getComId());
		map.put("jsons", jsons);
		return managerDao.tongbuWeixinTemplate(map)+"";
	}
	
	@Override
	public List<Map<String, Object>> getWexinMsgTemplate(Map<String, Object> map) {
		// TODO 从数据表中获取微信服务号消息模板
		return managerDao.getWexinMsgTemplate(map);
	}
	
	@Override
	public String updateSql(File file) {
		String msg=null;
		if (file.exists()&&file.isDirectory()) { 
			execSqlByFile(file);
		}else{
			msg="没有找到sql文件夹!";
		}
		return msg;
	}
	
	
	private boolean execSql(String sqlitem,String prex) {
		Map<String,Object> map=new HashMap<>();
		boolean b=sqlitem.contains("ctl09003");
		if(b){
			return b;
		}else{
			b=sqlitem.contains("FHDZ");
			if(b){
				return b;	
			}
			sqlitem=sqlitem.replaceAll("10end", "10 end ");
			sqlitem=sqlitem.replaceAll("nullend", " null end ");
			sqlitem=sqlitem.replaceAll("end ", " end ");
			sqlitem=sqlitem.replaceAll("else", " else ");
			sqlitem=sqlitem.replaceAll("WHERE", " WHERE ");
			sqlitem=sqlitem.replaceAll("where", " where ");
			if (StringUtils.isNotBlank(sqlitem)) {
				map.put("sSql", prex+sqlitem);
//				Object obj=sqlExecDao.sqlExec(map);
//				LoggerUtils.error(obj);
			}
			return b;
		}
	}
	
	private String getFileSql(File path) {
		if (path.exists()) {
			try {
				StringBuffer buffer=new StringBuffer();
				 InputStreamReader read = new InputStreamReader(
		                    new FileInputStream(path),"GBK");//考虑到编码格式
		                    BufferedReader bufferedReader = new BufferedReader(read);
		                    String sql = null;
		                    while((sql = bufferedReader.readLine()) != null){
		                    	Map<String,Object> map=new HashMap<>();
//								sql=sql.replaceAll("else", " else ");
//								sql=sql.replaceAll("WHERE", " WHERE ");
//								sql=sql.replaceAll("where", " where ");
								map.put("sSql", sql);
								System.out.println(sql);
								Object obj=sqlExecDao.sqlExec(map);
		                        buffer.append(sql);
		                    }
		                    read.close();
				
				return buffer.toString();
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return null;
	}
	
	private void execSqlByFile(File file) {
		if (file.exists()&&file.isDirectory()) {
			File[] fs=file.listFiles();
			for (File nextf : fs) {
				if (nextf.exists()) {
					if(nextf.isFile()&&nextf.exists()){
						LoggerUtils.error(nextf.getName());
						if (nextf.getPath().endsWith(".sql")) {
//							String sql=getFileTextContent(nextf);
							String sql=getFileSql(nextf);
							sql=sql.replaceAll("if ", "IF ");
							if (sql.contains("GO")) {
								String[] sqls=sql.split("GO");
								for (String sqlitem : sqls) {execSql(sqlitem,"");}
							}else if(sql.contains("go")){
								String[] sqls=sql.split("go ");
								for (String sqlitem : sqls) {execSql(sqlitem,"");}
							}
//							else if(sql.contains("IF")){
//								String[] sqls=sql.split("IF");
//								for (String sqlitem : sqls) {execSql(sqlitem," IF ");}
//							}else if(sql.contains("if")){
//								String[] sqls=sql.split("if ");
//								for (String sqlitem : sqls) {execSql(sqlitem," IF ");}
//							}
							else{
								if (StringUtils.isNotBlank(sql)) {
									Map<String,Object> map=new HashMap<>();
									sql=sql.replaceAll("else", " else ");
									sql=sql.replaceAll("WHERE", " WHERE ");
									sql=sql.replaceAll("where", " where ");
									map.put("sSql", sql);
									Object obj=sqlExecDao.sqlExec(map);
									LoggerUtils.error(obj);
								}
							}
						}
					}else{
						execSqlByFile(nextf);
					}
				}
			}
		}
	}
	/**
	 * 绿豆云短信发送
	 * @param com_id
	 * @param selectType
	 * @param txt
	 * @param jsons
	 * @param param
	 * @return
	 */
	public String sendSmsLvDou(Map<String,Object> map,String txt,JSONArray jsons, Map<String, Object> param) {
		Object com_id=map.get("com_id");
		Object selectType=map.get("selectType");
		String tels=jsons.toString();
		if("0".equals(selectType)){//所有人
			List<Map<String, String>> list=managerDao.getAllClientphone(com_id.toString());
			for (Iterator<Map<String, String>> iterator = list.iterator(); iterator.hasNext();) {
				Map<String, String> tel = iterator.next();
				String phone=tel.get("phone");
				if (StringUtils.isBlank(phone)||phone.length()!=11) {
				}else{
					boolean b=checkPhoneType(map, tel.get("license_type"));
					if(b){
						String txtMsg=txt.replaceAll("@customerName", tel.get("corp_sim_name"));
						SendSmsUtil.sendSmsLvDou(tel.get("phone"),null, txtMsg, param);
					}
				}
			}
		}else if("2".equals(selectType)){//不包含已选择的客户
			if (jsons!=null) {
				List<Map<String, String>> list=managerDao.getAllClientphone(com_id.toString());
				for (Iterator<Map<String, String>> iterator = list.iterator(); iterator.hasNext();) {
					Map<String, String> tel = iterator.next();
					String phone=tel.get("phone");
					if (StringUtils.isBlank(phone)||phone.length()!=11) {
					}else if(tels.contains(phone)){
					}else{
						boolean b=checkPhoneType(map, phone);
						if(b){
							String txtMsg=txt.replaceAll("@customerName", tel.get("corp_sim_name"));
							SendSmsUtil.sendSmsLvDou(tel.get("phone"),null, txtMsg, param);
						}
					}
				}
			}
		}else{//发送已选择的客户
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				String phone=json.getString("phone");
				boolean b=checkPhoneType(map, CheckPhoneUtil.getPhoneType(phone));
				if(b){
					String txtMsg=txt.replaceAll("@customerName", json.getString("name"));
					SendSmsUtil.sendSmsLvDou(phone,null, txtMsg, param);
				}
			}
		}
		return null;
	}
	/**
	 * 检查手机号码类型
	 * @param map
	 * @param license_type 手机号码类型
	 * @return
	 */
	private boolean checkPhoneType(Map<String,Object> map,String license_type) {
		boolean b=true;
		if ("移动".equals(license_type)) {
			if(!MapUtils.getBooleanValue(map, "mobile")){
				b=false;
			}
		}
		if ("联通".equals(license_type)) {
			if(!MapUtils.getBooleanValue(map, "unicom")){
				b=false;
			}
		}
		if ("电信".equals(license_type)) {
			if(!MapUtils.getBooleanValue(map, "telecom")){
				b=false;
			}
		}
		return b;
	}
	
	private void getPhone(Map<String,Object> map,Map<String,String> tel,Iterator<Map<String, String>> iterator,StringBuffer phones) {
		boolean b=checkPhoneType(map, tel.get("license_type"));
		if(b){
			phones.append(tel.get("phone")).append(",");
		}else{
			iterator.remove();
		}
	}
	
	@Override
	public String sendsms(Map<String,Object> map)throws Exception {
		Map<String,Object> param=getSystemParamsByComId();
		if(isMapKeyNull(map, "list")&&!"0".equals(map.get("selectType"))){
			return "没有待发送的客户数据!";
		}
		String txt=map.get("txt").toString();
		JSONArray jsons=JSONArray.fromObject(map.get("list"));
		if ("1".equals(param.get("smsType"))) {
			if (!txt.contains("【")) {
				int end=MapUtils.getString(param, "sendMsgBegin").indexOf("】");
				String qianm=MapUtils.getString(param, "sendMsgBegin").substring(0, end+1);
				txt=txt+qianm;
			}
			return sendSmsLvDou(map, txt, jsons, param);
		}else{
			if (!txt.contains("【")) {
				int end=MapUtils.getString(param, "sendMsgBegin").indexOf("】");
				String qianm=MapUtils.getString(param, "sendMsgBegin").substring(0, end+1);
				txt=qianm+txt;
			}
			StringBuffer phones=new StringBuffer();
			if("0".equals(map.get("selectType"))){//所有人
				List<Map<String, String>> list=managerDao.getAllClientphone(map.get("com_id").toString());
				for (Iterator<Map<String, String>> iterator = list.iterator(); iterator.hasNext();) {
					Map<String, String> tel = iterator.next();
					if (StringUtils.isBlank(tel.get("phone"))||tel.get("phone").length()!=11) {
						iterator.remove();
					}else{
						getPhone(map, tel, iterator, phones);
					}
				}
				
			}else if("2".equals(map.get("selectType"))){//不包含已选择的客户
				List<Map<String, String>> list=managerDao.getAllClientphone(map.get("com_id").toString());
				if (jsons!=null) {
					String tels=jsons.toString();
					for (Iterator<Map<String, String>> iterator = list.iterator(); iterator.hasNext();) {
						Map<String, String> tel = iterator.next();
						if (StringUtils.isBlank(tel.get("phone"))||tel.get("phone").length()!=11) {
							iterator.remove();
						}else if(tels.contains(tel.get("phone"))){
							iterator.remove();
						}else{
							getPhone(map, tel, iterator, phones);
						}
					}
				}
			}else{//发送已选择的客户
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					String phone=json.getString("phone");
					boolean b=checkPhoneType(map, CheckPhoneUtil.getPhoneType(phone));
					if(b){
						phones.append(phone).append(",");
					}
				}
			}
			if (phones.length()<=0) {
				throw new RuntimeException("没有获取到收信手机号!");
			}
			String phone=phones.substring(0, phones.length()-1);
			return  SendSmsUtil.sendSmsYx(phone, txt, param);
		}
	}
	private String sendsms3(Map<String,Object> map) {
		Map<String,Object> param=getSystemParamsByComId();
		String txt=map.get("txt").toString();
		StringBuffer bf=new StringBuffer();
		JSONArray jsons=JSONArray.fromObject(map.get("list"));
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			String name=json.getString("name");
			String phone=json.getString("phone");
			if (phone.length()==11) {
				String msg=SendSmsUtil.sendSms3(phone, null, txt.replaceAll("@customerName", name), param);
				bf.append(msg);
			}
		}
		return bf.toString();
	}
	@Override
	public String getBalance(Map<String, Object> map) {
		Map<String,Object> param=getSystemParamsByComId();
    	String url="http://222.73.66.76:8000/GetBalance.asp";
    	String account=MapUtils.getString(param, "YxSmsUsername") ;
    	String password=MapUtils.getString(param, "YxSmsPassword");
		url=url+"?Account="+account+"&Password="+password+"&Channel=1";
		return SendSmsUtil.SendGet(url);
	}
	@Override
	public String getReport(Map<String, Object> map) {
		Map<String,Object> param=getSystemParamsByComId();
		String url="http://222.73.66.76:8000/GetReport.asp";
		String account=MapUtils.getString(param, "YxSmsUsername") ;
		String password=MapUtils.getString(param, "YxSmsPassword");
		url=url+"?Account="+account+"&Password="+password+"&Channel=1";
		if (isNotMapKeyNull(map, "time")) {
			url=url+"&Time="+map.get("time");
		}
		return SendSmsUtil.SendGet(url);
	}
	
	@Override
	public String updateWeixinState(Map<String, Object> map) {
		if (isNotMapKeyNull(map, "table")) {
			List<Map<String,Object>> list=managerDao.getUserInfoByType(map);
			WeixinUtil wei=new WeixinUtil();
			Integer i=0;
			for (Map<String, Object> map2 : list) {
				if (isNotMapKeyNull(map2, "weixinID")) {
					if (map2.get("weixinID").toString().length()==11) {
						String msg=wei.getEmployeeInfo(map2.get("weixinID")+"",map.get("com_id")+"");
						if (StringUtils.isNotBlank(msg)) {
							JSONObject json=JSONObject.fromObject(msg);
							if(json!=null&&json.has("status")){
								if(1==json.getInt("status")){
									map2.put("table", map.get("table"));
									managerDao.updateWeixinState(map2);
									i++;
								}
							}
						}
					}
				}
			}
			return i+"";
		}else{
			return "参数错误!";
			
		}
	}
	
	@Override
	public void updateClientType() {
		List<Map<String, Object>> list= managerDao.getAllClient();
		for (Map<String, Object> map : list) {
			if (isNotMapKeyNull(map, "user_id")) {
				String phone=map.get("user_id").toString();
				String license_type=CheckPhoneUtil.getPhoneType(phone);
				if (!"error".equals(license_type)) {
					map.put("license_type", license_type);
					managerDao.updateClientLicense(map);
				}

			}
		}
	}
	
}
