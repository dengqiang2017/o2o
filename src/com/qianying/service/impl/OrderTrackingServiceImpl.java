package com.qianying.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IOrderTrackingDAO;
import com.qianying.page.PageList;
import com.qianying.service.IOrderTrackingService;
import com.qianying.util.ConfigFile;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.SendSmsUtil;
@Service
@Transactional
public class OrderTrackingServiceImpl extends BaseServiceImpl implements
		IOrderTrackingService {
	@Resource
	private IOrderTrackingDAO orderTrackingDao;

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
		//1.更新订单已出库
		employeeDao.updateOrderchuku(map);
		String processName=map.get("processName").toString();
		JSONObject item_json=getProcessParams(processName);
		//3.向客户发送产品已发货通知
		map.put("customer", "customer");
		List<Map<String, String>> cus=orderTrackingDao.getOrderInfoBySeeds_id(map);
		for (Map<String, String> map2 : cus) {
			//3.1获取订单中的客户信息
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", item_json.get("title"));
			mapMsg.put("description",item_json.get("content"));
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+item_json.getString("url")+"?seeds_id="+map.get("seeds_id")+"|"+utf8to16("已发货"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+item_json.get("CimgName"));
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			sendclientmsg(item_json.get("headship")+"", news, map2.get("customer_id")+"", processName);
		}
		String[] ses=map.get("seeds_id").toString().split(",");
		for (String seeds_id : ses) {
			saveOrderHistory(seeds_id, item_json.getString("content"));
		}
	}

	@Override
	public void noticeNeiqing(Map<String, Object> map) {
		if (isMapKeyNull(map, "")) {
			map.put("description","");
		}
		String description=map.get("description").toString();
		if (getCustomer(getRequest())!=null) {
			description=description.replaceAll("@customerName", getCustomer(getRequest()).get("clerk_name")+"");
		}
		String url="";
		if (isMapKeyNull(map, "url")) {
			url=url+"/employee/orderTracking.do?seeds_id="+map.get("seeds_id")+getMapKey(map, "param");
		}else{
			url+=map.get("url");
		}
		String imgName="/weixinimg/msg.png";
		if (isNotMapKeyNull(map, "imgName")) {
			imgName=map.get("imgName").toString();
		}
		//2.发送消息
		List<Map<String,String>> touserList=null;
		if (getNoticeStyle(map, "0")) {
			touserList=sendMessageNewsEmployee(map.get("msg")+"",description, map.get("headship")+"", imgName, url, null);
		}
		if (getNoticeStyle(map, "1")) {
			for (int i = 0; i < touserList.size(); i++) {
				Map<String, String> item= touserList.get(i);
				String newds=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", map.get("headship")+"")
						.replaceAll("@clerkName", item.get("clerk_name"));
				Map<String,Object> mapsms=getSystemParamsByComId();
				SendSmsUtil.sendSms2(item.get("movtel"), null,newds,mapsms);
			}
		}
		saveOrderHistory(map.get("seeds_id"),map.get("msg")+"");
	}
	@Override
	public void noticeAnPaiWuliu(Map<String, Object> map) {
		////////////////////
		String seeds_id=null;
		String Status_OutStore=null;
		Map<String,String[]> sopn=getProcessName();
		List<String> processNames=Arrays.asList(sopn.get("processName"));// getProcessNameList(getRequest());
		if(isNotMapKeyNull(map, "orders")){
			JSONArray jsons=JSONArray.fromObject(map.get("orders"));
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				map.put("st_hw_no",json.get("st_hw_no"));
				map.put("item_id",json.get("item_id"));
				map.put("orderNo",json.get("mps_id"));
				map.put("mps_id",json.get("mps_id"));
				//1.根据产品编号和采购单号获取订单id,当前流程步骤
				List<Map<String,Object>> infos= orderTrackingDao.getOrderInfoByCaiguo(map);
				for (Map<String, Object> mapinfo : infos) {
					if(seeds_id!=null){
						seeds_id=mapinfo.get("seeds_id")+","+seeds_id;
					}else{
						seeds_id=mapinfo.get("seeds_id")+"";
					}
					Status_OutStore=mapinfo.get("Status_OutStore")+"";
				}
				orderTrackingDao.updateStdm02001(map);
			}
		}else{
			//1.根据产品编号和采购单号获取订单id,当前流程步骤
			List<Map<String, Object>> infos= orderTrackingDao.getOrderInfoByCaiguo(map);
			for (Map<String, Object> mapinfo : infos) {
				if(seeds_id!=null){
					seeds_id=mapinfo.get("seeds_id")+","+seeds_id;
				}else{
					seeds_id=mapinfo.get("seeds_id")+"";
				}
				Status_OutStore=mapinfo.get("Status_OutStore")+"";
			}
			orderTrackingDao.updateStdm02001(map);
		}
		//2.根据流程步骤获取下一步流程步骤,对应的员工职务,对应的流程消息图片
		//更新订单表中的状态
		Integer index =processNames.indexOf(Status_OutStore);//按钮的索引值  从0开始
		String processName=processNames.get(index+1);
		if(StringUtils.isBlank(processName)){
			throw new RuntimeException("没有获取到流程名!");
		}
		String[] Eheadships=sopn.get("Eheadship");
		String headship =Eheadships[index+1];
		String[] imgNames=sopn.get("imgName");//流程对应消息的图片
		String imgName="msg.png";
		if(imgNames.length>index){
			imgName=imgNames[index+1];
			if (StringUtils.isBlank(imgName)) {
				imgName="msg.png";
			}
		}
		map.put("headship", headship);
		map.put("imgName", imgName);
		map.put("seeds_id", seeds_id);
		map.put("param", "|"+utf8to16(processName));
		map.put("Status_OutStore", processName);
		orderTrackingDao.updateOrderStatus(map);
		
		//3.向员工发送微信消息
		noticeNeiqing(map);
	}
	
	@Override
	public void noticeKuguan(Map<String, Object> map) {
		//1.更新订单数据
//		List<Map<String,Object>> list=getOrderInfoByIds(map.get("seeds_id")+"", null, map.get("com_id")+"");
		List<String> list= getProcessNameList(getRequest());
		int index=list.indexOf(map.get("processName"));
		String Status_OutStore=list.get(index+1);
		if(StringUtils.isBlank(Status_OutStore)){
			throw new RuntimeException("没有获取到流程名!");
		}
		map.put("Status_OutStore", Status_OutStore);
		employeeDao.updateOrderStatus(map);
		//2.发送消息
		String[] customer_names=map.get("customer_names").toString().split(",");
		Object msg=map.get("msg");
		for (String str : customer_names) {
			map.put("msg", "客户"+str+msg);
			noticeNeiqing(map);
		}
	}
	@Override
	public void noticeDrive(Map<String, Object> map) {
		List<Map<String,Object>> list=saiYuDao.getOrderInfoByIds(map.get("seeds_id").toString());
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		String HYS=list.get(0).get("HYS").toString();
		mapMsg.put("title",map.get("title"));
		mapMsg.put("description",map.get("description").toString().replaceAll("@hys", HYS.substring(0, HYS.indexOf("("))));
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/waybill.do?type=jin|_seeds_id="+map.get("seeds_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/driveShou.png");
		news.add(mapMsg);
		map.put("id", HYS.split(",")[2]);
		///////////////////
		String ids=map.get("seeds_id").toString();
		String qrUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/driverWaybillDetail.do?seeds_id="+ids;
		//生成二维码
		QRCodeUtil.generateQRCode(qrUrl, getRealPath(getRequest())+"/001/qrcode/"+ids+".jpg",getRealPath(getRequest())+"pc/image/logo.png");
		///////////////////////////////
		if(map.get("Status_OutStore")==null){
			throw new RuntimeException("没有获取到流程名!");
		}
		employeeDao.updateOrderStatus(map);
		List<Map<String, Object>> drives= employeeDao.getDriverToWeixin(map);
		sendMessageNews(news,getComId(),drives.get(0).get("weixinID").toString(),"司机");
		saveOrderHistory(map.get("seeds_id"), "库管完成备货");
	}
	@Override
	public void noticeOutedFactory(Map<String, Object> map) {
		//1.通知客户已经装车出厂请准备卸货
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("msg"));
		mapMsg.put("description",map.get("description"));
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do?seeds_id="+map.get("seeds_id")+"|"+utf8to16("已发货"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/driveShou.png");
		news.add(mapMsg); 
		zuheclientsendmsg(map.get("Cheadship")+"", news, map.get("customer_id")+"", "通知收货");
		//2.通知财务已经出厂
		news.get(0).put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?seeds_id="+map.get("seeds_id")+"|"+utf8to16("已发货"));
		news.get(0).put("title",map.get("msg"));
		sendWexinMsgToEmployee(news, map.get("headship"));
		///更新状态为已发货
		map.put("Status_OutStore", "已发货");
		map.put("at_term_datetime_Act", getNow());
		employeeDao.updateOrderStatus(map);
		saveOrderHistory(map.get("seeds_id"),  map.get("clerk_name")+",已经确认重量并出厂");
	}
	@Override
	public void confimShouhuo(Map<String, Object> map) {
		JSONArray jsons=null;
		if (map.get("orderlist")!=null) {
			  jsons=JSONArray.fromObject(map.get("orderlist"));
			map.put("jsons", jsons);
		}
		orderTrackingDao.confimShouhuo(map);
		//发送消息给内勤
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		String proceessStr=getFileTextContent(getSalesOrderProcessNamePath(getRequest()));
		JSONObject json=null;
		if (StringUtils.isNotBlank(proceessStr)&&proceessStr.startsWith("[")) {
			JSONArray proceess=JSONArray.fromObject(proceessStr);
			json=proceess.getJSONObject(proceess.size()-1);
		}
		String description=json.getString("Econtent").replace("@comName", getComName());
		description=description.replaceAll("@customerName",map.get("clerk_name")+"");
		description=description.replaceAll("@orderNo", map.get("orderNo")+"");
		description=description.replaceAll("@Eheadship", json.getString("Eheadship"));
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",json.getString("Etitle"));
		mapMsg.put("description",description);
		String url=ConfigFile.urlPrefix+json.getString("Eurl")+"?seeds_id="
				+map.get("seeds_id")+"|processName="+utf8to16("已结束");
		mapMsg.put("url", url);
		mapMsg.put("picurl", ConfigFile.urlPrefix+json.get("imgName"));
		news.add(mapMsg); 
		//2.客户向内勤发送已收货信息
		///向员工发送客户订单已经签收消息
		String orderNo="";
		if (jsons!=null) {
			for (int i = 0; i < jsons.size(); i++) {
				String no=jsons.getJSONObject(i).getString("orderNo");
				if (!orderNo.contains(no)) {
					orderNo+=no;
				}
			}
		}else{
			 orderNo=map.get("orderNo").toString();
		}
		map.put("orderNo", orderNo);
		List<Map<String,String>> touserList=sendWexinMsgToEmployee(news,json.get("Eheadship"));
		if(touserList!=null&&touserList.size()>0){
			sendShouHuo(touserList, map, url, json.getString("template_id"),"");
		}
		Map<String,String> empl=sendMsgToYewuyuan("客户【"+map.get("clerk_name")+"】的订单产品已收货",description.replaceAll("@headship", "业务员"),map.get("customer_id"),map.get("seeds_id"));
		if(empl!=null&&StringUtils.isNotBlank(empl.get("openid"))){
			List<Map<String,String>> yewuyuan=new ArrayList<>();
			yewuyuan.add(empl);
			sendShouHuo(yewuyuan, map, url, json.getString("template_id"),"业务员"+empl.get("clerk_name"));
		}
		if (isMapKeyNull(map, "seeds_id")) {
			saveOrderHistory(map.get("orderNo"),map.get("item_id"), description+"");
		}else{
			String[] ses=map.get("seeds_id").toString().split(",");
			for (String seeds_id : ses) {
			saveOrderHistory(seeds_id, "客户确认收货,收货人:"+map.get("clerk_name"));
			}
		}
	}
	/**
	 * 
	 */
	private void sendShouHuo(List<Map<String,String>> yewuyuan,Map<String,Object> map,String url,String template_id,String clerk_name) {
		template_id="u9ZeHWVLavDfK-3jyBIpPV9g9vskOuW4Tb2oQdPxpjs";
		Map<String,Object> param=new HashMap<>();
		param.put("com_id", getComId());
		param.put("template_id", template_id);
		String first=clerk_name+"你好,客户【"+map.get("clerk_name")+"】订单已收货:";
		List<Map<String,Object>> tempList= managerDao.getWexinMsgTemplate(param);
		if (tempList!=null&&tempList.size()>0) {
			JSONObject data=new JSONObject();
			String[] cons=tempList.get(0).get("content").toString().split("\\.");
			data.put("first",first);
			data.put(cons[0],getWeixinTempItem(map.get("orderNo")));//订单编号
			data.put(cons[1],getWeixinTempItem(map.get("clerk_name")));//收货人
			data.put(cons[2],getWeixinTempItem("订单已签收"));//商品明细
			data.put("remark",getWeixinTempItem("点击“详情”查看完整订单信息,消息发送时间:"+getNow()));
			sendWeixinServiceMsg(url, template_id, data, yewuyuan);
		}
	}
	
	@Override
	public void updateOrderState(Map<String,Object> map) {
		orderTrackingDao.confimShouhuo(map);
	}
	
	@Override
	public String saveHandle(Map<String, Object> map) {
		//获取当前流程下一步员工职务,客户职务,对应图片
		Map<String,String[]> sopn=getProcessName();
		List<String> processNames=Arrays.asList(sopn.get("processName"));// getProcessNameList(getRequest());
		Integer index =processNames.indexOf(map.get("name"));//按钮的索引值  从0开始
		String headship=sopn.get("headship")[index+1];
		String Eheadship=sopn.get("Eheadship")[index+1];
		String processName=processNames.get(index+1);
		map.put("Status_OutStore",processName);
		String[] imgNames=sopn.get("imgName");//流程对应消息的图片
		String imgName="msg.png";
		if(imgNames.length>index){
			imgName=imgNames[index];
			if (StringUtils.isBlank(imgName)) {
				imgName="msg.png";
			}
		}
		//消息发送类型
		boolean sms=getNoticeStyle(map, "1");
		boolean weixin=getNoticeStyle(map, "0");
		////物流方式进行分流//
		String url=null;
//		String erweimaUrl=null;
		String wuliu=map.get("wuliu").toString();
//		String kufang="0";
//		if (wuliu.startsWith("0")) {///到公司库房拉货
//			erweimaUrl="../orderTrack/driverWaybillDetail.do?seeds_id="+map.get("seeds_id");
//		}else{//到供应商库房拉货
//			kufang="1";
//			erweimaUrl="../orderTrack/driverWaybillDetailSupplier.do?seeds_id="+map.get("seeds_id");
//		}
		if(wuliu.contains("-1")){//安排物流消息发送给员工
			//1.准备员工安排物流url
			url="/orderTrack/employeeLogistics.do?seeds_id="+map.get("seeds_id")+"|_wuliu="+wuliu;
		}else if(wuliu.contains("-2")){//安排物流消息发送给客户
			//2.准备客户安排物流url
			url="/orderTrack/customerLogistics.do?seeds_id="+map.get("seeds_id")+"|_wuliu="+wuliu;
			map.put("customer", "customer");
		}else if (wuliu.contains("-3")) {//安排物流消息发送给第三方物流
			//准备第三方物流消息
			url="/orderTrack/thirdLogistics.do?seeds_id="+map.get("seeds_id")+"|_wuliu="+wuliu;
		}else{//安排物流发送给供应商
			//4.准备供应商安排物流url
			url="/orderTrack/supplierLogistics.do?seeds_id="+map.get("seeds_id")+"|_wuliu="+wuliu;
			map.put("vendor", "vendor");
		}
		//更新车牌号,提货地点,订单状态
		orderTrackingDao.updateOrderStatus(map);
		///发送消息
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("msg"));
		mapMsg.put("addName",map.get("addName"));
		mapMsg.put("description",map.get("description"));
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/"+imgName);
		news.add(mapMsg);
		///向员工发送消息
		List<Map<String, String>> touserList=null;
		String content=getComName()+"平台";
		if(wuliu.contains("-1")){
			if (weixin) {
				touserList=sendemployeemsg(Eheadship, news, map.get("com_id"), processName);
			}
			if(sms){
				if(touserList==null){
					Map<String,Object> mapper=new HashMap<String, Object>();
					mapper.put("com_id", getComId());
					mapper.put("movtel","movtel");
					mapper.put("headship", "%"+Eheadship+"%");
					mapper.put("processName", "%"+processName+"%");
					mapper.put("omrtype",getSystemParam("ordersMessageReceivedType"));
					touserList=employeeDao.getPersonnelNeiQing(mapper);
				}
				for (Map<String, String> movtel : touserList) {
					if (StringUtils.isNotBlank(movtel.get("movtel"))) {
						String add=movtel.get("clerk_name")+":";
						Map<String,Object> mapsms=getSystemParamsByComId();
						SendSmsUtil.sendSms2(movtel.get("movtel"), null,map.get("msg")+add+map.get("description"),mapsms);
					}
				}
			}
		}else{
			List<Map<String,String>> list=orderTrackingDao.getOrderInfoBySeeds_id(map);
			///向客户发送消息
			for (Map<String, String> map2 : list) {
				if(isNotMapKeyNull(map, "customer")){//向客户发送消息
					content="客户物流经办人";
					if(weixin){
						touserList=sendclientmsg(Eheadship, news, map2.get("customer_id"), processName);
					}
					if(sms){
						if(touserList==null){
							Map<String,Object> params=new HashMap<String, Object>();
							params.put("headship","%"+headship+"%");
							params.put("processName","%"+processName+"%");
							params.put("com_id", getComId());
							params.put("upper_customer_id",map2.get("customer_id"));
							params.put("omrtype",getSystemParam("ordersMessageReceivedType"));
							touserList=customerDao.getCustomerWeixinByHeadship(params);
						}
						if(touserList!=null){
							for (Map<String, String> movtel : touserList) {
								if (StringUtils.isNotBlank(movtel.get("movtel"))) {
									String add="尊敬的客户"+movtel.get("corp_sim_name")+",";
									Map<String,Object> mapsms=getSystemParamsByComId();
									SendSmsUtil.sendSms2(movtel.get("movtel"), null,map.get("msg")+add+map.get("description"),mapsms);
								}
							}
						}
					}
				}else if(isNotMapKeyNull(map, "vendor")){//向供应商发送消息
					if(weixin){
						String addName="title";
						if (news.get(0).get("addName")!=null) {
							addName=news.get(0).get("addName").toString();
						}
						String title=news.get(0).get(addName).toString();
						String msg="供应商经办人:"+map2.get("corp_name")+","+title;
						news.get(0).put(addName,msg);
						if (StringUtils.isNotBlank(map2.get("weixinID"))) {
							sendMessageNews(news,getComId(),map2.get("weixinID"),"供应商");
						}
						news.get(0).put(addName,title);
					}
					if(sms){
						Map<String,Object> mapsms=getSystemParamsByComId();
						SendSmsUtil.sendSms2(map2.get("phone"), null,map.get("msg")+map2.get("corp_name")+":"+map.get("description"),mapsms);
					}
				}else{//第三方物流
					if(weixin){
						String addName="title";
						if (news.get(0).get("addName")!=null) {
							addName=news.get(0).get("addName").toString();
						}
						String title=news.get(0).get(addName).toString();
						String msg="第三方经办人:"+map2.get("corp_name")+","+title;
						news.get(0).put(addName,msg);
						if (StringUtils.isNotBlank(map2.get("weixinID"))) {
							sendMessageNews(news,getComId(),map2.get("weixinID"),"第三方");
						}
						news.get(0).put(addName,title);
					}
					if(sms){
						Map<String,Object> mapsms=getSystemParamsByComId();
						SendSmsUtil.sendSms2(map2.get("phone"), null,map.get("msg")+map2.get("corp_name")+":"+map.get("description"),mapsms);
					}
				}
			} 
		}
		String[] ses=map.get("seeds_id").toString().split(",");
		for (String seeds_id : ses) {
		saveOrderHistory(seeds_id, content+"物流经办人补充确认司机车牌号");
		}
		return null;
	}
	/**
	 * 根据seeds_id获取下一步流程名称
	 * @param map seeds_id
	 * @return 流程名称
	 */
	private String getStatus_OutStoreBySeeds_id(Map<String, Object> map) {
		String Status_OutStore=orderTrackingDao.getOrderInfoStatus_OutStoreBySeeds_id(map);
		List<String> sts= getProcessNameList(getRequest());
		int index=sts.indexOf(Status_OutStore);
		return sts.get(index+1);
	}
	@Override
	public void postWuliu(Map<String, Object> map) {
		String erweimaUrl=null;
		String wuliu=map.get("wuliu").toString();
//		String kufang="0";
		map.put("Status_OutStore", getStatus_OutStoreBySeeds_id(map));
		///1.更新订单从表物流信息
		if(map.get("Status_OutStore")==null){
			throw new RuntimeException("没有获取到流程名!");
		}
		orderTrackingDao.updateOrderStatus(map);
		//2.更新采购表中的物流信息//
		//通知内勤,物流经办人已经提交司机和车牌号了(文字消息)
		if (wuliu.startsWith("0")) {///到公司库房拉货
			erweimaUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/driverWaybillDetail.do?seeds_id="+map.get("seeds_id");
			///通知库管拉货司机信息,车牌号,前来拉货的时间
			
		}else{//到供应商库房拉货
			///2.更新采购订单物流信息
			//2.1根据订单seeds获取采购订单中的订单编号
			List<Map<String, String>> list= orderTrackingDao.getCaigouOrderInfoByOrderSeeds_id(map);
			String wuliufs="";
			if(map.get("wuliu").toString().contains("-4")){//供应商直接送货
				wuliufs="供应商配送,";
			}else{//公司配送
				wuliufs="公司自提";
			}
			map.put("wuliufs", wuliufs+map.get("HYS")+",车牌号:"+map.get("Kar_paizhao")+","+map.get("tihuoDate"));
			if(list!=null&&list.size()>0){
				for (Map<String, String> map2 : list) {
					map.put("item_id", map2.get("item_id"));
					map.put("st_auto_no", map2.get("st_hw_no"));
					map.put("mps_id", map2.get("orderNo"));
					orderTrackingDao.updateStdm02001(map);
				}
			}
			//2.2更新采购订单物流信息
//			kufang="1";
			erweimaUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/supplierDriverWaybillDetail.do?seeds_id="+map.get("seeds_id");
			//通知供应商拉货司机,车牌号,前来拉货的时间
		}
		////向司机发送微信消息
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		String HYS= map.get("HYS").toString();
		mapMsg.put("title","送货通知");
		mapMsg.put("description","司机:"+HYS.split(",")[1]+"你有一条来自【"+getComName()+"】的送货通知" );
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/waybill.do?seeds_id="+map.get("seeds_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/driveShou.png");
		news.add(mapMsg);
		sendMessageNews(news,getComId(), map.get("HYS").toString().split(",")[1],"司机");
		/////////
		//生成二维码
		QRCodeUtil.generateQRCode(erweimaUrl, getRealPath(getRequest())+"/001/qrcode/"+map.get("seeds_id")+".jpg",getRealPath(getRequest())+"pc/image/logo.png");
		/////
		String content=getComName()+"平台物流经办人";
		if (!map.get("wuliu").toString().contains("-1")) {
			content="客户物流经办人";
		}
		String[] ses=map.get("seeds_id").toString().split(",");
		for (String seeds_id : ses) {
		saveOrderHistory(seeds_id, content+",提交司机信息:"+map.get("HYS")+","+map.get("Kar_paizhao")+","+map.get("tihuoDate"));
		}
	}
	
	@Override
	public List<Map<String, Object>> getWuliuByOrder(Map<String, Object> map) {
		return orderTrackingDao.getWuliuByOrder(map);
	}
	@Override
	public Map<String,Object> getProductionPlanPH(Map<String, Object> map) {
		 
		return orderTrackingDao.getProductionPlanPH(map);
	}

	@Override
	public String noticePurchasingOrPPlan(Map<String, Object> map) {
		//1.获取待更新状态
		//2.更新指定的数据
		Integer i= orderTrackingDao.updateOrderStatus(map);
		if(i>0){//更新成功
			//3.向指定职位发送消息
			String imgName="/weixinimg/msg.png";
			String description=MapUtils.getString(map, "description");
			sendMessageNewsEmployee(MapUtils.getString(map, "title"),description,
					MapUtils.getString(map, "headship"),imgName, MapUtils.getString(map, "url"), map.get("com_id"));
			//4.记录到订单跟踪历史中
			saveOrderHistory(map.get("seeds_id"),"开始准备"+map.get("shipped"));
		}else{
			return "选择的产品中已经在["+map.get("shipped")+"]中";
		}
		return null;
	}
	
	@Override
	public PageList<Map<String, Object>> getWaitingHandleOrderPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=orderTrackingDao.getWaitingHandleOrderCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=orderTrackingDao.getWaitingHandleOrderList(map);
		pages.setRows(list);
		return pages;
	}
	
}
