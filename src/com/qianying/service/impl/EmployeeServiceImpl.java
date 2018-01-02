package com.qianying.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.ICustomerDAO;
import com.qianying.dao.interfaces.IEmployeeDAO;
import com.qianying.dao.interfaces.IOperatorsDAO;
import com.qianying.dao.interfaces.IProductDAO;
import com.qianying.page.PageList;
import com.qianying.page.SupplierQuery;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.SendSmsUtil;
import com.qianying.util.WeiXinServiceUtil;
@Service
@Transactional
public class EmployeeServiceImpl extends BaseServiceImpl implements IEmployeeService{

	@Resource
	private IEmployeeDAO employeeDao;
	@Resource
	private ICustomerDAO customerDao;
	@Resource
	private IProductDAO productDao;
	@Autowired
	private IOperatorsDAO operatorsDao;
	@Resource
	private ICustomerService customerServer;
	@Override
	public void save(Map<String, Object> map) {
//		employeeDao.insert(map);
		employeeDao.insertSql(getInsertSql("ctl00801", map));
		try {
			///获取职位是内勤的所有人员
			Map<String,Object> mapparams=new HashMap<String, Object>();
			mapparams.put("com_id", getComId());
			mapparams.put("headship", "%客服%");
			mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title","员工注册核实" );
			String description="@comName-@Eheadship-@clerkName：有员工注册,请核实其身份并完善资料和授权,注册手机号:"+map.get("movtel");
			mapMsg.put("description",description);
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/manager/personnel.do?clerk_id="+map.get("clerk_id"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			for (int i = 0; i < touserList.size(); i++) {
				Map<String, String> item=touserList.get(i);
				String newdes=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", "客服")
						.replaceAll("@clerkName", item.get("clerk_name"));
				news.get(0).put("description",newdes);
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
				}
				news.get(0).put("description",description);
			}
		} catch (Exception e) {
			LoggerUtils.error(e.getMessage());
		}
	}

	@Override
	public void update(Map<String, Object> map) {
		employeeDao.updateByID(map);
	}

	@Override
	public void delete(Long id) {
		 employeeDao.deleteByID(id);
	}

	@Override
	public Map<String, Object> get(Long id) {
		return employeeDao.queryByID(id);
	}

	@Override
	public List<Map<String, Object>> getAll() {
		return employeeDao.getAll();
	}

	@Override
	public List<Map<String, Object>> findBySql(Map<String, Object> map) {
		return employeeDao.queryBySql(map);
	}

	@Override
	public boolean checkPhone(String phone,String com_id) {
		Integer i=employeeDao.checkPhone(phone,com_id);
		LoggerUtils.info(i);
		if (i>0) {
			return false;
		}else{
			return true;
		}
	}

	@Override
	public String getMaxClerk_id() {
		return employeeDao.getMaxClerk_id();
	}
	@Override
	public List<Map<String, Object>> loginList(Map<String,Object> map) {
		 
		return employeeDao.loginList(map);
	}
	@Override
	public Map<String, Object> checkLogin(String name,String com_id) {
		return employeeDao.checkLogin(name,com_id);
	}
	@Override
	public Map<String, Object> getEmployeeInfoByOpenid(String com_id,
			Object openid,String type) {
		Map<String, Object> map=new HashMap<>();
		map.put("com_id", com_id);
		if("企业号".equals(type)){
			map.put("weixinID", openid);
		}else{
			map.put("openid", openid);
		}
		return employeeDao.getEmployeeInfoByOpenid(map);
	}
	@Override
	public List<Map<String, Object>> getDeptBySort_id(String sort_id) {
		return employeeDao.getDeptBySort_id(sort_id);
	}

	@Override
	public PageList<Map<String, Object>> getPersonnelByClerk_id(HttpServletRequest request,
			Map<String,Object> map) {
		if (isNotMapKeyNull(map, "type_id")) {
			map.put("type_id", "%"+map.get("type_id")+"%");
		}
		if (isNotMapKeyNull(map, "dept_id")) {
			map.put("dept_id", "%"+map.get("dept_id")+"%");
		}
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.count(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>> rows = null;
		try {
			rows = employeeDao.findQuery(map);
			String real=getRealPath(request, null);
			for (Iterator<Map<String, Object>> iterator = rows.iterator(); iterator.hasNext();) {
				Map<String, Object> map2 = iterator.next();
				if (map2.get("clerk_id")!=null) {
					String clerk_id=map2.get("clerk_id").toString();
					
					StringBuffer buffer=new StringBuffer(real);
				    buffer.append("/").append(getComId(request)).append("/planquery/").append(clerk_id);
				    buffer.append("/authority.txt");
				    
				    File file=new File(buffer.toString());
				    int i=0;
				    if (file.exists()&&file.isFile()) {//计算有多少权限
					   InputStream inputStream=new FileInputStream(file);
						Scanner sc=new Scanner(inputStream);
						while (sc.hasNext()) {
							sc.nextLine();
							++i;
						}
						sc.close();
						inputStream.close();
				   }
				   map2.put("authority", i);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		pages.setRows(rows);
		return   pages;
	}
	@Override
	public Map<String, Object> getPersonnel(String clerk_id,String com_id) {
		return employeeDao.getPersonnel(clerk_id,com_id);
	}
//	@Overridec
//	public	String getProclsNameById(Map<String, Object> maptype){
//		return employeeDao.getProclsNameById(maptype);
//	}

	@Override
	public PageList<Map<String, Object>> getOAList(Map<String, Object> map) {
		if(map.get("page").toString().contains("HTMLInputElement")){
			return null;
		}
		Integer page=Integer.parseInt(map.get("page").toString());
		Integer pageRecord=Integer.parseInt(map.get("rows").toString());
		if(isMapKeyNull(map, "ziji")){
			Integer count=employeeDao.getOACount(map);
			PageList<Map<String, Object>> pages=new PageList<Map<String,Object>>(page,pageRecord, count);
			pages.setRows(employeeDao.getOAList(map));
			return pages;
		}else{
			Integer count=employeeDao.getMySqOACount(map);
			PageList<Map<String, Object>> pages=new PageList<Map<String,Object>>(page,pageRecord, count);
			pages.setRows(employeeDao.getMySqOAList(map));
			return pages;
		}
	}

	@Override
	public Map<String, Object> getOAInfo(Map<String, Object> map, String realurl) {
		Map<String,Object> mapinfo=new HashMap<String, Object>();
		if(map.get("seeds_id")!=null&&map.get("seeds_id").toString().startsWith("SP")){
			map.put("ivt_oper_listing", map.get("seeds_id"));
			map.remove("seeds_id");
		}
		Map<String,Object> mapxxi= employeeDao.getOAInfo(map);
		mapxxi.put("isfile", isFileNo(realurl,mapxxi.get("approvaler"),mapxxi.get("ivt_oper_listing"), mapxxi));
		mapinfo.put("ivt_oper_listing", mapxxi.get("ivt_oper_listing"));
		mapinfo.put("OA_what", mapxxi.get("OA_what"));
		mapinfo.put("content", mapxxi.get("content"));
		mapinfo.put("info",mapxxi);
		if (map.get("type")==null) {
			map.put("ivt_oper_listing", mapxxi.get("ivt_oper_listing"));
			List<Map<String,Object>> list=employeeDao.getOAhistryList(map);
			for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
				Map<String, Object> map2 = iterator.next();
				map2.put("isfile", isFileNo(realurl, map2.get("OA_whom"),map2.get("ivt_oper_listing"), map2));
			}
			mapinfo.put("list", list);
		}
		mapinfo.put("customer_id", mapxxi.get("customer_id"));
		mapinfo.put("item_name", mapxxi.get("item_name"));
		mapinfo.put("ivt_oper_listing", mapxxi.get("ivt_oper_listing"));
		return mapinfo;
	}

	private boolean isFileNo(String realurl, Object OA_who,Object ivt_oper_listing,
			Map<String, Object> map2) {
		boolean b=false;
		if (map2!=null) {
			StringBuffer buffer=new StringBuffer(realurl).append("sp/");
			buffer.append(OA_who).append("/").append(ivt_oper_listing).append("/");
			buffer.append("/");//审批人的id
			
			File file=new File(buffer.toString());
			File[] files=file.listFiles();
			if (files!=null&&files.length>0) {
				for (File file2 : files) {
					if (file2.exists()&&file2.isFile()) {//代表有文件,可以显示附件
						map2.put("url","../"+getComId()+ file2.getPath().split("\\\\"+getComId())[1].replaceAll("\\\\", "/"));
						b=true;
						break;
					}
				}
			}
		}
		return b;
	}
	
	@Override
	public void saveOpinion(Map<String, String> map) throws Exception {
		Map<String,Object> mapinfo=employeeDao.getOASpInfo(map);
		//查看当前步骤是否最后一步
		Integer maxStep=employeeDao.getMaxStep(map);
		Integer nowStep=Integer.parseInt(mapinfo.get("approval_step").toString());
		map.put("approval_step", mapinfo.get("approval_step")+"");
		Map<String,Object> mapupdate=getApprovalInfo(map);
		mapupdate.put("approval_YesOrNo", map.get("spyij"));
		mapupdate.put("mainten_clerk_id", getEmployeeId(getRequest()));
		Map<String,Object> mapnext=getApprovalInfoNext(map, mapinfo);
		if (nowStep<maxStep) {//当前步骤小于最大步骤可以增加一条
			if ("同意".equals(map.get("spyij"))) {//等于同意就向下流转
				///查询下一步审批的人
				int approval_step=Integer.parseInt(mapinfo.get("approval_step").toString())+1;
				map.put("approval_step", approval_step+"");
				map.put("item_id", mapinfo.get("item_id").toString());
				String OA_whom=employeeDao.getNextOA_whom(map);
				Object clerk_idAccountApprover=OA_whom;
				//业务类才比较是否是客户审批员,
				if ("1".equals(mapinfo.get("type_id"))) {
					Map<String,Object> cus= employeeDao.getPersonnel(OA_whom, getComId());
					if (cus!=null&&"客户审批员".equals(cus.get("clerk_name"))) {
						Map<String,Object> mapcus=customerDao.getCustomerByCustomer_id(mapinfo.get("OA_who")+"", getComId());
						clerk_idAccountApprover=mapcus.get("clerk_idAccountApprover");
					}
				}
				mapnext.put("OA_whom",clerk_idAccountApprover);
				mapnext.put("approval_step",approval_step);
				employeeDao.insertSql(getInsertSql("OA_ctl03001_approval", mapnext));
				sendOAMessageNews(OA_whom,mapinfo.get("OA_what"), mapinfo.get("content"));
			}else{
				spNotTG(mapinfo);
			}
		}else{//最后一步
			/////////////////////欠条审批//////
			if ("同意".equals(map.get("spyij"))){
				if("客户欠条审批".equals(mapinfo.get("item_name"))||
					"预存款".equals(mapinfo.get("item_name"))) {//等于同意就更新收款单数据的审核状态
				if (mapinfo.get("content")!=null) {
					String content=mapinfo.get("content").toString();
					Integer begin=content.indexOf("[");
					Integer end=content.indexOf("]");
					StringBuffer buffer=new StringBuffer();
					if(content.contains("订单号:")){
						String sSql="update sdd02021 set Status_OutStore='"+map.get("processName")+"' where ltrim(rtrim(isnull(com_id,'')))='"+map.get("com_id")+"' and ivt_oper_listing='"+content.split("订单号:")[1]+"'";
						employeeDao.insertSql(sSql);
						buffer.append("订单号:").append(content.split("订单号:")[1]);
					}
					if (begin!=null&&end!=null&&end>5) {
						content=content.substring(begin+1, end);
								String[] ivt_oper_listings=content.split(",");
								String seeds_id="";
								for (String ivt : ivt_oper_listings) {
									String sSql="update sdd02021 set Status_OutStore='"+map.get("processName")+"' where seeds_id="+ivt.split("_")[1]+"";
									employeeDao.insertSql(sSql);
									if (!buffer.toString().contains(ivt.split("_")[0])) {
										buffer.append(ivt.split("_")[0]).append(",");
									}
									if(StringUtils.isBlank(seeds_id)){
										seeds_id=ivt.split("_")[1];
									}else{
										seeds_id=seeds_id+","+ivt.split("_")[1];
									}
								}
								/////////////保存客户信息到产品的运营商下面/////////
								Map<String,Object> mapparam=new HashMap<String, Object>();
								mapparam.put("seeds_id", seeds_id);
								mapparam.put("com_id", getComId());
								List<Map<String,Object>> mapseeds= customerDao.getJeByseedsIdGcomId(mapparam);
								if (mapseeds.size()>1) {
									Map<String,Object> mapcusnow= getNowCustomreInfo();
									for (Map<String, Object> map2 : mapseeds) {
										saveCustomerToCom(mapcusnow, map2.get("com_id"));
									}
								}
								///////////////////////////////////////
//							String headship=getProcessName("processName", getRequest())[0];
//							String imgName=getProcessName("imgName", getRequest())[0];
//							sendMessageNewsNeiQing(map.get("processName"), buffer.toString(),headship,imgName);
							savePay(mapinfo.get("OA_who"),mapinfo.get("OA_je"), content);
							List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
							Map<String,Object> mapMsg=new HashMap<String, Object>();
							mapMsg.put("title","欠条审批通过通知");
							mapMsg.put("description","您的欠条已经通过审批,欠条金额:"+mapinfo.get("OA_je"));
							mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/accountStatement.do");
							mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
							mapMsg.put("sendRen", getEmployeeId(getRequest()));
							news.add(mapMsg);
							zuheclientsendmsg("出纳", news, mapinfo.get("OA_who")+"", null);
					}
				}
				}else if("插单计划审批".equals(mapinfo.get("item_name"))){///插单计划审批
					String OA_what=mapinfo.get("OA_what").toString();
					if (StringUtils.isNotBlank(OA_what)) {
						if (OA_what.split(":").length>1) {
							String planNo=OA_what.split(":")[1];
							String sSql="update sdp02020 set comfirm_flag='Y' where ivt_oper_listing='"+planNo+"'";
							employeeDao.insertSql(sSql);
							String headship="内勤";
							if (map.get("processName").contains("款")) {
								headship="出纳";
							}
							sendMessageNewsNeiQingHead("","一笔插单已审批计划", planNo,headship,null,null);
						}
					}
				}else{
					Map<String,String> maptouser= employeeDao.getPersonnelWeixinID(mapinfo.get("OA_who")+"", getComId());
					List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
					Map<String,Object> mapMsg=new HashMap<String, Object>();
					mapMsg.put("title","【"+ mapinfo.get("OA_what")+"】协同审批结束");
					mapMsg.put("description",maptouser.get("clerk_name")+"：您的协同申请已审批完成，申请内容："+mapinfo.get("content"));
					mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/myOA.do");
					mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
					mapMsg.put("sendRen", getEmployeeId(getRequest()));
					news.add(mapMsg);
					sendMessageNews(news,getComId(), maptouser.get("weixinID"),"员工");
					///抄送
					List<Map<String,Object>> list= managerDao.getChaosong(mapinfo);
					if(list!=null&&list.size()>0){
						for (Map<String, Object> map2 : list) {
							news=new ArrayList<Map<String,Object>>();
							mapMsg=new HashMap<String, Object>();
							mapMsg.put("title","【抄送】【"+ mapinfo.get("OA_what")+"】协同审批结束");
							mapMsg.put("description",maptouser.get("clerk_name")+"的协同申请已审批完成，申请内容："+mapinfo.get("content"));
							mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/employee/edspalready.do?ivt_oper_listing="+mapinfo.get("ivt_oper_listing"));
							mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
							mapMsg.put("sendRen", getEmployeeId(getRequest()));
							news.add(mapMsg);
							sendMessageNews(news,getComId(), map2.get("weixinID")+"","员工");
						}
					}
				}
				if("预存款".equals(mapinfo.get("item_name"))){///预存款审批
					///更新订单状态  预存款审批  为 未核货
					String  OA_what=mapinfo.get("OA_what").toString();
					Integer begin=OA_what.indexOf("[");
					Integer end=OA_what.indexOf("]");
					if (begin!=null&&end!=null&&end>5) {
						OA_what=OA_what.substring(begin+1, end);
						if (StringUtils.isNotBlank(OA_what)) {
							String[] recieved_id=OA_what.split(",");
							StringBuffer buffer=new StringBuffer();
							for (String ivt : recieved_id) {
								String sSql="update ARd02051 set Status_preIN='是' where recieved_id='"+ivt+"'";
								employeeDao.insertSql(sSql);
								if (buffer.indexOf(ivt)<0) {
									buffer.append(ivt).append(",");
								}
							}
							Map<String,Object> mapcustomer=new HashMap<String, Object>();
							mapcustomer.put("com_id", getComId());
							mapcustomer.put("customer_id", mapinfo.get("OA_who"));
							String name=employeeDao.getCustomer_name(mapcustomer);
							String params=utf8to16(name);
							sendMessageOAARD02051("",buffer.toString(),params,getComId());
						}
					}
					///更新收款表的 comfirm_flag='Y' 
				}
			}else{
				///审批不通过
				spNotTG(mapinfo);
			}
			
		}
		mapupdate.put("maintenance_datetime", getNow());
		mapupdate.put("approval_time", getNow());
		employeeDao.updateApproval(mapupdate);
	}
	/**
	 * 协同审批不通过发送微信消息
	 * @param mapinfo
	 */
	private void spNotTG(Map<String,Object> mapinfo) {
		Map<String,String> maptouser= employeeDao.getPersonnelWeixinID(mapinfo.get("OA_who")+"", getComId());
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title","【"+ mapinfo.get("OA_what")+"】协同审批未通过");
		mapMsg.put("description",maptouser.get("clerk_name")+"：您的协同申请审批不通过，申请内容："+mapinfo.get("content"));
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/myOA.do");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		sendMessageNews(news, maptouser.get("weixinID"));
	}
 private void savePay(Object customer_id,  Object account, String content) throws Exception {
	 Map<String,Object> map=new HashMap<String, Object>();
	 String orderNo=getOrderNo(customerDao,"销售收款", getComId(getRequest()));
	 Calendar c = Calendar.getInstance();
//	 String corp_name=content.split(",")[0];
	 map.put("finacial_y", c.get(Calendar.YEAR));
	 map.put("finacial_m", c.get(Calendar.MONTH));
	 map.put("finacial_d", getNow());
	 map.put("recieved_direct", "收款");
	 map.put("recieved_auto_id",orderNo);
	 map.put("recieved_id", orderNo);
	 map.put("customer_id",customer_id);
	 map.put("recieve_type","打欠条");
	 map.put("com_id",getComId());
	 map.put("rcv_hw_no", "打欠条");
	 
	 StringBuffer buffer=new StringBuffer("打欠条,欠条金额:").append(account);
//	 buffer.append(getNow().split(" ")[0]).append("收款单号");
//	 buffer.append("[").append(orderNo).append("]").append(",打欠条,欠条金额:").append(account);
	 map.put("customerName", buffer.toString());
//	 map.put("c_memo", buffer.toString());
//	 buffer.append(",订单编号:").append(content);
	 map.put("sum_si", 0);
	 map.put("comfirm_flag", "N");
	 map.put("mainten_clerk_id", getEmployeeId(getRequest()));
	 map.put("mainten_datetime", getNow());
	 customerServer.savePaymoney(map, null);
//	 sendMessageOAARD02051("运营商:"+getComName(),buffer.toString(),orderNo,null);
}
	@Override
	public Integer getOACount(Map<String, Object> map) {
		return employeeDao.getOACount(map);
	}

	@Override
	public void saveCoordination(Map<String, Object> map) throws Exception{
		Map<String,Object> process=getProcessInfoByName(map.get("item_name").toString(),"asc",productDao);
		map.put("item_id", process.get("item_id"));
		map.put("OA_whom", process.get("clerk_id")); 
		map.remove("item_name");
		map.put("approval_step", 1);
		employeeDao.insertSql(getInsertSql("OA_ctl03001_approval", map));
		try {
			sendOAMessageNews(process.get("clerk_id"), map.get("OA_what"),map.get("content"));
		} catch (Exception e) {
			throw new RuntimeException("没有找到该类型的相关审批流程,请联系管理员创建该类型的审批流程!");
		}
	}

	@Override
	public List<Map<String, String>> getCustomer_id_name(Map<String, Object> map) {
		return employeeDao.getCustomer_id_name(map);
	}
	
	@Override
	public PageList<Map<String, Object>> getCustomerByClerk_id(Map<String,Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getEmployeeCustomerCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=employeeDao.getEmployeeCustomerList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public void updatePlanFlag(Map<String, Object> map) {
		String accountTurn_Flag=null;
		if ("Y".equals(map.get("accountTurn_Flag"))) {
			  accountTurn_Flag="已结转";
		}else{
			  accountTurn_Flag="未结转";
			
		}
		 String sSql="update SDP02021 set accountTurn_Flag='"+accountTurn_Flag+"',accountTurn_Time='"+
		getNow()+"' where seeds_id="+map.get("seeds_id");
		employeeDao.insertSql(sSql);
	}

	@Override
	public void saveLeave(Map<String, Object> map) {
		employeeDao.employeeLeave(map);
	}
	/**
	 * 新版订单跟踪自定义流程
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void saveOrderHandle(Map<String,Object> map) throws Exception{
		//TODO 新版订单跟踪处理
		String proceessStr=getFileTextContent(getSalesOrderProcessNamePath(getRequest()));
		if (StringUtils.isNotBlank(proceessStr)&&proceessStr.startsWith("[")) {
			JSONArray proceess=JSONArray.fromObject(proceessStr);
			Integer index=null;
			JSONObject item_json=null;//下一个流程
			String processName=map.get("name").toString();
			String nextProcessName=null;
			for (int i = 0; i < proceess.size(); i++) {
				JSONObject json=proceess.getJSONObject(i);
				boolean b=json.getString("processName").equals(map.get("name"));
				if(b){
					index=proceess.indexOf(json);
					if(index==(proceess.size()-1)){
						throw new RuntimeException("已经到流程最后一步了!");//页面增加单独收货按钮
					}
					processName=json.getString("processName");
					item_json=proceess.getJSONObject(i+1);
					if (item_json!=null) {
						nextProcessName=proceess.getJSONObject(i+1).getString("processName");
					}
					break;
				}
			}
			if(StringUtils.isBlank(nextProcessName)){
				throw new RuntimeException("已经到最后一步!");
			}
			boolean sms=getNoticeStyle(map, "1");
			boolean weixin=getNoticeStyle(map, "0");
			String weixinType=systemParamsDao.checkSystem("weixinType", getComId());//企业号或者服务号
			if(StringUtils.isBlank(weixinType)){
				weixinType="qiye";
			}
			String seedsStr=map.get("seeds").toString();
			if (seedsStr.startsWith("[")) {
				seedsStr=seedsStr.replace("[", "");
			}
			if (seedsStr.startsWith("]")) {
				seedsStr=seedsStr.replace("]", "");
			}
			String[] seeds=seedsStr.split(",");
			//处理订单跟踪操作
			Set<String> customers=new HashSet<String>();
			Set<String> orders=new HashSet<String>();
			String ivt_oper_listing=null;
			String dizhi=null;
			for (String seeds_id : seeds) {
				Map<String,Object> mapOrder =employeeDao.getOrderInfoBySeeds_id(seeds_id);//mapOrder.get("corp_sim_name")+"|"+
				String cus=mapOrder.get("customer_id")+"|"+mapOrder.get("ivt_oper_listing")+"|"+mapOrder.get("corp_sim_name");
				customers.add(cus);
				orders.add(mapOrder.get("ivt_oper_listing")+"");
				ivt_oper_listing=mapOrder.get("ivt_oper_listing")+"";
				dizhi=mapOrder.get("FHDZ")+"";
				//更新订单流程为新的流程
				Map<String,Object> params=new HashMap<>();
				params.put("seeds_id", seeds_id);
				params.put("Status_OutStore", nextProcessName);
				///////////更新数据表////////
				StringBuffer wuliuinfo=new StringBuffer();
				if (isNotMapKeyNull(map, "c_memo")) {
					params.put("c_memo", getMapKey(map, "c_memo"));
				}
				if (isNotMapKeyNull(map, "wuliu")) {
					params.put("transport_AgentClerk_Reciever", map.get("wuliu"));
				}
				if (isNotMapKeyNull(map, "store_struct_id")) {
					params.put("store_struct_id", map.get("store_struct_id"));//仓库
				}
				if (isNotMapKeyNull(map, "driver")) {
					params.put("HYS", getMapKey(map, "driver"));
					wuliuinfo.append("拉货司机:").append(getMapKey(map, "driver"));
				}
				if (isNotMapKeyNull(map, "Kar_paizhao")) {
					params.put("Kar_paizhao", getMapKey(map, "Kar_paizhao"));
					wuliuinfo.append(",车牌号:").append(getMapKey(map, "Kar_paizhao")).append(",");
				}
				if (isNotMapKeyNull(map, "tidate")) {
					params.put("discount_time_begin", getMapKey(map, "tidate"));
					wuliuinfo.append(",提货时间:").append(getMapKey(map, "tidate"));
				}
				employeeDao.updateOrderStatus(params);
				downWare(item_json, mapOrder);
				if("已发货".equals(nextProcessName)&&!"已结束".equals(nextProcessName)){
					saveOrderHistory(seeds_id,"订单状态:"+processName+",操作者:"+getEmployee(getRequest()).get("clerk_name"));
				}else{
					String driver="";
					if (isNotMapKeyNull(map, "driver")) {
						driver=",拉货司机:"+getMapKey(map, "driver");
					}
					if("1-4".equals(map.get("wuliu"))){//供应商
						wuliuinfo.append(",送货信息:").append(mapOrder.get("FHDZ"));
						params.put("wuliudx", "供应商配送");
					}else if("1-1".equals(map.get("wuliu"))){
						params.put("wuliudx", "公司自提");
					}
					params.put("wuliuinfo", wuliuinfo.toString());
					params.put("st_hw_no", mapOrder.get("st_hw_no"));
					params.put("com_id", mapOrder.get("com_id"));
					params.put("item_id", mapOrder.get("item_id"));
					params.put("ivt_oper_listing", mapOrder.get("ivt_oper_listing"));
					employeeDao.updatePurOrderInfo(params);
					saveOrderHistory(seeds_id,"订单状态:"+processName+"已结束,即将"+nextProcessName+",操作者:"
					+getEmployee(getRequest()).get("clerk_name")+driver);
				}
			}
			if("1-4".equals(map.get("wuliu"))){//供应商
				
			}
			if (item_json.has("send")&&item_json.getBoolean("send")) {//向客户发送消息
				if("客户".equals(item_json.getString("role"))){
					for (String item : customers) {
							sendClientMessage(weixin, sms, weixinType, item_json,nextProcessName,item,seedsStr,getMapKey(map, "driver"));
					}
				}else if("供应商".equals(item_json.getString("role"))){
					sendGysMessage(weixin,sms,weixinType,item_json,nextProcessName,seedsStr);
				}else if("司机".equals(item_json.getString("role"))){
					if(isNotMapKeyNull(map, "driver")){
						Map<String, Object> mapdriver=null;
						Map<String,Object> params=new HashMap<>();
						String[] touser= map.get("driver").toString().split("-");
						if(touser.length>1){
							Map<String,Object> mapparams=new HashMap<String, Object>();
							mapparams.put("table", "Sdf00504_saiyu");
							mapparams.put("idName", "user_id");
							mapparams.put("idVal", touser[1]);
							mapparams.put("com_id", getComId());
							mapdriver=managerDao.getDataInfo(mapparams);
							boolean gx=false;//更新司机对应的车牌号和
							if(!map.get("Kar_paizhao").toString().equals(mapdriver.get("corp_working_lisence"))){//车牌号与数据库不一致,就更新
								mapdriver.put("corp_working_lisence",map.get("Kar_paiuzhao"));
								gx=true;
							}
							if(!map.get("idcard").toString().equals(mapdriver.get("idcard"))){//身份证与数据库不一致,就更新
								mapdriver.put("idcard",map.get("idcard"));
								gx=true;
							}
							if(gx){
								managerDao.updateDriveInfo(mapdriver);
							}
							if (!isMapKeyNull(mapdriver, "corp_sim_name")) {
								params.put("HYS", mapdriver.get("corp_sim_name")+","+mapdriver.get("user_id"));
							}
							if (!isMapKeyNull(mapdriver, "Kar_paizhao")) {
								params.put("Kar_paizhao", getMapKey(mapdriver, "Kar_paizhao"));
							}
							params.put("seeds_id", seedsStr);
							params.put("Status_OutStore", nextProcessName);
							employeeDao.updateOrderStatus(params);
						}
						////////////////////////////////////////
//							String ids=Arrays.toString(seeds);
						mapdriver.put("CimgName", item_json.getString("CimgName"));
						String url=null;
						if( item_json.getString("url").contains("?")){
							url=item_json.get("url")+"|processName="+utf8to16(nextProcessName)+"|seeds_id="+seedsStr;
						}else{
							url=item_json.get("url")+"?processName="+utf8to16(nextProcessName)+"|seeds_id="+seedsStr;
						}
						mapdriver.put("url",url);
						mapdriver.put("title", item_json.getString("title"));
						mapdriver.put("description", item_json.getString("content")
								.replaceAll("@driver", map.get("driver")+"").replaceAll("@comName", getComName()));
						mapdriver.put("driver", map.get("driver").toString().split("-")[0]);
						mapdriver.put("wuliu", map.get("wuliu"));
						mapdriver.put("orderNo", ivt_oper_listing);
						if (StringUtils.isNotBlank(dizhi)) {
							if(dizhi.split(";").length>=3){
								mapdriver.put("dizhi", dizhi.split(";")[2]);
							}else{
								mapdriver.put("dizhi", dizhi);
							}
						}
						mapdriver.put("time", getMapKey(map, "tidate"));
						noticeDrive(mapdriver, weixin, sms, seedsStr);
					}
				}
			}
			//向客户或者员工发送消息
			item_json.put("customer_names", map.get("customer_names"));
			if (item_json.has("Esend")&&item_json.getBoolean("Esend")) {
				String orderNos=null;
				for (String orderNo : orders) {
					if(orderNos==null){
						orderNos=orderNo;
					}else{
						orderNos=orderNos+","+orderNo;
					}
				}
				item_json.put("orderNos", orderNos);
				sendEmployeeMessage(weixin, sms, item_json,nextProcessName,map.get("seeds"));
			}
			if (item_json.has("salesperson")&&item_json.getBoolean("salesperson")) {
				for (String item : customers) {
					//向业务员发送通知消息
					Map<String, Object> mapOrder=new HashMap<>();
					mapOrder.put("customer_id",item.split("\\|")[0]);
					mapOrder.put("com_id",getComId());
					//根据客户编码获取业务员
					Map<String,String> map_salesperson=employeeDao.getSalespersonInfo(mapOrder);
					map_salesperson.put("item", item);
					map_salesperson.put("seeds", map.get("seeds").toString());
					sendSalespersonMessage(weixin, sms, item_json,nextProcessName, map_salesperson);
				}
			}
		}else{
			throw new RuntimeException("请先设置订单流程");
		}
	}
	/**
	 * 订单跟踪过程下库存
	 * @param item_json
	 * @param mapOrder
	 */
	private void downWare(JSONObject item_json, Map<String, Object> mapOrder) {
		if (item_json.has("down_ware")&&item_json.getBoolean("down_ware")) {
			//判断物流方式是否是供应商库房,是就跳过
			if(isMapKeyNull(mapOrder, "transport_AgentClerk_Reciever")){
				mapOrder.put("transport_AgentClerk_Reciever", mapOrder.get("wuliiu"));
			}
			if(isNotMapKeyNull(mapOrder, "transport_AgentClerk_Reciever")){
				if(MapUtils.getString(mapOrder, "transport_AgentClerk_Reciever").startsWith("0-")){//公司库房
					//减少库存
					JSONObject json=new JSONObject();
					json.put("sd_oq", mapOrder.get("sd_oq"));
					json.put("kcNum", mapOrder.get("use_oq"));
					json.put("store_struct_id", mapOrder.get("store_struct_id"));
					json.put("item_id", mapOrder.get("item_id"));
					updateKcReturn(json);
				}else{
					//向供应商发消息
				}
			}
		}
	}
	/**
	 * 更新库存
	 * @param json
	 * @param sd_oq 销售数量
	 * @param kcNum 库存数量
	 * @param store_struct_id 库房
	 * @param item_id 产品编码
	 */
	private void updateKcReturn(JSONObject json){
		BigDecimal sd_oq=new BigDecimal(json.getString("sd_oq"));
		BigDecimal kcnum=new BigDecimal(json.getString("kcNum"));
		Map<String, Object> thMap = new HashMap<String, Object>();
		Calendar c=Calendar.getInstance();
		thMap.put("accn_ivt", kcnum.subtract(sd_oq));
		thMap.put("use_oq", kcnum.subtract(sd_oq));
		thMap.put("finacial_datetime", getNow());
		thMap.put("maintenance_datetime", getNow());
		thMap.put("mainten_clerk_id", getEmployeeId(getRequest()));
		thMap.put("finacial_y", c.get(Calendar.YEAR));
		thMap.put("finacial_m", c.get(Calendar.MONTH));
		thMap.put("store_struct_id", json.get("store_struct_id"));
		thMap.put("item_id", json.get("item_id"));
		thMap.put("com_id",getComId());
		managerDao.updateKcReturn(thMap);
	}
	/**
	 * 向员工发送消息
	 * @param weixin
	 * @param sms
	 * @param json
	 * @param seeds 
	 */
	private void sendEmployeeMessage(boolean weixin, boolean sms,JSONObject json,String nextName, Object seeds) {
		List<Map<String, String>> touserList=null;
		//向员工发送消息
		Map<String,Object> params=new HashMap<>();
		String description=json.getString("Econtent").replace("@comName", getComName());
		description=description.replaceAll("@customerName", getJsonVal(json, "customer_names"));
		description=description.replaceAll("@orderNo", getJsonVal(json, "orderNos"));
		if(weixin){
			params.put("title", json.get("Etitle"));
			params.put("description", description);
			params.put("headship", json.get("Eheadship"));
			params.put("processName", nextName);
			params.put("imgName", json.get("imgName"));
			String url=null;
			if( json.getString("Eurl").contains("?")){
				url=json.get("Eurl")+"|processName="+utf8to16(nextName)+"|seeds_id="+seeds;
			}else{
				url=json.get("Eurl")+"?processName="+utf8to16(nextName)+"|seeds_id="+seeds;
			}
			if(url.contains("http")){
				params.put("url",url);
			}else{
				params.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
			}
			touserList=sendEmployeeWeixinMessage(params);
			///微信服务号消息
			sendEmployeeWeixinServiceMsg(touserList,json,url,nextName,getComName()+"-"+json.get("Eheadship")+":你有一笔订单需要进行流程操作:");
		}
		if(sms){
			if(touserList==null){
				params.put("headship", json.get("headship"));
				params.put("processName", nextName);
				touserList=employeeDao.getPersonnelNeiQing(getWeixinMsgParams(params,null));
			}
			Map<String,Object> mapsms=getSystemParamsByComId();
			for (Map<String, String> movtel : touserList) {
				String msg=description.replaceAll("@Eheadship", getJsonVal(json, "headship")).replaceAll("@clerkName", movtel.get("clerk_name"));
				if (StringUtils.isNotBlank(movtel.get("movtel"))) {
					SendSmsUtil.sendSms2(movtel.get("movtel"), null, msg,mapsms);
				}
			}
		}
	}
	/**
	 * 发送微信服务号消息
	 * @param touserList
	 * @param json
	 * @param url
	 * @param nextName 下一步流程
	 */
	private void sendEmployeeWeixinServiceMsg(List<Map<String, String>> touserList, JSONObject json,
			String url,Object nextName,Object first) {
		//json.getString("template_id");
		String template_id="p-Rtp5gigYthaxs7sD7j-JoqPlvmeGvkAwD_ek5DgRM";
		Map<String,Object> map=new HashMap<>();
		map.put("com_id", getComId());
		map.put("template_id", template_id);
		List<Map<String,Object>> tempList= managerDao.getWexinMsgTemplate(map);
		if (tempList!=null&&tempList.size()>0) {
			Map<String,Object> temp=tempList.get(0);
			JSONObject data=new JSONObject();
			data.put("first",getWeixinTempItem(first));
			String[] cons=temp.get("content").toString().split("\\.");
			data.put(cons[0],getWeixinTempItem(getJsonVal(json, "orderNos")));
			data.put(cons[1],getWeixinTempItem(nextName));
			data.put("remark",getWeixinTempItem("点击“详情”查看完整订单信息,消息发送时间:"+getNow()));
			sendWeixinServiceMsg(url, template_id, data, touserList);
		}
	}

	/**
	 * 向业务员发送消息
	 * @param weixin
	 * @param sms
	 * @param item_json
	 * @param map_salesperson 
	 */
	private void sendSalespersonMessage(boolean weixin, boolean sms,JSONObject item_json,String nextName,Map<String,String> map_salesperson) {
		//向员工发送消息
		Map<String,Object> params=new HashMap<>();
		String description=item_json.getString("Econtent").replace("@comName", getComName());
		description=description.replaceAll("@Eheadship", "业务员").replaceAll("@clerkName", map_salesperson.get("clerk_name"));
		description=description.replaceAll("@orderNo",map_salesperson.get("item").split("\\|")[1]);
		description=description.replaceAll("@customerName",map_salesperson.get("item").split("\\|")[2]);
		if(weixin){
			params.put("title", item_json.get("Etitle"));
			params.put("description", description);
			params.put("imgName", item_json.get("imgName"));
			String url=null;
			if( item_json.getString("Eurl").contains("?")){
				url=item_json.get("Eurl")+"|seeds_id="+map_salesperson.get("seeds");
			}else{
				url=item_json.get("Eurl")+"?seeds_id="+map_salesperson.get("seeds");
			}
			if(url.contains("http")){
				params.put("url",url);
			}else{
				params.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url="+ url);
			}
			if (StringUtils.isNotBlank(map_salesperson.get("weixinID"))) {
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				news.add(params);
				if (StringUtils.isNotBlank(map_salesperson.get("weixinID"))) {
					sendMessageNews(news,getComId(),map_salesperson.get("weixinID"),"员工");
				}
			}
			////发送微信服务号消息
			List<Map<String,String>> touserList=new ArrayList<>();
			touserList.add(map_salesperson);
			sendEmployeeWeixinServiceMsg(touserList, item_json, url, nextName,getComName()+"-业务员:你有一笔客户订单已有新进度:");
		}
		if(sms){
			Map<String,Object> mapsms=getSystemParamsByComId();
				if (StringUtils.isNotBlank(map_salesperson.get("movtel"))) {
					SendSmsUtil.sendSms2(map_salesperson.get("movtel"), null, description,mapsms);
				}
		}
	}
	/**
	 * 向供应商发送消息
	 * @param weixin 发送微信消weixinType@param sms 发送短信
	 * @param msgType qiye-企业号,服务号
	 * @param item_json 流程信息
	 * @param seeds 订单seeds_id
	 */
	private void sendGysMessage(boolean weixin, boolean sms,String msgType, JSONObject item_json,String nextName,Object seeds) {
		List<Map<String, String>> touserList=null;
		Map<String,Object> params=new HashMap<>();
		if(weixin){
			if("qiye".equals(msgType)){//企业号消息
				params.put("title", item_json.get("title"));
				String description=item_json.getString("content").replace("@comName", getComName());
				params.put("description",description);
				params.put("headship", item_json.get("headship"));
				params.put("processName", nextName);
				params.put("imgName", item_json.get("CimgName"));
				String url=null;
				if( item_json.getString("url").contains("?")){
					url=item_json.get("url")+"|seeds_id="+seeds;
				}else{
					url=item_json.get("url")+"?seeds_id="+seeds;
				}
				if(url.contains("http")){
					params.put("url",url);
				}else{
					params.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
				}
				//TODO 新版订单跟踪处理-供应商发消息
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				news.add(params);
				touserList=employeeDao.getGysByOrderSeeds(seeds);
				for (int i = 0; i < touserList.size(); i++) {
					Map<String,String> item=touserList.get(i);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						String msg=description.replaceAll("@headship", getJsonVal(item_json, "headship")).replaceAll("@customerName", item.get("corp_sim_name"));
						msg=description.replaceAll("@orderNo", item.get("orderNo")+"");
						news.get(0).put("description",msg);
						if (StringUtils.isNotBlank(item.get("weixinID"))) {
							sendMessageNews(news,getComId(),item.get("weixinID"),"供应商");
						}
						news.get(0).put("description",description);
					}
				}
			}
		}
		if(sms){
			if(touserList==null){
				touserList=employeeDao.getGysByOrderSeeds(seeds);
			}
			String description=item_json.get("title")+","+item_json.getString("content").replace("@comName", getComName());
			Map<String,Object> mapsms=getSystemParamsByComId();
			for (Map<String, String> movtel : touserList) {
				String msg=description.replaceAll("@headship", getJsonVal(item_json, "headship")).replaceAll("@customerName", movtel.get("corp_sim_name"));
				if (StringUtils.isNotBlank(movtel.get("movtel"))) {
					SendSmsUtil.sendSms2(movtel.get("movtel"), null, msg,mapsms);
				}
			}
		}
	}
	/**
	 * 发送客户消息
	 * @param weixin true-发微信消息
	 * @param sms true-发短信
	 * @param msgType -企业号或者服务号
	 * @param json -流程信息
	 * @param driver 
	 * @param object 
	 * @param customer_id -客户信息
	 */
	private void sendClientMessage(boolean weixin, boolean sms, Object msgType, JSONObject json,String nextName, String item, Object seeds, String driver) {
		List<Map<String, String>> touserList=null;
		Map<String,Object> params=new HashMap<>();
		String customer_id=item.split("\\|")[0];
		String orderNo=item.split("\\|")[1];
		if(weixin){
			String url=null;
			if( json.getString("url").contains("?")){
				url=json.get("url")+"|processName="+utf8to16(nextName)+"|seeds_id="+seeds;
			}else{
				url=json.get("url")+"?processName="+utf8to16(nextName)+"|seeds_id="+seeds;
			}
			if("qiye".equals(msgType)){//企业号消息
				params.put("title", json.get("title"));
				String description=json.getString("content").replace("@comName", getComName()).replaceAll("@driver",driver);
				description=description.replaceAll("@orderNo",orderNo);
				params.put("description",description);
				params.put("headship", json.get("headship"));
				params.put("processName", nextName);
				params.put("imgName", json.get("CimgName"));
				if(url.contains("http")){
					params.put("url",url);
				}else{
					params.put("url",ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
				}
				params.put("upper_customer_id", customer_id);
				params.put("orderNo", orderNo);
				//TODO 新版订单跟踪处理-客户
				touserList=sendClientWeixinMessage(params);
			}else{//服务号消息
			}
			//TODO 微信服务号模板消息
			//1.获取模板id
			String template_id="p-Rtp5gigYthaxs7sD7j-JoqPlvmeGvkAwD_ek5DgRM";
			//json.getString("template_id");
			Map<String,Object> map=new HashMap<>();
			map.put("com_id", getComId());
			map.put("template_id", template_id);
			List<Map<String,Object>> tempList= managerDao.getWexinMsgTemplate(map);
			if (tempList!=null&&tempList.size()>0) {
				Map<String,Object> temp=tempList.get(0);
				if(touserList==null||touserList.size()==0){
					params.put("headship", json.get("headship"));
					params.put("processName",nextName);
					params.put("upper_customer_id", customer_id);
					touserList=customerDao.getCustomerWeixinByHeadship(getWeixinMsgParams(params,null));
				}
				JSONObject data=new JSONObject();
				data.put("first",getWeixinTempItem("尊敬的客户您的的有新进度了:"));
				String[] cons=temp.get("content").toString().split("\\.");
				data.put(cons[0],getWeixinTempItem(orderNo));
				data.put(cons[1],getWeixinTempItem(nextName));
				if(StringUtils.isNotBlank(driver)){
					driver="送货司机信息:"+driver;
				}else{
					driver="";
				}
				data.put("remark",getWeixinTempItem(driver+"点击“详情”查看完整物流信息,消息发送时间:"+getNow()));
				sendWeixinServiceMsg(url, template_id, data, touserList);
			}
		}
		if(sms){
			if(touserList==null||touserList.size()==0){
				params.put("headship", json.get("headship"));
				params.put("processName",nextName);
				params.put("upper_customer_id", customer_id);
				touserList=customerDao.getCustomerWeixinByHeadship(getWeixinMsgParams(params,null));
			}
			String description=json.get("title")+","+json.getString("content").replace("@comName", getComName());
			Map<String,Object> mapsms=getSystemParamsByComId();
			for (Map<String, String> movtel : touserList) {
				String msg=description.replaceAll("@headship", getJsonVal(json, "headship")).replaceAll("@customerName", movtel.get("corp_sim_name"));
				if (StringUtils.isNotBlank(movtel.get("movtel"))) {
					SendSmsUtil.sendSms2(movtel.get("movtel"), null, msg,mapsms);
				}
			}
		}
	}
	@Override
	public String saveHandle(Map<String, Object> map)  throws Exception{
		String name=map.get("name").toString();
		String[] seeds=map.get("seeds").toString().split(",");
		Map<String,String[]> sopn=getProcessName();
		List<String> processNames=Arrays.asList(sopn.get("processName"));// getProcessNameList(getRequest());
		Integer index =processNames.indexOf(name);//按钮的索引值  从0开始
		String[] headships=sopn.get("headship");
		String[] Eheadships=sopn.get("Eheadship");
		String[] imgNames=sopn.get("imgName");//流程对应消息的图片
		String imgName="msg.png";
		if(imgNames.length>index){
			imgName=imgNames[index];
			if (StringUtils.isBlank(imgName)) {
				imgName="msg.png";
			}
		}
		Integer end=processNames.size()-1;
		boolean sms=getNoticeStyle(map, "1");
		boolean weixin=getNoticeStyle(map, "0");
		int len=0;
		if(headships.length>0){
			len=headships.length;
		}
		List<String> msglist=new ArrayList<String>();
		if (index==end) {///当按钮文章的索引值等于最后一项表示已到最后一步  通知收货
			String processName=processNames.get(index);//获取当前流程名称
			//1.更新订单状态为已结束
			for (String seeds_id : seeds) {///Status_OutStore='已发货',shipped='已发货',
				String sSql="update sdd02021 set Status_OutStore='已结束',at_term_datetime_Act='"+getNow()+"' where seeds_id="+seeds_id;
				employeeDao.insertSql(sSql);
				sSql="update sdd02020 set comfirm_flag='Y' where ivt_oper_listing in (select ivt_oper_listing from sdd02021 where seeds_id="+seeds_id+")";
				employeeDao.insertSql(sSql);
				Map<String,Object> mapOrder =employeeDao.getOrderInfoBySeeds_id(seeds_id);
				String cus=mapOrder.get("corp_sim_name")+"|"+mapOrder.get("customer_id")+"|"+mapOrder.get("ivt_oper_listing");
				if(msglist.indexOf(cus)<0){
					msglist.add(cus);
				}
				saveOrderHistory(seeds_id, "产品已结束,并通知客户,操作者:"+getEmployee(getRequest()).get("clerk_name"));
			}
			for (String item : msglist) {
				String[] paramst=item.split("\\|");
				StringBuffer msg=new StringBuffer(paramst[0]+"您有一笔订单信息为,单号:");
				msg.append(paramst[2]);
				msg.append(",产品已发货请注意收货!");
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", "订单商品已发货通知");
				mapMsg.put("description",msg);
				mapMsg.put("picurl",ConfigFile.urlPrefix+"/weixinimg/"+imgName);
				if(getCustomer(getRequest())!=null){
					mapMsg.put("sendRen", getCustomerId(getRequest()));
				}else if(getEmployee(getRequest())!=null){
					mapMsg.put("sendRen", getEmployeeId(getRequest()));
				}
				String params=paramst[2]+"|"+utf8to16("已结束");
				if("saiyu".equalsIgnoreCase(ConfigFile.emplName)){
					mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order|"+params);
				}else{
					mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do?"+params);
				}
				news.add(mapMsg);
				if(len>0){
					sendClientMsg(paramst[1], headships[len-1], weixin, sms, news, msg,processName);
				}else{
					sendClientMsg(paramst[1],"", weixin, sms, news, msg,processName);
				}
			}
			return "已结束";
		}else{
			String Status_OutStore=processNames.get(index+1);//获取下一步操作
			String processName=processNames.get(index);//获取当前流程名称
			String headshipClient="";
			if(len>0&&len>(index)){
				headshipClient=headships[index+1];
			}
			if (StringUtils.isBlank(headshipClient)) {
				headshipClient="";
			}
			Map<String,Object> mapdriver=null;
			if ((name.contains("拉货")||name.contains("司机"))&&isNotMapKeyNull(map, "driver")) {//通知司机的时候获取上级相关信息///以便于在更新订单信息的时候将司机相关信息更新到数据库中
				String[] touser= map.get("driver").toString().split("-");
				if(touser.length>1){
					Map<String,Object> mapparams=new HashMap<String, Object>();
					mapparams.put("table", "Sdf00504_saiyu");
					mapparams.put("idName", "user_id");
					mapparams.put("idVal", touser[1]);
					mapparams.put("com_id", getComId());
					mapdriver=managerDao.getDataInfo(mapparams);
					///corp_working_lisence  idcard  
					boolean gx=false;//更新司机对应的车牌号和
					if(!map.get("Kar_paizhao").toString().equals(mapdriver.get("corp_working_lisence"))){//车牌号与数据库不一致,就更新
						mapdriver.put("corp_working_lisence",map.get("Kar_paiuzhao"));
						gx=true;
					}
					if(!map.get("idcard").toString().equals(mapdriver.get("idcard"))){//身份证与数据库不一致,就更新
						mapdriver.put("idcard",map.get("idcard"));
						gx=true;
					}
					if(gx){
						managerDao.updateDriveInfo(mapdriver);
					}
				}
			}
			StringBuffer wuliufenjie=new StringBuffer();
			List<String> employeemsglist=new ArrayList<String>();
			//1.更新订单状态为 未核款
			for (String seeds_id : seeds) {
				String headship =Eheadships[index+1];
				Map<String,Object> mapOrder =employeeDao.getOrderInfoBySeeds_id(seeds_id);
				String statusOutStore=Status_OutStore;
				try {
					if(!(name.contains("拉货")||name.contains("司机"))&&!name.contains("物流")){
						String empl=statusOutStore+"|"+headship+"|客户【"+mapOrder.get("corp_sim_name")+"】,订单编号:"+mapOrder.get("ivt_oper_listing");
						if(employeemsglist.indexOf(empl)<0){
							employeemsglist.add(empl);
						}
					}else{
						wuliufenjie.append("订单编号:");
						wuliufenjie.append(mapOrder.get("ivt_oper_listing")).append(",产品名称:");
						wuliufenjie.append(mapOrder.get("item_sim_name")).append(",数量:").append(mapOrder.get("sd_oq"));
						wuliufenjie.append(",请尽快为客户[").append(mapOrder.get("corp_sim_name")).append("]");
						wuliufenjie.append("分解打包,").append("|");
					}
					if (!isMapKeyNull(mapdriver, "corp_sim_name")) {
						map.put("HYS", mapdriver.get("corp_sim_name")+","+mapdriver.get("user_id"));
					}
					if (!isMapKeyNull(map, "didian")) {
						map.put("c_memo", getMapKey(map,"didian")+","+getMapKey(map,"tidate")+"|"+getMapKey(map,"shr")+","+getMapKey(map,"shdz"));
					}
					if (!isMapKeyNull(map, "wuliu")) {
						map.put("transport_AgentClerk_Reciever", map.get("wuliu"));
					}
					if (!isMapKeyNull(mapdriver, "corp_working_lisence")) {
						map.put("Kar_paizhao", getMapKey(mapdriver, "corp_working_lisence"));
					}
					map.put("seeds_id", seeds_id);
					///////////更新数据表////////
					map.put("Status_OutStore", statusOutStore);
					employeeDao.updateOrderStatus(map);
					/////////
					String cus=mapOrder.get("corp_sim_name")+"|"+mapOrder.get("customer_id")+"|"+mapOrder.get("ivt_oper_listing");
					if(msglist.indexOf(cus)<0){
						msglist.add(cus);
					}
					saveOrderHistory(seeds_id, processNames.get(index)+",操作者:"+getEmployee(getRequest()).get("clerk_name"));
				} catch (Exception e) {
//					writeLog(getRequest(), "获取订单数据详细", e.getMessage());
					LoggerUtils.error(e.getMessage());
					e.printStackTrace();
					throw new RuntimeException(e.getMessage());
				}
			}
			//////////////////////////核款核货结束///////////////////
			if((name.contains("拉货")||name.contains("司机"))&&isNotMapKeyNull(map, "driver")){//通知司机
				if(mapdriver!=null){
					mapdriver.put("didian", map.get("didian"));
					mapdriver.put("tidate", map.get("tidate"));
					mapdriver.put("shr", map.get("shr"));
					mapdriver.put("shdz", map.get("shdz"));
					mapdriver.put("shphone", map.get("shphone"));
					mapdriver.put("wuliu", map.get("wuliu"));
					noticeDrive(mapdriver, weixin, sms, seeds,imgName);
					String shdz=getFileTextContent(getTHDDTxtPath(getRequest()));
					if(StringUtils.isBlank(shdz)){
						shdz=map.get("didian")+"|";
					}else{
						if (!shdz.contains(map.get("didian")+"")) {
							shdz=shdz+map.get("didian")+"|";
						}
					}
				}
			}else if (name.contains("物流")) {//通知物流
				sendMessageNewsWuliu(wuliufenjie.toString(), weixin, sms,seeds,imgName);
			}else{
				/////通知客户  /////////////////
				if ("客户安排司机".equals(Status_OutStore)) {
					if(isMapKeyNull(map, "wuliu")){
						map.put("wuliu", "0-2");
					}
				}
				if(isNotMapKeyNull(map, "wuliu")){
					if("0-2".equals(map.get("wuliu"))){
						if(msglist!=null&&msglist.size()>0){
							for (String item : msglist) {
								String[] paramst=item.split("\\|"); 
								StringBuffer msg=new StringBuffer(paramst[0]+"您的订单单号:").append(paramst[2]);
								msg.append(",订单状态为:").	append(Status_OutStore);
								String title="请完善并确认车牌号及司机，前往提货!";
								String description="已在此之前，线下与您沟通好物流方式、提货地点，请确认车牌号、司机、预计提货时间并通知司机前往提货。";
								noticeClient(paramst[1],title,description,paramst[2], sms,weixin,Status_OutStore,headshipClient,imgName);
							}
							return Status_OutStore;
						}
					}
				}
				//////////////员工/////////
				if(employeemsglist!=null&&employeemsglist.size()>0){
					for (String item : employeemsglist) {
						String[] items=item.split("\\|");
						if (StringUtils.isBlank(items[1])) {
							items[1]=null;
						}
						if (weixin) {
							sendMessageNewsNeiQing(items[0],items[2],items[1],imgName);
						}
						if (sms) {
							Map<String,Object> mapper=new HashMap<String, Object>();
							mapper.put("com_id", getComId());
							mapper.put("movtel","movtel");
							mapper.put("headship", "%"+items[1]+"%");
							mapper.put("processName", "%"+processName+"%");
							mapper.put("omrtype",getSystemParam("ordersMessageReceivedType"));
							List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapper);
							Map<String,Object> mapsms=getSystemParamsByComId();
							for (Map<String, String> movtel : touserList) {
								if (StringUtils.isNotBlank(movtel.get("movtel"))) {
									SendSmsUtil.sendSms2(movtel.get("movtel"), null, 
											"员工"+movtel.get("clerk_name")+":"+items[2]+"，为客户"+ items[0],mapsms);
								}
							}
						}
					}
				}
			}
			return Status_OutStore;
		}
	}

	private void noticeDrive(Map<String,Object> map, boolean weixin, boolean sms, String[] seeds, String imgName) {
		StringBuffer msg=new StringBuffer("司机:");
		String title="送货通知";
//		String title="司机:"+map.get("corp_sim_name")+"你有一条来自【"+getComName()+"】的送货通知";
		if (weixin) {
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", title);
			msg.append(map.get("corp_sim_name")).append("你有一条来自【").append(getComName()).append("】的送货通知,");
			msg.append("提货地点:").append(map.get("didian")).append(",提货时间:").append(map.get("tidate"));
			mapMsg.put("description",msg);
			mapMsg.put("picurl",ConfigFile.urlPrefix +imgName);
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/waybill.do?seeds_id="+Arrays.toString(seeds));
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			if (!isMapKeyNull(map, "weixinID")) {
				sendMessageNews(news, map.get("weixinID").toString());
			}
			String ids=Arrays.toString(seeds);
			String qrUrl=null;
			if(map.get("wuliu").toString().startsWith("0-")){//公司仓库
				qrUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/driverWaybillDetail.do?seeds_id="+ids;
			}else{//供应商仓库
				qrUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/supplierDriverWaybillDetail.do?seeds_id="+ids;
			}
			//生成二维码
			QRCodeUtil.generateQRCode(qrUrl, getRealPath(getRequest())+"/001/qrcode/"+ids+".jpg",getRealPath(getRequest())+"pc/image/logo.png");
		}
		if (sms&&!isMapKeyNull(map, "user_id")) {
			Map<String,Object> mapsms=getSystemParamsByComId();
			SendSmsUtil.sendSms2(getMapKey(map, "user_id"), null,title,mapsms);
		}
	}
	/**
	 * 
	 * @param map
	 * @param weixin
	 * @param sms
	 * @param seeds
	 * @param title
	 * @param description
	 * @param CimgName
	 * @param url
	 * @param weixinID
	 * @param user_id
	 * @param wuliu 物流类型
	 */
	private void noticeDrive(Map<String,Object> map, boolean weixin, boolean sms, String ids) {
		if (weixin) {
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", map.get("title"));
			mapMsg.put("description",map.get("description"));
			Object CimgName=map.get("CimgName");
			if(CimgName==null){
				CimgName="weixinimg/msg.png";
			}
			mapMsg.put("picurl",ConfigFile.urlPrefix+CimgName);
			String url=ConfigFile.urlPrefix+"/login/toUrl.do?url="+map.get("url");
			mapMsg.put("url",url);
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			if (!isMapKeyNull(map, "weixinID")) {
				sendMessageNews(news, map.get("weixinID").toString());
			}
			String qrUrl=null;
			if(map.get("wuliu").toString().startsWith("0-")){//公司仓库
				qrUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/driverWaybillDetail.do?seeds_id="+ids+"|com_id="+getComId();
			}else{//供应商仓库
				qrUrl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/supplierDriverWaybillDetail.do?seeds_id="+ids+"|com_id="+getComId();
			}
			//生成二维码
			QRCodeUtil.generateQRCode(qrUrl, getRealPath(getRequest())+"qrcode/"+ids+".jpg",getRealPath(getRequest())+"pc/image/logo.png");
			///发送微信服务号消息
			String template_id="7irp2ck85wXJIMG8c39pkO4Vzh1Fc-f9MVJ3t57W-lU";
			Map<String,Object> param=new HashMap<>();
			param.put("com_id", getComId());
			param.put("template_id", template_id);
			List<Map<String,Object>> tempList= managerDao.getWexinMsgTemplate(param);
			if (tempList!=null&&tempList.size()>0) {
				Map<String,Object> temp=tempList.get(0);
				WeiXinServiceUtil ws=new WeiXinServiceUtil();
				JSONObject data=new JSONObject();
				data.put("first",getWeixinTempItem(map.get("driver")+":你好,你有一笔来自【"+getComName()+"】的订单需要送货:"));
				String[] cons=temp.get("content").toString().split("\\.");
				data.put(cons[0],getWeixinTempItem(map.get("orderNo")+""));
				data.put(cons[1],getWeixinTempItem(map.get("dizhi")+""));//送货地址
				data.put(cons[2],getWeixinTempItem(map.get("time")+""));//送货时间
				data.put("remark",getWeixinTempItem("点击“详情”查看完整提货信息,消息发送时间:"+getNow()));
				String msg=ws.sendMessage(map.get("openid"), template_id, getComId(), url, data);
				LoggerUtils.info(msg);
			}
		}
		if (sms&&!isMapKeyNull(map, "user_id")) {
			Map<String,Object> mapsms=getSystemParamsByComId();
			SendSmsUtil.sendSms2(getMapKey(map, "user_id"), null,map.get("description")+"",mapsms);
		}
	}
	
//	/**
//	 * 通知客户当前进度
//	 * @param mapOrder
//	 * @param sms true-发送短信
//	 * @param weixin true-发送微信
//	 * @param statusOutStore 当前流程名称
//	 * @param msg 发送的消息
//	 * @return 返回客户相关信息
//	 */
//	private Map<String, Object> noticeClient(Map<String,Object> mapOrder,Map<String,Object> mapcus,boolean sms,boolean weixin, String statusOutStore,StringBuffer msg) {
//		msg=new StringBuffer(mapOrder.get("corp_sim_name")+"您的订单单号:").append(mapOrder.get("ivt_oper_listing"));
////		msg.append(",产品名称:").append(mapOrder.get("item_sim_name")).append(",金额:").append(mapOrder.get("sum_si"));
//		String processName=statusOutStore.substring(1, statusOutStore.length());
//		msg.append(",订单状态为:").
//		append(processName);
//		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
//		Map<String,Object> mapMsg=new HashMap<String, Object>();
//		mapMsg.put("title", "订单状态进度通知");
//		mapMsg.put("description",msg);
//		String params=mapOrder.get("ivt_oper_listing")+"|"+utf8to16(processName);
//		if("saiyu".equalsIgnoreCase(ConfigFile.emplName)){
//			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order|"+params);
//		}else{
//			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do?"+params);
//		}
//		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
//		if(getCustomer(getRequest())!=null){
//			mapMsg.put("sendRen", getCustomerId(getRequest()));
//		}else if(getEmployee(getRequest())!=null){
//			mapMsg.put("sendRen", getEmployeeId(getRequest()));
//		}
//		news.add(mapMsg);
//		//根据客户编码获取微信id
//		mapOrder.put("com_id", getComId());
//		if (weixin&&mapcus!=null&&mapcus.get("weixinID")!=null) {
//			sendMessageNews(news, mapcus.get("weixinID").toString());
//		}
//		if (sms&&mapcus!=null&&mapcus.get("user_id")!=null) {
//			if (!isMapKeyNull(mapcus, "user_id")) {
//				Map<String,Object> mapsms=getSystemParamsByComId();
//				SendSmsUtil.sendSms2(mapcus.get("user_id")+"", null, msg.toString(),mapsms);
//			}
//		}
//		return mapcus;
//	}
	/**
	 * 
	 * @param customer_id
	 * @param title
	 * @param description
	 * @param ivt_oper_listing
	 * @param sms
	 * @param weixin
	 * @param statusOutStore
	 * @param headshipClient
	 * @param imgName 
	 * @return
	 */
	private Map<String, Object> noticeClient(String customer_id,String title, String description,String ivt_oper_listing,
			boolean sms,boolean weixin, String statusOutStore,String headshipClient, String imgName) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",title);
		mapMsg.put("description",description);
		String params=ivt_oper_listing+"|"+utf8to16(statusOutStore);
		if("saiyu".equalsIgnoreCase(ConfigFile.emplName)){
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order|"+params);
		}else{
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do?"+params);
		}
		mapMsg.put("picurl", ConfigFile.urlPrefix+imgName);
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		StringBuffer msg=new StringBuffer(title).append(description);
		sendClientMsg(customer_id, headshipClient, weixin, sms, news,msg,statusOutStore);
		return null;
	}
//	private Map<String, Object> noticeClient(String customer_id,String corp_sim_name,String ivt_oper_listing,
//			boolean sms,boolean weixin, String statusOutStore,String headshipClient, String processName, String imgName) {
//		StringBuffer msg=new StringBuffer(corp_sim_name+"您的订单单号:").append(ivt_oper_listing);
////		msg.append(",产品名称:").append(mapOrder.get("item_sim_name")).append(",金额:").append(mapOrder.get("sum_si"));
//		msg.append(",订单状态为:").	append(statusOutStore);
//		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
//		Map<String,Object> mapMsg=new HashMap<String, Object>();
//		mapMsg.put("title", "订单状态进度通知");
//		mapMsg.put("description",msg);
//		String params=ivt_oper_listing+"|"+utf8to16(processName);
//		if("saiyu".equalsIgnoreCase(ConfigFile.emplName)){
//			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/personalCenter.do?order|"+params);
//		}else{
//			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/myorder.do?"+params);
//		}
//		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/"+imgName);
//		if(getCustomer(getRequest())!=null){
//			mapMsg.put("sendRen", getCustomerId(getRequest()));
//		}else if(getEmployee(getRequest())!=null){
//			mapMsg.put("sendRen", getEmployeeId(getRequest()));
//		}
//		news.add(mapMsg);
//		sendClientMsg(customer_id, headshipClient, weixin, sms, news,msg,processName);
//		return null;
//	}
	/**
	 * 
	 * @param customer_id
	 * @param headshipClient
	 * @param weixin
	 * @param sms
	 * @param news
	 * @param msg
	 * @param processName 
	 */
	private void sendClientMsg(Object customer_id, String headshipClient, boolean weixin, boolean sms, List<Map<String, Object>> news, StringBuffer msg, String processName) {
		if(weixin){
			sendclientmsg(headshipClient+"", news, customer_id+"",processName);
		}
		if(sms){
			List<String> phones=getCustomerPhoneByHeadship(customer_id, headshipClient,processName);
			if(phones!=null){
				for (String phone : phones) {
					if(StringUtils.isNotBlank(phone)){
						Map<String,Object> mapsms=getSystemParamsByComId();
						SendSmsUtil.sendSms2(phone, null, msg.toString(),mapsms);
					} 
				}
			}
		}
	}
	//////////////////////////
	@Override
	public List<Map<String, Object>> getDeptToWeixin(Map<String, Object> map) {
		 
		return employeeDao.getDeptToWeixin(map);
	}
	
	@Override
	public List<Map<String, Object>> getEmployeeToWeixin(Map<String, Object> map) {
		
		return employeeDao.getEmployeeToWeixin(map);
	}
	@Override
	public List<Map<String, Object>> getVendorToWeixin(Map<String, Object> map) {
		return employeeDao.getVendorToWeixin(map);
	}
	//////////
	@Override
	public PageList<Map<String, Object>> collectionConfirmList(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+""); 
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.collectionConfirmCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=employeeDao.collectionConfirmList(map);
		pages.setRows(list);
		return pages;
	}
	@Override
	public void collConfirm(Map<String, Object> map) throws Exception {
		//TODO 收款确认
		map.put("now", getNow());
//		JSONObject item_json=getProcessParams(map.get("name").toString());
		JSONArray jsons=JSONArray.fromObject(map.get("list"));
		StringBuffer rid=new StringBuffer();
		boolean sms=getNoticeStyle(map, "1");
		boolean weixin=getNoticeStyle(map, "0");
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			Map<String,Object> params=new HashMap<String, Object>();
			params.put("confirm", json.get("confirm"));
			params.put("clerk_id", map.get("clerk_id"));
			params.put("dept_id", map.get("dept_id"));
			params.put("Status_OutStore", map.get("Status_OutStore"));
			params.put("seeds_id", json.get("seeds_id"));
			params.put("sum_si", json.get("sum_si"));
			params.put("sum_si_origin", json.get("sum_si_origin"));
			params.put("rcv_hw_no", json.get("settlement_id"));
			params.put("now", getNow());
			employeeDao.collConfirm(params);
			clientPaymentConfirmationNotice(json, weixin, sms, map.get("clerk_name"));
			
//			File path=getRecievedMemo(getRequest(), json.getString("recieved_id"),json.getString("customer_id"));
			String txt=null;//getFileTextContent(path);
			boolean smgb=false;
			if (StringUtils.isNotBlank(txt)) {
				String[] ors=txt.split("订单编号:");
				if(ors!=null&&ors.length==2){//向订单跟踪第一步发送微信消息
					smgb=true;
					rid.append(json.get("recieved_id")).append("|");
//					rid.append(json.get("customer_id")).append(",");
					//向客户发送款项已确认消息
					List<Integer> seeds=getOrderSeedsByRecieved(json.getString("recieved_id")+"|"+json.getString("customer_id"));
					if (seeds!=null&&seeds.size()>0) {
						for (Integer seeds_id : seeds) {
							saveOrderHistory(seeds_id,getComName()+"出纳收款到账确认,确认人:"+map.get("clerk_name"));
						}
					}else{
						txt=txt.split("订单编号:")[1];
						if(StringUtils.isNotBlank(txt)){
							if(!txt.startsWith("[")){
								txt="["+txt+"]";
							}
							JSONArray orders=JSONArray.fromObject(txt);
							for (int k = 0; k < orders.size(); k++) {
								JSONObject order=orders.getJSONObject(k);
								if (order.has("ivt_oper_listing")) {
									saveOrderHistory(order.getString("ivt_oper_listing"),order.getString("item_id"), "出纳收款到账确认,确认人:"+map.get("clerk_name"));
								}else{
									if(order.has("orderNo")){
										saveOrderHistory(order.getString("orderNo"),order.getString("item_id"), getComName()+"出纳收款到账确认,确认人:"+map.get("clerk_name"));
									}else{
										Map<String,Object> param=new HashMap<String, Object>();
										param.put("recieved_id", json.getString("recieved_id"));
										param.put("customer_id", json.getString("customer_id"));
										param.put("item_id", order.getString("item_id"));
										param.put("com_id", getComId());
										param=employeeDao.getOrderNoByRecieved(param);
										saveOrderHistory(param.get("ivt_oper_listing"),param.get("item_id"), getComName()+"出纳收款到账确认,确认人:"+map.get("clerk_name"));
									}
								}
							}
						}
					}
					
				}
			}else{
//				String orderId=employeeDao.getOrderSeeds(params);
//				if(StringUtils.isNotBlank(orderId)){
//					smgb=true;
//					String[] ids=orderId.split(",");
//					for (String id : ids) {
//						saveOrderHistory(id, getComName()+"出纳收款到账确认,确认人:"+map.get("clerk_name"));
//					}
//				}
			}
			if (smgb||json.getInt("sum_si")>0) {
				//向员工发送订单跟踪流程协同消息
				Map<String, String[]> param=getProcessName();
				String Eheadship=param.get("Eheadship")[0];
				String processName=param.get("processName")[0];
				String imgName=param.get("imgName")[0];
				if(!processName.contains("核货")){
					employeeOrderProcessNotice(rid, weixin, sms);
					return;
				}
				String title="请核准客户订单，产品数量是否足够";
				StringBuffer description=new StringBuffer("@comName@Eheadship@clerkName:");
				description.append("出纳已经核实客户-").append(json.get("corp_sim_name")).append("的货款到账，请核准其订单，产品数量是否足够发出？");
				String url=ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?processName="+utf8to16(processName+"");
				List<Map<String,String>> touserList=null;
				if(weixin){
					touserList= sendMessageNewsEmployee(title, description.toString(), Eheadship, imgName, url, null);
				}
				if(sms){
					if (touserList==null) {
						Map<String,Object> mapparams=new HashMap<String, Object>();
						mapparams.put("com_id", getComId());
						mapparams.put("headship", "%"+Eheadship+"%");
						mapparams.put("processName", "%"+processName+"%");
						mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
						touserList=employeeDao.getPersonnelNeiQing(mapparams);
					}
					for (Map<String, String> item : touserList) {
						Map<String,Object> mapsms=getSystemParamsByComId();
						SendSmsUtil.sendSms2(item.get("movtel"), null, description.toString(),mapsms);
					}
				}
			}
			}
	}

	/**
	 * 员工
	 * @param rid 
	 * @param weixin 
	 * @param sms 
	 */
	private void employeeOrderProcessNotice(StringBuffer rid, boolean weixin, boolean sms) {
		if(rid.length()>1){
			Map<String, String[]> param=getProcessName();
			String Eheadship=param.get("Eheadship")[0];
			String processName=param.get("processName")[0];
			List<Map<String,String>> touserList=null;
			if(weixin){
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title","订单协同通知");
				mapMsg.put("description",getComName()+"-@Eheadship-@clerkName:您有一条出纳已收款确认需要进行订单【"+processName+"】协同");///传递收款单号,在订单跟踪里面对收款单号对应的订单备注文本解析处理
				if(processName.contains("生产")){
					mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/pPlan/productionPlan.do");
				}else{
					mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?processName="+utf8to16(processName+""));
				}
				if (processName.contains("款")||mapMsg.get("title").toString().contains("款")) {
					mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
				}else{
					mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
				}
				if(getCustomer(getRequest())!=null){
					mapMsg.put("sendRen", getCustomerId(getRequest()));
				}else if(getEmployee(getRequest())!=null){
					mapMsg.put("sendRen", getEmployeeId(getRequest()));
				}
				news.add(mapMsg);
				touserList=sendemployeemsg(Eheadship, news, getComId(), processName);
			}
			if(sms){
				if(touserList==null){
					Map<String,Object> mapparams=new HashMap<String, Object>();
					mapparams.put("com_id", getComId());
					mapparams.put("headship", "%"+Eheadship+"%");
					mapparams.put("processName", "%"+processName+"%");
					mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
					touserList=employeeDao.getPersonnelNeiQing(mapparams);
				}
				for (Map<String, String> map2 : touserList) {
					StringBuffer msg=new StringBuffer(map2.get("clerk_name"));
					msg.append(",您有一条出纳已收款确认需要进行订单[").append(processName).append("]协同,");
					msg.append("收款单号:").append(rid.toString());
					Map<String,Object> mapsms=getSystemParamsByComId();
					SendSmsUtil.sendSms2(map2.get("movtel"), null, msg.toString(),mapsms);
				}
			}
		}
	}
	/**
	 * 向客户发送款项已确认消息
	 * @param json 收款消息
	 * @param weixin 是否微信通知
	 * @param sms 是否短信通知
	 * @param clerk_name 收款人名称
	 */
	private void clientPaymentConfirmationNotice(JSONObject json, boolean weixin, boolean sms,Object clerk_name) {
		BigDecimal sum_si=new BigDecimal(json.getString("sum_si"));
		if(BigDecimal.ZERO.compareTo(sum_si)<0){//收款金额大于0才向客户发送到账消息
			Map<String, Object> mapOrder=new HashMap<String, Object>();
			mapOrder.put("customer_id", json.getString("customer_id"));
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title","已确认其款项到账");
			StringBuffer description=new StringBuffer("，您支付的订单货款，");
			description.append(getComName()).append("出纳，已确认到账。金额").append(json.get("sum_si")).append(",收款单号:");
			description.append(json.get("recieved_id"));///.append(",确认人:").append(clerk_name)
			mapMsg.put("description",description.toString()); 
			mapMsg.put("addName","description"); 
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/customer/accountStatement.do?recieved_id="+json.get("recieved_id"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			List<Map<String, String>> cuslist=null;
			String paymentConfirmationHeadship=getSystemParam("paymentConfirmationHeadship")+"";
			if(weixin){
				cuslist=sendclientmsg(paymentConfirmationHeadship, news, json.getString("customer_id"), "收款确认");
			}
			if(sms){
				if(cuslist==null){
				 	Map<String,Object> params=new HashMap<String, Object>();
					params.put("headship","%"+paymentConfirmationHeadship+"%");
					params.put("processName","%收款确认%");
					params.put("com_id", getComId());
					params.put("upper_customer_id",json.getString("customer_id"));
					params.put("omrtype",getSystemParam("ordersMessageReceivedType"));
					cuslist=customerDao.getCustomerWeixinByHeadship(params);
				}
				for (Map<String, String> map2 : cuslist) {
					Map<String,Object> mapsms=getSystemParamsByComId();
					SendSmsUtil.sendSms2(map2.get("movtel"), null, description.toString(),mapsms);
				}
			}
		}
	}
	@Override
	public String getPersonnelByMobile(Map<String, Object> map) {
		
		return employeeDao.getPersonnelByMobile(map);
	}

	@Override
	public void updateWeixinId(Map<String, Object> map) {
		employeeDao.insertSql(getUpdateSql(map, "ctl00801", "clerk_id", map.get("clerk_id").toString(), true));
	}

	@Override
	public void savePersonnelToWeixin(Map<String, Object> map) {
		employeeDao.insertSql(getInsertSql("ctl00801", map));
	}
	
	@Override
	public Map<String, Object> getDeptByName(Map<String, Object> map) {
		return employeeDao.getDeptByName(map);
	}
	
	@Override
	public void updateDeptToWeixin(Map<String, Object> map) {
		employeeDao.insertSql(getUpdateSql(map, "ctl00701", "sort_id", map.get("sort_id").toString(), true));
	}
	@Override
	public String getDeptUpperIdByid(Map<String, Object> dept) {
		return employeeDao.getDeptUpperIdByid(dept);
	}
	@Override
	public void saveDeptToWeixin(Map<String, Object> dept) {
		employeeDao.insertSql(getInsertSql("ctl00701", dept));
	}
	
	@Override
	public void backup(Map<String,Object> map) {
		employeeDao.backup(map);
	}
	
	@Override
	public PageList<Map<String, Object>> salesReceiptsList(
			Map<String, Object> map) {
		int totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.salesReceiptsListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=employeeDao.salesReceiptsList(map);
		
		pages.setRows(list);
		return pages;
	}
	@Override
	public void updateWeixinInvite(String weixinID) {
		String sSql="update ctl00801 set weixinStatus='1' where weixinID='"+weixinID+"'";
		employeeDao.insertSql(sSql);
		sSql="update sdf00504 set weixinStatus='1' where weixinID='"+weixinID+"'";
		employeeDao.insertSql(sSql);
	}

	@Override
	public PageList<Map<String, Object>> getPersonnelsSignInfo(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getPersonnelsSignInfoCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=employeeDao.getPersonnelsSignInfoList(map);
		
		pages.setRows(list);
		return pages;
	}
	/////////////////////////////////
	@Override
	public PageList<Map<String, Object>> vendorOrderList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if(map.get("beginDate")!=null){
			String beginDate=map.get("beginDate").toString()+" 00:00:00.000";
			map.put("beginDate", beginDate);
		}
		if(map.get("endDate")!=null){
			String endDate=map.get("endDate").toString()+" 23:59:59.999";
			map.put("endDate", endDate);
		}
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.vendorOrderListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		
		List<Map<String,Object>> list=employeeDao.vendorOrderList(map);
		
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public PageList<Map<String, Object>> waitingPurchasing(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.waitingPurchasingCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=employeeDao.waitingPurchasingList(map);
		getTailorInfoByOrder(list);
		pages.setRows(list);
		return pages;
	}
	/**
	 * 获取定制需求信息根据订单编号
	 * @param list
	 */
	private void getTailorInfoByOrder(List<Map<String, Object>> list) {
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> itemmap = iterator.next();
			if (isNotMapKeyNull(itemmap, "item_id")) {
				String orderNo=MapUtils.getString(itemmap, "item_id").trim();
				if(orderNo.startsWith("NO")){
					try {
						List<String> imgs= getTailorInfoImgs(getRequest(), orderNo);
						itemmap.put("imgs", imgs);
						String txt=getFileTextContent(getTailorInfoJsonPath(getRequest(), orderNo));
						if (StringUtils.isNotBlank(txt)) {//需求信息
							itemmap.put("info", JSONObject.fromObject(txt));
						}
					} catch (Exception e) {}
				}
			}
		}
	}
	
	@Override
	public String zuofeiPOrder(Map<String, Object> map) throws Exception {
		
		return employeeDao.zuofeiPOrder(map)+"";
	}
	
	@Override
	public String savePurchasingOrder(Map<String, Object> map) throws Exception {
		JSONArray jsons=JSONArray.fromObject(map.get("item_ids"));
		Set<String> vendors=new HashSet<String>();
		///获取所有供应商,放入set中,用于确定生成几条主表数据
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			vendors.add(json.getString("vendor_id"));
		}
