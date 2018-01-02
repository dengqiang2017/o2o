package com.qianying.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.PageList;
import com.qianying.service.IManagerService;
import com.qianying.service.IProductService;
import com.qianying.service.ISupplierService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.InitConfig;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5Util;

@Controller
@RequestMapping("supplier")
public class SupplierController extends FilePathController {
	
	@Autowired
	private ISupplierService supplierService;
	@Autowired
	private IManagerService managerService;
	@Autowired///注意先后顺序
	private IProductService productService;
	@Autowired
	private ISystemParamsService systemParams;
	/**
	 * 供应商登录
	 * @param request
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
				map.put("corp_id", map.get("clerk_id"));
			} else {
				map = supplierService.checkLogin(name, comId);
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
					String openid=request.getParameter("openid");
					if(StringUtils.isNotBlank(openid)&&openid.length()>=20){
						map.put("openid", openid);
						managerService.updateOpenid(map);
					}
					request.getSession().setAttribute(
							ConfigFile.CUSTOMER_SESSION_LOGIN, map);
					success=true;
				}
			}
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 检查供应商手机号是否存在
	 * 
	 * @param request
	 * @param phone
	 * @return 存在返回false,不存在返回true
	 */
	@RequestMapping("checkPhone")
	@ResponseBody
	public ResultInfo checkPhone(HttpServletRequest request, String phone) {
		boolean success = false;
		String msg = null;
		if (StringUtils.isBlank(phone)) {
			msg = "请输入手机号!";
		} else {
			success = supplierService.checkPhone(phone);
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 供应商注册
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveUser")
	@ResponseBody
	public ResultInfo saveUser(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer error_code = 0;
		String user_id = request.getParameter("userId");
		String user_password = request.getParameter("pwd");
		String openid = request.getParameter("openid");
		Map<String,Object> check=checkRegisterParam(request, user_id);
		if (MapUtils.getBoolean(check, "b")) {
			if (supplierService.checkPhone(user_id)) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("user_id", user_id);
				map.put("movtel", user_id);
				map.put("corp_sim_name", user_id);
				map.put("corp_name", user_id);
				map.put("com_id", setComId(request));
				map.put("working_status", "否");
				map.put("user_password", MD5Util.MD5(user_password));
				map.put("weixinID",user_id);
				String corp_id = supplierService.getMaxSupplier();
				if(StringUtils.isBlank(corp_id)){
					corp_id="0";
				}
				corp_id = String.format("G%06d",
						Integer.parseInt(corp_id) + 1);
				map.put("corp_id", corp_id);
				map.put("self_id", corp_id);
				map.put("openid", openid);
				supplierService.save(map);
				//////注册自动登录//////
				map = supplierService.checkLogin(user_id, getComId());
				map.remove("user_password");
				request.getSession().setAttribute(
						ConfigFile.CUSTOMER_SESSION_LOGIN, map);
				request.getSession().setAttribute("o2o",systemParams.checkSystem("o2o"));
				request.getSession().setAttribute("prefix", getPrefix());
				request.setAttribute("ver",InitConfig.getNewVer());
				////提交客户数据到微信企业号///
				Object agentDeptId=systemParams.checkSystem("agentDeptId");
				postInfoToweixinComId(map, "供应商",agentDeptId);
				writeLog(request,corp_id,user_id,"供应商注册");
				success = true;
			} else {
				error_code = 105;// 手机号已经存在
			}
		}
		return new ResultInfo(success, msg, error_code);
	}

	/**
	 *  供应商中心
	 * @param request
	 * @return
	 */
	@RequestMapping("supplier")
	public String supplier(HttpServletRequest request) {
		Object sessionUrl=request.getSession().getAttribute("sessionUrl");
		request.getSession().removeAttribute("sessionUrl");
		if (sessionUrl!=null) {
			String pre=request.getContextPath();
			if (StringUtils.isNotBlank(pre)) {
				sessionUrl=sessionUrl.toString().replaceAll(pre, "");
			}
			LoggerUtils.info(sessionUrl);
			return "redirect:"+ sessionUrl;
		}
		String emplName=systemParams.checkSystem("emplName", "");
		if (StringUtils.isNotBlank(emplName)&&"qqy".equals(emplName)) {
			return "pc/qingyuan/supplier";
		}else{
			return "pc/supplier/supplier";
		}
	}
	/**
	 *  供应商信息
	 * @param request
	 * @return
	 */
	@RequestMapping("vendorInfo")
	public String vendorInfo(HttpServletRequest request) {
		request.setAttribute("com_id", getComId()); 
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", getComId());
		map.put("corp_id", getCustomerId(request));
		map.put("all", "all");
		List<Map<String,Object>> list= managerService.getGysTree(map);
		if (list!=null&&list.size()>0) {
			request.setAttribute("vendor", list.get(0));
		}
		return "pc/supplier/vendorInfo";
	}
	
	/**
	 *  跳转到供应商订单页面
	 * @param request
	 * @return
	 */
	@RequestMapping("gysOrder")
	public String gysOrder(HttpServletRequest request) {
		return "pc/supplier/gysOrder";
	}
	/**
	 * 已经向供应商下采购订单的数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getGysOrderList")
	@ResponseBody
	public PageList<Map<String,Object>> getGysOrderList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("vendor_id", getCustomerId(request));
		return supplierService.getGysOrderList(map);
	}
	
	/**
	 *  查看订单详情
	 * @param request
	 * @return
	 */
	@RequestMapping("gysOrderInfo")
	public String gysOrderInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		List<Map<String,Object>> listinfo= supplierService.gysOrderInfo(map);
		request.setAttribute("listinfo", listinfo);
		request.setAttribute("st_auto_no", map.get("st_auto_no"));
		return "pc/supplier/gysOrderInfo";
	}
	/**
	 * 采购订单状态更新
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReceipt")
	@ResponseBody
	public ResultInfo orderReceipt(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			String[] list=request.getParameterValues("list[]");
			map.put("list", list);
			supplierService.orderReceipt(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  采购订单跟踪页面
	 * @param request
	 * @return
	 */
	@RequestMapping("gysOrderTracking")
	public String gysOrderTracking(HttpServletRequest request) {
		return "pc/supplier/gysOrderTracking";
	}
	
