package com.qianying.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.PageList;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.ISaiYuService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.InitConfig;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5Util;
import com.qianying.util.WeixinUtil;
import com.sun.mail.imap.protocol.Item;

@Controller
@RequestMapping("/saiyu")
public class SaiYuController extends FilePathController {
 
	@Autowired
	private ISaiYuService saiYuService;
	@Autowired
	private ICustomerService customerService;
	@Autowired
	private IEmployeeService employeeService;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private ISystemParamsService systemParams;
	/**
	 *  跳转到用户个人中心
	 * @param request
	 * @return 检测用户的微信号是否绑定成功,如果失败就跳转到微信绑定页面,成功就调整到个人中心页面
	 */
	@RequestMapping("personalCenter")
	public String personalCenter(HttpServletRequest request) {
		if (getCustomer(request)==null) {
			return "redirect:../pc/login.html";
		}
		if(getCustomer(request).get("corp_id")!=null){
			return "redirect: /supplier/supplier.do";
		}
		if (getCustomer(request)!=null&&!getCustomerId(request).startsWith("C")) {
			return "redirect:../pc/login.html";
		}
		String url=tourl(request);
		if (url!=null) {
			return url;
		}
		if("消费者".equals(getCustomer(request).get("ditch_type"))){
			return "redirect:/customer.do";
		}
//		if (!"001".equals(getCustomerId(request))) {
//			WeixinUtil wei=new WeixinUtil();
//			String resultmsg=wei.getEmployeeInfo(getCustomer(request).get("weixinID")+"");
//			if (StringUtils.isNotBlank(resultmsg)) {
//				JSONObject json=JSONObject.fromObject(resultmsg);
//				String weixinid=json.getString("weixinid");
//				if (StringUtils.isBlank(weixinid)) {//当没有检测到微信的时候在个人中心里面提示
//					request.setAttribute("weixin", "../pc/addWeixin.html?"+getCustomer(request).get("user_id"));
//				}
//			}
//		}
		request.setAttribute("headship", getCustomer(request).get("headship"));
		return "pc/saiyu/personalCenter";
	}
	/**
	 *  个人资料
	 * @param request
	 * @return
	 */
	@RequestMapping("personalData")
	public String personalData(HttpServletRequest request) {
		request.setAttribute("client", customerService.getCustomerByCustomer_id(getCustomerId(request),getComId(request)));
		return "pc/saiyu/personalData";
	}
	/**
	 *  审批流程定义
	 * @param request
	 * @return
	 */
	@RequestMapping("approvalDefinition")
	public String approvalDefinition(HttpServletRequest request) {
		return "pc/saiyu/approvalDefinition";
	}
	/**
	 *  客户定义审批流程
	 * @param request
	 * @return
	 */
	@RequestMapping("clientDefineApproval")
	public String clientDefineApproval(HttpServletRequest request) {
		request.setAttribute("upper_customer_id", getUpperCustomerId(request));
		return "pc/saiyu/clientDefineApproval";
	}
	/**
	 * 增加客户审批流程对话框
	 * @return
	 */
	@RequestMapping("clientProcessModal")
	public String clientProcessModal() {
		return "pc/saiyu/clientProcessModal";
	}
	
