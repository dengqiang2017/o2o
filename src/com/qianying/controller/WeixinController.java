package com.qianying.controller;

import java.io.File;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.service.IClientService;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.ISaiYuService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.Sign;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;


@Controller
@RequestMapping("/weixin")
@Component
public class WeixinController extends FilePathController{

	@Autowired
	ICustomerService customerService;
	@Autowired
	ISaiYuService saiYuService;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private IClientService clientService;
	@Autowired
	private IEmployeeService employeeService;
	@Autowired
	private ISystemParamsService systemParams;
	
	@RequestMapping("weixin")
	@ResponseBody
	public Map<String,Object> weixin(HttpServletRequest request) {
		Map<String,Object> mapresult=new HashMap<String, Object>();
		try {
			//////获取用户的openid工具userId/////
			String com_id=request.getParameter("com_id");
			if(StringUtils.isBlank(com_id)){
				com_id=getComId();
			}
			String trade_type=request.getParameter("trade_type");
			if (StringUtils.isBlank(trade_type)) {
				trade_type="JSAPI";
			}
			//微信支付提交接口
			String url="https://api.mch.weixin.qq.com/pay/unifiedorder";
			WeixinUtil wei=new WeixinUtil();
			String nonce_str=UUID.randomUUID().toString().substring(0, 8);
			String orderNo=request.getParameter("orderNo");
			if (StringUtils.isBlank(orderNo)) {
				LoggerUtils.error(LogUtil.getIpAddr(request)+getCustomerId(request));
				return null;
			}
			orderNo=orderNo.replaceAll("NO\\.", "");
			String total_fee=request.getParameter("total_fee");//总金额
			String appid=request.getParameter("appid");//
			String timeStamp=null;
			String weixinType=systemParams.checkSystem("weixinType", "0");
			String payTestOne=systemParams.checkSystem("payTestOne", "false");
			if("true".equals(payTestOne)){
				total_fee="1";
			}
			String mch_id=null;
			String openid=null;
			Object weixinID=getCustomer(request).get("weixinID");
			if(isNotMapKeyNull(getCustomer(request), "weixinID")){//默认从企业号开始
				appid=systemParams.checkSystem("corpid", "");
				mch_id=systemParams.checkSystem("mch_id","");
				openid=wei.useridToOpenid(weixinID+"",getComId());//
				weixinType="1";
			}
			if (isNotMapKeyNull(getCustomer(request), "openid")) {
				if("0".equals(weixinType)&&StringUtils.isBlank(openid)){//服务号,企业号获取openid失败后,转为服务号
					appid=systemParams.checkSystem("appid_service","");
					mch_id=systemParams.checkSystem("mch_id_service","");
					openid=getCustomer(request).get("openid").toString();
					weixinType="0";
				}
			}
			if (StringUtils.isBlank(appid)) {
				throw new RuntimeException("没有获取到appid"+weixinType);
			}
			if (StringUtils.isBlank(mch_id)) {
				throw new RuntimeException("没有获取到商家号"+weixinType);
			}
			if (StringUtils.isBlank(openid)) {
				throw new RuntimeException("没有获取到openid"+weixinType);
			}
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("appid", appid);
			String attach=request.getParameter("attach");
			String body=request.getParameter("body");
			map.put("attach",attach);
			map.put("body",body);
			map.put("mch_id", mch_id);
			map.put("device_info","WEB");
			map.put("nonce_str", nonce_str);
			map.put("notify_url", WeixinUtil.notify_url);
			map.put("out_trade_no", orderNo);
			String spbill_create_ip=LogUtil.getIpAddr(request);
			map.put("spbill_create_ip", spbill_create_ip);
			map.put("total_fee",total_fee);
			map.put("fee_type","CNY");
//			map.put("trade_type","JSAPI");
//			map.put("trade_type","NATIVE");
			map.put("trade_type",trade_type);
			map.put("openid",openid);
			String sign=Sign.sign(map,weixinType);
			LoggerUtils.info(sign);
			
			////////////组合参数///
			StringBuffer params=new StringBuffer("<xml>");
			params.append("<appid>").append(appid).append("</appid>");
			params.append("<attach>").append(attach).append("</attach>");
			params.append("<body>").append(body).append("</body>");
			params.append("<device_info>WEB</device_info>");
			params.append("<fee_type>CNY</fee_type>");///货币类型
			params.append("<mch_id>").append(mch_id).append("</mch_id>");
			params.append("<nonce_str>").append(nonce_str).append("</nonce_str>");
			params.append("<notify_url>").append(WeixinUtil.notify_url).append("</notify_url>");
			params.append("<openid>").append(openid).append("</openid>");
			params.append("<out_trade_no>").append(orderNo).append("</out_trade_no>");
			params.append("<spbill_create_ip>").append(spbill_create_ip).append("</spbill_create_ip>");
			params.append("<total_fee>").append(Integer.parseInt(total_fee)).append("</total_fee>");
			params.append("<trade_type>"+trade_type+"</trade_type>");//交易类型
//			params.append("<trade_type>JSAPI</trade_type>");//交易类型
			params.append("<sign>").append(sign).append("</sign>");
			params.append("</xml>");
			String msg=wei.postxml(url, params.toString());
			LoggerUtils.info(msg);
			mapresult=readStringXmlOut(msg);
			
			Map<String,Object> mapjs=new HashMap<String, Object>();
			if (StringUtils.isBlank(timeStamp)) {
				timeStamp = DateTimeUtils.strToDateTime(getNow()).getTime() + "";
				timeStamp=timeStamp.substring(0, timeStamp.length()-3);
			}
			mapjs.put("appId", appid);
			mapjs.put("timeStamp", timeStamp);
			mapjs.put("nonceStr",mapresult.get("nonce_str"));
			mapjs.put("package", "prepay_id="+mapresult.get("prepay_id"));
			if (!isMapKeyNull(mapresult, "code_url")) {
				String path="weixin/paycode_url/"+orderNo+".jpg";
				String destPath=getRealPath(request)+path;
				QRCodeUtil.generateQRCode(mapresult.get("code_url").toString(), destPath, getRealPath(getRequest())+"pc/image/logo.png");
				mapresult.put("codeUrl", path);
			}
			mapjs.put("signType", "MD5");
			String paySign=Sign.sign(mapjs,weixinType);
			mapresult.put("paySign",paySign);
			mapresult.put("timeStamp",timeStamp);
			mapresult.put("appId", appid);
			mapresult.put("weixinType", weixinType);
			mapresult.put("payTestOne", payTestOne);
			//保存日志
			File qxFile=new File(getComIdPath(request)+"recievedmemo/"+orderNo+".txt");
			mkdirsDirectory(qxFile);
			saveFile(qxFile, getCustomer(request).get("clerk_name")+"进行了充值,金额:"+total_fee+",订单编号:"+orderNo+",时间:"+getNow());
		} catch (Exception e) {
			if (StringUtils.isNotBlank(e.getMessage())) {
				mapresult.put("error", e.getMessage());
			}
//			e.printStackTrace();
		}
		return mapresult;
	}
	
