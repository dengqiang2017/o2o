package com.qianying.service.impl;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.ICustomerDAO;
import com.qianying.dao.interfaces.IEmployeeDAO;
import com.qianying.dao.interfaces.IOperatorsDAO;
import com.qianying.dao.interfaces.IProductDAO;
import com.qianying.page.PageList;
import com.qianying.page.ProductClassQuery;
import com.qianying.page.ProductQuery;
import com.qianying.service.IManagerService;
import com.qianying.service.IProductService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;
import com.qianying.util.SendSmsUtil;
import com.qianying.util.WeixinUtil;

@Service
@Scope("prototype")
public class ProductServiceImpl extends BaseServiceImpl implements
		IProductService {

	@Resource
	private IProductDAO productDao;
	@Resource
	private ICustomerDAO customerDao;
	@Resource
	private IEmployeeDAO employeeDao;
	@Resource
	private IOperatorsDAO operatorsDao;
	@Resource
	private IManagerService managerService;

	@Override
	@Transactional
	public void save(Map<String, Object> map) {
		// productDao.insert(map);
		productDao.insertSql(getInsertSql("Ctl03001", map));
	}

	@Override
	@Transactional
	public void update(Map<String, Object> map) {
		// productDao.updateByID(map);
		productDao.insertSql(getUpdateSql(map, "Ctl03001", "item_id", null,
				false));
	}

	@Override
	@Transactional
	public void delete(Long id) {
		productDao.deleteByID(id);
	}

	@Override
	public Map<String, Object> get(Long id) {
		return productDao.queryByID(id);
	}

	@Override
	public List<Map<String, Object>> getAll() {
		return productDao.getAll();
	}

	@Override
	@Transactional
	public String updateProFile(String basePath) {
		//1.获取所有运营商
		List<Map<String,Object>> list=operatorsDao.getNextComs(null);
		for (Map<String, Object> map : list) {
			Object com_id=map.get("com_id");
			//1.获取主图txt是否存在
			File itemFile=new File(basePath+com_id+"/img/");
			if (itemFile.exists()&&itemFile.isDirectory()) {
				File[] items=itemFile.listFiles();
				for (File file : items) {// img/item_id/
					String item_id=file.getName();
					File cp=new File(file.getPath()+"/cp.txt");
					if (cp.exists()&&cp.isFile()) {//已经存在跳过
					}else{
						File cpFile=new File(file.getPath()+"/cp/");
						if (cpFile.exists()&&cpFile.isDirectory()) {
							File[] cps=cpFile.listFiles();
							if (cps!=null&&cps.length>0) {
								StringBuffer cptxt=new StringBuffer();
								for (File cpimg : cps) {//  /com_id/img/item_id/cp/cpimg.getName();
									cptxt.append("/").append(com_id).append("/img/").append(item_id).append("/cp/").append(cpimg.getName()).append(",");
								}
								Map<String,Object> update=new HashMap<>();
								update.put("com_id", com_id);
								update.put("item_id", item_id);
								update.put("main_img", cps.length);
								update.put("sSql", "update ctl03001 set main_img=#{main_img} where ltrim(rtrim(isnull(com_id,'')))=#{com_id} and ltrim(rtrim(isnull(item_id,'')))=#{item_id}");
								productDao.insertSqlByPre(update); 
								saveFile(cp, cptxt.substring(0, cptxt.length()-1));
							}
						}
					}
					////////////////////////
					File cpFile=new File(file.getPath()+"/xj/");
					if (cpFile.exists()&&cpFile.isDirectory()) {
						File[] cps=cpFile.listFiles();
						if (cps!=null&&cps.length>0) {
							Map<String,Object> update=new HashMap<>();
							update.put("com_id", com_id);
							update.put("item_id", item_id);
							update.put("detail_cms", cps.length);
							update.put("sSql", "update ctl03001 set detail_cms=#{detail_cms} where ltrim(rtrim(isnull(com_id,'')))=#{com_id} and ltrim(rtrim(isnull(item_id,'')))=#{item_id}");
							productDao.insertSqlByPre(update); 
						}
					}
					///缩略图
					File sl=new File(file.getPath()+"/sl.jpg");
					if (sl.exists()&&sl.isFile()) {
						Map<String,Object> update=new HashMap<>();
						update.put("com_id", com_id);
						update.put("item_id", item_id);
						update.put("cover_img", 1);
						update.put("sSql", "update ctl03001 set cover_img=#{cover_img} where ltrim(rtrim(isnull(com_id,'')))=#{com_id} and ltrim(rtrim(isnull(item_id,'')))=#{item_id}");
						productDao.insertSqlByPre(update); 
					}
				}
				
			}
			
		}
		return null;
	}
	
	@Override
	public PageList<Map<String, Object>> findQuery(Map<String,Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.count(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.findQuery(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> findAddQuery(Map<String,Object> map) {
//		if(isNotMapKeyNull(map, "customer_id")){
//			Map<String, Object> mapcus = customerDao.getCustomerByCustomer_id(
//					map.get("customer_id")+"", map.get("com_id")+"");
//			String ditch_type = "普通经销商";// ditch_type
//			if (mapcus != null && mapcus.get("ditch_type") != null) {// 协议经销商不用排除已经筛选的产品
//				ditch_type = mapcus.get("ditch_type").toString();
//				if ("协议经销商".equals(ditch_type)) {
//					ditch_type = null;
//				}
//			}
//			map.put("ditch_type", ditch_type);
//		}
		String moreAdd= systemParamsDao.checkSystem("moreAdd", getComId());
		if (StringUtils.isNotBlank(moreAdd)&&"true".equals(moreAdd)) {
			map.put("moreAdd", moreAdd);
		}
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.countAdd(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=productDao.findAddQuery(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> getClientAdded(Map<String,Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getClientAddedCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=productDao.getClientAdded(map);
		pages.setRows(list);
		return pages;
	}
	/**
	 * 更新客户订单状态为待支付
	 * @param customer_id 
	 */
	private void updateClientStatus(String customer_id){
//		String sSql = "update SDd02021 set Status_OutStore='待支付' "
//				+ "where ltrim(rtrim(isnull(com_id,'')))='"+getComId()+"' and ltrim(rtrim(isnull(Status_OutStore,'待支付')))='支付中' "
//						+ "and  ivt_oper_listing in (select ivt_oper_listing from sdd02020 where customer_id='"
//				+ customer_id + "' and ltrim(rtrim(isnull(com_id,'')))='"+getComId()+"')";
//		customerDao.insertSql(sSql);
		Map<String,Object> map=new HashMap<>();
		map.put("com_id", getComId());
		map.put("customer_id", customer_id);
		productDao.updateOrder(map);
	}
	@Override
	public PageList<Map<String, Object>> getClientOrdered(ProductQuery query) {
		updateClientStatus(query.getCustomer_id());
		int count = productDao.getClientOrderedCount(query);
		PageList<Map<String, Object>> pages = getPageListToAdd(query, count);
		List<Map<String, Object>> rows = null;
		try {
			rows = productDao.getClientOrdered(query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		pages.setRows(rows);
		return pages;
	}

	@Override
	public List<Map<String, Object>> findBySql(Map<String, Object> map) {
		return productDao.queryBySql(map);
	}

	@Override
	public String getMaxItem_id() {
		String item=productDao.getMaxItem_id();
		if(StringUtils.isNotBlank(item)){
			return item;
		}else{
		    return "0";
		}
	}

	@Override
	@Transactional
	public void delpro(String item_id) {
		productDao.delpro(item_id);
	}

	@Override
	public void connDB() {
		try {
			productDao.connDB();
//			LoggerUtils.info("重复连接数据库中...");
			////
		} catch (Exception e) {
			LoggerUtils.error(e.getMessage());
		}
	}
	@Override
	public Map<String, Object> getByItemId(String itemId) {
		Map<String, Object> map = productDao.getByItemId(itemId,getComId());
		if (map.get("store_struct_id") != null) {
			map.put("table", "Ivt01001");
			map.put("showFiledName", "store_struct_name");
			map.put("findFiled", "sort_id='"
					+ map.get("store_struct_id").toString() + "'");
			Object store_struct_name = productDao.getOneFiledNameByID(map);
			if (store_struct_name == null) {
				store_struct_name = "";
			}
			map.put("store_struct_name", store_struct_name);
		}
		return map;
	}
	@Override
	public Map<String, Object> getByItemId(Map<String, Object> map) {
		Integer salesVolume=0;
		Object com_id=map.get("com_id");
		salesVolume=productDao.getProductSalesVolume(map);
		 map = productDao.getByItemMap(map);
		if (map!=null) {
			map.put("com_id", com_id);
			if(isNotMapKeyNull(map, "store_struct_id")){
				map.put("table", "Ivt01001");
				map.put("showFiledName", "store_struct_name");
				map.put("findFiled", "sort_id='"
						+ map.get("store_struct_id").toString() + "'");
				Object store_struct_name = productDao.getOneFiledNameByID(map);
				if (store_struct_name == null) {
					store_struct_name = "";
				}
				map.put("store_struct_name", store_struct_name);
			}
			map.put("salesVolume", salesVolume);
		}
		String fenx_jinbi=systemParamsDao.checkSystem("fenx_jinbi",com_id.toString());
		map.put("fenx_jinbi", fenx_jinbi);
		String moreColor=systemParamsDao.checkSystem("moreColor",com_id.toString());
		map.put("moreColor", moreColor);
		return map;
	}
	@Override
	public Map<String, Object> getProductBasicDetailByItemId(
			Map<String, Object> map) {
		return productDao.getProductBasicDetailByItemId(map);
	}
	@Override
	public Map<String, Object> getProductOrderDetailByItemId(
			Map<String, Object> map) {
		return productDao.getProductOrderDetailByItemId(map);
	}
	@Override
	public Map<String, Object> getProductPlanDetailByItemId(
			Map<String, Object> map) {
		return productDao.getProductPlanDetailByItemId(map);
	}
	@Override
	public List<Map<String, Object>> getProductClass(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "treeId")) {
			map.put("sort_id", map.get("treeId"));
		}
		String id=request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			map.put("id", id);
		}
		map.put("filed", getFiledNameBYJson(request, "productClass","sort_id",null));
		return productDao.getProductClass(map);
	}

	@Override
	public Map<String, Object> getProductClassBySordId(Map<String,Object> map) {
		return productDao.getProductClassBySordId(map);
	}

	@Override
	public String getMaxProductClass_id() {
		return productDao.getMaxProductClass_id();
	}

	@Override
	@Transactional
	public void saveClass(Map<String, Object> map, int type) {
		if (type == 1) {
			productDao.insertSql(getInsertSql("ctl03200", map));
		} else {
			productDao.insertSql(getUpdateSql(map, "ctl03200", "sort_id", null,
					false));
		}
	}

	@Override
	public PageList<Map<String, Object>> getProductClassPage(
			ProductClassQuery query) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("query", query);
		map.put("table", "ctl03200");
		map.put("sort_id", "sort_id");
		map.put("page", 1);
		map.put("record", 10);
		map.put("n1", "");
		map.put("n2", "");
		map.put("n3", "");
		List<Map<String, Object>> list = productDao.getProductClassPage(map);
		PageList<Map<String, Object>> pages = new PageList<Map<String, Object>>();
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> getCustomerAddProduct(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getCustomerAddProductCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows = productDao.getCustomerAddProduct(map);
		pages.setRows(rows);
		return pages;
	}
	@Override
	public PageList<Map<String, Object>> getZEROMOrderProduct(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=0;
		Integer page=0;
		Integer pageRecord=10;//View_productSdoq
		String zeroDesc=systemParamsDao.checkSystemDef("zeroDesc", "View_productNum", map.get("com_id")+"");
		if(StringUtils.isBlank(zeroDesc)){
			zeroDesc="View_productNum";
		}
		map.put("zeroDesc", zeroDesc);
		if (isMapKeyNull(map, "index")) {
			pageRecord=Integer.parseInt(map.get("rows")+"");
			page=Integer.parseInt(map.get("page")+"")*pageRecord;
			if (getTotalRecord(map, currentPage, pageRecord)==null) {
				totalRecord=productDao.getZEROMOrderProductCount(map);
			}else{
				totalRecord=Integer.parseInt(map.get("count")+"");
			}
		}
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(page, pageRecord, totalRecord);
		List<Map<String, Object>> rows = productDao.getZEROMOrderProduct(map);
		pages.setRows(rows);
		return pages;
	}
	@Override
	@Transactional
	public String addOrder(Map<String, Object> map) throws Exception {
		// 1.获取客户信息
		String customer_id = map.get("customer_id").toString();
		String comId = map.get("com_id").toString();
		Map<String, Object> mapcus = customerDao.getCustomerByCustomer_id(
				customer_id, comId);
		if (mapcus == null) {
			throw new RuntimeException("没有获取到客户信息!");
		} 
		String mainten_clerk_id = null;
		if (isNotMapKeyNull(map, "clerk_id")) {
			mainten_clerk_id = map.get("clerk_id").toString();
		} else {
			mainten_clerk_id = comId;
		}
		JSONArray jsons=JSONArray.fromObject(map.get("itemIds"));
		if (jsons == null || jsons.size() <= 0) {
			return "请至少选择一个产品!";
		}
		updateClientStatus(customer_id);
		String no = getOrderNo(customerDao, "销售开单", map.get("com_id")
				.toString());
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			json.put("com_id", map.get("com_id"));
			json.put("customer_id", map.get("customer_id"));
			Map<String, Object> mapaddpro = null;
			if (isMapKeyNull(map, "plan")) {
				// 查询为该客户下订单是否有客户价单表,验证客户来源是否正常
				mapaddpro = productDao.getAddProInfo(json);
				if (mapaddpro == null) {
					throw new RuntimeException("没有获取到客户价单表信息!");
				}
			} else {
				// 查询为该客户下订单是否有计划信息,验证客户来源是否正常
				mapaddpro = productDao.getPlanProInfo(json);
				if (mapaddpro == null) {
					throw new RuntimeException("没有获取到计划信息!");
				}
			}
			Map<String, Object> mapDetail = null;
			if (isMapKeyNull(map, "plan")) {
				mapDetail = getOrderDetail(comId, json, customer_id);
			} else {
				mapDetail = getOrderPlanDetail(comId, json, customer_id);
			}
			mapDetail.put("com_id", map.get("com_id"));
			mapDetail.put("FHDZ", mapcus.get("FHDZ"));
			mapDetail.put("ivt_oper_listing", no);
			mapDetail.put("sd_order_id", no);
			if(isNotMapKeyNull(map, "Status_OutStore")){
				mapDetail.put("Status_OutStore", map.get("Status_OutStore"));
			}else{
				mapDetail.put("Status_OutStore", "支付中");
				if (getEmployee(getRequest())!=null) {
					mapDetail.put("Status_OutStore", getProcessName(getRequest(), 0));
				}
			}
			mapDetail.put("customer_id", customer_id);
			mapDetail.put("clerk_id_sid", mapaddpro.get("clerk_id"));
			getJsonVal(mapDetail, json, "peijian_id", "peijian_id");
			getJsonVal(mapDetail, json, "item_name", "client_item_name");
			productDao.insertSql(getInsertSql("SDd02021", mapDetail));
			if (isNotMapKeyNull(map, "plan")) {
				productDao.updatePlanNumByOrder(json);
			}else{
				//更新报价单中单价为最新单价ivt_oper_bill
				productDao.updateAddedPrice(mapDetail);
			}
			if(getEmployee(getRequest())!=null){
				String item_id = json.getString("item_id");
				Object clerk_name=getEmployee(getRequest()).get("clerk_name");
				String content=getComName()+"-业务员-"+clerk_name+":代下订单";
				saveOrderHistory(no, item_id, content);
			}else{
				try {
					String item_id = json.getString("item_id");
					Object clerk_name=getCustomer(getRequest()).get("clerk_name");
					String content=getComName()+"-客户-"+clerk_name+":下订单";
					saveOrderHistory(no, item_id, content);
				} catch (Exception e) {
				}
			}
		}
		// 1.2组合主表数据
		Map<String, Object> mainmap = new HashMap<String, Object>();
		mainmap.put("com_id", map.get("com_id"));
		mainmap.put("sd_order_direct", "发货");
		mainmap.put("ivt_oper_bill", "发货");
		mainmap.put("ivt_oper_listing", no);
		mainmap.put("dept_id", map.get("dept_id"));
		mainmap.put("sd_order_id", no);
		mainmap.put("comfirm_flag", "N");
		mainmap.put("customer_id", customer_id);
		mainmap.put("regionalism_id", mapcus.get("regionalism_id"));
		mainmap.put("dept_id", mapcus.get("dept_id"));
		if (map.get("clerk_id")!=null) {
			mainmap.put("clerk_id", map.get("clerk_id"));
		}
		mainmap.put("so_consign_date", nowdate);
		mainmap.put("at_term_datetime", nowdate);
		Calendar c = Calendar.getInstance();
		mainmap.put("finacial_y", c.get(Calendar.YEAR));
		mainmap.put("finacial_m", c.get(Calendar.MONTH));
//		mainmap.put("all_oq", itemIds.length);
		mainmap.put("mainten_clerk_id", mainten_clerk_id);
		mainmap.put("mainten_datetime", nowdate);
		mainmap.put("settlement_type_id","JS001JS004");
		mainmap.put("HYS", map.get("HYS"));
		mainmap.put("transport_AgentClerk_Reciever", mapcus.get("delivery_Add"));
//		mainmap.put("HJJS", itemIds.length);
		productDao.insertSql(getInsertSql("SDd02020", mainmap));
		try {
			Map<String,String[]> sopn=getProcessName();
			String Status_OutStore=sopn.get("processName")[0];
			String[] Eheadships=sopn.get("Eheadship");//getProcessName("Eheadship",getRequest());
			String headship =Eheadships[0];//"内勤";
			Map<String,Object> mapsms=getSystemParamsByComId();
			String[] Imgheadships=sopn.get("imgName");//getProcessName("imgName", getRequest());
			String imgName="msg.png";
			if(Imgheadships.length>1){
				imgName=Imgheadships[0];
			}
			StringBuffer msg=new StringBuffer(getComName()).append("-").append(headship).append("-");
			List<Map<String,Object>> orderinfo=productDao.getOrderInfoByNo(no,getComId());
			if (getEmployee(getRequest())!=null) {
				Object clerk_name=getEmployee(getRequest()).get("clerk_name");
				if (clerk_name==null) {
					clerk_name="";
				}
				msg.append("@clerkName:业务员").append(clerk_name)
				.append("代客户").append(mapcus.get("corp_sim_name")).append("下订单,订单编号").append(no);
				///////////////////向客户发送短信/////////////
				StringBuffer msgcus=new StringBuffer("尊敬的客户").append(mapcus.get("corp_sim_name"));
				msgcus.append(":").append(getComName()).append("-业务员-").append(clerk_name).append(",帮您下了一笔订单").append("，订单单号：");
				msgcus.append(no).append("，产品名称：");
				msg.append(",产品名称:");
				for (Map<String, Object> map2 : orderinfo) {
					msgcus.append(map2.get("item_sim_name")).append("，金额：");
					msgcus.append(String.format("%.2f", map2.get("sum_si"))).append("元，数量:").
					append(String.format("%.2f", map2.get("sd_oq"))).append(map2.get("casing_unit")).append("，");
					//////////员工/////
					msg.append(map2.get("item_sim_name")).append("，金额：");
					msg.append(String.format("%.2f", map2.get("sum_si"))).append("元，数量:").
					append(String.format("%.2f", map2.get("sd_oq"))).append(map2.get("casing_unit")).append("，");
				}
				
				/////////代下订单通知客户///begin///////////
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", "代客户下订单通知");
				mapMsg.put("description",msgcus);
				mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do");
				news.add(mapMsg);
				//根据客户编码获取微信id
				if (ConfigFile.NoticeStyle.contains("0")&&mapcus.get("weixinID")!=null) {
					sendMessageNews(news, mapcus.get("weixinID").toString(),"客户");
				}
				if (ConfigFile.NoticeStyle.contains("1")) {
					if (mapcus.get("movtel")!=null) {
						SendSmsUtil.sendSms2(mapcus.get("movtel")+"", null, msgcus.toString(),mapsms);
					}
				}
				/////////代下订单通知客户///end///////////
			}else{
				//客户下订单微信消息通知
				msg.append("@clerkName:客户【").append(map.get("customerName")).append("】下订单,订单编号").append(no);
				msg.append(",产品名称:");
				for (Map<String, Object> map2 : orderinfo) {
					msg.append(map2.get("item_sim_name")).append("，金额：");
					msg.append(String.format("%.2f", map2.get("sum_si"))).append("元，数量:").
					append(String.format("%.2f", map2.get("sd_oq"))).append(map2.get("casing_unit")).append("，");
				}
			}
			//////////通知员工///begin/////
			msg.append("请尽快为客户").append(Status_OutStore);
			if (ConfigFile.NoticeStyle.contains("0")) {
				sendMessageNewsNeiQing(Status_OutStore, msg.toString(), headship,imgName);
			}
			if (ConfigFile.NoticeStyle.contains("1")) {
				Map<String,Object> mapper=new HashMap<String, Object>();
				mapper.put("com_id", getComId());
				mapper.put("movtel","movtel");
				mapper.put("headship", "%"+headship+"%");
				List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapper);
				for (Map<String,String> movtel : touserList) {
					if (StringUtils.isNotBlank(movtel.get("movtel"))) {
						SendSmsUtil.sendSms2(movtel.get("movtel"), null, movtel.get("clerk_name")+":"
					+msg.toString().replaceAll("@clerkName", movtel.get("clerk_name")),mapsms);
					}
				}
			}
			//////通知员工///end//////
		} catch (Exception e) {
			LoggerUtils.error(e.getMessage());
//			e.printStackTrace();
		}
		return no;
	}
	@Override
	@Transactional
	public String saveOrder(Map<String, Object> map) throws Exception {
		// 1.获取客户信息
		String customer_id = map.get("customer_id").toString();
		String com_id = map.get("com_id").toString();
		Map<String, Object> mapcus = customerDao.getCustomerByCustomer_id(
				customer_id, com_id);
		if (mapcus == null) {
			throw new RuntimeException("没有获取到客户信息!");
		}
		if (isMapKeyNull(map, "orderList")) {
			throw new RuntimeException("参数错误没有获取到订单信息!");
		}
		String orderListStr=map.get("orderList").toString();
		if (orderListStr.startsWith("[")) {
			orderListStr="["+orderListStr;
		}
		if (orderListStr.startsWith("]")) {
			orderListStr=orderListStr+"]";
		}
		JSONArray orderList=null;
		try {
			orderList=JSONArray.fromObject(orderListStr);
		} catch (Exception e) {
			throw new RuntimeException("参数错误!");
		}
		if (orderList.size()<=0) {
			throw new RuntimeException("参数错误没有获取到订单信息!");
		}
		updateClientStatus(customer_id);
		String no = getOrderNo(customerDao, "销售开单", map.get("com_id")
				.toString());
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		//TODO 保存订单
		int k=0;
		for (int i = 0; i < orderList.size(); i++) {
			JSONObject item=orderList.getJSONObject(i);
			if (!item.has("num")||item.getInt("num")<=0) {
				continue;
			}
			if (!item.has("price")) {
				continue;
			}
			Map<String, Object> mapDetail =new HashMap<>();
			mapDetail.put("sd_unit_price", item.getString("price"));
			mapDetail.put("sd_oq", item.getString("num"));
			mapDetail.put("ivt_oper_bill", item.getString("ivt_oper_listing"));
			mapDetail.put("com_id", map.get("com_id"));
			mapDetail.put("ivt_oper_listing", no);
			mapDetail.put("sd_order_id", no);
			mapDetail.put("Status_OutStore", "支付中");
			mapDetail.put("customer_id", customer_id);
			mapDetail.put("at_term_datetime_Act", getNow());
			getJsonVal(map, item, "c_memo", "c_memo");
			getJsonVal(map, item, "memo_color", "memo_color");
			getJsonVal(map, item, "memo_other", "memo_other");
			productDao.insertSql(getInsertSql("SDd02021", mapDetail));
			try {
				JSONObject json = JSONObject.fromObject(item);
				String item_id = json.getString("item_id");
				Object clerk_name=getCustomer(getRequest()).get("clerk_name");
				String content=getComName()+"-客户-"+clerk_name+":下订单";
				saveOrderHistory(no, item_id, content);
			} catch (Exception e) {}
			k++;
		}
		//////存储主表数据///////
		// 1.2组合主表数据
		if (k<=0) {
			throw new RuntimeException("参数错误!");
		}
		Map<String, Object> mainmap = new HashMap<String, Object>();
		mainmap.put("com_id", map.get("com_id"));
		mainmap.put("sd_order_direct", "发货");
		mainmap.put("ivt_oper_bill", "发货");
		mainmap.put("ivt_oper_listing", no);
		mainmap.put("dept_id", map.get("dept_id"));
		mainmap.put("sd_order_id", no);
		mainmap.put("comfirm_flag", "N");
		mainmap.put("customer_id", customer_id);
//		mainmap.put("regionalism_id", mapcus.get("regionalism_id"));
//		mainmap.put("dept_id", mapcus.get("dept_id"));
//		if (map.get("clerk_id")!=null) {
//			mainmap.put("clerk_id", map.get("clerk_id"));
//		}
		mainmap.put("so_consign_date", nowdate);
		mainmap.put("at_term_datetime", nowdate);
		Calendar c = Calendar.getInstance();
		mainmap.put("finacial_y", c.get(Calendar.YEAR));
		mainmap.put("finacial_m", c.get(Calendar.MONTH));
		mainmap.put("all_oq", orderList.size());
		mainmap.put("mainten_clerk_id", getCustomerId(getRequest()));
		mainmap.put("mainten_datetime", nowdate);
		mainmap.put("settlement_type_id","JS001JS004");
		mainmap.put("HYS", map.get("HYS"));
		mainmap.put("transport_AgentClerk_Reciever", mapcus.get("delivery_Add"));
		mainmap.put("HJJS", orderList.size());
		productDao.insertSql(getInsertSql("SDd02020", mainmap));
		return null;
	}
	@Override
	@Transactional
	public String addOrderByZEROM(Map<String, Object> map) throws Exception {
		// 1.获取客户信息
		String customer_id = map.get("customer_id").toString();
		String com_id = map.get("com_id").toString();
		Map<String, Object> mapcus = customerDao.getCustomerByCustomer_id(
				customer_id, com_id);
		if (mapcus == null) {
			throw new RuntimeException("没有获取到客户信息!");
		}
		String mainten_clerk_id = customer_id;
		String[] itemIds = (String[]) map.get("itemIds");
		if (itemIds == null || itemIds.length <= 0) {
			return "请至少选择一个产品!";
		}
		updateClientStatus(customer_id);
		String no = getOrderNo(customerDao, "销售开单", map.get("com_id")
				.toString());
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		for (String item : itemIds) {
			Map<String, Object> mapDetail = getOrderDetail(com_id, item, customer_id);
			mapDetail.put("com_id", map.get("com_id"));
			mapDetail.put("FHDZ", mapcus.get("FHDZ"));
			mapDetail.put("ivt_oper_listing", no);
			mapDetail.put("sd_order_id", no);
			if(isNotMapKeyNull(map, "Status_OutStore")){
				mapDetail.put("Status_OutStore", map.get("Status_OutStore"));
			}else{
				mapDetail.put("Status_OutStore", "支付中");
				if (getEmployee(getRequest())!=null) {
					mapDetail.put("Status_OutStore", getProcessName(getRequest(), 0));
				}
			}
			mapDetail.put("customer_id", customer_id);
//			mapDetail.put("clerk_id_sid", mapaddpro.get("clerk_id"));
			productDao.insertSql(getInsertSql("SDd02021", mapDetail));
			try {
				JSONObject json = JSONObject.fromObject(item);
				String item_id = json.getString("item_id");
				Object clerk_name=getCustomer(getRequest()).get("clerk_name");
				String content=getComName()+"-客户-"+clerk_name+":下订单";
				saveOrderHistory(no, item_id, content);
			} catch (Exception e) {}
		}
		// 1.2组合主表数据
		Map<String, Object> mainmap = new HashMap<String, Object>();
		mainmap.put("com_id", map.get("com_id"));
		mainmap.put("sd_order_direct", "发货");
		mainmap.put("ivt_oper_bill", "发货");
		mainmap.put("ivt_oper_listing", no);
		mainmap.put("dept_id", map.get("dept_id"));
		mainmap.put("sd_order_id", no);
		mainmap.put("comfirm_flag", "N");
		mainmap.put("customer_id", customer_id);
		mainmap.put("regionalism_id", mapcus.get("regionalism_id"));
		mainmap.put("dept_id", mapcus.get("dept_id"));
		if (map.get("clerk_id")!=null) {
			mainmap.put("clerk_id", map.get("clerk_id"));
		}
		mainmap.put("so_consign_date", nowdate);
		mainmap.put("at_term_datetime", nowdate);
		Calendar c = Calendar.getInstance();
		mainmap.put("finacial_y", c.get(Calendar.YEAR));
		mainmap.put("finacial_m", c.get(Calendar.MONTH));
		mainmap.put("all_oq", itemIds.length);
		mainmap.put("mainten_clerk_id", mainten_clerk_id);
		mainmap.put("mainten_datetime", nowdate);
		mainmap.put("settlement_type_id","JS001JS004");
		mainmap.put("HYS", map.get("HYS"));
		mainmap.put("transport_AgentClerk_Reciever", mapcus.get("delivery_Add"));
		mainmap.put("HJJS", itemIds.length);
		productDao.insertSql(getInsertSql("SDd02020", mainmap));
		return null;
	} 
	private Map<String, Object> getOrderPlanDetail(String com_id, JSONObject json,
			String customer_id) {
		String item_id = json.getString("item_id");
		String ivt_oper_listing = json.getString("ivt_oper_listing");
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("ivt_oper_listing", ivt_oper_listing);
		mapParam.put("item_id", item_id);
		mapParam.put("com_id", com_id);
		Map<String, Object> mapPro = productDao.getPlanProDetailInfo(mapParam);
		// /订单明细数据封装
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("com_id", com_id);
		map.put("item_id", item_id);
		map.put("ivt_oper_listing", ivt_oper_listing);
		map.put("sid", mapPro.get("seeds_id"));
		map.put("discount_time", mapPro.get("discount_time"));
		map.put("item_id", mapPro.get("item_id"));
		map.put("peijian_id", mapPro.get("peijian_id"));
		map.put("ivt_oper_bill", mapPro.get("ivt_oper_listing"));
		map.put("unit_id", mapPro.get("unit_id"));
		map.put("sd_oq", json.getString("pronum"));
		getJsonVal(map, json, "ivt_oper_listingMyPlan", "planno");
		getJsonVal(map, json, "pack_num", "pack_unit");
		getJsonVal(map, json, "pack_unit", "casing_unit");
		getJsonVal(map, json, "unit_id", "item_unit");
		getJsonVal(map, json, "sum_si", "sum_si");
		getJsonVal(map, json, "c_memo", "c_memo");
		getJsonVal(map, json, "memo_color", "memo_color");
		getJsonVal(map, json, "memo_other", "memo_other");
		map.put("price_display", mapPro.get("price_display"));// 对外标价
		map.put("price_prefer", mapPro.get("price_prefer"));// 现金折扣
		map.put("price_otherDiscount", mapPro.get("price_otherDiscount"));
		if (json.has("sd_unit_price")) {
			map.put("sd_unit_price", json.get("sd_unit_price"));
		}else{
			map.put("sd_unit_price", mapPro.get("sd_unit_price"));
		}
		map.put("discount_rate", mapPro.get("discount_rate"));
		map.put("tax_rate", mapPro.get("tax_rate"));
		map.put("tax_sum_si", mapPro.get("tax_sum_si"));
		return map;
	}

	private Map<String, Object> getOrderDetail(String com_id, String item,
			String customer_id) throws Exception {
		JSONObject json = JSONObject.fromObject(item);
		String item_id = json.getString("item_id");
		Map<String, Object> mapParam = new HashMap<String, Object>();
		getJsonVal(mapParam, json, "ivt_oper_listing", "ivt_oper_listing");
		Object ivt_oper_listing=mapParam.get("ivt_oper_listing");
		mapParam.put("item_id", item_id);
		mapParam.put("com_id", com_id);
		Map<String, Object> mapPro = productDao.getAddProDetailInfo(mapParam);
		if (mapPro == null) {
			throw new RuntimeException("没有找到该产品报价单对应的信息!");
		}
		// /订单明细数据封装
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item_id", item_id);
		map.put("ivt_oper_listing", ivt_oper_listing);
		map.put("sid", mapPro.get("seeds_id"));
		try {
			map.put("discount_ornot", mapPro.get("discount_ornot"));
			map.put("sd_unit_price_UP", mapPro.get("sd_unit_price_UP"));
			map.put("sd_unit_price_DOWN", mapPro.get("sd_unit_price_DOWN"));
			map.put("discount_time_begin", mapPro.get("discount_time_begin"));
		} catch (Exception e) {
		}
		try {
			map.put("ivt_oper_listingMyPlan", json.getString("planno"));
			map.put("sd_oqMyPlan", json.getString("sid"));
		} catch (Exception e) {
		}
		map.put("sd_oq", json.getString("pronum"));
		getJsonVal(map, json, "pack_num", "pack_unit");
		getJsonVal(map, json, "pack_unit", "casing_unit");
		getJsonVal(map, json, "unit_id", "item_unit");
		getJsonVal(map, json, "sum_si", "sum_si");
		getJsonVal(map, json, "c_memo", "c_memo");
		getJsonVal(map, json, "memo_color", "memo_color");
		getJsonVal(map, json, "memo_other", "memo_other");
		
		map.put("discount_time", mapPro.get("discount_time"));
		map.put("item_id", mapPro.get("item_id"));
		map.put("peijian_id", mapPro.get("peijian_id"));
		map.put("ivt_oper_bill", mapPro.get("ivt_oper_listing"));
		map.put("unit_id", mapPro.get("unit_id"));
		map.put("sd_unit_price", mapPro.get("sd_unit_price"));
		map.put("price_prefer", mapPro.get("price_prefer"));// 现金折扣
		map.put("price_otherDiscount", mapPro.get("price_otherDiscount"));
		map.put("sd_unit_price", mapPro.get("sd_unit_price"));

		map.put("discount_rate", mapPro.get("discount_rate"));
		map.put("tax_rate", mapPro.get("tax_rate"));
		map.put("tax_sum_si", mapPro.get("tax_sum_si"));
		return map;
	}
	private Map<String, Object> getOrderDetail(String com_id, JSONObject json,
			String customer_id) throws Exception {
		String item_id = json.getString("item_id");
		Map<String, Object> mapParam = new HashMap<String, Object>();
		getJsonVal(mapParam, json, "ivt_oper_listing", "ivt_oper_listing");
		Object ivt_oper_listing=mapParam.get("ivt_oper_listing");
		mapParam.put("item_id", item_id);
		mapParam.put("com_id", com_id);
//		Map<String, Object> mapPro = productDao.getAddProDetailInfo(mapParam);
//		if (mapPro == null) {
//			throw new RuntimeException("没有找到该产品报价单对应的信息!");
//		}
		// /订单明细数据封装
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("item_id", item_id);
		map.put("ivt_oper_listing", ivt_oper_listing);
//		map.put("sid", mapPro.get("seeds_id"));
//		try {
//			map.put("discount_ornot", mapPro.get("discount_ornot"));
//			map.put("sd_unit_price_UP", mapPro.get("sd_unit_price_UP"));
//			map.put("sd_unit_price_DOWN", mapPro.get("sd_unit_price_DOWN"));
//			map.put("discount_time_begin", mapPro.get("discount_time_begin"));
//		} catch (Exception e) {
//		}
		try {
			map.put("ivt_oper_listingMyPlan", json.getString("planno"));
			map.put("sd_oqMyPlan", json.getString("sid"));
		} catch (Exception e) {}
		map.put("sd_oq", json.getString("pronum"));
		getJsonVal(map, json, "pack_num", "pack_unit");
		getJsonVal(map, json, "pack_unit", "casing_unit");
		getJsonVal(map, json, "unit_id", "item_unit");
		getJsonVal(map, json, "sum_si", "sum_si");
		getJsonVal(map, json, "sd_unit_price", "sd_unit_price");
		map=getItemByJson(map, json);
		map.put("item_id", json.get("item_id"));
		map.put("discount_time", json.get("discount_time"));
		map.put("item_id", json.get("item_id"));
		map.put("peijian_id", json.get("peijian_id"));
		map.put("ivt_oper_bill", json.get("ivt_oper_listing"));
		map.put("unit_id", json.get("unit_id"));
//		if (json.has("sd_unit_price")) {
			map.put("sd_unit_price", json.get("sd_unit_price"));
//		}else{
//			map.put("sd_unit_price", mapPro.get("sd_unit_price"));
//		}
		map.put("price_prefer", json.get("price_prefer"));// 现金折扣
		map.put("price_otherDiscount", json.get("price_otherDiscount"));
		
		map.put("discount_rate", json.get("discount_rate"));
		map.put("tax_rate", json.get("tax_rate"));
		map.put("tax_sum_si", json.get("tax_sum_si"));
		return map;
	}


	
//	private void getJsonVal(Map<String, Object> map, JSONObject json,
//			String key, String name) {
//		try {
//			map.put(key, json.getString(name));
//		} catch (Exception e) {
//		}
//	}
	@Override
	@Transactional
	public String savePlan(Map<String, Object> map) {
		// TODO 保存计划 
		//获取指定客户的当天是否已经下计划
		Object planNo=map.get("planNo");
		if(isMapKeyNull(map, "planNo")){
			Map<String,Object> planinfo=productDao.getAddedPlanInfo(map);
			if(planinfo!=null){
				map.put("planNo", planinfo.get("ivt_oper_listing"));
			}
		}
		if(isMapKeyNull(map, "planNo")){
			String no = getOrderNo(customerDao, "销售计划", map.get("com_id")
					.toString());
			planNo=no;
			Map<String, Object> mapitem = new HashMap<String, Object>();
			mapitem.put("com_id", map.get("com_id"));
			mapitem.put("ivt_oper_listing", no);// 计划单号
			mapitem.put("sd_order_id", no);// 计划单号
			mapitem.put("customer_id", map.get("customer_id"));
			mapitem.put("accountTurn_Flag", "未结转");
			mapitem.put("item_id", map.get("item_id")); 
			mapitem.put("sd_oq", map.get("sd_oq")); 
			mapitem.put("send_qty", map.get("kucun"));//库存
			mapitem.put("discount_rate", map.get("item_cost"));//采购价
			mapitem.put("sd_unit_price", map.get("sd_unit_price"));//零售价
			productDao.insertSql(getInsertSql("SDP02021", mapitem));
			// /组合计划主表数据
			Map<String, Object> mapmain = new HashMap<String, Object>();
			mapmain.put("com_id", map.get("com_id"));
			mapmain.put("ivt_oper_bill", "发货");// 单据的操作类型
			mapmain.put("ivt_oper_listing", no);// 计划单号
			mapmain.put("sd_order_id", no);// 计划单号
			Calendar c = Calendar.getInstance();
			mapmain.put("finacial_y", c.get(Calendar.YEAR));
			mapmain.put("finacial_m", c.get(Calendar.MONTH));
			mapmain.put("comfirm_flag", "Y");
			mapmain.put("customer_id",  map.get("customer_id"));
			mapmain.put("sd_order_direct", map.get("sd_order_direct"));// 计划类型
			mapmain.put("so_consign_date", getNow());
			mapmain.put("at_term_datetime",DateTimeUtils.dateToStr(DateUtils.addDays(new Date(), 1)));
			mapmain.put("if_Insert_Plan", map.get("if_Insert_Plan"));
			mapmain.put("dept_id", map.get("dept_id"));
			mapmain.put("regionalism_id", map.get("regionalism_id"));
			mapmain.put("mainten_clerk_id", map.get("customer_id"));
			mapmain.put("mainten_datetime", getNow());
			productDao.insertSql(getInsertSql("SDP02020", mapmain));
		}else{//更新计划
			Map<String, Object> mapitem=new HashMap<String, Object>();
			mapitem.put("sd_oq", map.get("sd_oq")); 
			mapitem.put("send_qty", map.get("kucun"));
			mapitem.put("sd_unit_price", map.get("sd_unit_price"));
			productDao.insertSql(getUpdateSql(mapitem, "SDP02021", "ivt_oper_listing", map.get("planNo")+"")
					+" and ltrim(rtrim(isnull(item_id,'')))='"+map.get("item_id")+"'"
					+" and ltrim(rtrim(isnull(customer_id,'')))='"+map.get("customer_id")+"'");
			Map<String, Object> mapmain = new HashMap<String, Object>();
			mapmain.put("mainten_clerk_id", map.get("customer_id"));
			mapmain.put("mainten_datetime", getNow());
			productDao.insertSql(getUpdateSql(mapitem, "SDP02021", "ivt_oper_listing", map.get("planNo")+"")
					+" and ltrim(rtrim(isnull(customer_id,'')))='"+map.get("customer_id")+"'");
		}
		return planNo.toString();
	}
	@Override
	@Transactional
	public void addPlan(Map<String, Object> map) {
		String customer_id = map.get("customer_id").toString();
		String comId = map.get("com_id").toString();
		Map<String, Object> mapcus = customerDao.getCustomerByCustomer_id(
				customer_id, comId);
		if (mapcus == null) {
			throw new RuntimeException("没有获取到客户信息!");
		}
		String clerk_id = null;
		if (isNotMapKeyNull(map, "clerk_id")) {
			clerk_id = map.get("clerk_id").toString();
		}
		JSONArray jsons=JSONArray.fromObject(map.get("itemIds"));
		if (jsons == null || jsons.size() <= 0) {
			throw new RuntimeException("请至少选择一个产品!");
		}
		String no = getOrderNo(customerDao, "销售计划", map.get("com_id")
				.toString());
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			// 查询为该客户下订单是否有客户价单表,验证客户来源是否正常
			json.put("com_id", map.get("com_id"));
			json.put("customer_id", map.get("customer_id"));
			json.put("ivt_oper_listing", json.get("ivt_oper_bill"));
			Map<String, Object> mapaddpro = productDao.getAddProInfo(json);
			if (mapaddpro == null) {
				throw new RuntimeException("没有获取到客户价单表信息!");
			}
			Map<String, Object> mapitem = new HashMap<String, Object>();
			mapitem.put("com_id", map.get("com_id"));
			mapitem.put("ivt_oper_listing", no);// 计划单号
			mapitem.put("sd_order_id", no);// 计划单号
			mapitem.put("customer_id", customer_id);
			mapitem.put("accountTurn_Flag", "未结转");
			mapitem.put("ivt_oper_bill", json.getString("ivt_oper_bill"));// /价单单号内码ivt_oper_listing
			mapitem.put("sid", json.getInt("sid"));// /【客户价单表-视图】中的“从表行种子seeds_id
			mapitem.put("clerk_id_sid", json.getString("clerk_id_sid"));// /【客户价单表-视图】中的对应的销售员编码clerk_id
			mapitem.put("item_id", json.getString("item_id"));// /【客户价单表-视图】中的“从表行种子seeds_id
			getJsonVal(mapitem, json, "sd_oq", "num");
			getJsonVal(mapitem, json, "c_memo", "c_memo");
			getJsonVal(mapitem, json, "memo_color", "memo_color");
			getJsonVal(mapitem, json, "memo_other", "memo_other");
			Map<String, Object> mapParam = new HashMap<String, Object>();
			mapParam.put("ivt_oper_listing", json.getString("ivt_oper_bill"));
			mapParam.put("item_id", json.getString("item_id"));
			mapParam.put("com_id", map.get("com_id"));
			Map<String, Object> map2 = productDao.getAddProDetailInfo(mapParam);
			mapitem.put("price_display", map2.get("price_display"));// 对外标价
			mapitem.put("price_prefer", map2.get("price_prefer"));// 现金折扣
			mapitem.put("price_otherDiscount", map2.get("price_otherDiscount"));
			mapitem.put("sd_unit_price", map2.get("sd_unit_price"));
			productDao.insertSql(getInsertSql("SDP02021", mapitem));
		}
		// /组合计划主表数据
		Map<String, Object> mapmain = new HashMap<String, Object>();
		mapmain.put("com_id", map.get("com_id"));
		mapmain.put("ivt_oper_bill", "发货");// 单据的操作类型
		mapmain.put("ivt_oper_listing", no);// 计划单号
		mapmain.put("sd_order_id", no);// 计划单号
		Calendar c = Calendar.getInstance();
		mapmain.put("finacial_y", c.get(Calendar.YEAR));
		mapmain.put("finacial_m", c.get(Calendar.MONTH));
		if ("是".equals(map.get("if_Insert_Plan"))) {// 查单需要进行审批
			mapmain.put("comfirm_flag", "N");
		} else {
			mapmain.put("comfirm_flag", "Y");
		}
		mapmain.put("customer_id", customer_id);
		mapmain.put("sd_order_direct", map.get("sd_order_direct"));// 计划类型
		mapmain.put("so_consign_date", map.get("so"));
		mapmain.put("at_term_datetime", map.get("at"));
		mapmain.put("if_Insert_Plan", map.get("if_Insert_Plan"));
		mapmain.put("dept_id", map.get("dept_id"));
		mapmain.put("regionalism_id", mapcus.get("regionalism_id"));
		if (StringUtils.isBlank(clerk_id)) {
			mapmain.put("mainten_clerk_id", map.get("com_id"));
		} else {
			mapmain.put("clerk_id", clerk_id);
			mapmain.put("mainten_clerk_id", clerk_id);
		}
		mapmain.put("mainten_datetime", getNow());

		productDao.insertSql(getInsertSql("SDP02020", mapmain));
		if ("是".equals(map.get("if_Insert_Plan"))) {// 查单需要进行审批
			// 审批流程
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss",
					Locale.CHINA);
			Map<String, Object> mapsp = new HashMap<String, Object>();
			mapsp.put("com_id", comId);
			Integer opid = getApprovalNo(format.format(new Date()));
			String op_id = "SPNR" + format.format(new Date())
					+ String.format("%03d", opid);
			mapsp.put("ivt_oper_listing", op_id);
			mapsp.put("sd_order_id", op_id);
			////
			Map<String,Object> process=getProcessInfoByName("插单计划审批","asc",productDao);
			Map<String,Object> cus= employeeDao.getPersonnel(process.get("clerk_id")+"", getComId());
			Object clerk_idAccountApprover=map.get("clerk_idAccountApprover");
			if (!"客户审批员".equals(cus.get("clerk_name"))) {
				clerk_idAccountApprover=process.get("clerk_id");
			}
//			Object clerk_idAccountApprover=setClerk_idAccountApprover(process.get("clerk_id"), map);
		    mapsp.put("item_id",process.get("item_id"));
			mapsp.put("store_date", getNow());
			if (StringUtils.isBlank(clerk_id)) {
				mapsp.put("mainten_clerk_id", comId);
			}else {
				mapsp.put("mainten_clerk_id", clerk_id);
			}
			mapsp.put("maintenance_datetime", getNow());
			mapsp.put("content", map.get("insert_remark"));
			mapsp.put("approval_step", 1);
			mapsp.put("OA_what", "计划插单审批,计划单号:" + no);
			mapsp.put("OA_who", customer_id);
			mapsp.put("OA_whom", clerk_idAccountApprover);
			customerDao.insertSql(getInsertSql("OA_ctl03001_approval", mapsp));
		}
	}

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

	/**
	 * 同步产品与价单表,计划表
	 * 
	 * @param item_id
	 * @param table
	 * @param dest
	 * @param rule_out
	 */
	public void product(Map<String, String> item_id, Map<String, String> dest,
			String... rule_out) {
		StringBuffer sSql = new StringBuffer("update ");
		sSql.append(dest.get("table")).append(" set ");
		Map<String, Object> map_pro = productDao.getProductByItem_id(item_id);
		// Map<String,Object> map=productDao.getRecordByNo(no);

		Object[] objs = map_pro.keySet().toArray();
		// Collection<Object> c = map_pro.values();
		// Object[] vals = c.toArray();
		for (int i = 0; i < objs.length; i++) {
			String key = objs[i].toString();
			if (i == (objs.length - 1)) {
				sSql.append(key).append("=").append(map_pro.get(key));
			} else {
				sSql.append(key).append("=").append(map_pro.get(key))
						.append(",");
			}
		}
		sSql.append(" where ").append(dest.get("name")).append("=")
				.append(dest.get("val"));
		productDao.insertSql(sSql.toString());
	}

	@Override
	public PageList<Map<String, Object>> getPlanList(Map<String,Object> map) {
		String beginTime = null;
		String endTime = getNow();
		if ("%周计划%".equals(map.get("goods_origin"))) {
			beginTime = DateTimeUtils.getConvertWeekByDate(
					getNow().split(" ")[0]).get("beginTime");// DateTimeUtils.getTimesWeekmorning();
		} else if ("%月计划%".equals(map.get("goods_origin"))) {
			beginTime = DateTimeUtils.getTimesMonthmorning();
		} else {
			Date date = new Date();
			String dayTime_Of_SdPlan=systemParamsDao.checkSystemDef("dayTime_Of_SdPlan", "00:00:00", getComId());
			Date anotherDate = DateTimeUtils.strToDateTime(DateTimeUtils
					.dateToStr() +" "+ dayTime_Of_SdPlan);
			if(isNotMapKeyNull(map, "beginDate")){
				beginTime = map.get("beginDate").toString();
			}else{
				beginTime = DateTimeUtils.dateToStr(date);
				if (date.compareTo(anotherDate) != 1) {// /anotherDate大于now为1开始日期减1
					beginTime = DateTimeUtils
							.dateToStr(DateUtils.addDays(date, -1));
				} else {// 结束日期加1
					endTime = DateTimeUtils.dateToStr(DateUtils.addDays(date, 1));
				}
			}
			if(isNotMapKeyNull(map, "endDate")){
				endTime = map.get("endDate").toString();
			}else{
				endTime = DateTimeUtils.dateToStr(DateUtils.addDays(date, 1));
			}
			beginTime = beginTime +" "+dayTime_Of_SdPlan;
			endTime = endTime +" "+dayTime_Of_SdPlan;
		}
		map.put("beginTime", beginTime);
		map.put("endTime", endTime);
		map.put("comfirm_flag", "N");
		map.put("client", map.get("client"));
		map.put("clerk_id", map.get("employeeId"));
		map.put("customer_id", map.get("customer_id"));
		map.put("goods_origin",map.get("goods_origin"));
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getPlanListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=productDao.getPlanList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	@Transactional
	public void delPlan(Map<String, Object> map) {
		// String clerk_id=map.get("clerk_id").toString();
		String[] itemIds = (String[]) map.get("itemIds");
		for (String item : itemIds) {
			JSONObject json = JSONObject.fromObject(item);
			Integer sid = json.getInt("sid");
			String ivt_oper_bill = json.getString("ivt_oper_bill");
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("ivt_oper_bill", ivt_oper_bill);
			param.put("sid", sid);
			param.put("com_id", map.get("com_id"));
			productDao.delPlan(param);
		}

	}

	@Override
	public Integer getPlanDetailCount(Map<String, Object> param) {
		return productDao.getPlanDetailCount(param);
	}

	@Override
	@Transactional
	public void delPlanMain(Map<String, Object> param) {
		productDao.delPlanMain(param);
	}

	@Override
	@Transactional
	public void delAddPro(Map<String, Object> map) {
		if (isMapKeyNull(map, "itemIds")) {
			return;
		}
		String[] itemIds = (String[]) map.get("itemIds");
		for (String item : itemIds) {
			JSONObject json = JSONObject.fromObject(item);
			Integer sid = json.getInt("sid");
			String ivt_oper_bill = json.getString("ivt_oper_bill");
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("ivt_oper_bill", ivt_oper_bill);
			param.put("sid", sid);
			param.put("com_id", map.get("com_id"));
			productDao.delAddPro(param);
		}
	}

	@Override
	public Integer getAddDetailCount(Map<String, Object> param) {

		return productDao.getAddDetailCount(param);
	}

	@Override
	@Transactional
	public void delAddProMain(Map<String, Object> param) {
		productDao.delAddProMain(param);
	}
	@Override
	public String confirmAddPro(Map<String, Object> map) {
		String sSql="update sdd02011 set m_flag=#{m_flag} where seeds_id =#{sid}";
		if ("confirm".equals(map.get("confirm"))) {
			map.put("m_flag", "1");
		}else{
			map.put("m_flag", "0");
		}
		map.put("sSql", sSql);
		productDao.insertSqlByPre(map);
		
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getPlanOrder(ProductQuery query) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("query", query);
		Map<String, Object> mapparam = new HashMap<String, Object>();
		mapparam.put("com_id", query.getCom_id());
		mapparam.put("time", query.getBeginTime());
		String beginTime = productDao.getPlanOutExcelTime(mapparam);
		Map<String,Object> mapsms=getSystemParamsByComId();
		if (StringUtils.isBlank(beginTime)) {
			beginTime = query.getBeginTime() +mapsms.get("dayTime_Of_SdPlan");
		}
		mapparam.put("time", query.getEndTime());
		String endTime = productDao.getPlanOutExcelTime(mapparam);
		if (StringUtils.isBlank(endTime)) {
			if (StringUtils.isNotBlank(query.getEndTime())) {
				endTime = query.getEndTime() + mapsms.get("dayTime_Of_SdPlan");
			}
		}
		map.put("beginTime", beginTime);
		map.put("endTime", endTime);
		Integer count = productDao.getPlanOrderCount(map);
		PageList<Map<String, Object>> pages = getPageListToAdd(query, count);
		List<Map<String, Object>> rows = productDao.getPlanOrderPage(map);
		pages.setRows(rows);
		return pages;
	}
	@Override
	@Transactional
	public StringBuffer delOrderPro(String[] itemIds,String com_id) {
		StringBuffer buffer=new StringBuffer();
		String proName=getProcessName(getRequest(), 0);
		for (String str : itemIds) {
			buffer.append(str).append("->");
			JSONObject json=JSONObject.fromObject(str);
			///1.先判断订单产品当前状态
			Map<String,Object> orderinfo= employeeDao.getOrderInfoBySeeds_id(json.getString("seeds_id"));
			if(isNotMapKeyNull(orderinfo, "st_hw_no")){
				throw new RuntimeException("已向供应商下采购订单!");
			}
			if(isNotMapKeyNull(orderinfo, "Status_OutStore")){
				if("待支付".equals(orderinfo.get("Status_OutStore"))&&
						"支付中".equals(orderinfo.get("Status_OutStore"))){
					if(!proName.equals(getMapKey(orderinfo, "Status_OutStore"))){
						throw new RuntimeException("内勤已经核货并开始订单流程!");
					}
				}
			}
			json.getString("ivt_oper_bill");
			String sSql="delete from sdd02021 where seeds_id="+json.getInt("seeds_id");
			productDao.insertSql(sSql);
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", "sdd02021");
			mapquery.put("showFiledName", "ivt_oper_listing");
			mapquery.put("findFiled", "ivt_oper_listing='" + json.getString("ivt_oper_bill")
					+ "'");
			mapquery.put("com_id", com_id);
			Object obj=productDao.getOneFiledNameByID(mapquery);
			if (obj==null) {
				buffer.append("订单主表->").append(json.getString("ivt_oper_bill"));
				 sSql="delete from sdd02020 where ivt_oper_listing='"+json.getString("ivt_oper_bill")+"'";
				productDao.insertSql(sSql);
			}
		}
		return buffer;
	}
	@Override
	@Transactional
	public String delShopping(Map<String, Object> map) {
		String sSql="delete from sdd02021 where seeds_id="+map.get("seeds_id");
		productDao.insertSql(sSql);
		Map<String, Object> mapquery = new HashMap<String, Object>();
		mapquery.put("table", "sdd02021");
		mapquery.put("showFiledName", "ivt_oper_listing");
		mapquery.put("findFiled", "ivt_oper_listing='" + map.get("orderNo")
				+ "'");
		mapquery.put("com_id", map.get("com_id"));
		Object obj=productDao.getOneFiledNameByID(mapquery);
		if (obj==null) {
			 sSql="delete from sdd02020 where ivt_oper_listing='"+map.get("orderNo")+"'";
			productDao.insertSql(sSql);
		}
		return null;
	}
	/**
	 * 组合参数,用于总计和数据列表进行分开查询
	 * 
	 * @param map
	 * @return
	 */
	private Map<String, Object> getPlanReportParams(Map<String, Object> map) {
		if (map.get("beginDate") == null) {
			if (!"%日计划%".equals(map.get("sd_order_direct").toString())) {
				map.put("beginDate", DateTimeUtils.dateToStr());
			} else {
				return map;
			}
		}
		if ("%周计划%".equals(map.get("sd_order_direct").toString())) {
			map.put("beginTime",
					DateTimeUtils.getConvertWeekByDate(
							map.get("beginDate").toString()).get("beginTime"));
			map.put("endTime",
					DateTimeUtils.getConvertWeekByDate(
							map.get("beginDate").toString()).get("endTime"));
		} else if ("%月计划%".equals(map.get("sd_order_direct").toString())) {
			map.put("beginTime", DateTimeUtils.getFirstDayOfMonth(map.get(
					"beginDate").toString()));
			map.put("endTime", DateTimeUtils.getLastDayOfMonth(map.get(
					"beginDate").toString()));
		} else {
			Map<String,Object> mapsms=getSystemParamsByComId();
			if (isNotMapKeyNull(mapsms, "dayTime_Of_SdPlan")) {
				// Date now=new Date();
				// Date
				// anotherDate=DateTimeUtils.strToDateTime(DateTimeUtils.dateToStr()+ConfigFile.dayTime_Of_SdPlan);
				Date date = DateTimeUtils.strToDate(map.get("beginDate")
						.toString());
				String begintime = DateTimeUtils.dateToStr(date);
				String endTime = DateTimeUtils.dateToStr(date);
				// if (now.compareTo(anotherDate)!=1)
				// {///anotherDate大于now为1开始日期减1
				begintime = DateTimeUtils
						.dateToStr(DateUtils.addDays(date, -1));
				// }else{//结束日期加1
				// endTime=DateTimeUtils.dateToStr(DateUtils.addDays(date, 1));
				// }
				map.put("beginTime", begintime + mapsms.get("dayTime_Of_SdPlan"));
				map.put("endTime", endTime + mapsms.get("dayTime_Of_SdPlan"));
			}
		}
		return map;
	}

	@Override
	public PageList<Map<String, Object>> weeklyPlanAllProduct(
			Map<String, Object> map) {
		map = getPlanReportParams(map);
		List<Map<String, Object>> list = null;
		if ("day".equals(map.get("fenxi")) || "day".equals(map.get("day"))) {
			list = productDao.dayPlanAllProduct(map);
		} else {
			list = productDao.weeklyPlanAllProduct(map);
		}
		// 1.获取总记录数
		Integer count = list.size();
		PageList<Map<String, Object>> pages = getNewPages(map, count);
		// 2.循环取10条数据
		Integer page = Integer.parseInt(map.get("page").toString());
		Integer rows = Integer.parseInt(map.get("rows").toString());
		List<Map<String, Object>> listrows = new ArrayList<Map<String, Object>>();
		// 计算所在的周次
		int index = 0;
		for (int i = (page * rows); i < list.size(); i++) {
			Map<String, Object> itemMap = list.get(i);
			// ///////////
			itemMap.put("weeksnum", getWeeknum(map));// 所在周次
			itemMap = getInfoById(itemMap, map);
			// //////////
			listrows.add(itemMap);
			index++;
			if (index == rows) {
				break;
			}
		}
		pages.setRows(listrows);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> monthlyPlan(Map<String, Object> map) {
		map = getPlanReportParams(map);
		List<Map<String, Object>> list = productDao.monthlyPlan(map);
		PageList<Map<String, Object>> pages = getNewPages(map, list.size());
		// 2.循环取10条数据
		Integer page = Integer.parseInt(map.get("page").toString());
		Integer rows = Integer.parseInt(map.get("rows").toString());
		int index = 0;
		List<Map<String, Object>> listrows = new ArrayList<Map<String, Object>>();
		for (int i = (page * rows); i < list.size(); i++) {
			Map<String, Object> itemMap = list.get(i);
			// ///////////
			itemMap.put("weeksnum", getWeeknum(map));// 所在周次
			itemMap = getInfoById(itemMap, map);
			// //////////
			listrows.add(itemMap);
			index++;
			if (index == rows) {
				break;
			}
		}
		pages.setRows(listrows);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> dayProduct(Map<String, Object> map) {
		map = getPlanReportParams(map);
		List<Map<String, Object>> list = productDao.dayProduct(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator
				.hasNext();) {
			Map<String, Object> itemMap = (Map<String, Object>) iterator.next();
			// ///////////
			getInfoById(itemMap, map);
			// //////////
		}
		PageList<Map<String, Object>> pages = new PageList<Map<String, Object>>(
				0, 1000, list.size());
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> weekProduct(Map<String, Object> map) {
		map = getPlanReportParams(map);
		List<Map<String, Object>> list = productDao.weekProduct(map);
		PageList<Map<String, Object>> pages = new PageList<Map<String, Object>>(
				0, 1000, list.size());
		pages.setRows(list);
		return pages;
	}

	/**
	 * 根据id获取附属信息
	 * 
	 * @param itemMap
	 *            主信息存放map,并将附属信息放入并返回
	 * @param map
	 *            参数存放map
	 * @return
	 */
	private Map<String, Object> getInfoById(Map<String, Object> itemMap,
			Map<String, Object> map) {
		Object dept_id = itemMap.get("dept_id");
		Object item_id = itemMap.get("item_id");
		Object clerk_id = itemMap.get("clerk_id");
		Object customer_id = itemMap.get("customer_id");
		Object item_name = itemMap.get("item_name");
		Object dept_name = itemMap.get("dept_name");
		Object find = map.get("find");
		Map<String, String> mapno = new HashMap<String, String>();
		mapno.put("com_id", map.get("com_id").toString());
		if (dept_id != null && dept_id != "" && !"合计".equals(dept_id)) {
			if (dept_name == null || find == null) {
				mapno.put("table", "Ctl00701");
				mapno.put("name", "sort_id");
				mapno.put("val", dept_id.toString());
				Map<String, Object> deptMap = productDao.getRecordByNo(mapno);
				if (deptMap != null) {
					itemMap.put("dept_name", deptMap.get("dept_name"));
					if (find == null) {
						itemMap.put("dept", deptMap);
					}
				}
			}
		}

		if (item_id != null && item_id != "" && !"小计".equals(item_id)
				&& !"合计".equals(item_id)) {
			if (item_name == null || find == null) {
				mapno.put("table", "ctl03001");
				mapno.put("name", "item_id");
				mapno.put("val", item_id.toString());
				Map<String, Object> proMap = productDao.getRecordByNo(mapno);
				if (proMap != null) {
					itemMap.put("item_name", proMap.get("item_sim_name"));
					if (find == null) {
						itemMap.put("item", proMap);
					}
					BigDecimal sd_oq = getPrice(itemMap, "sd_oq");
					BigDecimal pack_unit = getPrice(proMap, "pack_unit");
					if (pack_unit.compareTo(BigDecimal.ZERO)!=0) {
						itemMap.put("num", sd_oq.divide(pack_unit));
					}
				}
			}
		}
		if (clerk_id != null && clerk_id != "") {
			if (map.get("clerk_name") == null || find == null) {
				mapno.put("table", "Ctl00801");
				mapno.put("name", "clerk_id");
				mapno.put("val", clerk_id.toString());
				Map<String, Object> proMap = productDao.getRecordByNo(mapno);
				if (proMap != null) {
					itemMap.put("clerk_name", proMap.get("clerk_name"));
					if (find == null) {
						itemMap.put("clerk", proMap);
					}
				}
			}
		}
		if (customer_id != null && customer_id != "") {
			if (map.get("corp_sim_name") == null || find == null) {
				mapno.put("table", "SDf00504");
				mapno.put("name", "customer_id");
				mapno.put("val", customer_id.toString());
				Map<String, Object> proMap = productDao.getRecordByNo(mapno);
				if (proMap != null) {
					itemMap.put("corp_sim_name", proMap.get("corp_sim_name"));
					if (find == null) {
						itemMap.put("customer", proMap);
					}
				}
			}
		}
		if (!"小计".equals(item_id) && map.get("seeds_id") == null) {
			if (!"合计".equals(item_id) && !"总计".equals(item_id)
					&& !"合计".equals(dept_id)) {
				// /获取员工
				Map<String, Object> mapinfo = new HashMap<String, Object>();
				mapinfo.put("com_id", map.get("com_id").toString());
				mapinfo.put("item_id", item_id);
				mapinfo.put("dept_id", dept_id);
				mapinfo.put("customer_id", customer_id);
				mapinfo.put("clerk_id", clerk_id);
				mapinfo.put("beginTime", map.get("beginTime"));
				mapinfo.put("endTime", map.get("endTime"));
				mapinfo.put("sd_order_direct", map.get("sd_order_direct"));
				Object type = map.get("type");
				if (type != null && type != "") {// /判断是否是插单的
					if ("4".equals(type)) {
						mapinfo.put("if_Insert_Plan", "是");
					} else if ("5".equals(type)) {
						mapinfo.put("if_Insert_Plan", "否");
					}
				}
				Map<String, Object> mapplan = productDao
						.getPlanInfoByCustomerPro(mapinfo);
				if (mapplan != null) {// .toString().split(" ")[0]
					itemMap.put("so_consign_date",
							mapplan.get("so_consign_date"));
					if (itemMap.get("at_term_datetime") == null) {
						itemMap.put("at_term_datetime",
								mapplan.get("at_term_datetime").toString()
										.split(" ")[0]);
					}
					itemMap.put("clerk_name", mapplan.get("clerk_name"));
					itemMap.put("ivt_oper_listing",
							mapplan.get("ivt_oper_listing"));
					if (find == null) {
						itemMap.put("info", mapplan);
					}
				}
			}
		}
		removeId(itemMap);
		return itemMap;
	}

	private void removeId(Map<String, Object> itemMap) {
		itemMap.remove("item_id");
		itemMap.remove("dept_id");
		itemMap.remove("customer_id");
		itemMap.remove("clerk_id");
	}

	/**
	 * 生成一个分页数据对象
	 * 
	 * @param map
	 * @param count
	 * @return
	 */
	private PageList<Map<String, Object>> getNewPages(Map<String, Object> map,
			Integer count) {
		return new PageList<Map<String, Object>>(Integer.parseInt(map.get(
				"page").toString()), Integer.parseInt(map.get("rows")
				.toString()), count);
	}

	@Override
	public Map<String, Object> weeklyPlanAllProductCount(Map<String, Object> map) {
		map = getPlanReportParams(map);
		return productDao.weeklyPlanAllProductCount(map);
	}

	@Override
	public Map<String, Object> weeklyPlanAllProductExcel(Map<String, Object> map) {
		map = getPlanReportParams(map);
		Map<String, Object> mainmap = new HashMap<String, Object>();
		List<Map<String, Object>> listrows = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> list = null;
		if ("day".equals(map.get("fenxi")) || "day".equals(map.get("day"))) {
			list = productDao.dayPlanAllProduct(map);
		} else {
			list = productDao.weeklyPlanAllProduct(map);
		}
		for (Map<String, Object> itemMap : list) {
			// ///////////
			itemMap = getInfoById(itemMap, map);
			// //////////
			listrows.add(itemMap);
		}
		updateExcelOutFlag(list);
		// if (map.get("excel")==null) {//导出总计
		// listrows.add(productDao.weeklyPlanAllProductCount(map));
		// }
		mainmap.put("list", listrows);
		mainmap.put("date", DateTimeUtils.dateToStr());
		// 计算所在的周次
		mainmap.put("weeksnum", getWeeknum(map));
		return mainmap;
	}

	@Override
	public Map<String, Object> weekProductExcel(Map<String, Object> map) {
		map = getPlanReportParams(map);
		Map<String, Object> mainmap = new HashMap<String, Object>();
		List<Map<String, Object>> listrows = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> list = productDao.weekProduct(mainmap);
		for (Map<String, Object> itemMap : list) {
			// ///////////
			itemMap = getInfoById(itemMap, map);
			// //////////
			listrows.add(itemMap);
		}
		mainmap.put("list", listrows);
		mainmap.put("date", DateTimeUtils.dateToStr());
		// 计算所在的周次
		mainmap.put("weeksnum", getWeeknum(map));
		return mainmap;
	}

	@Override
	public Map<String, Object> dayProductExcel(Map<String, Object> map) {
		map = getPlanReportParams(map);
		Map<String, Object> mainmap = new HashMap<String, Object>();
		List<Map<String, Object>> listrows = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> list = productDao.dayProduct(mainmap);
		for (Map<String, Object> itemMap : list) {
			// ///////////
			itemMap = getInfoById(itemMap, map);
			// //////////
			listrows.add(itemMap);
		}
		mainmap.put("list", listrows);
		mainmap.put("date", DateTimeUtils.dateToStr());
		return mainmap;
	}

	@Override
	public Map<String, Object> monthlyPlanExcel(Map<String, Object> map) {
		map = getPlanReportParams(map);
		List<Map<String, Object>> list = productDao.monthlyPlan(map);
		Map<String, Object> mainmap = new HashMap<String, Object>();
		List<Map<String, Object>> listrows = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> itemMap : list) {
			// ///////////
			itemMap = getInfoById(itemMap, map);
			// //////////
			listrows.add(itemMap);
		}
		updateExcelOutFlag(list);
		mainmap.put("list", listrows);
		mainmap.put("date", DateTimeUtils.dateToStr());
		// 计算所在的周次
		String d = DateTimeUtils.dateToStr(DateUtils.addMonths(
				DateTimeUtils.strToDate(map.get("beginDate").toString()), 1));
		mainmap.put("weeksnum", d);
		return mainmap;
	}

	/**
	 * 更新excel导出标识
	 * 
	 * @param list
	 *            更新列表
	 */
	private void updateExcelOutFlag(List<Map<String, Object>> list) {
		if (list != null && list.size() > 0) {
			for (Map<String, Object> itemMap : list) {
				updateExcelOutFlagOne(itemMap);
			}
		}
	}

	/**
	 * 更新一条excel导出标识
	 * 
	 * @param itemMap
	 *            数据存放map
	 */
	private void updateExcelOutFlagOne(Map<String, Object> itemMap) {
		if (itemMap.get("ivt_oper_listing") != null) {
			Map<String, Object> mapupdate = new HashMap<String, Object>();
			mapupdate.put("com_id", itemMap.get("com_id"));
			mapupdate.put("ivt_oper_listing", itemMap.get("ivt_oper_listing"));
			mapupdate.put("accountTurn_Time", getNow());
			StringBuffer buffer = new StringBuffer(
					"update SDP02021 set accountTurn_Flag='已结转',accountTurn_Time=#{accountTurn_Time}");
			buffer.append(" where ivt_oper_listing=#{ivt_oper_listing}")
					.append(" and com_id=#{com_id}")
					.append(" and isnull(accountTurn_Time,'')='' ");
			mapupdate.put("sSql", buffer.toString());
			productDao.insertSqlByPre(mapupdate);
		}
	}

	/**
	 * 获取指定日期的周次并加1
	 * 
	 * @param map
	 * @return
	 */
	private int getWeeknum(Map<String, Object> map) {
		if (map.get("beginDate") == null) {
			return 0;
		} else {
			return DateTimeUtils.getWeekNum(map.get("beginDate").toString());
		}
	}

	@Override
	public Object getOneFiledNameByID(Map<String, Object> mapquery) {
		return productDao.getOneFiledNameByID(mapquery);
	}

	@Override
	@Transactional
	public void saveExcelImportData(
			Map<String, List<Map<String, Object>>> maplist,
			HttpServletRequest request) {
		List<Map<String, Object>> list = maplist.get("list");
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		// 1.先存储主表
		String maintable = "sdd02020";
		String itemtable = "sdd02021";
		// List<Map<String,Object>> listno=new ArrayList<Map<String,Object>>();
		String com_id = mainlist.get(0).get("com_id").toString();
		try {
			for (Map<String, Object> map : mainlist) {
				// 获取外部单号
				if (map.get("sd_order_id") != null) {
					String sd_order_id = map.get("sd_order_id").toString();
					// Map<String, Object> mapno=new HashMap<String, Object>();
					// 查询数据库检查外部单号是否存在
					Map<String, Object> mapquery = new HashMap<String, Object>();
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "sd_order_id");
					mapquery.put("findFiled", "sd_order_id='" + sd_order_id
							+ "'");
					mapquery.put("com_id", com_id);
					// /判断l
					Object obj = productDao.getOneFiledNameByID(mapquery);
					if (obj == null) {// 不等于空说明已经存储过主表将不再存储
						String no = getOrderNo(customerDao, "销售开单", com_id);
						// 放入
						// mapno.put("ivt_oper_listing", no);
						// mapno.put("sd_order_id", sd_order_id);
						// mapno.put("customer_id", map.get("customer_id"));

						// getFinacial(mapquery, "at_term_datetime_Act");

						map.put("ivt_oper_listing", no);
						map.put("ivt_oper_cfm", map.get("mainten_clerk_id"));
						map.put("ivt_oper_cfm_time", getNow());
						
						Object is_sendmsg= map.get("if_sendmsg");
						if (is_sendmsg!=null) {
							if ("1".equals(is_sendmsg.toString().trim())||"是".equals(is_sendmsg.toString().trim())) {
								map.put("if_sendmsg", "是");
							}else{
								map.put("if_sendmsg", "否");
							}
						}
						String sSql = getInsertSqlByPre(maintable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
					// listno.add(mapno);
				}
			}
			StringBuffer buffer = new StringBuffer();
			for (Map<String, Object> map : list) {
				// 获取外部单号
				if (map.get("sd_order_id") != null) {
					String sd_order_id = map.get("sd_order_id").toString();
					Map<String, Object> mapquery = new HashMap<String, Object>();
					// 从主表中获取单号根据订单外部单号
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "ivt_oper_listing");
					mapquery.put("findFiled", "sd_order_id='" + sd_order_id
							+ "'");
					mapquery.put("com_id", com_id);
					Object no = productDao.getOneFiledNameByID(mapquery);
					if (no != null) {
						map.put("ivt_oper_listing", no);
						// 计算结算单价sd_unit_price
						BigDecimal price_display = getPrice(map,
								"price_display");
						BigDecimal price_prefer = getPrice(map, "price_prefer");
						BigDecimal price_otherDiscount = getPrice(map,
								"price_otherDiscount");
						// BigDecimal sd_oq=getPrice(map,"sd_oq");
						LoggerUtils.info(price_display.toString()
								+ price_prefer + price_otherDiscount);
						BigDecimal sd_unit_price = price_display.subtract(
								price_prefer).subtract(price_otherDiscount);
						// sd_unit_price=sd_unit_price.divide(sd_oq,2,BigDecimal.ROUND_HALF_UP);
						LoggerUtils.info(sd_unit_price.toString());
						map.put("sd_unit_price", sd_unit_price.toString());
						if (map.get("item_id") == null) {// /产品id为空就不存储
							buffer.append("excel行号:")
									.append(map.get("excelIndex"))
									.append(",产品编码为空");
						} else {
							Map<String, Object> mapitemquery = new HashMap<String, Object>();
							mapitemquery.put("com_id", com_id);
							Object at_term_datetime_Act = map
									.get("at_term_datetime_Act");
							if (at_term_datetime_Act != null) {
								Date date = DateTimeUtils
										.strToDateTime(map.get(
												"at_term_datetime_Act")
												.toString());
								mapitemquery.put("at_term_datetime_Act",
										DateTimeUtils.dateTimeToStr(date)
												+ ".000");
							}
							mapitemquery.put("sd_order_id", sd_order_id);
							mapitemquery.put("item_id", map.get("item_id"));
							mapitemquery.put("sum_si", map.get("sum_si"));
							// 根据订单号,产品id,发货时间,订单金额判断是否在从表中存在
							Object obj = productDao
									.getExcelOrderInfo(mapitemquery);
							// getFinacial(mapquery, "at_term_datetime_Act");
							if (obj == null) {
								map.put("Status_OutStore", "已结束");
								// 组合插入sql
								String sSql = getInsertSqlByPre(itemtable, map);
								map.put("sSql", sSql);
								productDao.insertSqlByPre(map);
								// productDao.insertSql(getUpdateSql(mapitemquery,
								// "sdd02020", findName, id, updateNull));
							} else {
								buffer.append("excel此行重复行号:")
										.append(map.get("excelIndex"))
										.append(",");
								buffer.append("单号:").append(sd_order_id)
										.append(",产品外码:")
										.append(map.get("peijian_id"));
								buffer.append(",发货时间:")
										.append(at_term_datetime_Act)
										.append("\n");
							}
						}
					} else {
						buffer.append("excel行号:").append(map.get("excelIndex"));
						buffer.append("没有在主表中找到对应单号:").append(sd_order_id)
								.append("\n");
					}
				}
			}
			saveloginfo(request, buffer);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(ERROR_MSG);
		}
		// if (ConfigFile.ORDER_SMS) {
		// LoggerUtils.msgToSession(request,"exceprogress", "开始发送短信...");
		// sendOrderSms(listno, com_id,request);
		// }

	}

	/**
	 * 保存数据存储中重复或其它数据问题
	 * 
	 * @param request
	 * @param buffer
	 * @throws IOException
	 */
	private void saveloginfo(HttpServletRequest request, StringBuffer buffer)
			throws IOException {
		if (buffer.length() > 5) {
			Object name = request.getSession().getAttribute("logname");
			if (name == null) {
				name = new Date().getTime() + ".log";
			}
			String msg = "temp/" + getComId(request) + "/" + name;
			File log = new File(getRealPath(request, null) + "/" + msg);
			if (!log.exists()) {
				log.getParentFile().mkdirs();
			}
//			FileOutputStream out = new FileOutputStream(log, true);
//			PrintStream stream = new PrintStream(out);
//			stream.println("数据存储中所遇问题如下:\n" + buffer);
//			out.close();
//			stream.close();
			saveFile(log,"数据存储中所遇问题如下:\n" + buffer);
			LoggerUtils.msgToSession(request, "excelordermsg", msg);
		}
	}

	/**
	 * 发送订单发货短信
	 * 
	 * @param listno
	 *            订单列表
	 * @param com_id
	 * @param request
	 */
	private void sendOrderSms(List<Map<String, Object>> listno, String com_id,
			HttpServletRequest request) {
		int index = 0;
		StringBuffer smserror = new StringBuffer();
		String empl = request.getParameter("empl");
		for (Map<String, Object> map : listno) {
			if (map.get("ivt_oper_listing") != null) {
				// 结算余额
				Object customer_id = map.get("customer_id");
				// Object clerk_id=map.get("clerk_id");
				Object user_id = map.get("user_id");
				Object movtel = map.get("movtel");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("com_id", com_id);
				params.put("StartDate", "1900-01-01");
				params.put("EndDate", getNow());
				params.put("Zero", "0");
				params.put("clerk_id", "");
				params.put("dept_id", "");
				params.put("Where", "and (1=1)");
				params.put("tjfs", 0);
				params.put("customer_id", customer_id);
				params.put("settlement_sortID", "''");
				List<Map<String, Object>> edks = customerDao
						.getAccounts(params);
				Map<String, Object> mapedk = new HashMap<String, Object>();
				BigDecimal no_acceptsum_All = BigDecimal.ZERO;
				if (edks != null && edks.size() > 0) {
					mapedk = edks.get(0);
					no_acceptsum_All = getPrice(mapedk, "acct_recieve_sum");
				}
				// /累计应收:该客户截止本单开单之前 累计的应收款：no_acceptsum_All decimal(17,6) NULL
				// 更新主表金额
				String ivt_oper_listing = map.get("ivt_oper_listing")
						.toString();
				Map<String, Object> mapsdd = new HashMap<String, Object>();
				mapsdd.put("com_id", com_id);
				mapsdd.put("ivt_oper_listing", ivt_oper_listing);
				mapsdd.put("no_acceptsum_All", no_acceptsum_All);
				BigDecimal sum_si = new BigDecimal(
						productDao.updatesdd02020Sum_si(mapsdd));
				// /您总共应该打款：no_acceptsum_All + sum_si 元到我公司账户
				BigDecimal zje = BigDecimal.ZERO;
				zje = no_acceptsum_All.add(sum_si);
				zje = zje.setScale(2, BigDecimal.ROUND_HALF_UP);
				no_acceptsum_All = no_acceptsum_All.setScale(2,
						BigDecimal.ROUND_HALF_UP);
				LoggerUtils.info("====>>>>准备发送短信");
				// if (zje.compareTo(BigDecimal.ZERO)==1) {//总打款金额大于0
				// /查询产品明细
				List<Map<String, Object>> mapitem = productDao
						.getOrderSmsMsg(mapsdd);
				if (mapitem != null) {
					if (ConfigFile.ORDER_SMS_DEBUG
							&& StringUtils.isNotBlank(ConfigFile.ORDER_SMS_NO)) {
						user_id = ConfigFile.ORDER_SMS_NO;
					}
					if (user_id != null) {// 手机号不能为空
						String userId = user_id.toString().trim();
						if (StringUtils.isNotBlank(userId)
								&& userId.length() == 11) {// 去空后长度要等于11位
							Object customer_name = mapitem.get(0).get(
									"corp_sim_name");
							// pack_unit 包装单位
							// 查询 客户名称,客户手机,产品名称,单位,订单结算单价,结算金额 根据订单编号
							// sdf00504 ,view_sdd02020_ctl00301
							LoggerUtils.info("====>>>>短信信息拼装");
							Map<String,Object> smsmap=getSystemParamsByComId();
							Object sms_format1=map.get("sms_format1");
							Object sms_format2=map.get("sms_format2");
							Object sms_format3=map.get("sms_format3");
							if ((sms_format1+"").contains("??")||(sms_format2+"").contains("??")||(sms_format3+"").contains("??")) {
								throw new RuntimeException("系统参数可能存在乱码，请检查系统参数！例：【"+sms_format2+"】");
							}
							StringBuffer sms = new StringBuffer().append(sms_format1).append(customer_name)
									.append(sms_format2).append("，订单编号为：");
							sms.append(map.get("sd_order_id"));
							sms.append("，发货日期").append(mapitem.get(0)
											.get("at_term_datetime_Act")
											.toString().split(" ")[0]
											.replaceAll("-", ".")).append("明细如下：");
							for (int j = 0; j < mapitem.size(); j++) {
								Map<String, Object> item = mapitem.get(j); 
								BigDecimal sd_oq = getPrice(item, "sd_oq");
								sd_oq = sd_oq.setScale(2,
										BigDecimal.ROUND_HALF_UP);
								sms.append(item.get("item_sim_name"))
										.append(sd_oq)
										.append(item.get("item_unit"));
								sms.append("，");
							}
							
							if (isMapKeyNull(smsmap, "sendSmsEnd")) {
								sms.append(smsmap.get("sms_format3")).append(zje)
										.append("元，请注意收货！");
							} else {
								sms.append(smsmap.get("sms_format3"))
										.append(zje)
										.append("元，请注意收货！"
												+ smsmap.get("sendSmsEnd"));
							}
//							writeLog(getRequest(), "发送发货短信", sms.toString());
							LoggerUtils.info("====>>>>开始短信");
							Map<String,Object> mapsms=getSystemParamsByComId();
							String msg = SendSmsUtil.sendSms2(userId, null,
									sms.toString(),mapsms);
							
							Map<String,Object> mapcus= customerDao.getCustomerByCustomer_id(customer_id.toString(), com_id);
							if (mapcus.get("weixinID")!=null) {
								sendMessage(sms.toString(), mapcus.get("weixinID").toString());
							}
							
							if (StringUtils.isNotBlank(empl)) {
								if (movtel != null) {
									msg = SendSmsUtil.sendSms2(
											movtel.toString(), null,
											sms.toString(),smsmap);
									Map<String,String> mapemployee= employeeDao.getPersonnelWeixinID(movtel.toString(), getComId());
									if (mapemployee!=null) {
										sendMessage(sms.toString(), mapemployee.get("weixinID"));
									}
								}
							}
							if (index<2) {
								sendMessage(sms.toString(), ConfigFile.systemWeixin);
							}
							
							if (!"ok".equalsIgnoreCase(msg)) {
								LoggerUtils.msgToSession(request, "smserror",
										msg);
								if (StringUtils.isBlank(msg)
										|| msg.contains("余额")) {
									LoggerUtils.info("====>>>>短信余额不足");
									break;
								}
							} else {
								Map<String, Object> mapupdate = new HashMap<String, Object>();
								mapupdate.put("ivt_oper_listing",
										ivt_oper_listing);
								mapupdate.put("com_id", com_id);
								String buffer = "update sdd02020 set if_sendMsg='是',mainten_datetime='"
										+ getNow()
										+ "' where ivt_oper_listing=#{ivt_oper_listing} and com_id=#{com_id}";
								mapupdate.put("sSql", buffer);
								productDao.insertSqlByPre(mapupdate);// /更新短信发送结果
								LoggerUtils.msgToSession(request,
										"exceprogress", "共" + listno.size()
												+ "条,已发送短信" + index++);
							}
							LoggerUtils.info("====>>>>短信发送结束" + sms.toString());
						}
					}
					// }
				}
				// }
			}
		}
		if (smserror.length() > 5) {
			LoggerUtils.msgToSession(request, "smserror", ",失败:" + smserror);
			LoggerUtils.info("====>>>>无接收号码或接收号码的格式不正确" + smserror);
		}
		LoggerUtils.msgToSession(request, "excesms", "本次总共发送短信" + index);
	}
 
	private BigDecimal getPrice(Map<String, Object> map, String name) {
		BigDecimal price_otherDiscount = BigDecimal.ZERO;
		if (map.get(name) != null) {
			String num = map.get(name).toString().trim();
			if (StringUtils.isNotBlank(num) && checkNumber(num)) {
				price_otherDiscount = new BigDecimal(num);
			}
		}
		return price_otherDiscount;
	}

	public synchronized boolean checkNumber(String value) {
		String regex = "^(-?[1-9]\\d*\\.?\\d*)|(-?0\\.\\d*[1-9])|(-?[0])|(-?[0]\\.\\d*)$";
		return value.matches(regex);
	}

	/**
	 * 全角转半角:
	 * 
	 * @param fullStr
	 * @return
	 */
	public static final String full2Half(String fullStr) {
		char[] c = fullStr.toCharArray();
		for (int i = 0; i < c.length; i++) {
			if (c[i] >= 65281 && c[i] <= 65374) {
				c[i] = (char) (c[i] - 65248);
			} else if (c[i] == 12288) { // 空格
				c[i] = (char) 32;
			}
		}
		return new String(c);
	}

	@Override
	public PageList<Map<String, Object>> planDayDetail(Map<String, Object> map) {
		map = getPlanReportParams(map);
		List<Map<String, Object>> list = productDao.planDayDetail(map);
		PageList<Map<String, Object>> pages = new PageList<Map<String, Object>>(
				0, 10, list.size());
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator
				.hasNext();) {
			Map<String, Object> map2 = iterator.next();
			map2 = getInfoById(map2, map);
		}
		pages.setRows(list);
		return pages;
	}

	// ////////////////
	@Override
	public String sendSms(Map<String, Object> map, HttpServletRequest request) {
		List<Map<String, Object>> list = productDao.getSensSmsList(map);
		sendOrderSms(list, map.get("com_id").toString(), request);
		return null;
	}

	// ////////
	@Override
	@Transactional
	public void saveArdExcelImportData(
			Map<String, List<Map<String, Object>>> maplist,
			HttpServletRequest request) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String com_id = mainlist.get(0).get("com_id").toString();
		String maintable = "ARd02051";
		StringBuffer buffer = new StringBuffer();
		try {
			for (Map<String, Object> map : mainlist) {
				// 获取外部单号
				if (map.get("recieved_id") != null) {
					BigDecimal sum_si = getPrice(map, "sum_si");
					String sd_order_id = map.get("recieved_id").toString();
					if (sum_si.compareTo(BigDecimal.ZERO) != 0) {
						Object customer_id = map.get("customer_id");
						Object clerk_id = map.get("clerk_id");
						// 查询数据库检查外部单号是否存在
						Map<String, Object> mapquery = new HashMap<String, Object>();
						mapquery.put("table", "ARd02051");
						mapquery.put("showFiledName", "recieved_id");
						mapquery.put("findFiled", "recieved_id='" + sd_order_id
								+ "'");
						mapquery.put("com_id", com_id);
						// /判断收款单号存在就不再导入
						Object obj = productDao.getOneFiledNameByID(mapquery);
						if (obj == null) {
							String recieved_auto_id = getOrderNo(customerDao,
									"销售收款", com_id);
							map.put("recieved_auto_id", recieved_auto_id);
							// 组合备注内容
							// 计算结算方式内码ctl02107
							Object settlement_sim_name = map
									.get("settlement_sim_name");
							if (settlement_sim_name != null
									&& settlement_sim_name != "0") {
								mapquery.put("table", "ctl02107");
								mapquery.put("showFiledName", "sort_id");
								mapquery.put(
										"findFiled",
										"settlement_sim_name like '"
												+ map.get("settlement_sim_name")
												+ "%'");
								Object settlement_type_id = productDao
										.getOneFiledNameByID(mapquery);
								map.put("rcv_hw_no", settlement_type_id);
							} else {
								buffer.append("结算方式不存在:")
										.append(settlement_sim_name)
										.append("\n");
								settlement_sim_name = "";
							}
							Object customerName = "";
							if (customer_id != null) {
								// 获取客户的简称
								mapquery.put("table", "sdf00504");
								mapquery.put("showFiledName", "corp_sim_name");
								mapquery.put("findFiled", "customer_id = '"
										+ customer_id + "'");
								customerName = productDao
										.getOneFiledNameByID(mapquery);

							}
							// ///收款日期
							// /备注
							String finacial_d = getFinacial(map, "finacial_d");
							map.put("c_memo", customerName + finacial_d + "收款,"
									+ settlement_sim_name);
							// //计算部门根据员工编码
							if (clerk_id != null) {
								mapquery.put("table", "ctl00801");
								mapquery.put("showFiledName", "dept_id");
								mapquery.put("findFiled", "clerk_id = '"
										+ clerk_id + "'");
								Object dept_id = productDao
										.getOneFiledNameByID(mapquery);
								if (dept_id != null) {
									map.put("dept_id", dept_id);
								} else {
									buffer.append("员工没有找到部门:").append(clerk_id)
											.append("\n");
								}
							}
							// //
							map.put("ivt_oper_cfm", map.get("mainten_clerk_id"));
							map.put("ivt_oper_cfm_time", getNow());
							map.remove("settlement_sim_name");
							String sSql = getInsertSqlByPre(maintable, map);
							map.put("sSql", sSql);
							productDao.insertSqlByPre(map);
						} else {
							buffer.append("重复单号:").append(sd_order_id);
						}
					} else {
						buffer.append("金额为0:").append(sd_order_id);
					}
				}
			}
			saveloginfo(request, buffer);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(ERROR_MSG);
		}
	}

	private static final String ERROR_MSG = "您导入的excel数据格式有误请仔细核对后再次导入!特别注意:1.单元格不能有公式,2.日期格式应符合日期规则,3.数字列不能有中文或字母!";

	@Override
	@Transactional
	public void saveArfExcelImportData(
			Map<String, List<Map<String, Object>>> maplist,
			HttpServletRequest request) {
		try {
			List<Map<String, Object>> mainlist = maplist.get("mainlist");
			String com_id = mainlist.get(0).get("com_id").toString();
			String maintable = "ARf02030";
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("com_id", com_id);
			for (Map<String, Object> map : mainlist) {
				if (map.get("customer_id") != null
						&& map.get("customer_id") != "") {
					// 1.生成单号
//					map.put("sd_order_id", ivt_oper_listing);
					map.put("finacial_d", getNow());
					getFinacial(map, "finacial_d");
					map.put("back_sum", map.get("oh_sum"));
					if (isNotMapKeyNull(map, "ivt_oper_listing")) {
//						Object seeds_id=map.get("ivt_oper_listing");
						String sSql=getUpdateSql(map, maintable, "ivt_oper_listing",map.get("ivt_oper_listing")+"");
						productDao.insertSql(sSql);
					}else{
						mapquery.put("table", maintable);
						mapquery.put("showFiledName", "seeds_id");
						mapquery.put("findFiled",
								"clerk_id = '" + map.get("clerk_id") + "'");
						int i = managerService.getMaxSeeds_id("ARf02030",
								"seeds_id");
						String ivt_oper_listing = "应收初始" + (i + 1);
						map.put("ivt_oper_listing", ivt_oper_listing);
						String sSql = getInsertSqlByPre(maintable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(ERROR_MSG);
		}
	}

	@Override
	@Transactional
	public void saveQuotationSheetExcelImportData(
			Map<String, List<Map<String, Object>>> maplist,
			HttpServletRequest request) {
		
		List<Map<String, Object>> list = maplist.get("list");
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		
		String maintable = "sdd02010";
		String itemtable = "sdd02011";
		
		String com_id = mainlist.get(0).get("com_id").toString();
		try {
			for (Map<String, Object> map : mainlist) {
				// 获取外部单号
				if (map.get("sd_order_id") != null) {
					String sd_order_id = map.get("sd_order_id").toString();
					//查询数据库检查外部单号是否存在
					Map<String, Object> mapquery = new HashMap<String, Object>();
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "sd_order_id");
					mapquery.put("findFiled", "sd_order_id='" + sd_order_id + "'");
					mapquery.put("com_id", com_id);
					//判断l
					Object obj = productDao.getOneFiledNameByID(mapquery);
					if (obj == null) {//不等于空说明已经存储过主表将不再存储
						String no = getOrderNo(customerDao, "销售订单", com_id);
						map.put("ivt_oper_listing", no);
						map.put("ivt_oper_cfm", map.get("mainten_clerk_id"));
						map.put("ivt_oper_cfm_time", getNow());
						
						String sSql = getInsertSqlByPre(maintable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
				}
			}
			StringBuffer buffer = new StringBuffer();
			for (Map<String, Object> map : list) {
				//获取外部单号
				if (map.get("sd_order_id") != null) {
					String sd_order_id = map.get("sd_order_id").toString();
					Map<String, Object> mapquery = new HashMap<String, Object>();
					// 从主表中获取单号根据订单外部单号
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "ivt_oper_listing");
					mapquery.put("findFiled", "sd_order_id='" + sd_order_id + "'");
					mapquery.put("com_id", com_id);
					Object no = productDao.getOneFiledNameByID(mapquery);
					// 从主表中获取员工编码
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "clerk_id");
					mapquery.put("findFiled", "sd_order_id='" + sd_order_id + "'");
					mapquery.put("com_id", com_id);
					Object clerk_id = productDao.getOneFiledNameByID(mapquery);
					if (no != null && clerk_id != null) {
						map.put("ivt_oper_listing", no);
						map.put("clerk_id", clerk_id);
						if (map.get("item_id") == null) {//产品id为空就不存储
							buffer.append("excel行号:")
								  .append(map.get("excelIndex"))
								  .append(",产品编码为空");
						} else if (map.get("clerk_id") == null){
							buffer.append("excel行号:")
							      .append(map.get("excelIndex"))
							      .append(",员工编码为空");
						}else {
							Map<String, Object> mapitemquery = new HashMap<String, Object>();
							mapitemquery.put("com_id", com_id);
							mapitemquery.put("ivt_oper_listing", map.get("ivt_oper_listing"));
							mapitemquery.put("item_id", map.get("item_id"));
							mapitemquery.put("customer_id", map.get("customer_id"));
							mapitemquery.put("clerk_id", map.get("clerk_id"));
							mapitemquery.put("row_num", map.get("row_num"));
							// 根据订单号,产品号,客户号,员工编号判断客户报价单从表是否重复
							Object obj = productDao.getExcelQuotationSheetInfo(mapitemquery);
							if (obj == null) {
								map.put("Status_OutStore", "已结束");
								map.remove("clerk_id");
								//组合插入sql
								String sSql = getInsertSqlByPre(itemtable, map);
								map.put("sSql", sSql);
								productDao.insertSqlByPre(map);
							} else {
								buffer.append("excel此行重复行号:")
									  .append(map.get("excelIndex"))
									  .append(",");
								buffer.append("单号:").append(sd_order_id)
									  .append(",产品编码:")
									  .append(map.get("item_id"));
								buffer.append(",客户号:")
									  .append(map.get("customer_id"))
									  .append(",员工号:")
									  .append(map.get("clerk_id"))
									  .append("\n");
							}
						}
					} else {
						buffer.append("excel行号:")
						      .append(map.get("excelIndex"));
						buffer.append("没有在主表中找到对应单号:")
						      .append(sd_order_id)
							  .append("\n");
					}
				}
			}
			saveloginfo(request, buffer);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(ERROR_MSG);
		}
	}

	@Override
	public List<String> getProductName(Map<String, Object> map) {
		
		return productDao.getProductName(map);
	}

	@Override
	public PageList<Map<String, Object>> getOneProductFiledList(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getOneProductFiledCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.getOneProductFiledList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public List<Map<String, Object>> getProductList(Map<String,Object> map) {
		
		return productDao.getProductList(map);
	}

	@Override
	public PageList<Map<String, Object>> getShopping(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getShoppingCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.getShoppingList(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	@Transactional
	public void updateOrder(Map<String, Object> map) {
		//1.更新所有订单为待支付
		productDao.updateOrder(map);
	}
	@Override
	@Transactional
	public void postShopping(Map<String, Object> map) {
		//2.更新订单客户编码为机器码的为客户编码
		//3.更新支付订单为支付中
		productDao.postShopping(map);
	}
	@Override
	public Map<String, Object> getOrderInfo(String orderInfo) {
		//1.获取参数,并组合
		Map<String,Object> map=new HashMap<String, Object>();
		if (!orderInfo.startsWith("[")) {
			orderInfo="["+orderInfo+"]";
		}
		JSONArray jsons=JSONArray.fromObject(orderInfo);
		map.put("customer_id", getUpperCustomerId(getRequest()));
		List<Map<String,Object>> infos=new ArrayList<Map<String,Object>>();
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			map.put("tag", json);
			Map<String,Object> info= productDao.getOrderInfoList(map);
			if (info!=null) {
				if (json.has("item_name")) {
					info.put("item_name", json.getString("item_name"));
				}
				infos.add(info);
			}
		}
		Map<String,Object> FHDZ= productDao.getOrderInfo(map);
		//2.
		map.put("orderInfo", infos);
		map.put("FHDZ", FHDZ.get("FHDZ"));
		return map;
	}
	@Override
	public List<Map<String, Object>> getOrderProductList(Map<String, Object> map) {
		if(!isMapKeyNull(map, "orderlist")){
			JSONArray jsons=JSONArray.fromObject(map.get("orderlist"));
			map.put("jsons", jsons);
		}
		return productDao.getOrderProductList(map);
	}
	@Override
	public PageList<Map<String, Object>> getStoreProductList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getStoreProductCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.getStoreProductList(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	@Transactional
	public String saveProductView(Map<String, Object> map) throws Exception {
		//1.查询今天是否已经访问
		Object begin=null;
		Object end=null;
		if(isNotMapKeyNull(map, "beginTime")){
			begin=map.get("beginTime");
		}
		if(isNotMapKeyNull(map, "endTime")){
			end=map.get("endTime");
		}
		map.put("beginTime", DateTimeUtils.dateToStr()+" 00:00:00.000");
		map.put("endTime", DateTimeUtils.dateToStr()+" 23:59:59.999");
		Integer count=productDao.getProductViewCount(map);
		if (count==0&&isNotMapKeyNull(map, "item_id")) {
			map.remove("beginNTime");
			map.remove("endNTime");
			map.remove("beginDate");
			map.remove("endDate");
			map.remove("rows");
			Map<String,Object> mapinfo=new HashMap<>();
			mapinfo.put("com_id",map.get("com_id"));
			mapinfo.put("item_id",map.get("item_id"));
			mapinfo.put("view_time",getNow());
			mapinfo.put("view_ip",map.get("view_ip"));
			mapinfo.put("customer_id",map.get("customer_id"));
			String sSql=getInsertSqlByPre("Ctl03101", mapinfo);
			mapinfo.put("sSql", sSql);
			productDao.insertSqlByPre(mapinfo);
			new Thread(new Runnable() {
				@Override
				public void run() {
					List<Map<String,Object>> seeds_id=productDao.getProductViewByAddressNull();
					WeixinUtil wei=new WeixinUtil();
					for (Map<String, Object> map2 : seeds_id) {
						String address=wei.doInBackground(map2.get("view_ip")+"");
						map2.put("view_address", address);
						productDao.updateProductView(map2);
					}
				}
			}).start();
		}
		if(begin!=null){
			map.put("beginTime", begin);
		}
		if(end!=null){
			map.put("endTime", end);
		}
		return null;
	}
	
	@Override
	public PageList<Map<String, Object>> getProductViewPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getProductViewCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.getProductViewPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public PageList<Map<String, Object>> getProductPageByTypeName(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		Map<String,Object> empl=null;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getProductPageByTypeNameCount(map);
			empl=employeeDao.getPersonnel(map.get("clerk_id")+"", map.get("com_id")+"");
			if (isNotMapKeyNull(map, "clerk_id")) {
				map.put("describe", getFileTextContent(getPlanquery(getRequest(), map.get("clerk_id"), "describe.txt")));
			}
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.getProductPageByTypeName(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 = iterator.next();
			if (isNotMapKeyNull(map2, "clerk_id")) {
				map2.put("describe", getFileTextContent(getPlanquery(getRequest(), map.get("clerk_id"), "describe.txt")));
			}
		}
		if(empl!=null){
			list.add(0, empl);
		}
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public PageList<Map<String, Object>> getProductWarePage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=productDao.getProductWareCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=productDao.getProductWareList(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public List<Map<String, Object>> getProductViewList(
			Map<String, Object> map) {
		return productDao.getProductViewList(map);
	}
	
	@Override
	public List<Map<String, Object>> getProductByName(Map<String, Object> map) {
		return productDao.getProductByName(map);
	}
	
	@Override
	public List<Map<String, Object>> getProductByTypeName(
			Map<String, Object> map) {
		return productDao.getProductByTypeName(map);
	}
	@Override
	public Map<String, Object> getSpruceInfo(Map<String, Object> map) {
		map= productDao.getSpruceInfo(map);
		if (isNotMapKeyNull(map, "clerk_id")) {
			map.put("describe", getFileTextContent(getPlanquery(getRequest(), map.get("clerk_id"), "describe.txt")));
		}
		return map;
	}
	
	@Override
	public List<Map<String, Object>> getProductParam(Map<String, Object> map) {
		return productDao.getProductParam(map);
	}
	@Override
	public Map<String,Object> getProductAccnIvt(Map<String, Object> map) {
		// TODO 获取指定产品颜色的库存 
		return productDao.getProductAccnIvt(map);
	}
	@Override
	@Transactional
	public String savePlanEidt(Map<String, Object> map) {
		Integer i=productDao.savePlanEidt(map);
		return i+"";
	}
	
}