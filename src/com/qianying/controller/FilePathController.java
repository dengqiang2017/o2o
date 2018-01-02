package com.qianying.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import javax.servlet.http.HttpServletRequest;

import net.sf.excelutils.ExcelUtils;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.xml.XMLSerializer;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;

import com.qianying.bean.VerificationCode;
import com.qianying.page.PageList;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IProductService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
import com.qianying.util.WeixinUtil;
/**
 * 文件工具类,用于存放系统中需要生成的文件路径
 * @author dengqiang
 *
 */
public abstract class FilePathController extends BaseController{
	/**
	 * 获取收款单号对应的备注文件路径
	 * @param request
	 * @param orderNo 收款单号
	 * @return 备注文件路径
	 */
	public File getRecievedMemo(HttpServletRequest request, Object orderNo,String customerId) {
		StringBuffer buffer=new StringBuffer(getComIdPath(request));
		buffer.append("recievedmemo/").append(customerId).append("/");
		buffer.append(orderNo).append(".txt");
		return new File(buffer.toString());
	}
	/**
	 * 获取带有comId的真实路径 已经在后面加 "/"
	 * @param request
	 * @return
	 */
	public String getComIdPath(HttpServletRequest request) {
		StringBuffer buffer=new StringBuffer(getRealPath(request));
		buffer.append(getComId(request)).append("/");
		return buffer.toString();
	}
	
	/**
	 * 获取日志文件路径
	 * @param request
	 * @param aut 操作者内码
	 * @param date 时间毫秒,文件名 
	 * @return 001/log/clerk_id/14788.log
	 */
	public File getLogPath(HttpServletRequest request,String aut,Long date) {
		if (StringUtils.isBlank(aut)) {
			aut=getEmployeeId(request);
			if (getCustomer(request)==null) {
				aut=getCustomerId(request);
			}
		}
		if(date==null){
			date=new Date().getTime();
		}
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("log/").append(aut).append("/");
		path.append(date).append(".log");
		File file=new File(path.toString());
		mkdirsDirectory(file);
		return file;
	}
	/**
	 * 保存日志文件
	 * @param request
	 * @param id 操作员内码
	 * @param name 操作员名称
	 * @param type 操作内容
	 * @see 内码,名称,IP地址,访问时间,访问内容,访问终端
	 */
	public void writeLog(HttpServletRequest request,String id,Object name,String type){
		StringBuffer str=new StringBuffer(id).append(",").append(name);
		str.append(",").append(LogUtil.getIpAddr(request)).append(",").append(getNow());
		str.append(",").append(type.replaceAll(",", "")).append(",访问终端:").append(request.getHeader("user-agent").replaceAll(";", "")).append(";");
		saveFile(getLogPath(request,id,null).getPath(), str.toString(),true);
	}
	/**
	 * 获取备份文件路径
	 * @param request
	 * @return
	 */
	public String getBackupFilePath(HttpServletRequest request) {
		StringBuffer buffer=new StringBuffer(getComIdPath(request));
		buffer.append("backup/").append(DateTimeUtils.getNowDate()).append("/");
		buffer.append(DateTimeUtils.getNowDateTime());
		buffer.append(".dat");
		File file =new File(buffer.toString());
		if (!file.exists()) {
			file.getParentFile().mkdirs();
		}
		return file.getPath();
	}
	
