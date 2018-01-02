package com.qianying.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.PageList;
import com.qianying.service.IPreTradingService;
/**
 * 预售预购平台
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/pre")
public class PreTradingController extends FilePathController {

	@Autowired
	private IPreTradingService preTradingService;
//	/**
//	 *  展示猪的信息页面
//	 * @param request
//	 * @return
//	 */
//	@RequestMapping("infoshow")
//	public String infoshow(HttpServletRequest request) {
//		return "pc/pre/infoshow";
//	}
	/**
	 *  养殖户/预购方操作界面
	 * @param request
	 * @return
	 */
	@RequestMapping("operate")
	public String operate(HttpServletRequest request) {
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				request.setAttribute("type", "预售");
			}else{
				request.setAttribute("type", "预购");
			}
		}
		String url=tourl(request);
		if (StringUtils.isNotBlank(url)) {
			return url;
		}
		return "pc/pre/operate";
	}
	/**
	 *  我要预售信息录入界面
	 * @param request
	 * @return
	 */
	@RequestMapping("preSale")
	public String preSale(HttpServletRequest request) {
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				request.setAttribute("type", "预售");
			}else{
				request.setAttribute("type", "预购");
			}
		}
		return "pc/pre/preSale";
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductByClassName")
	@ResponseBody
	public List<Map<String,Object>> getProductByClassName(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
//		map.put("sort_name", "'商品猪','仔猪'");
		map.put("type_id", map.get("type")+""+map.get("type_id"));
		return preTradingService.getProductByClassName(map);
	}
	/**
	 *  预售信息查询界面
	 * @param request
	 * @return
	 */
	@RequestMapping("preSaleQuery")
	public String preSaleQuery(HttpServletRequest request) {
		return "pc/pre/preSaleQuery";
	}
	
	/**
	 * 预购历史查询
	 * @param request
	 * @return 返回养殖户或者收购方的预购/预售历史
	 */
	@RequestMapping("preTradingPage")
	@ResponseBody
	public PageList<Map<String,Object>> preTradingPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				map.put("customer_id", getCustomerId(request));
			}else{
				map.put("buyer_id", getCustomerId(request));
			}
		}
		if(isNotMapKeyNull(map, "type_id")&&isNotMapKeyNull(map, "type")){
			map.put("type_id","%"+ map.get("type")+""+map.get("type_id")+"%");
		}else if(isNotMapKeyNull(map, "type_id")){
			map.put("type_id","%"+map.get("type_id")+"%");
		}else if(isNotMapKeyNull(map, "type")){
			map.put("type_id","%"+ map.get("type")+"%");
		}
		return preTradingService.preTradingPage(map);
	}
	
	/**
	 *  养殖户预购确认列表界面
	 * @param request
	 * @return
	 */
	@RequestMapping("preSaleConfirmList")
	public String preSaleConfirmList(HttpServletRequest request) {
		return "pc/pre/preSaleConfirmList";
	}
	/**
	 *  养殖户预购确认界面
	 * @param request
	 * @return
	 */
	@RequestMapping("preSaleConfirmPage")
	public String preSaleConfirmPage(HttpServletRequest request) {
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				request.setAttribute("type", "预售");
			}else{
				request.setAttribute("type", "预购方");
			}
		}
		return "pc/pre/preSaleConfirmPage";
	}
	/**
	 *  养殖户预购确认数据列表
	 * @param request
	 * @return
	 */
	@RequestMapping("preSaleConfirmListQuery")
	@ResponseBody
	public List<Map<String,Object>> preSaleConfirmListQuery(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				map.put("customer_id", getCustomerId(request));
			}else{
				map.put("buyer_id", getCustomerId(request));
			}
			return preTradingService.preSaleConfirmListQuery(map);
		}else{
			return null;
		}
	}
	
	/**
	 *  我要预购信息录入界面
	 * @param request
	 * @return
	 */
	@RequestMapping("reserveBuy")
	public String reserveBuy (HttpServletRequest request) {
		//获取产品列表猪种列表
		Map<String,Object> map=getKeyAndValue(request);
		map.put("sort_name", "'商品猪','仔猪'");
		request.setAttribute("itemList",preTradingService.getProductByClassName(map));
		return "pc/pre/reserveBuy";
	}
	/**
	 *  预购信息分页查询
	 * @param request
	 * @return
	 */
	@RequestMapping("reserveBuyQuery")
	@ResponseBody
	public PageList<Map<String,Object>> reserveBuyQuery(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				map.put("customer_id", getCustomerId(request));
			}else{
				map.put("buyer_id", getCustomerId(request));
			}
			return preTradingService.reserveBuyQuery(map);
		}else{
			return null;
		}
	}
	/**
	 *  预购确认列表界面
	 * @param request
	 * @return
	 */
	@RequestMapping("reserveBuyConfirmList")
	public String reserveBuyConfirmList(HttpServletRequest request) {
		return "pc/pre/reserveBuyConfirmList";
	}
	/**
	 *  预购确认界面
	 * @param request
	 * @return
	 */
	@RequestMapping("reserveBuyConfirmPage")
	public String reserveBuyConfirmPage(HttpServletRequest request) {
		if(getCustomer(request)!=null){
			if(getCustomerId(request).startsWith("CS1C001")){
				request.setAttribute("type", "预售");
			}else{
				request.setAttribute("type", "预购方");
			}
		}
		return "pc/pre/preSaleConfirmPage";
	}
