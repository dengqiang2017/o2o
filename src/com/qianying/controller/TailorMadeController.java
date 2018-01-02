package com.qianying.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.PageList;
import com.qianying.service.ITailorMadeService;
/**
 * 定制需求
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/tailorMade")
public class TailorMadeController extends FilePathController{

//	@Autowired
//	private IProductService productService;
//	@Autowired
//	private ICustomerService customerService;
//	@Autowired
//	private IEmployeeService employeeService;
	@Autowired
	private ITailorMadeService tailorMadeService;
/**
 * 保存定制需求信息
 * @param request
 * @return
 */
@RequestMapping("saveTailorMadeInfo")
@ResponseBody
public ResultInfo saveTailorMadeInfo(HttpServletRequest request) {
	boolean success = false;
	String msg = null;
	try {
		if(getCustomer(request)==null){
			return new ResultInfo(success, "页面已过期,请重新登录客户!");
		}
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		map.put("clerk_id", getCustomerId(request));
		map.put("clerk_name", getCustomer(request).get("clerk_name"));
		//1.生成报价单基本信息
		String orderNo=tailorMadeService.saveTailorMadeInfo(map);
		//2.获取返回的报价单基本信息
		JSONObject json=new JSONObject();
		json.put("demandInfo", map.get("demandInfo"));//需求信息
		json.put("deliveryDate", map.get("deliveryDate"));//要求完成时间
		//保存需求信息到文本文件中
		saveFile(getTailorInfoJsonPath(request,orderNo), json.toString());
		//保存图片到指定文件夹下面
		if (!isMapKeyNull(map, "imgPath")) {
			String[] paths=map.get("imgPath").toString().split(",");
			if (paths!=null&&paths.length>0) {
				for (String path : paths) {
					File srcFile=new File(getRealPath(request)+path.replaceAll("\\.\\.", ""));
					File destFile=new File(getTailorInfoPath(request, orderNo)+"/"+FilenameUtils.getName(path));
					if (srcFile.exists()) {
						mkdirsDirectory(destFile);
						FileUtils.moveFile(srcFile, destFile);
					}
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
 * 获取报价单信息 
 * @param request
 * @return 按照金额降序
 */
@RequestMapping("getTailorMadeInfoPage")
@ResponseBody
public PageList<Map<String,Object>> getTailorMadeInfoPage(HttpServletRequest request) {
	Map<String,Object> map=getKeyAndValueQuery(request);
	map.put("customer_id", getUpperCustomerId(request));
	PageList<Map<String,Object>> pages=tailorMadeService.getTailorMadeInfoPage(map);
	for (Iterator<Map<String,Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
		Map<String,Object> itemmap = iterator.next();
		if (isNotMapKeyNull(itemmap, "ivt_oper_listing")) {
			String orderNo=MapUtils.getString(itemmap, "ivt_oper_listing");
			try {
				List<String> imgs= getTailorInfoImgs(request, orderNo);
				itemmap.put("imgs", imgs);
				String txt=getFileTextContent(getTailorInfoJsonPath(request, orderNo));
				if (StringUtils.isNotBlank(txt)) {//需求信息
					itemmap.put("info", JSONObject.fromObject(txt));
				}
			} catch (Exception e) {}
		}
	}
	return pages;
}
/**
 * 获取订单分页列表,定制生产需求计划数据源
 * @param request
 * @return 
 */
@RequestMapping("getTailorMadeOrderPage")
@ResponseBody
public PageList<Map<String,Object>> getTailorMadeOrderPage(HttpServletRequest request) {
	Map<String,Object> map=getKeyAndValueQuery(request);
	map.put("customer_id", getUpperCustomerId(request));
	PageList<Map<String,Object>> pages=tailorMadeService.getTailorMadeOrderPage(map);
	for (Iterator<Map<String,Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
		Map<String,Object> itemmap = iterator.next();
		String orderNo=MapUtils.getString(itemmap, "item_id");
		if (isNotMapKeyNull(itemmap, "item_id")) {
			try {
				List<String> imgs= getTailorInfoImgs(request, orderNo);
				itemmap.put("imgs", imgs);
				String txt=getFileTextContent(getTailorInfoJsonPath(request, orderNo));
				if (StringUtils.isNotBlank(txt)) {//需求信息
					itemmap.put("info", JSONObject.fromObject(txt));
				}
			} catch (Exception e) {}
		}
	}
	return pages;
}


/**
 *  
 * @param request
 * @return
 */
@RequestMapping("getTailorMadeInfo")
@ResponseBody
public Map<String,Object> getTailorMadeInfo(HttpServletRequest request) {
	Map<String,Object> map=new HashMap<String, Object>();
	String orderNo=request.getParameter("orderNo");
	if (StringUtils.isNotBlank(orderNo)) {
		try {
			List<String> imgs= getTailorInfoImgs(request, orderNo);
			map.put("imgs", imgs);
			String txt=getFileTextContent(getTailorInfoJsonPath(request, orderNo));
			if (StringUtils.isNotBlank(txt)) {//需求信息
				map.put("info", JSONObject.fromObject(txt));
			}
			return map;
		} catch (Exception e) {
		}
	}
	return null;
}

/**
 * 删除需求
 * @param request
 * @return
 */
@RequestMapping("delTailorMade")
@ResponseBody
public ResultInfo delTailorMade(HttpServletRequest request) {
	boolean success = false;
	String msg = null;
	try {
		String orderNo=request.getParameter("orderNo");
		//1.删除报价单主从表
		boolean b=tailorMadeService.delTailorMade(orderNo);
		if(b){//判断该报价单是否已经下过订单,下过订单的将不在显示出来,但是不删除需求文件,以便订单流程等其他地方使用
			//2.删除订单编号对应的文件夹
			FileUtils.deleteDirectory(getTailorInfoPath(request, orderNo));
		}
		success = true;
	} catch (Exception e) {
		msg = e.getMessage();
		e.printStackTrace();
	}
	return new ResultInfo(success, msg);
}
/***
 * 保存员工报价金额
 * @param request
 * @return
 */
@RequestMapping("saveSum_si")
@ResponseBody
public ResultInfo saveSum_si(HttpServletRequest request) {
	boolean success = false;
	String msg = null;
	try {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("mainten_clerk_id", getEmployeeId(request));
		map.put("mainten_datetime", getNow());
		tailorMadeService.saveSum_si(map);
		success = true;
	} catch (Exception e) {
		msg = e.getMessage();
		e.printStackTrace();
	}
	return new ResultInfo(success, msg);
}

/**
 *  获取客户的支付金额百分比
 * @param request
 * @return 百分比数字
 */
@RequestMapping("getPayPercentage")
@ResponseBody
public Map<String,Object> getPayPercentage(HttpServletRequest request) {
	Map<String,Object> map=getKeyAndValue(request);
	map.put("customer_id", getUpperCustomerId(request));
	return tailorMadeService.getPayPercentage(map);
}
}