	public String excelExport(HttpServletRequest request,List<Map<String,Object>> list,String xlsName) {
		String msg=null;
		//将数据集合放入导出中
		ExcelUtils.addValue("listmap", list);
		//Excel模块相对路径
		String config ="/"+getComId(request)+"/xls/"+xlsName+".xls";
		//生成的Excel存放地址
		StringBuffer buffer=new StringBuffer("temp/");
	    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
	    buffer.append(xlsName+".xls"); 
	    //生成Excel文件并将路径返回到页面以供下载
	    msg=getExcelPath(request, buffer, config);
	    return msg;
	}
	/**
	 * 签到文件图片存放路径
	 * @param request
	 * @return
	 */
	public String getSignPath(HttpServletRequest request) {
		String path=getComIdPath(request)+"sign/"+DateTimeUtils.dateToStr()+"/"+getEmployeeId(request)+"/"+
				DateTimeUtils.getNowDateTime()+".jpg";
		File qxFile=new File(path);
		if (!qxFile.exists()) {
			qxFile.getParentFile().mkdirs();
		}
		return path;
	}
	/**
	 * 签到文件图片存放路径
	 * @param request
	 * @return
	 */
	public String getSignPath(HttpServletRequest request,String time) {
		String path=getComIdPath(request)+"sign/"+DateTimeUtils.dateToStr()+"/"+getEmployeeId(request)+"/"+
				time+".jpg";
		File qxFile=new File(path);
		if (!qxFile.exists()) {
			qxFile.getParentFile().mkdirs();
		}
		return path;
	}
	/**
	 * 获取签到文件图片存放路径
	 * @param request
	 * @return
	 */
	public String getSignPath(HttpServletRequest request,String date,String clerk_id) {
		String path=getComIdPath(request)+"sign/"+date+"/"+clerk_id+"/";
		File qxFile=new File(path);
		if (!qxFile.exists()) {
			qxFile.getParentFile().mkdirs();
		}
		return path;
	}
	/**
	 * 签到日志存放路径
	 * @param request
	 * @return
	 */
	public String getSignLogPath(HttpServletRequest request) {
		String path=getComIdPath(request)+"sign/"+DateTimeUtils.dateToStr()+"/"+getEmployeeId(request)+"/"+
				DateTimeUtils.getNowDate()+".log";
		File qxFile=new File(path);
		if (!qxFile.exists()) {
			qxFile.getParentFile().mkdirs();
		}
		return qxFile.getPath();
	}
	/**
	 * 查询
	 * @param request
	 * @param clerk_id
	 * @param filename
	 * @return
	 */
	public String getPlanquery(HttpServletRequest request,Object clerk_id, Object filename) {
		StringBuffer buffer=new StringBuffer(getComIdPath(request));
		buffer.append("/planquery/");
		buffer.append(clerk_id).append("/").append(filename);
		return buffer.toString();
	}
	/**
	 * 从文件中获取部门sql查询片段
	 * @param request
	 * @param map 数据存放源
	 * @param srcName 多来源字段名
	 * @param filename sql存放文件名
	 * @param queryName 查询字段名称
	 * @param prefix 前缀,为空就不加前缀
	 * @param employeeService 
	 * @return 返回获取到的sql
	 */
	public Map<String,Object> getDept_idInfoQuery(HttpServletRequest request, Map<String,Object> map,String srcName,String filename,String queryName,String prefix, IEmployeeService employeeService){
		try {
			//多来源验证集合,从员工表中获取是否需要进行组合和判断是否只看自己的
			if ("001".equals(getEmployeeId(request))&&map.get("info")==null) {
				return map;
			}
			String clerk_id=null;
			if (map.get("clerk_id")==null) {
				clerk_id=getEmployeeId(request);
			}else{
				clerk_id=map.get("clerk_id").toString();
			}
			Map<String,Object> mapdept=employeeService.getPersonnel(clerk_id,getComId(request));
			if (mapdept!=null&&mapdept.get(srcName)!=null) {//有多来源就可以看见多个
				
				File file=new File(getPlanquery(request, clerk_id, filename));
				if (file.exists()) {
					InputStream inputStream=new FileInputStream(file);
					Scanner sc=new Scanner(inputStream,"UTF-8");
					StringBuffer deptIdInfo=new StringBuffer();
					while (sc.hasNext()) {
						deptIdInfo.append(sc.nextLine()); 
					}
					map.put(srcName, deptIdInfo.toString());
					sc.close();
					inputStream.close();
				}
			}
			if (StringUtils.isNotBlank(prefix)) {//不为空就添加前缀
				addPrefx(map, srcName, queryName, prefix);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	/**
	 * 给查询字段加前缀以便用于更多的地方
	 * @param map
	 * @param srcName 多来源字段名
	 * @param queryName 查询字段名
	 * @param prefix 前缀
	 * @return 增加前缀后的sql
	 */
	private Map<String,Object> addPrefx(Map<String,Object> map,String srcName,String queryName,String prefix){
		if (map.get(srcName)!=null&&map.get(srcName)!="") {
			String newfield=map.get(srcName).toString().replaceAll(queryName, prefix+queryName);
			map.put(srcName, newfield);
		}
		return map;
	}
	/**
	 * 获取审批文件路径
	 * @param request
	 * @param ivt_oper_listing
	 * @return
	 */
	public StringBuffer getSpFilePath(HttpServletRequest request,String ivt_oper_listing) {
		StringBuffer dest = new StringBuffer(getComIdPath(request));
		dest.append("/sp/").append(getEmployeeId(request)).append("/").
		append(ivt_oper_listing).append("/");
		return dest;
	}
	public File getSpFilePath(HttpServletRequest request,Object clerk_id,Object ivt_oper_listing) {
		StringBuffer dest = new StringBuffer(getComIdPath(request));
		dest.append("/sp/").append(clerk_id).append("/").
		append(ivt_oper_listing).append("/");
		File file=new File(dest.toString());
		if (!file.exists()) {
			file.mkdirs();
		}
		return file;
	}
	/**
	 * 获取审批文件临时存放路径
	 * @param request
	 * @return
	 */
	public StringBuffer getSpTemp(HttpServletRequest request) {
		StringBuffer pathname = new StringBuffer(getRealPath(request));
		pathname.append("/temp/").append(getComId()).append("/").append(getEmployeeId(request))
				.append("/").append("sp/");
		return pathname;
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	public String getCpTempPath(HttpServletRequest request) {
		return getRealPath(request)+"temp/"+getComId()+"/"+getEmployeeId(request)+"/cp/";
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	public String getXjTempPath(HttpServletRequest request) {
		return getRealPath(request)+"temp/"+getComId()+"/"+getEmployeeId(request)+"/xj/";
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	public String getUserpicTempPath(HttpServletRequest request) {
		String math=request.getParameter("math");
		if (math==null) {
			math="";
		}
		return getRealPath(request)+"temp/"+getComId()+"/userpic"+math+"/";
	}
	
	/**
	 * 获取会话日志文件路径
	 * @param request
	 * @param chatid 会话id
	 * @param date 指定日期
	 * @return  会话指定日期日志路径
	 */
	public String getChatLogPath(HttpServletRequest request, String chatid,String date) {
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("chat/").append(chatid).append("/");
		path.append(date).append(".log");
		File file=new File(path.toString());
		if (!file.exists()) {
			file.getParentFile().mkdirs();
		}
		return path.toString();
	}
	/**
	 * 获取会话日志文件路径
	 * @param request
	 * @param chatid 会话id
	 * @return 会话动天日志路径
	 */ 
	public String getChatLogPath(HttpServletRequest request, String chatid) {
		return getChatLogPath(request, chatid, DateTimeUtils.dateToStr());
	}
	
	/**
	 * 获取会话json文件路径
	 * @param request
	 * @return
	 */
	public File getChatIdPath(HttpServletRequest request) {
		return new File(getComIdPath(request) + "charids.txt");
	}
	/**
	 * 保存创建会话信息
	 * @param request
	 * @param json
	 */
	public void saveCreate_chat(HttpServletRequest request,JSONObject json) {
		// 把会话id写入到会话外部文件
		if (json.has("errmsg")&&"errmsg".equals(json.getString("errmsg"))) {
			return;
		} 
		File path = getChatIdPath(request);
		String str = getFileTextContent(path);
		JSONArray jsons = null;
		if (StringUtils.isNotBlank(str)) {
			jsons = JSONArray.fromObject(str);
		} else {
			jsons = new JSONArray();
		}
//		jsons.add(transToLowerObject(json));
		jsons.add(json);
		saveFile(path, jsons.toString());
		
	}
	/**
     * json大写转小写
     * 
     * @param jSONArray1 jSONArray1
     * @return JSONObject
     */
    public static JSONObject transToLowerObject(JSONObject jSONArray1) {
        JSONObject jSONArray2 = new JSONObject();
        Iterator<String> it = jSONArray1.keys();
        while (it.hasNext()) {
            String key = (String) it.next();
            Object object = jSONArray1.get(key);
            if (object.getClass().toString().endsWith("String")) {
                jSONArray2.accumulate(key.toLowerCase(), object);
            } else if (object.getClass().toString().endsWith("JSONObject")) {
                jSONArray2.accumulate(key.toLowerCase(), transToLowerObject((JSONObject) object));
            } else if (object.getClass().toString().endsWith("JSONArray")) {
                jSONArray2.accumulate(key.toLowerCase(), transToArray(jSONArray1.getJSONArray(key)));
            }
        }
        return jSONArray2;
    }
    /**
     * jsonArray转jsonArray
     * 
     * @param jSONArray1 jSONArray1
     * @return JSONArray
     */
    public static JSONArray transToArray(JSONArray jSONArray1) {
        JSONArray jSONArray2 = new JSONArray();
        for (int i = 0; i < jSONArray1.size(); i++) {
        	try {
        		Object jArray = jSONArray1.getJSONObject(i);
        		if (jArray.getClass().toString().endsWith("JSONObject")) {
        			jSONArray2.add(transToLowerObject((JSONObject) jArray));
        		} else if (jArray.getClass().toString().endsWith("JSONArray")) {
        			jSONArray2.add(transToArray((JSONArray) jArray));
        		}
			} catch (Exception e) {
			}
        }
        return jSONArray2;
    }
    /**
     * 将xml转换为json对象
     * @param xml 需要转换的xml文件
     * @return 转换后的json对象
     */
	public JSONObject xml2JSON(String xml) {
		 JSON json=new XMLSerializer().read(xml);
		 if (json!=null) {
			 JSONObject obj =JSONObject.fromObject(json.toString());
			 return obj;
		}
		 return null;
    }
	/**
	 * 获取微信成员的信息
	 * @param request
	 * @param userid 微信号
	 * @return
	 */
	public JSONObject getWeixinUserInfo(HttpServletRequest request,String userid) {
		WeixinUtil wei = new WeixinUtil();
		String info = wei.getEmployeeInfo(userid,getComId());
		JSONObject infojson = JSONObject.fromObject(info);
		return infojson;
	}
	/**
	 * 获取微信成员的头像
	 * @param request
	 * @param userid 微信号
	 * @return
	 */
	public String getWeixinImg(HttpServletRequest request,String userid) {
		JSONObject infojson=getWeixinUserInfo(request, userid);
		if (infojson!=null&&!infojson.isNullObject()) {
			if (infojson.has("avatar")) {
				return infojson.getString("avatar");
			}else{
				return infojson.getString("name");
			}
		}
		return "";
	}
	
	/**
	 * 保存会话聊天信息
	 * @param json
	 * @param request
	 */
	public void saveChatMsgLog(JSONObject json,HttpServletRequest request) {
		LoggerUtils.info(json);
		if (json.getInt("ItemCount")>1) {//消息总数大于1
			JSONArray jsons=json.getJSONArray("Item");
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject item=jsons.getJSONObject(i);
				if (item!=null) {
					Date d=new Date(Long.parseLong(item.getString("CreateTime")+"000"));
					item.put("CreateTime",DateTimeUtils.dateTimeToStr(d));
					JSONObject Receiver=item.getJSONObject("Receiver");
					if (Receiver!=null) {
						try {//保存会话记录到log文件中
							saveFile(getChatLogPath(request,Receiver.getString("Id")), item.toString()+",",true);
						} catch (Exception e) {}
					}
				}
			}
		}else{
			JSONObject item= json.getJSONObject("Item");
			if (item!=null) {
				Date d=new Date(Long.parseLong(item.getString("CreateTime")+"000"));
				item.put("CreateTime",DateTimeUtils.dateTimeToStr(d));
				JSONObject Receiver=item.getJSONObject("Receiver");
				if (Receiver!=null) {
					LoggerUtils.info(Receiver);
					item.put("weixinimg", getWeixinImg(request, item.getString("FromUserName")));
					try {
						saveFile(getChatLogPath(request,Receiver.getString("Id")), item.toString()+",",true);
					} catch (Exception e) {
						LoggerUtils.error(e.getMessage());
					}
				}
			}
		}
	}
	/**
	 * 更新json文件
	 * @param chatid
	 * @param request
	 * @param wei
	 */
	public void updateJsonFile(String chatid, HttpServletRequest request,WeixinUtil wei) {
		//1.根据会话id获取最新的成员列表
		String chat = wei.chatGet(chatid,getComId());
		JSONObject json =null;
		if (chat!=null) {
			json = JSONObject.fromObject(chat);
			saveChatInfo(request, chatid, json);
		}
	}
	/**
	 * 保存会话信息
	 * @param request
	 * @param chatid 会话id
	 * @param json 会话信息json对象
	 */
	public void saveChatInfo(HttpServletRequest request, Object chatid,JSONObject json) {
		if (json.has("errmsg")&&"errmsg".equals(json.getString("errmsg"))) {
			return;
		}
		//2.获取原始文件
				File path = getChatIdPath(request);
				String str = getFileTextContent(path);
				JSONArray jsons = JSONArray.fromObject(str);
				for (int i = 0; i < jsons.size(); i++) {
					//3.找到对应的会话数据
					if (chatid.equals(
							jsons.getJSONObject(i).getString("chatid"))) {
						//4.移除旧的会话信息
						jsons.remove(i);
						//5.增加新的会话信息
						if (json!=null) {
							jsons.add(json);
						}
					}
				}
				saveFile(path, jsons.toString());
	}
	/**
	 * 从请求中获取xml内容
	 * @param request
	 * @return 字符串型xml内容
	 * @throws IOException
	 */
	public String getXmlToRequest(HttpServletRequest request) throws IOException {
//		byte[] buffer = new byte[320*1024];
		InputStream in = request.getInputStream();
//		int length = in.read(buffer);
//		String encode = request.getCharacterEncoding();
//		byte[] data = new byte[length];
//		System.arraycopy(buffer, 0, data, 0, length);
//		String context = new String(data, encode);
//		in.close();
		 BufferedReader inbf=new BufferedReader(new InputStreamReader(in));
		 StringBuilder context = new StringBuilder();   
         String line = null;  
         while ((line = inbf.readLine()) != null) {
        	 context.append(line);   
           }
         inbf.close();
         LoggerUtils.info(context.toString());
		return context.toString();
	}
	public static void main(String[] args) throws Exception {
		File file=new File(ConfigFile.getProjectPath()+"weixin.txt");
		InputStream in=new FileInputStream(file);
		  BufferedReader inbf=new BufferedReader(new InputStreamReader(in));
		  StringBuilder sb = new StringBuilder();   
		         String line = null;  
		         while ((line = inbf.readLine()) != null) {   
		         sb.append(line);   
		           }
		         System.out.println(sb);
		         inbf.close();
	}
	/**
	 * 获取生产工段定义文件路径
	 * @param request
	 * @return
	 */
	public File getProductionSectionPath(HttpServletRequest request) {
		 String path=getComIdPath(request)+"ProductionSection.txt";
		 File file=new File(path);
		return file;
	}
	/**
	 * 获取生产工段定义文内容
	 * @param request
	 * @return 返回数组
	 */
	public String[] getProductionSection(HttpServletRequest request) {
		String ProductionSection=getFileTextContent(getProductionSectionPath(request));
		if (StringUtils.isNotBlank(ProductionSection)) {
			String[] names=ProductionSection.split(",");
			if (names!=null&&names.length>0) {
			return names;
			}
		}
		return null;
	}
	/**
	 * 获取生产工段定义文内容
	 * @param request
	 * @return 返回list集合
	 */
	public List<String> getProductionSectionlist(HttpServletRequest request) {
		String[] names=getProductionSection(request);
		if (names!=null&&names.length>0) {
			return Arrays.asList(names);
		}
		return null;
	}
	/**
	 * 获取指定工段的索引位置
	 * @param request 
	 * @param obj 查找工段值
	 * @return
	 */
	public int getProductionSectionIndex(HttpServletRequest request, Object obj) {
		List<String> list= getProductionSectionlist(request);
		if (list!=null&&list.size()>0) {
			return list.indexOf(obj);
		}
		return -1;
	}
	/**
	 * 获取线上客户支付数据
	 * @param customer_id
	 * @param recieved_id
	 * @return
	 */
	public File getPayInfoFilePath(Object customer_id,Object recieved_id) {
		StringBuffer path=new StringBuffer(getComIdPath(getRequest()));
		path.append("/pay/");
//		if (customer_id==null||"".equals(customer_id)) {
//			File file=new File(path.toString());
//			file.listFiles();
//		}.append(customer_id).append("/")
		path.append(recieved_id);
		path.append("/order.log");
		File file=new File(path.toString());
		if (!file.exists()) {
			file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 获取线上客户支付数据
	 * @param customer_id
	 * @param recieved_id
	 * @return
	 */
	public File getPayMsgFilePath(Object customer_id,Object recieved_id) {
		StringBuffer path=new StringBuffer(getComIdPath(getRequest()));
		path.append("/pay/").append(customer_id).append("/").append(recieved_id);
		path.append("/msg.log");
		File file=new File(path.toString());
		if (!file.exists()) {
			file.getParentFile().mkdirs();
		}
		return file;
	}
	
	/**
	 * 获取签名相关文件路径
	 * @param request
	 * @return
	 */
	public StringBuffer getIouPath(HttpServletRequest request,String customerId) {
		StringBuffer buffer=new  StringBuffer(getComIdPath(request));
		buffer.append(customerId).append("/iou/");
		return buffer;
	}
	
	public StringBuffer getEmployeeImgPath(HttpServletRequest request,String clerk_id) {
		StringBuffer buffer=new  StringBuffer(getComIdPath(request));
		buffer.append(clerk_id).append("/img/");
		return buffer;
	} 
	/**
	 * 获取生产工序类别定义文件路径
	 * @param request
	 * @return
	 */
	public File getWorkTypePath(HttpServletRequest request) {
		 String path=getComIdPath(request)+"WorkType.txt";
		 File file=new File(path);
		return file;
	}
	/**
	 * 获取生产工序类别定义文内容
	 * @param request
	 * @return
	 */
	public String[] getWorkType(HttpServletRequest request) {
		String WorkType=getFileTextContent(getWorkTypePath(request));
		if (StringUtils.isNotBlank(WorkType)) {
			return WorkType.split(",");
		}
		return null;
	}
	/**
	 * 订单评价信息路径
	 * @param request
	 * @param orderNo 
	 * @return 评价信息
	 */
	public File getOrderEvalFilePath(HttpServletRequest request,Object orderNo,String type) {
		StringBuffer buffer=new StringBuffer(getComIdPath(request));
		buffer.append("eval/").append(type).append(orderNo).append(".log");
		File file=new File(buffer.toString());
		if(!file.getParentFile().exists()){
			file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 订单评价信息路径
	 * @param request
	 * @param orderNo 订单编号
	 * @param item_id 产品id
	 * @return 评价信息路径
	 */
	public File getOrderEvalFilePath(HttpServletRequest request,Object com_id,Object orderNo, Object item_id) {
		if(com_id==null){
			com_id=getComId();
		}
		StringBuffer buffer=new StringBuffer(getComIdPath(request));
		buffer.append("eval/").append(orderNo).append("/").append(item_id).append(".log");
		File file=new File(buffer.toString());
		if(!file.getParentFile().exists()){
			file.getParentFile().mkdirs();
		}
		return file;
	}
	
	/**
	 * 获取存在txt
	 * @param request
	 * @param phone
	 * @return
	 */
	public String getTxtVerificationCode(HttpServletRequest request,String phone) {
		if(StringUtils.isBlank(phone)){
			return "";
		}
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("VerificationCode/")
		.append(phone.trim()).append(".txt");
		return path.toString();
	}
	/**
	 *  获取产品浏览记录
	 * @param request
	 * @param date 记录日期
	 * @return 产品浏览记录日志路径
	 */
	public String getProductViewLog(HttpServletRequest request,String item_id) {
		StringBuffer buffer=new StringBuffer(getRealPath(request));
		String com_id=request.getParameter("com_id");
		buffer.append(com_id).append("/viewlog/").append(item_id).append(".log");
		File file=new File(buffer.toString());
		mkdirsDirectory(file);
		return file.getPath();
	}
	/**
	 * 获取产品列表分页数据
	 * @param productService
	 * @param request
	 */
	public synchronized void proPageList(IProductService productService, HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		PageList<Map<String, Object>> pages= productService.findQuery(map);
		request.setAttribute("pages", pages);
		getProductImgNum(pages.getRows());
	}
	/**
	 * 获取产品数据对应的图片数量列表
	 * @param list
	 */
	public void getProductImgNum(List<Map<String,Object>> list) {
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map = iterator.next();
			Object item_id=map.get("item_id");
			StringBuffer buffer=new StringBuffer(getComIdPath(getRequest()));
			buffer.append("img/").append(item_id).append("/");
			File cpfile=new File(buffer.toString()+"cp/");
			if (cpfile.exists()) {
				if (cpfile.listFiles()!=null) {
					long len=cpfile.listFiles().length;
					map.put("cpnum", len);
				}
			}else{
				map.put("cpnum", 0);
			}
			File xjfile=new File(buffer.toString()+"xj/");
			if (xjfile.exists()) {
				if (xjfile.listFiles()!=null) {
					long len=xjfile.listFiles().length;
					map.put("xjnum", len);
				}
			}else{
				map.put("xjnum", 0);
			}
			///产品缩略图
			xjfile=new File(buffer.toString()+"sl.jpg");
			if (xjfile.exists()) {
				map.put("slnum", 1);
			}else{
				map.put("slnum", 0);
			}
			
		}
	}
	/**
	 * 获取提货地点文件历史路径
	 * @param request
	 * @return
	 */
	public String getTHDDTxtPath(HttpServletRequest request) {
		File file=new File(getComIdPath(getRequest())+"didian.txt");
		return file.getPath();
	}
	/**
	 * 从收款单号中获取出订单产品的id
	 * @param recieved_id  recieved_id|customer_id
	 * @param request
	 * @return 订单产品的id
	 */
	public List<Integer> getOrderSeedsByRecieved(String recieved_id) {
		if(StringUtils.isNotBlank(recieved_id)){
			String[] rids=recieved_id.split(",");
			if(rids.length>0){
				List<Integer> seds=new ArrayList<Integer>();
				for (String rid : rids) {
					if (rid.split("\\|").length==2) {
						File path=getRecievedMemo(getRequest(), rid.split("\\|")[0], rid.split("\\|")[1]);
						String txt=getFileTextContent(path);
						txt=txt.split("订单编号:")[1];
						if(StringUtils.isNotBlank(txt)){
							if(!txt.startsWith("[")){
								txt="["+txt+"]";
							}
							JSONArray jsons=JSONArray.fromObject(txt);
							for (int i = 0; i < jsons.size(); i++) {
								JSONObject json=jsons.getJSONObject(i);
								if (json.has("seeds_id")) {
									if(json.getString("com_id").equals(getComId())){
									seds.add(json.getInt("seeds_id"));
									}
								}
							}
							return seds;
						}
					}
					
				}
			}
		}
		return null;
	}
	/**
	 * 客户收货地址
	 * @param request
	 * @param customer_id 客户编码
	 * @return
	 */
	public String getFHDZPath(HttpServletRequest request, String customer_id) {
		StringBuffer buffer=new StringBuffer();
		buffer.append(getComIdPath(request)).append("fhdz/").append(customer_id).append(".log");
		File file=new File(buffer.toString());
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		return buffer.toString();
	}
	/**
	 * 获取订单产品的历史记录
	 * @param orderNo 订单编号
	 * @param item_id 产品内码
	 * @return 订单产品编号加产品id日志存放路径001/orderHistory/orderNo/item_id.log
	 */
	public String getOrderHistoryPath(Object orderNo,Object item_id) {
		StringBuffer path=new StringBuffer(getRealPath(getRequest())).append(getComId());
		path.append("/orderHistory/").append(orderNo).append("/").append(item_id).append(".log");
		File file=new File(path.toString());
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		return path.toString();
	}
	/**
	 * 获取产品生产过程历史消息文件路径
	 * @param pmNo 生产计划编码
	 * @param item_id 产品内码
	 * @return 产品生产历史消息路径
	 */
	public String getPMHistoryPath(Object pmNo, Object item_id) {
		 StringBuffer path=new StringBuffer(getComIdPath(getRequest()));
		 path.append(pmNo).append("/").append(item_id).append(".log");
		 File file=new File(path.toString());
		 if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		return path.toString();
	}
	/**
	 * 获取需求文件夹的路径
	 * @param request
	 * @param orderNo 报价单号
	 * @return
	 */
	public File getTailorInfoPath(HttpServletRequest request, String orderNo)throws Exception {
		if(StringUtils.isBlank(orderNo)){
			throw new RuntimeException("报价单号不能为空!");
		}
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("tailorInfo/").append(orderNo).append("/");
		File file=new File(path.toString());
		mkdirsDirectory(null);
		return file;
	}
	/**
	 * 获取需求文件json文本文件路径
	 * @param request
	 * @param orderNo 报价单号
	 * @return 需求文件json文本文件路径
	 */
	public File getTailorInfoJsonPath(HttpServletRequest request, String orderNo)throws Exception  {
		File file=new File(getTailorInfoPath(request, orderNo).getPath()+"/info.json");
		return file;
	}
	/**
	 * 获取需求附件图片路径
	 * @param request
	 * @param orderNo 报价单号
	 * @return 需求附件图片路径集合格式,包含多个图片路径地址
	 */
	public List<String> getTailorInfoImgs(HttpServletRequest request, String orderNo)throws Exception  {
		File file=getTailorInfoPath(request, orderNo);
		File[] fs= file.listFiles();
		List<String> imgs=new ArrayList<String>();
		for (File item : fs) {
			if (item.isFile()&&!item.getName().contains("json")) {
				String img="/"+getComId()+item.getPath().split("\\\\"+getComId())[1].replaceAll("\\\\", "/");
				imgs.add(img);
			}
		}
		return imgs;
	}
	/**
	 * 创建指定文件的父级目录
	 * @param file 文件路径
	 */
	public static synchronized void mkdirsDirectory(File file) {
		if(!file.getParentFile().exists()){
			file.getParentFile().mkdirs();
		}
	}
	
	/**
	 * 获取指定时间,供应商上报产品图片
	 * @param request
	 * @param date 时间
	 * @param vendor_id 供应商编码
	 * @param item_id 产品编码
	 * @return
	 */
	public String getUpitemItemImgPath(HttpServletRequest request,Object date,Object vendor_id,Object item_id) {
		return  getComIdPath(request)+"upitem/"+date+"/"+vendor_id+"/"+item_id+"/";
	}
	/**
	 * 获取显示字段路径
	 * @param request
	 * @param fileName 文件名
	 * @return
	 */
	public File getShowFiledPath(HttpServletRequest request, Object fileName) {
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("filed/").append(fileName).append(".json");
		File file=new File(path.toString());
		if(!file.getParentFile().exists()){
			file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 获取指定维护内容项的列表或者维护界面展示,用于动态生成相关字段
	 * @param request
	 * @return
	 */
	public JSONArray sort_id(HttpServletRequest request,String fileName) {
		File file=getShowFiledPath(request, fileName);
		if(file.exists()){
			String str=getFileTextContent(file);
			if(StringUtils.isNotBlank(str)){
				if(!str.startsWith("[")){
					str="["+str+"]";
				}
				return JSONArray.fromObject(str);
			}
		}
		return null;
	}
	/**
	 * 获取显示字段列表
	 * @param request
	 * @param fileName
	 * @return
	 */
	public JSONArray getShowFiledList(HttpServletRequest request,String fileName) {
		File file=getShowFiledPath(request, fileName);
		if(file.exists()){
			String str=getFileTextContent(file);
			if(StringUtils.isNotBlank(str)){
				if(!str.startsWith("[")){
					str="["+str+"]";
				}
				return JSONArray.fromObject(str);
			}
		}
		return null;
	}
	/**
	 * 获取显示字段从json文件中
	 * @param request
	 * @param fileName 表类型
	 * @param idName 内码名称
	 * @param type 显示字段的类型 list/edit
	 * @return
	 */
	 public StringBuffer getFiledNameBYJson(HttpServletRequest request,String fileName,String idName,String type) {
		 JSONArray info=getShowFiledList(request,fileName);
		StringBuffer filed=new StringBuffer();
		if (StringUtils.isBlank(type)) {
			type="list";
		}
		if (info!=null&&info.size()>0) {
			for (int i = 0; i < info.size(); i++) {
				JSONObject json=info.getJSONObject(i);
				if(json.getBoolean(type)){
					filed.append("ltrim(rtrim(t1.").append(json.getString("filed")).append(")) as ").append(json.getString("filed")).append(" ,");
				}
			}
			if (StringUtils.isNotBlank(filed.toString())) {
				filed.append("ltrim(rtrim(isnull(t1.").append(idName).append(",''))) as ").append(idName);
			}else{
				filed.append("*");
			}
		}else{
			filed.append("*");
		}
		return filed;
	}
	 /**
		 * 获取支付订单信息
		 * @param request
		 * @param orderNo
		 * @return
		 */
		public File getPayOrderInfo(HttpServletRequest request, Object orderNo) {
			File file=new File(getComIdPath(request)+"payinfo/"+orderNo+".log");
			mkdirsDirectory(file);
			return file;
		}
		/**
		 * 获取文章消息发送信息存放历史路径
		 * @param request
		 * @param clerk_id 员工编码
		 * @param date 发送时间
		 * @return 001/article/clerk_id/sendHistory/147.log
		 */
		public String getArticleSendHistoryPath(HttpServletRequest request,String clerk_id, Long date) {
			File file=new File(getComIdPath(request)+"/article/"+clerk_id+"/sendHistory/"+date+".log");
			mkdirsDirectory(file);
			return file.getPath();
		}
		/**
		 * 获取指定文件夹下的文件内容
		 * @param file 指定文件夹 必须
		 * @param filter 文件后缀名 必须
		 * @param numstr 每次获取数 否 默认为10
		 * @param desc 排序 否 默认desc倒序
		 * @param pagestr 第几页  否 ,默认为0
		 * @param begin 开始时间 否
		 * @param end 结束时间 否
		 * @param searchKey 关键词 否
		 * @return 指定文件内容集合
		 */
		public List<String> getArticleFileList(File file,final String filter, 
				String numstr, String desc, String pagestr,
				final Long begin,final Long end, String searchKey)throws Exception {
			List<String> list = new ArrayList<String>();
			if (file.exists()) {
				if(!file.isDirectory()){
					throw new RuntimeException("不是一个文件夹路径");
				}
				File[] fs = file.listFiles(new FileFilter() {//
					@Override
					public boolean accept(File pathname) {
						if (StringUtils.isNotBlank(filter)) {
							String s = pathname.getName().toLowerCase();
							if (s.endsWith(filter)) {//指定的后缀名文件
								//按照时间段查询,去除时间段以外的数据
								if (begin!=null&&end!=null) {
									Long n=Long.parseLong(FilenameUtils.getBaseName(pathname.getName()));
									if(begin<=n&&end>=n){
										return true;
									}else{
										return false;
									}
								}else{
									return true;
								}
							} else {
								return false;
							}
						}
						return true;
					}
				});
				if (fs != null && fs.length > 0) {
					List<File> fslist = Arrays.asList(fs);
					if (fslist != null && fslist.size() > 0) {
						Integer num = 10;
						if (StringUtils.isNotBlank(numstr)) {
							num = Integer.parseInt(numstr);
						}
						Integer page = 0;
						if (StringUtils.isNotBlank(pagestr)) {
							page = Integer.parseInt(pagestr)*num;
						}
						if (page < fslist.size()) {
							//获取筛选后的数据,读取文件内容到List
							int len=0;
							for (int i = page; i < fslist.size(); i++) {
								if (len >= num) {
									break;
								}else{
									String str = getFileTextContent(fslist.get(i));
									if (StringUtils.isNotBlank(str)) {
										if(str.startsWith(",")){
											str=str.substring(1, str.length());
										}
										if(str.endsWith(",")){
											str=str.substring(0, str.length()-1);
										}
										if (StringUtils.isNotBlank(searchKey)) {//去除关键词中没有的数据
											boolean b=str.toString().contains(searchKey);
											if(!b){
												continue;
											}
										}
										list.add(str);
										len=len+1;
									}
								}
							}
							//排序
							if (StringUtils.isBlank(desc) || "desc".equals(desc)) {
								Collections.reverse(fslist);
							} else {
								Collections.sort(fslist);
							}
						}
					}
				}
			}else{
				throw new RuntimeException("路径不存在");
			}
			return list;
		}
		
		/**
		 * 检查注册必须参数
		 * @param request
		 * @param user_id
		 * @return 通过返回true,不通过返回false
		 */
		public Map<String,Object> checkRegisterParam(HttpServletRequest request,String user_id) {
			boolean b=false;
			Integer error_code=null;
			String msg=null;
			String code = request.getParameter("verificationCode");
			String user_password = request.getParameter("pwd");
			String password = request.getParameter("confirmPwd");
			VerificationCode verification_code = (VerificationCode) request
					.getSession().getAttribute(ConfigFile.registerVerificationCode);
			String vercode=getFileTextContent(getTxtVerificationCode(request, user_id));
			if(StringUtils.isBlank(vercode)){
				vercode="";
			}
			if(!"1111".equals(code)){
				 if(verification_code!=null){
					 if(code.equalsIgnoreCase(verification_code.getCode())){
						b=true;
					 }else{
						msg="验证码不正确!";
						b=false;
						error_code = 100;// 验证码 错误
					 }
				}else if(vercode.equals(code)){
					b=true;
				}else{
					msg="验证码不正确!";
					b=false;
					error_code = 100;// 验证码 错误
				}
			}
			if (b) {
				if(StringUtils.isBlank(user_id)){
					msg="请输入注册手机号!";
					error_code = 101;// 请输入注册手机号
					b=false;
				}else if(user_id.trim().length()!=11){
					b=false;
					msg="手机号长度不足!";
					error_code = 101;// 请输入注册手机号
				}else{
					b=true;
				}
			}
			if (b) {
				if(StringUtils.isNotBlank(user_password)){
					if (StringUtils.isNotBlank(password)&&!password.equals(user_password)) {
						b=false;
						msg="两次密码不一致!";
						error_code = 104;// 两次密码不一致
					}else{
						b=true;
					}
				}
			}
			Map<String,Object> map=new HashMap<>();
			map.put("b", b);
			map.put("msg", msg);
			map.put("error_code", error_code);
			return map;
		}
		@SuppressWarnings("unchecked")
		public JSONArray getProcessNameNew(HttpServletRequest request) {
			String msg=getFileTextContent(getSalesOrderProcessNamePath(request));
			LoggerUtils.error(msg);
			if(StringUtils.isNotBlank(msg)&&msg.startsWith("[")){
				JSONArray jsons=JSONArray.fromObject(msg);
					JSONArray htmls=new JSONArray();
					for (Iterator<JSONObject> iterator = jsons.iterator(); iterator.hasNext();) {
						JSONObject json = iterator.next();
						if (json.has("show")&&json.getBoolean("show")) {
							htmls.add(json.get("processName"));
						}
					}
					return htmls;
			}
			return null;
		}
}