//		Set<Map<String,Object>> set=new HashSet<Map<String,Object>>();
		StringBuffer sSql=new StringBuffer();
		for (String vendor : vendors) {
			String st_auto_no=getOrderNo(customerDao, "采购订单", map.get("com_id").toString());
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				if(vendor.equals(json.getString("vendor_id"))){///供应商编码一致生成到同一个主表对应的从表中
					//存储从表
					Map<String,Object> mapitem=new HashMap<String, Object>();
					mapitem.put("com_id",map.get("com_id"));
					mapitem.put("st_auto_no",st_auto_no);
					getJsonVal(mapitem, json, "item_id", "item_id");
					getJsonVal(mapitem, json, "rep_qty", "pronum");
					getJsonVal(mapitem, json, "hav_rcv", "pronum");
					getJsonVal(mapitem, json, "c_memo", "c_memo");
					getJsonVal(mapitem, json, "mps_id", "ivt_oper_listing");
					Integer c=employeeDao.checkPur(mapitem);
					if(c>0){//表示已经在表中已经存在
						sSql.append("update STD02001 set rep_qty=rep_qty+").append(mapitem.get("rep_qty"));
						sSql.append(",hav_rcv=hav_rcv+").append(mapitem.get("hav_rcv"))
						.append(" where ltrim(rtrim(isnull(com_id,'')))='").append(map.get("com_id")).append("'");
						sSql.append(" and ltrim(rtrim(isnull(item_id,'')))='").append(mapitem.get("item_id")).append("'");
						sSql.append(" and ltrim(rtrim(isnull(st_auto_no,'')))='").append(st_auto_no).append("'");
					}else{
						mapitem.put("st_hw_no",st_auto_no);
						mapitem.put("m_flag",6);//未审核
						mapitem.put("at_term_datetime",getNow());
						getJsonVal(mapitem, json, "price", "item_cost");
						getJsonVal(mapitem, json, "pack_num", "pack_unit");
						getJsonVal(mapitem, json, "pack_unit", "item_unit");
						employeeDao.insertSql(getInsertSql("STD02001", mapitem));
					}
					//////////////////组合发微信信息//////////
//					Map<String,Object> mapgys=new HashMap<String, Object>();
//					mapgys.put("st_auto_no", st_auto_no);
//					getJsonVal(mapgys, json, "weixinID", "weixinID");
//					getJsonVal(mapgys, json, "corp_sim_name", "corp_sim_name");
//					getJsonVal(mapgys, json, "movtel", "movtel");
//					set.add(mapgys);
					////////////////////////// 
					if(json.has("ivt_oper_listing")&&StringUtils.isNotBlank(json.getString("ivt_oper_listing"))){
						getJsonVal(mapitem, json, "ivt_oper_listing", "ivt_oper_listing");
						mapitem.put("st_auto_no", st_auto_no);
						employeeDao.updateOrderPurchasing(mapitem);
					}
				}
			}
			sSql.append(";");
			if (sSql.length()>5) {
				employeeDao.insertSql(sSql.toString());
			}
			///存储主表
			Map<String,Object> mapmain=new HashMap<String, Object>();
			mapmain.put("com_id",map.get("com_id"));
			mapmain.put("st_auto_no",st_auto_no);
			mapmain.put("st_hw_no",st_auto_no);
			mapmain.put("vendor_id",vendor);
			mapmain.put("cgt_day",map.get("cgt_day"));
			Calendar c = Calendar.getInstance();
			mapmain.put("finacial_y", c.get(Calendar.YEAR));
			mapmain.put("finacial_m", c.get(Calendar.MONTH));
			mapmain.put("finacial_d",getNow());
			mapmain.put("mainten_datetime",getNow());
			mapmain.put("comfirm_flag","Y");
			mapmain.put("clerk_id", getEmployeeId(getRequest()));
			mapmain.put("mainten_clerk_id", getEmployeeId(getRequest()));
			employeeDao.insertSql(getInsertSql("STDM02001", mapmain));
		}
		//////发送消息部分//////////
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", "采购订单审核通知");
		mapMsg.put("description", getComName()+"-@Eheadship-@clerkName:采购员-"+map.get("clerk_name")+"增加了一笔采购订单,请审核物料采购价格。"); 
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/purchasingOrder.do?m_flag=6");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		zuheemployeesendmsg(map.get("headship")+"", news, map.get("com_id"), null);
		return null;
	}
	@Override
	public String purchasingOrderComfirm(Map<String, Object> map) {
		// TODO 采购订单审核
		employeeDao.purchasingOrderComfirm(map);
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", "产品采购订单-邀请授理");
		mapMsg.put("description", map.get("corp_sim_name")+":我公司已下单采购订单,物料名称:"+map.get("item_name")+"，请及时落实物料“有货”还是“无货”。采购订单编号："+map.get("st_auto_no")); 
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/supplier.do?st_auto_no="+map.get("st_auto_no")+"|type=0");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		if ("0".equals(map.get("type"))||"2".equals(map.get("type"))) {
			sendMessageNews(news,getComId(), map.get("weixinID")+"","供应商");
		}
		if("1".equals(map.get("type"))||"2".equals(map.get("type"))){
			if(!isMapKeyNull(map, "movtel")){
				Map<String,Object> mapsms=getSystemParamsByComId();
				SendSmsUtil.sendSms2(map.get("movtel").toString(), null, mapMsg.get("title")+","+mapMsg.get("description"),mapsms);
			}
		}
			return null;
	}
	/**
	 * 获取需要发消息的
	 * @param title
	 * @param description
	 * @param url
	 * @return
	 */
	public List<Map<String,Object>> getMessageNews(String title,String description,String url) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",title);
		mapMsg.put("description",description); 
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		return news;
	}
	
	/*
	 * VIEW_STDM02001_ctl03001 已向供应商下采购单视图
	 * View_sdd02020G待采购订单数据不包含供应商信息和产品信息
	 * view_waitingPurchasing 待采购订单数据包含供应商信息和产品信息,
	 * 
	 * */
	
	@Override
	public List<Map<String, Object>> getDriverToWeixin(Map<String, Object> map) {
		
		return employeeDao.getDriverToWeixin(map);
	}
	@Override
	public String confirmGys(Map<String, Object> map) {
		 employeeDao.confirmGys(map);
		 List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", map.get("corp_sim_name")+",您有一条来自【"+getComName()+"】的采购订单,请尽快进行处理");
			mapMsg.put("description","采购订单号:"+map.get("st_auto_no")); 
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/supplier.do?st_auto_no="+map.get("st_auto_no"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			if ("0".equals(map.get("type"))) {
				sendMessageNews(news,getComId(), map.get("weixinID").toString(),"供应商");
			}
			if("1".equals(map.get("type"))){
				if(!isMapKeyNull(map, "movtel")){
					Map<String,Object> mapsms=getSystemParamsByComId();
					SendSmsUtil.sendSms2(map.get("movtel").toString(), null, mapMsg.get("title")+","+mapMsg.get("description"),mapsms);
				}
			}
		return null;
	}
	@Override
	public String cuidan(Map<String, Object> map) {
		Map<String,Object> mapgys=employeeDao.getGysInfoByOrder(map);
		 List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", "产品采购订单-邀请受理");
			mapMsg.put("description",mapgys.get("corp_sim_name")+",您有一条来自【"+getComName()+"】的采购订单,请尽快进行处理,采购订单号:"+map.get("st_auto_no")); 
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/supplier.do?st_auto_no="+map.get("st_auto_no")+"|type=0");
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			if ("0".equals(map.get("type"))||"2".equals(map.get("type"))) {
				sendMessageNews(news, mapgys.get("weixinID").toString(),"供应商");
			}
			if("1".equals(map.get("type"))||"2".equals(map.get("type"))){
				if(!isMapKeyNull(mapgys, "movtel")){
					Map<String,Object> mapsms=getSystemParamsByComId();
					SendSmsUtil.sendSms2(mapgys.get("movtel").toString(), null, mapMsg.get("title")+","+mapMsg.get("description"),mapsms);
				}
			}
		return null;
	}
	@Override
	public Map<String, Object> getYanshouGysInfo(Map<String, Object> map) {
		return employeeDao.getYanshouGysInfo(map);
	}
	@Override
	public List<Map<String, Object>> getYanshouOrder(Map<String, Object> map) {
		return employeeDao.getYanshouOrder(map);
	}
	/**
	 * 保存订单产品的库存数
	 * @param map
	 * @param json
	 */
	private void saveProductInventory(Map<String,Object> map,JSONObject json) {
		Calendar c=Calendar.getInstance();
		//查询库存表中产品是否存在
		Map<String,Object> mapquery=new HashMap<String,Object>();
		mapquery.put("com_id",map.get("com_id"));
		String store_struct_id="";
		if (json.has("store_struct_id")&&StringUtils.isNotBlank(json.getString("store_struct_id"))) {
			store_struct_id=json.getString("store_struct_id");
		}else{
			if (isNotMapKeyNull(map, "store_struct_id")) {
				store_struct_id=map.get("store_struct_id").toString();
			}
		}
		mapquery.put("store_struct_id",store_struct_id);
		mapquery.put("item_id",json.get("item_id"));
		Map<String,Object> mapware=employeeDao.checkProductWare(mapquery);
		//存在更新
		Map<String,Object> thMap=new HashMap<>();
		thMap.put("finacial_datetime", getNow());
		thMap.put("maintenance_datetime", getNow());
		thMap.put("mainten_clerk_id", getEmployeeId(getRequest()));
		thMap.put("finacial_y", c.get(Calendar.YEAR));
		thMap.put("finacial_m", c.get(Calendar.MONTH));
		thMap.put("store_struct_id", store_struct_id);
		thMap.put("item_id", json.get("item_id"));
		thMap.put("com_id",getComId());
		if (mapware!=null) {//库存累加
			BigDecimal sd_oq=new BigDecimal(json.getString("sd_oq"));
			BigDecimal accn_ivt=new BigDecimal(mapware.get("accn_ivt")+"");
			BigDecimal use_oq=new BigDecimal(mapware.get("use_oq")+"");
			thMap.put("accn_ivt",sd_oq.add(accn_ivt));
			thMap.put("use_oq",sd_oq.add(use_oq));
			String sql="";
			if (isNotMapKeyNull(thMap, "store_struct_id")) {
				sql=" and ltrim(rtrim(isnull(store_struct_id,'')))='"+store_struct_id+"'";
			}
			managerDao.insertSql(getUpdateSql(thMap, "IVTd01302", "item_id", json.getString("item_id"))+sql);
		}else{
			//不存在插入
			thMap.put("accn_ivt",json.get("sd_oq"));
			thMap.put("use_oq",json.get("sd_oq"));
			thMap.put("sSql", getInsertSqlByPre("IVTd01302", thMap));
			productDao.insertSqlByPre(thMap);
		}
	}
	
	@Override
	public void noticeReceipt(Map<String, Object> map, String[] list) {
		//更新采购表数据更新为已收货
		StringBuffer buffer=new StringBuffer();
		StringBuffer st_auto_no=new StringBuffer();
		for (String item : list) {
			buffer.append("update STD02001 set ");
			JSONObject json=JSONObject.fromObject(item);
			buffer.append(" m_flag=5 ").append(" where item_id='").append(json.getString("item_id")).append("'");
			buffer.append(" and st_auto_no='").append(json.getString("st_auto_no")).append("';");
			buffer.append("update  STDm02001 set mainten_clerk_id='").append(getEmployeeId(getRequest()));
			buffer.append("', mainten_datetime='").append(getNow()).append("'").append(" where st_auto_no='").
			append(json.getString("st_auto_no")).append("';");
			if (st_auto_no.indexOf(json.getString("st_auto_no"))>-1) {
				st_auto_no.append(json.getString("st_auto_no")).append(",");
			}
			// TODO 更新库存
			saveProductInventory(map, json);
		}
		managerDao.insertSql(buffer.toString());
		//向采购发送消息
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		String title= "您有一条采购订单已收货,请尽快进行处理";
		mapMsg.put("title",title);
		mapMsg.put("description","供应商:"+map.get("gysname")); 
		//通知出纳,录入采购订单,并通知下一步
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/receiving.do?st_auto_no="+map.get("st_auto_no")+"|type=luru");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		Map<String,Object> mapempl=new HashMap<String, Object>();
		String headship=getMapKey(map, "headship");
		mapempl.put("com_id", getComId());
		mapempl.put("headship", "%"+headship+"%");
		mapempl.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapempl);
		for (int i = 0; i < touserList.size(); i++) {
			 Map<String, String> item=touserList.get(i);
			news.get(0).put("title",headship+item.get("clerk_name")+":"+title);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				sendMessageNews(news,item.get("weixinID"),"供应商");
			}
			news.get(0).put("title",title);
		}
		//向供应商发消息
		news=new ArrayList<Map<String,Object>>();
		mapMsg=new HashMap<String, Object>();
		mapMsg.put("title","供应商:"+map.get("gysname")+",您有一条来自【"+getComName()+"】的采购订单已收货");
		mapMsg.put("description","供应商:"+map.get("gysname"));
		//通知出纳,录入采购订单,并通知下一步
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/supplier.do?st_auto_no="+st_auto_no);
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg); 
		sendMessageNews(news, map.get("weixinID").toString(),"供应商");
	}
	@Override
	public void entryNotice(Map<String, Object> map) {
		//向采购发送消息
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", "您有一条来自【"+map.get("gysname")+"】的采购订单已收货入库,请进行订单核货处理");
		mapMsg.put("description",map.get("description")); 
		//通知出纳,录入采购订单,并通知下一步
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?st_auto_no="+map.get("st_auto_no")+"");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		String[] heas=map.get("headship").toString().split(",");
		if(heas!=null&&heas.length>0){
			for (int j = 0; j < heas.length; j++) {
				sendWexinMsgToEmployee(news, heas[j]);
			}
		}
	}
	@Override
	public void guardConfirmNotice(Map<String, Object> map) {
		if ("chumen".equals(map.get("type"))) {
			///司机出门,门卫核对信息
		}else{
			//1.通知库存注意接车
			List<Map<String,Object>> list=saiYuDao.getOrderInfoByIds(map.get("seeds_id").toString());
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", list.get(0).get("corp_name")+"客户的司机已经进厂,请准备接车");
			mapMsg.put("description",list.get(0).get("HYS"));
			mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/driverWaybillDetail.do?seeds_id="+map.get("seeds_id"));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/driveShou.png");
			news.add(mapMsg);
			//1.2发送消息部分
			sendWexinMsgToEmployee(news, "库管");
			//2.根据id和司机信息
			//3.发微信给司机
			//保存订单跟踪记录
			saveOrderHistory(map.get("seeds_id"), map.get("clerk_name")+"门卫确认司机信息,并通知库管接车");
		}
	}
	@Override
	public void noticeDriveGuard(Map<String, Object> map) {
		//1.向司机发送过磅消息at_term_datetime_Act
		List<Map<String,Object>> list=saiYuDao.getOrderInfoByIds(map.get("seeds_id").toString());
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		String HYS=list.get(0).get("HYS").toString();
		mapMsg.put("title",map.get("title"));
		mapMsg.put("description",map.get("description").toString().replaceAll("@hys", HYS.substring(0, HYS.indexOf("("))));
		mapMsg.put("url", ConfigFile.urlPrefix+"/orderTrack/successLoad.do?seeds_id="+map.get("seeds_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/driveShou.png");
		news.add(mapMsg);
		map.put("id", HYS.split(",")[2]);
		List<Map<String, Object>> drives= employeeDao.getDriverToWeixin(map);
		sendMessageNews(news,drives.get(0).get("weixinID").toString(),"司机");
		//2.向门卫发送关注过磅消息
		news.get(0).put("title","司机出厂核对重量通知");
		news.get(0).put("description","司机:"+HYS.substring(0, HYS.indexOf("("))+",已经完成装车请核对重量消息");
		news.get(0).put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/orderTrack/verify.do?seeds_id="+map.get("seeds_id"));
		sendWexinMsgToEmployee(news, "门卫");
		///更新数据库订单产品装车时间和订单状态为通知收货
		map.put("at_term_datetime_Act", getNow());
		String[] pros=getProcessName(getRequest());
		for (String str : pros) {
			if(str.contains("收货")){
				map.put("Status_OutStore", str);
			}
		}
		employeeDao.updateOrderStatus(map);
		saveOrderHistory(map.get("seeds_id"), "库管"+map.get("clerk_name")+",已经装车完成通知司机过磅");
	}
	@Override
	public void cuikuan(Map<String, Object> map) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("title"));
		mapMsg.put("description",map.get("description"));
		mapMsg.put("url", ConfigFile.urlPrefix+"/customer/accountStatement.do");
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
		news.add(mapMsg);
		List<Map<String,String>> phones=zuheclientsendmsg(map.get("headship").toString(), news, map.get("customer_id").toString(), null);
		for (Map<String,String> phone : phones) {
			if(StringUtils.isNotBlank(phone.get("phone"))){
				Map<String,Object> mapsms=getSystemParamsByComId();
				SendSmsUtil.sendSms2(phone.get("phone"), null,
						"尊敬的客户["+phone.get("corp_sim_name")+"]"+ map.get("title")+map.get("description"),mapsms);
			}
		}
	}
	@Override
	public PageList<Map<String, Object>> purchasingCheckList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.purchasingCheckListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.purchasingCheckList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> getSupplierByComId(Map<String, Object> map) {
		String corp_id=employeeDao.getSupplierId(map);
		int page=Integer.parseInt(map.get("page").toString());
		int rows=Integer.parseInt(map.get("rows").toString());
		List<Map<String,Object>> list=null;
		if (StringUtils.isNotBlank(corp_id)) {
			String[] cusids=corp_id.split(",");
			int len=cusids.length;
			if (map.get("keyname")==null||map.get("keyname")=="") {
				List<String> listpage=new ArrayList<String>();
				if (page>0) {
					page=page*rows;
				}
				int index=0;
				for (int i =page; i < cusids.length; i++) {
					if (index==rows) {
						break;
					}else{
						listpage.add(cusids[i]);
					}
					index++;
				}
				if (cusids!=null&&cusids.length>0) {
					map.put("cusids", listpage);
				}else{
					map.put("cusids",null);
				}
			}else{
				len=0;
				map.put("cusids",cusids);
			}
			PageList<Map<String, Object>> pages=new PageList<Map<String,Object>>(page,rows,len);
			list= employeeDao.getSupplierByComId(map);
			pages.setRows(list);
			return pages;
		}else{
			SupplierQuery query=new SupplierQuery();
			query.setCom_id(map.get("com_id").toString());
			query.setPage(page);
			query.setRows(rows);
			if (map.get("keyname")!=null) {
				query.setSearchKey(map.get("keyname").toString().replaceAll("%", ""));
			}
			return customerServer.findSupplier(query);
		}
	}

	@Override
	public List<Map<String, Object>> setDefaultByClerkId(Map<String, Object> map) {
		return employeeDao.setDefaultByClerkId(map);
	}

	@Override
	public PageList<Map<String, Object>> getProcurementList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getProcurementListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String,Object>> list=employeeDao.getProcurementList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> purchasingReturnList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.purchasingReturnListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.purchasingReturnList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public String saveDirectOrder(Map<String, Object> map){
		JSONArray jsons=JSONArray.fromObject(map.get("item_ids"));
		Object vendor_id=null;
		for (int i = 0; i < jsons.size(); i++) {
			JSONArray jsonitems= jsons.getJSONArray(i);
			String st_auto_no=getOrderNo(customerDao, "采购订单", map.get("com_id").toString());
			for (int j = 0; j < jsonitems.size(); j++) {
				JSONObject json=jsonitems.getJSONObject(j);
				//存储从表
				Map<String,Object> mapitem=new HashMap<String, Object>();
				mapitem.put("com_id",map.get("com_id"));
				mapitem.put("c_memo",map.get("c_memo"));
				mapitem.put("st_auto_no",st_auto_no);
				mapitem.put("m_flag","4");
				getJsonVal(mapitem, json, "item_id", "item_id");
				getJsonVal(mapitem, json, "rep_qty", "pronum");
				getJsonVal(mapitem, json, "hav_rcv", "pronum");
				mapitem.put("st_hw_no",st_auto_no);
				mapitem.put("at_term_datetime",getNow());
				getJsonVal(mapitem, json, "price", "item_cost");
				getJsonVal(mapitem, json, "pack_num", "pack_unit");
				getJsonVal(mapitem, json, "pack_unit", "item_unit");
				getJsonVal(mapitem, json, "discount_rate", "discount_rate");
				getJsonVal(mapitem, json, "item_type", "item_type");
				employeeDao.insertSql(getInsertSql("STD02001", mapitem));
				vendor_id=json.get("vendor_id");
			}
			///存储主表
			Map<String,Object> mapmain=new HashMap<String, Object>();
			mapmain.put("com_id",map.get("com_id"));
			mapmain.put("clerk_id",map.get("clerk_id"));
			mapmain.put("dept_id",map.get("dept_id"));
			mapmain.put("st_auto_no",st_auto_no);
			mapmain.put("st_hw_no",st_auto_no);
			mapmain.put("vendor_id",vendor_id);
			Calendar c = Calendar.getInstance();
			mapmain.put("finacial_y", c.get(Calendar.YEAR));
			mapmain.put("finacial_m", c.get(Calendar.MONTH));
			mapmain.put("finacial_d",getNow());
			mapmain.put("mainten_datetime",getNow());
			mapmain.put("clerk_id", getEmployeeId(getRequest()));
			mapmain.put("mainten_clerk_id", getEmployeeId(getRequest()));
			employeeDao.insertSql(getInsertSql("STDM02001", mapmain));
		}
		return null;
	}
	@Override
	public void GenerateSignBaseTable() {
//		Map<String, String> map=new HashMap<>();
//		map.put("com_id", "001");
//		employeeDao.GenerateSignBaseTable(map);
//		 List<Map<String,Object>> comlist= operatorsDao.getAll();
//		 String date=DateTimeUtils.dateToStr();
//		 for (Map<String, Object> map2 : comlist) {
//			 String com_id=map2.get("com_id").toString().trim();
//			 Map<String, Object> sysParam=managerDao.checkSystem("isGenerateSaturday", com_id);
//			 if(DateTimeUtils.isSATURDAY(date)){
//				 if("false".equals(sysParam.get("param_val"))){
//					 continue;
//				 }
//			 }
//			 sysParam=managerDao.checkSystem("isGenerateSaturday", com_id);
//			 if(DateTimeUtils.isSUNDAY(date)){
//				 if("false".equals(sysParam.get("param_val"))){
//					 continue;
//				 }
//			 }
//			 Map<String, Object> map=new HashMap<String, Object>();
//			 map.put("com_id", com_id);
//			 List<Map<String,String>> list=employeeDao.getPersonnelNeiQing(map);
//			 for (Map<String, String> map3 : list) {
//				map3.put("signDate", date);
//				employeeDao.GenerateSignBaseTable(map3);
//			}
//		}
		//2.判断当天签到表是否生成,
		//2.1生成就直接跳过
		//3.循环生成签到表数据
	}
	
	@Override
	public String saveSignInfo(Map<String, Object> map) {
		//1.获取是否已经生成签到基础表
		map.put("signDate", DateTimeUtils.dateToStr());
		employeeDao.saveSignInfo(map);
		//1.1没有生成就手动生成一个
		//1.2生成后就自动更新
		return null;
	}
	
	@Override
	public String updateSignInfo(Map<String, Object> map) {
		employeeDao.updateSignInfo(map);
		return null;
	}
	
	@Override
	public PageList<Map<String, Object>> getSignInfoList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;		
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getSignInfoListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getSignInfoList(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 =iterator.next();
			if (isNotMapKeyNull(map2, "signDate")) {
				if(DateTimeUtils.isSATURDAY(map2.get("signDate")+"")){
					map2.put("c_memo", "星期六");
				}
				if(DateTimeUtils.isSUNDAY(map2.get("signDate")+"")){
					map2.put("c_memo", "星期天");
				}
			}
		}
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public List<Map<String, Object>> getSignInfoCount(Map<String, Object> map) {
		
		return employeeDao.getSignInfoCount(map);
	}
	
	@Override
	public List<Map<String, Object>> employeeSignExport(Map<String, Object> map) {
		List<Map<String, Object>> list=employeeDao.employeeSignExport(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 =iterator.next();
			if(DateTimeUtils.isSATURDAY(map2.get("signDate")+"")){
				map2.put("c_memo", "星期六");
			}
			if(DateTimeUtils.isSUNDAY(map2.get("signDate")+"")){
				map2.put("c_memo", "星期天");
			}
		}
		return list;
	}

	@Override
	public PageList<Map<String, Object>> getNOByComId(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getNOByComIdCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getNOByComIdList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public String getCgAmountByNo(Map<String, Object> map) {
		return employeeDao.getCgAmountByNo(map);
	}

	@Override
	public String getYfAmountByNo(Map<String, Object> map) {
		return employeeDao.getYfAmountByNo(map);
	}
	
	@Override
	public List<Map<String, Object>> sginedList(Map<String, Object> map) {
		 
		return employeeDao.sginedList(map);
	}
	
	@Override
	public String generatePurchaseOrderByPlan(Map<String,Object> map) throws Exception{
		String st_auto_no=getOrderNo(customerDao, "采购订单", map.get("com_id").toString());
		map.put("orderNo", st_auto_no);
		Map<String,Object> mapret= employeeDao.generatePurchaseOrderByPlan(map);
		StringBuffer msg=new StringBuffer();
		if(mapret!=null){
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title",map.get("title"));
			String description=map.get("description").toString();
			mapMsg.put("description",description);
			String url=ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/gather.do?st_auto_no=";
			mapMsg.put("url", url);
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			List<Map<String,String>> list=employeeDao.getPlanSupplierInfo(map);
			for (Map<String, String> map2 : list) {
				String desc=description.replaceAll("@gysName", map2.get("corp_name"));
				news.get(0).put("description",desc );
				news.get(0).put("url", url+map2.get("orderNo"));
				String ret=sendMessageNews(news, map2.get("weixinID"),"供应商");
				if (!"ok".equals(ret)) {
					msg.append("发送微信失败");
					//String txtMsg="【青清源】"+map.get("title")+","+desc+url+map2.get("orderNo");
					//SendSmsUtil.sendSms3(map2.get("movtel"), null, txtMsg);
				}else{
					msg.append("成功");
				}
				sendMessageNews(news, map.get("ling")+"","供应商");
				//String txtMsg="【青清源】"+map.get("title")+","+desc+url+map2.get("orderNo");
				//SendSmsUtil.sendSms3(map.get("ling")+"", null, txtMsg);
			}
		}
		return msg.toString();
	}
	@Override
	public List<Map<String, Object>> getGysUpItemInfoList(
			Map<String, Object> map) {
		return employeeDao.getGysUpItemInfoList(map);
	}
	
	@Override
	public String updateGysProFlag(Map<String, Object> map) {
		// TODO 更新供应商上报产品信息标识
		String msg= employeeDao.updateGysProFlag(map)+"";
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("title"));
		String description=map.get("description").toString().replaceAll("@comName", getComName());
		mapMsg.put("description",description);
		String url=ConfigFile.urlPrefix+"/login/toUrl.do?url=/supplier/uploading.do";
		mapMsg.put("url", url);
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		msg=sendMessageNews(news, map.get("weixinID")+"");
		return msg;
	}
	@Override
	public String editAddedInfo(Map<String, Object> map) {
		return employeeDao.editAddedInfo(map)+"";
	}
	@Override
	public String editOrderNum(Map<String, Object> map) {
		// TODO 修改订单数量
		StringBuffer pingjie=new StringBuffer();
		StringBuffer log=new StringBuffer(getComName());
		log.append("-员工:").append(map.get("clerk_name"));
		BigDecimal old_sd_oq=new BigDecimal(map.get("old_sd_oq").toString());//订单总数量
		BigDecimal sd_oq=new BigDecimal(map.get("sd_oq").toString());//订单总数量
		boolean b=false;
		String msg="无修改内容";
		if(isNotMapKeyNull(map, "old_sd_oq")&&old_sd_oq.compareTo(sd_oq)!=0){
			pingjie.append(",修改订单数量为:").append(map.get("sd_oq")).append(map.get("item_unit"))
			.append(",原订单数量:").append(old_sd_oq).append(map.get("item_unit"));
			b=true;
		}
		if (isNotMapKeyNull(map, "price")) {
			BigDecimal price=new BigDecimal(map.get("price").toString());
			BigDecimal oldprice=new BigDecimal(map.get("oldprice").toString());
			if (price.compareTo(oldprice)!=0) {
				pingjie.append("修改订单单价:").append(map.get("price")).append("元,原单价:").append(map.get("oldprice")).append("元");
				b=true;
			}
		}else{
			map.remove("price");
		}
		if (isNotMapKeyNull(map, "send_qty")) {
			BigDecimal send_qty=new BigDecimal(map.get("send_qty").toString());//本次发货数量
			BigDecimal send_sum=new BigDecimal(map.get("send_sum").toString());//本次发货数量
			BigDecimal syNum=sd_oq.subtract(send_sum);
			//结果是:-1 小于,0 等于,1 大于
			if (send_qty.compareTo(BigDecimal.ZERO)==1&&syNum.compareTo(send_qty)!=-1) {
				pingjie.append(",本次发货数:").append(map.get("send_qty")).append(map.get("casing_unit"))
				.append(",剩余未发数:").append(sd_oq.subtract(send_sum).subtract(send_qty)).append(map.get("casing_unit"));
				map.put("title", "订单发货申请");
				b=true;
			}else{
				b=false;
				msg="本次发货数量超过订单未发数,请调整!";
			}
		}
		if (b) {
			if (isNotMapKeyNull(map, "c_memo")) {
				pingjie.append(",备注:").append(map.get("c_memo"));
			}
			msg= employeeDao.editOrderNum(map)+"";
//			//TODO 更新订单对应的计划数据
//			//1.获取订单行中的计划单号
//			Map<String,Object> maporder= employeeDao.getOrderInfoBySeeds_id(map.get("seeds_id")+"");
//			//2.更新本次发货数量到计划数据行中
//			JSONObject json=new JSONObject();
//			json.put("com_id", map.get("com_id"));
//			json.put("ivt_oper_bill", maporder.get("ivt_oper_bill"));
//			json.put("item_id", map.get("item_id"));
//			json.put("pronum", map.get("send_qty"));
//			json.put("send_sum", map.get("send_sum"));
//			productDao.updatePlanNumByOrder(json);
			saveOrderHistory(map.get("seeds_id"), log.toString()+pingjie.toString());
			if(isNotMapKeyNull(map, "zhiwu")){
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title",map.get("title"));
				String description=map.get("description").toString().
						replaceAll("@comName", getComName()).
						replaceAll("@name", map.get("clerk_name")+"")+pingjie.toString();
				mapMsg.put("description",description);
				String url=ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?seeds_id="+map.get("seeds_id");
				mapMsg.put("url", url);
				mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
				news.add(mapMsg);
				String[] zhiwus=MapUtils.getString(map, "zhiwu").split(",");
				for (String headship : zhiwus) {
					zuheemployeesendmsg(headship, news, getComId(), "");
				}
			}
//			Map<String,Object> mapempl=employeeDao.getEmployeeByCustomerId(map);
		}
		return msg;
	}
	@Override
	public PageList<Map<String, Object>> getSalesKdList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getSalesKdListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getSalesKdList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public String saveSalesOrder(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="SDd02020";//主表
		String itemtable="SDd02021";//从表
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			String ivt_oper_listing = getOrderNo(customerDao, "销售开单", map.get("com_id").toString());
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Map<String, Object> itemMap = new HashMap<String, Object>();
				itemMap.put("ivt_oper_listing", ivt_oper_listing);
				itemMap.put("sd_order_id", ivt_oper_listing);
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("item_id", json.get("item_id"));
				itemMap.put("customer_id", map.get("customer_id"));
				if(json.has("store_struct_id")&&StringUtils.isNotBlank(json.getString("store_struct_id"))){
					itemMap.put("store_struct_id", json.get("store_struct_id"));
				}else{
					itemMap.put("store_struct_id", map.get("store_struct_id"));
				}
				if(isNotMapKeyNull(map, "driverinfo")){
					itemMap.put("HYS", map.get("driverinfo"));
				}
				if(isNotMapKeyNull(map, "wlfs")){
					itemMap.put("transport_AgentClerk_Reciever", map.get("wlfs"));
				}
				if(isNotMapKeyNull(map, "fhtime")){
					itemMap.put("discount_time_begin", map.get("fhtime"));
				}
				if(isNotMapKeyNull(map, "Kar_paizhao")){
					itemMap.put("Kar_paizhao", map.get("Kar_paizhao"));
				}
				if(isNotMapKeyNull(map, "fhdz")){
					itemMap.put("FHDZ", map.get("fhdz"));
				}
				itemMap.put("c_memo", map.get("c_memo"));
				itemMap.put("item_color", json.get("item_color"));
				itemMap.put("sd_oq", json.get("pronum"));
				itemMap.put("sd_unit_price", json.get("sd_unit_price"));
				itemMap.put("discount_rate", Double.valueOf(json.getString("discount_rate"))/100);
				itemMap.put("price_prefer", json.getString("discount_rate"));
				itemMap.put("sum_si", json.get("sum_si"));
				itemMap.put("shipped", "已发货");
				itemMap.put("Status_OutStore", "已结束");
				managerDao.insertSql(getInsertSql(itemtable, itemMap));
			}
			Map<String, Object> mainMap = new HashMap<String, Object>();
			if(isNotMapKeyNull(map, "settlement_type_id")){
				mainMap.put("settlement_type_id", map.get("settlement_type_id"));
			}
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("comfirm_flag", "N");
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("customer_id", map.get("customer_id"));
			mainMap.put("store_struct_id", json.get("store_struct_id"));
			mainMap.put("c_memo", map.get("c_memo"));
			mainMap.put("mainten_clerk_id", map.get("mainten_clerk_id"));
			mainMap.put("clerk_id", map.get("clerk_id"));
			mainMap.put("dept_id", map.get("dept_id"));
			mainMap.put("mainten_datetime", getNow());
			mainMap.put("so_consign_date", getNow());
			mainMap.put("at_term_datetime", getNow());
			mainMap.put("sd_order_direct", "发货");
			mainMap.put("ivt_oper_bill", "发货");
			if(isNotMapKeyNull(map, "driverinfo")){
				mainMap.put("HYS", map.get("driverinfo"));
			}
			if(isNotMapKeyNull(map, "wlfs")){
				mainMap.put("transport_AgentClerk_Reciever", map.get("wlfs"));
			}
			mainMap.put("finacial_y", c.get(Calendar.YEAR));
			mainMap.put("finacial_m", c.get(Calendar.MONTH));
			managerDao.insertSql(getInsertSql(maintable, mainMap));
		}
		return null;
	}

	@Override
	public String confirmOrder(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//更新库存
				Double pronum = Double.valueOf(json.getString("pronum"));//销售数量
				Double kcnum = Double.valueOf(json.getString("kcNum"));//库存数量
				if("退货".equals(map.get("status"))){
					thMap.put("accn_ivt", kcnum + pronum);
					thMap.put("use_oq", kcnum + pronum);
				}else{
					thMap.put("accn_ivt", kcnum - pronum);
					thMap.put("use_oq", kcnum - pronum);
				}
				thMap.put("finacial_datetime", getNow());
				thMap.put("maintenance_datetime", getNow());
				thMap.put("finacial_y", c.get(Calendar.YEAR));
				thMap.put("finacial_m", c.get(Calendar.MONTH));
				thMap.put("store_struct_id", json.get("store_struct_id"));
				thMap.put("item_id", json.get("item_id"));
				thMap.put("com_id", map.get("com_id"));
				managerDao.updateKcReturn(thMap);
			}
			//更新销售主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "Y");
			managerDao.updateComfirmFlag(thMap);
		}
		return null;
	}

	@Override
	public PageList<Map<String, Object>> getSalesReturnList(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getSalesReturnListCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		pageRecord=Integer.parseInt(map.get("rows")+"");
		
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getSalesReturnList(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public String saveSalesReturn(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="SDd02020";//主表
		String itemtable="SDd02021";//从表
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains = JSONArray.fromObject(mainjsons.get(i));
			String ivt_oper_listing = getOrderNo(customerDao, "销售退货", map.get("com_id").toString());
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//存入从表数据
				Map<String, Object> itemMap = new HashMap<String, Object>();
				itemMap.put("ivt_oper_listing", ivt_oper_listing);
				itemMap.put("sd_order_id", ivt_oper_listing);
				itemMap.put("st_hw_no", json.get("ivt_oper_listing"));
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("item_id", json.get("item_id"));
				itemMap.put("item_color", json.get("item_color"));
				itemMap.put("item_id", json.get("item_id"));
				itemMap.put("customer_id", json.get("customer_id"));
				itemMap.put("store_struct_id", json.get("store_struct_id"));
				itemMap.put("sd_oq", json.get("pronum"));
				itemMap.put("sd_unit_price", json.get("sd_unit_price"));
				itemMap.put("discount_rate", Double.valueOf(json.getString("discount_rate"))/100);
				itemMap.put("sum_si", json.get("sum_si"));
				itemMap.put("Status_OutStore", "已结束");
				managerDao.insertSql(getInsertSql(itemtable, itemMap));
				//更新销售订单
//				itemMap.clear();
//				Double pronum = Double.valueOf(json.getString("pronum"));//退货数量
//				Double useOq = Double.valueOf(json.getString("useOq"));//销售数量
//				itemMap.put("com_id", map.get("com_id"));
//				itemMap.put("item_id", json.get("item_id"));
//				itemMap.put("store_struct_id", json.get("store_struct_id"));
//				itemMap.put("ivt_oper_listing", json.get("ivt_oper_listing"));
//				itemMap.put("sd_oq", useOq - pronum);
//				managerDao.updateSalesOrder(itemMap);
			}
			//存入主表数据
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("comfirm_flag", "N");
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("customer_id", json.get("customer_id"));
			mainMap.put("store_struct_id", json.get("store_struct_id"));
			mainMap.put("c_memo", map.get("c_memo"));
			mainMap.put("mainten_clerk_id", map.get("clerk_id"));
			mainMap.put("clerk_id", map.get("clerk_id"));
			mainMap.put("dept_id", map.get("dept_id"));
			mainMap.put("mainten_datetime", getNow());
			mainMap.put("so_consign_date", getNow());
			mainMap.put("at_term_datetime", getNow());
			mainMap.put("sd_order_direct", "退货");
			mainMap.put("ivt_oper_bill", "退货"); 
			mainMap.put("finacial_y", c.get(Calendar.YEAR));
			mainMap.put("finacial_m", c.get(Calendar.MONTH));
			managerDao.insertSql(getInsertSql(maintable, mainMap));
		}
		return null;
	}

	@Override
	public String saveTransfersBills(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="IVTd01201";//主表
		String itemtable="IVTd01202";//从表
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			String ivt_oper_listing = getOrderNo(customerDao, "库存调拨", map.get("com_id").toString());
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//存入从表数据
				Map<String, Object> itemMap = new HashMap<String, Object>();
				itemMap.put("ivt_oper_listing", ivt_oper_listing);//调拨单号
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("store_struct_id", json.get("store_struct_id"));//当前仓库
				itemMap.put("corpstorestruct_id", json.get("in_store_struct_id"));//调入仓库
				itemMap.put("item_id", json.get("item_id"));
				itemMap.put("unit_id", json.get("unit_id"));//基本单位
				itemMap.put("oper_price", json.get("oper_price"));//单价
				itemMap.put("oper_qty", json.get("oper_qty"));//数量
				itemMap.put("plan_price", json.get("plan_price"));//金额
				managerDao.insertSql(getInsertSql(itemtable, itemMap));
			}
			//存入主表数据
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("comfirm_flag", "N");
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("store_struct_id", json.get("store_struct_id"));//当前仓库
			mainMap.put("in_store_struct_id", json.get("in_store_struct_id"));//调入仓库
			mainMap.put("corp_id", json.get("corp_id"));//供应商
			mainMap.put("i_factacceptsum", json.get("plan_price"));//金额
			mainMap.put("ivt_oper_id", "调拨");//标识
			mainMap.put("c_memo", map.get("c_memo"));//备注
			mainMap.put("clerk_id", map.get("clerk_id"));//经办人
			mainMap.put("dept_id", map.get("dept_id"));//经办部门
			mainMap.put("store_date", getNow());//调拨时间
			mainMap.put("finacial_datetime", getNow());
			mainMap.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			mainMap.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			managerDao.insertSql(getInsertSql(maintable, mainMap));
		}
		return null;
	}

	@Override
	public String confirmTransfers(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Integer kcnum = Integer.valueOf(json.getString("kcNum"));//库存数量
				Integer oper_qty = Integer.valueOf(json.getString("oper_qty"));//调拨数量
				//更新调出仓库产品库存
				thMap.put("accn_ivt", kcnum - oper_qty);
				thMap.put("use_oq", kcnum - oper_qty);
				thMap.put("store_struct_id", json.get("store_struct_id"));//调出仓库
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				managerDao.updateKcReturn(thMap);
				if(kcnum - oper_qty==0){
					//删除对应仓库产品数据
					managerDao.delKcItem(thMap);
				}
				//更新调入仓库产品库存
				//1.查询调入仓库该产品是否存在
				//2.存在就更新数量;不存在就新增
				thMap.put("in_store_struct_id", json.get("in_store_struct_id"));
				Integer useOq=employeeDao.selectItemByStore(thMap);
				if(useOq!=null){
					thMap.clear();
					thMap.put("accn_ivt", useOq+ oper_qty);
					thMap.put("use_oq",  useOq+ oper_qty);
					thMap.put("store_struct_id", json.get("in_store_struct_id"));//调入仓库
					thMap.put("com_id", map.get("com_id"));
					thMap.put("item_id", json.get("item_id"));
					managerDao.updateKcReturn(thMap);
				}else{
					thMap.clear();
					thMap.put("store_struct_id",json.get("in_store_struct_id"));
					thMap.put("finacial_datetime",getNow());
					thMap.put("item_id",json.get("item_id"));
					thMap.put("i_price",json.get("item_cost"));//单价
					thMap.put("accn_ivt",oper_qty);//该产品当前实际库存数
					thMap.put("use_oq",oper_qty);//该产品当前可用库存数
					thMap.put("customer_id",json.get("corp_id"));//供应商
					thMap.put("com_id",map.get("com_id"));
					thMap.put("ivt_oper_listing", json.get("ivt_oper_listing"));//调拨单号
					thMap.put("maintenance_datetime",getNow());
					thMap.put("finacial_y", c.get(Calendar.YEAR));
					thMap.put("finacial_m", c.get(Calendar.MONTH)+1);
					managerDao.insertSql(getInsertSql("IVTd01302", thMap));
				}
			}
			//更新调拨单主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "Y");
			managerDao.updateBsComfirmFlag(thMap);
		}
		return null;
	}

	@Override
	public String savebreInventory(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="IVTd01201";//主表
		String itemtable="IVTd01202";//从表
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			String ivt_oper_listing = getOrderNo(customerDao, "库存报损", map.get("com_id").toString());
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//存入从表数据
				Map<String, Object> itemMap = new HashMap<String, Object>();
				itemMap.put("ivt_oper_listing", ivt_oper_listing);//报损单号
				itemMap.put("com_id", getComId());//报损单号
				getJsonVal(itemMap, json, "store_struct_id", "store_struct_id");
				getJsonVal(itemMap, json, "corp_storeroom_id", "corp_id");
				getJsonVal(itemMap, json, "item_id", "item_id");
				getJsonVal(itemMap, json, "unit_id", "unit_id");
//				getJsonVal(itemMap, json, "c_memo", "c_memo");
				getJsonVal(itemMap, json, "oper_price", "oper_price");
				getJsonVal(itemMap, json, "oper_qty", "oper_qty");
				getJsonVal(itemMap, json, "plan_price", "plan_price");
				managerDao.insertSql(getInsertSql(itemtable, itemMap));
			}
			//存入主表数据
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("comfirm_flag", "N");
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("store_struct_id", json.get("store_struct_id"));//仓库
			mainMap.put("corp_id", json.get("corp_id"));//供应商
			mainMap.put("i_factacceptsum", json.get("plan_price"));//金额
			mainMap.put("ivt_oper_id", "报损");//标识
			mainMap.put("c_memo", map.get("c_memo"));//备注
			mainMap.put("clerk_id", map.get("clerk_id"));//经办人
			mainMap.put("dept_id", map.get("dept_id"));//经办部门
			mainMap.put("store_date", getNow());//报损时间
			mainMap.put("finacial_datetime", getNow());
			mainMap.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			mainMap.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			managerDao.insertSql(getInsertSql(maintable, mainMap));
		}
		return null;
	}

	@Override
	public String confirmBreInv(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Double kcnum = Double.valueOf(json.getString("kcNum"));//库存数量
				Double oper_qty = Double.valueOf(json.getString("oper_qty"));//报损数量
				//更新报损产品所在仓库库存
				thMap.put("accn_ivt", kcnum - oper_qty);
				thMap.put("use_oq", kcnum - oper_qty);
				thMap.put("store_struct_id", json.get("store_struct_id"));
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				managerDao.updateKcReturn(thMap);
			}
			//更新报损单主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "Y");
			managerDao.updateBsComfirmFlag(thMap);
			
		}
		return null;
	}

	@Override
	public String saveCheckInv(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="IVTd01201";//主表
		String itemtable="IVTd01202";//从表
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			String ivt_oper_listing = getOrderNo(customerDao, "库存盘点", map.get("com_id").toString());
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//存入从表数据
				Map<String, Object> itemMap = new HashMap<String, Object>();
				itemMap.put("ivt_oper_listing", ivt_oper_listing);//盘点单号
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("store_struct_id", json.get("store_struct_id"));//盘点仓库
				itemMap.put("item_id", json.get("item_id"));
				itemMap.put("unit_id", json.get("unit_id"));//基本单位
				itemMap.put("oper_price", json.get("oper_price"));//盘点单价
				itemMap.put("oper_qty", json.get("oper_qty"));//盘点数量
				itemMap.put("base_oq", json.get("kcNum"));//库存数量
				itemMap.put("plan_price", json.get("plan_price"));//盈亏金额
				managerDao.insertSql(getInsertSql(itemtable, itemMap));
				json.put("com_id", map.get("com_id"));
				productDao.updateProductGys(json);
			}
			//存入主表数据
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("ivt_oper_listing", ivt_oper_listing);
			mainMap.put("sd_order_id", ivt_oper_listing);
			mainMap.put("comfirm_flag", "N");
			mainMap.put("com_id", map.get("com_id"));
			mainMap.put("store_struct_id", json.get("store_struct_id"));//盘点仓库
			mainMap.put("corp_id", json.get("corp_id"));//供应商
			mainMap.put("i_factacceptsum", json.get("plan_price"));//盈亏金额
			mainMap.put("ivt_oper_id", "盘点");//标识
			mainMap.put("c_memo", map.get("c_memo"));//备注
			mainMap.put("clerk_id", map.get("clerk_id"));//经办人
			mainMap.put("dept_id", map.get("dept_id"));//经办部门
			mainMap.put("store_date", getNow());//盘点时间
			mainMap.put("finacial_datetime", getNow());
			mainMap.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			mainMap.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			managerDao.insertSql(getInsertSql(maintable, mainMap));
		}
		return null;
	}

	@Override
	public String confirmCheckInv(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Double oper_qty = Double.valueOf(json.getString("oper_qty"));//盘点数量
				//更新盘点产品所在仓库库存
				thMap.put("accn_ivt", oper_qty);
				thMap.put("use_oq", oper_qty);
				thMap.put("store_struct_id", json.get("store_struct_id"));
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				managerDao.updateKcReturn(thMap);
			}
			//更新盘点单主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "Y");
			managerDao.updateBsComfirmFlag(thMap);
			
		}
		return null;
	}

	@Override
	public PageList<Map<String, Object>> getBreInventory(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getBreInventoryCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getBreInventory(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> getTransfersBills(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getTransfersBillsCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getTransfersBills(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public PageList<Map<String, Object>> getCheckInv(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getCheckInvCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getCheckInv(map);
		pages.setRows(list);
		return pages;
	}

	@Override
	public String delInventoryRel(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="IVTd01201";//主表
		String itemtable="IVTd01202";//从表
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains=JSONArray.fromObject(mainjsons.get(i));
			for(int j=0;j<jsonmains.size();j++){
				JSONObject json=jsonmains.getJSONObject(j);
				Map<String,Object> itemMap=new HashMap<String,Object>();
				itemMap.put("table", itemtable);
				itemMap.put("ivt_oper_listing", json.getString("ivt_oper_listing"));
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("item_id", json.getString("item_id"));
				managerDao.delPurchasingCheck(itemMap);
				//根据ivt_oper_listing判断从表是否还有相同的入库单号
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", itemtable);
				mapquery.put("com_id",map.get("com_id"));
				mapquery.put("showFiledName", "ivt_oper_listing");
				mapquery.put("findFiled","ivt_oper_listing='"+json.getString("ivt_oper_listing")+"' ");
				Object obj = productDao.getOneFiledNameByID(mapquery);
				if(obj==null){
					//没有则根据ivt_oper_listing删除主表对应数据行
					Map<String,Object> mainMap=new HashMap<String,Object>();
					mainMap.put("table", maintable);
					mainMap.put("ivt_oper_listing", json.getString("ivt_oper_listing"));
					mainMap.put("com_id", map.get("com_id"));
					mainMap.put("item_id", null);
					managerDao.delPurchasingCheck(mainMap);
				}
			}
		}
		return null;
	}
	@Override
	public String delSalesOrder(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		String maintable="SDd02020";//主表
		String itemtable="SDd02021";//从表
		for(int i=0;i<mainjsons.size();i++){
			JSONArray jsonmains=JSONArray.fromObject(mainjsons.get(i));
			for(int j=0;j<jsonmains.size();j++){
				JSONObject json=jsonmains.getJSONObject(j);
				Map<String,Object> itemMap=new HashMap<String,Object>();
//				if("xsth".equals(map.get("client"))){
//					//更新销售订单
//					itemMap.put("com_id", map.get("com_id"));
//					itemMap.put("item_id", json.get("item_id"));
//					itemMap.put("ivt_oper_listing", json.get("st_hw_no"));
//					itemMap.put("store_struct_id", json.get("store_struct_id"));
//					Double useOq = managerDao.selSalesNum(itemMap);//获取销售数量
//					
//					Double pronum = Double.valueOf(json.getString("pronum"));//退货数量
//					itemMap.put("sd_oq", useOq + pronum);
//					managerDao.updateSalesOrder(itemMap);
//					itemMap.clear();
//				}
				itemMap.put("table", itemtable);
				itemMap.put("ivt_oper_listing", json.getString("ivt_oper_listing"));
				itemMap.put("com_id", map.get("com_id"));
				itemMap.put("item_id", json.getString("item_id"));
				managerDao.delPurchasingCheck(itemMap);
				//根据ivt_oper_listing判断从表是否还有相同的入库单号
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", itemtable);
				mapquery.put("com_id",map.get("com_id"));
				mapquery.put("showFiledName", "ivt_oper_listing");
				mapquery.put("findFiled","ivt_oper_listing='"+json.getString("ivt_oper_listing")+"' ");
				Object obj = productDao.getOneFiledNameByID(mapquery);
				if(obj==null){
					//没有则根据ivt_oper_listing删除主表对应数据行
					Map<String,Object> mainMap=new HashMap<String,Object>();
					mainMap.put("table", maintable);
					mainMap.put("ivt_oper_listing", json.getString("ivt_oper_listing"));
					mainMap.put("com_id", map.get("com_id"));
					mainMap.put("item_id", null);
					managerDao.delPurchasingCheck(mainMap);
				}
			}
		}
		return null;
	}

	@Override
	public String returnConfirm(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		Calendar c=Calendar.getInstance();
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				//更新库存
				if (json.has("pronum")&&"pronum".equals(json.getString("pronum").trim())) {
				}else{
					json.put("pronum",1);
				}
				if (json.has("kcNum")&&"kcNum".equals(json.getString("kcNum").trim())) {
				}else{
					json.put("kcNum",0);
				}
				Double pronum = Double.valueOf(json.getString("pronum"));//销售数量
				Double kcnum = Double.valueOf(json.getString("kcNum"));//库存数量
				if("退货".equals(map.get("status"))){
					thMap.put("accn_ivt", kcnum - pronum);
					thMap.put("use_oq", kcnum - pronum);
				}else{
					thMap.put("accn_ivt", kcnum + pronum);
					thMap.put("use_oq", kcnum + pronum);
				}
				thMap.put("finacial_datetime", getNow());
				thMap.put("maintenance_datetime", getNow());
				thMap.put("finacial_y", c.get(Calendar.YEAR));
				thMap.put("finacial_m", c.get(Calendar.MONTH));
				thMap.put("store_struct_id", json.get("store_struct_id"));
				thMap.put("item_id", json.get("item_id"));
				thMap.put("com_id", map.get("com_id"));
				managerDao.updateKcReturn(thMap);
			}
			//更新销售主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "N");
			managerDao.updateComfirmFlag(thMap);
		}
		return null;
	}

	@Override
	public String returnTransfers(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Integer kcnum = Integer.valueOf(json.getString("kcNum"));//库存数量
				Integer oper_qty = Integer.valueOf(json.getString("oper_qty"));//调拨数量
				//更新调出仓库产品库存
				thMap.put("accn_ivt", kcnum + oper_qty);
				thMap.put("use_oq", kcnum + oper_qty);
				thMap.put("store_struct_id", json.get("store_struct_id"));//调出仓库
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				managerDao.updateKcReturn(thMap);
				//回退产品调入仓库的库存
				thMap.clear();
				thMap.put("in_store_struct_id", json.get("in_store_struct_id"));//调出仓库
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				Integer useOq=employeeDao.selectItemByStore(thMap);
				thMap.put("accn_ivt", useOq - oper_qty);
				thMap.put("use_oq", useOq - oper_qty);
				managerDao.updateKcReturn(thMap);
				if(useOq - oper_qty==0){
					thMap.put("store_struct_id", json.get("in_store_struct_id"));
					managerDao.delKcItem(thMap);
				}
			}
			//更新调拨单主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "N");
			managerDao.updateBsComfirmFlag(thMap);
		}
		return null;
	}

	@Override
	public String returnCheckInv(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Double oper_qty = Double.valueOf(json.getString("oper_qty"));//盘前数量
				//更新盘点产品所在仓库库存
				thMap.put("accn_ivt", oper_qty);
				thMap.put("use_oq", oper_qty);
				thMap.put("store_struct_id", json.get("store_struct_id"));
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				managerDao.updateKcReturn(thMap);
			}
			//更新盘点单主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "N");
			managerDao.updateBsComfirmFlag(thMap);
			
		}
		return null;
	}

	@Override
	public String returnBreInv(Map<String, Object> map) {
		JSONArray mainjsons=JSONArray.fromObject(map.get("item_ids"));
		for (int i = 0; i < mainjsons.size(); i++) {
			JSONArray jsonmains =JSONArray.fromObject(mainjsons.get(i));
			Map<String, Object> thMap = new HashMap<String, Object>();
			JSONObject json=null;
			for (int j = 0; j < jsonmains.size(); j++) {
				json = jsonmains.getJSONObject(j);
				Double kcnum = Double.valueOf(json.getString("kcNum"));//库存数量
				Double oper_qty = Double.valueOf(json.getString("oper_qty"));//报损数量
				//更新报损产品所在仓库库存
				thMap.put("accn_ivt", kcnum + oper_qty);
				thMap.put("use_oq", kcnum + oper_qty);
				thMap.put("store_struct_id", json.get("store_struct_id"));
				thMap.put("com_id", map.get("com_id"));
				thMap.put("item_id", json.get("item_id"));
				managerDao.updateKcReturn(thMap);
			}
			//更新报损单主表审核状态
			thMap.clear();
			thMap.put("com_id", map.get("com_id"));
			thMap.put("ivt_oper_listing", json.getString("ivt_oper_listing").trim());
			thMap.put("comfirm_flag", "N");
			managerDao.updateBsComfirmFlag(thMap);
			
		}
		return null;
	}
	@Override
	public List<Map<String, String>> getPersonnelNeiQing(
			Map<String, Object> mapparams) {
		return employeeDao.getPersonnelNeiQing(mapparams);
	}

	@Override
	@Transactional
	public String confirmAllAdded(Map<String, Object> map)throws Exception{
		map.put("sSql", "update sdd02011 set m_flag=#{m_flag} "
				+ "where ltrim(rtrim(isnull(com_id,'')))=#{com_id} "
				+ "and ltrim(rtrim(isnull(customer_id,'')))=#{customer_id} and ltrim(rtrim(isnull(m_flag,'')))!=#{m_flag}");
		 productDao.insertSqlByPre(map);
		return null;
	}
	
	@Override
	public String noticeComfirm(Map<String, Object> map) {
		Integer c=employeeDao.getAddedFlagCount(map);
		if(c==null||c==0){
			return "没有待审核的报价单!";
		}
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("title"));
		String description=MapUtils.getString(map, "description");
		description=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", map.get("headship")+"");
		mapMsg.put("description",description);
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/add.do?customer_id="+map.get("customer_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		Map<String,Object> mapparams=new HashMap<String, Object>();
		mapparams.put("com_id", getComId());
		mapparams.put("headship", "%"+map.get("headship")+"%");
		mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
		for (int i = 0; i < touserList.size(); i++) {
			Map<String, String> item=touserList.get(i);
			String newdes=description.replaceAll("@clerkName", item.get("clerk_name"));
			news.get(0).put("description",newdes);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
			}
			news.get(0).put("description",description);
		}
		return null;
	}
	@Override
	public String noticeAddedConfirmed(Map<String, Object> map) {
		Integer c=employeeDao.getAddedFlagCount(map);
		if(c==null||c==0){
			return "没有已经审核的报价单!";
		}
		Map<String,String> mapinfo=employeeDao.getEmployeeByCustomerId(map);
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title",map.get("title"));
		String description=MapUtils.getString(map, "description");
		description=description.replaceAll("@comName", getComName()).replaceAll("@clerkName",mapinfo.get("clerk_name"));
		mapMsg.put("description",description);
		mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/add.do?customer_id="+map.get("customer_id"));
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("sendRen", getEmployeeId(getRequest()));
		news.add(mapMsg);
		sendMessageNews(news,getComId(),mapinfo.get("weixinID"),"员工");
		
		return null;
	}
}