//	/**
//	 *  
//	 * @param request
//	 * @return
//	 */
//	@RequestMapping("reserveBuyConfirmInfo")
//	@ResponseBody
//	public List<Map<String,Object>> reserveBuyConfirmInfo(HttpServletRequest request) {
//		Map<String,Object> map=getKeyAndValueQuery(request);
//		if (getCustomer(request)!=null) {
//			map.put("buyer_id", getCustomerId(request));
//		}
//		return preTradingService.preSaleConfirmListQuery(map);
//	}
	/**
	 * 保存预售信息
	 * @param request
	 * @return
	 */
	@RequestMapping("savePre")
	@ResponseBody
	public ResultInfo savePre(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "list")) {
				msg="没有数据";
			}else{
				if(getCustomer(request)!=null){
					map.put("customer_id", getCustomerId(request));
					map.put("customer_name", getCustomer(request).get("clerk_name"));
					msg=preTradingService.savePre(map);
				}else{
					msg="登录信息错误!";
				}
				if(msg==null){
					success = true;
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			if(!msg.contains("挂价")){
				e.printStackTrace();
			}
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getPreImgs")
	@ResponseBody
	public List<String> getPreImgs(HttpServletRequest request) {
		List<String> list=new ArrayList<>();
		String no=request.getParameter("no");
		File file=new File(getComIdPath(request)+"preimg/"+no);
		if (file.exists()&&file.isDirectory()) {
			for (File file2 : file.listFiles()) {
				String path="../"+getComId()+file2.getPath().split("\\\\"+getComId())[1];
				path=path.replaceAll("\\\\", "/");
				list.add(path);
			}
		}
		return list;
	}
	/**
	 * 养殖户确认
	 * @param request
	 * @return
	 */
	@RequestMapping("preSaleConfirm")
	@ResponseBody
	public ResultInfo preSaleConfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(getCustomer(request)!=null){
				if(getCustomerId(request).startsWith("CS1C001")){
					map.put("customer_id", getCustomerId(request));
					map.put("m_flag", "1");
				}else{
					map.put("buyer_id", getCustomerId(request));
					map.put("m_flag", "2");
				}
				map.put("now", getNow());
				msg=preTradingService.preSaleConfirm(map);
				success = true;
			}else{
				msg="请使用养殖户或者贩卖方账号登录!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 收购方确认
	 * @param request
	 * @return
	 */
	@RequestMapping("reserveBuyConfirm")
	@ResponseBody
	public ResultInfo reserveBuyConfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(getCustomer(request)!=null){
				map.put("buyer_id", getCustomerId(request));
				map.put("now", getNow());
				map.put("m_flag", "2");
				msg=preTradingService.preSaleConfirm(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
 
	/**
	 *  获取指定猪种的平均 养殖户挂价,数量和收购方挂价,数量
	 * @param request
	 * @return
	 */
	@RequestMapping("getPreAverageInfo")
	@ResponseBody
	public List<Map<String,Object>> getPreAverageInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("type_id", map.get("type")+""+map.get("type_id"));
		return preTradingService.getPreAverageInfo(map);
	}
	
	/**
	 *  选择预售/预购方页面
	 * @param request
	 * @return
	 */
	@RequestMapping("preCustomerSelect")
	public String preCustomerSelect(HttpServletRequest request) {
		return "pc/pre/preCustomerSelect";
	}
	
	/**
	 *  获取指定猪种下的预购方/预售方
	 * @param request
	 * @return 预购方或者预售方预售相关信息
	 */
	@RequestMapping("getPreCustomerInfo")
	@ResponseBody
	public List<Map<String,Object>> getPreCustomerInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(isNotMapKeyNull(map, "type_id")&&isNotMapKeyNull(map, "type")){
			map.put("type_id","%"+ map.get("type")+""+map.get("type_id")+"%");
		}else if(isNotMapKeyNull(map, "type_id")){
			map.put("type_id","%"+map.get("type_id")+"%");
		}else if(isNotMapKeyNull(map, "type")){
			map.put("type_id","%"+ map.get("type")+"%");
		}
		map.put("customer_id", map.get("customer_id")+"%");
		return preTradingService.getPreCustomerInfo(map);
	}
	/**
	 * 修改预售/预购的挂价
	 * @param request
	 * @return
	 */
	@RequestMapping("editGuajia")
	@ResponseBody
	public ResultInfo editGuajia(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=preTradingService.editGuajia(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存撮合信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveCuoheInfo")
	@ResponseBody
	public ResultInfo saveCuoheInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
//				if(isMapKeyNull(map, "ygfList")||!map.get("ygfList").toString().startsWith("[")){
			if(isMapKeyNull(map, "ygfjson")){
				msg="数据错误-预购方为空!";
			}else if(isMapKeyNull(map, "ysfList")||!map.get("ysfList").toString().startsWith("[")){
				msg="数据错误!-预售方为空";
			}else{
				map.put("clerk_id",getEmployeeId(request));
				if(isNotMapKeyNull(map, "type_id")){
					map.put("type_id", map.get("type")+""+map.get("type_id"));
				}
				msg=preTradingService.saveCuoheInfo(map);
				if(StringUtils.isBlank(msg)){
					success = true;
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 撮合历史查询
	 * @param request
	 * @return
	 */
	@RequestMapping("platformHistoryPage")
	@ResponseBody
	public PageList<Map<String,Object>> platformHistoryPage(HttpServletRequest request) {
		 Map<String,Object> map=getKeyAndValueQuery(request);
		 if(isNotMapKeyNull(map, "type_id")&&isNotMapKeyNull(map, "type")){
				map.put("type_id","%"+ map.get("type")+""+map.get("type_id")+"%");
			}else if(isNotMapKeyNull(map, "type_id")){
				map.put("type_id","%"+map.get("type_id")+"%");
			}else if(isNotMapKeyNull(map, "type")){
				map.put("type_id","%"+ map.get("type")+"%");
			}
		return preTradingService.platformHistoryPage(map);
	}
	
	/**
	 *  获取撮合相关权限
	 * @param request
	 * @return
	 */
	@RequestMapping("getPreAuth")
	@ResponseBody
	public Map<String,Object> getPreAuth(HttpServletRequest request) {
		Map<String, Object> mapval = getTxtKeyVal(request,
				getEmployeeId(request));
		Map<String,Object> map=new HashMap<>();
		if (mapval!=null) {
			map.put("cuohe", mapval.get("cuohe"));
			map.put("cuohebtn", mapval.get("cuohebtn"));
			map.put("cuoheHistory", mapval.get("cuoheHistory"));
		}
		return map;
	}
}
