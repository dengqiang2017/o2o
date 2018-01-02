package com.qianying.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IClientDAO;
import com.qianying.page.PageList;
import com.qianying.service.IClientService;
import com.qianying.util.DateTimeUtils;
@Service
@Transactional
public class ClientServiceImpl extends BaseServiceImpl implements IClientService {

	@Resource
	private IClientDAO clientDao;
	
	@Override
	public List<Map<String, Object>> getClientSimpleList(
			Map<String, Object> map)throws Exception {
		 
		return employeeDao.getCustomerByClerk_id(map);
	}
	@Override
	public String saveUserInfo(Map<String, Object> map)throws Exception {
		customerDao.insertSql(getUpdateSql(map, "SDf00504", "customer_id",
				null, false));
		return null;
	}

	@Override
	public PageList<Map<String, Object>> getVisitPage(Map<String, Object> map)throws Exception {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=clientDao.getVisitPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.getVisitPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public List<Map<String, Object>> getVisitExcel(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return clientDao.getVisitExcel(map);
	}
	@Override
	public String delVisit(Map<String, Object> map)throws Exception {
		 // TODO 客户拜访记录删除
		return clientDao.delVisit(map).toString();
	}
	
	@Override
	public String saveVisitInfo(Map<String, Object> map)throws Exception {
		// TODO 客户拜访记录保存
		String table="sdf00504_visit";
		if (isMapKeyNull(map, "ivt_oper_listing")) {//增加
			if (isMapKeyNull(map, "visitTime")) {
				map.put("visitTime", getNow());
			}
			if (isMapKeyNull(map, "ivt_oper_listing")) {
				map.put("ivt_oper_listing", "NO."+DateTimeUtils.getNowDateTimeS());
			}
			map.put("sSql", getInsertSqlByPre(table, map));
			productDao.insertSqlByPre(map);
		}else{//修改
			managerDao.insertSql(getUpdateSql(map, table, "ivt_oper_listing", map.get("ivt_oper_listing")+""));
		}
		return map.get("ivt_oper_listing").toString();
	}
	@Override
	public Map<String, Object> getVisitInfo(Map<String, Object> map) {
		return clientDao.getVisitInfo(map);
	}
	@Override
	public String delWorkPlan(Map<String, Object> map) {
		return clientDao.delWorkPlan(map).toString();
	}
	@Override
	public Map<String, Object> getWorkPlanInfo(Map<String, Object> map) {
		return clientDao.getWorkPlanInfo(map);
	}
	@Override
	public PageList<Map<String, Object>> getWorkPlanPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=clientDao.getWorkPlanPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.getWorkPlanPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public List<Map<String, Object>> getWorkPlanExcel(Map<String, Object> map) {
		 
		return clientDao.getWorkPlanExcel(map);
	}
	@Override
	public String saveWorkPlanInfo(Map<String, Object> map) throws Exception {
		String table="ctl00801_plan";
		if (isMapKeyNull(map, "ivt_oper_listing")) {//增加
			if (isMapKeyNull(map, "planTime")) {
				map.put("planTime", getNow());
			}
			if (isMapKeyNull(map, "ivt_oper_listing")) {
				map.put("ivt_oper_listing", "NO."+DateTimeUtils.getNowDateTimeS());
			}
			map.put("sSql", getInsertSqlByPre(table, map));
			productDao.insertSqlByPre(map);
		}else{//修改
			managerDao.insertSql(getUpdateSql(map, table, "ivt_oper_listing", map.get("ivt_oper_listing")+""));
		}
		return map.get("ivt_oper_listing").toString();
	}
	@Override
	public List<Map<String, Object>> getClientInfoById(Map<String, Object> map) {
		String selectClient=MapUtils.getString(map, "selectClient");
		selectClient=selectClient.replaceAll("null,", "");
		selectClient=selectClient.replaceAll("undefined,", "");
		if (selectClient.startsWith("\"")) {
			selectClient=selectClient.substring(1,selectClient.length());
		}
		if (selectClient.startsWith(",")) {
			selectClient=selectClient.substring(1,selectClient.length());
		}
		if(selectClient.endsWith(",")){
			selectClient=selectClient.substring(0,selectClient.length()-1);	
		}
		if(selectClient.endsWith("\"")){
			selectClient=selectClient.substring(0,selectClient.length()-1);	
		}
		if (StringUtils.isNotBlank(selectClient)) {
			map.put("clients",selectClient.split(","));
			return clientDao.getClientInfoById(map);
		}
		return null;
	}
	
	@Override
	public String saveGanzhiInfo(Map<String, Object> map) throws Exception {
		
		return clientDao.saveGanzhiInfo(map)+"";
	}
	@Override
	public void updateGanzhiEndTime(Map<String, Object> map) {
		// TODO Auto-generated method stub
		clientDao.updateGanzhiEndTime(map);
	}
	@Override
	public PageList<Map<String, Object>> ganzhiRecordPage(
			Map<String, Object> map) throws Exception {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=clientDao.ganzhiRecordCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.ganzhiRecordPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public Integer getTotalJinbi(Map<String, Object> map) {
		return clientDao.getTotalJinbi(map);
	}
	@Override
	public Map<String, Object> getQiandaoInfo(Map<String, Object> map) {
		//2.今天是否已经签到
		Map<String,Object> info=clientDao.getQiandaoInfo(map);
		if(info==null){
			info=new HashMap<>();
			info.put("success", false);
		}else{
			if (isNotMapKeyNull(info, "jinbi")) {
				//1.获取当前客户的总金币
				info.put("success", true);
			}else{
				info.put("success", false);
			}
		}
		Integer totalJinbi=clientDao.getTotalJinbi(map);
		if(totalJinbi==null){
			totalJinbi=0;
		}
		info.put("totalJinbi", totalJinbi);
		return info;
	}
	@Override
	public Map<String,Object> saveQiandaoInfo(Map<String, Object> map) {
		Map<String,Object> info=getQiandaoInfo(map);
		//获取随机金币数
		if(!MapUtils.getBooleanValue(info, "success", false)){
			Random rand = new Random();
			int jinbi = rand.nextInt(10);
			if(jinbi==0||jinbi==1){
				jinbi = 3;
			}
			info.put("jinbi", jinbi);
			Map<String,Object> param=new HashMap<>();
			param.put("com_id", map.get("com_id"));
			param.put("customer_id", map.get("customer_id"));
			param.put("f_num", jinbi);//增加为正数,消费为负数
			param.put("f_time", getNow());//消费或者获取时间
			param.put("f_source", "签到");//金币来源:签到,分享,评价
			param.put("flag", 0);//
//			param.put("orderNo", "");//存储消费时的订单编号
//			param.put("c_memo", "");//
			param.put("sSql", getInsertSqlByPre("sdf00504_jinbi", param));
			productDao.insertSqlByPre(param);
			Integer totalJinbi =MapUtils.getInteger(info, "totalJinbi");
			info.put("totalJinbi", totalJinbi+jinbi);
			info.put("success", true);
		}
		return info;
	}
	@Override
	public String saveJinbiInfo(Map<String, Object> map)throws Exception {
		Integer jinbi=0;
		Map<String,Object> param=new HashMap<>();
		boolean b=false;
		if(isNotMapKeyNull(map, "type")){
			if("分享".equals(map.get("type"))){
				String fenjinbi=systemParamsDao.checkSystem("fenx_jinbi",getComId());
				if(StringUtils.isBlank(fenjinbi)){
					jinbi=30;
				}else{
					jinbi=Integer.parseInt(fenjinbi);
				}
				param.put("f_source", "分享");//金币来源:签到,分享,评价
				Integer i=clientDao.checkFenxByItemId(map);
				if(i==0){
					b=true;
				}
			}else if("评价".equals(map.get("type"))){
				String pingjiajinbi=systemParamsDao.checkSystem("pingjia_jinbi",getComId());
				if(StringUtils.isBlank(pingjiajinbi)){
					jinbi=30;
				}else{
					jinbi=Integer.parseInt(pingjiajinbi);
				}
				param.put("f_source", "评价");//金币来源:签到,分享,评价
				Integer i=clientDao.checkFenxByItemId(map);
				if(i==0){
					b=true;
				}
			}else if("消费".equals(map.get("type"))){//消费
				///生成金币消费数据
				if(isNotMapKeyNull(map, "jinbi")){
					//1.检查金币余额
					Integer totalJinbi=clientDao.getTotalJinbi(map);
					if(totalJinbi==null){
						totalJinbi=0;
					}
					if(totalJinbi>=1000){
						//2.检查消费金币是否大于等1000
						if(MapUtils.getInteger(map, "jinbi")>=1000){
							//3.生成金金币消费数据
							jinbi=Integer.parseInt(map.get("jinbi").toString())*-1;
							b=true;
							param.put("f_source", "消费");//注册
						}
					}
				}
				if(!b){
					throw new RuntimeException("金币余额不足!");
				}
			}else if("注册".equals(map.get("type"))){
				String pingjiajinbi=systemParamsDao.checkSystem("zhuce_jinbi",getComId());
				if(StringUtils.isBlank(pingjiajinbi)){
					jinbi=1000;
				}else{
					jinbi=Integer.parseInt(pingjiajinbi);
				}
				param.put("f_source", "注册");//注册
			}
		}
		if(b){
			param.put("com_id", map.get("com_id"));
			param.put("customer_id", map.get("customer_id"));
			param.put("f_num", jinbi);//增加为正数,消费为负数
			param.put("f_time", getNow());//消费或者获取时间
			param.put("flag", 0);//1-暂存,0-正式,消费时使用
			if(isNotMapKeyNull(map, "skdh")){
				param.put("orderNo", map.get("skdh"));//存储消费时的订单编号
				param.put("flag", 1);//暂存
			}else if (isNotMapKeyNull(map, "orderNo")) {
				param.put("orderNo", map.get("orderNo"));//存储消费时的订单编号
				param.put("flag", 1);//暂存
			}
			param.put("c_memo", map.get("item_id"));//分享的哪个产品
			param.put("sSql", getInsertSqlByPre("sdf00504_jinbi", param));
			productDao.insertSqlByPre(param);
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
			totalRecord=clientDao.getProductViewCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.getProductViewPage(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public String checkJinbiDikou(Map<String, Object> map) {
		//1.获取订单编号对应的金币抵扣数据ivt_oper_listing
		map.put("orderNo", "%"+map.get("ivt_oper_listing")+"%");
		List<Map<String,Object>> info= clientDao.getJinbiInfoByOrderNo(map);
		//2.删除该信息
		for (Map<String, Object> map2 : info) {
			String sSql="delete from sdf00504_jinbi where seeds_id="+map2.get("seeds_id");
			productDao.insertSql(sSql);
		}
		return null;
	}
	@Override
	public String updateJinbiXiaofei(Map<String, Object> map) {
		 
		return clientDao.updateJinbiXiaofei(map)+"";
	}
	
	@Override
	public Map<String, Object> getOtherTotal(Map<String, Object> map) {
		Integer jinbicount= clientDao.getTotalJinbi(map);
		if (jinbicount==null) {
			jinbicount=0;
		}
		Integer viewcount= clientDao.getProductViewCount(map);
		if (viewcount==null) {
			viewcount=0;
		}
		Integer couponcount=clientDao.getClientCouponCount(map);
		if (couponcount==null) {
			couponcount=0;
		}
		Map<String,Object> info=new HashMap<>();
		info.put("jinbicount", jinbicount);
		info.put("viewcount", viewcount);
		info.put("couponcount", couponcount);
		return info;
	}
	@Override
	public String saveCoupon(Map<String, Object> map) {
		String table="t_coupon";
		Map<String,Object> auth= (Map<String, Object>) getRequest().getSession().getAttribute("auth");
		String ivt_oper_listing=null;
		if(isMapKeyNull(map, "ivt_oper_listing")){//为空增加
			if(isNotMapKeyNull(auth, "coupon_add")){//检查权限
				ivt_oper_listing=DateTimeUtils.getNowDateTimeS();
				map.put("ivt_oper_listing", ivt_oper_listing);
				String sSql=getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			}else{
				return "无操作权限!";
			}
		}else{//修改
			if(isNotMapKeyNull(auth, "coupon_edit")){
				ivt_oper_listing=MapUtils.getString(map,"ivt_oper_listing");
				String sSql=getUpdateSql(map, table, "ivt_oper_listing",ivt_oper_listing ,true);
				productDao.insertSql(sSql);
			}else{
				return "无操作权限!";
			}
		}
		return ivt_oper_listing;
	}
	@Override
	public String delCoupon(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return clientDao.delCoupon(map)+"";
	}
	@Override
	public PageList<Map<String, Object>> getCouponPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=clientDao.getCouponCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.getCouponPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public String receiveCoupon(Map<String, Object> map) {
		//1.判断优惠券该客户是否已经领取
		Integer i=clientDao.checkCoupon(map);
		if(i==0||i==0){
			//2.未领取生成客户优惠券数据
			Map<String,Object> info=new HashMap<>();
			info.put("com_id", map.get("com_id"));
			info.put("customer_id", map.get("customer_id"));
			info.put("ivt_oper_listing", map.get("ivt_oper_listing"));
			info.put("get_time",getNow());
			info.put("f_type", 0);
			info.put("sSql", getInsertSqlByPre("sdf00504_coupon", info));
			productDao.insertSqlByPre(info);
		}
		//3.领取就直接结束
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getClientCoupon(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=clientDao.getClientCouponC(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.getClientCouponList(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public List<Map<String, Object>> getCanUseCoupon(Map<String, Object> map) {
		 //获取当前支付产品对应的产品类别编码
		List<String> list=clientDao.getProClassByOrder(map);
		map.put("list", list);
		return clientDao.getCanUseCoupon(map);
	}
	@Override
	public PageList<Map<String, Object>> getJinbiPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=clientDao.getJinbiCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=clientDao.getJinbiPage(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public String saveUseYhqInfo(Map<String, Object> map)throws Exception {
		//1.检查优惠券是否可用
		//2.更新订单编号到客户优惠券记录中
		Integer i=clientDao.saveUseYhqInfo(map);
		if(i!=1){
			throw new RuntimeException("优惠券已被使用请选择其它优惠券!");
		}else{
			return null;
		}
	}
	@Override
	public Integer checkYhq(Map<String, Object> map) {
		return clientDao.checkYhq(map);
	}
}
