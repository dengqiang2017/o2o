package com.qianying.controller.business;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.LabelCell;
import jxl.NumberCell;
import jxl.Sheet;
import jxl.Workbook;
import net.sf.excelutils.ExcelUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.controller.FilePathController;
import com.qianying.page.PageList;
import com.qianying.page.ProductQuery;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.IProductService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.InitConfig;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;

/**
 * 产品管理模块
 * 
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/product")
@Component
//@Scope("prototype")
public class ProductController extends FilePathController {

	@Autowired
	protected IProductService productService;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private ISystemParamsService systemParamsService;
	@Autowired
	private ICustomerService customerService;
	@Autowired
	private IEmployeeService employeeService;
//	@Scheduled(cron = "0/30 * * * * ?")  
//	public void connDB() {
//	}
	@Scheduled(fixedRate = 1000*30)
	public void connDB() {
		if(ConfigFile.NOSQL){
			return;
		}
		InitConfig.initLoad();
		productService.connDB();
	}
	/**
	 * 去掉第一个和最后一个分号
	 * @param item_color
	 * @return
	 */
	private String delbeginendfen(String item_color) {
		if (item_color.startsWith(";")) {
			item_color=item_color.substring(1, item_color.length());
		}
		if (item_color.startsWith(";")) {
			item_color=item_color.substring(0, item_color.length()-1);
		}
		return item_color;
	}
	/**
	 * 替换字符串中的中文分号和全角分号
	 * @param map
	 * @param key 替换字段
	 * @return
	 */
	private Map<String,Object> getFenge(Map<String,Object> map, String key) {
		if (isNotMapKeyNull(map, key)) {
			String item_color=MapUtils.getString(map,key).replaceAll("；", ";");
			map.put(key, delbeginendfen(item_color));
		}
		return map;
	}
	/**
	 * 保存或者更新产品
	 * @param request
	 * @return
	 */
	@RequestMapping("save")
	@ResponseBody
	public ResultInfo save(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		int type=0;
		String item_id = request.getParameter("item_id");
		if (StringUtils.isBlank(item_id)) {
			//1.获取最大产品编号
			item_id=productService.getMaxItem_id();
			item_id=String.format("CP%06d", Integer.parseInt(item_id)+1);
			type=1;
		}
		String cicun=request.getParameter("cicun");
		int newWidth=300;
		try {
			newWidth=Integer.parseInt(cicun);
		} catch (Exception e) {}
		//////////////////////////
		Map<String, Object> map = getKeyAndValue(request,"item_id");
		map.remove("cpslpath");
		map.remove("cicun");
		map.put("maintenance_datetime",getNow());
		if (StringUtils.isBlank(request.getParameter("peijian_id"))) {
			map.put("peijian_id", item_id);
		}
		map.put("item_id", item_id);
		map.remove("imgurl");
		getFenge(map, "item_color");
		getFenge(map, "item_type");
		String mainImg=null;
		if (isNotMapKeyNull(map, "mainImg")) {
			mainImg=map.get("mainImg").toString();
			map.remove("mainImg");
			String[] imgs=mainImg.split(",");
			StringBuffer mainImgpath=new StringBuffer();
			for (String img : imgs) {
				File srcFile=new File(getRealPath(request)+img);
				mainImgpath.append("/").append(getComId()).append("/img/").append(map.get("item_id")).append("/cp/").append(srcFile.getName()).append(",");
				if (img.contains("temp")) {
					File destFile=new File(getComIdPath(request)+"img/"+map.get("item_id")+"/cp/"+srcFile.getName());
					try {
						if (srcFile.exists()&&srcFile.isFile()) {
							if (destFile.exists()&&destFile.isFile()) {
								destFile.delete();
							}else{
								mkdirsDirectory(destFile);
							}
							FileUtils.moveFile(srcFile, destFile);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			File file=new File(getComIdPath(request)+"img/"+map.get("item_id")+"/cp.txt");
			saveFile(file, mainImgpath.toString());
		}
		if (isNotMapKeyNull(map, "coverImg")) {
			String coverImg=map.get("coverImg").toString();
			map.remove("coverImg");
			if (coverImg.contains("temp")) {
				File srcFile=new File(getRealPath(request)+coverImg);
				if (srcFile.exists()&&srcFile.isFile()) {
					File destFile=new File(getComIdPath(request)+"img/"+map.get("item_id")+"/sl.jpg");
					try {
						if (destFile.exists()&&destFile.isFile()) {
							destFile.delete();
						}else{
							mkdirsDirectory(destFile);
						}
						imgResize(srcFile, destFile,newWidth, 0.5f); 
						if (srcFile.exists()&&srcFile.isFile()) {
							srcFile.delete();
						}
					} catch (Exception e) {}
				}
				
			}
		}
		if (type==1) {
			productService.save(map);
		} else {
			productService.update(map);
		}
		msg=item_id;
		//////////////////////////////////////////////////////
		///获取修改,删除的同图片信息
//		String imgurl=request.getParameter("imgurl");
//		if (StringUtils.isNotBlank(imgurl)) {
//			String[] imgedits=imgurl.split("_");
//			for (String imgedit : imgedits) {
//				LoggerUtils.info(imgedit);
//				JSONObject imgjson=JSONObject.fromObject(imgedit);
//				String oldimg=imgjson.optString("oldimg");
//				String newimg=imgjson.optString("newimg");
//				String delimg=imgjson.optString("delimg");
//				String alink=imgjson.optString("alink");
//				if (StringUtils.isNotBlank(newimg)&&StringUtils.isNotBlank(oldimg)) {
//					oldimg=oldimg.replace("..", "");
//					oldimg=oldimg.split("\\.")[0]+".";
//					newimg=newimg.replace("..", "");
//					newimg=newimg.split("\\?")[0];
//					if (!oldimg.equals(newimg)) {
//						File destFile=new File(getRealPath(request)+oldimg+FilenameUtils.getExtension(newimg));
//						File srcFile=new File(getRealPath(request)+newimg);
//						LoggerUtils.info(destFile.getPath());
//						LoggerUtils.info(srcFile.getPath());
//						if (srcFile.exists()) {
//							if (destFile.exists()&&destFile.isFile()) {
//								destFile.delete();
//							}
//							try {
//								FileUtils.moveFile(srcFile, destFile);
//							} catch (Exception e) {
//								e.printStackTrace();
//							}
//						}
//					}
//				}else if (StringUtils.isNotBlank(delimg)) {
//					delimg=delimg.replace("..", "");
//					File cpFile=new File(getRealPath(request)+"/"+delimg);
//					if (cpFile.exists()&&cpFile.isFile()) {
//						cpFile.delete();
//					}
//				}
//			}
//		}
//		try{
//			success=imghandle(request, item_id,"/cp/");
//		} catch (IOException e) {
//			msg=e.getMessage();
//			e.printStackTrace();
//		}
//		try{
//			success=imghandle(request, item_id,"/xj/");
//		} catch (IOException e) {
//			msg=e.getMessage();
//			e.printStackTrace();
//		}
//		try {
//			String cpslpath=request.getParameter("cpslpath");
//			if(StringUtils.isNotBlank(cpslpath)){
//				File srcFile=new File(getRealPath(request)+cpslpath);
//				File destFile=new File(getComIdPath(request)+"img/"+item_id+"/sl.jpg");
//				if (destFile.exists()&&destFile.isFile()) {
//					destFile.delete();
//				}
//				if(!destFile.getParentFile().exists()){
//					destFile.getParentFile().mkdirs();
//				}
//				imgResize(srcFile, destFile,newWidth, 0.5f); 
//				if (srcFile.exists()&&srcFile.isFile()) {
//					srcFile.delete();
//				}
//			}
//		} catch (Exception e) {
//			LoggerUtils.error(e.getMessage());
//		}
		success=true;
		return new ResultInfo(success, msg);
	}
	@RequestMapping("updateProFile")
	@ResponseBody
	public ResultInfo updateProFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//1.遍历产品图片文件夹
			String basePath=getRealPath(request);
			msg=productService.updateProFile(basePath);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取产品名称
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductName")
	@ResponseBody
	public List<String> getProductName(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("rows", 10);
		return productService.getProductName(map);
	}
	
	
	/**
	 * 图片处理
	 * @param request
	 * @param item_id 产品编号
	 * @param imgtype 图片类型
	 * @throws IOException
	 */
	private boolean imghandle(HttpServletRequest request, String item_id,String imgtype)
			throws IOException {
		boolean success = false;
		File xjFile=new File(getRealPath(request)+"temp/"+getComId()+imgtype);
		File[] xjimgs=xjFile.listFiles();
		if (xjimgs!=null&&xjimgs.length>0) {
			///1.获取产品图片最大编号
			File cp=new File(getRealPath(request)+getComId()+"/img/"+item_id+imgtype);
			int index = getMaxFileName(cp);
			for (int i = 0; i < xjimgs.length; i++) {
				File srcFile=xjimgs[i];
				//目标路径
				StringBuffer buffer=new StringBuffer(getRealPath(request));
				buffer.append("/"+getComId()+"/").append("img/").
				append(item_id).append(imgtype).append(i+index).append(".").append(FilenameUtils.getExtension(srcFile.getName()));
				File destFile=new File(buffer.toString());
				if (srcFile.exists()&&srcFile.isFile()) {
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					FileUtils.moveFile(srcFile, destFile);
					success=true;
				}
			}
		}
		return success;
	}
	private int getMaxFileName(File cp) {
		int index=0;
		if (cp.exists()) {
			String[] cps=cp.list();
			if (cps.length>0) {
				String cpurl=cps[cps.length-1];
				cpurl=FilenameUtils.getBaseName(cpurl);
				if ("0".equals(cpurl)) {
					index=1;
				}else{
					index=Integer.parseInt(cpurl);
				}
			}
		}
		return index;
	}
	/**
	 * 删除产品及图片
	 * @param request
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("delpro")
	@ResponseBody
	public ResultInfo delpro(HttpServletRequest request) throws IOException {
		boolean success=false;
		String item_id=request.getParameter("item_id");
		if (StringUtils.isNotBlank(item_id)) {
			productService.delpro(item_id);
			StringBuffer buffer=new StringBuffer(getRealPath(request));
			buffer.append("/"+getComId()+"/").append("img/").append(item_id);
			File destFile=new File(buffer.toString());
			FileUtils.deleteDirectory(destFile);
			success=true;
		}
		return new ResultInfo(success);
	}
	@RequestMapping("getImgUrl")
	@ResponseBody
	public Map<String,Object> getImgUrl(HttpServletRequest request) {
		String item_id=request.getParameter("item_id");
		String com_id=request.getParameter("com_id");
		if (StringUtils.isBlank(item_id)) {
			return null;
		}
		if (StringUtils.isBlank(com_id)) {
			com_id=getComId();
		}
		Map<String,Object> map=new HashMap<String, Object>();
		StringBuffer buffer=new StringBuffer(getRealPath(request));
		buffer.append("/"+com_id+"/img/").append(item_id);
		File cpFile=new File(buffer.toString()+"/cp");
		if (cpFile.listFiles()!=null) {
			List<String> cps=new ArrayList<String>();
			for (File file : cpFile.listFiles()) {
				if (file.isFile()) {
					String path="../"+com_id+"/img/"+item_id+"/cp/"+file.getName();
					cps.add(path);
				}
			}
			map.put("cps",cps);
		}
		File xjFile=new File(buffer.toString()+"/xj");
		if (xjFile.listFiles()!=null) {
			List<String> xjs=new ArrayList<String>();
			for (File file : xjFile.listFiles()) {
				if (file.isFile()) {
					String path="../"+com_id+"/img/"+item_id+"/xj/"+file.getName();
					xjs.add(path);
				}
			}
			map.put("xjs",xjs);
		}
		String sl="../"+com_id+"/img/"+item_id+"/sl.jpg";
		map.put("sl", sl);
		return map;
	}
	/**
	 * 产品分页接口
	 * @param request
	 * @param query
	 * @return 分页数据
	 */
	@RequestMapping("proPageList")
	@ResponseBody
	public PageList<Map<String, Object>> proPageList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getEmployee(request)!=null) {
			map.put("employeeId", getEmployeeId(request));
		}
		return productService.findQuery(map);
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductList")
	@ResponseBody
	public List<Map<String,Object>> getProductList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productService.getProductList(map);
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("moreMemo")
	public String moreMemo(HttpServletRequest request) {
		return "pc/customer/moreMemo";
	}
	
	/**
	 * 产品分页接口
	 * @param request
	 * @param query
	 * @return 分页数据
	 */
	@RequestMapping("productList")
	@ResponseBody
	public PageList<Map<String, Object>> productList(HttpServletRequest request,ProductQuery query) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (!"001".equals(getEmployeeId(request))) {
			Map<String, Object> mapclerk =(Map<String, Object>) getEmployee(request).get("personnel");
			if (isMapKeyNull(mapclerk, "mySelf_Info")
					|| "是".equals(mapclerk.get("mySelf_Info"))) {
				map.put("employeeId", getEmployeeId(request));
			}
			if (isNotMapKeyNull(mapclerk, "type_id")) {
				map.put("type_id", mapclerk.get("type_id").toString());
			}
		}
		if (isNotMapKeyNull(map, "item_spec")) {
			map.put("item_spec", "%"+map.get("item_spec")+"%");
		}
		if (isNotMapKeyNull(map, "type_id")&&!MapUtils.getString(map, "type_id").contains("%")) {
			map.put("type_id", map.get("type_id")+"%");
		}
		return productService.findAddQuery(map);
	}
	
	/**
	 * 获取产品信息包含库存
	 * @param request
	 * @param type 生产或者采购
	 * @return 产品信息和库存数量,采购时返回供应商信息
	 */
	@RequestMapping("getProductWarePage")
	@ResponseBody
	public PageList<Map<String,Object>> getProductWarePage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "item_spec")) {
			map.put("item_spec", "%"+map.get("item_spec")+"%");
		}
		if (isNotMapKeyNull(map, "type_id")&&!MapUtils.getString(map, "type_id").contains("%")) {
			map.put("type_id", map.get("type_id")+"%");
		}
		return  productService.getProductWarePage(map);
	}
	
	/**
	 * 获取客户已经添加的品种
	 * @param request
	 * @param query
	 * @return 
	 */
	@RequestMapping("getClientAdded")
	@ResponseBody
	public PageList<Map<String,Object>> getClientAdded(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isMapKeyNull(map, "customer_id")) {
			return null;
		}
		if (getEmployeeId(request)!=null) {
			map.put("employeeId", getEmployeeId(request));
		}
