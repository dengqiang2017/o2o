package com.qianying.service.impl;

import java.io.File;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.qianying.controller.FilePathController;
import com.qianying.dao.interfaces.ICustomerDAO;
import com.qianying.dao.interfaces.IEmployeeDAO;
import com.qianying.dao.interfaces.IManagerDAO;
import com.qianying.dao.interfaces.IOrderTrackingDAO;
import com.qianying.dao.interfaces.IProductDAO;
import com.qianying.dao.interfaces.ISaiYuDao;
import com.qianying.dao.interfaces.ISystemParamsDAO;
import com.qianying.dao.interfaces.IUserDao;
import com.qianying.page.ObjectQuery;
import com.qianying.page.PageList;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;
import com.qianying.util.SendSmsUtil;
import com.qianying.util.WeiXinServiceUtil;

public abstract class BaseServiceImpl extends FilePathController{
	
	public static final BigDecimal zeroBig=new BigDecimal(0);
	
	@Autowired
	protected IEmployeeDAO employeeDao;
	
	@Autowired
	ISystemParamsDAO systemParamsDao;
	
	@Autowired
	protected IProductDAO productDao;
	
	@Autowired
	protected ICustomerDAO customerDao;
	
	@Autowired
	IManagerDAO managerDao;
	@Autowired
	IUserDao userDao;
	@Autowired
	ISaiYuDao saiYuDao;
	@Resource
	IOrderTrackingDAO orderTrackingDao;
	/**
	 * 获取插入sql语句
	 * 
	 * @param table
	 *            插入语句的头及insert into 表名
	 * @param map
	 *            要插入的数据和字段
	 * @return 插入语句
	 */
	public String getInsertSql(String table, Map<String, Object> map) {
		StringBuffer buffer = new StringBuffer("insert into ").append(table).append("(");
		StringBuffer key = new StringBuffer();
		StringBuffer val = new StringBuffer();
		Object[] objs = map.keySet().toArray();
		Collection<Object> c = map.values();
		Object[] vals = c.toArray();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
				Locale.CHINA);
		for (int i = 0; i < vals.length; i++) {
			if (vals[i] != null &&!"".equals(vals[i])) {
				if ("smsMsg".equals(objs[i])) {//短信信息
					continue;
				}else if ("newsUrl".equals(objs[i])) {//图文消息 的url链接
					continue;
				}else{
					key.append(objs[i]).append(",");
					if (vals[i] instanceof Date) {
						val.append("'").append(format.format((Date) vals[i]))
						.append("',");
					} else {
						if (vals[i]!=null) {
							vals[i]=vals[i].toString().trim();
						}
						val.append("'").append(vals[i]).append("',");
					}
				}
			}
		}
		key=key.delete(key.length() - 1, key.length());
		val.delete(val.length() - 1, val.length());
		buffer.append(key);
		buffer.append(")values(");
		buffer.append(val);
		buffer.append(")");
		LoggerUtils.info(buffer.toString());
		return buffer.toString();
	}
	/**
	 * 根据参数生成预处理插入sql语句
	 * @param table 表名
	 * @param map 需要生成的字段和传入字段变量名称
	 * @return
	 */
	public String getInsertSqlByPre(String table, Map<String, Object> map) {
		map.remove("excelIndex");
		StringBuffer buffer = new StringBuffer("insert into ").append(table).append("(");
		StringBuffer key = new StringBuffer();
		StringBuffer val = new StringBuffer();
		Object[] objs = map.keySet().toArray();
		Collection<Object> c = map.values();
		Object[] vals = c.toArray();
		for (int i = 0; i < vals.length; i++) {
			if (map.get(objs[i]) != null && map.get(objs[i]) != "") {
				if ("smsMsg".equals(objs[i])) {//短信信息
					continue;
				}else if ("newsUrl".equals(objs[i])) {//图文消息 的url链接
					continue;
				}else{
					key.append(objs[i]).append(",");
					val.append("#{").append(objs[i]).append("},");
				}
			}
		}
		key=key.delete(key.length() - 1, key.length());
		val.delete(val.length() - 1, val.length());
		buffer.append(key);
		buffer.append(")values(");
		buffer.append(val);
		buffer.append(")"); 
		return buffer.toString();
	}
	
	/**
	 * 获取更新sql语句
	 * @param map 查询的数据
	 * @param table 更新的表名及update SDf00504 set
	 * @param findName 查询的字段名
	 * @param updateNull 是否更新空数据的字段值为空true-更新为空的字段,false不更新为空的字段
	 * @return 更新语句
	 */
	public String getUpdateSql(Map<String, Object> map,String table,String findName,String id,boolean updateNull) {
		StringBuffer buffer=new StringBuffer("update ").append(table).append(" set ");
		StringBuffer key=new StringBuffer();
		 Object[] keys =  map.keySet().toArray();
		  Collection<Object> c = map.values();
		  Object[] vals=c.toArray();
		  String user_id=null;
		  SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.CHINA);
		  for (int i = 0; i < vals.length; i++) {
			  if (vals[i]!=null) {
					vals[i]=vals[i].toString().trim();
				}
			  if ("smsMsg".equals(keys[i])) {//短信信息
				  continue;
			  }else if ("newsUrl".equals(keys[i])) {//图文消息 的url链接
				continue;
			  }
			  updateNull=true;
			  if (updateNull) {
				  if (findName.equals(keys[i])) {
					  if (vals[i]!=null) {
						  user_id=vals[i].toString();
					}else{
						user_id="";
					}
				  }
				  if(!"id".equals(keys[i])){
					if (vals[i] instanceof Date) {
						key.append(keys[i]).append("='").append(format.format((Date)vals[i])).append("',");
					}else{
						if (vals[i]==null||vals[i]=="") {
							key.append(keys[i]).append("=null").append(",");
						}else{
							key.append(keys[i]).append("='").append(vals[i]).append("',");
						}
					}
				}
			  }else{
				  if (vals[i]!=null&&vals[i]!="") {
					  if (findName.equals(keys[i])) {
						  user_id=vals[i].toString();
					  }
					  if(!"id".equals(keys[i])){
					  if (vals[i] instanceof Date) {
						  key.append(keys[i]).append("='").append(format.format((Date)vals[i])).append("',");
					  }else{
						  key.append(keys[i]).append("='").append(vals[i]).append("',");
					  }
					  }
				  }
			  }
		  }
		  key.delete(key.length()-1, key.length());
		  buffer.append(key);
		  if (StringUtils.isNotBlank(id)) {
			 user_id=id;
		  }
	      if (StringUtils.isNotBlank(findName)) {
	    	  buffer.append(" where ");
	    	  if(!"ctl00501".equalsIgnoreCase(table)){
	    		  buffer.append("com_id='").append(getComId()).append("'  and ");
	    	  }
	    	  buffer.append(findName).append(" ='").append(user_id).append("'");
		   }
		  LoggerUtils.info(buffer.toString());
		  return buffer.toString();
	}
	public String getUpdateSql(Map<String, Object> map,String table,String findName,String id) {
		StringBuffer buffer=new StringBuffer("update ").append(table).append(" set ");
		StringBuffer key=new StringBuffer();
		 Object[] keys =  map.keySet().toArray();
		  Collection<Object> c = map.values();
		  Object[] vals=c.toArray();
		  String user_id=null;
		  SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.CHINA);
		  for (int i = 0; i < vals.length; i++) {
			  if (vals[i]!=null) {
					vals[i]=vals[i].toString().trim();
				}
			  if ("smsMsg".equals(keys[i])) {//短信信息
				  continue;
			  }else if ("newsUrl".equals(keys[i])) {//图文消息 的url链接
				continue;
			  }
				  if (vals[i]!=null&&vals[i]!="") {
					  if (findName.equals(keys[i])) {
						  user_id=vals[i].toString();
					  }
					  if(!"id".equals(keys[i])){
					  if (vals[i] instanceof Date) {
						  key.append(keys[i]).append("='").append(format.format((Date)vals[i])).append("',");
					  }else{
						  key.append(keys[i]).append("='").append(vals[i]).append("',");
					  }
					  }
				  }
			  }
		  key.delete(key.length()-1, key.length());
		  buffer.append(key);
		  if (StringUtils.isNotBlank(id)) {
			 user_id=id;
		  }
		  buffer.append(" where ltrim(rtrim(isnull(com_id,'')))='").append(getComId()).append("'");
	      if (StringUtils.isNotBlank(findName)) {
			buffer.append(" and ltrim(rtrim(isnull(").append(findName).append(",''))) ='").append(user_id).append("'");
		   }
		  LoggerUtils.info(buffer.toString());
		  return buffer.toString();
	}
	/**
	 * 获取分页列表
	 * @param rows 列表数据集合
	 * @param query 查询条件
	 * @param count 总数
	 * @return 分页对象
	 */
	public PageList<Map<String,Object>> getPageList(ObjectQuery query,int count){
		PageList<Map<String, Object>> pages=new PageList<Map<String,Object>>(query.getPage(),query.getRows(),count);
		if (query.getPage()>0) {
			query.setPage(query.getPage()*query.getRows());
		}else{
			query.setPage(query.getPage()*query.getRows()+1);
		}
		return pages;
	}
	/**
	 * 获取分页列表
	 * @param rows 列表数据集合
	 * @param query 查询条件
	 * @param count 总数
	 * @return 分页对象
	 */
	public PageList<Map<String,Object>> getPageListToAdd(ObjectQuery query,int count){
		PageList<Map<String, Object>> pages=new PageList<Map<String,Object>>(query.getPage(),query.getRows(),count);
		if (query.getPage()==0) {
			query.setPage(query.getPage()*query.getRows()+1);
		}else{
			query.setPage(query.getPage()*query.getRows());
		}
		return pages;
	}
	/**
	 * 
	 * @param orderName
	 * @return
	 */
	public String getOrderNo(ICustomerDAO customerDao,String orderName,String comId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cmd_id", "001");
		map.put("xskd", orderName);
		map.put("mac", "");
		return customerDao.getOrderNo(map);
	}