	/**
	 * 用于html页面时,通过微信跳转
	 * @param request
	 * @return
	 */
	@RequestMapping("htmltourl")
	@ResponseBody
	public ResultInfo htmltourl(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			msg=tourl(request);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
   /**
    * @description 将xml字符串转换成map
    * @param xml
    * @return Map
    */
   public Map<String,Object> readStringXmlOut(String xml) {
       Map<String,Object> map = new HashMap<String, Object>();
       Document doc = null;
       try {
           doc = DocumentHelper.parseText(xml); // 将字符串转为XML
           Element rootElt = doc.getRootElement(); // 获取根节点
           Iterator<Element> iter = rootElt.elementIterator(); // 获取根节点下的子节点head
           // 遍历head节点
           while (iter.hasNext()) {
               Element recordEle = (Element) iter.next();
               map.put(recordEle.getName(), recordEle.getTextTrim());
           }
       } catch (DocumentException e) {
           e.printStackTrace();
       } catch (Exception e) {
           e.printStackTrace();
       }
       return map;
   }
	
	/**
	 *  微信支付警告接口
	 * @param request
	 * @return
	 */
	@RequestMapping("warning")
	@ResponseBody
	public String warning(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		LoggerUtils.error(map);
		return "success";
//		return "weixin/warning";
	}
	
	/**
	 *  微信支付回调地址
	 * @param request
	 * @return
	 */
	@RequestMapping("notify_url")
	public String notify_url(HttpServletRequest request) {
//		Map<String,Object> map=getKeyAndValueQuery(request);
//		System.out.println("----notify_url-----");
//		System.out.println(map);
		Map<String,Object> map=getKeyAndValue(request);
		if (map.get("orderNo")!=null&&map.get("orderNo")!="") {
			map.put("recieved_id","NO."+map.get("orderNo"));
//			map.put("customer_id", getUpperCustomerId(request));
			customerService.alipayOK(map);
		}
		return "success"; 
	}
	/**
	 * 跳转微信支付界面
	 * @param response
	 * @param orderNo 
	 * @param amount
	 * @throws Exception
	 */
	@RequestMapping("alipay")
	public void alipay(HttpServletRequest request, HttpServletResponse response, String orderNo,
			String amount,String attach,String body) throws Exception {
		if (StringUtils.isBlank(amount)) {
			throw new RuntimeException("金额不能为0!");
		}
		//金额单位为分,乘以100
		String total_fee=new BigDecimal(amount).multiply(new BigDecimal(100)).toString().split("\\.")[0];
		StringBuffer builder=new StringBuffer("../weixin/pay.jsp?");
		StringBuffer stringSignTemp=new StringBuffer();
		stringSignTemp.append("orderNo=").append(orderNo).append("&total_fee=");
		stringSignTemp.append(total_fee).append("&attach=").
		append(URLEncoder.encode(attach,"UTF-8")).append("&body=").append(URLEncoder.encode(body,"UTF-8"));
		builder.append(stringSignTemp);
		String key=MD5.MD5Encode(stringSignTemp.toString()).toLowerCase();
		builder.append("&key=").append(key).append("&com_id=").append(getComId(request));
		response.sendRedirect(builder.toString());
 	}
	/**
	 * 支付取消
	 * @param request
	 * @return
	 */
	@RequestMapping("alipayCancel")
	@ResponseBody
	public ResultInfo alipayCancel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (map.get("orderNo")!=null&&map.get("orderNo")!="") {
				map.put("recieved_id","NO."+map.get("orderNo"));
				map.put("customer_id", getUpperCustomerId(request));
				msg=customerService.alipayCancel(map);
				success = true;
			}else{
				msg="没有收款单号!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 支付取消
	 * @param request
	 * @return
	 */
	@RequestMapping("alipayClose")
	@ResponseBody
	public ResultInfo alipayClose(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (map.get("orderNo")!=null&&map.get("orderNo")!="") {
				map.put("recieved_id","NO."+map.get("orderNo"));
				map.put("customer_id", getCustomer(request));
				msg=saiYuService.alipayClose(map);
				success = true;
			}else{
				msg="没有收款单号!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取微信上面支付状态
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderPayState")
	@ResponseBody
	public ResultInfo getOrderPayState(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei=new WeixinUtil();
			String nonce_str=UUID.randomUUID().toString().substring(0, 8);
			Map<String,Object> map=getKeyAndValue(request);
			//1.从外部文件中获取订单seeds_id
			Object orderNo=map.get("orderNo");
			if (orderNo.toString().contains("NO")) {
				orderNo=orderNo.toString().replaceAll("NO\\.", "");
			}
			String weixinType=request.getParameter("weixinType");
			if(StringUtils.isBlank(weixinType)){
				weixinType=systemParams.checkSystem("weixinType", "0");
			}
			String appid=null;
			String mch_id=null;
			if("0".equals(weixinType)){//服务号
				appid=systemParams.checkSystem("appid_service","");
				mch_id=systemParams.checkSystem("mch_id_service","");
				if (getCustomer(request).get("openid")!=null) {
				}
			}else{//企业号
				appid=systemParams.checkSystem("corpid", "");
				mch_id=systemParams.checkSystem("mch_id","");
			}
			Map<String,Object> mappay=new HashMap<>();
			mappay.put("appid",appid);
			mappay.put("mch_id",mch_id);
			mappay.put("out_trade_no", orderNo);
			mappay.put("nonce_str", nonce_str );
			String sign=Sign.sign(mappay,weixinType);
			StringBuffer params=new StringBuffer("<xml>");
			params.append("<appid>").append(appid).append("</appid>");
			params.append("<mch_id>").append(mch_id).append("</mch_id>");
			params.append("<nonce_str>").append(nonce_str).append("</nonce_str>");
			params.append("<out_trade_no>").append(orderNo).append("</out_trade_no>");
			params.append("<sign>").append(sign).append("</sign>");
			params.append("</xml>");
//			Timer timer = new Timer();
//	        timer.schedule(new TimerTask() {
//	            @Override  
//	            public void run() {
//                	this.cancel();
//                	System.gc();
//	            }  
//	        }, 1000, 3*1000);
	        String url="https://api.mch.weixin.qq.com/pay/orderquery";
			msg=wei.postxml(url, params.toString());
			LoggerUtils.info(msg);
			Map<String,Object> mapresult=readStringXmlOut(msg);
			if (!orderNo.toString().contains("NO")) {
				orderNo="NO."+orderNo;
			}
			JSONObject json=JSONObject.fromObject(mapresult);
			if("SUCCESS".equals(mapresult.get("trade_state"))){
				savePayInfo(request,map.get("orderNo"));
				File file=new File(getComIdPath(request)+"payinfo/success/"+orderNo+".log");
				saveFile(file, json.toString());
				success = true;
			}else{
				msg=json.toString();
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 微信支付收款记录生成
	 * @param map
	 * @param request
	 * @return
	 */
	private String savePayInfo(HttpServletRequest request,Object orderNo) {
		if (!orderNo.toString().contains("NO")) {
			orderNo="NO."+orderNo;
		}
		//1.从外部文件中获取订单seeds_id
		String seeds_id=getFileTextContent(getPayOrderInfo(request, orderNo));
		seeds_id=seeds_id.replace("[", "");
		seeds_id=seeds_id.replace("]", "");
		//2.获取订单信息
		String customer_id=getUpperCustomerId(request);
		Map<String,Object> map=new HashMap<>();
		map.put("com_id", getComId());
		map.put("customer_id", customer_id);
		Map<String,Object> order=customerService.getSimpleOrderPayInfo(map);
		//3.生成付款单数据
		Map<String,Object> fkdmap=new HashMap<>();
		Calendar c = Calendar.getInstance();
		fkdmap.put("com_id", getComId());
		fkdmap.put("finacial_y", c.get(Calendar.YEAR));
		fkdmap.put("finacial_m", c.get(Calendar.MONTH));
		fkdmap.put("finacial_d", getNow());
		fkdmap.put("recieved_direct", "收款");
		fkdmap.put("recieved_auto_id",orderNo);
		fkdmap.put("recieved_id", orderNo);
		fkdmap.put("customer_id",customer_id);
		fkdmap.put("recieve_type","微信支付");
		fkdmap.put("rcv_hw_no", "微信支付");
		if(isNotMapKeyNull(order, "sum_si")){
			fkdmap.put("sum_si", order.get("sum_si"));
		}else{
			fkdmap.put("sum_si",request.getParameter("total_fee"));
		}
		fkdmap.put("rejg_hw_no",seeds_id);
		fkdmap.put("comfirm_flag", "N");
		fkdmap.put("mainten_clerk_id", getCustomerId(request));
		fkdmap.put("mainten_datetime", getNow());
		return customerService.savePayInfo(fkdmap);
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("alipaySuccess")
	@ResponseBody
	public ResultInfo alipaySuccess(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=savePayInfo(request,map.get("orderNo"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 支付确认
	 * @param request
	 * @return
	 */
	@RequestMapping("alipayOK")
	@ResponseBody
	public ResultInfo alipayOK(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (map.get("orderNo")!=null&&map.get("orderNo")!="") {
				map.put("recieved_id","NO."+map.get("orderNo"));
				if(getCustomer(request)==null){
					//向运营商表写入金额和充值时间
					map.put("recharge_time", getNow());
					if(isMapKeyNull(map, "recharge_amount")){
						map.put("recharge_amount", 500);
					}
					String clerk_id=managerService.updateOperateOk(map);
					//把001的权限复制给该员工
					//////为该员工复制所有权限/////////
					StringBuffer filePath=new StringBuffer(getRealPath(request));
					filePath.append("/001/planquery/001/").append("authority.txt");
					File srcFile=new File(filePath.toString());
					filePath=new StringBuffer(getRealPath(request)).append(map.get("com_id"));
					filePath.append("/planquery/").append(clerk_id).append("/").append("authority.txt");
					File destFile=new File(filePath.toString());
					mkdirsDirectory(destFile);
					FileUtils.copyFile(srcFile, destFile);
					///向运营商发送已收到款项通知
					String touser=managerService.getComIdWeixinID(map.get("com_id")+"",1);
					List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
					Map<String,Object> mapMsg=new HashMap<String, Object>();
					mapMsg.put("title","运营商支付成功通知");
					String description="尊敬的客户,您的本次充值成功!";
					mapMsg.put("description",description);
					mapMsg.put("url",  ConfigFile.urlPrefix+"/employee.do");
					mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
					mapMsg.put("sendRen", "系统管理员");
					news.add(mapMsg);
					sendMessageNews(news, touser);
				}else{
					map.put("customer_id", getUpperCustomerId(request));
					msg=customerService.alipayOK(map);
				}
				success = true;
			}else{
				msg="没有收款单号!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 支付确认
	 * @param request
	 * @return
	 */
	@RequestMapping("alipayComplete")
	@ResponseBody
	public ResultInfo alipayComplete(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (map.get("orderNo")!=null&&map.get("orderNo")!="") {
				map.put("recieved_id","NO."+map.get("orderNo"));
				map.put("customer_id", getUpperCustomerId(request));
				msg=saiYuService.alipayComplete(map);
				success = true;
			}else{
				msg="没有收款单号!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 根据微信返回资源id获取图片
	 * @param request
	 * @return
	 */
	@RequestMapping("getWeixinFwqImg")
	@ResponseBody
	public ResultInfo getWeixinFwqImg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei=new WeixinUtil();
			String media_id=request.getParameter("url");
			Map<String,Object> map=getKeyAndValue(request);
			String url="https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token="+wei.getAccessToken(getComId())
					+"&media_id="+media_id;
			msg=getComId()+"/certificate/"+map.get("orderNo")+".jpg";
	        File destFile=new File(getRealPath(request)+msg);
	        mkdirsDirectory(destFile);
	        if (destFile.exists()&&destFile.isFile()) {
				destFile.delete();
			}
			wei.getDataImage(url,destFile);
			msg="../"+msg;
			if (isNotMapKeyNull(map, "headship")) {
				///向财务发送调整消息
				noticeCaiwu(map);
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/***
	 * 通知财务收款确认
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeConfirm")
	@ResponseBody
	public ResultInfo noticeConfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			noticeCaiwu(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 通知财务收款确认
	 * @param map
	 */
	private void noticeCaiwu(Map<String,Object> map) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		if (isNotMapKeyNull(map, "title")) {
			mapMsg.put("title",map.get("title"));
		}else{
			mapMsg.put("title","客户支付凭证上传提醒");
		}
		StringBuffer description=new StringBuffer(getComName());
		description.append("-").append(map.get("headship")).append("-@clerkName:客户【");
		description.append(getCustomer(getRequest()).get("clerk_name")).append("】提交了支付凭证,请进行客户收款确认操作，落实款项到账情况");
		description.append(",收款单号：").append(map.get("orderNo"));
		mapMsg.put("description",description);
		String url="/employee/collectionConfirm.do?recieved_id="+map.get("orderNo");
		if (StringUtils.isNotBlank(url)) {
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
		}
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
		mapMsg.put("sendRen", getCustomerId(getRequest()));
		news.add(mapMsg);
		boolean b=MapUtils.getString(map, "headship").toString().startsWith("%");
		if(!b){
			map.put("headship", "%"+map.get("headship")+"%");
		}
		List<Map<String,String>> list=employeeService.getPersonnelNeiQing(map);
		for (Map<String, String> item : list) {
			String msg=description.toString().replaceAll("@clerkName", item.get("clerk_name"));
			news.get(0).put("description",msg);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
			}
			news.get(0).put("description",description);
			
		}
	}
	
	/**
	 * 获取图片从微信服务器
	 * @param request
	 * @param url 微信端图片位置
	 * @param imgPath  图片存放位置
	 * @return 图片存放的位置
	 */
	@RequestMapping("getImageToWeixin")
	@ResponseBody
	public ResultInfo getImageToWeixin(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei=new WeixinUtil();
			String media_id=request.getParameter("url");
			String imgPath=request.getParameter("imgPath");
			if (StringUtils.isNotBlank(imgPath)) {
				if(imgPath.contains("@com_id")){
					imgPath=imgPath.replace("@com_id", getComId());
				}
				String url="https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token="+wei.getAccessToken(getComId())+"&media_id="+media_id;
				File destFile=new File(getRealPath(request)+imgPath);
				if (!destFile.getParentFile().exists()) {
					destFile.getParentFile().mkdirs();
				}
				wei.getDataImage(url,destFile);
				msg=imgPath;
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取订单支付结果
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderPayResults")
	@ResponseBody
	public ResultInfo getOrderPayResults(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			customerService.getOrderPayState(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取微信消息历史列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getWeixinMsglist")
	@ResponseBody
	public ResultInfo getWeixinMsglist(HttpServletRequest request) {
		String beginDate=request.getParameter("beginDate");
		String endDate=request.getParameter("endDate");
		if (StringUtils.isBlank(beginDate)) {
			beginDate=DateTimeUtils.dateToStr();
		}
		if (StringUtils.isBlank(endDate)) {
			endDate=DateTimeUtils.dateToStr();
		}
		beginDate=beginDate.replaceAll("-", "");
		endDate=endDate.replaceAll("-", "");
		Integer begin=Integer.parseInt(beginDate);
		Integer end=Integer.parseInt(endDate);
		String jsonmsg="";
		if(begin<end){
			for (int i = 0; i <( end-begin)+1; i++) {
				File file=new File(getComIdPath(request)+"weixinID/news/"+(begin+i)+".log");
				String context=getFileTextContent(file);
				if(context!=null){
					jsonmsg=jsonmsg+context;
				}
			}
		}else{
			File file=new File(getComIdPath(request)+"weixinID/news/"+begin+".log");
			jsonmsg=getFileTextContent(file);
		}
		Object weixinID=null;
		if(!"001".equals(getCustomerId(request))&&!"001".equals(getEmployeeId(request))){
			if(getCustomerId(request)!=null){
				weixinID=getCustomer(request).get("weixinID");
			}else if(getEmployeeId(request)!=null){
				weixinID=getEmployee(request).get("weixinID");
			}
		}
		if (StringUtils.isNotBlank(jsonmsg)) {
			JSONArray jsons= JSONArray.fromObject("["+jsonmsg+"]");
			JSONArray touser=new JSONArray();
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json =jsons.getJSONObject(i);
				if(json.getString("touser").equals(weixinID)){
					touser.add(json);
				}
			}
			sort(touser,"time",false);
			return new ResultInfo(true, touser.toString(),touser.size());
		}
		return null;
	}
	/**
	 * 
	 * @param ja json数组
	 * @param field 要排序的key
	 * @param isAsc 是否升序
	 */
	@SuppressWarnings("unchecked")
	private synchronized void sort(JSONArray ja,final String field, boolean isAsc){
	Collections.sort(ja, new Comparator<JSONObject>() {
	@Override
	public int compare(JSONObject o1, JSONObject o2) {
	Object f1 = o1.get(field);
	Object f2 = o2.get(field);
	if(f1!=null){
		f1=f1.toString().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "");
		f1=Long.parseLong(f1.toString());
	}
	if(f2!=null){
		f2=f2.toString().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "");
		f2=Long.parseLong(f2.toString());
	}
	if(f1 instanceof Number && f2 instanceof Number){
	return ((Number)f1).intValue() - ((Number)f2).intValue();
	}else{
	return f1.toString().compareTo(f2.toString());
	}
	}
	});
	if(!isAsc){
	Collections.reverse(ja);
	}
	}
	/**
	 *  获取接收人和发送人名称
	 * @param request
	 * @return 
	 */
	@RequestMapping("getMembersInfo")
	@ResponseBody
	public Map<String,Object> getMembersInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return customerService.getMembersInfo(map);
	}
	/**
	 * 保存支付凭证图片
	 * @param request
	 * @return
	 */
	@RequestMapping("certificateImg")
	@ResponseBody
	public ResultInfo certificateImg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String orderNo=request.getParameter("orderNo");
			String imgurl=request.getParameter("imgurl");
			if (StringUtils.isNotBlank(imgurl)) {
				File srcFile=new File(getRealPath(request)+imgurl); 
				if (srcFile.exists()) {
					msg=getComId()+"/certificate/"+orderNo+".jpg";
			        File destFile=new File(getRealPath(request)+msg);
					mkdirsDirectory(destFile);
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					FileUtils.moveFile(srcFile, destFile);
					success = true;
					msg="../"+msg;
					Map<String,Object> map=getKeyAndValue(request);
					if (isNotMapKeyNull(map, "headship")) {
						noticeCaiwu(map);
					}
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 向指定客户提交提成金额
	 * @param request
	 * @return
	 */
	@RequestMapping("payCommission")
	@ResponseBody
	public ResultInfo payCommission(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			msg=payCommission(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 
	 * @param sum_si
	 * @param &wishing=感谢您参加祝您快乐！
	 * @param &act_name=猜灯谜抢红包活动
	 * @param &remark=猜越多得越多，快来抢！
	 * @return
	 */
	public String payCommission(Map<String, Object> map) {
		//1.获取客户的weixinid
//		Map<String,Object> mapcus=customerService.getCustomerWeixinID(map);
		//2.调用微信发送红包转账接口
		WeixinUtil wei=new WeixinUtil();
		Map<String,Object> parammap=new HashMap<String, Object>();
		String nonce_str=UUID.randomUUID().toString().substring(0, 8);
		parammap.put("nonce_str", nonce_str);
		
		String weixinType=systemParams.checkSystem("weixinType", "0");
		String appid=null;
		String mch_id=null;
		if("0".equals(weixinType)){//服务号
			appid=systemParams.checkSystem("appid_service","");
			mch_id=systemParams.checkSystem("mch_id_service","");
		}else{//企业号
			appid=systemParams.checkSystem("corpid", "");
			mch_id=systemParams.checkSystem("mch_id","");
		}
		
		String mch_billno= mch_id+DateTimeUtils.getNowDateTimeS()+"1";
		
		parammap.put("mch_billno",mch_billno);
		parammap.put("mch_id", mch_id);
		parammap.put("wxappid", appid);
//		parammap.put("send_name", getComName());
		parammap.put("send_name", "牵引互联");
//		String openid=wei.useridToOpenid(mapcus.get("weixinID")+"");//
		String openid=wei.useridToOpenid("dvdq",getComId());//
		parammap.put("re_openid", openid);
		parammap.put("total_amount", map.get("sum_si"));
		parammap.put("total_num", 1);
		parammap.put("wishing", map.get("wishing"));
		parammap.put("client_ip","");
		parammap.put("act_name", map.get("act_name"));
		parammap.put("remark", map.get("remark"));
		String sign=Sign.sign(parammap,weixinType);
		StringBuffer params=new StringBuffer("<xml>");
		params.append("<sign>").append(sign).append("</sign>");
		params.append("<mch_billno>").append(mch_billno).append("</mch_billno>");
		params.append("<mch_id>").append(mch_id).append("</mch_id>");
		params.append("<wxappid>").append(appid).append("</wxappid>");
		params.append("<send_name>").append("牵引互联").append("</send_name>");
		params.append("<re_openid>").append(openid).append("</re_openid>");
		params.append("<total_amount>").append(map.get("sum_si")).append("</total_amount>");
		params.append("<total_num>1</total_num>");
		params.append("<wishing>").append(map.get("wishing")).append("</wishing>");
		params.append("<client_ip>").append(ConfigFile.LocalIP).append("</client_ip>");
//		params.append("<client_ip>10.18.0.118</client_ip>");
		params.append("<act_name>").append(map.get("act_name")).append("</act_name>");
		params.append("<remark>").append(map.get("remark")).append("</remark>");
		params.append("<nonce_str>").append(nonce_str).append("</nonce_str>");
		params.append("</xml>");
		String msg=wei.postxml("https://api.mch.weixin.qq.com/mmpaymkttransfers/sendredpack", params.toString());
		Map<String,Object> mapresult=new HashMap<String, Object>();
		mapresult=readStringXmlOut(msg);
		if(isNotMapKeyNull(mapresult, "result_code")){
			if("SUCCESS".equals(mapresult.get("result_code"))){
				//3.成功后将客户所对应的订单全部更新为m_flag=1
			}
		}
		return null;
	}
	/**
	 * 从微信企业号中获取指定部门
	 * @param request
	 * @return
	 */
	@RequestMapping("getDeptList")
	@ResponseBody
	public ResultInfo getDeptList(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei=new WeixinUtil();
			Object agentDeptId=systemParams.checkSystem("agentDeptId");
        	wei.saveDeptList(getComId(),agentDeptId);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
//	/**
//	 * 获取微信状态
//	 * */
//	@Scheduled(fixedRate = 1000*60*60*2)
//	@Scheduled(cron = "0 0/90 8-19 * * ?")
//	public void getWeixinState() {
//		managerService.updateWeixinState();
//	}
	/**
	 * 保存微信服务号模板
	 * @param request
	 * @return
	 */
	@RequestMapping("saveTemplate")
	@ResponseBody
	public JSONArray saveTemplate(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return managerService.saveWeixinTemplateMessageInfo(map);
	}
	/**
	 *  获取微信服务号中的用户列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getUserInfoList")
	@ResponseBody
	public JSONObject getUserInfoList(HttpServletRequest request) {
		return new WeiXinServiceUtil().getUserInfoList(getComId());
	}
	
	/**
	 *  获取微信企业号用户信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getUserInfo")
	@ResponseBody
	public JSONObject getUserInfo(HttpServletRequest request) {
		WeixinUtil wei=new WeixinUtil();
		String id=request.getParameter("id");
		if (StringUtils.isBlank(id)) {
			if (getEmployee(request)!=null) {
				id=getEmployee(request).get("weixinID")+"";
			}else if(getCustomer(request)!=null){
				id=getCustomer(request).get("weixinID")+"";
			}else{
				return null;
			}
		}
		String msg=wei.getEmployeeInfo(id, getComId());
		if (StringUtils.isNotBlank(msg)) {
			return JSONObject.fromObject(msg);
		}
		return null;
	}
	
	/**
	 *  获取微信企业号用户头像
	 * @param request
	 * @return
	 */
	@RequestMapping("getUserImg")
	@ResponseBody
	public String getUserImg(HttpServletRequest request) {
		WeixinUtil wei=new WeixinUtil();
		String id=request.getParameter("id");
		if (StringUtils.isBlank(id)) {
			if (getEmployee(request)!=null) {
				id=getEmployee(request).get("weixinID")+"";
			}else if(getCustomer(request)!=null){
				id=getCustomer(request).get("weixinID")+"";
			}else{
				return "";
			}
		}
		String msg=wei.getEmployeeInfo(id, getComId());
		if (StringUtils.isNotBlank(msg)) {
			JSONObject json= JSONObject.fromObject(msg);
			if (json.has("avatar")) {
				return json.getString("avatar");
			}
		}
		return "";
	}

	/**
	 * 使用企业号群发图文消息
	 * @param request
	 * @param touser 接收消息的用户,以"|"分隔
	 * @param agentName 发送的应用对应角色,员工,客户,供应商,司机,其它
	 * @param articleList 文章标题+文章内容+文章图片+文章路径json数组{"title":title,"description":description,"url":url,"imgName":imgName}
	 * @return 发送结果
	 */
	@RequestMapping("sendArticles")
	@ResponseBody
	public ResultInfo sendArticles(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String receiverInfo=request.getParameter("receiverInfo");
			String articleList=request.getParameter("articleList");
			if (StringUtils.isNotBlank(articleList)&&articleList.startsWith("[")&&articleList.endsWith("]")) {
				articleList=articleList.replaceAll("@com_id", getComId());
				articleList=articleList.replaceAll("@clerk_id", getEmployeeId(request));
				articleList=articleList.replaceAll("@urlPrefix", ConfigFile.urlPrefix);
				JSONArray jsons=JSONArray.fromObject(articleList);
				JSONArray articles = new JSONArray();
				for (int i = 0; i < jsons.size(); i++) {
					if (i>8) {
						break;
					}
					JSONObject json=jsons.getJSONObject(i);				
					JSONObject article = new JSONObject();
					article.put("title", json.get("title"));
					article.put("description", json.get("description"));
					article.put("url", ConfigFile.urlPrefix+json.get("url"));
					if(getEmployee(getRequest())!=null){
						article.put("sendRen", getEmployeeId(getRequest()));
					}
					if (json.has("imgName")) {
						article.put("picurl",  ConfigFile.urlPrefix+json.get("imgName"));
					}else{
						article.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
					}
					articles.add(article);
				}
				if (StringUtils.isNotBlank(receiverInfo)) {
					JSONObject receiver=JSONObject.fromObject(receiverInfo);
					receiver.put("time", getNow());
					receiver.put("data", articleList);
					receiver.put("publisher", getEmployee(request).get("clerk_name"));
					String weixinType=request.getParameter("weixinType");
					String all=request.getParameter("all");
					if(StringUtils.isBlank(weixinType)){
						weixinType=systemParams.checkSystem("weixinType", "0");
					}
					StringBuffer errorinfo=new StringBuffer();
					Map<String,String> info=WeixinUtil.getErrorMsg(); 
					if(weixinType.contains("0")){//服务号
						WeiXinServiceUtil ws=new WeiXinServiceUtil();
//						if ("true".equals(all)) {
//							ws.sendMessagenewsAll(articles, getComId());
//						}else{
//						}
						if(receiver.has("customerId")){
							msg=sendWeixinServiceMsg(articles, receiver.getString("customerId"), ws,errorinfo,"sdf00504",info);
							receiver.put("clientRet", msg);
						}
						if(receiver.has("clerkId")){
							msg=sendWeixinServiceMsg(articles, receiver.getString("clerkId"), ws,errorinfo,"ctl00801",info);
							receiver.put("employeeServiceRet", msg);
						}
						if(receiver.has("corpId")){
							msg=sendWeixinServiceMsg(articles, receiver.getString("corpId"), ws,errorinfo,"ctl00504",info);
							receiver.put("gysServiceRet", msg);
						}
					}
					if(weixinType.contains("1")){//企业号
						WeixinUtil wei=new WeixinUtil();
						if ("true".equals(all)) {
							wei.sendMessagenewsAll(articles, getComId());
						}else{							
							if (receiver.has("clientid")) {
								String[] ws= receiver.getString("clientid").split("\\|");
								if(ws.length>0){
									for (String id : ws) {
										if(StringUtils.isNotBlank(id)){
											msg=wei.sendMessagenews2(articles, getComId(), id,receiver.getString("clientType"));
											receiver.put("clientRet",msg);
										}
									}
								}
							}
							if (receiver.has("employeeid")) {
								String[] ws= receiver.getString("employeeid").split("\\|");
								if(ws.length>0){
									for (String id : ws) {
										if(StringUtils.isNotBlank(id)){
											msg=wei.sendMessagenews2(articles, getComId(),id,receiver.getString("employeeType"));
											receiver.put("employeeRet",msg);
										}
									}
								}
							}
							if (receiver.has("gysid")) {
								String[] ws= receiver.getString("gysid").split("\\|");
								if(ws.length>0){
									for (String id : ws) {
										if(StringUtils.isNotBlank(id)){
											msg=wei.sendMessagenews2(articles, getComId(),id,receiver.getString("gysType"));
											receiver.put("gysRet",msg);
										}
									}
								}
							}
						}
					}
					if(weixinType.contains("2")){//短信
						
					}
					Long date=DateTimeUtils.strToDateTime(getNow()).getTime();
					saveFile(getArticleSendHistoryPath(request, getEmployeeId(request), date), ","+receiver.toString(),true);
					if(errorinfo.length()==0){
						success=true;
					}
					msg=errorinfo.toString();
				}else{
					msg="参数错误,接收者不明确!";
				}
			}else {
				msg="没有获取到待发送图文消息数据!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	private String sendWeixinServiceMsg(JSONArray articles, String id,
			WeiXinServiceUtil ws, StringBuffer errorinfo,String table,Map<String,String> info) {
		List<Map<String,String>> list=managerService.getOpenidById(id,getComId(),table);
//		StringBuffer error=new StringBuffer();
		if(list!=null&&list.size()>0){
			for (Map<String, String> map : list) {
				if (StringUtils.isNotBlank(map.get("openid"))) {
					JSONObject json=ws.customSendNews(getComId(), map.get("openid"), articles);
					if(json.has("errcode")){
						if(!"0".equals(json.getString("errcode"))){
							errorinfo.append("【").append(map.get("name")).append("】服务号发送失败,").append(info.get(json.getString("errcode")));
						}
					}
				}else{
					errorinfo.append("【").append(map.get("name")).append("】服务号发送失败没有openid!");
				}
			}
		}
		return errorinfo.toString();
	}
	/**
	 * 更新微信状态,获取用户数据后获取微信企业号中的状态.
	 * @param request
	 * @return
	 */
	@RequestMapping("updateWeixinState")
	@ResponseBody
	public ResultInfo updateWeixinState(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isNotMapKeyNull(map, "type")) {
				if ("employee".equals(map.get("type"))) {
					map.put("table", "ctl00801");
				}else if("client".equals(map.get("type"))){
					map.put("table", "sdf00504");
				}else if("gys".equals(map.get("type"))){
					map.put("table", "ctl00504");
				}else if("drive".equals(map.get("type"))){
					map.put("table", "sdf00504_saiyu");
				}
			}
			msg=managerService.updateWeixinState(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
}