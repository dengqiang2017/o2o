package com.qianying.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.PageList;
import com.qianying.service.IClientService;
import com.qianying.service.IOrderTrackingService;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
/**
 * 订单跟踪流程
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/orderTrack")
public class OrderTrackingController extends FilePathController {
	@Autowired
	private IOrderTrackingService orderTrackService;
	@Autowired
	private IClientService clientService;
	/**
	 *  司机运货单
	 * @param request
	 * @return
	 */
	@RequestMapping("waybill")
	public String waybill(HttpServletRequest request) {
		//TODO 司机运货单
		String id= request.getParameter("seeds_id");
		if(StringUtils.isNotBlank(id)){
			String ids=id;
			if(id.contains("[")){
				ids=id.replace("[", "");
			}
			if(ids.contains("]")){
				ids=ids.replace("]", "");
			}
			ids=ids.replace("%20", "");
			List<Map<String,Object>> list= orderTrackService.getOrderInfoByIdsDrive(ids);
			if(list!=null&&list.size()>0){
				request.setAttribute("seeds_id", id);
				request.setAttribute("com_id", list.get(0).get("com_id"));
				String erweima="../001/qrcode/"+id+".jpg";
				request.setAttribute("erweima", erweima);
				request.setAttribute("list", list);
				request.setAttribute("Status_OutStore", list.get(0).get("Status_OutStore"));
			}else{
				request.setAttribute("ordertype", "订单已结束!");
			}
			boolean fenx=false;
			if(getCustomer(request)!=null){
				fenx=true;
			}else if(getEmployee(request)!=null){
				fenx=true;
			}else{
				fenx=false;
			}
			request.setAttribute("fenx", fenx);//客户指派司机拉货,只需要客户将拉货页面分享给司机
		}else{
			request.setAttribute("ordertype", "订单已结束!");
		}
		return "pc/near/waybillNew";
	}
	
	/**
	 *  获取司机拉货详情
	 * @param request
	 * @return
	 */
	@RequestMapping("getDriveOrderInfo")
	@ResponseBody
	public List<Map<String,Object>> getDriveOrderInfo(HttpServletRequest request)throws Exception {
		Map<String,Object> map=getKeyAndValue(request);
		if(isNotMapKeyNull(map, "seeds_id")){
			return  orderTrackService.getOrderInfoByIdsDrive(map.get("seeds_id").toString());
		}else{
			LoggerUtils.error(LogUtil.getIpAddr(request));
			return null;
		}
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
		Object headship=getEmployee(request).get("headship");
		String id= request.getParameter("seeds_id");
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
			List<Map<String,Object>> list= orderTrackService.getOrderInfoByIds(id);
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
	 *  供应商扫描进行装货
	 * @param request
	 * @return
	 */
	@RequestMapping("supplierDriverWaybillDetail")
	public String supplierDriverWaybillDetail(HttpServletRequest request) {
		String[] pros=getProcessName(request);
		int j=0;
		for (int i = 0; i < pros.length; i++) {
			String item=pros[i];
			if(item.contains("拉货")||item.contains("司机")){
				j=i;
				break;
			}
		}
		String id= request.getParameter("seeds_id");
		if(StringUtils.isNotBlank(id)){
			request.setAttribute("seeds_id", id);
			String type= request.getParameter("type");
			request.setAttribute("type", type);
			String ids=id.replace("[", "").replace("]", "").replace("%20", "");
			String proName=getProcessName(request, j+1);
			List<Map<String,Object>> list= orderTrackService.getOrderInfoByIds(ids);
			if(list.size()==0){
				proName=getProcessName(request, j+2);
				list= orderTrackService.getOrderInfoByIds(ids);
			}
			request.setAttribute("proName", proName);
			request.setAttribute("list", list);
		}
		return "pc/orderTrack/supplierDriverWaybillDetail";
	}
	/**
	 * 通知库管
	 * @param request
	 * @return 
	 */
	@RequestMapping("noticeKuguan")
	@ResponseBody
	public ResultInfo noticeKuguan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderTrackService.noticeKuguan(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  司机确认重量
	 * @param request
	 * @return
	 */
	@RequestMapping("successLoad")
	public String successLoad(HttpServletRequest request) {
		///获取司机信息和订单总重量
		Map<String,Object> map=getKeyAndValue(request);
		if(map.get("seeds_id")!=null){
			List<Map<String, Object>> orderinfo=orderTrackService.getOrderInfoByIds(map.get("seeds_id").toString());
			BigDecimal zsl=new BigDecimal(0);
			BigDecimal casing_unitzsl=new BigDecimal(0);
			for (Map<String, Object> map2 : orderinfo) {
				BigDecimal pack_unit=new BigDecimal(map2.get("pack_unit").toString());
				if(pack_unit.compareTo(BigDecimal.ONE)>0){//大于0  使用除法
					zsl=zsl.add(new BigDecimal(map2.get("sd_oq").toString()).divide(pack_unit));
				}else{//小于0使用乘法
					zsl=zsl.add(new BigDecimal(map2.get("sd_oq").toString()).multiply(pack_unit));
				}
				casing_unitzsl=casing_unitzsl.add(new BigDecimal(map2.get("sd_oq").toString()));
			}
			request.setAttribute("list", orderinfo);
			DecimalFormat ft=new DecimalFormat("0.00");
			request.setAttribute("zsl", ft.format(zsl));
			request.setAttribute("casing_unitzsl", ft.format(casing_unitzsl));
			String id= request.getParameter("seeds_id");
			request.setAttribute("seeds_id", id);
		}
		return "pc/orderTrack/successLoad";
	}
	public static void main(String[] args) {
		BigDecimal zsl=new BigDecimal(12.11200);
		System.out.println(new java.text.DecimalFormat("0").format(zsl));
	}
	
	/**
	 *  门卫验证过磅消息
	 * @param request
	 * @return
	 */
	@RequestMapping("verify")
	public String verify(HttpServletRequest request) {
		///获取司机信息和订单总重量
		Map<String,Object> map=getKeyAndValue(request);
		if(map.get("seeds_id")!=null){
		List<Map<String, Object>> orderinfo=orderTrackService.getOrderInfoByIds(map.get("seeds_id").toString());
		BigDecimal zsl=new BigDecimal(0);
		BigDecimal casing_unitzsl=new BigDecimal(0);
		for (Map<String, Object> map2 : orderinfo) {
			BigDecimal pack_unit=new BigDecimal(map2.get("pack_unit").toString());
			if(pack_unit.compareTo(BigDecimal.ONE)>0){//大于0  使用除法
				zsl=zsl.add(new BigDecimal(map2.get("sd_oq").toString()).divide(pack_unit));
			}else{//小于0使用乘法
				zsl=zsl.add(new BigDecimal(map2.get("sd_oq").toString()).multiply(pack_unit));
			}
			casing_unitzsl=casing_unitzsl.add(new BigDecimal(map2.get("sd_oq").toString()));
		}
		request.setAttribute("list", orderinfo);
		DecimalFormat ft=new DecimalFormat("0.00");
		request.setAttribute("zsl", ft.format(zsl));
		request.setAttribute("casing_unitzsl", ft.format(casing_unitzsl));
		String id= request.getParameter("seeds_id");
		request.setAttribute("seeds_id", id);
		}
		return "pc/orderTrack/verify";
	}
	/**
	 * 通知内勤
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeNeiqing")
	@ResponseBody
	public ResultInfo noticeNeiqing(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderTrackService.noticeNeiqing(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 通知下采购订单或者下生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("noticePurchasingOrPPlan")
	@ResponseBody
	public ResultInfo noticePurchasingOrPPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(isNotMapKeyNull(map, "shipped")&&isNotMapKeyNull(map, "seeds_id")){
				orderTrackService.noticePurchasingOrPPlan(map);
				success = true;
			}else{
				msg="参数缺少!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 采购确认供应商有货,通知安排物流
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeAnPaiWuliu")
	@ResponseBody
	public ResultInfo noticeAnPaiWuliu(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderTrackService.noticeAnPaiWuliu(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 通知司机拉货
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeDrive")
	@ResponseBody
	public ResultInfo noticeDrive(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderTrackService.noticeDrive(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 通知已经出厂
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeOutedFactory")
	@ResponseBody
	public ResultInfo noticeOutedFactory(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderTrackService.noticeOutedFactory(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 员工通知发货管理员
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
			
//			List<String> list=getProcessNameList(request);
			if (isMapKeyNull(map, "processName")) {
				map.put("processName", "库管装货");
			}
//			int index=list.indexOf(map.get("processName"));
//			String[] headships=getHeadships(request);
//			try {
//				map.put("headship",headships[index+1]);
//			} catch (Exception e) {
//				map.put("headship","发货");
//			}
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
//			if (list.size()==(index+1)) {//流程最后一步,标识已发货
//				map.put("proName", map.get("shipped"));
//			}else{
//				map.put("proName", list.get(index+1));
//			}
//			Map<String,String[]> sopn=getProcessName();
//			String[] imgNames=sopn.get("imgName");//流程对应消息的图片
//			String imgName="msg.png";
//			if(imgNames.length>index){
//				imgName=imgNames[index];
//				if (StringUtils.isBlank(imgName)) {
//					imgName="msg.png";
//				}
//			}
//			map.put("imgName", imgName);
			String seeds_id=MapUtils.getString(map, "seeds_id");
			if (seeds_id.startsWith("[")) {
				seeds_id=seeds_id.replaceAll("[", "").replaceAll("]", "");
			}
			if (seeds_id.endsWith(",")) {
				seeds_id=seeds_id.substring(0, seeds_id.length()-1);
			}
			map.put("seeds_id", seeds_id);
			orderTrackService.noticeShippingManager(map);
			success = true;
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
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("customer_id", getUpperCustomerId(request));
			map.put("clerk_name", getCustomer(getRequest()).get("clerk_name"));
			orderTrackService.confimShouhuo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
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
			String params=request.getParameter("params");
			map.put("time", getNow());
			Object corp_name=getCustomer(request).get("clerk_name");
			Object customer_id=getCustomerId(request);
			if (StringUtils.isNotBlank(params)&&params.startsWith("[")) {
				JSONArray jsons=JSONArray.fromObject(map.get("params"));
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					map.put("name",corp_name);
					map.put("id",customer_id);
					saveEvalInfo(request, json, map);
				}
			}else{///直接获取相关参数名
				map.put("name",corp_name);
				map.put("id",customer_id);
				saveEvalInfo(request,map);
			}
			if(!isMapKeyNull(map, "imageUrl")){
				String[] imgs=map.get("imageUrl").toString().split(",");
				for (String img : imgs) {
					File src=new File(getRealPath(request)+img);
					if (src.exists()&&src.isFile()) {
						src.delete();
					}
				}
			}
			JSONObject json=new JSONObject();
			json.put("time", getNow());
			json.put("content", "订单已评价");
			map.put("type", "评价");
			map.put("customer_id", getCustomerId(request));
			msg=clientService.saveJinbiInfo(map);
			saveFile(getOrderHistoryPath(map.get("orderNo"),map.get("item_id")), json.toString()+",", true);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存评价信息
	 * @param request
	 * @param json
	 * @param map
	 * @throws IOException
	 */
	private void saveEvalInfo(HttpServletRequest request,
			Map<String, Object> map) {
		map.put("Status_OutStore", "已结束");
		orderTrackService.updateOrderState(map);
		if(!isMapKeyNull(map, "imageUrl")){
			String[] imgs=map.get("imageUrl").toString().split(",");
			for (String img : imgs) {
				File src=new File(getRealPath(request)+img);
				if(src.exists()){
					String imageUrl=map.get("com_id")+"/eval/"+map.get("orderNo")+"/"+map.get("item_id")+"/"+src.getName();
					File dest=new File(getRealPath(request)+imageUrl);
					if (!dest.getParentFile().exists()) {
						dest.getParentFile().mkdirs();
					}
					try {
						FileUtils.moveFile(src, dest);
					} catch (Exception e) {}
				}
			}
		}
		map.remove("imageUrl");
		map.remove("Status_OutStore");
		map.remove("params");
		JSONObject jsonm=JSONObject.fromObject(map);
		saveFile(getOrderEvalFilePath(request,map.get("com_id"),map.get("orderNo"),map.get("item_id")), jsonm.toString());
	}
	/**
	 * 保存评价信息
	 * @param request
	 * @param json
	 * @param map
	 * @throws IOException
	 */
	private void saveEvalInfo(HttpServletRequest request, JSONObject json, Map<String, Object> map) throws IOException {
//		json.put("Status_OutStore", "已结束");
//		orderTrackService.updateOrderState(json);
		if(!isMapKeyNull(map, "imageUrl")){
			String[] imgs=map.get("imageUrl").toString().split(",");
			for (String img : imgs) {
				File src=new File(getRealPath(request)+img);
				if(src.exists()){
					String imageUrl=json.get("com_id")+"/eval/"+json.get("orderNo")+"/"+json.get("item_id")+"/"+src.getName();
					File dest=new File(getRealPath(request)+imageUrl);
					if (!dest.getParentFile().exists()) {
						dest.getParentFile().mkdirs();
					}
					try {
						FileUtils.copyFile(src, dest);
					} catch (Exception e) {}
				}
			}
		}
		json.remove("imageUrl");
		JSONObject jsonm=JSONObject.fromObject(map);
		jsonm.remove("params");
		jsonm.remove("imageUrl");
		jsonm.remove("orderNo");
		jsonm.remove("item_id");
		saveFile(getOrderEvalFilePath(request,json.get("com_id"),json.get("orderNo"),json.get("item_id")), jsonm.toString());
	}
//	private String getImgToJsonFile(JSONObject json){
//		String imageUrl=json.get("com_id")+"/eval/"+json.get("orderNo")+"/"+json.get("item_id")+"/";
//		File dest=new File(getRealPath(getRequest())+imageUrl);
//		String imgs="";
//		if (dest!=null&&dest.exists()) {
//			for (File item : dest.listFiles()) {
//				if (json.has("imgs")) {
//					imgs=json.getString("imgs");
//					imgs=imageUrl+item.getName()+","+imgs;
//				}else{
//					imgs=imageUrl+item.getName();
//				}
//			}
//		}
//		
//		return imgs;
//	}
	/**
	 * 获取订单评价信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderEvalInfo")
	@ResponseBody
	public JSONObject getOrderEvalInfo(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		String item_id=request.getParameter("item_id");
		String com_id=request.getParameter("com_id");
		String type=request.getParameter("type");
		if(StringUtils.isNotBlank(type)){
			type=type+"/";
		}else{
			type="";
		}
		String map=getFileTextContent(getOrderEvalFilePath(request,com_id, orderNo,item_id));
		if(StringUtils.isNotBlank(map)){
			JSONObject json=JSONObject.fromObject(map);
			File dest=new File(getRealPath(request)+com_id+"/eval/"+type+orderNo+"/"+item_id+"/");
			if(dest.exists()){
				File[] files=dest.listFiles();
				List<String> list=new ArrayList<String>();
				for (File item : files) {
					String[] path=item.getPath().split("\\\\"+com_id);
					String pathimg=com_id+path[1];
					pathimg=pathimg.replaceAll("\\\\", "/");
					list.add(pathimg);
				}
				json.put("imgs", list);
			}
			return json;
		}
		return null;
	}	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderInfoByIds")
	@ResponseBody
	public List<Map<String,Object>> getOrderInfoByIds(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return orderTrackService.getOrderInfoByIds(map.get("seeds_id")+"");
	}
	
	/**
	 *  获取订单信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderInfo")
	@ResponseBody
	public Map<String,Object> getOrderInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		String params=request.getParameter("params");
		if(StringUtils.isNotBlank(params)){
			String[] pars=params.split("&");
			for (String str : pars) {
				map.put(str.split("=")[0], str.split("=")[1]);
			}
		}
		Map<String,Object> maplist=new HashMap<String, Object>();
		//获取展示订单信息
		List<Map<String,Object>> list=orderTrackService.getOrderInfoByIds(map.get("seeds_id")+"");
		maplist.put("orderInfo", list);
		//获取订单跟踪文本消息
		String msg=getFileTextContent(getOrderHistoryPath(map.get("orderNo"), map.get("item_id")));
		if (StringUtils.isNotBlank(msg)) {
			msg="["+msg+"]";
			JSONArray jsons=JSONArray.fromObject(msg);
			maplist.put("historyInfo", jsons);
		}
		return maplist;
	}
	 
	/**
	 * 获取订单流程消息
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderHistory")
	@ResponseBody
	public JSONArray getOrderHistory(HttpServletRequest request) {
		String msg = null;
			Map<String,Object> map=getKeyAndValue(request);
			  msg=getFileTextContent(getOrderHistoryPath(map.get("orderNo"), map.get("item_id")));
			if (StringUtils.isNotBlank(msg)) {
				if(msg.endsWith(",")){
					msg=msg.substring(0, msg.length()-1);
				}
				msg=msg.trim();
				msg="["+msg+"]";
				return JSONArray.fromObject(msg);
			}
			return null;
	}
//	@RequestMapping("getOrderHistory")
//	@ResponseBody
//	public ResultInfo getOrderHistory(HttpServletRequest request) {
//		boolean success = false;
//		String msg = null;
//		try {
//			Map<String,Object> map=getKeyAndValue(request);
//			msg=getFileTextContent(getOrderHistoryPath(map.get("orderNo"), map.get("item_id")));
//			if (StringUtils.isNotBlank(msg)) {
//				if(msg.endsWith(",")){
//					msg=msg.substring(0, msg.length()-1);
//				}
//				msg="["+msg+"]";
//			}
//			success = true;
//		} catch (Exception e) {
//			msg = e.getMessage();
//			e.printStackTrace();
//		}
//		return new ResultInfo(success, msg);
//	}
	//////////////////////////
	/**
	 * 订单跟踪,提交物流分流部分
	 * @param request
	 * @return
	 */
	@RequestMapping("saveHandle")
	@ResponseBody
	public ResultInfo saveHandle(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=orderTrackService.saveHandle(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	///////////////////
	/**
	 *  安排物流消息发送给员工对应的跳转链接
	 * @param request
	 * @return
	 */
	@RequestMapping("employeeLogistics")
	public String employeeLogistics(HttpServletRequest request) {
		
		List<Map<String,Object>> list=orderTrackService.getOrderInfoByIds(request.getParameter("seeds_id"));
		request.setAttribute("list", list);
		
		return "pc/orderTrack/logistics";
	}
	
	/**
	 *  安排物流消息发送给客户对应的跳转链接
	 * @param request
	 * @return
	 */
	@RequestMapping("customerLogistics")
	public String customerLogistics(HttpServletRequest request) {
		
		return "pc/orderTrack/logistics";
	}
	
	/**
	 *  安排物流消息发送给第三方物流
	 * @param request
	 * @return
	 */
	@RequestMapping("thirdLogistics")
	public String thirdLogistics(HttpServletRequest request) {

		return "pc/orderTrack/logistics";
	}
	
	/**
	 *  安排物流发送给供应商
	 * @param request
	 * @return
	 */
	@RequestMapping("supplierLogistics")
	public String supplierLogistics(HttpServletRequest request) {
		
		return "pc/orderTrack/logistics";
	}
	/**
	 * 物流经办人提交司机拉货信息
	 * @param request
	 * @return
	 */
	@RequestMapping("postWuliu")
	@ResponseBody
	public ResultInfo postWuliu(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			orderTrackService.postWuliu(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	
	/**
	 *  从订单从表中获取司机历史信息,
	 * @param rows 记录数
	 * @param filedName 查询字段名  HYS,Kar_paizhao
	 * @return 获取前10条
	 */
	@RequestMapping("getWuliuByOrder")
	@ResponseBody
	public List<Map<String,Object>> getWuliuByOrder(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (isMapKeyNull(map, "filedName")) {
			return null;
		}
		return orderTrackService.getWuliuByOrder(map);
	}
	
	
/**
 * 获取待处理订单数据
 * @param type 生产或者采购
 * @param request
 * @return
 */
@RequestMapping("getWaitingHandleOrderPage")
@ResponseBody
public PageList<Map<String,Object>> getWaitingHandleOrderPage(HttpServletRequest request) {
	Map<String,Object> map=getKeyAndValueQuery(request);
	if (isNotMapKeyNull(map, "type_id")) {
		map.put("type_id", map.get("type_id")+"%");
	}
	return  orderTrackService.getWaitingHandleOrderPage(map);
}
}