	/**
	 *  获取订单信息,审批信息,报修单信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getSaiyuOAInfo")
	@ResponseBody
	public Map<String, Object> getSaiyuOAInfo(HttpServletRequest request) {
		//  获取订单信息,审批信息,报修单信息
		Map<String, Object> map = getKeyAndValueQuery(request);
		if (map.get("spNo")!=null) {
			//获取订单编号
			Map<String,Object> mapno=saiYuService.getOrderNoToApprovalInfo(map);
			String no=mapno.get("OA_what").toString();
			if (no.split("单号:").length>1) {
				if(no.split(",").length>1){
					 if(no.split(",")[0].contains("单号:")){
						 map.put("ivt_oper_listing", no.split(",")[0].split("单号:")[1]);
					 }else{
						 map.put("ivt_oper_listing", no.split(",")[1].split("单号:")[1]);
					 }
				}else{
					map.put("ivt_oper_listing", no.split("单号:")[1]);
				}
			}else{
				map.put("ivt_oper_listing",no.split("单号:")[0]);
			}
			//传入订单编号
			Map<String,Object> mapinfo=new HashMap<String, Object>();
			String sumSi=saiYuService.getOrderSumsi(map);
			mapinfo.put("sumSi", sumSi);
			mapinfo.put("approval_step", mapno.get("approval_step"));
			return mapinfo;
		}else if(map.get("orderNo")!=null){
			//传入订单编号
			Map<String,Object> mapinfo=new HashMap<String, Object>();
			map.put("ivt_oper_listing", map.get("orderNo"));
			String sumSi=saiYuService.getOrderSumsi(map);
			mapinfo.put("sumSi", sumSi); 
			return mapinfo;
		}else{
			//1.获取审批信息
			Map<String, Object> mapinfo = employeeService.getOAInfo(map,getComIdPath(request));
			Map<String,Object> mapparam=new HashMap<String, Object>();
			mapparam.put("com_id", getComId());
			if (mapinfo.get("OA_what").toString().split("单号:").length>1) {
				mapparam.put("ivt_oper_listing", mapinfo.get("OA_what").toString().split("单号:")[1]);
			}else{
				mapparam.put("ivt_oper_listing", mapinfo.get("content").toString().split("单号:")[0]);
			}
			mapparam.put("customer_id", getUpperCustomerId(request));
			List<Map<String,Object>> list=null;
			if ("order".equals(map.get("type"))) {
				mapparam.put("ivt_oper_listing", mapparam.get("ivt_oper_listing").toString().replaceAll("\\[", ""));
				mapparam.put("ivt_oper_listing", mapparam.get("ivt_oper_listing").toString().replaceAll("\\]", ""));
				mapinfo.put("ivt_oper_listing", mapparam.get("ivt_oper_listing"));
				if(!mapinfo.get("ivt_oper_listing").toString().contains("XSKD")){
					mapinfo.put("ivt_oper_listing", map.get("orderNo"));
				}
				String sumSi=saiYuService.getOrderSumsi(mapparam);
				mapinfo.put("sumSi", sumSi);
//		    list=saiYuService.getOrderList(mapparam);
			}else{
				list=saiYuService.getSuggest(mapparam);
			}
			mapinfo.put("list", list);
			mapinfo.remove("OA_what");
			return mapinfo;
		}
	}
	
	
	/**
	 * 保存
	 * @param request
	 * @return
	 */
	@RequestMapping("saveApprovalDefinition")
	@ResponseBody
	public ResultInfo saveApprovalDefinition(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {

			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取客户内部员工显示权限
	 * @param request 
	 * 
	 */
	private void getAutr(HttpServletRequest request){
		if (getUpperCustomerId(request)!=null) {
			Object headship= getCustomer(request).get("headship");
			int autr=0;
			if (headship!=null) {
				if (headship.toString().contains("采购")) {
					autr=2;
				}else if(headship.toString().contains("财务")){
					autr=2;
				}else if(headship.toString().contains("出纳")){
					autr=2;
				}else if(headship.toString().contains("经理")){
					autr=2;
				}else if(headship.toString().contains("工程")){
					autr=1;
				}else{
				}
			} else {
			}
			request.setAttribute("headship", getCustomer(request).get("headship"));
			request.setAttribute("autr", autr);
			request.setAttribute("colum", 3);
		}else{
			request.setAttribute("autr", 10);
			request.setAttribute("colum", 5);
		}
	}
	
	/**
	 *  获取体检表tbody部分
	 * @param request
	 * @return
	 */
	@RequestMapping("tijiantbody")
	public String tijiantbody(HttpServletRequest request) {
		getAutr(request);
		String repair=request.getParameter("repair");
		String autr= request.getParameter("autr");
		if(StringUtils.isNotBlank(autr)){
			request.setAttribute("autr", autr);
		}
		if(StringUtils.isNotBlank(repair)){
			request.setAttribute("autr", 0);
		}
		return "pc/saiyu/tijiantbody";
	}
	/**
	 *  上报维修
	 * @param request
	 * @return
	 */
	@RequestMapping("repair")
	public String repair(HttpServletRequest request) {
		request.setAttribute("customer_id", getUpperCustomerId(request));
		String spNo=request.getParameter("spNo");
		if(StringUtils.isBlank(spNo)){
			spNo=request.getParameter("ivt_oper_listing");
		}
		request.setAttribute("spNo", spNo);
		getAutr(request);
		if(StringUtils.isNotBlank(spNo)){
			request.setAttribute("autr", 1);
		}else{
			Object headship= getCustomer(request).get("headship");
			if(headship!=null&&headship.toString().contains("工程")){
				request.setAttribute("autr", 1);
			}else{
				request.setAttribute("autr", 0);
			}
		}
		String approval_step= request.getParameter("approval_step");
		request.setAttribute("approval_step", approval_step);
		request.setAttribute("headship", getCustomer(request).get("headship"));
		request.setAttribute("colum", 2);
		return "pc/saiyu/repair";
	}

	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("newRepair")
	public String newRepair(HttpServletRequest request) {
		return "pc/saiyu/newRepair";
	}
	/**
	 * 用户增加保修
	 * @param request
	 * @return
	 */
	@RequestMapping("addRepair")
	@ResponseBody
	public ResultInfo addRepair(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] list=request.getParameterValues("list[]");
			if(list!=null&&list.length>0){
				Map<String,Object> map=getKeyAndValue(request);
				if (getUpperCustomerId(request)!=null) {
					map.put("upper_customer_id", getUpperCustomerId(request));
					saiYuService.addRepair(map,list);
					success = true;
				}else{
					msg="登录超时请重新登录!";
				}
			}else{
				msg="没有找到保修信息";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 报修确认
	 * @param request
	 * @return
	 */
	@RequestMapping("repairConfim")
	@ResponseBody
	public ResultInfo repairConfim(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			String[] list=request.getParameterValues("list[]");
			if(list!=null&&list.length>0){
				map.put("upper_customer_id", getUpperCustomerId(request));
				saiYuService.repairConfim(map,list);
				success = true;
			}else{
				msg="没有找到保修信息";
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 员工推荐采购保存
	 * @param request
	 * @return
	 */
	@RequestMapping("qrtjProduct")
	@ResponseBody
	public ResultInfo qrtjProduct(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] infolist=request.getParameterValues("infolist[]");
			if (infolist!=null&&infolist.length>0) {
				Map<String,Object> map=getKeyAndValue(request);
//				map.put("upper_customer_id", getUpperCustomerId(request));
				map.remove("seeds_id");
				saiYuService.qrtjProduct(infolist,map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	} 
	/**
	 * 保存采购订单
	 * @param request
	 * @return
	 */
	@RequestMapping("savePurchaseOrder")
	@ResponseBody
	public ResultInfo savePurchaseOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			String[] list=request.getParameterValues("list[]");
			if(list!=null&&list.length>0&&map.get("spNo")!=null){
				map.put("upper_customer_id", getUpperCustomerId(request));
				map.put("spyj", "同意");
				msg=saiYuService.savePurchaseOrder(map,list);
				success = true;
			}else{
				msg="提交数据不全!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	////////////////////////////////////////
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("repairApproval")
	public String repairApproval(HttpServletRequest request) {
		String date=request.getParameter("date");
		//1.从
		File path=getRepairLogPath(request, date);
		String content=getFileTextContent(path);
		request.setAttribute(content, content);//
		return "pc/saiyu/repairApproval";
	}
	
	
	/**
	 *  获取位置大类
	 * @param request
	 * @param position 小类
	 * @param upper_customer_id 上级客户编码
	 * @return
	 */
	@RequestMapping("getPosition")
	@ResponseBody
	public List<Map<String,Object>> getPosition(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (getUpperCustomerId(request)!=null) {
			map.put("customer_id", getUpperCustomerId(request));
		}
		return saiYuService.getPosition(map);
	}
	/**
	 * 获取品牌
	 * @param request
	 * @param position_big 大类
	 * @param position 小类
	 * @param upper_customer_id 上级客户编码
	 * @return 
	 */
	@RequestMapping("getItemBrand")
	@ResponseBody
	public List<Map<String,Object>> getItemBrand(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		return saiYuService.getItemBrand(map);
	}
	/**
	 * 报修人提交报修信息
	 * @param request
	 * @return
	 */
	@RequestMapping("postRepair")
	@ResponseBody
	public ResultInfo postRepair(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//第一步报修人初步报修
			///获取客户审批第一步人员或者职位对应的人员
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getCustomerId(request));
			map.put("customer_name", getCustomer(request).get("clerk_name"));
			saveFile(getRepairLogPath(request,DateTimeUtils.dateToStr()).getPath(), map.toString(),true);
			String ivs=saiYuService.postRepair(map);
			msg=sendApprovalOA(request, map, 1,"repair",map.get("position_big")+"|"+map.get("position")+"|"+DateTimeUtils.dateToStr()+"|"+ivs);
			///保存照明报修生成的图片
			Object typeImg=map.get("typeImg");
			Object positionImg=map.get("positionImg");
			if (typeImg!=null) {
				File destFile= getRepairImgPath(request,FilenameUtils.getName(typeImg+""),"typeImg");
				File srcFile=new File(getRealPath(request)+positionImg);
				FileUtils.moveFile(srcFile, destFile);
			}
			if (positionImg!=null) {
				File destFile= getRepairImgPath(request,FilenameUtils.getName(positionImg+""),"positionImg");
				File srcFile=new File(getRealPath(request)+positionImg);
				FileUtils.moveFile(srcFile, destFile);
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 保存报修信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveRepair")
	@ResponseBody
	public ResultInfo saveRepair(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			String items[]=request.getParameterValues("items[]");
			if(items!=null&&items.length>0){
					map.put("items",items);
				// 第二步工程部上报具体报修消息
				if ("不同意".equals(map.get("spyij"))){//工程部不同意//原因:维修后正常,不需要更换
					saveFile(getRepairLogPath(request, map.get("date").toString()).getPath(), map.toString(), true);
				}else{
					saiYuService.saveRepair(map);
				}
				success = true;
				JSONArray array=JSONArray.fromObject(map.get("items"));
				///保存照明报修生成的图片
				for (int i = 0; i < array.size(); i++) {
					JSONObject json=array.getJSONObject(i);
					if (json.has("")) {
						String positionImg=json.getString("positionImg");
						if (positionImg!=null) {
							File destFile= getRepairImgPath(request,FilenameUtils.getName(positionImg),"positionImg");
							File srcFile=new File(getRealPath(request)+positionImg);
							FileUtils.moveFile(srcFile, destFile);
						}
					}
					if (json.has("typeImg")) {
						String typeImg=json.getString("typeImg");
						if (typeImg!=null) {
							File destFile= getRepairImgPath(request,FilenameUtils.getName(typeImg),"typeImg");
							File srcFile=new File(getRealPath(request)+typeImg);
							FileUtils.moveFile(srcFile, destFile);
						}
					}
					if (json.has("date")) {
						File srcFile=getRepairLogPath(request,json.getString("date"));
						File destFile=getRepairHistoryPath(request,json.getString("date"),"history");
						FileUtils.moveFile(srcFile, destFile);
					}
				}
			}else{
				msg="请选择具体位置";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取客户历史报修信息文件
	 * @param request
	 * @param date
	 * @param type history 查看历史记录
	 * @return
	 */
	private File getRepairHistoryPath(HttpServletRequest request, String date,String type) {
		StringBuffer path=new StringBuffer(getComIdPath(request));
		 path.append(getUpperCustomerId(request)).append("/");
		 if (StringUtils.isNotBlank(type)) {
			 path.append(type).append("/");
		}
		 path.append(date).append("_repair.log");
		 File file=new File(path.toString());
		 if (!file.getParentFile().exists()) {
			 file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 获取照明报修时的图片
	 * @param request
	 * @param name 文件名
	 * @param type 文件类型
	 * @return 
	 */
	private File getRepairImgPath(HttpServletRequest request,String name,String type) {
		 StringBuffer buffer=new StringBuffer(getComIdPath(request));
		 buffer.append(type).append("/").append(getUpperCustomerId(request)).append("/").append(name);
		 File file=new File(buffer.toString());
		 if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 获取报修历史日志文件
	 * @param request
	 * @param date
	 * @return
	 */
	private File getRepairLogPath(HttpServletRequest request,String date) {
		return getRepairHistoryPath(request, date, null);
	}
	/**
	 * 发送审批协同OA记录
	 * @param request
	 * @param map
	 * @param step 审批步骤
	 * @param url 跳转地址
	 * @param params
	 */
	private String sendApprovalOA(HttpServletRequest request, Map<String,Object> map,Integer step,String url,String params) {
		//1.获取客户审批第一步人员微信id
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("com_id", getComId());
		mapparam.put("upper_customer_id", getUpperCustomerId(request));
		mapparam.put("approval_step",step);
		Map<String,String> personInfo= saiYuService.getApprovalPerson(mapparam);
		if (personInfo==null) {
			return "没有找到该流程步骤对应的信息";
		}
		//2.获取组合标题title 否 标题description 否 描述url 否 点击后跳转的链接。
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> newmap=new HashMap<String, Object>();
		newmap.put("title","您有一条报修申请需要协同!");
		newmap.put("description", map.get("position_big")+""+map.get("position"));
		newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/"+url+".do?"+utf8to16(params));
		news.add(newmap);
		sendMessageNews(news, personInfo.get("weixinID"));	
		return null;
	}
	///////赛宇内部操作beign--推荐购买产品///////
	/**
	 *  推荐产品
	 * @param request
	 * @return
	 */
	@RequestMapping("suggest")
	public String suggest(HttpServletRequest request) {
		return "pc/saiyu/suggest";
	}
	/**
	 *  获取报修信息  赛宇员工操作入口
	 * @param request
	 * @param no 报修单号
	 * @return
	 */
	@RequestMapping("getRepairInfo")
	@ResponseBody
	public Map<String,Object> getRepairInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return saiYuService.getRepairInfo(map);
	}
	
	/**
	 * 获取产品的部分字段信息,逐级缩小查询范围  与产品接口中的getOneProductFiledList组合使用获取类型
	 * @param name item_color
	 * @param type_id 
	 * @param class_card 
	 * @param item_type 
	 * @return 返回对应数据和产品id
	 */
	@RequestMapping("getProductOneFiledlist")
	@ResponseBody
	public List<Map<String,String>> getProductOneFiledlist(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return saiYuService.getProductOneFiledlist(map);
	}
	/**
	 * 保存推荐产品
	 * @param request
	 * @param ivt_oper_listing 报修单号
	 * @param item_ids 产品id集合{"item_id":"CP0001","num":12,"sd_unit_price":12.12}
	 * @return
	 */
	@RequestMapping("saveSuggest")
	@ResponseBody
	public ResultInfo saveSuggest(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			// 第三步赛宇根据报修消息,推荐客户购买产品类型和数量
			///根据产品的id
			Map<String,Object> map=getKeyAndValue(request);
			if (map.get("bxNo")!=null) {
				String[] item_ids=request.getParameterValues("item_ids[]");
				if (item_ids!=null) {
					JSONArray json=JSONArray.fromObject(item_ids);
					map.put("spyj", "同意");
					saiYuService.saveSuggest(json,map);
					success = true;
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	////////////////////////////////
	/**
	 * 取消推荐产品
	 * @param request
	 * @return
	 */
	@RequestMapping("quxiaoProduct")
	@ResponseBody
	public ResultInfo quxiaoProduct(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			saiYuService.quxiaoProduct(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	///////////////////////赛宇内部操作end///////////
	/**
	 *  维修历史
	 * @param request
	 * @return
	 */
	@RequestMapping("repairHistory")
	public String repairHistory(HttpServletRequest request) {
		
		return "pc/saiyu/repairHistory";
	}
	
	/**
	 *  获取维修历史记录
	 * @param request
	 * @return
	 */
	@RequestMapping("getRepairHistory")
	@ResponseBody
	public PageList<Map<String,Object>> getRepairHistory(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("customer_id", getUpperCustomerId(request));
		return saiYuService.getRepairHistory(map);
	}
	/**
	 *  历史采购
	 * @param request
	 * @return
	 */
	@RequestMapping("historicalPurchase")
	public String historicalPurchase(HttpServletRequest request) {
		
		request.setAttribute("processName",getProcessNameNew(request));
		return "pc/saiyu/myOrder";
	}
	
	/**
	 *  获取采购历史记录--已下订单记录     customer/orderTrackingRecord.do
	 * @param request
	 */ 
	
	/**
	 * 客户对账单
	 * @param request
	 * @return
	 */
	@RequestMapping("accountStatement")
	public String accountStatement(HttpServletRequest request) {
		return "pc/saiyu/accountStatement";
	}
	/**
	 *  采购审批 
	 * @param request
	 * @return
	 */
	@RequestMapping("purchaseApproval")
	public String purchaseApproval(HttpServletRequest request) {
		Object headship=getCustomer(request).get("headship");
		String seeds_id=request.getParameter("seeds_id");
		request.setAttribute("seeds_id", seeds_id);
		String spNo=request.getParameter("spNo");
		if(StringUtils.isBlank(spNo)){
			spNo=request.getParameter("ivt_oper_listing");
		}
		request.setAttribute("spNo",spNo);
		request.setAttribute("upper_customer_id", getUpperCustomerId(request));
		getAutr(request);
		request.setAttribute("autr", 2);
		String approval_step= request.getParameter("approval_step");
		request.setAttribute("approval_step", approval_step);
		if (headship!=null) {///第四步
			if (headship.toString().contains("采购")) {
				return "pc/saiyu/purchaseApproval";
			}
		}
		return "pc/saiyu/purchaseApproval";
	}
	
	/**
	 *  我的协同页面
	 * @param request
	 * @return
	 */
	@RequestMapping("myOA")
	public String myOA(HttpServletRequest request) {
		return "pc/saiyu/myOA";
	}
	/**
	 *  付款信息页面
	 * @param request
	 * @return
	 */
	@RequestMapping("paymentInfo")
	public String paymentInfo(HttpServletRequest request) {
		return "pc/saiyu/paymentInfo";
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("edspalready")
	public String edspalready(HttpServletRequest request) {
		request.setAttribute("ivt_oper_listing", request.getParameter("ivt_oper_listing"));
		return "pc/saiyu/edspalready";
	}
	
	/**
	 * 获取客户员工自己的待办事项列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getOAList")
	@ResponseBody
	public PageList<Map<String, Object>> getOAList(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		map.put("clerk_id", getCustomerId(request));
		if (map.get("page") == null) {
			map.put("page", 1);
		}
		if (map.get("rows") == null) {
			map.put("rows", 10);
		}
		if (map.get("item_name") != null) {
			map.put("item_name", "%" + map.get("item_name") + "%");
		}
		if (map.get("OA_who") != null) {
			map.put("OA_who", "%" + map.get("OA_who") + "%");
		}
		if (map.get("store_date") != null) {
			map.put("store_date2", map.get("store_date") + " 23:59:59");
		}
		map.put("approval_YesOrNo", map.get("yesOrNo"));
		if (map.get("type_id") == "") {
			map.remove("type_id");
		}
		map.put("customer_id", getCustomerId(request));
		map.put("headship", getCustomer(request).get("headship"));
		map.put("upper_customer_id", getUpperCustomerId(request));
		return employeeService.getOAList(map);
	}
	/**
	 * 获取审批详细记录
	 * @param request
	 * @param seeds_id
	 * @return
	 */
	@RequestMapping("getOAInfo")
	@ResponseBody
	public Map<String, Object> getOAInfo(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		//1.获取审批信息
		Map<String, Object> mapinfo = employeeService.getOAInfo(map,getComIdPath(request));
		String ivt_oper_listing=mapinfo.get("ivt_oper_listing").toString();
		//3.获取订单信息
		map.put("ivt_oper_listing", ivt_oper_listing);
		//2.获取订单编号
		List<Map<String,Object>> list=saiYuService.getOrderList(map);
		mapinfo.put("list", list);
		return mapinfo;
	}
	/**
	 * 获取推荐的产品
	 * @param request
	 * @return
	 */
	@RequestMapping("getSuggest")
	public List<Map<String,Object>> getSuggest(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		return saiYuService.getSuggest(map);
	}
	/**
	 * 获取采购审批详细信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getPurchaseApproval")
	@ResponseBody
	public Map<String,Object> getPurchaseApproval(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return  saiYuService.getPurchaseApproval(map);
	}
	/**
	 * 保存采购审批操作,并生成订单数据
	 * @param request
	 * @param item_ids 产品采购列表 {"item_id":"CP0001","num":12,"sd_unit_price":12.12}
	 * @return
	 */
	@RequestMapping("savePurchaseApproval")
	@ResponseBody
	public ResultInfo savePurchaseApproval(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//   第四步保存采购订单审批
			//1.保存审批记录,
			String[] item_ids=request.getParameterValues("itemIds[]");
			JSONArray jsons=JSONArray.fromObject(item_ids);
//			String ivt_oper_listing=request.getParameter("ivt_oper_listing");
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getCustomer(request));
			//2.保存订单记录
			msg=saiYuService.savePurchaseApproval(jsons,map); 
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  财务审批
	 * @param request
	 * @param ivt_oper_listing 订单编号
	 * @return 财务审批页面和no订单编号
	 */
	@RequestMapping("financialApproval")
	public String financialApproval(HttpServletRequest request) {
		request.setAttribute("spNo", request.getParameter("ivt_oper_listing"));
		request.setAttribute("seeds_id", request.getParameter("seeds_id"));
		Map<String, Object> mapparam=new HashMap<String, Object>();
		mapparam.put("upper_customer_id", getUpperCustomerId(request));
		mapparam.put("step", request.getParameter("approval_step"));
		mapparam.put("com_id",getComId());
		//获取第三步审批人电话
		Map<String,String> map=saiYuService.getApprovalPerson(mapparam);
		request.setAttribute("phone", map.get("phone"));
		request.setAttribute("corp_sim_name", map.get("corp_sim_name"));
		request.setAttribute("spNo", request.getParameter("spNo"));
		getAutr(request);
		request.setAttribute("autr", 2);
		String approval_step= request.getParameter("approval_step");
		request.setAttribute("approval_step", approval_step);
		return "pc/saiyu/financialApproval";
	}
	/**
	 * 保存财务经理审批  
	 * @param request
	 * @return
	 */
	@RequestMapping("saveApprovalInfo")
	@ResponseBody
	public ResultInfo saveApprovalInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			// 第五步保存财务经理审批
			Map<String,String> map=new HashMap<String, String>();
			map.put("com_id", getComId());
			map.put("ivt_oper_listing", request.getParameter("ivt_oper_listing"));
			map.put("url", "financialApproval");
			map.put("spyj", request.getParameter("spyj"));
			map.put("spNo", request.getParameter("spNo"));
			map.put("approval_step",request.getParameter("approval_step"));
			map.put("list", request.getParameter("list[]"));
			saiYuService.saveApprovalInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  出纳支付
	 * @param request
	 * @return
	 */
	@RequestMapping("cashierPayment")
	public String cashierPayment(HttpServletRequest request) {
		// 出纳支付跳转页面
		request.setAttribute("spNo", request.getParameter("ivt_oper_listing"));
		request.setAttribute("seeds_id", request.getParameter("seeds_id"));
		Map<String, Object> mapparam=new HashMap<String, Object>();
		mapparam.put("upper_customer_id", getUpperCustomerId(request));
		String approval_step= request.getParameter("approval_step");
		mapparam.put("step", approval_step);
		mapparam.put("com_id",getComId());
		//获取第三步审批人电话
		Map<String,String> map=saiYuService.getApprovalPerson(mapparam);
		if(map!=null){
			request.setAttribute("phone", map.get("phone"));
			request.setAttribute("fhdz", map.get("addr1"));
			request.setAttribute("corp_sim_name", map.get("corp_sim_name"));
		}
		request.setAttribute("spNo", request.getParameter("spNo"));
		request.setAttribute("approval_step", approval_step);
		request.setAttribute("orderNo", request.getParameter("orderNo"));
		getAutr(request);
		
		return "pc/saiyu/cashierPayment";
	}
	
	/**
	 * 获取待支付订单      product/getClientOrdered.do
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderPage")
	@ResponseBody
	public PageList<Map<String,Object>> getOrderPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("customer_id", getUpperCustomerId(request));
		String type="";
		if(!isMapKeyNull(map, "type")){
			type=map.get("type")+"/";
		}
		PageList<Map<String,Object>> pages= saiYuService.getOrderPage(map);
		for (Iterator<Map<String,Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
			Map<String,Object> maprows = iterator.next();
			File file=getOrderEvalFilePath(request, maprows.get("ivt_oper_listing"),type);
			if(file.exists()){
				maprows.put("pingjia", "已评价");
			}
			///////计算电工相关信息////
			if(!"0".equals(maprows.get("elecState"))){
				maprows.put("orderNo", "%"+maprows.get("ivt_oper_listing")+"%");
				Map<String,Object> mapele=saiYuService.getElectricianInfo(maprows);
				if(mapele!=null){
					maprows.put("dianName", mapele.get("corp_sim_name"));
					maprows.put("dianPhone", mapele.get("user_id"));
				}
			}
		}
		return pages;
	}
	
	/**
	 *  产品订单详细
	 * @param request
	 * @return
	 */
	@RequestMapping("orderDetails")
	public String orderDetails(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		request.setAttribute("info", saiYuService.getOrderInfo(map));
		if(map.get("orderNo")!=null){
			Integer len=map.get("orderNo").toString().split(",").length;
			if(len>1){
				map.remove("ivt_oper_listing");
			}else{
				map.put("ivt_oper_listing", map.get("orderNo"));
//				map.remove("orderNo");
			}
		}
		List<Map<String,Object>> list= saiYuService.getOrderDetails(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> listmap = iterator.next();
			StringBuffer buffer=new StringBuffer("img/");
			buffer.append(listmap.get("item_id")).append("/cp/");
			File file=new File(getComIdPath(request)+buffer.toString());
			File[] imgs=file.listFiles();
			if (imgs!=null) {
				String imgpath=imgs[0].getPath().split("\\\\"+getComId())[1];
				imgpath="../"+getComId()+"/"+imgpath;
				imgpath=imgpath.replaceAll("\\\\", "/");
				listmap.put("imgpath", imgpath);
			}
		}
		request.setAttribute("list",list);
		request.setAttribute("orderNo", map.get("orderNo"));
		request.setAttribute("Status_OutStore", map.get("Status_OutStore"));
		return "pc/saiyu/orderDetails";
	}
	
	/**
	 *  获取订单详细信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderDetails")
	@ResponseBody
	public List<Map<String,Object>> getOrderDetails(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("orderNo", map.get("ivt_oper_listing"));
		return saiYuService.getOrderDetails(map);
	}
	/**
	 *  客户评价
	 * @param request
	 * @return
	 */
	@RequestMapping("evaluation")
	public String evaluation(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		String type=request.getParameter("type");
		request.setAttribute("orderNo", orderNo);
		request.setAttribute("type", type);
		String url="electricianEval";
		if(StringUtils.isNotBlank(type)){
			type=type+"/";
		}else{
			type="";
			url="evaluation";
		}
		String pingjia=getFileTextContent(getOrderEvalFilePath(request, orderNo,type));
		if(StringUtils.isNotBlank(pingjia)){
			JSONObject json=JSONObject.fromObject(pingjia);
			request.setAttribute("map", json);
		}
		File dest=new File(getComIdPath(request)+"eval/"+type+orderNo+"/");
		if(dest.exists()){
			File[] files=dest.listFiles();
			List<String> list=new ArrayList<String>();
			for (File item : files) {
				String[] path=item.getPath().split("\\\\"+getComId());
				String pathimg=getComId()+path[1];
				pathimg=pathimg.replaceAll("\\\\", "/");
				list.add(pathimg);
			}
			request.setAttribute("list", list);
		}
		
		return "pc/saiyu/"+url;
	}
	/**
	 * 提交订单评价
	 * @param request
	 * @return
	 */
	@RequestMapping("postEval")
	@ResponseBody
	public ResultInfo postEval(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("time", getNow());
			JSONObject json=JSONObject.fromObject(map);
			String type="";
			if(isNotMapKeyNull(map, "type")){
				saiYuService.updateElecState(map);
				type=map.get("type")+"/";
			}
			saveFile(getOrderEvalFilePath(request,map.get("orderNo"),type), json.toString());
			if(!isMapKeyNull(map, "imageUrl")){
				String[] imgs=map.get("imageUrl").toString().split(",");
				for (String img : imgs) {
					File src=new File(getRealPath(request)+img);
					if(src.exists()){
						File dest=new File(getComIdPath(request)+"eval/"+type+map.get("orderNo")+"/"+src.getName());
						if (!dest.getParentFile().exists()) {
							dest.getParentFile().mkdirs();
						}
						FileUtils.moveFile(src, dest);
					}
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存电工安装费用
	 * @param request
	 * @return
	 */
	@RequestMapping("saveEvalOrderPay")
	@ResponseBody
	public ResultInfo saveEvalOrderPay(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Calendar c = Calendar.getInstance();
			Map<String, Object> map =getKeyAndValue(request);
			////////////////
//			writeLog(request,getCustomerId(request),map.toString());
			Map<String,Object> mapdemand=new HashMap<String, Object>();
			/////////////////////////////
			mapdemand.put("ivt_oper_listing", map.get("orderNo"));map.remove("orderNo");//订单编号
			mapdemand.put("confirm_je", map.get("amount"));map.remove("amount");//安装金额
			mapdemand.put("anz_datetime", map.get("anz_datetime"));map.remove("anz_datetime");//安装金额
			mapdemand.put("dian_customer_id", map.get("dian_customer_id"));map.remove("dian_customer_id");//安装金额
			/////////////////
			Object xsskNo=map.get("xsskNo");
			map.remove("xsskNo");
			map.put("finacial_y", c.get(Calendar.YEAR));
			map.put("finacial_m", c.get(Calendar.MONTH));
			map.put("finacial_d", getNow());
			map.put("recieved_direct", "收款");
			map.put("recieved_auto_id",xsskNo);
			map.put("recieved_id", xsskNo);
			//获取上级客户编码和名称
			map.put("customer_id", getUpperCustomerId(request));
			String upper_name= customerService.getCustomerName(getUpperCustomerId(request), getComId());
			mapdemand.put("customerName",upper_name);
			map.put("recieve_type", "账上款");
			map.put("rcv_hw_no","JS001");//结算方式编码
			StringBuffer buffer=new StringBuffer(upper_name).append(",已支付电工安装费,金额:");
			buffer.append(mapdemand.get("confirm_je")).append(",支付方式:").append(map.get("paystyle")).append(",收款单号:").append(xsskNo).append(",");
			buffer.append(map.get("paystyle")).append(",安装订单编号:").append(mapdemand.get("ivt_oper_listing"));
			Map<String,Object> maprows=new HashMap<String, Object>();
			maprows.put("com_id", getComId());
			maprows.put("customer_id", map.get("dian_customer_id"));
			maprows.put("orderNo", mapdemand.get("ivt_oper_listing"));
			Map<String,Object> mapeleinfo= saiYuService.getElectricianInfo(maprows);
			if(mapeleinfo!=null){
				buffer.append("|电工姓名:").append(mapeleinfo.get("corp_sim_name")).append(",电话:").append(mapeleinfo.get("user_id"));
			}
			map.put("buffer",  buffer.toString());
			map.put("c_memo","电工安装费支付,安装订单编号:"+mapdemand.get("ivt_oper_listing"));
			map.put("sum_si", mapdemand.get("confirm_je"));
			map.put("sum_si_origin",map.get("paystyle"));map.remove("paystyle");
			map.put("comfirm_flag", "N");
			map.put("mainten_clerk_id", getComId(request));
			map.put("mainten_datetime", getNow());
			mapdemand.put("com_id", getComId());
			mapdemand.put("customer_id", getUpperCustomerId(request));
			saiYuService.saveEvalOrderPay(map,mapdemand);
			////////保存备注信息到文件中
			File file=getRecievedMemo(request, xsskNo,getUpperCustomerId(request));
			saveFile(file, buffer.toString());
			String clerk_id=getEmployeeId(request);
			if (clerk_id==null) {
				clerk_id=getCustomerId(request);
			}
			writeLog(request,clerk_id,mapeleinfo.get("corp_sim_name"), "收款单号:"+xsskNo);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 保存订单支付
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOrderPay")
	@ResponseBody
	public ResultInfo saveOrderPay(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Calendar c = Calendar.getInstance();
			Map<String, Object> map =getKeyAndValue(request);
			////////////////
//			writeLog(request,getCustomerId(request),map.toString());
			Map<String,Object> mapupdate=new HashMap<String, Object>();
			/////////////////////////////
			mapupdate.put("spNo", map.get("spNo"));map.remove("spNo");//审批单号
			mapupdate.put("spyj", map.get("spyj"));map.remove("spyj");//审批意见
			mapupdate.put("bxNo", map.get("bxNo"));map.remove("bxNo");//报修单号
			mapupdate.put("FHDZ", map.get("FHDZ"));map.remove("FHDZ");//发货地址
			mapupdate.put("approval_step", map.get("approval_step"));map.remove("approval_step");//当前审批步骤
			mapupdate.put("orderNo", map.get("orderNo"));map.remove("orderNo");//订单编号
			mapupdate.put("amount", map.get("amount"));map.remove("amount");//支付金额
			mapupdate.put("paystyle", map.get("paystyle"));map.remove("paystyle");//支付方式
			mapupdate.put("orderlist", map.get("orderlist"));map.remove("orderlist");//支付方式
			/////////////////
			Object xsskNo=map.get("xsskNo");
			map.remove("xsskNo");
			map.put("finacial_y", c.get(Calendar.YEAR));
			map.put("finacial_m", c.get(Calendar.MONTH));
			map.put("finacial_d", getNow());
			map.put("recieved_direct", "收款");
			map.put("recieved_auto_id",xsskNo);
			map.put("recieved_id", xsskNo);
			//获取上级客户编码和名称
			map.put("customer_id", getUpperCustomerId(request));
			String upper_name= customerService.getCustomerName(getUpperCustomerId(request), getComId());
			mapupdate.put("customerName",upper_name);
			map.put("recieve_type", "账上款");
			map.put("rcv_hw_no","JS001");//结算方式编码
			StringBuffer buffer=new StringBuffer(upper_name).append(",");
			buffer.append("收款单号:").append(xsskNo).append(",");
			buffer.append(mapupdate.get("paystyle")).append(",订单编号:").append(mapupdate.get("orderNo"));
			mapupdate.put("spyj", "同意");
			JSONObject json=JSONObject.fromObject(mapupdate);
			json.put("customer_id", getUpperCustomerId(request));
			json.put("recieved_id", xsskNo);
			map.put("json", json);
			map.put("c_memo", buffer.toString());
			buffer.append("|");
			map.put("sum_si", mapupdate.get("amount"));
			map.put("sum_si_origin",map.get("paystyle"));
			map.put("comfirm_flag", "N");
			map.put("mainten_clerk_id", getComId(request));
			map.put("mainten_datetime", getNow());
			mapupdate.put("Status_OutStore", getProcessName(request, 0));
			saiYuService.savePaymoney(mapupdate,map);
			////////保存备注信息到文件中
			File file=getRecievedMemo(request, xsskNo,getUpperCustomerId(request));
			saveFile(file, buffer.toString());
			String clerk_id=getEmployeeId(request);
			if (clerk_id==null) {
				clerk_id=getCustomerId(request);
			}
			writeLog(request,clerk_id,upper_name, "收款单号:"+ xsskNo);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	////////////////////附近货运部分////////////
	/**
	 *  物流分解
	 * @param request
	 * @return
	 */
	@RequestMapping("decompose")
	public String decompose(HttpServletRequest request) {
//		String[] pros=getProcessName(request);
		int j=0;
//		for (int i = 0; i < pros.length; i++) {
//			String item=pros[i];
//			if(item.contains("物流")||item.contains("司机")){
//				j=0;
//				break;
//			}
//		}
//		String proName=getProcessName(request, j+1);
//		if(StringUtils.isNotBlank(proName)){
//			proName=proName.substring(1, proName.length());
//			proName="%"+proName+"%";
//		}else{
//			proName="%%";
//		}
		request.getParameter("processName");
		String id= request.getParameter("seeds_id");
		request.setAttribute("seeds_ids", id);
		String ids=id.replace("[", "").replace("]", "");
		List<Map<String,Object>> list= saiYuService.getOrderInfoByIds(ids);
		request.setAttribute("list", list);
		
		return "pc/saiyu/decompose";
	}
	
	/**
	 * 保存司机信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveDriver")
	@ResponseBody
	public ResultInfo saveDriver(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			int type=0;
			map.put("isclient","1");
			if (isMapKeyNull(map,"working_status")) {
			    map.put("working_status","是");
			}
			msg=saiYuService.saveDriverElectrician(map,type);
			////提交客户数据到微信企业号///
			map.put("name", map.get("corp_name"));
			Object agentDeptId=systemParams.checkSystem("agentDeptId");
			postInfoToweixin(map, "司机",agentDeptId);
			///////////////////////////////
			File srcDir=new File(getUserpicTempPath(request));
			if (srcDir.exists()) {
				File destDir=new File(getComIdPath(request)+"evalimg/"+map.get("customer_id"));
				for (File srcFile : srcDir.listFiles()) {
					if (srcFile.exists()) {
					File destFile=new File(destDir.getPath()+"/"+srcFile.getName());
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					FileUtils.moveFile(srcFile, destFile);
					}
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 附近司机
	 * @param request
	 * @return
	 */
	@RequestMapping("nearDriver")
	public String nearDriver(HttpServletRequest request) {
		//1.获取订单信息
		return "pc/near/nearDriver";
	}
	
	/**
	 *  司机运货单
	 * @param request
	 * @return
	 */
	@RequestMapping("waybill")
	public String waybill(HttpServletRequest request) {
		//TODO 司机运货单
		String id= request.getParameter("seeds_id");
		if (StringUtils.isBlank(id)) {
			id=request.getParameter("seeds_id");
		}
		if (StringUtils.isBlank(id)) {
			return "pc/near/waybill";
		}
		
		String ids=id;
		if(id.contains("[")){
			ids=id.replace("[", "");
		}
		if(ids.contains("]")){
			ids=ids.replace("]", "");
		}
		ids=ids.replace("%20", ""); 
		List<Map<String,Object>> list= saiYuService.getOrderInfoByIdsDrive(ids);
		if(list!=null&&list.size()>0){
			request.setAttribute("seeds_id", id);
			request.setAttribute("com_id", list.get(0).get("com_id"));
			String erweima="../qrcode/"+id+".jpg";
			request.setAttribute("erweima", erweima);
			request.setAttribute("type", request.getParameter("type"));
			request.setAttribute("list", list);
			request.setAttribute("Status_OutStore", list.get(0).get("Status_OutStore"));
		}else{
			request.setAttribute("ordertype", "订单已结束!");
		}
		boolean fenx=true;
		if(getCustomer(request)==null){
			fenx=false;
		}
		if(getEmployee(request)==null){
			fenx=false;
		}
		request.setAttribute("fenx", fenx);
		return "pc/near/waybillNew";
	}
	/**
	 *  司机提货详细单
	 * @param request 传入id数组值
	 * @return 包含司机,产品,客户信息的页面,通过二维码扫描直接展示出信息,
	 */
	@RequestMapping("driverWaybillDetail")
	public String driverWaybillDetail(HttpServletRequest request) {
		//TODO 司机提货详细单
		if (getEmployee(request)==null) {
			return "redirect:../pc/login-yuangong.html";
		}
		String id= request.getParameter("seeds_id");
		Object headship=getEmployee(request).get("headship");
		String msg=null;
		if(StringUtils.isNotBlank(id)){
			id=id.replace("[", "").replace("]", "");
			id=id.replace("%20", "");
			if(headship!=null&&!"".equals(headship)){
				if (id.startsWith(",")) {
					id=id.substring(1,id.length());
				}
				if (id.endsWith(",")) {
					id=id.substring(0,id.length()-1);
				}
				request.setAttribute("seeds_id", id);
				if(headship.toString().contains("门卫")){
					id=id.split(",")[0];
				}else{
					if(headship.toString().contains("库管")){
						String type= request.getParameter("type");
						request.setAttribute("type", type);
					}else if(StringUtils.isBlank(msg)){
						msg="没有操作权限请联系管理员!";
					}
				}
			}else if(StringUtils.isBlank(msg)){
				msg="没有操作权限请联系管理员!";
			}
		}else if(StringUtils.isBlank(msg)){
			msg="参数错误请联系管理员!";
		}
		if (StringUtils.isNotBlank(id)) {
			List<Map<String,Object>> list= saiYuService.getOrderInfoByIds(id);
			if(list.size()==0){
				list=null;
				msg= "已发货!";
			}else{
				request.setAttribute("list", list);
			}
		}else if(StringUtils.isBlank(msg)){
			msg="参数错误请联系管理员!";
		}
		request.setAttribute("msg", msg);
		if(headship!=null&&headship.toString().contains("门卫")){
			return "pc/orderTrack/verify_driver";
		}else{
			return "pc/saiyu/driverWaybillDetail";
		}
	}

	/**
	 * 通知发货管理员
	 * @param seeds_ids
	 * @param type
	 * @return
	 */
	@RequestMapping("noticeShippingManager")
	@ResponseBody
	public ResultInfo noticeShippingManager(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			String proceessStr=getFileTextContent(getSalesOrderProcessNamePath(getRequest()));
			if (StringUtils.isNotBlank(proceessStr)&&proceessStr.startsWith("[")) {
				JSONArray proceess=JSONArray.fromObject(proceessStr);
				Integer index=null;
				JSONObject item_json=null;//下一个流程
				String nextProcessName=null;
				for (int i = 0; i < proceess.size(); i++) {
					JSONObject json=proceess.getJSONObject(i);
					boolean b=json.getString("processName").equals(map.get("processName"));
					if(b){
						index=proceess.indexOf(json);
						if(index==(proceess.size()-1)){
							throw new RuntimeException("已经到流程最后一步了!");//页面增加单独收货按钮
						}
						item_json=proceess.getJSONObject(i+1);
						if (item_json!=null) {
							nextProcessName=proceess.getJSONObject(i+1).getString("processName");
						}
						break;
					}
				}
			map.put("headship",item_json.get("Eheadship"));
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			map.put("proName", nextProcessName);
			saiYuService.noticeShippingManager(map);
			success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 确认收货
	 * @param request
	 * @return
	 */
	@RequestMapping("confimShouhuo")
	@ResponseBody
	public ResultInfo confimShouhuo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
//			String[] itemids=request.getParameterValues("itemids[]");
//			map.put("itemids", Arrays.toString(itemids));
			saiYuService.confimShouhuo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	//////////////////附近电工部分/////////////////
	/**
	 * 保存电工详细
	 * @param request
	 * @return
	 */
	@RequestMapping("saveElectrician")
	@ResponseBody
	public ResultInfo saveElectrician(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			int type=0;
			map.put("isclient","0");
			if (isMapKeyNull(map,"working_status")) {
				map.put("working_status","是");
			}
			saiYuService.saveDriverElectrician(map,type);
			map.put("name", map.get("corp_name"));
			Object agentDeptId=systemParams.checkSystem("agentDeptId");
			postInfoToweixin(map, "电工",agentDeptId);
			File srcDir=new File(getUserpicTempPath(request));
			if (srcDir.exists()) {
				File destDir=new File(getComIdPath(request)+"evalimg/"+map.get("customer_id"));
				for (File srcFile : srcDir.listFiles()) {
					if (srcFile.exists()) {
					File destFile=new File(destDir.getPath()+"/"+srcFile.getName());
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					FileUtils.moveFile(srcFile, destFile);
					}
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取电工,司机分页列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getElectricianPage")
	@ResponseBody
	public PageList<Map<String,Object>> getElectricianPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return saiYuService.getElectricianPage(map);
	}
 
	/**
	 * 附近电工
	 * @param request
	 * @return
	 */
	@RequestMapping("nearElectrician")
	public String nearElectrician(HttpServletRequest request) {
		//1.获取订单信息
//		Map<String,Object> map=getKeyAndValue(request);
		String ivt_oper_listing=request.getParameter("ivt_oper_listing");
		if (StringUtils.isNotBlank(ivt_oper_listing)) {
			//2.获取客户地址,weixinID
			//3.获取所有电工的weixinID
			String weixinID=saiYuService.getDriverElectricianWeixinID(getComId(),0);
			//4.发送消息给司机
			List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> newmap=new HashMap<String, Object>();
			Map<String,Object> mapcus= customerService.getCustomerByCustomer_id(getUpperCustomerId(request), getComId());
			newmap.put("title","您有一条来自【"+getComName()+mapcus.get("customer_name")+"】的安装信息!");
			newmap.put("description", "客户地址:"+mapcus.get("corp_addr"));
			newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/installationList.do?ivt_oper_listin="+ivt_oper_listing);
			sendMessageNews(news, weixinID);
		}
		return "pc/near/nearElectrician";
	}
	
	/**
	 *  电工安装列表
	 * @param request
	 * @return
	 */
	@RequestMapping("installationList")
	public String installationList(HttpServletRequest request) {
		return "pc/near/installationList";
	}
	/**
	 * 司机或者电工上报地址
	 * @param request
	 * @return
	 */
	@RequestMapping("uploadLocation")
	@ResponseBody
	public ResultInfo uploadLocation(HttpServletRequest request) {          
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (map.get("ivt_oper_listing")!=null) {
				map.put("up_datetime", getNow());
				map.put("dian_customer_id", getCustomerId(request));
				saiYuService.uploadLocation(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 欠条
	 * @param request
	 * @return
	 */
	@RequestMapping("iou")
	public String iou(HttpServletRequest request) {
		String contentpath="";
		if (StringUtils.isNotBlank(request.getContextPath()) ) {
			contentpath=request.getContextPath()+"/";
		}
		request.setAttribute("contentpath",contentpath);
		request.setAttribute("iouPath", getIouPath(request,getCustomerId(request)));
		return "pc/saiyu/IOU";
	}
	/**
	 * 保存欠条
	 * @param request
	 * @return
	 */
	@RequestMapping("saveIou")
	@ResponseBody
	public ResultInfo saveIou(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String printdiv=request.getParameter("printdiv");
			Map<String,Object> map=getKeyAndValue(request, "printdiv");
			map.put("customer_id",getCustomerId(request));
			map.put("clerk_idAccountApprover", getCustomer(request).get("clerk_idAccountApprover"));
			map.put("com_id", getComId(request));
			if(isMapKeyNull(map, "customerName")){
				map.put("customerName", getCustomer(request).get("clerk_name").toString());
			}
			String op_id=saiYuService.saveIouOA_ctl03001_approval(map);
			StringBuffer buffer=getIouPath(request, getCustomerId(request));
			buffer.append(op_id).append(".html");
			saveFile(buffer.toString(), "<!DOCTYPE html>"+printdiv);
			success = true;
			writeLog(request,getCustomerId(request),map.get("customerName"),"生成欠条:"+op_id+".html");
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  预约电工
	 * @param request
	 * @return
	 */
	@RequestMapping("reservationElectrician")
	public String reservationElectrician(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		String[] orderNos=request.getParameterValues("orderNo[]"); 
		if(orderNos!=null&&orderNos.length>0){
			 orderNo=Arrays.toString(orderNos);
			 if (orderNo.startsWith("[")) {
				 orderNo=orderNo.replaceFirst("\\[", "");
				 orderNo=orderNo.replaceAll("\\]", "");
			}
		}
		Map<String,Object> mapinfo=null;//saiYuService.findTiqianYuYueInfo(orderNo,getComId());
		if(mapinfo==null){
			mapinfo=customerService.getCustomerByCustomer_id(getUpperCustomerId(request), getComId());
			mapinfo.put("lxr", mapinfo.get("corp_sim_name"));
			mapinfo.put("address", mapinfo.get("addr1"));
		}
		request.setAttribute("info",mapinfo);
		request.setAttribute("orderNo",orderNo);
		request.setAttribute("upper_customer_id", getUpperCustomerId(request));
		
		return "pc/saiyu/reservationElectrician";
	}
	/**
	 * 邀请电工
	 * @param request
	 * @return
	 */
	@RequestMapping("inviteEval")
	@ResponseBody
	public ResultInfo inviteEval(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
//			String weixinID=saiYuService.getDriverElectricianWeixinID(getComId(), 0);
			saiYuService.getDriverElectricianWeixinID(map, 0);
//			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
//			Map<String,Object> newmap=new HashMap<String, Object>();
//			Map<String,Object> mapcus=customerService.getCustomerByCustomer_id(getUpperCustomerId(request), getComId());
//			newmap.put("title","您有一条来自["+getComName()+"客户-"+mapcus.get("corp_name")+"]安装需求!");
//			newmap.put("description","订单编号:"+map.get("orderNo"));
//			newmap.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/evalUpAddress.do?param=|ivt_oper_listing="+
//			map.get("orderNo")+"|customer_id="+getUpperCustomerId(request)+"|lat="+map.get("lat")+"|lng="+map.get("lat"));
//			news.add(newmap);
//			sendMessageNews(news, weixinID);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  
	 * @param request
	 * @param type 0-电工,1-司机
	 * @return
	 */
	@RequestMapping("getLatlng")
	@ResponseBody
	public List<Map<String,Object>> getLatlng(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		Date d=new Date();
		map.put("beginTime",DateUtils.addMinutes(d, -30));
		map.put("endTime",DateTimeUtils.dateTimeToStr());
		List<Map<String,Object>> list= saiYuService.getLatlng(map);
		return list;
	}
	
	/**
	 *  电工接收消息后打开的上报地址页面
	 * @param request
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("evalUpAddress")
	public String evalUpAddress(HttpServletRequest request,HttpServletResponse response) throws IOException {
		String ivt_oper_listing=request.getParameter("param");
		Map<String,Object> map=getKeyAndValue(request);
		if (getCustomer(request)!=null&&getCustomerId(request).startsWith("E")) {
			if (isNotMapKeyNull(map, "ivt_oper_listing")&&isNotMapKeyNull(map, "customer_id")) {
			}else{
				String[] params=ivt_oper_listing.split("\\|");
				for (String item : params) {
					if (item.split("=").length>1) {
						if(!"null".equals(item.split("=")[1])){
							map.put(item.split("=")[0], item.split("=")[1]);
						}else{
							map.put(item.split("=")[0], "30.694260");
						}
					}
				}
			}
			Map<String,Object> mapcus=customerService.getCustomerByCustomer_id(map.get("customer_id").toString(), getComId());
			request.setAttribute("corp_sim_name",mapcus.get("corp_sim_name"));
			request.setAttribute("ivt_oper_listing",map.get("ivt_oper_listing"));
			if(map.get("ivt_oper_listing").toString().split(",").length>1){
				map.put("orderNo", map.get("ivt_oper_listing"));
				map.remove("ivt_oper_listing");
			}
//		map.put("Status_OutStore", "已结束");
			List<Map<String,Object>> list=saiYuService.getOrderDetails(map);
			request.setAttribute("list", list);
			request.setAttribute("lat", map.get("lat"));//经纬度
			request.setAttribute("lng", map.get("lng"));//经纬度
			request.setAttribute("customer_id", map.get("customer_id"));//经纬度
			return "pc/saiyu/evalUpAddress";
		}else{
			StringBuffer param=new StringBuffer("/saiyu/evalUpAddress.do?ivt_oper_listing=");
			param.append(map.get("ivt_oper_listing")).append("&customer_id=").append(map.get("customer_id"));
			param.append("&lat=").append(map.get("lat")).append("&lng=").append(map.get("lng")).append("&com_id=").append(map.get("com_id"));
			request.getSession().setAttribute("sessionUrl",param.toString());
			response.sendRedirect("../pc/loginEval.jsp");
			return null;
		}
	}
	
	/**
	 *  附近电工实时预约
	 * @param request
	 * @return
	 */
	@RequestMapping("electricianNear")
	public String electricianNear(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		request.setAttribute("orderNo",orderNo);
		Map<String,Object> map=customerService.getCustomerByCustomer_id(getUpperCustomerId(request), getComId());
		String confirm_je=saiYuService.getElecOrderSumsi(orderNo,getComId());
		request.setAttribute("confirm_je", confirm_je);
		request.setAttribute("address", map.get("addr1"));
		return "pc/saiyu/electricianNear";
	}
	/**
	 * 客户登录
	 * @pa电工ram request
	 * @param name
	 * @param pwd
	 * @return
	 */
	@RequestMapping("login")
	@ResponseBody
	public ResultInfo login(HttpServletRequest request, String name, String pwd) {
		String msg = null;
		boolean success = false;
		if (getEmployee(request) != null ) {
			 request.getSession().removeAttribute(ConfigFile.SESSION_USER_INFO);
		} 
		if (StringUtils.isBlank(name)) {
			msg = "请输入用户名!";
		} else if (StringUtils.isBlank(pwd)) {
			msg = "请输入密码!";
		} else {
			String comId = setComId(request,managerService);
			Map<String, Object> map = null;
			if ("001".equals(name)) {
				map = managerService.checkLogin(name, comId);
				map.put("customer_id", map.get("clerk_id"));
			} else {
				Map<String,Object> maplogin=new HashMap<String, Object>();
				maplogin.put("name", name);
				maplogin.put("com_id", comId);
				maplogin.put("type", request.getParameter("type"));
				map = saiYuService.checkLogin(maplogin);
			}
			if (map == null) {
				msg = "用户不存在!";
			} else {
				Object password = map.get("user_password");
				if (password != null && password.toString().length() < 32) {
					password = MD5Util.MD5(password.toString());
				}
				if (password == null
						|| !pwd.equalsIgnoreCase(password.toString())) {
					msg = "用户名或密码错误!";
				} else {
					map.remove("user_password");
					request.getSession().setAttribute(
							ConfigFile.CUSTOMER_SESSION_LOGIN, map);
					request.getSession().setAttribute("o2o", systemParams.checkSystem("o2o"));
					request.getSession().setAttribute("prefix", getPrefix());
					request.setAttribute("ver",InitConfig.getNewVer());
					Object weixinID = map.get("weixinID");
					if (weixinID != null) {
//						LoggerUtils.info(sendMessage(
//								"欢迎使用,登录时间:" + getNow(),
//								weixinID.toString()));
					}
					WeixinUtil wei=new WeixinUtil();
					String resultmsg=wei.getEmployeeInfo(weixinID+"",comId);
					if ("001".equals(name)) {
						success = true;
					}else if (StringUtils.isNotBlank(resultmsg)) {
						JSONObject json=JSONObject.fromObject(resultmsg);
						LoggerUtils.info(json);
						if (json.has("weixinid")) {
							success = true;
							writeLog(request, map.get("customer_id").toString(),map.get("clerk_name"), "登录");
						}else{
							msg="weixinid";
						}
					}else{
						msg="weixinid";
					}
				}
			}
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  塞宇电工首页
	 * @param request
	 * @return
	 */
	@RequestMapping("eval")
	public String eval(HttpServletRequest request) {
		String url=tourl(request);
		request.getSession().removeAttribute("sessionUrl");
		if (url!=null) {
			return url;
		}
		return "pc/eval/eval";
//		return "redrict:../pc/electrician/install02/diangong-yian.html";
	}
	/**
	 *  司机首页
	 * @param request
	 * @return
	 */
	@RequestMapping("drive")
	public String drive(HttpServletRequest request) {
		String url=tourl(request);
		if (url!=null) {
			return url;
		}
//		return "pc/near/drive";
		return "redrict:../pc/driver/freight02/diangong-daian.html";
	}
	
	/**
	 * 保存电工注册信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveEval")
	@ResponseBody
	public ResultInfo saveEval(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer error_code = 0;
		try {
			String user_id = request.getParameter("userId");
			String user_password = request.getParameter("pwd");
			String openid = request.getParameter("openid");
			Map<String,Object> check=checkRegisterParam(request, user_id);
			if (MapUtils.getBoolean(check, "b")) {
				boolean b=managerService.checkPhone(user_id,"Sdf00504_saiyu"," and isclient='0'");
				if (b) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("user_id", user_id);
					map.put("movtel", user_id);
					map.put("corp_sim_name", user_id);
					map.put("corp_name", user_id);
					map.put("com_id", setComId(request));
					map.put("working_status", "是");
					map.put("weixinStatus", "0");
					map.put("isclient", "0");//电工
					map.put("user_password", MD5Util.MD5(user_password));
					map.put("weixinID",user_id); 
					map.put("openid",openid); 
					saiYuService.saveDriverElectrician(map,0); 
					////提交客户数据到微信企业号///
					map.put("name", map.get("corp_name"));
					Object agentDeptId=systemParams.checkSystem("agentDeptId");
					postInfoToweixinComId(map, "电工",agentDeptId); 
					writeLog(request,user_id,user_id,"电工注册");
					success = true;
				}else{
					msg="手机号已存在！";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg,error_code);
	}
	/**
	 * 保存司机注册信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveDrive")
	@ResponseBody
	public ResultInfo saveDrive(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer error_code = 0;
		try {
			String user_id = request.getParameter("userId");
			String user_password = request.getParameter("pwd");
			String openid = request.getParameter("openid");
			Map<String,Object> check=checkRegisterParam(request, user_id);
			if (MapUtils.getBoolean(check, "b")) {
				boolean b=managerService.checkPhone(user_id,"Sdf00504_saiyu"," and isclient='1'");
				if (b) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("user_id", user_id);
					map.put("movtel", user_id);
					map.put("corp_sim_name", user_id);
					map.put("corp_name", user_id);
					map.put("com_id", setComId(request));
					map.put("working_status", "是");
					map.put("weixinStatus", "0");
					map.put("isclient", "1");//司机
					map.put("user_password", MD5Util.MD5(user_password));
					map.put("weixinID",user_id); 
					map.put("openid",openid); 
					saiYuService.saveDriverElectrician(map,0); 
					////提交客户数据到微信企业号///
					map.put("name", map.get("corp_name"));
					Object agentDeptId=systemParams.checkSystem("agentDeptId");
					postInfoToweixinComId(map, "司机",agentDeptId);
					writeLog(request,user_id,user_id,"司机注册");
					success = true;
				}else{
					msg="手机号已存在！";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg,error_code);
	}
	
	/**
	 * 保存提前预约电工
	 * @param request
	 * @return
	 */
	@RequestMapping("tiqianYuYue")
	@ResponseBody
	public ResultInfo tiqianYuYue(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			saiYuService.tiqianYuYue(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("diangongpay")
	public String diangongpay(HttpServletRequest request) {
//		Map<String,Object> map=getKeyAndValue(request);
//		List<Map<String,Object>> orderlist=saiYuService.getOrderDetails(map);
//		request.setAttribute("orderlist", orderlist);
		request.setAttribute("orderNo", request.getParameter("orderNo"));
		request.setAttribute("type", request.getParameter("type"));
		request.setAttribute("dian_customer_id", request.getParameter("dian_customer_id"));
		String anz_datetime=request.getParameter("anz_datetime");
		if(StringUtils.isBlank(anz_datetime)){
			anz_datetime=DateTimeUtils.dateTimeToStr(DateUtils.addMinutes(new Date(), 30));
		}
		request.setAttribute("anz_datetime", anz_datetime);
		return "pc/saiyu/diangongpay";
	}
	/**
	 *  电工预约订单信息
	 * @param request
	 * @return
	 */
	@RequestMapping("evalOrderDetails")
	public String evalOrderDetails(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("Status_OutStore", "已结束");
		List<Map<String,Object>> orderlist=saiYuService.getOrderDetails(map);
		Map<String,Object> cusInfo=saiYuService.findTiqianYuYueInfo(map.get("ivt_oper_listing").toString(), getComId());
		request.setAttribute("orderlist", orderlist);
		request.setAttribute("cusInfo", cusInfo);
		return "pc/saiyu/evalOrderDetails";
	}
	

	/**
	 * 电工上报地址参与安装讨论
	 * @param request
	 * @return
	 */
	@RequestMapping("cyanz")
	@ResponseBody
	public ResultInfo cyanz(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("type", "0");
			map.put("dian_customer_id", getCustomerId(request));
			map.put("up_datetime", new Date());
			saiYuService.cyanz(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 客户确认选择电工
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmSelectEval")
	@ResponseBody
	public ResultInfo confirmSelectEval(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("upper_customer_id", getUpperCustomerId(request));
			map.put("customer_id", getCustomerId(request));
			map.put("corp_sim_name", customerService.getCustomerName(getUpperCustomerId(request), getComId()));
			map.put("up_datetime", getNow());
			saiYuService.confirmSelectEval(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 电工确认安装
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmanz")
	@ResponseBody
	public ResultInfo confirmanz(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			saiYuService.confirmanz(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  客户 与电工对话
	 * @param request
	 * @return
	 */
	@RequestMapping("clientAndElectricianChat")
	public String clientAndElectricianChat(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("map", map);
		//创建客户与电工对话
		//获取客户id
		String customer_id=getCustomerId(request);
		String name=getCustomer(request).get("clerk_name")+"与电工"+request.getParameter("name")+"会话";
		WeixinUtil wei=new WeixinUtil();
		//获取会话消息
		String chatid=customer_id+map.get("dian_customer_id");
		request.setAttribute("chatid", chatid);
		request.setAttribute("chatname", name);
		request.setAttribute("dian_customer_id", map.get("dian_customer_id"));
		String info=wei.chatGet(chatid,map.get("com_id").toString().trim());
		if(StringUtils.isNotBlank(info)){
			JSONObject json=JSONObject.fromObject(info);
			if(!json.has("chatid")){//会话不存在就创建
				/////////
				//获取客户和电工微信账号
				map.put("customer_id", customer_id);
				Map<String,String> weixin=saiYuService.getWeixinIDCustomerAndEval(map);
				String[] userlist={weixin.get("weixinIDC"),weixin.get("weixinIDE"), weixin.get("weixinID")};
				String msg=wei.chatCreate(chatid, name, weixin.get("weixinIDC"), userlist,map.get("com_id").toString().trim());
				wei.chatUpdate(chatid, name, weixin.get("weixinIDC"), null, new String[]{weixin.get("weixinID")},map.get("com_id").toString().trim());
				LoggerUtils.info(msg);
			}else{
				//存在就直接跳转页面
			}
		}
		return "pc/saiyu/clientAndElectricianChat";
	}
	/**
	 * 获取客户和电工聊天消息
	 * @param request
	 * @return
	 */
	@RequestMapping("getCAndEChatInfo")
	@ResponseBody
	public ResultInfo getCAndEChatInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String chatid=request.getParameter("chatid");
			//微信将消息统一返回到一个接口中,接收到的消息将按照微信
			msg=getFileTextContent(getChatLogPath(request, chatid));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  电工个人信息页面
	 * @param request
	 * @return
	 */
	@RequestMapping("evalEdit")
	public String evalEdit(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("isclient","0");
		request.setAttribute("com_id", getComId());
		map.put("customer_id", getCustomerId(request));
		request.setAttribute("dian", managerService.getElectricianInfo(map)); 
		return "pc/saiyu/evalEdit";
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getevalimg")
	@ResponseBody
	public List<String> getevalimg(HttpServletRequest request) {
		String customer_id=request.getParameter("customer_id");
		if(getCustomerId(request)!=null){
			customer_id=getCustomerId(request);
		}
		String type=request.getParameter("type");
		if(StringUtils.isBlank(type)){
			type="evalimg";
		}
		File file=new File(getComIdPath(request)+type+"/"+customer_id);
		if (file.exists()) {
			List<String> list=new ArrayList<String>();
			for (File item : file.listFiles()) {
				list.add(item.getName());
			}
			return list;
		}
		return null;
	}
	
	/**
	 *  获取电工订单相关信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getEvalOrderInfo")
	@ResponseBody
	public PageList<Map<String, Object>> getEvalOrderInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("dian_customer_id", getCustomerId(request));
		return saiYuService.getEvalOrderInfo(map);
	}
	
	/**
	 *  在线咨询
	 * @param request
	 * @return
	 */
	@RequestMapping("sendChatClient")
	public String sendChatClient(HttpServletRequest request) {
		return "pc/saiyu/sendChatClient";
	}
	
	/**
	 * 电工安装确认
	 * @param request
	 * @return
	 */
	@RequestMapping("anzconfirm")
	@ResponseBody
	public ResultInfo anzconfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] items=request.getParameterValues("list[]");
			Map<String,Object> map=getKeyAndValue(request);
			if (items!=null&&items.length>0) {
				map.put("list", items);
			}
			map.put("time", getNow());
			saiYuService.anzconfirm(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
}
