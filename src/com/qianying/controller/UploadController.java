package com.qianying.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import sun.misc.BASE64Decoder;

import com.qianying.bean.ResultInfo;
import com.qianying.integerceptor.FileUploadStatus;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.Kit;

/**
 * 上传图片
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("/upload")
public class UploadController extends FilePathController{
	 @RequestMapping("/getBar")
	 public void getBar(HttpServletRequest request, HttpServletResponse response) {
	 	HttpSession session = request.getSession();
	 	FileUploadStatus status = (FileUploadStatus) session.getAttribute("status");
	 	try {
	 		response.reset();
	 		if (status!=null) {
	 			response.getWriter().write("{\"pBytesRead\":"
	 					+status.getPBytesRead()+",\"pContentLength\":"+status.getPContentLength()+"}");
			}
	 	} catch (IOException e) {
	 		e.printStackTrace();
	 	}
	 } 
	 /**
	  * 上传图片,单个文件标准上传
	  * @param file
	  * @param request
	  * @param response
	  * @throws IOException
	  * @RequestParam(value = "imgFile") MultipartFile file,
	  */
//	 @RequestMapping("/uploadImage")
	 @RequestMapping(value = "/uploadImage", method = RequestMethod.POST,  headers = "content-type=multipart/*")
	 public void uploadImg(MultipartHttpServletRequest msReq,HttpServletRequest request, HttpServletResponse response) throws IOException {
		 MultipartFile file = msReq.getFile(request.getParameter("fileName"));
		 String type=request.getParameter("type");
		 String imgName=request.getParameter("imgName");
		 if (StringUtils.isNotBlank(type)) {
			if ("userpic".equals(type)) {
//				Map<String,Object> mapManager=(Map<String, Object>) request.getSession().getAttribute(ConfigFile.MANAGER_SESSION_LOGIN);
				type=type+"/";
			}else if ("sp".equals(type)) {
				type=getEmployeeId(request)+"/"+type+"/";
			}else{
				type=type+"/";
			}
		}else{
			type="";
		}
		 String ext="."+FilenameUtils.getExtension(file.getOriginalFilename());
		 String filename=new Date().getTime()+ext;
		 if (StringUtils.isNotBlank(imgName)) {
			filename=imgName+ext;
		}
		 if (StringUtils.isNotBlank(request.getParameter("fileNameNo"))) {//不改变文件名
			 filename=file.getOriginalFilename();
		}
		 File filepath=new File(getRealPath(request)+"temp/"+getComId()+"/"+type+filename);	
		 if (filepath.exists()&&filepath.isFile()) {
			filepath.delete();
		}
		 mkdirsDirectory(filepath);
 		try {
 			file.transferTo(filepath);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		 Kit.writeJson(response,"/temp/"+getComId()+"/"+type+filename);
	}
	 /**
	  * 直接上传图片到指定文件夹,单个文件标准上传
	  * @param imgPath 文件上传到什么地方
	  * @param fileName
	  * @param newWidth图片宽度不写表示不压缩
	  * @param request
	  * @param response
	  * @param quality 缩放级别
	  * @param newWidth 尺寸
	  * @throws IOException
	  * @RequestParam(value = "imgFile") MultipartFile file,
	  */
//	 @RequestMapping("/uploadImageZs")
	 @RequestMapping(value = "/uploadImageZs", method = RequestMethod.POST,  headers = "content-type=multipart/*")
	 public void uploadImageZs( MultipartHttpServletRequest msReq,HttpServletRequest request, HttpServletResponse response) throws IOException {
		 MultipartFile file = msReq.getFile(request.getParameter("fileName"));
		 String imgPath=request.getParameter("imgPath");
		 String q=request.getParameter("quality");
		 String w=request.getParameter("newWidth");
		 float quality=0.5f;
		 if (StringUtils.isNotBlank(q)) {
			 quality=Float.parseFloat(q);
		 }
		 Integer newWidth=0;
		 if(StringUtils.isNotBlank(w)){
			 newWidth=Integer.parseInt(w);
		 }
		 if (StringUtils.isNotBlank(imgPath)) {
			if(imgPath.contains("@com_id")){
				imgPath=imgPath.replace("@com_id", getComId());
			}
			if(!imgPath.contains(".")){
				imgPath=imgPath+"/"+file.getOriginalFilename();
			}
		 }else{
			 throw new RuntimeException("缺少存储路径!");
		 }
		 File filepath=new File(getRealPath(request)+imgPath);	
		 if (filepath.exists()&&filepath.isFile()) {
			 filepath.delete();
		 }
		 mkdirsDirectory(filepath);
		 try {
			 file.transferTo(filepath);
			 if (newWidth>0) {
				 imgResize(filepath, filepath, newWidth, quality);
			}
		 } catch (IllegalStateException e) {
			 e.printStackTrace();
		 } catch (IOException e) {
			 e.printStackTrace();
		 }
		 Kit.writeJson(response,imgPath);
	 }
//		@RequestMapping("/uploadWordImg")
		@RequestMapping(value = "/uploadWordImg", method = RequestMethod.POST,  headers = "content-type=multipart/*")
		public void uploadWordImg(MultipartHttpServletRequest msReq,
				HttpServletRequest request, HttpServletResponse response) throws IOException {
			MultipartFile file = msReq.getFile("image");
			if(file==null){
				file = msReq.getFile("video");
			}
			String htmlname =request.getParameter("htmlname");
			String filename = new Date().getTime() + "."
						+ FilenameUtils.getExtension(file.getOriginalFilename());
			String templateName =request.getParameter("templateName");
			if (StringUtils.isBlank(templateName)) {
				templateName="";
			}
			//////////////001/article/clerk_id/img/
			StringBuffer buffer=new StringBuffer("/");
			String msg="";
			if ("clerk".equals(templateName)) {
				if(htmlname.contains("E0")){//只需要时间戳部分
					htmlname=new File(htmlname).getParentFile().getName();
				}
				buffer.append(getComId()).append("/article/").append(getEmployeeId(request)).append("/").append(htmlname).append("/img/").append(filename);
				msg=buffer.toString();
			}else{
				String type=request.getParameter("type");
				buffer.append(templateName);
				StringBuffer bf=new StringBuffer("article/");
				bf.append(type).append("/").append(htmlname).append("img/").append(filename);
				msg=bf.toString();
				buffer.append("/").append(bf.toString());
			}
			
			File filepath = new File(getRealPath(request) +buffer.toString());
			if (filepath.exists()&&filepath.isFile()) {
				filepath.delete();
			}
			mkdirsDirectory(filepath);
			try {
				file.transferTo(filepath);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			Kit.writeJson(response,msg);
		}
	 /**
	  * 存储图片
	  * @param request
	  * @param imgs
	  * @return
	  * @throws Exception
	  */
	@RequestMapping("getBusinessList")
	@ResponseBody
	public ResultInfo saveImg(HttpServletRequest request) throws Exception {
		String[] imgs=request.getParameterValues("imgs");
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd", Locale.CHINA);
		for (String img : imgs) {
			File destFile=new File(getRealPath(request)+format.format(new Date())+"/"+img);
			File srcFile=new File(getRealPath(request)+"temp/"+img);
			FileUtils.moveFile(srcFile, destFile);
		}
		return new ResultInfo();
	}
	/**
	 * 删除图片
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("removeTemp")
	@ResponseBody
	public ResultInfo removeTemp(HttpServletRequest request) throws Exception {
		String imgUrl=request.getParameter("imgUrl");
		if (StringUtils.isNotBlank(imgUrl)) {
			if("/".equals(imgUrl)||"\\\\".equals(imgUrl)){
			}else{
				File srcFile=new File(getRealPath(request)+imgUrl);
				if (srcFile.exists()&&srcFile.isFile()) {//存在并且是文件
					srcFile.delete();
				}
			}
		}
		return new ResultInfo(true);
	}
	/**
	 * 保存签名图片
	 * @param request
	 * @return
	 */
	@RequestMapping("qianming")
	@ResponseBody
	public ResultInfo qianming(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String imgStr=request.getParameter("imgStr").split(",")[1];
			String qianmiang=null;
			if (getCustomer(request)!=null) {
				qianmiang=getCustomerId(request);
			}else{
				qianmiang=getEmployeeId(request);
			}
			msg=getComId()+"/"+qianmiang+"/"+DateTimeUtils.getNowDateTime()+".png";
			File imgFilePath=new File(getRealPath(request)+msg);
			if (!imgFilePath.exists()) {
				imgFilePath.getParentFile().mkdirs();
			}
			generateImage(imgStr, imgFilePath.getPath());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	public boolean generateImage(String imgStr,String imgFilePath) {
		if (imgStr==null) {
			return false;
		}
		BASE64Decoder decoder=new BASE64Decoder();
		try {
			byte[] bytes=decoder.decodeBuffer(imgStr);
			for (int i = 0; i < bytes.length; i++) {
				if (bytes[i]<0) {
					bytes[i]+=256;
				}
			}
			OutputStream out=new FileOutputStream(imgFilePath);
			out.write(bytes);
			out.flush();
			out.close();
			return true;
		} catch (Exception e) {
			return false;
		}
	}

}
