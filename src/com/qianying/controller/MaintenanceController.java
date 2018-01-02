package com.qianying.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.excelutils.ExcelUtils;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.controller.business.ProductController;
import com.qianying.page.PageList;
import com.qianying.page.ProductQuery;
import com.qianying.service.IMaintenanceService;
import com.qianying.service.IProductionManagementService;
import com.qianying.util.DateTimeUtils;

/**
 * 维护控制
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/maintenance")
public class MaintenanceController extends ProductController {
	
	@Autowired
	private IMaintenanceService maintenanceService;
	@Autowired
	private IProductionManagementService productionManagementService;
	
	/**
	 * 员工基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("employeeImport")
	@ResponseBody
	public ResultInfo employeeImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("员工信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.employeeImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
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
	 * 员工导出
	 * @param request
	 * @return
	 */
	@RequestMapping("employeeExport")
	@ResponseBody
	public ResultInfo employeeExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.employeeExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/员工信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("员工信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("daylogexcel")
	@ResponseBody
	public ResultInfo daylogexcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			List<Map<String,Object>> list=DateTimeUtils.getDay(2017);
			//将数据集合放入导出中 
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/daylogexcel.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append("工作日志.xls");
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
	
	public static void main(String[] args) {
		int year= 2016;
		 int m=1;//月份计数
		 while (m<13)
		 {
		  int month=m;
		  Calendar cal=Calendar.getInstance();//获得当前日期对象
		  cal.clear();//清除信息
		  cal.set(Calendar.YEAR,year);
		  cal.set(Calendar.MONTH,month-1);//1月从0开始
		  cal.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天 
		  
		  System.out.println("##########___" + sdf.format(cal.getTime()));
		  
		  int count=cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		  
		  System.out.println("$$$$$$$$$$________" + count);
		  
		  for (int j=0;j<=(count - 2);)
		  {
		  cal.add(Calendar.DAY_OF_MONTH,+1);
		  j++;
		  System.out.println(sdf.format(cal.getTime()));
		  }
		  m++;
		 } 
	}
	
	/**
	 * 部门基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("departmentImport")
	@ResponseBody
	public ResultInfo departmentImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("部门信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.departmentImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 部门导出
	 * @param request
	 * @return
	 */
	@RequestMapping("departmentExport")
	@ResponseBody
	public ResultInfo departmentExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.departmentExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/部门信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("部门信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 结算方式基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("settlementImport")
	@ResponseBody
	public ResultInfo settlementImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("结算方式信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.settlementImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 结算方式导出
	 * @param request
	 * @return
	 */
	@RequestMapping("settlementExport")
	@ResponseBody
	public ResultInfo settlementExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.settlementExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/结算方式信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("结算方式信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 行政区划基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("regionalismImport")
	@ResponseBody
	public ResultInfo regionalismImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("行政区划信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.regionalismImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 行政区划导出
	 * @param request
	 * @return
	 */
	@RequestMapping("regionalismExport")
	@ResponseBody
	public ResultInfo regionalismExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.regionalismExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/行政区划信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("行政区划信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 客户基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("clientImport")
	@ResponseBody
	public ResultInfo clientImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("客户信息.xml");
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			tempPath.append(url);
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.clientImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 客户导出
	 * @param request
	 * @return
	 */
	@RequestMapping("clientExport")
	@ResponseBody
	public ResultInfo clientExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.clientExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/客户信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("客户信息.xls");
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 库房基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("warehouseImport")
	@ResponseBody
	public ResultInfo warehouseImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("库房信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.warehouseImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 库房导出
	 * @param request
	 * @return
	 */
	@RequestMapping("warehouseExport")
	@ResponseBody
	public ResultInfo warehouseExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.warehouseExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/库房信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("库房信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 产品基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("prodImport")
	@ResponseBody
	public ResultInfo prodImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("产品信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.prodImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 产品导出
	 * @param request
	 * @return
	 */
	@RequestMapping("prodExport")
	@ResponseBody
	public ResultInfo prodExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.prodExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/产品信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("产品信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 产品类别基础数据导入
	 * @param request
	 * @return
	 */
	@RequestMapping("prodClassImport")
	@ResponseBody
	public ResultInfo prodClassImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("产品类别信息.xml");
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			tempPath.append(url);
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.prodClassImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 产品类别导出
	 * @param request
	 * @return
	 */
	@RequestMapping("prodClassExport")
	@ResponseBody
	public ResultInfo prodClassExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.prodClassExport(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/产品类别信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("产品类别信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 库存表导入 ，特殊环境使用
	 * @param request
	 * @return
	 */
	@RequestMapping("wareImport")
	@ResponseBody
	public ResultInfo wareImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			msg=maintenanceService.wareImport(getExcelData(request, "库存"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 库存导出
	 * @param request
	 * @return
	 */
	@RequestMapping("wareExport")
	@ResponseBody
	public ResultInfo wareExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			map.put("page", 10000);
//			PageList<Map<String,Object>> pages=productionManagementService.initialMaintenancePage(map);
			List<Map<String,Object>> list=productionManagementService.getWareList(map);
			msg=excelExport(request, list, "库存");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取库存列表
	 * @return
	 */
	@RequestMapping("getWarePage")
	@ResponseBody
	public PageList<Map<String,Object>> getWarePage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "item_spec")) {
			map.put("item_spec", "%"+map.get("item_spec")+"%");
		}
		return productionManagementService.getWarePage(map);
	}
	
	/**
	 * 应收初始导入
	 * @param request
	 * @return
	 */
	@RequestMapping("receivableImport")
	@ResponseBody
	public ResultInfo receivableImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("ARf02030.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.receivableImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 从excel中获取需要导入的数据
	 * @param request
	 * @param xmlName excel的xml配置文件名
	 * @return 从excel中获取的数据
	 * @throws IOException
	 */
	public Map<String,List<Map<String,Object>>> getExcelData(HttpServletRequest request,String xmlName) throws IOException{
		String url=request.getParameter("url");
		StringBuffer tempPath=new StringBuffer(getRealPath(request));
		StringBuffer filePath=new StringBuffer(getRealPath(request));
		StringBuffer xmlPath=new StringBuffer(getRealPath(request));
		xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append(xmlName+".xml");		
		filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
		tempPath.append(url);
		File src=new File(tempPath.toString());
		Map<String,List<Map<String,Object>>> map=null;
		if (src.exists()&&src.isFile()) {
			File destFile=new File(filePath.toString());
			FileUtils.moveFile(src, destFile);
			if (destFile.exists()&&destFile.isFile()) {
				map=readExcel(filePath.toString(), xmlPath.toString(), request);
				destFile.delete();
			}
		}
		return map;
	}
	
	/**
	 * 库存调拨单导入
	 * @param request
	 * @return
	 */
	@RequestMapping("inventoryAllocationImport")
	@ResponseBody
	public ResultInfo inventoryAllocationImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			msg=maintenanceService.inventoryAllocation(getExcelData(request, "库存调拨"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 库存调拨单导出
	 * @param request
	 * @return
	 */
	@RequestMapping("inventoryAllocationExport")
	@ResponseBody
	public ResultInfo inventoryAllocationExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("page", 10000);
		    List<Map<String,Object>> list =productionManagementService.inventoryAllocationFind(map).getRows();
		    msg=excelExport(request, list, "库存调拨");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 供应商导入
	 * @param request
	 * @return
	 */
	@RequestMapping("vendorImport")
	@ResponseBody
	public ResultInfo vendorImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			msg=maintenanceService.vendorinit(getExcelData(request, "供应商"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 供应商导出
	 * @param request
	 * @return
	 */
	@RequestMapping("vendorExport")
	@ResponseBody
	public ResultInfo vendorExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list = maintenanceService.vendorExport(map);
			msg=excelExport(request, list, "供应商");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 运营商导入
	 * @param request
	 * @return
	 */
	@RequestMapping("operateImport")
	@ResponseBody
	public ResultInfo operateImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			msg=maintenanceService.operateInit(getExcelData(request, "运营商"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 运营商导出
	 * @param request
	 * @return
	 */
	@RequestMapping("operateExport")
	@ResponseBody
	public ResultInfo operateExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list = maintenanceService.operateExport(map);
			msg=excelExport(request, list, "运营商");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 司机导入
	 * @param request
	 * @return
	 */
	@RequestMapping("driverImport")
	@ResponseBody
	public ResultInfo driverImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String type=request.getParameter("type");
			if (StringUtils.isBlank(type)) {
				type="司机";
			}
			msg=maintenanceService.driverAndDianInit(getExcelData(request, type),"1");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 电工导入
	 * @param request
	 * @return
	 */
	@RequestMapping("dianImport")
	@ResponseBody
	public ResultInfo dianImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String type="电工";
			msg=maintenanceService.driverAndDianInit(getExcelData(request, type),"E");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 司机导出
	 * @param request
	 * @return
	 */
	@RequestMapping("driverExport")
	@ResponseBody
	public ResultInfo driverExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);		
			String type=request.getParameter("type");
			if (StringUtils.isBlank(type)) {
				type="司机";
				map.put("isclient", 1);
			}else{
				map.put("isclient", 0);
			}
			List<Map<String,Object>> list = maintenanceService.driverAndDianExport(map);
			msg=excelExport(request, list, type);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}	
	/**
	 * 电工的导出
	 * @param request
	 * @return
	 */
	@RequestMapping("dianExport")
	@ResponseBody
	public ResultInfo dianExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);		
			String type=request.getParameter("type");						
				type="电工";
				map.put("isclient", 0);	
			List<Map<String,Object>> list = maintenanceService.driverAndDianExport(map);
			msg=excelExport(request, list, type);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 库存初始化导入
	 * @param request
	 * @return
	 */
	@RequestMapping("wareinitImport")
	@ResponseBody
	public ResultInfo wareinitImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("库存初始化信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.wareinitImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 库存初始化导出
	 * @param request
	 * @return
	 */
	@RequestMapping("wareinitExport")
	@ResponseBody
	public ResultInfo wareinitExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.getWareinitAll(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/库存初始化信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("库存初始化信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 期初应收导出
	 * @param request
	 * @return
	 */
	@RequestMapping("initialReceivableExcel")
	@ResponseBody
	public ResultInfo initialReceivableExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.initialReceivableExcel(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/期初应收.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("期初应收.xls");
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	
	/**
	 * 计量单位导入
	 * @param request
	 * @return
	 */
	@RequestMapping("meteringUnitImport")
	@ResponseBody
	public ResultInfo meteringUnitImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("计量单位信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.meteringUnitImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 计量单位导出
	 * @param request
	 * @return
	 */
	@RequestMapping("meteringUnitExport")
	@ResponseBody
	public ResultInfo meteringUnitExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.getMeteringUnitAll(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/计量单位信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("计量单位信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 期初应付导入
	 * @param request
	 * @return
	 */
	@RequestMapping("payableImport")
	@ResponseBody
	public ResultInfo payableImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("期初应付信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.payableImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 期初应付导出
	 * @param request
	 * @return
	 */
	@RequestMapping("payableExport")
	@ResponseBody
	public ResultInfo payableExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.getPayableAll(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/期初应付信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("期初应付信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 产地品牌导入
	 * @param request
	 * @return
	 */
	@RequestMapping("producareaImport")
	@ResponseBody
	public ResultInfo producareaImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("产地品牌信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.producareaImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 产地品牌导出
	 * @param request
	 * @return
	 */
	@RequestMapping("producareaExport")
	@ResponseBody
	public ResultInfo producareaExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.getProducareaAll(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/产地品牌信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("产地品牌信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 会计科目导入
	 * @param request
	 * @return
	 */
	@RequestMapping("accountingSubjectsImport")
	@ResponseBody
	public ResultInfo accountingSubjectsImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("会计科目信息.xml");
			
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.accountingSubjectsImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 会计科目导出
	 * @param request
	 * @return
	 */
	@RequestMapping("accountingSubjectsExport")
	@ResponseBody
	public ResultInfo accountingSubjectsExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =maintenanceService.getAccountingSubjectsAll(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/会计科目信息.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("会计科目信息.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}


/**
	 * 体检表导出
	 * @param request
	 * @return
	 */
	@RequestMapping("tijianExport")
	@ResponseBody
	public ResultInfo tijianExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list = maintenanceService.tijianExport(map);
			msg=excelExport(request, list, "体检表");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 体检表导入
	 * @param request
	 * @return
	 */
	@RequestMapping("tijianImport")
	@ResponseBody
	public ResultInfo tijianImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			msg=maintenanceService.tijianInit(getExcelData(request, "体检表"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 客户报价单导入
	 * @param request
	 * @return
	 */
	@RequestMapping("quotationSheetImport")
	@ResponseBody
	public ResultInfo quotationSheet(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("客户报价单.xml");
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.quotationSheetImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 客户报价单导出
	 * @param request
	 * @return
	 */
	@RequestMapping("quotationSheetExport")
	@ResponseBody
	public ResultInfo quotationSheetExport(HttpServletRequest request,ProductQuery query) {
		boolean success = false;
		String msg = null;
		try {
			query.setCom_id(getComId());
			List<Map<String,Object>> list = maintenanceService.quotationSheetExport(query);
			msg=excelExport(request, list, "客户报价单");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 产品生产计划导入
	 * @param request
	 * @return
	 */
	@RequestMapping("productionPlanSheetImport")
	@ResponseBody
	public ResultInfo productionPlanSheet(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("产品生产计划.xml");
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.productionPlanSheetImport(
							readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 产品生产计划导出
	 * @param request
	 * @return
	 */
	@RequestMapping("productionPlanExport")
	@ResponseBody
	public ResultInfo productionPlanExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list = maintenanceService.exportProductionPlan(map);
			msg=excelExport(request, list, "产品生产计划");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 材料生产计划导入
	 * @param request
	 * @return
	 */
	@RequestMapping("materialproductionPlanSheetImport")
	@ResponseBody
	public ResultInfo materialproductionPlanSheet(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("材料生产计划.xml");
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.materialproductionPlanSheetImport(readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 采购验收入库单导入
	 */
	@RequestMapping("purchasingSheetImport")
	@ResponseBody
	public ResultInfo purchasingSheetImport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			StringBuffer tempPath=new StringBuffer(getRealPath(request));
			StringBuffer filePath=new StringBuffer(getRealPath(request));
			StringBuffer xmlPath=new StringBuffer(getRealPath(request));
			xmlPath.append("/").append(getComId(request)).append("/excel/xml/").append("采购验收入库.xml");
			filePath.append("/").append(getComId(request)).append("/excel/").append(FilenameUtils.getName(url));
			tempPath.append(url);
			
			File src=new File(tempPath.toString());
			if (src.exists()&&src.isFile()) {
				File destFile=new File(filePath.toString());
				FileUtils.moveFile(src, destFile);
				if (destFile.exists()&&destFile.isFile()) {
					msg=maintenanceService.purchasingSheetImport(
							readExcel(filePath.toString(), xmlPath.toString(), request)).toString();
					success = true;
					destFile.delete();
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
	 * 已增加入库单导出
	 * @param request
	 * @return
	 */
	@RequestMapping("purchasingSheetExport")
	@ResponseBody
	public ResultInfo purchasingSheetExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list = maintenanceService.purchasingSheetExport(map);
			msg=excelExport(request, list, "采购验收入库");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
}