	/**
	 * 向供应商提交物流信息
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeGysWuliu")
	@ResponseBody
	public ResultInfo noticeGysWuliu(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			supplierService.noticeGysWuliu(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 供应商发货,通知发货管理员已出库
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
			List<String> list=getProcessNameList(request);
			if (isMapKeyNull(map, "processName")) {
				map.put("processName", "库管装货");
			}
			int index=list.indexOf(map.get("processName"));
			String[] headships=getHeadships(request);
			try {
				map.put("headship",headships[index+1]);
			} catch (Exception e) {
				map.put("headship","发货");
			}
			map.put("clerk_name", getCustomer(request).get("clerk_name"));
			if (list.size()==(index+1)) {//流程最后一步,标识已发货
				map.put("proName", map.get("shipped"));
			}else{
				map.put("proName", list.get(index+1));
			}
			if (isMapKeyNull(map, "proName")) {
				LoggerUtils.error(list.get(index));
				LoggerUtils.error(list.get(index+1));
				map.put("proName", "已发货");
			}
			Map<String,String[]> sopn=getProcessName();
			String[] imgNames=sopn.get("imgName");//流程对应消息的图片
			String imgName="msg.png";
			if(imgNames.length>index){
				imgName=imgNames[index];
				if (StringUtils.isBlank(imgName)) {
					imgName="msg.png";
				}
			}
			map.put("imgName", imgName);
			supplierService.noticeShippingManager(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  供应商明细
	 * @param request 
	 * @return
	 */
	@RequestMapping("gather")
	public String gather(HttpServletRequest request) {
		String emplName=systemParams.checkSystem("emplName", "");
		if (StringUtils.isNotBlank(emplName)&&"qqy".equals(emplName)) {
			return "pc/qingyuan/gather";
		}else{
			return "pc/supplier/gather";
		}
	}
	
