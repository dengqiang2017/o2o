package com.qianying.listener;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Controller;

import com.qianying.controller.BaseController;
import com.qianying.dao.interfaces.SqlExecDao;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.IOperatorsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.InitConfig;
import com.qianying.util.Kit;
import com.qianying.util.WeixinUtil;
/**
 *  容器加载完成监听器
 * @author dengqiang
 *
 */
@Controller
public class DataSourceInitListener implements ApplicationListener<ContextRefreshedEvent> {
	@Autowired
	private IOperatorsService operatorsService;
	@Autowired
	private SqlExecDao sql;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private IEmployeeService employeeService;
	private Logger log = Logger.getLogger(DataSourceInitListener.class);
	private static boolean fisInit=true;
	@Override
	public void onApplicationEvent(ContextRefreshedEvent ev) {
		//防止重复执行。
//		boolean b=ev.getApplicationContext() instanceof FileSystemXmlApplicationContext;
        if(fisInit){
        	fisInit=false;
        	log.error("系统初始化中请等待......"); 
			 try {
				 ClassLoader loader = InitConfig.class.getClassLoader();
				 InputStream inStream = loader
						 .getResourceAsStream("jdbc.properties");
				 Map<String, Object> mapname = Kit.getTxtKeyVal(inStream);
				 operatorsService.initTable(mapname.get("databaseName").toString());
			 } catch (Exception e) {
				 e.printStackTrace();
			 }
			 ///读取sql文件中表结构,存储过程,视图,进行创建
			 log.error("初始化数据库结构......");
			 File sqlsFile=new File(ConfigFile.getProjectPath()+"sql/");
			 if (sqlsFile.exists()&&sqlsFile.isDirectory()) {
				File[] sqlFiles=sqlsFile.listFiles();
				if (sqlFiles!=null&&sqlFiles.length>0) {
					for (File path : sqlFiles) {
						if (path.isFile()) {
							String sqlStr=BaseController.getFileTextContent(path);
							if (StringUtils.isNotBlank(sqlStr)) {
								Map<String, Object> map=new HashMap<>();
								map.put("sSql", sqlStr);
								sql.sqlExec(map);
							}
						}
					}
				}
			}
			 log.error("初始化账套信息......");
			 List<Map<String,Object>> list= operatorsService.getAll(); 
			 WeixinUtil weicom=new WeixinUtil();
			 //1.查询ctl09003中也没有001
			 if (list.size()>0) {
				 for (Map<String, Object> mapcom : list) {
					 String com_id=mapcom.get("com_id").toString();
					 weicom.delAccessFile(com_id);
					 Map<String,Object> paramMap=null;
					 try {
						 paramMap=managerService.getSystemParamsByComIdSet(com_id);
					} catch (Exception e) {break;}
					 if (paramMap!=null) {
						 String corpid=MapUtils.getString(paramMap, "corpid");
						 if(StringUtils.isNotBlank(corpid)){
							 BaseController.saveFile(WeixinUtil.getWeixinParamFile(com_id,"corpid"), corpid);
						 }
						 String mch_id=MapUtils.getString(paramMap, "mch_id");
						 if(StringUtils.isNotBlank(mch_id)){
							 BaseController.saveFile(WeixinUtil.getWeixinParamFile(com_id,"mch_id"), mch_id);
						 }
						 String corpsecret=MapUtils.getString(paramMap, "corpsecret");
						 if(StringUtils.isNotBlank(corpsecret)){
							 BaseController.saveFile(WeixinUtil.getWeixinParamFile(com_id,"corpsecret"), corpsecret);
						 }
						 String corpsecret_chat=MapUtils.getString(paramMap, "corpsecret_chat");
						 if(StringUtils.isNotBlank(corpsecret_chat)){
							 BaseController.saveFile(WeixinUtil.getWeixinParamFile(com_id,"corpsecret_chat"), corpsecret_chat);
						 }
						 //
						 weicom.saveDeptList(com_id,paramMap.get("agentDeptId"));
						 String appid_service=MapUtils.getString(paramMap, "appid_service");
						 if(StringUtils.isNotBlank(appid_service)){
							 BaseController.saveFile(WeixinUtil.getWeixinParamFile(com_id,"appid_service"), appid_service);
						 }
						 String secret_service=MapUtils.getString(paramMap, "secret_service");
						 if(StringUtils.isNotBlank(secret_service)){
							 BaseController.saveFile(WeixinUtil.getWeixinParamFile(com_id,"secret_service"), secret_service);
						 }
					}
					 InitConfig.initComIdFile(com_id);
					 Map<String,Object> map= managerService.checkLogin("001",com_id);
					 if (map==null) {
						 Map<String,Object> mapsave=new HashMap<String, Object>();
						 mapsave.put("com_id", com_id);
						 mapsave.put("user_id", "001");
						 mapsave.put("user_password", "123qwe");
						 mapsave.put("clerk_id", "001");
						 mapsave.put("i_browse", "2");
						 mapsave.put("usr_grp_id", "0");
						 mapsave.put("if_O2O", "2");
						 managerService.insertSql(mapsave,0,"ctl09003",null,null);
					 }
					 log.error("初始化数据中请等待......");
					 try {
						operatorsService.initData(com_id);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				 }
			}else{
				 weicom.delAccessFile("001");
				 weicom.getDeptList(1,"001");
				 Map<String,Object> mapsave=new HashMap<String, Object>();
				 mapsave.put("com_id", "001");
				 mapsave.put("com_sim_name", "运营商001");
				 mapsave.put("com_name", "运营商001");
				 mapsave.put("tax_class", "0");
				 managerService.insertSql(mapsave,0,"Ctl00501",null,null);
				 mapsave=new HashMap<String, Object>();
				 mapsave.put("com_id", "001");
				 mapsave.put("user_id", "001");
				 mapsave.put("user_password", "123qwe");
				 mapsave.put("clerk_id", "001");
				 mapsave.put("i_browse", "2");
				 mapsave.put("if_O2O", "2");
				 mapsave.put("usr_grp_id", 0);
				 managerService.insertSql(mapsave,0,"ctl09003",null,null);
			}
//			 employeeService.GenerateSignBaseTable();//生成微信预签到信息
//			 managerService.updateWeixinState();//更新微信状态
			 //2.查询用户表中有没有001
			log.error("系统初始化完成!");
        }
	}
	private Map<String, String> addSql(String sql1, String sql2) {
		Map<String, String> map=new HashMap<String, String>();
		map.put("modify", sql1);
		if (StringUtils.isNotBlank(sql2)) {
			map.put("add", sql2);
		}
		return map;
	}
	private void modifyTable(List<Map<String, String>> sqls){
		Map<String, Object> map =new HashMap<String, Object>();
		for (Map<String, String>  sql : sqls) {
			try {
				execSql(map, sql.get("modify"));
			} catch (Exception e) {
				execSql(map, sql.get("add"));
			}
		}
				}
	private void execSql(Map<String, Object> map,String sSql) {
		if (StringUtils.isNotBlank(sSql)) {
			map.put("sSql", sSql);
			sql.sqlExec(map);
		}
		map.clear();
			}
	private void sax_sql() {
		try {
			ClassLoader loader = DataSourceInitListener.class.getClassLoader();
			InputStream in = loader.getResourceAsStream("tableModify.xml");
			SAXReader reader = new SAXReader();
			Document document = reader.read(in);
			Element rootElm = document.getRootElement();
			List<Element> nodes = rootElm.elements("item");
			List<Map<String, String>> sqls=new ArrayList<Map<String,String>>();
			for (Iterator<Element> it = nodes.iterator(); it.hasNext();) {
				Element elm = it.next();
				String sql1 = elm.attributeValue("sql1");
				String sql2 = elm.attributeValue("sql2");
				sqls.add(addSql(sql1, sql2));
        }
			modifyTable(sqls);
		} catch (Exception e) {
			e.printStackTrace();
	}
	}
}
