package com.qianying.controller.business;

import java.io.File;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import net.sf.excelutils.ExcelUtils;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.controller.FilePathController;
import com.qianying.page.PageList;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IStatisticalRreportService;

/**
 * 报表控制模块
 * 
 * @author dengqiang
 *
 */
@Component
@Controller
@RequestMapping("/report")
@Scope("prototype")
public class StatisticalRreportController extends FilePathController{
	@Autowired
	private IEmployeeService employeeService;
	@Autowired
	private IStatisticalRreportService statisticalRreportService;
	@Autowired
	private ICustomerService customerService;

	/**
	 * 订单销售统计按部门总报表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReportDeptCount")
	public String orderReportDeptCount(HttpServletRequest request) {

		return "pc/report/orderReportDeptCount";
	}

	/**
	 * 获取订单分部门总列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReportDeptCountlist")
	@ResponseBody
	public PageList<Map<String, Object>> orderReportDeptCountlist(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		getMySelf_Info(request, map);
		getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql",
				"dept_id", "t1.", employeeService);
		return statisticalRreportService.orderReportDeptCountlist(map);
	}

	/**
	 * 订单销售统计部门明细
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReportDeptDetail")
	public String orderReportDeptDetail(HttpServletRequest request) {
		return "pc/report/orderReportDeptDetail";
	}
	
	/**
	 * 销售报表
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReport")
	public String orderReport(HttpServletRequest request) {
		return "pc/report/orderReport";
	}
	
	/**
	 * 获取订单分部门总列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReportDeptDetailList")
	@ResponseBody
	public PageList<Map<String, Object>> orderReportDeptDetailList(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		getMySelf_Info(request, map);
		getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql",
				"dept_id", "t1.", employeeService);
		return statisticalRreportService.orderReportDeptDetailList(map);
	}
	
	/**
	 * 销售统计报表(含-明细统计、-客户统计、-业务员统计):导出
	 * @param request
	 * @return
	 */
	@RequestMapping("orderReportDeptDetailListExcel")
	@ResponseBody
	public ResultInfo orderReportDeptDetailListExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String client=request.getParameter("client");
			String clerk=request.getParameter("clerk");
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("excel", "excel");
			//获取要导出的数据
			List<Map<String,Object>> list =statisticalRreportService.orderReportDeptDetailListExcel(map);
			Map<String,Object> maplist=new HashMap<String, Object>();
			maplist.put("map", map);
			maplist.put("list", list);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", maplist);
			//Excel模块相对路径    ****重要****
			String config ="/"+getComId(request)+"/xls/";
			if (StringUtils.isNotBlank(client)) {
				config+="saleStatistic_customer.xls";//客户统计导出模板
			}
			if (StringUtils.isNotBlank(clerk)) {
				config+="saleStatistic_clerk.xls";//业务员统计导出模板
			}
			if (StringUtils.isBlank(clerk)&&StringUtils.isBlank(client)) {
				config+="saleStatistic_multiDetail.xls";//明细统计导出模板E:\work\twtest\WebContent\001\xls
			}
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    if (StringUtils.isNotBlank(client)) {
				///生成的文件名   ****重要****//客户统计导出文件名
				buffer.append("销售统计报表-客户统计.xls"); 
			}
			if (StringUtils.isNotBlank(clerk)) {
				///生成的文件名   ****重要****//业务员统计导出文件名
				buffer.append("销售统计报表-业务员统计.xls"); 
			}
			if (StringUtils.isBlank(clerk)&&StringUtils.isBlank(client)) {
				///生成的文件名   ****重要****//明细统计导出文件名
				buffer.append("销售统计报表-明细统计.xls"); 
			}
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
	 * 订单明细记录
	 * @param request
	 * @return
	 */
	@RequestMapping("orderRecord")
	@ResponseBody
	public PageList<Map<String,Object>> orderRecord(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		getMySelf_Info(request, map);
		getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql",
				"dept_id", "t1.", employeeService);
		return statisticalRreportService.orderRecord(map);
	}
	/**
	 * 订单明细记录导出
	 * @param request
	 * @return
	 */
	@RequestMapping("orderRecordExcel")
	@ResponseBody
	public ResultInfo orderRecordExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			getMySelf_Info(request, map);
			getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql",
					"dept_id", "t1.", employeeService);
			//获取要导出的数据
			List<Map<String,Object>> list =statisticalRreportService.orderRecordExcel(map);
			Map<String,Object> maplist=new HashMap<String, Object>();
			maplist.put("map", map);
			maplist.put("list", list);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", maplist);
			
			//Excel模块相对路径    ****重要****
			String config ="/"+getComId(request)+"/xls/saleStatistic_record.xls";
			
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    
		    ///生成的文件名   ****重要****
		    buffer.append("销售记录.xls");
		    
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/***
	 * 销售明细订单总计
	 * @param request
	 * @return
	 */
	@RequestMapping("orderRecordSum")
	@ResponseBody
	public Map<String,Object> orderRecordSum(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		getMySelf_Info(request, map);
		getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql",
				"dept_id", "t1.", employeeService);
		return statisticalRreportService.orderRecordSum(map);
	}
	/**
	 * 销售收款报表
	 * @param request
	 * @return
	 */
	@RequestMapping("receivablesReport")
	public String receivablesReport(HttpServletRequest request) {
		return "pc/report/receivablesReport";
	}
	
	/**
	 * 销售收款报表
	 * @param request
	 * @return
	 */
	@RequestMapping("receivablesReportList")
	@ResponseBody
	public PageList<Map<String,Object>> receivablesReportList(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
//		getMySelf_Info(request, map);
		getDept_idInfoQuery(request, map, "customer_id", "customer_id.sql",
				"customer_id", "t1.", employeeService);
		return statisticalRreportService.receivablesReportList(map);
	}
	/**
	 * 客户对账单
	 * @param request
	 * @return
	 */
	@RequestMapping("accountStatement")
	public String accountStatement(HttpServletRequest request) {
		return "pc/report/accountStatement";
	}
	/**
	 * 对账单查询
	 * @param request
	 * @return
	 */
	@RequestMapping("accountStatementList")
	@ResponseBody
	public PageList<Map<String,Object>> accountStatementList(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
//		getMySelf_Info(request, map);
		if (getCustomer(request)==null) {
		getDept_idInfoQuery(request, map, "customer_id", "customer_id.sql",
				"customer_id", "t1.", employeeService);
		getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql",
				"dept_id", null, employeeService);
		}
		if (getUpperCustomerId(request)!=null) {
			map.put("client_id", getUpperCustomerId(request));
		}
		return statisticalRreportService.accountStatementList(map);
		
	}
	/**
	 * 获取签名图片
	 * @param request
	 * @return
	 */
	@RequestMapping("getQianmingimg")
	@ResponseBody
	public ResultInfo getQianmingimg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String qianmingTime=request.getParameter("qianmingTime");
			String type=request.getParameter("type");
			String orderNo=request.getParameter("orderNo");
			String item_id=request.getParameter("item_id");
			StringBuffer path=new StringBuffer(getRealPath(request));
			path.append("001/").append("qianming/");
			if (StringUtils.isNotBlank(type)) {
				if(StringUtils.isNotBlank(qianmingTime)){
					path.append(type).append("/").append(qianmingTime).append(".log");
					msg=getFileTextContent(path.toString());
				}
//				File file=new File(path.toString());
//				if (file.exists()&&file.isDirectory()) {
//					for (File item : file.listFiles()) {
//						if (item.getPath().contains(qianmingTime)) {
//							msg=getFileTextContent(item);
//							break;
//						}
//					}
//				}
			}else{
				path.append(orderNo).append("/").append(item_id).append(".log");
				msg=getFileTextContent(path.toString());
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 应收款总账
	 * @param request
	 * @return
	 */
	@RequestMapping("accountsReceivableLedger")
	public String accountsReceivableLedger(HttpServletRequest request) {
		
		return "pc/report/accountsReceivableLedger";
	}
	/**
	 * 应收款总账查询
	 * @param request
	 * @return
	 */
	@RequestMapping("accountsReceivableLedgerList")
	@ResponseBody
	public PageList<Map<String,Object>> accountsReceivableLedgerList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		getDept_idInfoQuery(request, map, "customer_id", "customer_id.sql",
				"customer_id", "t1.", employeeService);
		return statisticalRreportService.accountsReceivableLedgerList(map);
	}
	/**
	 * 应收款总账导出
	 * @param request
	 * @return
	 */
	@RequestMapping("accountsReceivableLedgerListExport")
	@ResponseBody
	public ResultInfo accountsReceivableLedgerListExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			getDept_idInfoQuery(request, map, "customer_id", "customer_id.sql",
					"customer_id", "t1.", employeeService);
			//获取要导出的数据
			List<Map<String,Object>> list =statisticalRreportService.accountsReceivableLedgerList(map).getRows();
			Map<String,Object> maplist=new HashMap<String, Object>();
			maplist.put("map", map);
			maplist.put("list", list);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", maplist);
			
			//Excel模块相对路径    ****重要****
			String config ="/"+getComId(request)+"/xls/应收账款总账导出模板.xls";
			
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    
		    ///生成的文件名   ****重要****
		    buffer.append("销售应收账款总账导出.xls");
		    
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
	 * 邀请客户对账
	 * @param request
	 * @return
	 */
	@RequestMapping("inviteReconciliation")
	@ResponseBody
	public ResultInfo inviteReconciliation(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			statisticalRreportService.inviteReconciliation(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 采购付款报表
	 */
	@RequestMapping("purchasingPayment")
	public String purchasingPayment(HttpServletRequest request){
		return "pc/report/purchasingPayment";
	}
	/**
	 * 采购付款报表数据获取
	 * @param request
	 * @return
	 */
	@RequestMapping("getPaymentSheet")
	@ResponseBody
	public PageList<Map<String,Object>> getPaymentSheet(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return statisticalRreportService.getPaymentSheet(map);
	}
	/**
	 * 应付明细账
	 * @return
	 */
	@RequestMapping("payableAccount")
	public String payableAccount(HttpServletRequest request){
		return "pc/report/payableAccount";
	}
	/**
	 * 应付明细账查询
	 * 
	 */
	@RequestMapping("getFkAccount")
	@ResponseBody
	public PageList<Map<String,Object>> getFkAccount(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValueQuery(request);
//		Map<String,Object> ygzl=getEmployee(request);
//		map.put("clerk_id", ygzl.get("clerk_id"));
//		map.put("dept_id", ygzl.get("dept_id"));
		return statisticalRreportService.getFkAccount(map);
	}
	/**
	 * 采购明细统计
	 */
	@RequestMapping("procurementAccount")
	public String procurementAccount(HttpServletRequest request){
		return "pc/report/procurementAccount";
	}
	/**
	 * 获取采购明细数据统计
	 */
	@RequestMapping("getCgmxStatistical")
	@ResponseBody
	public PageList<Map<String,Object>> getCgmxStatistical(HttpServletRequest request){
		Map<String,Object>map=getKeyAndValueQuery(request);
		return statisticalRreportService.getCgmxStatistical(map);
	}
	
	/**
	 *  直销提成报表
	 * @param request
	 * @return
	 */
	@RequestMapping("salesCommission")
	public String salesCommission(HttpServletRequest request) {
		Map<String,Object> mapparam=getKeyAndValue(request);
		List<Map<String, Object>> map=customerService.getCustomerTree(mapparam);
		request.setAttribute("clients", map);
		return "pc/report/salesCommission";
	}
	/**
	 *  直销提成报表-分页数据查询
	 * @param request
	 * @return
	 */
	@RequestMapping("getSalesCommission")
	@ResponseBody
	public PageList<Map<String,Object>> getSalesCommission(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return statisticalRreportService.getSalesCommission(map);
	}
	/**
	 *  直销奖金报表
	 * @param request
	 * @return
	 */
	@RequestMapping("salesBonus")
	public String salesBonus(HttpServletRequest request) {
		Map<String,Object> mapparam=getKeyAndValue(request);
		List<Map<String, Object>> map=customerService.getCustomerTree(mapparam);
		request.setAttribute("clients", map);
		return "pc/report/salesBonus";
	}
	
	/**
	 *  直销提成报表-分页数据查询
	 * @param request
	 * @return
	 */
	@RequestMapping("getSalesBonus")
	@ResponseBody
	public PageList<Map<String,Object>> getSalesBonus(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return statisticalRreportService.getSalesBonus(map);
	}
	
	
	/**
	 *  计划产品汇总页面
	 * @param request
	 * @return
	 */
	@RequestMapping("planReport")
	public String planReport(HttpServletRequest request) {
		return "pc/qingyuan/planReport";
	}
	
	/**
	 *  按产品进行分类汇总
	 * @param request
	 * @return
	 */
	@RequestMapping("planReportCount")
	@ResponseBody
	public List<Map<String,Object>> planReportCount(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return statisticalRreportService.planReportCount(map);
	}
	/**
	 *  按产品,客户查询明细
	 * @param request
	 * @return
	 */
	@RequestMapping("planReportDetail")
	@ResponseBody
	public List<Map<String,Object>> planReportDetail(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getCustomer(request)!=null) {
			map.put("customer_id", getUpperCustomerId(request));
		}
		return statisticalRreportService.planReportDetail(map);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("planReportDetailPage")
	@ResponseBody
	public PageList<Map<String,Object>> planReportDetailPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getCustomer(request)!=null) {
			map.put("customer_id", getUpperCustomerId(request));
		}
		return statisticalRreportService.planReportDetailPage(map);
	}
	
	@RequestMapping("planReportCountExcel")
	@ResponseBody
	public ResultInfo planReportCountExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list=statisticalRreportService.planReportCount(map);
			////////////////
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径    ****重要****
			String config ="/"+getComId(request)+"/xls/";
			config+="计划产品汇总统计.xls";//客户统计导出模板
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
			buffer.append("计划产品汇总统计.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			////////////////////
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("planReportDetailExcel")
	@ResponseBody
	public ResultInfo planReportDetailExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			List<Map<String,Object>> list=statisticalRreportService.planReportDetail(map);
			if(isMapKeyNull(map, "xlsx")){
				msg="/temp/"+getComId()+"/"+new Date().getTime()+".log";
				StringBuffer path=new StringBuffer(getRealPath(request));
				path.append(msg);
				File file=new File(path.toString());
				mkdirsDirectory(file);
				if(file.exists()&&file.isFile()){
					file.delete();
				}
				if (list!=null&&list.size()>0) {
					BigDecimal numsum=new BigDecimal(0);
					BigDecimal jesum=new BigDecimal(0);
					String config =getRealPath(request)+getComId(request)+"/xls/计划产品明细.log";
					File f=new File(config);
					Scanner scanner=new Scanner(f,"UTF-8");
					String head="";
					String content="";
					String count="";
					while (scanner.hasNext()) {
						String li=scanner.nextLine();
						if(StringUtils.isNotBlank(li)){
							if (StringUtils.isBlank(head)) {
								head=li;
							}else if (StringUtils.isBlank(content)) {
								content=li;
							}else if (StringUtils.isBlank(count)) {
								count=li;
							}else{
								break;
							}
						}
					}
					scanner.close();
					StringBuffer strhead=new StringBuffer(head).append("\r\n");
					saveFile(path.toString(), strhead.toString(), true);
					String[] cons=content.split("\\|");
					for (Map<String, Object> map2 : list) {
						String txt=content+"";
						for (int i = 0; i < cons.length; i++) {
							String con=cons[i];
							if (StringUtils.isNotBlank(con)) {
								String val=map2.get(con.trim()).toString();
								int k=val.getBytes().length;
								int l=8;
								if(!iszhwen(val)){
									l=7;
								}
								if(k<l){
									for (int j = 0; j < l-k; j++) {
										val=val+" ";
									}
								}
								txt=txt.replaceAll(con.trim(), val);
							}
						}
						txt=txt.replaceAll("\\|", "");
						txt+="\r\n";
						numsum=numsum.add(new BigDecimal(map2.get("planNum").toString()));
						jesum=jesum.add(new BigDecimal(map2.get("je").toString()));
						saveFile(path.toString(), txt, true);
					}
					count=count.replaceAll("@numsum", numsum.toString()).replaceAll("@jesum", jesum.toString());
					saveFile(path.toString(), count,true);
					success = true;
				}else{
					msg="没有可导出的数据!";
				}
			}else{
			////////////////
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径    ****重要****
			String config ="/"+getComId(request)+"/xls/";
			config+="计划产品明细.xls";//客户统计导出模板
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
			buffer.append("计划产品明细.xls"); 
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
		    success = true;
				////////////////////
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	private boolean iszhwen(String str){
		int count = 0; 
		String regEx = "[\\u4e00-\\u9fa5]"; 
		Pattern p = Pattern.compile(regEx); 
		Matcher m = p.matcher(str); 
		while (m.find()) { 
		for (int i = 0; i <= m.groupCount(); i++) { 
		count = count + 1; 
		} 
		} 
		if(count>0){
			return true;
		}else{
			return false;
		}
	}
	@RequestMapping("savePlanGys")
	@ResponseBody
	public ResultInfo savePlanGys(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=statisticalRreportService.savePlanGys(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  计划金额汇总根据店面分组
	 * @param request
	 * @return
	 */
	@RequestMapping("getPlanBusinessAccontCount")
	@ResponseBody
	public List<Map<String,Object>> getPlanBusinessAccontCount(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getCustomer(request)!=null) {
			map.put("customer_id", getUpperCustomerId(request));
		}
		return statisticalRreportService.getPlanBusinessAccontCount(map);
	}
}
