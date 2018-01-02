package com.qianying.controller.cms;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
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
import com.qianying.controller.FilePathController;
import com.qianying.page.PageList;
import com.qianying.service.IManagerService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.FileOperate;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;
/**
 * 
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/temp")
public class TempletController extends FilePathController {

	@Autowired
	IManagerService managerService;
	
	@Autowired
	ISystemParamsService systemParamsService;
	
	/**
	 * 跳转到内容发布页面
	 * 
	 * @param request
	 * @return 跳转页面
	 */
	@RequestMapping("contentPublishing")
	public String contentPublishing(HttpServletRequest request) {
		return "contentPublishing";
	}

	/**
	 * 跳转到广告发布页面
	 * 
	 * @param request
	 * @param type
	 *            1-首页通栏广告,3-视频广告
	 * @return 跳转页面
	 */
	@RequestMapping("imgPublishing")
	public String imgPublishing(HttpServletRequest request) {
		String type = request.getParameter("type");
		request.setAttribute("type", type);
		if ("3".equals(type)) {
			return "mp4Publishing";
		}
		return "imgPublishing";
	}

	/**
	 * 跳转到模板发布页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("templetPublishing")
	public String templetPublishing(HttpServletRequest request) {
		return "templetPublishing";
	}

	public static List<Long> cms_id = new ArrayList<Long>();

	private void moveFile(StringBuffer srcBuffer, StringBuffer destBuffer,
			HttpServletRequest request) {
		File srcDir = new File(srcBuffer.toString());
		if (srcDir.exists()) {
			moveFile(srcDir, destBuffer, request);
		}
	}

	private void moveFile(File srcDir, StringBuffer destBuffer,
			HttpServletRequest request) {
		File[] files = srcDir.listFiles();
		for (File srcFile : files) {
			if (srcFile.isFile()) {// 如果是文件就获取源文件和目标文件的修改时间
				// 获取源文件的修改时间
				String srclastdate = FileOperate.getModifiedTime(srcFile);
				// 分解
				String desturl = srcFile.getPath().split(
						getTemplateName(request))[1];
				desturl = destBuffer.toString() + desturl;
				File destFile = new File(desturl);
				String destlastdate = FileOperate.getModifiedTime(destFile);
				if (!srclastdate.equals(destlastdate)) {
					if (destFile.exists() && destFile.isFile()) {
						destFile.delete();
					}
					try {
						FileUtils.copyFile(srcFile, destFile);
					} catch (IOException e) {
						LoggerUtils.error(e.getMessage());
					}
				}
			} else {
				moveFile(srcFile, destBuffer, request);
			}
		}
	}

	/**
	 * 保存生成文件
	 * 
	 * @param request
	 * @param cardId
	 *            临时文件路径
	 * @param imgurl
	 *            旧文件路径
	 * @param builder
	 *            新的文件路径
	 * @throws IOException
	 */
	private void saveUploadFile(HttpServletRequest request, String cardId,
			String imgurl, StringBuilder builder) throws IOException {
		if (cardId.equalsIgnoreCase(imgurl)) {
			return;
		}
		File destFile = new File(getRealPath(request, "/") + "/"
				+ builder.toString());
		File srcFile = new File(getRealPath(request, "/") + cardId);
		if (srcFile.exists()) {
			// 1.删除旧的图片
			if (imgurl != null) {
				File file = new File(getRealPath(request, "/") + imgurl);
				if (file.exists() && file.isFile()) {
					file.delete();
				}
			}
			if (!destFile.getParentFile().exists()) {
				destFile.getParentFile().mkdirs();
			}
			FileUtils.moveFile(srcFile, destFile);
		}
	}

	private void delFile(String src) {
		File file = new File(src);
		LoggerUtils.error(file.getPath());
		if (file.exists() && file.isFile()) {
			file.delete();
		}
	}

	private StringBuffer getJsonToFile(File srcFile) throws IOException {
		StringBuffer builder = null;
		if (srcFile.exists() && srcFile.isFile()) {
			builder = new StringBuffer();
			InputStream inStream = new FileInputStream(srcFile);
			// 读取文件的时候也需要设置文件编码为utf-8,要不会造成中文乱码从而影响后续操作
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					inStream, "UTF-8"));
			String line = null;
			try {
				while ((line = reader.readLine()) != null) {
					builder.append(line);
					builder.append("\n");
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					inStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return builder;
	}

	@RequestMapping("saveAnliImg")
	@ResponseBody
	public ResultInfo saveAnliImg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String imgurl=request.getParameter("imgurl");
			String htmlname=request.getParameter("htmlname");
			String type=request.getParameter("type");
			if (StringUtils.isNotBlank(imgurl)
					&& StringUtils.isNotBlank(htmlname)) {
				StringBuffer buffer = new StringBuffer(getRealPath(request,
						null)).append("/pc/content/");
				buffer.append(getUserInfo_Id(request)).append("/")
						.append(getTemplateName(request)).append("/")
						.append("article/").append(type).append("/")
						.append(htmlname).append(".json");
				try {
					StringBuilder builder = new StringBuilder();
					File srcFile = new File(buffer.toString());
					if (srcFile.exists()) {
						// ///////////////
						InputStream inStream = new FileInputStream(srcFile);
						// 读取文件的时候也需要设置文件编码为utf-8,要不会造成中文乱码从而影响后续操作
						BufferedReader reader = new BufferedReader(
								new InputStreamReader(inStream, "UTF-8"));
						String line = null;
						try {
							while ((line = reader.readLine()) != null) {
								builder.append(line);
								builder.append("\n");
							}
						} catch (IOException e) {
							e.printStackTrace();
						} finally {
							try {
								inStream.close();
							} catch (IOException e) {
								e.printStackTrace();
							}
						}
						// /////////////////////
						LoggerUtils.info(builder.toString());
						JSONObject json = JSONObject.fromObject(builder
								.toString());
						json.put("img", imgurl);
						OutputStreamWriter outputStream = null;
						outputStream = new OutputStreamWriter(
								new FileOutputStream(srcFile), "UTF-8");
						outputStream.write(json.toString().replaceAll("_temp",
								""));
						outputStream.flush();
						outputStream.close();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	// private void saveJsonList(String path) {
	// FileFilter filefilter = new FileFilter() {
	// public boolean accept(File file) {
	// if (file.getName().endsWith(".json")) {
	// return true;
	// }
	// return false;
	// }
	// };
	// File jsonfile = new File(path);
	// File[] jsons = jsonfile.listFiles();
	// for (File file : jsons) {
	// if (file.isDirectory()) {
	// File[] jsoninfos= file.listFiles(filefilter);
	// System.out.println(file);
	// }
	// }
	// }

	/**
	 * 移动存储在文件夹里面的临时内为正式内容
	 * 
	 * @param request
	 * @param url
	 *            相对路径名称
	 * @param foldername
	 *            文件夹名称
	 */
	private void moveAndSaveTemp(String path) {
		File img = new File(path);
		File[] imgs = img.listFiles();
		for (int i = 0; i < imgs.length; i++) {
			if (imgs[i].exists() && imgs[i].isFile()) {
				if (imgs[i].getPath().contains("_temp")) {
					String imgurl = imgs[i].getPath().replace("_temp", "");
					File file = new File(imgurl);
					if (file.exists() && file.isFile()) {
						file.delete();
					}
					imgs[i].renameTo(new File(imgurl));
				}
			} else {
				moveAndSaveTemp(imgs[i].getPath());
			}
		}
	}

	/**
	 * 获取指定文件夹下按照过滤后的总数
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getArticleCount")
	@ResponseBody
	public ResultInfo getArticleCount(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String path = request.getParameter("path");// 目标文件夹
			final String filter = request.getParameter("filter");// 过滤
			File file = new File(getRealPath(request) + path + "/");
			if (file.exists()) {
				File[] fs = file.listFiles(new FileFilter() {
					@Override
					public boolean accept(File pathname) {
						if (StringUtils.isNotBlank(filter)) {
							String s = pathname.getName().toLowerCase();
							if (s.endsWith(filter)) {
								return true;
							} else {
								return false;
							}
						}
						return true;
					}
				});
				if (fs != null && fs.length > 0) {
					msg = fs.length + "";
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
	 * 获取业务员发布的文章列表
	 * @param request
	 * @return 文章json列表信息
	 * @throws Exception 
	 */
	@RequestMapping("getArticleListByEmployee")
	@ResponseBody
	public List<String> getArticleListByEmployee(HttpServletRequest request) throws Exception {
		//1.获取权限,是否只看自己
		String clerk_id=request.getParameter("clerk_id");
		String numstr = request.getParameter("num");// 每次加载数
		String zhiding = request.getParameter("zhiding");// 每次加载数
		if(StringUtils.isBlank(numstr)){
			numstr="10";
		}
		String pagestr = request.getParameter("page");// 开始记录数
		if(StringUtils.isBlank(pagestr)){
			pagestr="0";
		}
		String desc = request.getParameter("desc");
		if (StringUtils.isBlank(clerk_id)) {
			clerk_id=getEmployeeId(request);
			if(StringUtils.isNotBlank(clerk_id)){
				clerk_id=clerk_id+"/";
			}else{
				clerk_id="";
			}
		}
		Map<String,String> map=getQueryKeyAndValue(request);
		Long begin=DateTimeUtils.strToDateTime(map.get("beginTime")).getTime();
		Long end=DateTimeUtils.strToDateTime(map.get("endTime")).getTime();
		String searchKey=request.getParameter("searchKey");
		List<String> list=new ArrayList<>();
		File file = new File(getComIdPath(request)+"article/"+clerk_id);
		if ("history".equals(map.get("type"))) {//获取历史消息信息内容
			file = new File(file.getPath()+"/sendHistory/");
			if(file.exists()){
				List<String> ls=getArticleFileList(file, "log", numstr, desc, pagestr, begin, end,searchKey);
				if (ls!=null&&ls.size()>0) {
					list.addAll(ls);
				}
				return list;
			}
		}
		if (file.exists()) {
			for (int i = 0; i < file.listFiles().length; i++) {//1484
				File item=file.listFiles()[i];
				if (item.isDirectory()) {
					if (!"history".equals(map.get("type"))) {//如果获取的不是历史发送信息,
						boolean b=item.getPath().contains("sendHistory");
						if(b){//就跳出当前循环,不获取历史消息文件里面的内容
							continue;
						}
					}
					if(item.getName().startsWith("E")){
						continue;
					}
					Long n=Long.parseLong(item.getName());
					if(begin<=n&&end>=n){
						List<String> msg=getArticleFileList(item,"json", numstr, desc, pagestr,zhiding);
						if (msg!=null&&msg.size()>0) {
							if (StringUtils.isBlank(desc) || "desc".equals(desc)) {
								Collections.reverse(msg);
							} else {
								Collections.sort(msg);
							}
							if (StringUtils.isNotBlank(searchKey)) {
								boolean b=msg.toString().contains(searchKey);
								if(!b){
									continue;
								}
							}
							list.addAll(msg);
						}
					}
				}
			}
		}
		if (StringUtils.isBlank(desc) || "desc".equals(desc)) {
			Collections.reverse(list);
		} else {
			Collections.sort(list);
		}
		return list;
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getArticleInfo")
	@ResponseBody
	public ResultInfo getArticleInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(isNotMapKeyNull(map, "htmlname")){
				StringBuffer path=new StringBuffer(getRealPath(request));
				path.append(map.get("htmlname").toString().replaceAll("html", "json"));
				File file=new File(path.toString());
				if (file.exists()) {
					msg= getFileTextContent(file);
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
	 * 获取文章列表
	 * @param file 文章所在文件夹
	 * @param filter 获取指定类型文件
	 * @param numstr 每次加载数
	 * @param desc 排序
	 * @param pagestr 当前页
	 * @return 指定类型文件内容列表
	 */
	private List<String> getArticleFileList(File file,final String filter, String numstr, String desc, String pagestr,final String zhiding) {
		List<String> list = new ArrayList<String>();
		if (file.exists()) {
			File[] fs = file.listFiles(new FileFilter() {
				@Override
				public boolean accept(File pathname) {
					if (StringUtils.isNotBlank(filter)) {
						String s = pathname.getName().toLowerCase();
						if (s.endsWith(filter)) {
							if(StringUtils.isNotBlank(zhiding)){
								if(!s.startsWith(zhiding)){
									return false;
								}
							}
							return true;
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
					if (StringUtils.isBlank(desc) || "desc".equals(desc)) {
						Collections.reverse(fslist);
					} else {
						Collections.sort(fslist);
					}
					Integer page = 0;
					if (StringUtils.isNotBlank(pagestr)) {
						page = Integer.parseInt(pagestr)*num;
					}
					if (page < fslist.size()) {
						int len=0;
						for (int i = page; i < fslist.size(); i++) {
							if (len >= num) {
								break;
							}else{
								String str = getFileTextContent(fslist.get(i));
								list.add(str);
								len=len+1;
							}
						}
					}
				}
				list.add("{\"count\":"+fslist.size()+"}");
			}
		}
		return list;
	}
	
	/**
	 * 获取指定文件夹下的文件列表
	 * @param request
	 * @param path 目标文件夹
	 * @param filter 过滤文件类型,用于只获取json或者html文件
	 * @param num 每次加载数
	 * @param page 开始记录数 0,0+num,num*,0,10,20,30
	 * @param desc 排序
	 * @return 文件列表
	 */
	@RequestMapping("getArticleList")
	@ResponseBody
	public List<String> getArticleList(HttpServletRequest request) {
		try {
			
			String path = request.getParameter("path");// 目标文件夹
			if (StringUtils.isBlank(path)) {
				throw new RuntimeException("参数错误,没有指定路径!");
			}
			String filter = request.getParameter("filter");// 过滤
			String numstr = request.getParameter("num");// 每次加载数
			String zhiding = request.getParameter("zhiding");// 每次加载数
			if(StringUtils.isBlank(numstr)){
				numstr="10";
			}
			if(StringUtils.isBlank(filter)){
				filter="json";
			}
			String pagestr = request.getParameter("page");// 开始记录数
			if(StringUtils.isBlank(pagestr)){
				pagestr="0";
			}
			String desc = request.getParameter("desc");
			File file = new File(getRealPath(request) + path + "/");
			return getArticleFileList(file, filter, numstr, desc, pagestr,zhiding);
		} catch (Exception e) {
			Map<String,Object> map=getKeyAndValue(request);
			String str=e.getMessage()+"-->"+map.toString()+"-->"+LogUtil.getIpAddr(request);
			File file=new File(getRealPath(request)+"error/"+DateTimeUtils.dateToStr()+".log");
			saveFile(file.getPath(), str,true);
			LoggerUtils.error(e.getMessage());
			return null;
		}
	}

	/**
	 * 获取文章分页信息从数据表中
	 * @param request
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("getArticlePage")
	@ResponseBody
	public PageList<Map<String,Object>> getArticlePage(HttpServletRequest request) throws Exception {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(isNotMapKeyNull(map, "clerk")){//查询员工文章记录
			///是否只看自己
			if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
				if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
		}
		if (isMapKeyNull(map, "desc")) {
			map.put("desc", "desc");
		}
		if (getEmployee(request)==null) {
			if (isMapKeyNull(map, "show")) {
				map.put("show","1");
			}
		}
		return managerService.getArticlePage(map);
	}
	/**
	 *  获取文章详细信息共数据表中
	 * @param request
	 * @param htmlname
	 * @param projectName
	 * @param projectType
	 * @return
	 */
	@RequestMapping("getArticleInfoData")
	@ResponseBody
	public Map<String,Object> getArticleInfoData(HttpServletRequest request) throws Exception {
		Map<String,Object> map=getKeyAndValue(request);
		return managerService.getArticleInfoData(map);
	}
	/**
	 * 保存在线编辑的内容到html文件中
	 * 
	 * @param request
	 * @param text
	 *            html文件内容
	 * @param url
	 *            存储地址,不写就新增加一个
	 * @return 执行结果
	 */
	@RequestMapping("saveArticle")
	@ResponseBody
	public ResultInfo saveArticle(HttpServletRequest request) {
		String url=request.getParameter("url");
		String text=request.getParameter("text");
		StringBuffer buffer = new StringBuffer(getRealPath(request));
		String item_id=request.getParameter("item_id");
		ResultInfo info = new ResultInfo(true);
		if (StringUtils.isNotBlank(item_id)) {
			buffer.append(request.getParameter("url"));
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("detail_cms", 1);
			map.put("item_id", item_id);
			managerService.insertSql(map, 1, "ctl03001", "item_id", item_id);
		}else{
			String type = request.getParameter("type");// 文章类型
			String projectName = request.getParameter("projectName");
			String releaseTime = request.getParameter("releaseTime");
			if (StringUtils.isBlank(type)) {
				type = "1";
			}
			if (StringUtils.isBlank(url)) {
				if (StringUtils.isNotBlank(releaseTime)) {
					SimpleDateFormat dateTime_format = new SimpleDateFormat(
							"HH:mm:ss", Locale.CHINA);
					String time = dateTime_format.format(new Date());
					url = DateTimeUtils.strToDateTime(releaseTime + " " + time)
							.getTime() + ".html";
				} else {
					url = new Date().getTime() + ".html";
				}
			}
			if(!url.contains("html")){
				url=url+".html";
			}
			buffer.append(projectName);
			buffer.append("/");
			buffer.append("article/").append(type).append("/").append(url);
		}
		info = HtmlUtils.saveHtmlContent(buffer.toString(), text);
		if (info.isSuccess()) {
			info.setMsg(url);
		}
		return info;
	}
	/**
	 * 
	 * @param request
	 * @param projectName
	 * @param clerk
	 * @param htmlname
	 * @return
	 */
	@RequestMapping("delArticle")
	@ResponseBody
	public ResultInfo delArticle(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(isNotMapKeyNull(map, "clerk")){
				map.put("clerk_id", getEmployeeId(request));
				map.put("projectName", getComId()+"/"+getEmployeeId(request));
			}
			//1.删除图片,json,html
			//1.1图片
			StringBuffer buffer = new StringBuffer(getRealPath(request))
			.append(map.get("projectName"));
			buffer.append("/");
			Map<String,Object> info= managerService.getArticleInfoData(map);
			if (isNotMapKeyNull(info, "img")) {
				File imgUrl=new File(buffer.toString()+info.get("img"));
				if(imgUrl.exists()&&imgUrl.isFile()){
					imgUrl.delete();
				}
			}
			if (isNotMapKeyNull(info, "poster")) {
				File imgUrl=new File(buffer.toString()+info.get("poster"));
				if(imgUrl.exists()&&imgUrl.isFile()){
					imgUrl.delete();
				}
			}
			buffer.append("article/").append(map.get("projectType")).append("/");///.append(map.get("htmlname"));
			File htmlname=new File(buffer.toString()+map.get("htmlname"));
			if(htmlname.exists()&&htmlname.isFile()){
				htmlname.delete();
			}
			File jsonFile=null;
			File imgFile=null;
			if(htmlname.getPath().contains(".html")){
				String htmlnamestr=map.get("htmlname").toString().split("\\.")[0];
				jsonFile=new File(buffer.toString()+"/"+htmlnamestr+".json");
				imgFile=new File(buffer.toString()+htmlnamestr+"img");
			}else{
				jsonFile=new File(htmlname.getPath()+".json");
				imgFile=new File(htmlname.getPath()+"img");
			}
			if(jsonFile.exists()&&jsonFile.isFile()){
				jsonFile.delete();
			}
			if (imgFile.exists()&&imgFile.isDirectory()) {
				FileUtils.deleteDirectory(imgFile);
			}
			msg=managerService.delArticle(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 保存文章编辑器中的内容到文件中
	 * @param request
	 * @param text 编辑器中html内容
	 * @param url 文章地址
	 * @param type 文章类型,业务员文章或者官网文章
	 * @param saveType 保存类型,0-增加或者1-编辑
	 * @param projectName 官网模式下,文章存放根目录文件夹名称,例如:pc,p1,o2oindex
	 * @return
	 */
	@RequestMapping("saveArticleHtml")
	@ResponseBody
	public ResultInfo saveArticleHtml(HttpServletRequest request) {
		String text=request.getParameter("text");
		String url=request.getParameter("url");
		ResultInfo info = new ResultInfo(true);
		String type = request.getParameter("type");// 文章类型
		String saveType = request.getParameter("saveType");//保存类型,0-增加或者1-编辑
		String projectName = request.getParameter("projectName");
		if (StringUtils.isBlank(projectName)) {//可以为空,例如威尔检测
			projectName="";
		}
		if (StringUtils.isBlank(type)) {
			type = "1";
		}
		if (StringUtils.isBlank(saveType)) {
			saveType = "0";
		}
		if (StringUtils.isBlank(url)) {
			url = new Date().getTime()+"";
		}
		//组合html保存路径
		StringBuffer buffer = null;
		if("clerk".equals(type)){//业务员文章
			if ("0".equals(saveType)) {//增加
				buffer = new StringBuffer(getComIdPath(request));
				buffer.append("article/").append(getEmployeeId(request)).append("/").append(url).append("/item.html");
			}else{//编辑
				buffer = new StringBuffer(getRealPath(request));
				buffer.append(url);
			}
			url=buffer.toString().split("/"+getComId())[1];
			url="/"+getComId()+url;
		}else{//官网文章
			if ("0".equals(saveType)) {//增加
				buffer = new StringBuffer(getRealPath(request))
				.append(projectName);
				buffer.append("/");
				buffer.append("article/").append(type).append("/").append(url).append("/item.html");
			}else{//编辑
				buffer = new StringBuffer(getRealPath(request)).append(url);
			}
			url=buffer.toString().split("/"+projectName)[1];
			url="/"+projectName;
		}
		url=url.replaceAll("\\\\", "/");
		info = HtmlUtils.saveHtmlContent(buffer.toString(), text);
		if (info.isSuccess()) {
			info.setMsg(url);
		}
		return info;
	}
	
	/**
	 * 将文章信息存储为json文件
	 * @param request
	 * @param artical
	 *            文章信息对象
	 * @return 执行结果
	 */
	@RequestMapping("saveArtical")
	@ResponseBody
	public ResultInfo saveArtical(HttpServletRequest request) {
		//TODO 将文章信息存储为json文件
		boolean success = false;
		String msg = null;
		Map<String, Object> map = getKeyAndValue(request);
		if (isMapKeyNull(map, "htmlname")||isMapKeyNull(map, "projectName")) {
			msg="参数不全!";
		}else{
			String name = FilenameUtils.getBaseName(map.get("htmlname") + "");
			String projectName = request.getParameter("projectName");
			StringBuffer pathname = new StringBuffer(getRealPath(request));
			pathname.append(projectName).append("/article/")
			.append(map.get("type")).append("/").append(name);
			File file = new File(pathname.toString() + ".json");
			mkdirsDirectory(file);
			try {
				//判断当前json文件名中是否带置顶
				String jsonstr =null;
				StringBuffer pathname2 = new StringBuffer(getRealPath(request));
				pathname2.append(projectName).append("/article/")
				.append(map.get("type")).append("/a").append(name);
				File file2 = new File(pathname2.toString() + ".json");
				if (file2.exists()) {//带置顶标识,替换为不带置顶标识
					jsonstr = getFileTextContent(file2);
					file2.renameTo(file);//将带置顶 标识的替换为不带置顶标识
					if(file2.exists()&&file2.isFile()){
						file2.delete();
					}
				}else{
					jsonstr = getFileTextContent(file);
				}
				JSONObject json = null;
				if (StringUtils.isNotBlank(jsonstr)) {
					json = JSONObject.fromObject(jsonstr);
				} else {
					json = new JSONObject();
				}
				json.put("type", map.get("type"));
//			jsonold.put("typeName", map.get("typeName"));
				json.put("title", map.get("title"));
				json.put("releaseTime", map.get("releaseTime"));
				json.put("publisher", map.get("publisher"));
				json.put("htmlname", map.get("htmlname"));
				json.put("content", map.get("content"));
				json.put("zhiding", map.get("zhiding"));
				json.put("show", map.get("show"));
				json.put("filetype", map.get("filetype"));
				if (isNotMapKeyNull(map, "img")) {
					if(map.get("img").toString().contains("?")){
						map.put("img", map.get("img").toString().split("\\?")[0]);
					}
					map.put("img", map.get("img").toString().replaceAll("\\.\\.", ""));
					boolean b = MapUtils.getString(map, "img").contains("temp");
					if (b) {
						File srcFile = new File(getRealPath(request)
								+ MapUtils.getString(map, "img"));
						File destFile = new File(pathname.toString() + "."
								+ FilenameUtils.getExtension(srcFile.getName()));
						if (srcFile.exists()) {
							if (destFile.exists()) {
								destFile.delete();
							}
							FileUtils.moveFile(srcFile, destFile);
						}
						json.put("img", "article/" + map.get("type") + "/"
								+ destFile.getName());
						msg = destFile.getName();
					}
				}
				if (isNotMapKeyNull(map, "poster")) {
					if(map.get("poster").toString().contains("?")){
						map.put("poster", map.get("poster").toString().split("\\?")[0]);
						map.put("poster", map.get("poster").toString().replaceAll("\\.\\.", ""));
					}
					boolean b = MapUtils.getString(map, "poster").contains("temp");
					if (b) {
						File srcFile = new File(getRealPath(request)
								+ MapUtils.getString(map, "poster"));
						File destFile = new File(pathname.toString()+ "."
								+ FilenameUtils.getExtension(srcFile.getName()));
						if (srcFile.exists()) {
							if (destFile.exists()&&destFile.isFile()) {
								destFile.delete();
							}
							FileUtils.moveFile(srcFile, destFile);
						}
						json.put("poster", "article/" + map.get("type") + "/"
								+ destFile.getName());
						msg = destFile.getName();
					}
				}
				json.put("gjc", map.get("gjc"));
				json.put("projectName", map.get("projectName"));
				saveFile(file, json.toString());
				json.remove("content");
				json.put("projectType", json.get("type"));
				json.remove("type");
				json.remove("typeName");
				if (isNotMapKeyNull(map, "zhiding")&&"true".equals(map.get("zhiding"))) {
					json.put("zhiding", 1);
				}else{
					json.put("zhiding", 0);
				}
				managerService.saveArticleToTable(json);
				success = true;
			} catch (Exception e) {
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
	@RequestMapping("saveArticalInfo")
	@ResponseBody
	public ResultInfo saveArticalInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
			Map<String, Object> map = getKeyAndValue(request);
			if (isMapKeyNull(map, "htmlname")||isMapKeyNull(map, "projectName")) {
				msg="参数不全!";
			}else{
				try {
				String name = FilenameUtils.getBaseName(map.get("htmlname") + "");
				String projectName = request.getParameter("projectName");
				StringBuffer pathname = new StringBuffer(getRealPath(request));
				pathname.append(projectName).append("/article/")
				.append(map.get("projectType")).append("/").append(name);
				File file = new File(pathname.toString() + ".json");
				mkdirsDirectory(file);
				if (isNotMapKeyNull(map, "img")) {
					if(map.get("img").toString().contains("?")){
						map.put("img", map.get("img").toString().split("\\?")[0]);
					}
					map.put("img", map.get("img").toString().replaceAll("\\.\\.", ""));
					boolean b = MapUtils.getString(map, "img").contains("temp");
					if (b) {
						File srcFile = new File(getRealPath(request)
								+ MapUtils.getString(map, "img"));
						File destFile = new File(pathname.toString() + "."
								+ FilenameUtils.getExtension(srcFile.getName()));
						if (srcFile.exists()) {
							if (destFile.exists()&&destFile.isFile()) {
								destFile.delete();
							}
							FileUtils.moveFile(srcFile, destFile);
						}
						map.put("img", "article/" + map.get("projectType") + "/"
								+ destFile.getName());
						msg = destFile.getName();
					}
				}
				JSONObject json=new JSONObject();
				json.put("img",map.get("img"));
				json.put("title", map.get("title"));
				if (isNotMapKeyNull(map, "projectName")) {
					json.put("projectName", map.get("projectName"));
				}else{
					json.put("projectName","");
				}
				json.put("releaseTime", map.get("releaseTime"));
				json.put("publisher", map.get("publisher"));
				json.put("htmlname", map.get("htmlname"));
				json.put("gjc", map.get("gjc"));
				json.put("filetype", map.get("filetype"));
				json.put("projectType", map.get("projectType"));
				if (isNotMapKeyNull(map, "show")&&"true".equals(map.get("show"))) {
					json.put("show", 1);
				}else{
					json.put("show", 0);
				}
				if (isNotMapKeyNull(map, "zhiding")&&"true".equals(map.get("zhiding"))) {
					json.put("zhiding", 1);
				}else{
					json.put("zhiding", 0);
				}
				saveFile(file, json.toString());
				if (isMapKeyNull(map, "data")) {
					managerService.saveArticleToTable(json);
				}
				success = true;
			} catch (Exception e) {
				msg = e.getMessage();
				e.printStackTrace();
			}
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("tongbu")
	@ResponseBody
	public ResultInfo tongbu(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			File file=new File(getRealPath(request)+map.get("projectName")+"/article/"+map.get("type"));
			if(file.exists()&&file.isDirectory()){
				File[] fs = file.listFiles(new FileFilter() {
					@Override
					public boolean accept(File pathname) {
						String s = pathname.getName().toLowerCase();
						if (s.endsWith("json")) {
							return true;
						} else {
							return false;
						}
					}
				});
				if(fs!=null&&fs.length>0){
					for (File path : fs) {
						String info=getFileTextContent(path);
						if (StringUtils.isNotBlank(info)) {
							JSONObject json=JSONObject.fromObject(info);
							json.remove("content");
							json.put("projectName", map.get("projectName"));
							json.put("projectType", map.get("type"));
							json.remove("type");
							if (isNotMapKeyNull(map, "zhiding")&&"true".equals(map.get("zhiding"))) {
								json.put("zhiding", 1);
							}else{
								json.put("zhiding", 0);
							}
							json.remove("typeName");
							managerService.saveArticleToTable(json);
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
	 * 保存文章信息到json文件中
	 * @param request
	 * @return
	 */
	@RequestMapping("saveArticalJson")
	@ResponseBody
	public ResultInfo saveArticalJson(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String, Object> map = getKeyAndValue(request);
			if(isNotMapKeyNull(map, "htmlname")){
				String name = map.get("htmlname").toString().replaceAll(".html", "");
				StringBuffer pathname = new StringBuffer(getRealPath(request));
				pathname.append(name).append(".json");
				File file = new File(pathname.toString());
				mkdirsDirectory(file);
				// 获取json文件中已经存在的,然后进行更新
				JSONObject json = new JSONObject();
				json.put("type", map.get("type"));
				json.put("typeName", map.get("typeName"));
				json.put("title", map.get("title"));
				json.put("releaseTime", map.get("releaseTime"));
//			json.put("time", getNow());
				if (isMapKeyNull(map, "publisher")&&getEmployee(request)!=null) {
					json.put("publisher", getEmployee(request).get("clerk_name"));
				}else{
					json.put("publisher",map.get("publisher"));
				}
				json.put("htmlname", map.get("htmlname"));
				json.put("content", map.get("content"));
				json.put("filetype", map.get("filetype"));
				json.put("gjc", map.get("gjc"));
				json.put("img", map.get("img"));
				json.put("poster", map.get("poster"));
				if (isNotMapKeyNull(map, "img")) {
					boolean b = MapUtils.getString(map, "img").contains("temp");
					if (b) {
						String img=MapUtils.getString(map, "img").replaceAll("\\.\\.", "");
						if (img.contains("?")) {
							img=img.split("\\?")[0];
						}
						File srcFile = new File(getRealPath(request)+img);
						String imgpath=name+"."+FilenameUtils.getExtension(srcFile.getName());
						File destFile = new File(getRealPath(request)+imgpath);
						if (destFile.exists()&&destFile.isFile()) {
							destFile.delete();
						}
						FileUtils.moveFile(srcFile, destFile);
						json.put("img",  imgpath);
						msg = destFile.getName();
					}
				}
				if (isNotMapKeyNull(map, "poster")) {
					boolean b = MapUtils.getString(map, "poster").contains("temp");
					if (b) {
						String img=MapUtils.getString(map, "poster").replaceAll("\\.\\.", "");
						if (img.contains("?")) {
							img=img.split("\\?")[0];
						}
						File srcFile = new File(getRealPath(request) + img);
						String poster=name+"."+FilenameUtils.getExtension(srcFile.getName());
						poster=poster.replace("item", "poster");
						File destFile = new File(getRealPath(request)+poster);
						mkdirsDirectory(destFile);
						if (destFile.exists()&&destFile.isFile()) {
							destFile.delete();
						}
						FileUtils.moveFile(srcFile, destFile);
						json.put("poster", poster);
						msg = destFile.getName();
					}
				}
				saveFile(file, json.toString());
				json.remove("content");
				json.put("projectType", json.get("type"));
				json.remove("type");
				json.remove("typeName");
				if (isNotMapKeyNull(map, "zhiding")&&"true".equals(map.get("zhiding"))) {
					json.put("zhiding", 1);
				}else{
					json.put("zhiding", 0);
				}
				if (isNotMapKeyNull(map, "show")&&"true".equals(map.get("show"))) {
					json.put("show", 1);
				}else{
					json.put("show", 0);
				}
				json.put("clerk_id", getEmployeeId(request));
				json.put("projectName",getComId(request)+"/"+ getEmployeeId(request));
				managerService.saveArticleToTable(json);
				success = true;
			}else{
				msg="文件名缺少!";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 获取发布需要使用的js
	 * 
	 * @param request
	 * @return 返回发布js所在txt页面
	 */
	@RequestMapping("publish")
	@ResponseBody
	public ResultInfo publish(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if (getEmployee(request) == null) {

			} else {
				String path = getRealPath(request)
						+ "WEB-INF/pages/cms/publishInfo.txt";
				msg = getFileTextContent(path);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 保存产品列表页面内容为json
	 * 
	 * @return 成功返回jsonname
	 */
	@RequestMapping("saveProduct")
	@ResponseBody
	public ResultInfo saveProduct(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String type = request.getParameter("type");
			if (StringUtils.isBlank(type)) {
				type = "4";
			}
			String jsonname = request.getParameter("jsonname");
			String proName = request.getParameter("proName");
			String proTips = request.getParameter("proTips");
			String proJe = request.getParameter("proJe");
			String imgurl = request.getParameter("imgurl");
			StringBuffer pathname = new StringBuffer(getRealPath(request,
					"/pc/content/"));
			pathname.append(getUserInfo_Id(request)).append("/")
					.append(getTemplateName(request));
			if (StringUtils.isBlank(jsonname)) {
				jsonname = new Date().getTime() + "";
			}
			pathname.append("/").append("article/").append(type).append("/")
					.append(jsonname).append(".json");
			File file = new File(pathname.toString());
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			JSONObject json = new JSONObject();
			json.put("proName", proName);
			json.put("proTips", proTips);
			json.put("proJe", proJe);
			json.put("imgurl", imgurl);
			OutputStreamWriter outputStream = null;
			try {
				outputStream = new OutputStreamWriter(
						new FileOutputStream(file), "UTF-8");
				outputStream.write(json.toString());
				outputStream.flush();
				outputStream.close();
				msg = jsonname;
				success = true;
			} catch (IOException e) {
				e.printStackTrace();
				msg = e.getMessage();
				try {
					outputStream.flush();
					outputStream.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 保存公共html部分
	 * 
	 * @param request
	 * @param content
	 *            网页内容
	 * @param name
	 *            网页名称
	 * @return
	 */
	@RequestMapping("saveFragmentHtml")
	@ResponseBody
	public ResultInfo saveFragmentHtml(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		String content = request.getParameter("content");
		String name = request.getParameter("name");
		StringBuffer buffer = new StringBuffer(getRealPath(request));
		buffer.append(getUserInfo_Id(request)).append("/")
				.append(getTemplateName(request));
		buffer.append("/").append(name).append(".html");
		File file = new File(buffer.toString());
		if (file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		try {
			OutputStreamWriter stream = new OutputStreamWriter(
					new FileOutputStream(file), "UTF-8");
			stream.write(content);
			stream.flush();
			stream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 跳转到文章编辑页面
	 * 
	 * @param url
	 * @param request
	 * @return
	 */
	@RequestMapping("artivleEdit")
	public String artivleEdit(String url, HttpServletRequest request) {
		StringBuilder builder = new StringBuilder("/pc/content/");
		builder.append(getUserInfo_Id(request)).append("/")
				.append(getTemplateName(request)).append("/");
		String urlh = request.getParameter("urlh");
		url = builder.toString() + url;
		// /pc/content/13144444/ui1/13232332423.html
		// /pc/content/13144444/ui1/artivle.html?url=pc/content/13144444/ui1/13232332423.html
		builder.append(urlh).append("?url=").append(url);
		request.setAttribute("url", builder.toString());
		return "../../pc/artivleEdit";
	}

	/**
	 * 跳转到文章列表页面
	 * 
	 * @param request
	 * @param url
	 * @return
	 */
	@RequestMapping("artivleList")
	public String artivleList(HttpServletRequest request) {
		String name=request.getParameter("name");
		StringBuilder builder = new StringBuilder("/pc/content/");
		builder.append(getUserInfo_Id(request)).append("/")
				.append(getTemplateName(request)).append("/");
		String urlh = request.getParameter("urlh");
		builder.append(urlh).append("?url=").append(name);
		// /pc/content/13144444/ui/article_list.html?url=1
		request.setAttribute("url", builder.toString());
		return "../../pc/artivleEdit";
	}

	/**
	 * 清空临时文件
	 * 
	 * @param request
	 * @param url
	 *            文件相对路径
	 * @param foldername
	 *            文件夹名
	 */
	private void removeTemp(String path) {
		File img = new File(path);
		File[] imgs = img.listFiles();
		if (imgs != null && imgs.length > 0) {
			for (int i = 0; i < imgs.length; i++) {
				if (imgs[i].exists() && imgs[i].isFile()) {
					if (imgs[i].getPath().contains("_temp")) {
						if (imgs[i].exists()&&imgs[i].isFile()) {
							imgs[i].delete();
						}
					}
				} else {
					removeTemp(imgs[i].getPath());
				}
			}
		}
	}

	private String getTemplateName(HttpServletRequest request) {
		return request.getSession().getAttribute("templateName").toString();
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
		String templateName = getTemplateName(request);
		String filename = getRealPath(request, null) + "/temp/"
				+ getUserInfo_Id(request) + "/" + templateName + ".zip";
		StringBuffer srcpath = new StringBuffer("/pc/content/");
		srcpath.append(getUserInfo_Id(request)).append("/")
				.append(templateName).append("/");
		zip(filename, getRealPath(request, srcpath.toString()));
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
		File file = new File(zipFilePath);
		if (!file.exists()) {
			file.getParentFile().mkdirs();
		} else if (file.exists() && file.isFile()) {
			file.delete();
		}
		File zipFile = new File(inputFolderName);
		zip(zipFilePath, zipFile);
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
			// System.out.println(base);
			while ((b = in.read()) != -1) {
				out.write(b);
			}
			in.close();
		}
	}

	// ////////////
	/**
	 * Word转html
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("convert2Html")
	@ResponseBody
	public ResultInfo convert2Html(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			File fileName = new File(getRealPath(request)
					+ request.getParameter("fileName"));// "temp/word/案例.doc";
			File outPutFile = new File(getRealPath(request)
					+ request.getParameter("outPutFile"));// "pc/word/anli.html";
			File imgPath = new File(getRealPath(request)
					+ request.getParameter("imgPath"));// "pc/word/img/";
			String imgprex = request.getParameter("imgprex");
			String utf = request.getParameter("utf");
			if (StringUtils.isBlank(utf)) {
				utf = "UTF-8";
			}
			if (!fileName.getParentFile().exists()) {
				fileName.getParentFile().mkdirs();
			}
			if (!outPutFile.getParentFile().exists()) {
				outPutFile.getParentFile().mkdirs();
			}
			if (!imgPath.exists()) {
				imgPath.mkdirs();
			}
			// docTest.convert2Html(fileName.getPath(), outPutFile.getPath(),
			// imgPath.getPath()+"/",utf,imgprex);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	//////////////////////////
	@RequestMapping("saveFile")
	@ResponseBody
	public ResultInfo saveFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String html=request.getParameter("html");
			String path=request.getParameter("path");
			if (StringUtils.isNotBlank(html)) {
				if (StringUtils.isNotBlank(path)) { 
					super.saveFile(getRealPath(request)+path, html);
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
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getFile")
	@ResponseBody
	public ResultInfo getFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String path=request.getParameter("path");
			if (StringUtils.isNotBlank(path)) {
				msg=getFileTextContent(getRealPath(request)+path);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 同步微信服务号模板到数据表中
	 * @param request
	 * @return
	 */
	@RequestMapping("tongbuWeixinTemplate")
	@ResponseBody
	public ResultInfo tongbuWeixinTemplate(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeiXinServiceUtil ws=new WeiXinServiceUtil();
			JSONArray jsons=ws.get_all_private_template(getComId());
			if(jsons!=null){
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					String[] ss=json.getString("content").split("DATA}}");
					String content="";
					for (int j = 1; j < ss.length-1; j++) {
						String s=ss[j];
						if (StringUtils.isNotBlank(s)&&s.trim().length()>2) {
							int begin=s.indexOf("{{");
							String str=s.substring(begin+2, s.length());
							if(!"remark.".equals(str)){
								content=content+str;
							}
						}
					}
					json.put("content", content);
//					json.remove("example");
					json.remove("primary_industry");
					json.remove("deputy_industry");
				}
				msg=managerService.tongbuWeixinTemplate(jsons);
				File file=new File(getComIdPath(request)+"/weixinTemplate");
				saveFile(file, jsons.toString());
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 从数据表中获取微信服务号消息模板
	 * @param request
	 * @return
	 */
	@RequestMapping("getWexinMsgTemplate")
	@ResponseBody
	public List<Map<String,Object>> getWexinMsgTemplate(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return managerService.getWexinMsgTemplate(map);
	}
	/**
	 * 通过网页获取视频地址
	 * @param request
	 * @return
	 */
	@RequestMapping("getVideoUrl")
	@ResponseBody
	public ResultInfo getVideoUrl(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String url=request.getParameter("url");
			if(StringUtils.isNotBlank(url)){
				WeixinUtil wx=new WeixinUtil();
				msg=wx.getData(url);
				if(StringUtils.isNotBlank(msg)){
					int b= msg.indexOf("<video");
					int e=msg.indexOf("</video>");
					msg=msg.substring(b, e);
					System.out.println(msg);
					b=msg.indexOf("src")+5;
					e=msg.indexOf(">");
					msg=msg.substring(b, e);
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
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getBanner")
	@ResponseBody
	public JSONArray getBanner(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		if(StringUtils.isBlank(com_id)){
			com_id="001";
		}
		String msg=getFileTextContent(getRealPath(request)+com_id+"/banner.json");
		if(StringUtils.isNotBlank(msg)){
			if(msg.startsWith("[")){
				msg="["+msg;
			}
			if(msg.endsWith("]")){
				msg=msg+"]";
			}
			return JSONArray.fromObject(msg);
		}
		return null;
	}
	/**
	 * 获取cms编辑js文件内容
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("cmsjs")
	@ResponseBody
	public String cmsjs(HttpServletRequest request, HttpServletResponse response) {
		if(getEmployee(request)!=null){
			//检查权限
			boolean b=checkAuthority(request, "indexEdit", "");
			if(b){
				String path = getRealPath(request)
						+ "WEB-INF/pages/cms/cmsjs.js";
				String msg=getFileTextContent(path);
				try {
					response.setContentType("text/html;charset=utf-8");
					response.getOutputStream().write(msg.getBytes("utf-8"));
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
				return null;
			}else{
				return "没有权限!";
			}
		}else{
			return null;
		}
	}
	/**
	 * 保存html内容和header和copyright
	 * @param request
	 * @return
	 */
	@RequestMapping("saveHtml")
	@ResponseBody
	public ResultInfo saveHtml(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)!=null){
				boolean b=checkAuthority(request, "indexEdit", "");
				if(b){
					String html=request.getParameter("html");
					String htmlname=request.getParameter("htmlname");
					if(StringUtils.isNotBlank(htmlname)){
						if(StringUtils.isNotBlank(html)){
							File file=new File(getRealPath(request)+htmlname);
							saveFile(file,"<!DOCTYPE html><html>"+html+"</html>");
							String name=FilenameUtils.getBaseName(file.getPath());
							String header=request.getParameter("header");
							file=new File(getRealPath(request)+htmlname.replace(name, "header"));
							saveFile(file,header);
							String copyright=request.getParameter("copyright");
							file=new File(getRealPath(request)+htmlname.replace(name, "copyright"));
							saveFile(file,copyright);
							String eavingHtml=request.getParameter("eavingHtml");
							if(StringUtils.isNotBlank(eavingHtml)){
								file=new File(getRealPath(request)+htmlname.replace(name, "eavingHtml"));
								saveFile(file,eavingHtml);
							}
							success = true;
							msg="保存成功!";
						}else{
							msg="没有html文件内容!";
						}
					}else{
						msg="没有html文件名称和路径";
					}
				}else{
					msg="没有操作权限!";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 细分行业首页编辑
	 * @param request
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("indexCmsEdit")
	public String indexCmsEdit(HttpServletRequest request,HttpServletResponse response) throws IOException {
			File file=new File(getComIdPath(request)+"cms/index.html");
			if (file.exists()&&file.isFile()) {
				response.sendRedirect("/"+getComId()+"/cms/index.html");
			}else{
				response.sendRedirect("/cms/indexCmsSelect.jsp");
			}
			return null;
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getNewTemp")
	@ResponseBody
	public JSONArray getNewTemp(HttpServletRequest request) {
		File file=new File(getRealPath(request)+"cms");
		if (file.exists()&&file.isDirectory()) {
			File[] fs= file.listFiles();
			String msg=getFileTextContent(getRealPath(request)+"cms/tempList.json");
			JSONArray jsons=null;
			if (StringUtils.isNotBlank(msg)) {
				if (!msg.startsWith("[")) {
					msg="["+msg;
				}
				if (!msg.endsWith("]")) {
					msg=msg+"]";
				}
				jsons=JSONArray.fromObject(msg);
			}else{
				jsons=new JSONArray();
			}
			for (File f : fs) {
				if (f.isDirectory()&&!"css".equals(f.getName())) {
					String name=f.getName();
					if(!msg.contains(name)){//不在json
						JSONObject json=new JSONObject();
						json.put("tempName",name);
						jsons.add(json);
					}
				}
			}
			return jsons;
		}
		return null;
	}
	/**
	 * 保存模板信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveTempList")
	@ResponseBody
	public ResultInfo saveTempList(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			File file=new File(getRealPath(request)+"cms/tempList.json");
			saveFile(file, request.getParameter("jsons"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 使用选择的官网模板
	 * @param request
	 * @return
	 */
	@RequestMapping("useTempIndex")
	@ResponseBody
	public ResultInfo useTempIndex(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			File indexFile=new File(getComIdPath(request)+"cms/index.html");
			if(indexFile.exists()&&indexFile.isFile()){
				File dest=new File(getComIdPath(request)+"cms"+getNow());
				indexFile.getParentFile().renameTo(dest);
			}
			File tempFile=new File(getRealPath(request)+"cms/"+map.get("tempName"));
			if (tempFile.exists()&&tempFile.isDirectory()) {
				FileUtils.copyDirectory(tempFile, indexFile.getParentFile());
				msg="/"+getComId()+"/cms/";
				success = true;
			}else{
				msg="模板路径不存在!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取文章短链接
	 * @param request
	 * @return 
	 */
	@RequestMapping("getShortUrl")
	@ResponseBody
	public ResultInfo getShortUrl(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map=managerService.getArticleInfoData(map);
			if (isNotMapKeyNull(map, "id")) {
				String urlPrefix=systemParamsService.checkSystem("urlPrefix","");
				if (!urlPrefix.endsWith("/")) {
					urlPrefix=urlPrefix+"/";
				}
				msg=urlPrefix+"smg/"+MapUtils.getString(map, "id")+".do";
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
}