//		map.put("queryParams", getOrderParams(map));
		return productService.getClientAdded(map);
	}
	/**
	 * 获取客户已经下订单的数据
	 * @param request
	 * @param query
	 * @return
	 */
	@RequestMapping("getClientOrdered")
	@ResponseBody
	public PageList<Map<String,Object>> getClientOrdered(HttpServletRequest request,ProductQuery query){
		String customer_id=request.getParameter("customer_id");
		Map<String,Object> map =getKeyAndValue(request);
		query.setCom_id(getComId(request));
		query.setQueryParams(getOrderParams(map));
		if (StringUtils.isBlank(customer_id)) {
			customer_id=getUpperCustomerId(request);
			if (StringUtils.isBlank(customer_id)) {
				return null;
			}
			query.setCustomer_id(customer_id);
		}
		if (getCustomer(request)!=null&&StringUtils.isNotBlank(customer_id)) {
			query.setClient(1);
		}else{
			if (getEmployee(request)!=null) {
				String clerk_id = getEmployeeId(request);
				if (!"001".equals(clerk_id)) {
					Map<String, Object> mapclerk =(Map<String, Object>) getEmployee(request).get("personnel");
					if (mapclerk==null||mapclerk.get("mySelf_Info") == null
							|| "是".equals(mapclerk.get("mySelf_Info"))) {
						query.setEmployeeId(getEmployeeId(request));
					}
				}
			}
		}
		return productService.getClientOrdered(query);
	}
	
	/**
	 * 获取订单页面查询数据
	 * @param map
	 * @return
	 */
	private String getOrderParams(Map<String,Object> map) {
		map.remove("page");
		map.remove("rows");
		Object[] keys =  map.keySet().toArray();
		Collection<Object> c = map.values();
		Object[] vals=c.toArray();
		StringBuffer wheresql=new StringBuffer();
		for (int i = 0; i < vals.length; i++) {
			if (vals[i]!=null&&keys[i]!=null&&keys[i]!=""&&keys[i]!="ver"&&keys[i].toString().length()>2) {
				if ("type_id".equals(keys[i])||"com_id".equals(keys[i])) {
					wheresql.append(" and ltrim(rtrim(isnull(t1.").append(keys[i]).append(",'')))=").append("'").append(vals[i]).append("'");
				}else{
					wheresql.append(" and ltrim(rtrim(isnull(t1.").append(keys[i]).append(",''))) like '").append(vals[i]).append("%'");
				}
			}
		}
		return wheresql.toString();
	}
	/**
	 * 到产品详细页面
	 * @param request
	 * @return
	 */
	@RequestMapping("productDetail")
	public String productDetail(HttpServletRequest request) {
		 String item_id=request.getParameter("item_id");
		 String customer_id=request.getParameter("customer_id");
		 String com_id=request.getParameter("com_id");
		 final Map<String,Object> map=new HashMap<String, Object>();
		 if(StringUtils.isNotBlank(item_id)){
			 map.put("item_id", item_id);
		 }
		 if(StringUtils.isBlank(com_id)){
			 map.put("com_id", getComId());
		 }else{
			 map.put("com_id",com_id);
		 }
		if(StringUtils.isNotBlank(customer_id)){
			map.put("customer_id", customer_id);
		}else{
			if (getCustomer(request)!=null) {
				map.put("customer_id", getCustomerId(request));
			}else{
				map.put("customer_id", "CS1_ZEROM");
			}
		}
		request.setAttribute("product",productService.getByItemId(map));
		map.put("view_time", getNow());
		String view_ip=LogUtil.getIpAddr(request);
		map.put("view_ip",view_ip);
		try {
			productService.saveProductView(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("evals", getProductEval(request));
		writeLog(request,map.get("customer_id")+"","","浏览产品["+item_id+"]");
		return "pc/productDetail";
	}
	
	/**
	 *  获取指定产品的评价内容和图片
	 * @param request
	 * @return 评价内容和图片
	 */
	@RequestMapping("getProductEval")
	@ResponseBody
	public JSONArray getProductEval(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		String item_id=request.getParameter("item_id");
		String lenstr=request.getParameter("len");
		if (StringUtils.isBlank(lenstr)) {
			lenstr="10";
		}
		Integer len=Integer.parseInt(lenstr);
		File file=new File(getRealPath(request)+com_id+"/eval/");
		if (file.exists()) {
			File[] fs=file.listFiles();//订单编号
			if (fs!=null&&fs.length>0) {
				JSONArray jsons=new JSONArray();
				for (File file2 : fs) {
					if (file2.isDirectory()) {
						File[] items=file2.listFiles();//产品评价log和img所在文件夹
						if(items!=null&&items.length>0){
							JSONObject json=new JSONObject();
							for (File file3 : items) {
								boolean b=file3.getPath().contains(item_id);//判断是否是指定产品编码
								if(b){
									if(file3.isFile()){
										String str=getFileTextContent(file3);
										JSONObject eval=JSONObject.fromObject(str);
										if (eval.has("id")) {//移除内编码
											eval.remove("id");
										}
										json.put("eval", eval);//文字评价
									}else{
										File[] imgs=file3.listFiles();//图片
										List<String> imglist=new ArrayList<>();
										for (File img : imgs) {
											String path="../"+com_id+img.getPath().split("\\\\"+com_id)[1].replaceAll("\\\\", "/");
											imglist.add(path);
										}
										json.put("imgs", imglist);
									}
								}
							}
							if (!json.isEmpty()&&jsons.size()<len) {
								jsons.add(json);
							}
						}
					}
				}
				return jsons;
			}
		}
		return null;
	}
	
	/**
	 * 获取产品浏览历史记录
	 * @param request
	 * @return 产品访问历史详细记录
	 */
	@RequestMapping("getProductViewPage")
	@ResponseBody
	public PageList<Map<String,Object>> getProductViewPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(getCustomer(request)!=null){
			map.put("customer_id", getCustomerId(request));
		}
		return productService.getProductViewPage(map);
	}
	
	/**
	 *  获取产品浏览历史记录列表不分页 可用于线形图,柱形图
	 * @param request
	 * @return 产品名称,访问量,按照访问时间进行查询汇总
	 */
	@RequestMapping("getProductViewList")
	@ResponseBody
	public List<Map<String,Object>> getProductViewList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productService.getProductViewList(map);
	}
	
	/**
	 * 获取基础产品详情图文介绍页面
	 * @param request
	 * @return
	 */
	@RequestMapping("productBasicDetail")
	public String productBasicDetail(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("product",productService.getProductBasicDetailByItemId(map));
		return "pc/productDetail";
	}
	
	/**
	 *  以下订单对应的产品详情页面
	 * @param request
	 * @return
	 */
	@RequestMapping("productOrderDetail")
	public String productOrderDetail(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("product",productService.getProductOrderDetailByItemId(map));
		return "pc/productDetail";
	}
	
	/**
	 *  下计划对应的产品详情页面
	 * @param request
	 * @return
	 */
	@RequestMapping("productPlanDetail")
	public String productPlanDetail(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("product",productService.getProductPlanDetailByItemId(map));
		return "pc/productDetail";
	}
	@RequestMapping("productDetailEwm")
	public String productDetailEwm(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("product",productService.getProductPlanDetailByItemId(map));
		return "pc/productDetailEwm";
	}
	/**
	 * 获取产品明细信息,指定时间内的销量
	 * @param item_id 产品内码
	 * @param customer_id 客户内码
	 * @param com_id 运营商编码
	 * @param beginDate 开始日期
	 * @param endDate 结束日期
	 * @return 产品详情+产品销量
	 */
	@RequestMapping("getProductDetail")
	@ResponseBody
	public Map<String,Object> getProductDetail(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isMapKeyNull(map, "customer_id")) {
			map.put("error", "请输入客户编码");
			LoggerUtils.error(LogUtil.getIpAddr(request));
			return map;
		}
		if (isMapKeyNull(map, "item_id")) {
			map.put("error", "请输入产品编码");
			LoggerUtils.error(LogUtil.getIpAddr(request));
			return map;
		}
		String aut=map.get("customer_id").toString();
		if (getCustomer(request)!=null) {
			aut= getCustomerId(request);
		}
		String name="陌生客户";
		if (getCustomer(request)==null) {
			if(isNotMapKeyNull(map, "userid")){
				aut=map.get("userid").toString();
				Map<String,Object> mapinfo= customerService.getCustomerInfoByWeixinID(map);
				if (mapinfo!=null) {
					name=mapinfo.get("corp_name").toString();
				}else{
					name=name+":"+aut;
				}
			}
		}else{
			name=getCustomer(request).get("clerk_name").toString();
		}
		String view_ip=LogUtil.getIpAddr(request);
		map.put("view_ip",view_ip);
		Object customer_id=map.get("customer_id");
		try {
			if(getCustomer(request)!=null){
				map.put("customer_id", getCustomerId(request));
			}else{
				map.put("customer_id", "CS1_ZEROM");
			}
			productService.saveProductView(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		writeLog(request,aut,name,"浏览产品["+map.get("item_id")+"]");
		if(isNotMapKeyNull(map, "add")){
			map.put("customer_id", getUpperCustomerId(request));
		}else{
			map.put("customer_id", customer_id);
		}
		return productService.getByItemId(map);
	}
	////////////////////////////////////////
	/**
	 * 产品类别编辑页面
	 * @param request
	 * @return
	 */
	@RequestMapping("productClassEdit")
	public String productClassEdit(HttpServletRequest request) {
		String sort_id=request.getParameter("sort_id");
//		String next=request.getParameter("next");
//		String sort_name=request.getParameter("sort_name");
//		if (StringUtils.isNotBlank(next)) {
//			Map<String, Object> map=new HashMap<String, Object>();
//			map.put("upper_sort_id", sort_id);
//			map.put("upper_sort_name", sort_name);
//			request.setAttribute("productClass", map);
//		}else{
//			if (StringUtils.isNotBlank(sort_id)) {
//				Map<String, Object> map=productService.getProductClassBySordId(sort_id);
//				request.setAttribute("productClass", map);
//			}
//			request.setAttribute("info", request.getParameter("info"));
//		}
		request.setAttribute("sort_id", sort_id);
		request.setAttribute("fileds", getShowFiledList(request,"productClass"));
		return "pc/manager/productClassEdit";
	}
	
	/**
	 *  获取类别详细
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductClassBySordId")
	@ResponseBody
	public Map<String,Object> getProductClassBySordId(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "id")) {
			map.put("sort_id",map.get("id"));
		}
		map.put("filed", getFiledNameBYJson(request, "productClass","sort_id","edit"));
		return productService.getProductClassBySordId(map);
	}
	
	/**
	 * 保存产品类别
	 * @param request
	 * @return
	 */
	@RequestMapping("saveProductClass")
	@ResponseBody
	public ResultInfo saveProductClass(HttpServletRequest request) {
		String msg = null;
		boolean success = false;
		try {
			int type=1;
			String table="ctl03200";
			String sortName="sort_id";//内码名称
			String upperName="upper_sort_id";//上级内码名称
			//////////////////////////////////////////////////////////////////
			Map<String, Object> map=getKeyAndValue(request, sortName);
			//1.1获取上级编码
			String upper_dept_id=request.getParameter(upperName);
			String  upper_id=null;
			//1.2获取产品类别编码
			String sort_id=request.getParameter(sortName);
			String  newsort_id=null;
			//1.3判断编码是否存在
			if (StringUtils.isBlank(sort_id)) {//新增加
				//1.4不存在生成新编码
				Integer  seedsId=managerService.getMaxSeeds_id(table, "seeds_id");
				newsort_id=String.format("TY%03d", seedsId+1);
				//1.4.1判断是否有上级编码
				if (StringUtils.isNotBlank(upper_dept_id)) {
					//1.4.2将新编码前加入新的上级编码
					newsort_id=upper_dept_id+newsort_id;
				}
				sort_id=newsort_id;
				map.put(sortName, newsort_id);
				type=0;
			}else{//修改
				//1.5判断上级与现在是否一样
				Map<String,Object> mapparam=new HashMap<String, Object>();
				mapparam.put("table", table);
				mapparam.put("upperName", upperName);
				mapparam.put("idName", sortName);
				mapparam.put("idVal", sort_id);
				mapparam.put("com_id", getComId(request));
				upper_id=managerService.getUpperId(mapparam);
				//2.有上一级,并且不相等的时候生成新id
				if (StringUtils.isNotBlank(upper_dept_id)&&!upper_dept_id.equals(upper_id)) {
					//2.1替换现有编码中的上级编码为空字符串放入新编码中
					newsort_id=sort_id.replaceAll(upper_id, "");
					//2.2将新编码前加入新的上级编码
					newsort_id=upper_dept_id+newsort_id;
				}else if(StringUtils.isNotBlank(upper_dept_id)&&!sort_id.startsWith(upper_id)){
					//2.2将新编码前加入新的上级编码
					newsort_id=upper_dept_id+sort_id;
				}else{//一致时旧编码与新编码保持一致,
					newsort_id=sort_id;
				}
				map.put(sortName, newsort_id);
			}
			////////////////////////////////////////////////////////////
			//将参数列表中的字段名循环迭代出来进行处理
			map.put("maintenance_datetime",getNow());
			map.put("mainten_clerk_id",getEmployeeId(request));
			if (StringUtils.isNotBlank(sort_id)&&!sort_id.equals(newsort_id)) {
				//更新产品表中的类别字段和员工表中的类别字段
				managerService.updateProductAndEmployee(sort_id,newsort_id);
			}
			if (isMapKeyNull(map, "self_id")||MapUtils.getString(map, "self_id").startsWith("TY")) {
				map.put("self_id", sort_id);
			}
			managerService.insertSql(map, type, table, sortName, sort_id);
			msg=newsort_id;
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
///////////////////////////////////////////////
	/**
	 * 客户添加产品
	 * @param request
	 * @return
	 */
	@RequestMapping("addPro")
	@ResponseBody
	public ResultInfo addPro(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "item_ids")) {
				msg="产品信息为空";
			}else if(isMapKeyNull(map,"customer_ids")){
				msg="客户信息为空";
			}else{
				map.put("sd_order_direct", request.getParameter("goods_origin"));
				if (getEmployeeId(request)!=null) {
					map.put("clerk_id", getEmployeeId(request));
					map.put("dept_id", getEmployee(request).get("dept_id"));
				}else{
					map.put("clerk_id", getComId(request));
				}
				msg=customerService.addProduct(map);
				if(msg==null){
					success=true;
				}
			}
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 删除增加的品种
	 * @param request
	 * @return
	 */
	@RequestMapping("delAddPro")
	@ResponseBody
	public ResultInfo delAddPro(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=new HashMap<String, Object>();
			String[] itemIds=request.getParameterValues("itemIds[]");
			map.put("itemIds", itemIds);
			map.put("com_id",getComId(request));
			productService.delAddPro(map);
			Set<String> ivt=new HashSet<String>();
			for (String item : itemIds) {//获取不重复的增加品种单号
				JSONObject json = JSONObject.fromObject(item);
				String ivt_oper_bill=json.getString("ivt_oper_bill");
				ivt.add(ivt_oper_bill);
			}
			for (String item : ivt) {
				Map<String,Object> param=new HashMap<String, Object>();
				param.put("com_id",map.get("com_id"));
				param.put("ivt_oper_listing", item);//获取增加品种单号在从表中是否还有
				Integer i=productService.getAddDetailCount(param);
				if (i==0) {//当从表数据为0时才删除主表
					productService.delAddProMain(param);
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
	 * 审核和弃审报价单
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmAddPro")
	@ResponseBody
	public ResultInfo confirmAddPro(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=productService.confirmAddPro(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取购物车数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getShopping")
	@ResponseBody
	public PageList<Map<String,Object>> getShopping(HttpServletRequest request) {
		 Map<String,Object> map=getKeyAndValueQuery(request);
		 map.put("customer_id", getCustomerId(request));
		return productService.getShopping(map);
	}
	/**
	 * 删除购物车产品
	 * @param request
	 * @return
	 */
	@RequestMapping("delShopping")
	@ResponseBody
	public ResultInfo delShopping(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			productService.delShopping(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 提交购物车
	 * @param request
	 * @return
	 */
	@RequestMapping("postShopping")
	@ResponseBody
	public ResultInfo postShopping(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getUpperCustomerId(request));
//			map.put("customer_id", getCustomerId(request));
			map.put("customer_id2", LogUtil.getIpAddr(request));
			productService.updateOrder(map);
			productService.postShopping(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取首页产品列表查询参数
	 * @param request
	 * @param map
	 */
	private void getOrderProductParams(HttpServletRequest request,Map<String,Object> map) {
		String params=request.getParameter("params");
		if (StringUtils.isNotBlank(params)) {
			JSONArray jsons=JSONArray.fromObject(params);
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				if(json.getString("filedId").contains("_id")){
					map.put(json.getString("filedId"), json.getString("filedname")+"%");
				}else if(json.getString("filedname").contains("-")){
					map.put(json.getString("filedId"), json.getString("filedname").split("-")[0]);
					map.put(json.getString("filedId")+"1", json.getString("filedname").split("-")[1]);
				}else{
					map.put(json.getString("filedId"), json.getString("filedname"));
				}
			} 
		}
	}
	/**
	 * 获取客户增加的品种列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderProduct")
	@ResponseBody
	public PageList<Map<String, Object>> getOrderProduct(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getCustomer(request)!=null&&isMapKeyNull(map, "customer_id")) {
			map.put("customer_id", getUpperCustomerId(request));
			map.put("customerName", getCustomer(request).get("clerk_name"));
		}
		getOrderProductParams(request, map);
		return productService.getCustomerAddProduct(map);
	}
	/**
	 * 获取零售客户的报价单列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getZEROMOrderProduct")
	@ResponseBody
	public PageList<Map<String, Object>> getZEROMOrderProduct(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("customer_id", "CS1_ZEROM");
//		if(!ConfigFile.isShowAllProduct){//是否显示其他运营商的消息
//			map.put("com_id", getComId());
//		}
		getOrderProductParams(request, map);
		return productService.getZEROMOrderProduct(map);
//		return productService.getCustomerAddProduct(map);
	}
	/**
	 *  获取订单信息根据传入的报价单号,产品内码,折算数量
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderInfo")
	@ResponseBody
	public Map<String,Object> getOrderInfo(HttpServletRequest request) {
		Map<String,Object> map=productService.getOrderInfo(request.getParameter("orderInfo"));
		map.put("orderNo", customerService.getOrderNo("销售收款", getComId(request)));
		return map;
	}
	/**
	 * 到客户维护页面
	 * @param request
	 * @return
	 */
	@RequestMapping("clientEdit")
	public String clientEdit(HttpServletRequest request) {
		String customer_id=request.getParameter("customer_id");
		String next=request.getParameter("next");
		String corp_name=request.getParameter("item_name");
		if (StringUtils.isNotBlank(next)) {
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("upper_customer_id", customer_id);
			map.put("upper_corp_name", corp_name);
			request.setAttribute("client", map);
		}else{
			if (StringUtils.isNotBlank(customer_id)) {
				request.setAttribute("client", customerService.getCustomerByCustomer_id(customer_id,getComId(request)));
			}
			request.setAttribute("info", request.getParameter("info"));
		}
		return "pc/manager/clientEdit";
	}
	/**
	 * 选择计划页面
	 * @param request
	 * @return
	 */
	@RequestMapping("modalChooseplan")
	public String modalChooseplan(HttpServletRequest request) {
		Map<String,Object> map=systemParamsService.getSystemParamsByComId(getComId());
		request.setAttribute("beginTime",DateTimeUtils.dateToStr(DateUtils.addDays(new Date(), - MapUtils.getIntValue(map, "dayN1_SdOutStore_Of_SdPlan"))));
		request.setAttribute("begin", map.get("dayN1_SdOutStore_Of_SdPlan"));
		request.setAttribute("endTime", map.get("dayN2_SdOutStore_Of_SdPlan"));
		return "pc/employee/modalChooseplan";
	}
	
	/**
	 * 保存订单信息
	 * @param request
	 * @return
	 */
	@RequestMapping("addOrder")
	@ResponseBody
	public ResultInfo addOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//1.获取客户里面的货运商等信息 customer_id
			//2.regionalism_id dept_id clerk_id HYS  HYJE HJJS
			if(getCustomer(request)==null&&getEmployee(request)==null){
				return new ResultInfo(success, "请先登录系统!");
			}
			Map<String,Object> map=getKeyAndValue(request);
			if(getCustomer(request)!=null){
				map.put("customer_id", getUpperCustomerId(request));
				map.put("Status_OutStore", getProcessName(request, 0));
				map.put("customerName", getCustomer(request).get("clerk_name"));
			}
			String clerk_id=null;
			if (getEmployee(request)!=null) {//代客户下订单
				clerk_id=getEmployeeId(request);
				map.put("dept_id", getEmployee(request).get("dept_id"));
				map.put("clerk_id", clerk_id);
			}
			if (StringUtils.isBlank(clerk_id)) {
				clerk_id=map.get("customer_id")+"";
			}else{
				clerk_id+=map.get("customer_id");
			}
			map.put("plan", request.getParameter("plan"));
			String info=productService.addOrder(map);
			if (getCustomer(request)!=null) {
				writeLog(request,clerk_id,getCustomer(request).get("clerk_name"), "添加订单"+map.get("itemIds").toString().replaceAll(",", "_"));
			}else{
				writeLog(request,clerk_id,getEmployee(request).get("clerk_name"), "添加订单"+map.get("itemIds").toString().replaceAll(",", "_"));
			}
			success = true;
			msg=info;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
		
	}
	@RequestMapping("addOrderByZEROM")
	@ResponseBody
	public ResultInfo addOrderByZEROM(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//1.获取客户里面的货运商等信息 customer_id
			//2.regionalism_id dept_id clerk_id HYS  HYJE HJJS
			if(getCustomer(request)==null){
				return new ResultInfo(success, "请先登录!");
			}
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getUpperCustomerId(request));
			String[] itemIds=request.getParameterValues("itemIds[]");
			map.put("itemIds", itemIds);
			map.put("plan", request.getParameter("plan"));
			map.put("com_id", getComId(request));
			String info=productService.addOrderByZEROM(map);
			if (StringUtils.isBlank(info)) {
				success = true;
			}else{
				msg=info;
			}
			writeLog(request,getCustomerId(request),getCustomer(request).get("clerk_name"), "添加订单"+Arrays.toString(itemIds).replaceAll(",", "_"));
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存订单信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOrder")
	@ResponseBody
	public ResultInfo saveOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			
			if (getCustomer(request)==null) {
				msg="请先登录!";
			}else{
				Map<String,Object> map=getKeyAndValue(request);
				if (isMapKeyNull(map, "orderList")) {
					msg="参数错误没有获取到订单信息!";
				}else{
					map.put("customer_id", getUpperCustomerId(request));
					map.put("customerName",getCustomer(request).get("clerk_name"));
					msg=productService.saveOrder(map);
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
	 * 删除已下订单
	 * @param request
	 * @return
	 */
	@RequestMapping("delOrderPro")
	@ResponseBody
	public ResultInfo delOrderPro(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] itemIds=request.getParameterValues("itemIds[]");
			StringBuffer buffer=new StringBuffer();
			buffer.append(productService.delOrderPro(itemIds,getComId(request)));
			String clerk_id=getEmployeeId(request);
			if (clerk_id==null) {
				clerk_id=getCustomerId(request);
			}
			writeLog(request,clerk_id,"", "删除订单:"+ buffer.toString().replaceAll(",", "_"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			if(!msg.contains("订单")){
			e.printStackTrace();
			}
		}
		return new ResultInfo(success, msg);
	}
	 
	/**
	 * 添加计划
	 * @param request
	 * @return 执行结果
	 */
	@RequestMapping("addPlan")
	@ResponseBody
	public ResultInfo addPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			///SDP02020
			Map<String,Object> map=getKeyAndValue(request);
			String clerk_id=null;
			String customer_id=request.getParameter("customer_id");
			if (getEmployee(request)!=null) {
				map.put("dept_id", getEmployee(request).get("dept_id"));
				map.put("clerk_id", getEmployeeId(request));
				clerk_id=getEmployeeId(request);
			}else{
				map.put("customer_id", getCustomerId(request));
			}
			if (isMapKeyNull(map, "customer_id")) {
				msg="没有指定具体客户";
			}else{
				String if_Insert_Plan=request.getParameter("if_Insert_Plan");
				if (isMapKeyNull(map, "so")) {
					map.put("so", getNow());
				}
				if (isMapKeyNull(map, "at")) {
					map.put("at", getNow());
				}
				if (StringUtils.isBlank(clerk_id)) {
					clerk_id=customer_id;
				}else{
					clerk_id+=customer_id;
				}
				if (StringUtils.isNotBlank(if_Insert_Plan)) {
					if_Insert_Plan+=request.getParameter("insert_remark");
				}else{
					if_Insert_Plan="";
				}
				productService.addPlan(map);
				writeLog(request,clerk_id,"",map.get("sd_order_direct")+if_Insert_Plan+map.get("item_ids"));
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 计划修改保存
	 * @param request
	 * @return
	 */
	@RequestMapping("savePlanEidt")
	@ResponseBody
	public ResultInfo savePlanEidt(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isNotMapKeyNull(map, "seeds_id")) {
				msg=productService.savePlanEidt(map);
				success = true;
			}else{
				msg="无法为更新定位,请联系管理员!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存计划
	 * @param request
	 * @return
	 */
	@RequestMapping("savePlan")
	@ResponseBody
	public ResultInfo savePlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getUpperCustomerId(request));
			if(isNotMapKeyNull(map, "sd_oq")){
				msg=productService.savePlan(map);
				success = true;
			}else{
				msg="没有获取到计划数!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取以下计划
	 * @param request
	 * @param query
	 * @return
	 */
	@RequestMapping("getPlanList")
	@ResponseBody
	public PageList<Map<String,Object>> getPlanList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		String type=request.getParameter("type");
		if (StringUtils.isBlank(type)) {//默认为员工查询单个客户的数据
			map.put("employeeId", getEmployeeId(request));
		}else{
			map.put("client", 1);
		}
		if (isMapKeyNull(map, "customer_id")) {
			return null;
		}
		return productService.getPlanList(map);
	}
  
	@RequestMapping("delPlan")
	@ResponseBody
	public ResultInfo delPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
//			String type=request.getParameter("type");
			Map<String,Object> map=new HashMap<String, Object>();
//			if (StringUtils.isBlank(type)) {//默认为员工查询单个客户的数据
//				 map.put("clerk_id", getEmployeeId(request));
//			}
			String clerk_id=null;
			if (getEmployeeId(request)!=null) {
				clerk_id=getEmployeeId(request);
			}else {
				clerk_id=getCustomerId(request);
			}
			StringBuffer buffer=new StringBuffer(clerk_id);
			buffer.append("删除已计划操作");
			String[] itemIds=request.getParameterValues("itemIds[]");
			map.put("itemIds", itemIds);
			map.put("com_id",getComId(request));
			productService.delPlan(map);
			Set<String> ivt=new HashSet<String>();
			for (String item : itemIds) {//获取不重复的计划单号
				JSONObject json = JSONObject.fromObject(item);
				String ivt_oper_bill=json.getString("ivt_oper_bill");
				ivt.add(ivt_oper_bill);
				buffer.append(item);
			}
			buffer.append("--");
			for (String item : ivt) {
				Map<String,Object> param=new HashMap<String, Object>();
				param.put("com_id",map.get("com_id"));
				param.put("ivt_oper_listing", item);//获取计划单号在从表中是否还有
				Integer i=productService.getPlanDetailCount(param);
				if (i==0) {//当从表数据为0时才删除主表
					productService.delPlanMain(param);
				}
				buffer.append(item);
			}
			writeLog(request,clerk_id,"",  buffer.toString());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取计划订单
	 * @param request
	 * @return
	 */
	@RequestMapping("getPlanOrder")
	@ResponseBody
	public PageList<Map<String,Object>> getPlanOrder(HttpServletRequest request,ProductQuery query) {
		query.setCom_id(getComId(request));
		if (getCustomer(request)==null) {
			query.setEmployeeId(getEmployeeId(request));
		}else{
			query.setClient(1);
		}
		return productService.getPlanOrder(query);
	}
	////////////计划报表//////////
	/**
	 * 周计划-需导入Oracle
	 * @param request
	 * @return
	 * @throws FileNotFoundException 
	 */
	@RequestMapping("weeklyPlanAllProduct")
	@ResponseBody
	public PageList<Map<String,Object>> weeklyPlanAllProduct(HttpServletRequest request) throws FileNotFoundException {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (map.get("page")==null) {
			map.put("page", 0);
		}
		if (map.get("rows")==null) {
			map.put("rows", 1000);
		}
		if (map.get("count")==null) {
			map.put("count", 0);
		}
		//获取权限查看是否只能看自己的
		getMySelf_Info(request, map);
		map=getPlanReportParams(map,request);
		PageList<Map<String,Object>> pages= productService.weeklyPlanAllProduct(map);
		return pages;
	}
	/**
	 * 分产品
	 * @param request
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("dayProduct")
	@ResponseBody
	public PageList<Map<String,Object>> dayProduct(HttpServletRequest request) throws IOException {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (map.get("page")==null) {
			map.put("page", 0);
		}
		if (map.get("rows")==null) {
			map.put("rows", 1000);
		}
		if (map.get("count")==null) {
			map.put("count", 0);
		}
		if (getCustomer(request)==null) {
			getMySelf_Info(request, map);
			map=getPlanReportParams(map,request);
		}
		return productService.dayProduct(map);
	}
	
	@RequestMapping("dayProductExcel")
	@ResponseBody
	public ResultInfo dayProductExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			String sd_order_direct=map.get("sd_order_direct").toString();
			getMySelf_Info(request, map);
			map=getPlanReportParams(map,request);
			
			Map<String,Object> listmap=productService.dayProductExcel(map);
			
			ExcelUtils.addValue("listmap", listmap);
			String config ="/"+getComId(request)+"/xls/day_product.xls";
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]).append(sd_order_direct);
		    buffer.append("分产品").append(".xls"); 
		    
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 周计划分产品
	 * @param request
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("weekProduct")
	@ResponseBody
	public PageList<Map<String,Object>> weekProduct(HttpServletRequest request) throws IOException {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (map.get("page")==null) {
			map.put("page", 0);
		}
		if (map.get("rows")==null) {
			map.put("rows", 1000);
		}
		if (map.get("count")==null) {
			map.put("count", 0);
		}
		getMySelf_Info(request, map);
		map=getPlanReportParams(map,request);
		return productService.weekProduct(map);
	}
	/**
	 * 周计划分产品 导出
	 * @param request
	 * @return
	 */
	@RequestMapping("weekProductExcel")
	@ResponseBody
	public ResultInfo weekProductExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			String sd_order_direct=map.get("sd_order_direct").toString();
			getMySelf_Info(request, map);
			map=getPlanReportParams(map,request);
			
			Map<String,Object> listmap=productService.weekProductExcel(map);
			
			ExcelUtils.addValue("listmap", listmap);
			String config ="/"+getComId(request)+"/xls/weekproduct.xls";
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]).append(sd_order_direct);
		    buffer.append("分产品").append(".xls"); 
		    
		    msg=getExcelPath(request, buffer, config); 
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	
	/**
	 * 周计划-需导入Oracle 生成并导出excel
	 * @param request
	 * @return
	 */
	@RequestMapping("weeklyPlanAllProductExcel")
	@ResponseBody
	public ResultInfo weeklyPlanAllProductExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.remove("find");///移除后就可以将对象放入到集合中以便于导出,查询的时候不需要查询过多的不需要数据
			String sd_order_direct=map.get("sd_order_direct").toString();
			//获取权限查看是否只能看自己的
			getMySelf_Info(request, map);
			map=getPlanReportParams(map,request);
			Map<String,Object> listmap=productService.weeklyPlanAllProductExcel(map);
			ExcelUtils.addValue("listmap", listmap);
		    String config ="/"+getComId(request)+"/xls/"+map.get("config")+".xls";
		    StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]).append(sd_order_direct);
		    if ("weekfenxi".equals(map.get("config"))) {
		    	buffer.append("分析");
			}else if ("dayfenxi".equals(map.get("config"))) {
				buffer.append("分析");
			}
		    buffer.append(".xls");
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	@RequestMapping("weeklyPlanAllProductExcel2")
	public void weeklyPlanAllProductExcel2(HttpServletRequest request,HttpServletResponse response) {
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.remove("find");///移除后就可以将对象放入到集合中以便于导出,查询的时候不需要查询过多的不需要数据
			map=getPlanReportParams(map,request);
			Map<String,Object> listmap=productService.weeklyPlanAllProductExcel(map);
			ExcelUtils.addValue("listmap", listmap);
		    String config ="/xls/"+map.get("config")+".xls";
		    response.reset();
		    response.setContentType("application/vnd.ms-excel");
		    ExcelUtils.export(request.getSession().getServletContext(), config,response.getOutputStream());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping("monthlyPlan")
	@ResponseBody
	public PageList<Map<String,Object>> monthlyPlan(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (map.get("page")==null) {
			map.put("page", 0);
		}
		if (map.get("rows")==null) {
			map.put("rows", 1000);
		}
		if (map.get("count")==null) {
			map.put("count", 0);
		}
		getMySelf_Info(request, map);
		map=getPlanReportParams(map,request);
		return  productService.monthlyPlan(map);
	}
	@RequestMapping("monthlyPlanExcel")
	@ResponseBody
	public ResultInfo monthlyPlanExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.remove("find");
			String sd_order_direct=map.get("sd_order_direct").toString();
			Object monthtype=map.get("monthtype");
			//获取权限查看是否只能看自己的
			getMySelf_Info(request, map);
			map=getPlanReportParams(map,request);
			Map<String,Object> listmap=productService.monthlyPlanExcel(map);
			ExcelUtils.addValue("listmap", listmap);
			String config ="/"+getComId(request)+"/xls/";
			if ("client".equals(monthtype)) {
				config=config+"mothclient.xls";
			}else if("product".equals(monthtype)){
				config=config+"mothproduct.xls";
			}else{
				config=config+"moth.xls";
			}
			
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]).append(sd_order_direct);
		    if ("client".equals(monthtype)) {
		    	buffer.append("分客户");
			}else if("product".equals(monthtype)){
				buffer.append("分产品");
			}else{
				buffer.append("oracle");
			}
		    
		    buffer.append(".xls");
		    
		    File file=new File(getRealPath(request)+buffer.toString());
		    if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			OutputStream out=new FileOutputStream(file);
		    ExcelUtils.export(request.getSession().getServletContext(), config,out);
		    out.close();
		    msg="../"+buffer.toString();
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 组合参数,用于总计和数据列表进行分开查询
	 * @param map
	 * @param request 
	 * @return
	 * @throws FileNotFoundException 
	 */
	private Map<String,Object> getPlanReportParams(Map<String,Object> map, HttpServletRequest request){
		if (map.get("item_name")!=null) {
			map.put("item_name", "%"+map.get("item_name")+"%");
		}
		if (map.get("customer_name")!=null) {
			map.put("customer_name", "%"+map.get("customer_name")+"%");
		}
		if (map.get("sd_order_direct")!=null) {
			map.put("sd_order_direct", "%"+map.get("sd_order_direct")+"%");
		}
		map=getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql", "dept_id", null,employeeService);
		return map;
	}


	/**
	 * 获取周计划总计
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("weeklyPlanAllProductCount")
	@ResponseBody
	public Map<String,Object> weeklyPlanAllProductCount(HttpServletRequest request) throws IOException {
		Map<String,Object> map=getKeyAndValueQuery(request);
		//获取权限查看是否只能看自己的
		getMySelf_Info(request, map);
		return productService.weeklyPlanAllProductCount(getPlanReportParams(map,request));
	}
	
	/////////////excel导入//////////
//	/**
//	 * 导入Excel
//	 * @param request
//	 * @param url 备份文件路径
//	 * @return
//	 */
//	@RequestMapping("excelImport")
//	@ResponseBody
//	public ResultInfo excelImport(HttpServletRequest request) {
//		boolean success = false;
//		String msg = null;
//		try {
//			String url=request.getParameter("url");
//			String typeName=request.getParameter("typeName");
//			String xmlname="excel.xml";//应收款
//			if ("ard".equalsIgnoreCase(typeName)) {//收款
//				xmlname="ARd02051.xml";
//			}else if("arf".equalsIgnoreCase(typeName)){//期初
//				xmlname="ARf02030.xml";
//			}
//			StringBuffer tempPath=new StringBuffer(getRealPath(request));
//			StringBuffer filePath=new StringBuffer(getComIdPath(request));
//			StringBuffer xmlPath=new StringBuffer(getComIdPath(request));
//			xmlPath.append("excel/xml/").append(xmlname);
//			
//			filePath.append("excel/").append(FilenameUtils.getName(url));
//			
//			tempPath.append(url);
//			
//			File src=new File(tempPath.toString());
//			if (src.exists()&&src.isFile()) {
//				File destFile=new File(filePath.toString());
////				if (destFile.exists()&&destFile.isFile()) {
////					LoggerUtils.error(destFile.delete());
////				}
//				FileUtils.moveFile(src, destFile);
//				if (destFile.exists()&&destFile.isFile()) {
//					if ("ard".equalsIgnoreCase(typeName)) {
//						saveArdData(request, destFile, filePath, xmlPath);
//					}else  if("arf".equalsIgnoreCase(typeName)){
//						saveArfData(request, destFile, filePath, xmlPath);
//					}else{
//						///保存excel数据到订单主表和从表中
//						saveExcelData(request, destFile, filePath, xmlPath);
//					}
//					success = true;
//					destFile.delete();
//				}
//			}
//			//获取excel上传信息
//			msg=getMsgToSession(request); 
//		} catch (Exception e) {
//			msg = e.getMessage();
//			e.printStackTrace();
//		}
//		return new ResultInfo(success, msg);
//	}

	/**
	 * 获取excel上传信息,从session中
	 * @param request
	 * @return 获取的上传信息
	 */
	private String getMsgToSession(HttpServletRequest request) {
		String msg=null;
		Object excesms=request.getSession().getAttribute("excesms");
		Object smserror=request.getSession().getAttribute("smserror");
		if (excesms!=null) {
			msg=excesms.toString();
		}
		if (smserror!=null) {
			msg=msg+smserror.toString();
		}
		request.getSession().removeAttribute("smserror");
		request.getSession().removeAttribute("excesms");
		return msg;
	}
	/**
	 * 保存订单导入excel数据
	 * @param request
	 * @param destFile
	 * @param filePath
	 * @param xmlPath
	 */
	private void saveExcelData(HttpServletRequest request,File destFile,StringBuffer filePath,StringBuffer xmlPath) {
		if ("xlsx".equals(FilenameUtils.getExtension(destFile.getName()))) {
			productService.saveExcelImportData(readExcelPoi(filePath.toString(), xmlPath.toString(), request), request);
		}else{
			productService.saveExcelImportData(readExcel(filePath.toString(), xmlPath.toString(), request), request);
		}
	}
	/**
	 * 保存收款导入Excel
	 * @param request
	 * @param destFile
	 * @param filePath
	 * @param xmlPath
	 */
	private void saveArdData(HttpServletRequest request, File destFile,
			StringBuffer filePath, StringBuffer xmlPath) {
		if ("xlsx".equals(FilenameUtils.getExtension(destFile.getName()))) {
			productService.saveArdExcelImportData(readExcelPoi(filePath.toString(), xmlPath.toString(), request), request);
		}else{
			productService.saveArdExcelImportData(readExcel(filePath.toString(), xmlPath.toString(), request), request);
		}
	}
	private void saveArfData(HttpServletRequest request, File destFile,
			StringBuffer filePath, StringBuffer xmlPath) {
		if ("xlsx".equals(FilenameUtils.getExtension(destFile.getName()))) {
			productService.saveArfExcelImportData(readExcelPoi(filePath.toString(), xmlPath.toString(), request), request);
		}else{
			productService.saveArfExcelImportData(readExcel(filePath.toString(), xmlPath.toString(), request), request);
		}
	}
	/***
	 * Excel导入需要使用的前缀
	 * 用于非固定字段的值
	 */
	private final String computedata="c";
	/**
	 * 获取导入excel的配置文件
	 * @param filePath 与Excel文件名一样后缀为.xml
	 * @return
	 * @throws FileNotFoundException
	 */
	private Map<String, Map<String,Object>> getExcelImportFiledname(String filePath) throws FileNotFoundException {
		Map<String, Map<String,Object>> map = new HashMap<String, Map<String,Object>>();
		File file=new File(filePath);
		if (!file.exists()) {
			throw new RuntimeException("excel导入配置文件不存在!");
		}
		InputStream in =new FileInputStream(file);
		try {
			SAXReader reader = new SAXReader();
			Document document = reader.read(in);
			Element rootElm = document.getRootElement();
			List<Element> itembegin = rootElm.elements("itembegin");//设置从多少行开始
			for (Iterator<Element> iterator = itembegin.iterator(); iterator.hasNext();) {
				Element element = iterator.next();
				String index = element.attributeValue("index");
				String sheetName = element.attributeValue("sheetName");
				Map<String,Object> mapkey=new HashMap<String, Object>();
				mapkey.put("beginindex", index);
				mapkey.put("sheetName", sheetName);
				map.put("beginindex", mapkey);
			}
			List<Element> nodes = rootElm.elements("item");
			int i=0;
			for (Iterator<Element> it = nodes.iterator(); it.hasNext();) {
				Map<String,Object> mapitem=new HashMap<String, Object>();
				Element elm = it.next();
				setParamsToXml(elm, mapitem, "mainfiledName");//主表字段名称
				setParamsToXml(elm, mapitem, "filedName");//从表字段名称
				setParamsToXml(elm, mapitem, "excelChineseName");//从表字段名称
				setParamsToXml(elm, mapitem, "compute");//计算值
				setParamsToXml(elm, mapitem, "tableName");//表名
				setParamsToXml(elm, mapitem, "queryName");//查询名称
				setParamsToXml(elm, mapitem, "value");//默认值
				setParamsToXml(elm, mapitem, "auto");//自动生成单号标示
				setParamsToXml(elm, mapitem, "valueOr");//小于的时候存放值
				setParamsToXml(elm, mapitem, "orname");//比较数据来源字段
				setParamsToXml(elm, mapitem, "like");//查询数据方法,like或者=
				setParamsToXml(elm, mapitem, "datatype");//数据类型
				setParamsToXml(elm, mapitem, "compareSrc");//比较来源
				setParamsToXml(elm, mapitem, "isnullval");//如果为空的值
				setParamsToXml(elm, mapitem, "or");//内外码一起判断
				setParamsToXml(elm, mapitem, "ext");//后缀,用于将长数字型的加后缀后不再是数字
				String index = elm.attributeValue("index");
				if (StringUtils.isBlank(index)) {//没有index的为计算字段或者直接存储固定值
				 index=computedata+i;
				 i++;
				}
				if (!mapitem.isEmpty()) {
					map.put(index, mapitem);
				}
			}
			Map<String,Object> mapkey=new HashMap<String, Object>();
			mapkey.put("c_key", ++i);
			map.put("c_key", mapkey);
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	/**
	 * 将xml中的参数设置到map中
	 * @param elm xml子项
	 * @param mapitem 存放参数的map
	 * @param filedName xml中的字段名称
	 */
	private void setParamsToXml(Element elm,Map<String,Object> mapitem,String filedName){
		String name = elm.attributeValue(filedName);
		if (StringUtils.isNotBlank(name)) {
			mapitem.put(filedName, name);
		}
	}
	
	/**
	 * 读取Excel 只能导入2003,不限生成文件的,wps,excel生成的均可,不能导入2007格式
	 * @param filePath Excel文件路径
	 * @param xmlPath xml配置文件路径
	 * @param request 
	 */
	protected Map<String,List<Map<String,Object>>> readExcel(String filePath,String xmlPath, HttpServletRequest request) {
		try {
			File file=new File(filePath);
			if (!file.exists()) {
				throw new RuntimeException("Excel文件不存在!");
			}else if (!file.isFile()) {
				throw new RuntimeException("路径不是指向一个文件!");
			}else{
				InputStream is = new FileInputStream(file);
				Workbook rwb = Workbook.getWorkbook(is);
				// Sheet st = rwb.getSheet("0")这里有两种方法获取sheet表,1为名字，而为下标，从0开始
				Map<String,Map<String,Object>> map=null;
				try {
					 map=getExcelImportFiledname(xmlPath);
				} catch (Exception e) {
					is.close();
					rwb.close();
					throw new RuntimeException(e.getMessage());
				}
				///设置从多少行开始导入数据
				Map<String,Object> beginindex= map.get("beginindex");
				String sheetName=beginindex.get("sheetName").toString();
				Sheet st = rwb.getSheet(sheetName); 
				if (st==null) {
					is.close();
					rwb.close();
					throw new RuntimeException("没有找到Sheet名为:["+sheetName+"]");
				}
				int rs = st.getColumns();
				int rows = st.getRows();
				LoggerUtils.info("列数===>" + rs + "行数：" + rows);
				//存放主表集合
				List<Map<String,Object>> mainlist=new ArrayList<Map<String,Object>>();
				//存放从表集合
				List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
				
				///设置时区,jxl转换的时间多出8个小时,需要进行时区换算
				SimpleDateFormat dateTime_format = new SimpleDateFormat(
						ConfigFile.DATETIME_FORMAT, Locale.CHINA);
				TimeZone zone = TimeZone.getTimeZone("GMT");
				dateTime_format.setTimeZone(zone);
				////时区换算结束
				String com_id=getComId(request);
				
				int  index=0;
				if (beginindex!=null) {
					 index=Integer.parseInt(beginindex.get("beginindex").toString());
				}
				StringBuffer buffer=new StringBuffer();
				for (int k = index; k < rows; k++) {
					//存放从表数据
					Map<String,Object> mapitem=new HashMap<String, Object>();
					mapitem.put("com_id", com_id);
					//存放主表数据
					Map<String,Object> mapmian=new HashMap<String, Object>();
					mapmian.put("com_id", com_id);
					mapmian.put("excelIndex", k);
					mapitem.put("excelIndex", k);
					for (int i = 0; i < rs; i++) {// 读取第4行内容
						Cell c00 = st.getCell(i, k);
						if (map.get(i+"") != null) {//Excel已有字段导入
						Map<String,Object> item=map.get(i+"");
						Object mainfiledName=item.get("mainfiledName");//主表字段名称
						Object filedName=item.get("filedName");//从表字段名称
						Object datatype=item.get("datatype");//数据类型
						String excelValue = c00.getContents();
						// 获得cell具体类型值的方式
						if (c00.getType() == CellType.LABEL) {
							LabelCell labelc00 = (LabelCell) c00;
							excelValue = labelc00.getString();
						}
						// excel 类型为时间类型处理;
						if (c00.getType() == CellType.DATE) {
							DateCell dc = (DateCell) c00; 
							excelValue =dateTime_format.format(dc.getDate());
						}
						if (datatype!=null) {
							if ("txt".equals(datatype)) {//数据类型为文本的时候
								excelValue=excelValue.split("\\.")[0];
							}
						}
						if(c00.getType() == CellType.NUMBER){
							try {
								NumberCell numberCell = (NumberCell) c00;
								double value =numberCell.getValue();
								BigDecimal db = new BigDecimal(value);
								String ii = db.toPlainString();
								if (ii.contains(".")) {
									db=db.setScale(6);
									ii=db.toPlainString();
								}
								excelValue = ii;
								LoggerUtils.info(ii);
							} catch (Exception e) {
								LoggerUtils.error(e.getMessage());
							}
							 excelValue=excelValue.replaceAll(",", "");
						} 
							// excel 类型为数值类型处理; 
							if (StringUtils.isNotBlank(excelValue)) {
								excelValue=excelValue.trim();
								StringBuffer buffer2=null;
								Object ext=item.get("ext");//去数据的后缀
								if (ext!=null&&!"".equals(ext.toString().trim())) {
									excelValue=excelValue.replaceAll(ext.toString(), "");
								}
								if (mainfiledName!=null) {//数据放入到主表中
									buffer2=computeExcelFiledData(item, com_id, mapmian, mapitem, excelValue.trim(), mainfiledName, filedName);
								}else{//没有主表字段将数据放入到从表中
									buffer2=computeExcelFiledData(item, com_id, mapitem, mapitem, excelValue.trim(), filedName, null);
								}
								if (buffer2.length()>5) {
									buffer.append("excel编码有问题行号:").append((k+1)).append(buffer2).append("\n");
								}
							}
						}
					}
					///获取计算字段的值
					buffer.append(computeFiledData(map, com_id, mapmian, mapitem));
					///附加系统默认字段的值
					setDefutVal(mapmian,request);
					mapmian.remove("excelIndex");
					map.remove("excelIndex");
					list.add(mapitem);
					mainlist.add(mapmian);
					LoggerUtils.msgToSession(request,"exceprogress", "数据已处理:"+rows+"/"+k);
				}
				LoggerUtils.msgToSession(request,"excelordermsg", orderLog(request, buffer));
				// 关闭流
				rwb.close();
				is.close();
				///保存Excel导入数据
				Map<String,List<Map<String,Object>>> maplist=new HashMap<String, List<Map<String,Object>>>();
				maplist.put("list", list);
				maplist.put("mainlist", mainlist);
				LoggerUtils.msgToSession(request,"exceprogress", "数据存储中......");
				return maplist;
			}
		} catch (Exception e) {
			String msg=e.getMessage();
			if ("Unable to recognize OLE stream".equals(e.getMessage())) {
				msg="系统暂时不支持excel2007格式导入,请转换为2003格式再导入";
			}else{
				e.printStackTrace();
			}
			throw new RuntimeException(msg);
		}
	}
	
	/**
	 * 从session中获取信息
	 * @param request
	 * @param key 获取信息的key值
	 * @return
	 */
	@RequestMapping("excelOrderMsg")
	@ResponseBody
	public ResultInfo excelOrderMsg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String key=request.getParameter("key");
			if (StringUtils.isNotBlank(key)) {
				Object obj=request.getSession().getAttribute(key);
				if (obj!=null&&obj!="") {
					msg=obj.toString();
					success = true;
				}
				request.getSession().removeAttribute(key);
			}
		} catch (Exception e) {
			msg = e.getMessage();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 写订单导入日志
	 * @param request
	 * @param response 
	 * @param buffer
	 * @throws IOException
	 */
	private String orderLog(HttpServletRequest request,  StringBuffer buffer) throws IOException{
		if (buffer!=null&&buffer.length()>5) {
			String name=new Date().getTime()+".log";
			request.getSession().setAttribute("logname", name);
			String msg="temp/"+getComId(request)+"/"+name;
			File log=new File(getRealPath(request)+msg);
			if (!log.exists()) {
				log.getParentFile().mkdirs();
			}
//			FileOutputStream out=new FileOutputStream(log);
//			PrintStream stream=new PrintStream(out);
//			stream.println("导入过程中所遇问题如下:\n"+buffer);
//			out.close();
//			stream.close(); 
			
			saveFile(log, "导入过程中所遇问题如下:\n"+buffer);
			return msg;
		}
		return null;
	}
	
	/**
	 * 读取Excel 2003到2007格式 但是必须是excel生成的文件才可以正常使用
	 * @param filePath Excel文件路径
	 * @param xmlPath xml配置文件路径
	 * @param request 
	 */
	private Map<String,List<Map<String,Object>>> readExcelPoi(String filePath,String xmlPath, HttpServletRequest request) {
		try {
			File file=new File(filePath);
			if (!file.exists()) {
				throw new RuntimeException("Excel文件不存在!");
			}else if (!file.isFile()) {
				throw new RuntimeException("路径不是指向一个文件!");
			}else{
				
				Map<String,Map<String,Object>> map=getExcelImportFiledname(xmlPath);
				InputStream is = new FileInputStream(file);
				POIFSFileSystem fs  = new POIFSFileSystem(is);
				HSSFWorkbook workbook = new HSSFWorkbook(fs);//创建Excel工作簿对象
				///设置从多少行开始导入数据
				Map<String,Object> beginindex= map.get("beginindex");
				String sheetName=beginindex.get("sheetName").toString();
				HSSFSheet st = workbook.getSheet(sheetName);//获取第1个工作表
				if (st==null) {
					throw new RuntimeException("没有找到Sheet名为:["+sheetName+"]");
				}
				int rows = st.getLastRowNum(); //获取实际行数
				LoggerUtils.info("行数：" + rows);
				//存放主表集合
				List<Map<String,Object>> mainlist=new ArrayList<Map<String,Object>>();
				//存放从表集合
				List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
				
				///设置时区,jxl转换的时间多出8个小时,需要进行时区换算
				SimpleDateFormat dateTime_format = new SimpleDateFormat(
						ConfigFile.DATETIME_FORMAT, Locale.CHINA);
				TimeZone zone = TimeZone.getTimeZone("GMT");
				dateTime_format.setTimeZone(zone);
				////时区换算结束
				String com_id=getComId(request);
				
				int  index=0;
				if (beginindex!=null) {
					index=Integer.parseInt(beginindex.get("beginindex").toString());
				}
				for (int k = index; k < rows; k++) {
					HSSFRow row = st.getRow(k);//获取行
					//存放从表数据
					Map<String,Object> mapitem=new HashMap<String, Object>();
					mapitem.put("com_id", com_id);
					//存放主表数据
					Map<String,Object> mapmian=new HashMap<String, Object>();
					mapmian.put("com_id", com_id);
					for (short i = row.getFirstCellNum(); i < row.getLastCellNum(); i++) {// 读取第4行内容
						HSSFCell c00 = row.getCell(i);  
						// 获得cell具体类型值的方式
						String excelValue=getValue(c00);
						// excel 类型为数值类型处理; 
						if (map.get(i+"") != null&&StringUtils.isNotBlank(excelValue)) {//Excel已有字段导入
							Map<String,Object> item=map.get(i+"");
							Object mainfiledName=item.get("mainfiledName");//主表字段名称
							Object filedName=item.get("filedName");//从表字段名称
							if (mainfiledName!=null) {//数据放入到主表中
								computeExcelFiledData(item, com_id, mapmian, mapitem, excelValue, mainfiledName, filedName);
							}else{//没有主表字段将数据放入到从表中
								computeExcelFiledData(item, com_id, mapitem, mapitem, excelValue, filedName, null);
							}
						}
					}
					///获取计算字段的值
					computeFiledData(map, com_id, mapmian, mapitem); 
					///附加系统默认字段的值
					setDefutVal(mapmian,request);
					list.add(mapitem);
					mainlist.add(mapmian);
				}
				// 关闭流
				is.close();
				///保存Excel导入数据
				Map<String,List<Map<String,Object>>> maplist=new HashMap<String, List<Map<String,Object>>>();
				maplist.put("list", list);
				maplist.put("mainlist", mainlist);
				return maplist;
			}
		} catch (Exception e) {
			String msg=e.getMessage(); 
			if (msg.contains("Invalid header signature")) {
				msg="该文件非excel生成,请在excel中进行另存或者转换为2003格式";
			}else{
				e.printStackTrace();
			}
			throw new RuntimeException(msg);
		}
	}
	  /**
     * 得到Excel表中的值
     * 
     * @param hssfCell
     *            Excel中的每一个格子
     * @return Excel中每一个格子中的值
     */
    @SuppressWarnings("static-access")
    private String getValue(HSSFCell hssfCell) {
        if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {
            // 返回布尔类型的值
            return String.valueOf(hssfCell.getBooleanCellValue());
        } else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
            // 返回数值类型的值
//        	String  excelValue=
//        	excelValue=excelValue.replaceAll(",", "");
            return String.valueOf(hssfCell.getNumericCellValue());
        }else if (hssfCell.getCellType() == HSSFCell.CELL_TYPE_FORMULA) {// 公式 
        	return String.valueOf(hssfCell.getCellFormula());
		}else {
            // 返回字符串类型的值
            return String.valueOf(hssfCell.getStringCellValue());
        }
    }
	/**
	 * 设置计算和excel字段数据值
	 * @param item 字段存放map
	 * @param com_id 
	 * @param mapmian 数据存放map 主表或者从表的map
	 * @param mapitem 当在主表中需要将数据同步到从表中的map
	 * @param excelValue Excel单元格的值
	 * @param mainfiledName 主表或者从表的字段名称
	 * @param filedName 从表名称,当为主表的时候需要进行从表同步使用
	 */
	private StringBuffer computeExcelFiledData(Map<String,Object> item, String com_id,Map<String,Object> mapmian,Map<String,Object> mapitem,String excelValue, Object mainfiledName, Object filedName) {
		Object obj=null;
		StringBuffer msg=new StringBuffer();
		Object compute=item.get("compute");//计算字段名称
		Object tableName=item.get("tableName");//表名
		Object queryName=item.get("queryName");//查询字段值
		Object value=item.get("value");//默认固定值
		Object datatype=item.get("datatype");//数据类型
		Map<String,Object> mapquery=new HashMap<String, Object>();
		mapquery.put("com_id", com_id);
		if (excelValue==null&&value==null) {
			return msg;
		}
		if (tableName!=null) {//需要进行计算的字段
			//1.先将excel中读取的值放入该字段map中
			///<item mainfiledName="dept_id" compute="sort_id" tableName="Ctl00701" queryName="dept_id" index="0"/>
//			mapmian.put(mainfiledName.toString(), excelValue);
			mapquery.put("table", tableName);
			mapquery.put("showFiledName", compute);
			if (queryName!=null) {//查询字段如果有//如果没有就表示查询数据库第一条值
				String findFiled=null;
				String orfindfiled="";
				Object like=item.get("like");
				Object or=item.get("or");//数据类型
				if (excelValue!=null||value!=null) {
					if (like!=null) {//查询方法,直接查询或者模糊查询
						findFiled=queryName+" like '%";
						if (or!=null) {
							orfindfiled=or+" like '%";
						}
					}else{
						findFiled=queryName+"='";
						if (or!=null) {
							orfindfiled=or+" ='";
						}
					}
					if (datatype!=null) {
						if ("txt".equals(datatype)) {//数据类型为文本的时候
							excelValue=excelValue.split("\\.")[0];
						}
					}
					if (value!=null) {//有默认值,就使用默认值作为查询字段值
						findFiled+=value;
						if (or!=null) {
							orfindfiled+=value;
						}
					}else{//如果没有默认值表示使用Excel已有字段的值作为查询值 
						findFiled+=excelValue;
						if (or!=null) {
							orfindfiled+=excelValue;
						}
					}
					if (findFiled!=null) {
						if (like!=null) {//查询方法,直接查询或者模糊查询
							mapquery.put("findFiled", findFiled+"%' or "+orfindfiled+"%'");
						}else{
							mapquery.put("findFiled", findFiled+"' or "+orfindfiled+"'");
						}
					}
				}
			}
			obj=productService.getOneFiledNameByID(mapquery);
			if (obj==null) {
				Object excelChineseName=item.get("excelChineseName");
				String name=mainfiledName.toString();
				if (excelChineseName!=null) {
					name=excelChineseName.toString();
				}
				if (value!=null&&value!="null") {
					msg.append(name).append(",");
					msg.append(value).append(",");
				}else{
					if (StringUtils.isNotBlank(excelValue)&&excelValue!="null") {
						msg.append(name).append(",");
						msg.append(excelValue).append(",");
					}
				}
				LoggerUtils.info(excelValue);
				Object isnullval=item.get("isnullval");//数据类型
				if (isnullval!=null) {
					obj=isnullval;
				}
			}else{
				obj=obj.toString().trim();
			}
			mapmian.put(mainfiledName.toString(), obj);
		}else{//没有表名,表示不需要进行查询计算直接放入map中
			mapmian.put(mainfiledName.toString(), excelValue);
			obj=excelValue;//并准备向从表中放入数据准备
		}
		if (filedName!=null) {//同时需要放入到从表中
			///<item mainfiledName="clerk_id" filedName="clerk_id_sid" compute="clerk_id" tableName="Ctl00801" queryName="self_id" index="2"/>
			mapitem.put(filedName.toString(), obj);
		}
		return msg;
	}
	
	/**
	 * 设置计算字段的值
	 * @param map 字段存放map
	 * @param com_id
	 * @param mapmian 主表map
	 * @param mapitem 从表map
	 */
	private StringBuffer computeFiledData(Map<String,Map<String, Object>> map, String com_id,Map<String,Object> mapmian,Map<String,Object> mapitem) {
		Map<String,Object> c_key= map.get("c_key");
		if (c_key!=null) {
			int len=Integer.parseInt(c_key.get("c_key").toString());
			if (len>0) {
				StringBuffer buffer=new StringBuffer();
				for (int j = 0; j < len; j++) {
					Map<String,Object> item=map.get(computedata+j);
					if (item!=null) {
						Object mainfiledName=item.get("mainfiledName");//主表字段名称
						Object filedName=item.get("filedName");//从表字段名称
						Object auto=item.get("auto");//是否调用存储过程自动计算字段
						if (auto!=null) {//如果为auto表示要自动生成单号,放入map中转到Service进行生成
//							mapmian.put("no", mainfiledName);
						}else if (mainfiledName!=null) {//判断是否要将数据放入到主表中,不为空就放入到主表中
							buffer.append(setComputeFiledData(item, com_id, mapmian, mapitem,mainfiledName,filedName));
						}else{//为空就放入到从表中
							buffer.append(setComputeFiledData(item, com_id, mapitem, mapitem,filedName,null));
						}
						
					}
				}
				return buffer;
			}
		}
		return null;
	}
	/**
	 * 设置默认字段的数据
	 * @param mapmian
	 * @param request
	 */
	private void setDefutVal(Map<String, Object> mapmian,
			HttpServletRequest request) {
		String clerk= getEmployeeId(request);
		if (StringUtils.isBlank(clerk)) {
			clerk=getComId(request);
		}
//		Calendar c = Calendar.getInstance();
//		mapmian.put("finacial_y", c.get(Calendar.YEAR));
//		mapmian.put("finacial_m", c.get(Calendar.MONTH));
		mapmian.put("mainten_clerk_id", clerk);
		mapmian.put("mainten_datetime",getNow());

	}
	/**
	 * 设置计算字段的数据
	 * @param item 配置文件中的字段名称
	 * @param com_id 
	 * @param mapmian 数据存放map,主表或者从表的map
	 * @param mapitem 从表map主要是从里面取数据进行sql查询计算
	 * @param mainfiledName 放入到map中的字段名称
	 * @param filedName 当在主表执行的时候从表也需要同步放入数据的字段名称,从表的时候为空
	 */
	private StringBuffer setComputeFiledData(Map<String,Object> item, String com_id,Map<String,Object> mapmian,Map<String,Object> mapitem,Object mainfiledName,Object filedName){
		if (mainfiledName!=null) {
			Object compute=item.get("compute");//计算字段名称
			Object tableName=item.get("tableName");//表名
			Object queryName=item.get("queryName");//查询字段值
			Object orname=item.get("orname");//比较查询字段值
			StringBuffer msg=new StringBuffer();
			Object value=item.get("value");//默认固定值
			Map<String,Object> mapquery=new HashMap<String, Object>();
			mapquery.put("com_id", com_id);
			String findFiled=null;
			Object obj=null;
			if (mapitem.get(queryName)==null&&value==null) {
				return msg;
			}
			if (tableName!=null&&(mapitem.get(queryName)!=null||value!=null)) {//判断是否有表名,有进入数据库进行查询
				mapquery.put("table", tableName);
				mapquery.put("showFiledName", compute);
					if (queryName!=null) {//查询字段如果有//如果没有就表示查询数据库第一条值
						Object like=item.get("like");
						if (like!=null) {//查询方法,直接查询或者模糊查询
							findFiled=queryName+" like '%";
						}else{
							findFiled=queryName+"='";
						}
						if (value!=null) {//有默认值,就使用默认值作为查询字段值
							findFiled+=value;
						}else{//如果没有默认值表示使用Excel已有字段的值作为查询值
							///<item filedName="unit_id" compute="item_unit" tableName="ctl03001" queryName="peijian_id"/>
							findFiled+=mapitem.get(queryName);
						}
						if (like!=null) {//查询方法,直接查询或者模糊查询
							mapquery.put("findFiled", findFiled+"%'");
						}else{
							mapquery.put("findFiled", findFiled+"'");
						}
				}
				//查询数据库获取数据
				obj=productService.getOneFiledNameByID(mapquery);
				//放入到主表的map中
				if (obj!=null) {
					obj=obj.toString().trim();
				}else{
					Object excelChineseName=item.get("excelChineseName");
					String name=mainfiledName.toString();
					if (excelChineseName!=null) {
						name=excelChineseName.toString();
					}
					if (value!=null&&value!="null") {
						msg.append(name).append(",");
						msg.append(value).append(",");
					}else{
						if (mapitem.get(queryName)!=null&&mapitem.get(queryName)!="null") {
							msg.append(name).append(",");
							msg.append(mapitem.get(queryName)).append(",");
						}
					}
					LoggerUtils.info(mapitem.get(queryName));
					Object isnullval=item.get("isnullval");//数据类型
					if (isnullval!=null) {
						obj=isnullval;
					}
				}
				mapmian.put(mainfiledName.toString(), obj);
			}else{//判断是否有表名,没有就使用xml中固定的值
				if (orname!=null) {//不为空就根据字段字段值的大小选择相应的值
					///<item mianfiledName="ivt_oper_bill" orname="send_sum" value="发货" valueOr="退货"/>
					try {
						Object compareSrc=item.get("orname");//比较查询字段值来源主表或者从表
						String ornameval=mapitem.get(orname).toString();
						if ("main".equals(compareSrc)) {
							ornameval=mapmian.get(orname).toString();
						} 
						BigDecimal big=new BigDecimal(ornameval);
						// if(r==0) //等于 if(r==1) //大于 if(r==-1) //小于
						if (big.compareTo(BigDecimal.ZERO)==1) {//大于0//是value的值
							obj=value;//查询字段值
						}else{//小于等于0使用valueor中的值
							obj=item.get("valueOr");//查询字段值
						}
					} catch (Exception e) {}
				}else{///<item mianfiledName="sd_order_direct" value="发货"/>
					obj=value;
				}
				//放入到主表的map中
				mapmian.put(mainfiledName.toString(), obj);
			}
			if (filedName!=null) {//如果不为空表示该数据既要放入主表也要放入从表
				mapitem.put(filedName.toString(), obj);
			}
			return msg;
		}
		return null;
	}
	/**
	 * 发送订单导入短信
	 * @param request
	 * @return
	 */
	@RequestMapping("sendSms")
	@ResponseBody
	public ResultInfo sendSms(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			msg=productService.sendSms(map,request);
			msg=request.getSession().getAttribute("excesms").toString();
			Object obj=request.getSession().getAttribute("smserror");
			if (obj!=null) {
				msg+=obj;
			}
			request.getSession().removeAttribute("excesms");
			request.getSession().removeAttribute("smserror");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	
	/**
	 * 计划日明细
	 * @param request
	 * @param query
	 * @return
	 */
	@ResponseBody
	@RequestMapping("planDayDetail")
	public PageList<Map<String,Object>> planDayDetail(HttpServletRequest request,ProductQuery query) {
		String item_name=request.getParameter("item_name");
		String beginDate=request.getParameter("beginDate");
		String sd_order_direct=request.getParameter("sd_order_direct");
		String excel=request.getParameter("excel");
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("item_name",item_name);
		map.put("sd_order_direct",sd_order_direct);
		map.put("beginDate", beginDate);
		//获取权限查看是否只能看自己的
		getMySelf_Info(request, map);
		map.put("query", query);
		map.put("excel", excel);
		map.put("com_id",getComId(request));
		map=getPlanReportParams(map,request);
		return productService.planDayDetail(map);
	}
	/**
	 * 计划日明细导出
	 * @param request
	 * @return
	 */
	@RequestMapping("planDayDetailExcel")
	@ResponseBody
	public ResultInfo planDayDetailExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			List<Map<String,Object>> listmap=planDayDetail(request, new ProductQuery()).getRows();
			String sd_order_direct=request.getParameter("sd_order_direct");
			String configName=request.getParameter("config");
			String beginDate=request.getParameter("beginDate");
			Map<String,Object> map=new HashMap<String, Object>();
			
			map.put("list", listmap);
			map.put("date", DateTimeUtils.dateToStr());
			
			//计算所在的周次
			map.put("weeksnum", DateTimeUtils.getWeekNum(beginDate));
			ExcelUtils.addValue("listmap", map);
		    String config ="/"+getComId(request)+"/xls/"+configName+".xls";
		    StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]).append(sd_order_direct);
		    if ("weekfenxi".equals(config)) {
		    	buffer.append("分析");
			}else if ("dayfenxi".equals(config)) {
				buffer.append("分析");
			}
		    buffer.append(".xls");
		    File file=new File(getRealPath(request)+buffer.toString());
		    if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
		    OutputStream out=new FileOutputStream(file);
		    ExcelUtils.export(request.getSession().getServletContext(), config,out);
		    out.close();
		    msg="../"+buffer.toString();
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 
	 * @param zipFilePath
	 *            打包文件存放路径
	 * @param inputFolderName
	 *            需要打包的文件夹
	 * @throws Exception
	 */
	@RequestMapping("zip")
	public void zip(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String url=request.getParameter("url");
		url=url.replaceAll("\\..", "");
		String filename = getRealPath(request)+url+".zip";
		File file=new File(filename);
		
		StringBuffer srcpath = new StringBuffer(file.getParentFile().getPath());
	 
		zip(filename,  srcpath.toString());
		FileInputStream inStream = new FileInputStream(filename);
		// 设置输出的格式
		response.reset();
		response.setContentType("bin");
		response.addHeader("Content-Disposition", "attachment; filename=\""
				+ FilenameUtils.getName(filename) + "\"");
		// 循环取出流中的数据
		byte[] b = new byte[100];
		int len;
		try {
			while ((len = inStream.read(b)) > 0)
				response.getOutputStream().write(b, 0, len);
			inStream.close();
		} catch (IOException e) {
			// e.printStackTrace();
		}
		
	}

	/**
	 * 
	 * @param zipFilePath
	 *            打包文件存放路径
	 * @param inputFolderName
	 *            需要打包的文件夹
	 * @throws Exception
	 */
	public void zip(String zipFilePath, String inputFolderName)
			throws Exception {
		String zipFileName = zipFilePath; // 打包后文件名字
		File file=new File(zipFileName);
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		File zipFile = new File(inputFolderName);
		zip(zipFileName, zipFile);
	}

	private void zip(String zipFileName, File inputFolder) throws Exception {
		FileOutputStream fileOut = new FileOutputStream(zipFileName);
		ZipOutputStream out = new ZipOutputStream(fileOut);
		zip(out, inputFolder, "");
		out.close();
		fileOut.close();
	}

	private void zip(ZipOutputStream out, File inputFolder, String base)
			throws Exception {
		if (inputFolder.isDirectory()) {
			File[] fl = inputFolder.listFiles();
			out.putNextEntry(new ZipEntry(base + "/"));
			base = base.length() == 0 ? "" : base + "/";
			for (int i = 0; i < fl.length; i++) {
				zip(out, fl[i], base + fl[i].getName());
			}
		} else {
			out.putNextEntry(new ZipEntry(base));
			FileInputStream in = new FileInputStream(inputFolder);
			int b;
			while ((b = in.read()) != -1) {
				out.write(b);
			}
			in.close();
		}
	}
	
	// ///////////excel导入//////////
		/**
		 * 导入Excel
		 * 
		 * @param request
		 * @param url
		 *            备份文件路径
		 * @return
		 */
		@RequestMapping("excelImport")
		@ResponseBody
		public ResultInfo excelImport(HttpServletRequest request) {
			boolean success = false;
			String msg = null;
			try {
				String url = request.getParameter("url");
				String typeName = request.getParameter("typeName");
				String xmlname = "excel.xml"; // 应收款
				if ("ard".equalsIgnoreCase(typeName)) {
					xmlname = "ARd02051.xml"; // 收款
				} else if ("arf".equalsIgnoreCase(typeName)) {
					xmlname = "ARf02030.xml"; // 期初
				} else if ("quotationSheet".equalsIgnoreCase(typeName)) {
					xmlname = "quotationSheet.xml"; // 客户报价单
				}
				StringBuffer tempPath = new StringBuffer(getRealPath(request));
				StringBuffer filePath = new StringBuffer(getComIdPath(request));
				StringBuffer xmlPath = new StringBuffer(getComIdPath(request));
				xmlPath.append("excel/xml/").append(xmlname);

				filePath.append("excel/").append(FilenameUtils.getName(url));

				tempPath.append(url);

				File src = new File(tempPath.toString());
				if (src.exists() && src.isFile()) {
					File destFile = new File(filePath.toString());
					/*
					 * if (destFile.exists()&&destFile.isFile()) {
					 * LoggerUtils.error(destFile.delete()); }
					 */
					FileUtils.moveFile(src, destFile);
					if (destFile.exists() && destFile.isFile()) {
						if ("ard".equalsIgnoreCase(typeName)) {
							saveArdData(request, destFile, filePath, xmlPath);
						} else if ("arf".equalsIgnoreCase(typeName)) {
							saveArfData(request, destFile, filePath, xmlPath);
						} else if ("quotationSheet".equalsIgnoreCase(typeName)) {
							saveQuotationSheetData(request, destFile, filePath,
							xmlPath);
						} else {
							// /保存excel数据到订单主表和从表中
							saveExcelData(request, destFile, filePath, xmlPath);
						}
						success = true;
						if(destFile.exists()&&destFile.isFile()){
							destFile.delete();
						}
					}
				}
				// 获取excel上传信息
				msg = getMsgToSession(request);
			} catch (Exception e) {
				msg = e.getMessage();
				e.printStackTrace();
			}
			return new ResultInfo(success, msg);
		}

		private void saveQuotationSheetData(HttpServletRequest request,
				File destFile, StringBuffer filePath, StringBuffer xmlPath) {
			if ("xlsx".equals(FilenameUtils.getExtension(destFile.getName()))) {
				productService.saveQuotationSheetExcelImportData(readExcelPoi(filePath.toString(), xmlPath.toString(),
								request), request);
			} else {
				productService.saveQuotationSheetExcelImportData(readExcel(filePath.toString(), xmlPath.toString(),
										request), request);
			}
		}
		
////////////////////产品展示类型,品牌查询相关//////////////////
	/**
	 *  获取一个产品字段查询
	 * @param name 查询的字段名
	 * @return
	 */
	@RequestMapping("getOneProductFiledList")
	@ResponseBody
	public PageList<Map<String,Object>> getOneProductFiledList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("rows", 1000);
		if (map.get("name")==null||map.get("name")=="") {
			return new PageList<Map<String,Object>>();
		}
		if ("sort_name".equals(map.get("name"))) {
			map.put("table","Ctl03200");
			map.put("id","sort_id");
		}else if ("store_struct_name".equals(map.get("name"))) {
			map.put("table","Ivt01001");
			map.put("id","sort_id");
		}else{
			map.put("table","ctl03001");
			map.put("id", map.get("name"));
		}
		if (ConfigFile.isShowAllProduct) {
			map.remove("com_id");
		}
		return productService.getOneProductFiledList(map);
	}
	/**
	 *  获取指定订单编号和产品内码的订单产品列表
	 * @param orderlist
	 * @param orderNo 
	 * @param item_id
	 * @param com_id
	 * @return 订单产品列表
	 */
	@RequestMapping("getOrderProductList")
	@ResponseBody
	public List<Map<String,Object>> getOrderProductList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productService.getOrderProductList(map);
	}
	/**
	 * 获取当前运营商仓库产品列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getStoreProductList")
	@ResponseBody
	public PageList<Map<String,Object>> getStoreProductList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "item_spec")) {
			map.put("item_spec", "%"+map.get("item_spec")+"%");
		}
		if (isNotMapKeyNull(map, "type_id")&&!MapUtils.getString(map, "type_id").contains("%")) {
			map.put("type_id", map.get("type_id")+"%");
		}
		return productService.getStoreProductList(map);
	}
	
	/**
	 *  获取同一个产品名称下不同规格,颜色的产品
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductByName")
	@ResponseBody
	public List<Map<String,Object>> getProductByName(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productService.getProductByName(map);
	}
	/**
	 * 获取指定产品颜色的库存
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductAccnIvt")
	@ResponseBody
	public Map<String,Object> getProductAccnIvt(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (isNotMapKeyNull(map, "add")) {
			map.put("customer_id", getUpperCustomerId(request));
		}
		return productService.getProductAccnIvt(map);
	}
	
	/**
	 * 获取产品列表根据多级类型名称
	 * @param request
	 * @return 库存数
	 */
	@RequestMapping("getProductByTypeName")
	@ResponseBody
	public List<Map<String,Object>> getProductByTypeName(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (isMapKeyNull(map, "rows")) {
			map.put("rows", 6);
		}
		return productService.getProductByTypeName(map);
	}
	
	/**
	 * 获取产品列表分页根据多级类型名称
	 * @param request
	 * @return 分页数据
	 */
	@RequestMapping("getProductPageByTypeName")
	@ResponseBody
	public PageList<Map<String,Object>> getProductPageByTypeName(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "params")) {
			JSONArray jsons=JSONArray.fromObject(map.get("params"));
			map.put("jsons", jsons);
		}
		getOrderProductParams(request, map);
		return productService.getProductPageByTypeName(map);
	}
	/**
	 * 获取产品参数根据指定字段
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductParam")
	@ResponseBody
	public List<Map<String,Object>> getProductParam(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (isNotMapKeyNull(map, "filedName")) {
			return productService.getProductParam(map);
		}
		return null;
	}
	/**
	 *  获取家装案例详情+设计师信息
	 * @param request
	 * @return 案例详情与设计师详情
	 */
	@RequestMapping("getSpruceInfo")
	@ResponseBody
	public Map<String,Object> getSpruceInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productService.getSpruceInfo(map);
	}
	
}
 