//	/**
//	 * 获取当前时间
//	 * @return
//	 */
//	public String getNow() {
//		SimpleDateFormat format=new SimpleDateFormat(ConfigFile.DATETIME_FORMAT,Locale.CHINA);
//		return format.format(new Date());
//	}
//	/**
//	 * 获取运营商编码
//	 * @param request
//	 * @return 运营商编码
//	 */
//	public String getComId(HttpServletRequest request) {
//		return request.getSession().getAttribute(ConfigFile.OPERATORS_NAME).toString();
//	}
//	/**
//	 * 获取客户内编码
//	 * @param request
//	 * @return
//	 */
//	@SuppressWarnings("unchecked")
//	public String getCustomerId(HttpServletRequest request){
//		Map<String,Object> map= (Map<String, Object>) request.getSession().getAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
//		if (map!=null) {
//			return map.get("customer_id").toString();
//		}
//		return null;
//	}
	
//	/**
//	 * 获取绝对路径
//	 * 
//	 * @param request
//	 * @param url
//	 * @return
//	 */
//	public static String getRealPath(HttpServletRequest request, String url) {
//		if (StringUtils.isBlank(url)) {
//			url = ConfigFile.ROOT;
//		}
//		return request.getSession().getServletContext().getRealPath(url)+"/";
//	}
	
	
//	/**
//	 * 发送OA协同微信信息
//	 * @param clerk_id
//	 * @param com_id
//	 * @param OAName
//	 * @param employeeDao
//	 */
//	public void sendOAMessage(Object clerk_id,String OAName,String msgtxt) {
//		if (clerk_id!=null) {
//			Map<String,String> mapemployee= employeeDao.getPersonnelWeixinID(clerk_id.toString(), getComId());
//			if (mapemployee!=null) {
//				String msg=mapemployee.get("clerk_name")+",您有一条["+OAName+"]需要进行协同"+msgtxt;
//				sendMessage(msg, mapemployee.get("weixinID"));
//			}
//		}
//	}
	/**
	 * 发送OA协同微信信息
	 * @param clerk_id
	 * @param com_id
	 * @param OA_what
	 * @param content
	 */
	public void sendOAMessageNews(Object clerk_id,Object OA_what,Object content) {
		if (clerk_id!=null) {
			Map<String,String> mapemployee= employeeDao.getPersonnelWeixinID(clerk_id.toString(), getComId());
			if (mapemployee!=null) {
				String msg=mapemployee.get("clerk_name")+",您有一条协同申请需要处理,申请内容："+content;
				List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> map=new HashMap<String, Object>();
				map.put("title","【"+ OA_what+"】协同申请处理");
				map.put("description", msg);
				map.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/myOA.do");
				map.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
				if(getCustomer(getRequest())!=null){
					map.put("sendRen", getCustomerId(getRequest()));
				}else if(getEmployee(getRequest())!=null){
					map.put("sendRen", getEmployeeId(getRequest()));
				}
				news.add(map);
				sendMessageNews(news,getComId(), mapemployee.get("weixinID"),"员工");
			}
		}
	}
	
	/**
	 * 获取流程信息根据流程名称
	 * @param item_name 流程名称
	 * @param order 排序asc 或者 desc
	 * @param productDao
	 * @return 流程信息
	 * @throws Exception
	 */
	public Map<String,Object> getProcessInfoByName(String item_name,String order, IProductDAO productDao){
		Map<String,Object> mapone=new HashMap<String, Object>();
		mapone.put("com_id", getComId());
		mapone.put("order", order);
		mapone.put("item_name", item_name);
		Map<String,Object> process= productDao.getProcessInfoByName(mapone);
		if (process==null) {
			throw new RuntimeException("error101");
		}
		return process;
	}
	
	protected Object setClerk_idAccountApprover(Object clerk_id,Map<String,Object> map) {
		//2.获取流程中对应的员工信息
		Map<String,Object> cus= employeeDao.getPersonnel(clerk_id+"", getComId());
		Object clerk_idAccountApprover=map.get("clerk_idAccountApprover");
		//3.对比是否是客户审批员
		if (!"客户审批员".equals(cus.get("clerk_name"))) {
			//4.如果不是就设置为流程中的定义的员工
			clerk_idAccountApprover=clerk_id;
		}
		return clerk_idAccountApprover;
	}
	/**
	 * 向出纳发送核款消息
	 * @param name 运营商名称
	 * @param corpName
	 * @param params 微信图文链接地址collectionConfirm.do后面跟的参数
	 */
	public void sendMessageOAARD02051(Object name,String description,String params,Object com_id) {
		try {
			 Map<String,Object> mapper=new HashMap<String, Object>();
				 if (com_id!=null) {
					 mapper.put("com_id", com_id);
				}else{
					mapper.put("com_id", getComId());
				}
				if (ConfigFile.NoticeStyle.contains("0")) {
					String url="";
					if (StringUtils.isNotBlank(params)) {
						url="/employee/collectionConfirm.do?"+params;
					}
//					sendMessageNewsNeiQingUrl(name+",客户收款确认", msg, "出纳",url);
					String title="客户收款确认";
					String headship="出纳";
					String imgName="/weixinimg/kuan.png";
					sendMessageNewsEmployee(title, description, headship, imgName, url,com_id);
					
				}
//				if (ConfigFile.NoticeStyle.contains("1")) {
//					for (Map<String,String> movtel : touserList) {
//						if (StringUtils.isNotBlank(movtel.get("movtel"))) {
//							SendSmsUtil.sendSms2(movtel.get("movtel"), null, description);
//						}
//					}
//				}
		} catch (Exception e) {
//			writeLog(getRequest(), "发送微信出错", e.getMessage());
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
	/**
	 *  向出纳发送核款消息
	 * @param name
	 * @param buffer
	 * @param params
	 * @param com_id 
	 */
	public void sendMessageOAARD02051(StringBuffer buffer,String params, Object com_id) {
		sendMessageOAARD02051("", buffer.toString(), params,com_id);
	}
	/**
	 * 根据员工的职位获取员工微信号
	 * @param headship 职务
	 * @return weixinID账号
	 */
//	public String getPersonnelWeixinIDByHeadship(String headship) {
//		Map<String,Object> map=new HashMap<String, Object>();
//		map.put("com_id", getComId());
//		map.put("headship", "%"+headship+"%");
//		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(map);
//		StringBuffer touser=new StringBuffer();
//		for (int i = 0; i < touserList.size(); i++) {
//			String item=touserList.get(i);
//			if (i==(touserList.size()-1)) {
//				touser.append(item);
//			}else{
//				touser.append(item).append("|");
//			}
//		}
//		return touser.toString();
//	}
	
//	/**
//	 * 获取客户的微信消息
//	 * @param upper_customer_id 所属上级客户编码
//	 * @param headship 职务
//	 * @return weixinID账号
//	 */
//	public String getCustomerWeixinIDByHeadship(Object upper_customer_id,String headship) {
//		Map<String,Object> params=new HashMap<String, Object>();
//		params.put("headship","%"+headship+"%");
//		params.put("com_id", getComId());
//		params.put("upper_customer_id",upper_customer_id);
//		List<Map<String,String>> cuslist=customerDao.getCustomerWeixinByHeadship(params);
//		if (cuslist!=null&&cuslist.size()>0) {
//			StringBuffer weixinID=new StringBuffer();
//			for (int i = 0; i < cuslist.size(); i++) {
//				Map<String,String> item=cuslist.get(i);
//				if (i==(cuslist.size()-1)) {
//					weixinID.append(item.get("weixinID"));
//				}else{
//					weixinID.append(item.get("weixinID")).append("|");
//				}
//			}
//			return weixinID.toString();
//		}
//		return "";
//	}
	/**
	 * 获取客户的微信消息
	 * @param upper_customer_id 所属上级客户编码
	 * @param headship 职务
	 * @param processName 
	 * @return weixinID账号
	 */
	public List<String> getCustomerPhoneByHeadship(Object upper_customer_id,String headship, String processName) {
		Map<String,Object> params=new HashMap<String, Object>();
		params.put("headship","%"+headship+"%");
		params.put("processName","%"+processName+"%");
		params.put("com_id", getComId());
		params.put("upper_customer_id",upper_customer_id);
		params.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String,String>> cuslist=customerDao.getCustomerWeixinByHeadship(params);
		if (cuslist!=null&&cuslist.size()>0) {
			List<String> user_id=new ArrayList<String>();
			for (int i = 0; i < cuslist.size(); i++) {
				Map<String,String> item=cuslist.get(i);
				user_id.add(item.get("phone"));
			}
			return user_id;
		}
		return null;
	}
	/**
	 * 向所有内勤发送订单需要处理的微信
	 * @param Status_OutStore 订单跟踪流程名称
	 * @param buffer 订单号存放
	 * @param headship 发送的职务
	 * @param imgName 微信消息图片名称
	 */
	public void sendMessageNewsNeiQing(Object Status_OutStore,String buffer,String headship, String imgName) {
		sendMessageNewsNeiQingHead("", Status_OutStore, buffer, headship,null,imgName);
	}
	/**
	 * 向所有内勤发送订单需要处理的微信
	 * @param processName 订单跟踪流程名称
	 * @param description 订单号存放
	 * @param com_id 
	 * @param imgName 
	 */
	public void sendMessageNewsNeiQingHead(Object name,Object processName,String description,String headship, Object com_id, String imgName) {
		try {
			///获取职位是内勤的所有人员
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", processName+"协同处理");
//			mapMsg.put("description",name+":您有"+processName+"协同处理,"+buffer);
			mapMsg.put("description",description);
			mapMsg.put("addName","description");
			Integer begin=description.indexOf("[");
			String clientName="";
			if (begin>0) {
				Integer end=description.indexOf("]");
				clientName="|"+utf8to16(description.substring(begin+1, end));
			}
			if(StringUtils.isBlank(imgName)){
				imgName="msg.png";
			}
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?processName="+utf8to16(processName+"")+clientName);
			mapMsg.put("picurl", ConfigFile.urlPrefix+imgName);
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			sendemployeemsg(headship, news,com_id,processName.toString().substring(1, processName.toString().length()));
		} catch (Exception e) {
//			writeLog(getRequest(), "订单跟踪发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 向所有内勤发送订单需要处理的微信
	 * @param processName 订单跟踪流程名称
	 * @param param 订单号存放
	 */
	public void sendMessageNewsByHeadship(Object processName,String param,String headship,String buffer) {
		try {
			///获取职位是内勤的所有人员
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("com_id", getComId());
			map.put("headship", "%"+headship+"%");
			map.put("omrtype",getSystemParam("ordersMessageReceivedType"));
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(map);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", "您有"+processName+"需要处理");
			if (StringUtils.isNotBlank(buffer)) {
				mapMsg.put("description",buffer);
			}else{
				mapMsg.put("description","您有"+processName+"需要进行处理!");
			}
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?seeds_ids="+param+"|processName="+utf8to16(processName+""));
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			for (int i = 0; i < touserList.size(); i++) {
				Map<String,String> item=touserList.get(i);
				String add="员工:"+item.get("clerk_name");
				String msg=add+news.get(0).get("description");
				news.get(0).put("description",msg);
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
				}
				news.get(0).put("description",msg.replaceAll(add, ""));
			}
		} catch (Exception e) {
//			writeLog(getRequest(), "订单跟踪发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 发送物流分解打包消息
	 * @param buffer 需要打包的产品消息
	 * @param sms 
	 * @param weixin 
	 * @param seeds 
	 * @param imgName 
	 */
	public void sendMessageNewsWuliu(String buffer, boolean weixin, boolean sms, String[] seeds, String imgName) {
		try {
			String path=getWuliuInfoPath();
			saveFile(path, buffer);	
			if(weixin){
				///获取职位是内勤的所有人员
				Map<String,Object> map=new HashMap<String, Object>();
				map.put("com_id", getComId());
				map.put("headship", "%物流%");
				map.put("omrtype",getSystemParam("ordersMessageReceivedType"));
				List<Map<String,String>> touserList=employeeDao.getPersonnelNeiQing(map);
				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
				Map<String,Object> mapMsg=new HashMap<String, Object>();
				mapMsg.put("title", "您有[产品分解打包]需要处理");
				mapMsg.put("description",buffer);
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url=/saiyu/decompose.do?seeds_ids="+Arrays.toString(seeds));
				mapMsg.put("picurl", ConfigFile.urlPrefix+imgName);
				if(getCustomer(getRequest())!=null){
					mapMsg.put("sendRen", getCustomerId(getRequest()));
				}else if(getEmployee(getRequest())!=null){
					mapMsg.put("sendRen", getEmployeeId(getRequest()));
				}
				news.add(mapMsg);
				for (int i = 0; i < touserList.size(); i++) {
					Map<String,String> item=touserList.get(i);
					String add="物流打包员："+item.get("clerk_name");
					String msg=add+news.get(0).get("title");
					news.get(0).put("title",msg);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
					}
					news.get(0).put("title",msg.replaceAll(add, ""));
				}
			}
			if(sms){
				Map<String,Object> map=new HashMap<String, Object>();
				map.put("com_id", getComId());
				map.put("movtel","movtel");
				map.put("headship", "%物流%");
				map.put("omrtype",getSystemParam("ordersMessageReceivedType"));
				List<Map<String,String>> touserList=employeeDao.getPersonnelNeiQing(map);
				for (Map<String,String> movtel : touserList) {
					if (StringUtils.isNotBlank(movtel.get("movtel"))) {
						Map<String,Object> mapsms=getSystemParamsByComId();
						SendSmsUtil.sendSms2(movtel.get("movtel"), null,"物流打包员："+movtel.get("clerk_name")+buffer,mapsms);
					}
				}
			}
		} catch (Exception e) {
//			writeLog(getRequest(), "订单跟踪发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
	/**
	 * 获取系统参数
	 * @return
	 */
	public Map<String,Object> getSystemParamsByComId() {
		List<Map<String,Object>> list=systemParamsDao.getSystemParamsByComId(getComId()); 
		Map<String,Object> map=new HashMap<String, Object>();
		for (Map<String, Object> map2 : list) {
			map.put(map2.get("param_name")+"", map2.get("param_val"));
		}
		return map;
	}
	/**
	 * 获取单个系统参数
	 * @param key
	 * @return
	 */
	public Object getSystemParam(String key) {
		Object obj=systemParamsDao.checkSystem(key, getComId());
		if (obj==null) {
			obj="";
		}
		return obj;
	}
	/**
	 * 获取物流分解消息路径
	 * @return
	 */
	private String getWuliuInfoPath() {
		 StringBuffer buffer=new StringBuffer(getComIdPath(getRequest())+"/wuliufenjie/");
		 buffer.append(DateTimeUtils.getNowDateTime()).append(".txt");
		return buffer.toString();
	}
	
	/**
	 * 向所有内勤发送订单需要处理的微信
	 * @param processName 订单跟踪流程名称
	 * @param buffer 订单号存放
	 * @param url 微信图文链接地址/login/toUrl.do?url=
	 */
	public void sendMessageNewsNeiQingUrl(Object processName,String buffer,String headship,String url) {
		try {
			///获取职位是内勤的所有人员
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("com_id", getComId());
			map.put("headship", "%"+headship+"%");
			map.put("omrtype",getSystemParam("ordersMessageReceivedType"));
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(map);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			String title=processName+"需要处理";
			mapMsg.put("title",title);
			mapMsg.put("description",buffer);
			if (StringUtils.isNotBlank(url)) {
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
			}
			if (processName.toString().contains("款")) {
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
			for (int i = 0; i < touserList.size(); i++) {
				Map<String,String> item=touserList.get(i);
				if (StringUtils.isNotBlank(item.get("clerk_name"))) {
					String msg=headship+item.get("clerk_name")+":"+title;
					news.get(0).put("title",msg);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
					}
					news.get(0).put("title",title);
				}
			}
		} catch (Exception e) {
//			writeLog(getRequest(), "订单跟踪发微信", e.getMessage()+"--");
			LoggerUtils.error(e.getMessage());
			e.printStackTrace();
		}
	}
	/**
	 * 向所有内勤发送订单需要处理的微信
	 * @param processName 订单跟踪流程名称
	 * @param buffer 订单号存放
	 * @param url 微信图文链接地址/login/toUrl.do?url=
	 * @param com_id 
	 * @return touserList
	 */
	public List<Map<String, String>> sendMessageNewsEmployee(String title, String description,String headship,String imgName,String url, Object com_id) {
		try {
			///获取职位是内勤的所有人员
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("com_id", getComId());
			if (com_id!=null) {
				map.put("com_id", com_id);
			}else{
				map.put("com_id", getComId());
			}
			map.put("headship", "%"+headship+"%");
			map.put("omrtype",getSystemParam("ordersMessageReceivedType"));
			List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(map);
			List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title",title);
			mapMsg.put("description",description);
			if (StringUtils.isNotBlank(url)) {
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+url);
			}
			if(StringUtils.isBlank(imgName)){
				mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			}else{
				mapMsg.put("picurl", ConfigFile.urlPrefix+imgName);
			}
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			news.add(mapMsg);
			for (int i = 0; i < touserList.size(); i++) {
				Map<String,String> item=touserList.get(i);
				if (StringUtils.isNotBlank(item.get("clerk_name"))) {
					String newds=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", headship)
							.replaceAll("@clerkName", item.get("clerk_name"));
					news.get(0).put("description",newds);
					if (StringUtils.isNotBlank(item.get("weixinID"))) {
						sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
					}
					news.get(0).put("description",description);
				}
			}
			return touserList;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 获取id值
	 * @param table 表名
	 * @param field 查询字段名
	 * @param prefix 前缀
	 * @param fnum 编码补0数
	 * @return id值
	 */
	public String getSortId(String table,String field,String prefix,int fnum) {
		String newsort_id;
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("tableName", table);
		map.put("filedName", field);
		Integer  seedsId=  managerDao.getMaxSeeds_id(map);
		newsort_id=String.format(prefix+"%0"+fnum+"d", seedsId+1);
		return newsort_id;
	}
	
	/**
	 * 生成结算年月
	 * 
	 * @param map
	 * @param name 日期取数的字段名称
	 * @return 结算日期
	 */
	public String getFinacial(Map<String, Object> map, String name) {
		String at_term_datetime_Act = DateTimeUtils.dateToStr(DateTimeUtils
				.strToDate(map.get(name).toString()));
		map.put("finacial_y", at_term_datetime_Act.split("-")[0]);
		map.put("finacial_m",
				Integer.parseInt(at_term_datetime_Act.split("-")[1]));
		return at_term_datetime_Act;
	}
	
	/**
	 * 获取总记录数
	 * @param map
	 * @param currentPage page
	 * @param pageRecord  rows
	 * @return
	 */
	public Integer getTotalRecord(Map<String,Object> map,Integer currentPage,Integer pageRecord) {
		Integer totalRecord=null;
		if(isNotMapKeyNull(map, "rows")){
			pageRecord=Integer.parseInt(map.get("rows")+"");
		}
		if (map.get("page")==null||"0".equals(map.get("page"))) {
			map.put("page", 1);
		}else{
			currentPage=Integer.parseInt(map.get("page")+"");
			if (currentPage==1) {
			}
			currentPage+=1;
			if (currentPage>1) {
				currentPage=(currentPage-1)*pageRecord;
			}
			map.put("page", currentPage);
		}
		if (map.get("rows")==null) {
			map.put("rows", pageRecord);
		}
		if (map.get("count")!=null&&!"0".equals(map.get("count"))) {
			totalRecord=Integer.parseInt(map.get("count")+""); 
		}else{
			map.put("count", 0);
		}
		return totalRecord;
	}
	/**
	 * 从xml中获取查询where条件
	 * @param map
	 * @return
	 */
	public String getQueryField(Map<String,Object> map) {
		map.remove("excelIndex");
		Object[] keys = map.keySet().toArray();
		Collection<Object> c = map.values();
		Object[] vals = c.toArray();
		StringBuffer findfield = new StringBuffer();
		for (int i = 0; i < vals.length; i++) {
			if (vals != null && !"".equals(vals)) {
				if (keys[i].toString().contains("mainten")) {
					continue;
				}
				String filed = keys[i] + "='" + vals[i] + "'";
				findfield.append(" ").append(filed).append(" and ");
			}
		}
		return findfield.substring(0, findfield.length() - 5);
	}
	
	public Integer getApprovalNo(String nowdate) {
		nowdate = nowdate + "%";
		String no = customerDao.getApprovalNo(nowdate);
		if (StringUtils.isBlank(no)) {
			return 1;
		} else {
			return Integer.parseInt(no.substring(no.length() - 4,
					no.length() - 1)) + 1;
		}
	}
	
	/**
	 * 组合下一个人员的审批信息
	 * @param map
	 * @param mapinfo
	 * @return
	 */
	public Map<String,Object> getApprovalInfoNext(Map<String, String> map, Map<String, Object> mapinfo) {
		Map<String,Object> mapnext=new HashMap<String, Object>();
		mapnext.put("com_id", mapinfo.get("com_id"));
		mapnext.put("ivt_oper_listing", mapinfo.get("ivt_oper_listing"));
		mapnext.put("sd_order_id", mapinfo.get("sd_order_id"));
		mapnext.put("store_date", mapinfo.get("store_date"));
		
		mapnext.put("mainten_clerk_id",map.get("employee"));
		mapnext.put("maintenance_datetime",getNow());
		
		mapnext.put("content",mapinfo.get("content"));
		mapnext.put("item_id",mapinfo.get("item_id"));
		mapnext.put("OA_what",mapinfo.get("OA_what"));
		mapnext.put("OA_je",mapinfo.get("OA_je"));
		mapnext.put("OA_who",mapinfo.get("OA_who"));
		
		mapnext.put("OA_whom", mapinfo.get("clerk_id"));
		mapnext.put("customer_id", mapinfo.get("customer_id"));
		mapnext.put("clerk_id", mapinfo.get("clerk_id"));
		
		mapnext.put("noticeResult",mapinfo.get("noticeResult"));
		return mapnext;
	}
	/**
	 * 组合需要更新的数据
	 * @param map
	 * @param mapinfo
	 * @return
	 */
	public Map<String,Object> getApprovalInfo(Map<String, String> map) {
		Map<String,Object> mapupdate=new HashMap<String, Object>();
		mapupdate.put("approval_YesOrNo", map.get("spyj"));//审批意见是否同意
		mapupdate.put("mainten_clerk_id",map.get("approvaler"));
		mapupdate.put("approvaler",map.get("approvaler"));
		mapupdate.put("approval_suggestion",map.get("spyijcontent"));
		mapupdate.put("maintenance_datetime",getNow());
		mapupdate.put("approval_time",getNow());
		mapupdate.put("approval_step_now", map.get("approval_step"));
		mapupdate.put("ivt_oper_listing", map.get("ivt_oper_listing"));
		return mapupdate;
	}
	
	/**
	 * 获取分页信息
	 * @param map
	 * @param totalRecord
	 * @param currentPage
	 * @param pageRecord
	 */
	public void getPageInfo(Map<String, Object> map, Integer totalRecord,
			Integer currentPage, Integer pageRecord) {
		if(map.get("page")!=null 
				&& !map.get("page").toString().equals("") 
				&& !map.get("page").toString().equals("0")){
			Integer page =  Integer.parseInt(map.get("page").toString());
			map.put("totalRecord", totalRecord);
			map.put("currentPage", page);
			map.put("pageRecord", pageRecord);
			map.put("top1", (page-1)==0?1:(page-1)*pageRecord);
			map.put("top2", pageRecord);
		}else{
			map.put("page", 1);
			map.put("totalRecord", totalRecord);
			map.put("currentPage", currentPage);
			map.put("pageRecord", pageRecord);
			map.put("top1", 1);
			map.put("top2", pageRecord);
		}
	}
	public Map<String, String> getPersonnelByWorkID(Object work_id,Object clerk_id) {
		Map<String,Object> mapParam=new HashMap<String, Object>();
		mapParam.put("com_id", getComId());
		if (work_id!=null) {
			mapParam.put("work_id",  work_id);
		}else{
			mapParam.put("clerk_id",clerk_id);
		}
		List<Map<String, String>> list = employeeDao.getPersonnelByWorkID(mapParam);
		if (list!=null&&list.size()>0) {
			 if (list.size()>1) {
				 StringBuffer phone=new StringBuffer();
				 StringBuffer weixinID=new StringBuffer();
				 for (int i = 0; i < list.size(); i++) {
					 Map<String, String> map=list.get(i);
					if (i==(list.size()-1)) {
						phone.append(map.get("phone"));
						weixinID.append(map.get("weixinID"));
					}else{
						phone.append(map.get("phone")).append("|");
						weixinID.append(map.get("weixinID")).append("|");
					}
				}
				 Map<String,String> map=new HashMap<String, String>();
				 map.put("phone", phone.toString());
				 map.put("weixinID", weixinID.toString());
				 return map;
			 }else{
				 return list.get(0);
			 }
		}
		return null;
	}
	/**
	 * 获取map中的值
	 * @param map
	 * @param key
	 * @return 为null返回空字符串
	 */
	public  String getMapKey(Map<String,Object> map, String key){
		if (isMapKeyNull(map, key)) {
			return "";
		}else{
			return map.get(key).toString().trim();
		}
	}
	
	/**
	 * 发送员工微信消息
	 * @param headship
	 * @param news
	 * @param com_id 
	 * @param processName 
	 * @return 
	 */
	public List<Map<String, String>> sendemployeemsg(String headship,List<Map<String, Object>> news, Object com_id, String processName) {
		Object obj=getSystemParam("ordersMessageReceivedType");
		if("0".equals(obj)||"2".equals(obj)){
			if(StringUtils.isNotBlank(headship)){
				String[] heas=headship.split(",");
				if(heas!=null&&heas.length>0){
					List<Map<String,String>> list=new ArrayList<Map<String,String>>();
					for (int j = 0; j < heas.length; j++) {
						list.addAll(zuheemployeesendmsg(heas[j], news,com_id,processName));
					}
					return list;
				}else{
					return zuheemployeesendmsg("", news,com_id,processName);
				}
			}else{
				return zuheemployeesendmsg("", news,com_id,processName);
			}
		}else{
			return zuheemployeesendmsg("", news,com_id,processName);
		}
	}
	/**
	 * 组合员工发送消息
	 * @param headship
	 * @param news
	 * @param com_id 
	 * @param processName 
	 * @return 
	 */
	public List<Map<String, String>> zuheemployeesendmsg(String headship, List<Map<String, Object>> news, Object com_id, String processName) {
		Map<String,Object> mapparams=new HashMap<String, Object>();
		if (com_id!=null) {
			mapparams.put("com_id", com_id);
		}else{
			mapparams.put("com_id", getComId());
		}
		if(StringUtils.isBlank(headship)){
			headship=null;
		}
		mapparams.put("headship", "%"+headship+"%");
		if (StringUtils.isNotBlank(processName)) {
			mapparams.put("processName", "%"+processName+"%");
		}
		mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapparams);
		String description=news.get(0).get("description").toString();
		for (int i = 0; i < touserList.size(); i++) {
			Map<String,String> item=touserList.get(i);
			String msg=description.replaceAll("@Eheadship", headship).replaceAll("@clerkName", item.get("clerk_name"));
			news.get(0).put("description",msg);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
			}
			news.get(0).put("description",description);
		}
		return touserList;
	}
	/**
	 * 获取查询员工或客户的条件参数和微信消息参数
	 * @param map
	 * @param news 返回微信消息参数
	 * @param title
	 * @param description
	 * @param url+param 跳转地址加参数 utf8to16
	 * @param imgName 图片路径
	 * @param headship
	 * @param processName 流程名称
	 * @return 查询员工信息的条件参数,并返回微信消息参数
	 */
	protected Map<String, Object> getWeixinMsgParams(Map<String,Object> map, List<Map<String, Object>> news) {
		if (news!=null) {
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title", map.get("title"));
			mapMsg.put("description",map.get("description")); 
			if(map.get("url").toString().contains("http")){
				mapMsg.put("url",map.get("url"));
			}else{
				mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+map.get("url"));
			}
			mapMsg.put("picurl", ConfigFile.urlPrefix+map.get("imgName"));
			if(getCustomer(getRequest())!=null){
				mapMsg.put("sendRen", getCustomerId(getRequest()));
			}else if(getEmployee(getRequest())!=null){
				mapMsg.put("sendRen", getEmployeeId(getRequest()));
			}
			if (isNotMapKeyNull(map, "upper_customer_id")) {
				mapMsg.put("upper_customer_id",map.get("upper_customer_id"));
			}
			news.add(mapMsg);
		}
		Map<String,Object> mapparams=new HashMap<String, Object>();
		mapparams.put("com_id", getComId());
		if(isNotMapKeyNull(map, "headship")){
			mapparams.put("headship", "%"+map.get("headship")+"%");
		}
		if (isNotMapKeyNull(map, "upper_customer_id")) {
			mapparams.put("upper_customer_id",map.get("upper_customer_id"));
		}
		mapparams.put("processName", "%"+map.get("processName")+"%");
		mapparams.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		return mapparams;
	}
	
	/**
	 * 向员工发送消息
	 * @param map
	 * @param title
	 * @param description
	 * @param url+参数 跳转地址加参数 utf8to16 ,参数使用"|"进行连接
	 * @param imgName 图片路径
	 * @param headship
	 * @param processName
	 * @return 员工待发消息列表
	 */
	public List<Map<String, String>> sendEmployeeWeixinMessage(Map<String,Object> map) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(getWeixinMsgParams(map,news));
		String description=map.get("description").toString();
		for (int i = 0; i < touserList.size(); i++) {
			Map<String,String> item=touserList.get(i);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				String msg=description.replaceAll("@Eheadship",getMapKey(map, "headship")).replaceAll("@clerkName", item.get("clerk_name"));
				news.get(0).put("description",msg);
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
				}
				news.get(0).put("description",description);
			}
		}
		return touserList;
	}
	/**
	 * 向客户发送消息
	 * @param map
	 * @param title
	 * @param description
	 * @param url+参数 跳转地址加参数 utf8to16 ,参数使用"|"进行连接
	 * @param imgName 图片路径
	 * @param headship
	 * @param processName
	 * @return 客户待发消息列表
	 */
	public List<Map<String, String>> sendClientWeixinMessage(Map<String,Object> map) {
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		List<Map<String,String>> touserList=customerDao.getCustomerWeixinByHeadship(getWeixinMsgParams(map,news));
		String description=map.get("description").toString();
		for (int i = 0; i < touserList.size(); i++) {
			Map<String,String> item=touserList.get(i);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				String msg=description.replaceAll("@headship", getMapKey(map, "headship"));
				msg=msg.replaceAll("@customerName", item.get("corp_sim_name"));
				msg=msg.replaceAll("@orderNo", map.get("orderNo")+"");
				news.get(0).put("description",msg);
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,getComId(),item.get("weixinID"),"客户");
				}
				news.get(0).put("description",description);
			}
		}
		return touserList;
	}
	
	
	
	/**
	 * 发送客户微信消息
	 * @param headship
	 * @param news
	 * @param upper_customer_id 
	 * @param processName 
	 * @return 
	 */
	public List<Map<String, String>> sendclientmsg(String headship, List<Map<String, Object>> news, String upper_customer_id, String processName) {
		Object obj=getSystemParam("ordersMessageReceivedType");
		if("0".equals(obj)||"2".equals(obj)){
			if(StringUtils.isNotBlank(headship)){
				String[] heas=headship.split(",");
				if(heas!=null&&heas.length>0){
					List<Map<String, String>> list=new ArrayList<Map<String,String>>();
					for (int j = 0; j < heas.length; j++) {
						list.addAll(zuheclientsendmsg(heas[j], news,upper_customer_id,processName));
					}
					return list;
				}else{
					return zuheclientsendmsg("", news,upper_customer_id,processName);
				}
			}else{
				return zuheclientsendmsg("", news,upper_customer_id,processName);
			}
		}else{
			return zuheclientsendmsg("", news,upper_customer_id,processName);
		}
	}
	/**
	 * 组合客户需要发送的消息
	 * @param headship
	 * @param news
	 * @param processName
	 * @return 
	 */
	public List<Map<String, String>>  zuheclientsendmsg(String headship, List<Map<String, Object>> news,
			String upper_customer_id, String... processName) {
		Map<String,Object> params=new HashMap<String, Object>();
		params.put("headship","%"+headship+"%");
		if (processName!=null&&StringUtils.isNotBlank(processName[0])) {
			params.put("processName","%"+processName[0]+"%");
		}
		String name="";
		if(processName!=null&&processName.length<2){
			name="客户";
		}else{
			name=processName[1];
		}
		params.put("com_id", getComId());
		params.put("upper_customer_id",upper_customer_id);
		params.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String,String>> cuslist=customerDao.getCustomerWeixinByHeadship(params);
		if (cuslist!=null&&cuslist.size()>0) {
			String description=news.get(0).get("description").toString();
			for (int i = 0; i < cuslist.size(); i++) {
				Map<String,String> item=cuslist.get(i);
				String msg=null;
				if(StringUtils.isNotBlank(description)){
					if(description.contains("@customerName")){
						msg=description.replaceAll("@customerName", item.get("corp_sim_name"));
					}else{
						msg="尊敬的客户["+item.get("corp_sim_name")+"]"+description;
					}
					news.get(0).put("description",msg);
				}
				if (StringUtils.isNotBlank(item.get("weixinID"))) {
					sendMessageNews(news,getComId(),item.get("weixinID"),name);
				}
				news.get(0).put("description",description);
			}
		}
		return cuslist;
	}
	/**
	 * 保存客户到指定的运营商
	 * @param mapcusnow
	 * @param com_id 指定的com_id
	 */
	public void saveCustomerToCom(Map<String,Object> mapcusnow, Object com_id){
		if (!getComId().equals(com_id)) {
			if("消费者".equals(getCustomer(getRequest()).get("ditch_type"))){
				saveCustomerToCom(mapcusnow,com_id,getCustomerId(getRequest()));
			}else{
				Map<String,Object> mapparam=new HashMap<String, Object>();
				mapparam.put("com_id", com_id);
				mapparam.put("customer_id", getCustomerId(getRequest()));
				String upper=customerDao.getCustomerNext(mapparam);
				String customer_id=getUpperCustomerId(getRequest());
				if(StringUtils.isNotBlank(upper)){//有数据表示是单位账号登录,客户上级编码就是该客户的
					customer_id= getCustomerId(getRequest());
				}
				List<Map<String,Object>> list=customerDao.getUpNextCustomerByCid(customer_id, getComId());
				if (list!=null&&list.size()>0) {
					for (Map<String, Object> map : list) {
						map.remove("seeds_id");
						saveCustomerToCom(map, com_id, map.get("customer_id").toString());
					}
				}
			}
		}
	}
	/**
	 * 保存客户信息到指定的运营商下
	 * @param mapcusnow
	 * @param com_id
	 * @param customer_id
	 */
	public void saveCustomerToCom(Map<String, Object> mapcusnow, Object com_id,String customer_id) {
		//判断当前客户在该运营商下面是否存在
		Map<String,Object> mapcus= customerDao.getCustomerByCid(customer_id,com_id.toString());
		//不存在就新增加一条
		if(mapcus==null){
			mapcusnow.put("com_id", com_id);
			mapcusnow.put("ifUseCredit", "否");
			mapcusnow.put("ifUseDeposit", "否");
			mapcusnow.put("price_type", "否");
			mapcusnow.remove("clerk_idAccountApprover");
			managerDao.insertSql(getInsertSql("sdf00504", mapcusnow));
		}
	}
	/**
	 * 获取当前登录客户信息
	 * @return
	 */
	public Map<String,Object> getNowCustomreInfo() {
		Map<String,Object> mapcusnow= customerDao.getCustomerByCid(getCustomerId(getRequest()), getComId());
		mapcusnow.remove("seeds_id");
		return mapcusnow;
	}
	/**
	 * 获取订单产品的历史记录
	 * @param seeds_id 订单产品的id 根据此id获取订单从表中的订单编号和产品内码
	 * @return 订单产品编号加产品id日志存放路径001/orderHistory/orderNo/item_id.log
	 */
	public String getOrderHistoryPath(Object seeds_id) {
		Map<String,String> map =employeeDao.getOrderNoAndItemIdBySeeds_is(seeds_id);
		if(map!=null){
			StringBuffer path=new StringBuffer(getRealPath(getRequest())).append(getComId()).append("/");
			path.append("orderHistory/").append(map.get("orderNo")).append("/").append(map.get("item_id")).append(".log");
			File file=new File(path.toString());
			mkdirsDirectory(file);
			return path.toString();
		}
		return null;
	}
	/**
	 * 保存订单产品的历史
	 * @param seeds_id 订单产品的id 根据此id获取订单从表中的订单编号和产品内码
	 * @param content 订单产品相关事项
	 */
	public void saveOrderHistory(Object seeds_id,String content) {
		//{"time":time,"content":""}
		JSONObject json=new JSONObject();
		json.put("time", getNow());
		json.put("content", content);
		if(seeds_id!=null){
			if (seeds_id.toString().contains(",")) {
				for (String str : seeds_id.toString().split(",")) {
					saveFile(getOrderHistoryPath(str), json.toString()+",", true);
				}
			}else{
				saveFile(getOrderHistoryPath(seeds_id), json.toString()+",", true);
			}
		}
	}
	/**
	 * 保存订单产品的历史
	 * @param seeds_id 订单产品的id 根据此id获取订单从表中的订单编号和产品内码
	 * @param content 订单产品相关事项
	 */
	public void saveOrderHistory(Object orderNo,Object item_id,String content) {
		//{"time":time,"content":""}
		JSONObject json=new JSONObject();
		json.put("time", getNow());
		json.put("content", content);
		saveFile(getOrderHistoryPath(orderNo,item_id), json.toString()+",", true);
	}
	/**
	 * 向员工发送微信消息
	 * @param news 消息主体
	 * @param headship 职务
	 * @return 
	 */
	public List<Map<String, String>> sendWexinMsgToEmployee(List<Map<String, Object>> news,Object headship) {
		if(getCustomer(getRequest())!=null){
			news.get(0).put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			news.get(0).put("sendRen", getEmployeeId(getRequest()));
		}
		Map<String,Object> mapempl=new HashMap<String, Object>();
		mapempl.put("com_id", getComId());
		mapempl.put("headship", "%"+headship+"%");
		mapempl.put("omrtype",getSystemParam("ordersMessageReceivedType"));
		List<Map<String, String>> touserList=employeeDao.getPersonnelNeiQing(mapempl);
		for (int i = 0; i < touserList.size(); i++) {
			Map<String, String> item= touserList.get(i);
			String title=news.get(0).get("description").toString();
			///////
			String msg=title.replaceAll("@comName", getComName()).replaceAll("@clerkName", item.get("clerk_name").replaceAll("@Eheadship", headship+""));
			news.get(0).put("description",msg);
			if (StringUtils.isNotBlank(item.get("weixinID"))) {
				sendMessageNews(news,getComId(),item.get("weixinID"),"员工");
			}
			news.get(0).put("description",title);
		}
		return touserList;
	}
	/**
	 * 获取通知类型
	 * @param map
	 * @param key 需要查询的类型传入参数0-微信,1-短信
	 * @return true-通知,false-不通知
	 */
	public boolean getNoticeStyle(Map<String, Object> map,String key) {
		boolean b=false;
		Object NoticeStyle=map.get("NoticeStyle");
		if (NoticeStyle==null) {
			NoticeStyle ="0";
		}
		if (key.equals(NoticeStyle)||"2".equals(NoticeStyle)) {
			b=true;
		}else{
			b=false;
		}
		return b;
	}
	/**
	 * 向业务员发送客户下订单消息和订单结束消息
	 * @param orderNo 订单编号
	 * @param msg 发送主题,下订单,或者订单收货
	 * @param customer_id 客户编码
	 * @param seeds_id 
	 * @param customerName 
	 */
	public Map<String,String> sendMsgToYewuyuan(String msginfo,String description,Object customer_id, Object seeds_id) {
		// TODO Auto-generated method stub
		//1.获取该客户对应的业务员
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("customer_id", customer_id);
		map.put("com_id", getComId());
		Map<String,String> mapempl=employeeDao.getEmployeeByCustomerId(map);
		//2.向该业务员发送消息
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", msginfo);
		mapMsg.put("description",description);
		String Eurl=null;
		if(seeds_id!=null){
			Eurl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?seeds_id="+seeds_id+"|processName="+utf8to16("已结束");
		}else{
			Eurl=ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?customer_id="+customer_id;
		}
		mapMsg.put("url",Eurl);
		mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
		if(getCustomer(getRequest())!=null){
			mapMsg.put("sendRen", getCustomerId(getRequest()));
		}else if(getEmployee(getRequest())!=null){
			mapMsg.put("sendRen", getEmployeeId(getRequest()));
		}
		news.add(mapMsg);
		String msg=description.replaceAll("@comName", getComName()).replaceAll("@Eheadship", "业务员").replaceAll("@clerkName", mapempl.get("clerk_name"));
		if (StringUtils.isNotBlank(description)) {
			news.get(0).put("description",msg);
		}
		if (StringUtils.isNotBlank(mapempl.get("weixinID"))) {
			sendMessageNews(news,getComId(),mapempl.get("weixinID"),"员工");
		}
		if (StringUtils.isNotBlank(description)) {
			news.get(0).put("description",description);
		}
		return mapempl;
	}
	/**
	 * 获取系统参数名称
	 * @param param_name
	 * @return
	 */
	public String getSystemParamByName(String param_name) {
		return systemParamsDao.checkSystem(param_name, getComId()).toString();
	}
	/**
	 * 获取系统参数名称
	 * @param param_name
	 * @return
	 */
	public Integer getSystemParamIByName(String param_name) {
		return Integer.parseInt(systemParamsDao.checkSystem(param_name, getComId().toString()));
	}
	/**
	 * 获取当前流程下微信消息参数
	 * @param processName
	 * @param item_json
	 * @return
	 * @throws Exception
	 */
	public JSONObject getProcessParams(Object processName)throws Exception {
		String proceessStr=getFileTextContent(getSalesOrderProcessNamePath(getRequest()));
		if (StringUtils.isNotBlank(proceessStr)&&proceessStr.startsWith("[")) {
			JSONArray proceess=JSONArray.fromObject(proceessStr);
			Integer index=null;
			JSONObject item_json=null;
			for (int i = 0; i < proceess.size(); i++) {
				JSONObject json=proceess.getJSONObject(i);
				boolean b=json.getString("processName").equals(processName);
				if(b){
					index=proceess.indexOf(json);
					if(index==(proceess.size()-1)){
						throw new RuntimeException("已经到流程最后一步了!");//页面增加单独收货按钮
					}
					item_json=json;
					break;
				}
			}
			return item_json;
		}else{
			throw new RuntimeException("请先设置订单流程");
		}
	}
	/**
	 * 将产品详情放入到订单从表中
	 * @param map
	 * @param json
	 * @return
	 */
	public Map<String,Object> getItemByJson(Map<String,Object> map,JSONObject json){
		getJsonVal(map, json, "c_memo", "c_memo");
		getJsonVal(map, json, "memo_color", "memo_color");
		getJsonVal(map, json, "memo_other", "memo_other");
		getJsonVal(map, json, "item_color", "item_color");
		getJsonVal(map, json, "item_id", "item_id");
		getJsonVal(map, json, "item_type", "item_type");
		getJsonVal(map, json, "item_code", "item_code");
		getJsonVal(map, json, "item_Hight", "item_Hight");
		getJsonVal(map, json, "item_Lenth", "item_Lenth");
		getJsonVal(map, json, "item_Sellprice", "item_Sellprice");
		getJsonVal(map, json, "item_struct", "item_struct");
		getJsonVal(map, json, "item_Width", "item_Width");
		getJsonVal(map, json, "item_struct", "item_struct");
		getJsonVal(map, json, "item_yardPrice", "item_yardPrice");
		getJsonVal(map, json, "item_zeroSell", "item_zeroSell");
		return map;
	}
	
	/**
	 * 组合微信服务号模板子项内容
	 * @param val
	 * @return
	 */
	public JSONObject getWeixinTempItem(Object val) {
		JSONObject json=new JSONObject();
		json.put("value",val);
		json.put("color","#173177");
		return json;
	}
	/**
	 * 发送微信服务号消息
	 * @param url 跳转地址
	 * @param template_id 模板id
	 * @param data 发送的数据
	 * @param touserList 待发送人员列表
	 */
	public void sendWeixinServiceMsg(String url,String template_id,JSONObject data, List<Map<String, String>> touserList){
		if (!url.contains("http://")) {
			url=ConfigFile.urlPrefix+"/login/toUrl.do?url="+url;
		}
		StringBuffer buffer=new StringBuffer("微信服务号:");
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		for (Map<String, String> map2 : touserList) {
			if (StringUtils.isNotBlank(map2.get("openid"))) {
				String msg=ws.sendMessage(map2.get("openid"), template_id, getComId(), url, data);
				buffer.append(msg);
			}
		}
		LoggerUtils.info(buffer.toString());
	}
	/**
	 * 发送新订单消息给内勤
	 * @param map
	 * @param Eurl
	 * @param payType
	 * @param touserList
	 */
	public void sendNewOrderMsgToEmpl(Map<String,Object> map, String Eurl,String payType,String template_id, List<Map<String, String>> touserList) {
		template_id="aZib3OJYYtwfZ2VxXNEvDkV8SD-JXwwJFnl4k-0EtHk";
		Map<String,Object> param=new HashMap<>();
		param.put("com_id", getComId());
		param.put("template_id", template_id);
		List<Map<String,Object>> tempList= managerDao.getWexinMsgTemplate(param);
		if (tempList!=null&&tempList.size()>0) {
			List<String> list=customerDao.getPayOrderProductName(map);
			StringBuffer names=new StringBuffer();
			for (String name : list) {
				names.append(name).append(",");
			}
			String item_name=names.substring(0, names.length()-1);
			JSONObject data=new JSONObject();
			if (isNotMapKeyNull(map, "first")) {
				data.put("first",getWeixinTempItem(map.get("first")));
			}else{
				data.put("first",getWeixinTempItem("你好,你有一笔新订单需要审核:"));
			}
			String[] cons=tempList.get(0).get("content").toString().split("\\.");
			data.put(cons[0],getWeixinTempItem(item_name));//商品明细
			data.put(cons[1],getWeixinTempItem(getNow()));//下单时间
			data.put(cons[2],getWeixinTempItem(map.get("fhdz")));//配送地址
			data.put(cons[3],getWeixinTempItem(map.get("lxr")));//联系人
			data.put(cons[4],getWeixinTempItem(payType));//付款状态
			data.put("remark",getWeixinTempItem("点击“详情”查看完整订单信息,消息发送时间:"+getNow()));
			sendWeixinServiceMsg(Eurl, template_id, data, touserList);
		}
	}
}
