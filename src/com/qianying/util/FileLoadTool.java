package com.qianying.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * 文件上传工具类
 * @author Administrator
 */
public class FileLoadTool {
	private static  Logger log = Logger.getLogger(FileLoadTool.class); 
	//删除文件
	public static boolean deleteFile(HttpServletRequest request,String filePath){
		File file = new File(filePath);
		System.out.println("删除图片 "+filePath +"图片是否存在 "+file.exists());
		if(file.exists()&&file.isFile()){
			return file.delete();
		}
		return false;
	}
	public static String FILESIZE="";
	/**
	 * 
	 * 上传文件
	 * @param msReq
	 * @param path 文件存放路径
	 * @param filename新的文件名
	 * @param bfile 是否生成新的文件名 true生成
	 * @return
	 */
	public static String loadFile(MultipartHttpServletRequest msReq,String path,String filename,boolean bfile){
		// 获得文件：
		MultipartFile mFile = msReq.getFile("file");
		if (mFile==null) {
			return "";
		}
		Long filesize=mFile.getSize()/1024;
		FILESIZE= FileOperate.getFileSizeToStr((mFile.getSize() * 1.0) / 1024);
		if (filesize<=955012&&filesize>=0) {
			// 获得文件全名：
			String fname = mFile.getOriginalFilename();
			//文件名
		//	String firstName = fname.substring(0,fname.lastIndexOf("."));
			//文件后缀名
			String lastName = fname.substring(fname.lastIndexOf(".")+1,fname.length());
			//获取当前文件URL
			//new filename
			String newFileName=fname;
			if (StringUtils.isNotBlank(filename)) {
				newFileName=filename;	
			}
			if (bfile) {
				  newFileName = new Date().getTime()+"."+lastName;				
			} 
			//新建文件URL
			String newURL = path+ConfigFile.ROOT+newFileName;
			
			//获取文件上一级路径
//			String real=msReq.getSession().getServletContext().getRealPath(ConfigFile.ROOT);
//			File file=new File(real).getParentFile();
			//获取图片存储位置
			File filePath=new File(ConfigFile.TOMCAT_DIR+path);
			if (!filePath.exists()) {
				filePath.mkdirs();
			}
			
			//pc_url
			String pc_url = filePath.getPath()+ConfigFile.ROOT+newFileName;
			
			//创建新的文件
			File newFile = new File(pc_url);
			if (newFile.exists()) {
				return "文件已经存在!";
			}
//			try {
//				//把文件转化为数组
//				byte[] bts = mFile.getBytes();
//				//向新文件中写入数据
//				OutputStream outputStream=new FileOutputStream(newFile);
//				outputStream.write(bts);
//				outputStream.close(); 
//			} catch (IOException e) {
//				e.printStackTrace();
//				//文件上传失败
//				return "文件上传失败";
//			}
			///////////////////////////////
			try {
				InputStream is =mFile.getInputStream();// 获得输入流;（里面是大文件）
				OutputStream os = new FileOutputStream(newFile,true);
				log.info("begin====>>>>>"+System.currentTimeMillis());
				byte[] buffer=new byte[1024*1024];
		        int byteread = 0; 
		        while ((byteread=is.read(buffer))!=-1)
		        {
		           os.write(buffer,0,byteread);
		           os.flush();
		        } 
		        log.info("end====>>>>>"+System.currentTimeMillis());
		        os.close();
		        is.close();    
			} catch (Exception e) {
				if (ConfigFile.PRINT_ERROR) {				
					e.printStackTrace();
				}
				return "文件上传失败";
			}finally{
			}
			/////////////////////////////////
				return newURL;
		}else{
			//文件大小超过限制
			return "文件大小超过限制";
		}
	}	
	/**
	 * 获取webapps
	 * @param request
	 * @return
	 */
	public static String getTomcatWebappsPath(HttpServletRequest request){
		String tomcatRoot = request.getSession().getServletContext().getRealPath(ConfigFile.ROOT);  
		        String[] foo = tomcatRoot.split(ConfigFile.ROOT);  
		        StringBuilder tomcatWebAppsBuilder = new StringBuilder();  
		        int i = 0;  
		        for(String paths : foo){  
		            ++i;  
		            if(i != foo.length){  
		                tomcatWebAppsBuilder.append(paths);  
		                tomcatWebAppsBuilder.append(ConfigFile.ROOT);  
		            }  
		        }  
		        String tomcatWebApps = tomcatWebAppsBuilder.toString();
		        return tomcatWebApps;
		}
	/**
	 * 获取文件夹大小
	 * @param dir
	 * @return
	 */
    public static Long getDirSize(File dir) {  
        if (dir == null) {  
            return 0l;  
        }  
        if (!dir.isDirectory()) {  
            return 0l;  
        }  
        long dirSize = 0;  
        File[] files = dir.listFiles();  
        for (File file : files) {
            if (file.isFile()) {
                dirSize += file.length();  
            } else if (file.isDirectory()) {  
                dirSize += file.length();  
                dirSize += getDirSize(file); // 如果遇到目录则通过递归调用继续统计  
            }  
        }  
        return dirSize;  
    } 
    

}
