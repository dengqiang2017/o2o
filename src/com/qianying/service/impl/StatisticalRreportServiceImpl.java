package com.qianying.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.time.DateUtils;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.qianying.dao.interfaces.IProductDAO;
import com.qianying.dao.interfaces.IStatisticalRreportDAO;
import com.qianying.page.PageList;
import com.qianying.service.IStatisticalRreportService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;

/**
 * 报表统计业务实现,用于统计查询
 * 
 * @author dengqiang
 *
 */
@Service
@Scope("prototype")
public class StatisticalRreportServiceImpl extends BaseServiceImpl implements
		IStatisticalRreportService  {

	@Resource
	private IStatisticalRreportDAO statisticalRreportDao;
	@Resource
	private IProductDAO productDao;
	
	@Override
	public PageList<Map<String, Object>> orderReportDeptCountlist(
			Map<String, Object> map) {
		getTimeParams(map);
		List<Map<String, Object>> list = statisticalRreportDao
				.orderReportDeptCountlist(map);
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(0,1000,list.size());
		page.setRows(list);
		return page;
	}
	
	@Override
	public List<Map<String, Object>> orderReportDeptDetailListExcel(
			Map<String, Object> map) {
		getTimeParams(map);
		return  getOrderRecord(map);
	}
	
	private void getTimeParams(Map<String,Object> map) {
		String begin="-01-01 00:00:00.000";
		String end="-12-31 23:59:59.999";
		String sourceBegin=map.get("beginDate").toString()+" 00:00:00.000";
		String sourceEnd=map.get("endDate").toString()+" 23:59:59.999";
		//本期 当前选择的时间段
		Date beginDate=DateTimeUtils.strToDateTime(sourceBegin);
		Date endDate=DateTimeUtils.strToDateTime(sourceEnd);
		map.put("beginTime", sourceBegin);
		map.put("endTime",  sourceEnd);
		//同期 去年这个时候的时间段
		Date up_Years_month_begin=DateUtils.addYears(beginDate, -1);
		Date up_Years_month_end=DateUtils.addYears(endDate, -1);
		map.put("up_month_Years_begin", DateTimeUtils.dateTimeToStr(up_Years_month_begin));
		map.put("up_month_Years_end",  DateTimeUtils.dateTimeToStr(up_Years_month_end));
		//上期 当前选择的时间段向前推一个月
		Date up_month_begin=DateUtils.addMonths(beginDate, -1);
		Date up_month_end=DateUtils.addMonths(endDate, -1);
		map.put("up_month_begin", DateTimeUtils.dateTimeToStr( up_month_begin));
		map.put("up_month_end",  DateTimeUtils.dateTimeToStr(up_month_end));
		//本年累计销量 选择时间段截止时间所在的年
		String beginYears=  DateTimeUtils.dateTimeToStr(beginDate).split("-")[0];
		String endYears=  DateTimeUtils.dateTimeToStr(endDate).split("-")[0];
		map.put("years_begin", beginYears+begin);
		map.put("years_end", endYears+end);
		//去年累计销量  选择时间段截止时间向前推一年
		String up_years_begin=  DateTimeUtils.dateTimeToStr(up_Years_month_begin).split("-")[0];
		String up_years_end=  DateTimeUtils.dateTimeToStr(up_Years_month_end).split("-")[0];
		map.put("up_years_begin", up_years_begin+begin);
		map.put("up_years_end", up_years_end+end);
	}
	
	@Override
	public PageList<Map<String, Object>> orderReportDeptDetailList(
			Map<String, Object> map) {
		List<Map<String, Object>> list =  getOrderRecord(map);
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(0,1000,list.size());
		page.setRows(list);
		return page;
	}
	
	private List<Map<String,Object>> getOrderRecord(Map<String,Object> map){
		getTimeParams(map);
		List<Map<String, Object>> list = statisticalRreportDao
				.orderReportDeptDetailList(map);
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("com_id", map.get("com_id"));
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> item = iterator.next();
			if (item.get("type_id")!=null&&item.get("sort_name")==null) {
				mapparam.put("table", "ctl03200");
				mapparam.put("showFiledName", "sort_name");
				mapparam.put("findFiled", "sort_id='"+item.get("type_id")+"'");
				Object obj=productDao.getOneFiledNameByID(mapparam);
				item.put("sort_name", obj);
			}
			if (item.get("customer_id")!=null&&map.get("excel")!=null) {
						
				mapparam.put("table", "sdf00504");
				mapparam.put("showFiledName", "self_id");
				mapparam.put("findFiled", "customer_id='"+item.get("customer_id")+"'");
				Object obj=productDao.getOneFiledNameByID(mapparam);
				item.put("customer_id_OUT", obj);
			}
			//
			if ((item.get("clerk_id")!=null&&item.get("clerk_name")==null)||map.get("excel")!=null) {
				mapparam.put("table", "ctl00801");
				mapparam.put("showFiledName", "clerk_name");
				mapparam.put("findFiled", "clerk_id='"+item.get("clerk_id")+"'");
				Object obj=productDao.getOneFiledNameByID(mapparam);
				item.put("clerk_name", obj);
				
				mapparam.put("showFiledName", "self_id");
				obj=productDao.getOneFiledNameByID(mapparam);
				item.put("clerk_id_OUT", obj);
			}

		}
		return list;
	}
	
	 @Override
	public List<Map<String, Object>> orderRecordExcel(Map<String, Object> map) {
			String sourceBegin=map.get("beginDate").toString()+" 00:00:00.000";
			String sourceEnd=map.get("endDate").toString()+" 23:59:59.999";
			map.put("beginTime", sourceBegin);
			map.put("endTime",  sourceEnd); 
			return statisticalRreportDao.orderRecord(map);
	}
	@Override
	public PageList<Map<String, Object>> orderRecord(Map<String, Object> map) {
		String sourceBegin=map.get("beginDate").toString()+" 00:00:00.000";
		String sourceEnd=map.get("endDate").toString()+" 23:59:59.999";
		map.put("beginTime", sourceBegin);
		map.put("endTime",  sourceEnd); 
		List<Map<String, Object>> list = statisticalRreportDao.orderRecord(map);
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(0,1000,list.size());
		page.setRows(list);
		return page;
	}
	@Override
	public Map<String, Object> orderRecordSum(Map<String, Object> map) {
		String sourceBegin=map.get("beginDate").toString()+" 00:00:00.000";
		String sourceEnd=map.get("endDate").toString()+" 23:59:59.999";
		map.put("beginTime", sourceBegin);
		map.put("endTime",  sourceEnd); 
		return statisticalRreportDao.orderRecordSum(map);
	}

	@Override
	public PageList<Map<String, Object>> receivablesReportList(
			Map<String, Object> map) {
		if (map.get("beginDate")!=null) {
			String sourceBegin=map.get("beginDate").toString()+" 00:00:00.000";
			map.put("beginTime", sourceBegin);
		}
		if (map.get("endDate")!=null) {
			String sourceEnd=map.get("endDate").toString()+" 23:59:59.999";
			map.put("endTime",  sourceEnd); 
		}
		List<Map<String, Object>> list = statisticalRreportDao.receivablesReportList(map);
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(0,1000,list.size());
		page.setRows(list);
		return page;
	}
	
	@Override
	public PageList<Map<String, Object>> accountStatementList(
			Map<String, Object> map) {
		String sourceBegin=map.get("beginDate").toString()+" 00:00:00";
		String sourceEnd=map.get("endDate").toString()+" 23:59:59";
		map.put("beginTime", sourceBegin);
		map.put("endTime",  sourceEnd);
		
		if (map.get("clerk_id")==null) {
			map.put("clerk_id", "");
		}
		if (map.get("client_id")==null) {
			map.put("client_id", "");
		}
		if (map.get("dept_id")==null) {
			map.put("dept_id", "");
		}
		if (map.get("customer_id")==null) {
			map.put("customer_id", "");
		}
		if (map.get("settlement_sortID")==null) {
			map.put("settlement_sortID", "");
		}
//		if (map.get("dept_idInfo")!=null) {
//			map.put("dept_right", map.get("dept_idInfo"));
//		}
		if (map.get("dept_right")==null) {
			map.put("dept_right","");
		}
		if (map.get("key_words")==null) {
			map.put("key_words","");
		}
		if (map.get("if_LargessGoods")==null) {
			map.put("if_LargessGoods","否");
		}
		if (map.get("if_check")==null) {
			map.put("if_check","全部");
		}
		
		List<Map<String, Object>> list = statisticalRreportDao.accountStatementList(map);
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("com_id", map.get("com_id"));
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 = iterator.next();
//			if (isNotMapKeyNull(map2, "item_id")) {
//				if(!map2.get("item_id").toString().startsWith("NO")){
//					Map<String,String> mapproparam=new HashMap<String, String>();
//					mapproparam.put("com_id", map.get("com_id").toString().trim());
//					mapproparam.put("item_id", map2.get("item_id").toString().trim());
//					Map<String,Object> mappro=productDao.getProductByItem_id(mapproparam);
//					map2.put("item_sim_name", mappro.get("item_sim_name"));
//					map2.put("item_spec", mappro.get("item_spec"));
//					map2.put("item_type", mappro.get("item_type"));
//					map2.put("item_unit", mappro.get("item_unit"));
//					map2.put("casing_unit", mappro.get("casing_unit"));
//					map2.put("pack_unit", mappro.get("pack_unit"));
//				}
//			}
//			if (isNotMapKeyNull(map2, "expenses_id")&&isMapKeyNull(map2, "settlement_sim_name")) {
//				mapparam.put("table", "ctl02107");
//				mapparam.put("showFiledName", "settlement_sim_name");
//				mapparam.put("findFiled", "sort_id='"+map2.get("expenses_id")+"'");
//				Object obj=productDao.getOneFiledNameByID(mapparam);
//				map2.put("settlement_sim_name", obj);
//			}
//			if (isNotMapKeyNull(map2, "customer_id")) {
//				mapparam.put("table", "sdf00504");
//				mapparam.put("showFiledName", "corp_sim_name");
//				mapparam.put("findFiled", "customer_id='"+map2.get("customer_id")+"'");
//				Object obj=productDao.getOneFiledNameByID(mapparam);
//				map2.put("corp_sim_name", obj);
//				if(isNotMapKeyNull(map2, "qianming")){
//					mapparam.put("findFiled", "customer_id='"+map2.get("qianming")+"'");
//					obj=productDao.getOneFiledNameByID(mapparam);
//					map2.put("qianming", obj);
//				}
//			}
		}
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(0,1000,list.size());
		page.setRows(list);
		return page;
	}

	@Override
	public PageList<Map<String, Object>> accountsReceivableLedgerList(
			Map<String, Object> map) {
		String sourceBegin=map.get("beginDate").toString()+" 00:00:00.000";
		String sourceEnd=map.get("endDate").toString()+" 23:59:59.999";
		map.put("beginTime", sourceBegin);
		map.put("endTime",  sourceEnd);
		if (map.get("clerk_id")==null) {
			map.put("clerk_id", "");
		}
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
			map.put("Zero", "");
		}
		List<Map<String, Object>> list = statisticalRreportDao.accountsReceivableLedgerList(map);
		
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(0,1000,list.size());
		page.setRows(list);
		return page;
	}
	@Override
	public String inviteReconciliation(Map<String, Object> map) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("title"));
		String newds=map.get("description").toString().replaceAll("@comName", getComName());
		mapMsg.put("description",newds);
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url="+map.get("url"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
		news.add(mapMsg); 
		zuheclientsendmsg("出纳", news, map.get("customer_id")+"",null);
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getPaymentSheet(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=statisticalRreportDao.getPaymentSheetCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=statisticalRreportDao.getPaymentSheetList(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 = iterator.next();
			 File file=new File(getComIdPath(getRequest())+"certificate/"+map2.get("recieved_auto_id")+".jpg");
			 if (file.exists()&&file.isFile()) {
				map2.put("imgpath", "/"+map.get("com_id")+"/certificate/"+map2.get("recieved_auto_id")+".jpg");
			}
		}
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> getFkAccount(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=statisticalRreportDao.getFkAccountCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String, Object>> page = new PageList<Map<String, Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> list = statisticalRreportDao.getFkAccountList(map);
		page.setRows(list);
		return page;
	}

	@Override
	public PageList<Map<String, Object>> getCgmxStatistical(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=statisticalRreportDao.getCgmxStatisticalCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=statisticalRreportDao.getCgmxStatisticalList(map);
		
		pages.setRows(list);
		return pages;
	}
	@Override
	public PageList<Map<String, Object>> getSalesCommission(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=statisticalRreportDao.getSalesCommissionCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			pages.setRows(statisticalRreportDao.getSalesCommissionList(map));
		}
		return pages;
	}
	@Override
	public PageList<Map<String, Object>> getSalesBonus(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=statisticalRreportDao.getSalesBonusCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			pages.setRows(statisticalRreportDao.getSalesBonusList(map));
		}
		return pages;
	}
	
	@Override
	public String savePlanGys(Map<String, Object> map) {
		statisticalRreportDao.updatePlanGys(map);
		return null;
	}
	
	@Override
	public List<Map<String, Object>> planReportCount(Map<String, Object> map) {
		
		return statisticalRreportDao.planReportCount(map);
	}
	@Override
	public List<Map<String, Object>> planReportDetail(Map<String, Object> map) {
		 
		return statisticalRreportDao.planReportDetail(map);
	}
	@Override
	public PageList<Map<String, Object>> planReportDetailPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=statisticalRreportDao.planReportDetailPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		if(totalRecord>0){
			pages.setRows(statisticalRreportDao.planReportDetailPage(map));
		}
		return pages;
	}

	@Override
	public List<Map<String, Object>> getPlanBusinessAccontCount(
			Map<String, Object> map) {
		
		return statisticalRreportDao.getPlanBusinessAccontCount(map);
	}
	
	@Override
	public String generatePurchaseOrderByPlan(Map<String, Object> map) {
		// TODO 根据计划生成采购订单
		//1.获取需要生成采购订单的计划列表
		List<Map<String,Object>> list=statisticalRreportDao.planReportDetail(map);
		
		
		return null;
	}
	
	
}