	/**
	 *  按车号汇总
	 * @param request
	 * @return
	 */
	@RequestMapping("collect")
	public String collect(HttpServletRequest request) {
		String emplName=systemParams.checkSystem("emplName", "");
		if (StringUtils.isNotBlank(emplName)&&"qqy".equals(emplName)) {
			return "pc/qingyuan/collect";
		}else{
			return "pc/supplier/collect";
		}
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("detail")
	public String detail(HttpServletRequest request) {
		String emplName=systemParams.checkSystem("emplName", "");
		if (StringUtils.isNotBlank(emplName)&&"qqy".equals(emplName)) {
			return "pc/qingyuan/detail";
		}else{
			return "pc/supplier/detail";
		}
	}

	/**
	 *  按车号汇总-列表查询
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerOrderList")
	@ResponseBody
	public List<Map<String,Object>> getCustomerOrderList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("vendor_id", getCustomerId(request));
		return supplierService.getCustomerOrderList(map);
	}
	
	
	/**
	 *  按产品汇总-类别查询
	 * @param request
	 * @return
	 */
	@RequestMapping("getItemOrderList")
	@ResponseBody
	public List<Map<String,Object>> getItemOrderList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("vendor_id", getCustomerId(request));
		return supplierService.getItemOrderList(map);
	}
	
	/**
	 * 供应商上报产品价格
	 * @param request
	 * @return
	 */
	@RequestMapping("uploading")
	public String uploading(HttpServletRequest request) {
		String emplName=systemParams.checkSystem("emplName", "");
		if (StringUtils.isNotBlank(emplName)&&"qqy".equals(emplName)) {
			return "pc/qingyuan/uploading";
		}else{
			return "pc/supplier/uploading";
		}
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getSupplierItemList")
	@ResponseBody
	public List<Map<String,Object>> getSupplierItemList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("vendor_id", getCustomerId(request));
		Object beginDate= map.get("beginDate");
		String date=DateTimeUtils.dateToStr(DateUtils.addDays(DateTimeUtils.strToDate(map.get("beginDate")+""), -1));
		map.put("beginDate",date);
		map.put("endDate", date);
		List<Map<String,Object>> list= supplierService.getSupplierItemList(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> item =  iterator.next();
			File file=new File(getUpitemItemImgPath(request,beginDate, map.get("vendor_id"), item.get("item_id")));
			if (file.exists()&&file.isDirectory()) {
				File[] fs=file.listFiles();
				List<String> imgs=new ArrayList<String>();
				for (File file2 : fs) {
					String path="../"+getComId()+"/"+file2.getPath().split("\\\\"+getComId())[1];
					path=path.replaceAll("\\\\", "/");
					imgs.add(path);
				}
				item.put("imgs", imgs);
			}
		}
		return list;
	}
	
	/**
	 * 保存上报价格
	 * @param request
	 * @return
	 */
	@RequestMapping("saveUpPrice")
	@ResponseBody
	public ResultInfo saveUpPrice(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("up_datetime", getNow());
			map.put("vendor_id", getCustomerId(request));
			map.put("m_flag", 0);
			Object imgUrl=map.get("imgUrl");map.remove("imgUrl");
			map.put("description", map.get("description").toString().replaceAll("@gysName",getCustomer(request).get("clerk_name")+""));
			msg=supplierService.saveUpPrice(map);
			String date=DateTimeUtils.dateToStr();
			File srcFile=new File(getRealPath(request)+imgUrl);//+srcFile.getName()
			File destFile=new File(getUpitemItemImgPath(request, date,map.get("vendor_id"), map.get("item_id"))+srcFile.getName());
			if (srcFile.exists()&&srcFile.isFile()) {
				 mkdirsDirectory(destFile);
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
	 * 保存修改供应商资料
	 * @param request
	 * @return
	 */
	@RequestMapping("saveSupplierInfo")
	@ResponseBody
	public ResultInfo saveSupplierInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("corp_id", getCustomerId(request));
			msg=supplierService.saveSupplierInfo(map);
			File srcDir=new File(getUserpicTempPath(request));
			if (srcDir.exists()) {
				File destDir=new File(getComIdPath(request)+"evalimg/"+map.get("corp_id"));
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
	 *  收款页面
	 * @param request
	 * @return
	 */
	@RequestMapping("receipt")
	public String receipt(HttpServletRequest request) {
		return "pc/supplier/receipt";
	}
	
	/**
	 * 获取供应商收款数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getReceiptPage")
	@ResponseBody
	public PageList<Map<String,Object>> getReceiptPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("corp_id", getCustomerId(request));
		return  supplierService.getReceiptPage(map);
	}
}
