package com.qianying.service.impl;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IPreTradingDAO;
import com.qianying.page.PageList;
import com.qianying.service.IPreTradingService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;

@Service
@Transactional
public class PreTradingServiceImpl extends BaseServiceImpl implements
		IPreTradingService {
	@Resource
	private IPreTradingDAO preTradingDao;
	
	@Override
	public List<Map<String, Object>> getProductByClassName(Map<String, Object> map) {
		return preTradingDao.getProductByClassName(map);
	}
	
	@Override
	public String savePre(Map<String, Object> map) throws Exception {
		// TODO 保存预售信息
		if (!map.get("list").toString().startsWith("[")) {
			return "数据格式错误";
		}
		JSONArray jsons=JSONArray.fromObject(map.get("list"));
		String no="NO."+DateTimeUtils.getNowDateTimeS();
		int k=0;
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i); 
			if(json.has("price")&&json.has("time")){
				k++;
				Map<String,Object> mapinfo=new HashMap<String, Object>();
				mapinfo.put("ivt_oper_listing", no);
				mapinfo.put("com_id", map.get("com_id"));
				mapinfo.put("customer_id", map.get("customer_id"));
				mapinfo.put("mainten_clerk_id", map.get("customer_id"));
				mapinfo.put("item_id", json.get("item_id"));
				mapinfo.put("sd_oq", json.get("num"));
				mapinfo.put("sd_unit_price", json.get("price"));
				if (json.has("time")&&StringUtils.isNotBlank(json.getString("time"))) {
					mapinfo.put("guajia_datetime", json.get("time"));
				}else{
					mapinfo.put("guajia_datetime",getNow());
				}
				mapinfo.put("address", getJsonVal(json,"address"));
				mapinfo.put("latlng", getJsonVal(json, "latlng"));
				mapinfo.put("mainten_datetime", getNow());
				mapinfo.put("jiaoyi_num", 0);
				mapinfo.put("selling_price", 0);
				mapinfo.put("sSql", getInsertSqlByPre("t_Pre_Trading", mapinfo));
				productDao.insertSqlByPre(mapinfo);
				///保存图片
				JSONArray imgs= json.getJSONArray("imgs");
				for (int j = 0; j < imgs.size(); j++) {
					File srcFile=new File(getRealPath(getRequest())+imgs.getString(j).replaceAll("\\.\\.", ""));
					File destFile=new File(getComIdPath(getRequest())+"preimg/"+no+"/"+srcFile.getName());
					if(srcFile.exists()&&srcFile.isFile()){
						mkdirsDirectory(destFile);
						FileUtils.moveFile(srcFile, destFile);
					}
				}
			}
			}
		if (k==0) {
			throw new RuntimeException("请输入挂价相关信息!");
		}
		return null;
	}
	
	@Override
	public String preSaleConfirm(Map<String, Object> map) {
		return preTradingDao.preSaleConfirm(map)+"";
	}

	@Override
	public PageList<Map<String, Object>> preTradingPage(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=preTradingDao.preTradingPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=preTradingDao.preTradingPage(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> platformHistoryPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=preTradingDao.platformHistoryCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=preTradingDao.platformHistoryPage(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public List<Map<String, Object>> preSaleConfirmListQuery(
			Map<String, Object> map) {
		return preTradingDao.preSaleConfirmListQuery(map);
	}
	
	@Override
	public List<Map<String, Object>> getPreAverageInfo(Map<String, Object> map) {
		return preTradingDao.getPreAverageInfo(map);
	}
	
	@Override
	public List<Map<String, Object>> getPreCustomerInfo(Map<String, Object> map) {
		return preTradingDao.getPreCustomerInfo(map);
	}
	@Override
	public String editGuajia(Map<String, Object> map) {
		return preTradingDao.updateSql(map)+"";
	}
	@Override
	@Transactional
	public String saveCuoheInfo(Map<String, Object> map) {
		// TODO 保存撮合信息
		//预售方
		JSONArray ysfs=JSONArray.fromObject(map.get("ysfList"));
		String no="NO."+DateTimeUtils.getNowDateTimeS()+"CH";
//		BigDecimal sg_num=new BigDecimal(0);
		BigDecimal mc_num=new BigDecimal(0);
//		BigDecimal buy_unit_price=new BigDecimal(0);
		BigDecimal selling_price=new BigDecimal(0);
		if(ysfs.size()==0){
			return "养殖户数据缺失!";
		}
//		if(ygfs.size()==0){
//			return "贩卖方数据缺失!";
//		}
		JSONObject ygf=JSONObject.fromObject(map.get("ygfjson")); 
		for (int i = 0; i < ysfs.size(); i++) {
			JSONObject ysf=ysfs.getJSONObject(i);
			Map<String,Object> detail=new HashMap<String, Object>();
			detail.put("com_id",map.get("com_id"));
			detail.put("ivt_oper_listing", no);
			detail.put("m_flag", "0");
			detail.put("item_id", ysf.get("item_id"));
			detail.put("customer_id", ysf.get("customer_id"));
			detail.put("sd_oq", ysf.get("num"));
			detail.put("sd_unit_price", ysf.get("price"));
			detail.put("cuohe_datetime", getNow());
			mc_num.add(new BigDecimal(ysf.getString("num")));
			selling_price.add(new BigDecimal(ysf.getString("price")));
			detail.put("pre_trading_no", ysf.get("ivt_oper_listing"));
			detail.put("buyer_id", ygf.get("customer_id"));//收购方
			ygf.put("num", ysf.get("num"));
			detail.put("buyer_sd_oq", ysf.get("num"));//养殖户的数据
			detail.put("buyer_sd_unit_price", ygf.get("price"));
			detail.put("buyer_pre_trading_no", ygf.get("ivt_oper_listing"));
			detail.put("sSql", getInsertSqlByPre("sdd02031", detail));
			ygf.put("com_id", map.get("com_id"));
			ygf.put("clerk_id", map.get("clerk_id"));
			ygf.put("now",getNow());
			productDao.insertSqlByPre(detail);
			/// 更新预购方表交易数量
			preTradingDao.updateYgfInfo(ygf);
			///更新预售方表交易数量
			ysf.put("com_id", map.get("com_id"));
			ysf.put("clerk_id", map.get("clerk_id"));
			ysf.put("now",getNow());
			preTradingDao.updateYsfInfo(ysf);
		}
//		for (int i = 0; i < ygfs.size(); i++) {
//			sg_num.add(new BigDecimal(ygf.getString("num")));
//			buy_unit_price.add(new BigDecimal(ygf.getString("price")));
//		}
//		buy_unit_price=buy_unit_price.divide(new BigDecimal(ygfs.size()));
		try {
			selling_price=selling_price.divide(new BigDecimal(ysfs.size()));
		} catch (Exception e) {
		}
		
		Map<String,Object> mainMap=new HashMap<String, Object>();
		mainMap.put("com_id",map.get("com_id"));
		mainMap.put("ivt_oper_listing", no);
		mainMap.put("sg_num", ygf.getString("num"));//收购数量
		mainMap.put("mc_num", mc_num);//卖出数量
		mainMap.put("buy_unit_price", ygf.getString("price"));//收购均价
		mainMap.put("selling_price", selling_price);//卖出均价
		mainMap.put("cuohe_datetime", getNow());
		mainMap.put("item_id", ygf.get("item_id"));
		mainMap.put("mainten_clerk_id", map.get("clerk_id"));
		mainMap.put("mainten_datetime", getNow());
		mainMap.put("sSql", getInsertSqlByPre("sdd02030", mainMap));
		productDao.insertSqlByPre(mainMap);
		
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title","预购交易确认通知");
		mapMsg.put("description",map.get("description").toString().replace("@comName",getComName()+"-收购人"));
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/pre/reserveBuyConfirmPage.do?"+no);
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		//向预购方发生消息
		zuheclientsendmsg("", news, ygf.getString("customer_id"), "","贩卖方");
		//向养殖户发生消息
		for (int i = 0; i < ysfs.size(); i++) {//预售方-养殖户
			String description=map.get("description").toString().replace("@comName",getComName()+"-预售人");
			news.get(0).put("description", description);
			news.get(0).put("title", "预售交易确认通知");
			news.get(0).put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/pre/preSaleConfirmPage.do?"+no);
			zuheclientsendmsg("", news, ysfs.getJSONObject(i).getString("customer_id"),"", "养殖户");
		}
		return  "";
	}
	
	@Override
	public PageList<Map<String, Object>> reserveBuyQuery(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=preTradingDao.reserveBuyQueryCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=preTradingDao.reserveBuyQuery(map);
		pages.setRows(list);
		return pages;
	}
}
