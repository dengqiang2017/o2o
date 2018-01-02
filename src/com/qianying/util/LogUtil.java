package com.qianying.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.text.DateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.qianying.controller.BaseController;

public abstract class LogUtil {
	/**
	 * 获取多层代理中的真实地址
	 * @param request
	 * @return
	 */
	public static  String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Real-IP");
        if (!StringUtils.isBlank(ip) && !"unknown".equalsIgnoreCase(ip)) {
            return ip;
        }
        ip = request.getHeader("X-Forwarded-For");
        if (!StringUtils.isBlank(ip) && !"unknown".equalsIgnoreCase(ip)) {
        // 多次反向代理后会有多个IP值，第一个为真实IP。
        int index = ip.indexOf(',');
            if (index != -1) {
                return ip.substring(0, index);
            } else {
                return ip;
            }
        } else {
             return request.getRemoteAddr();
        }
    }
	/** 
	 * 写日志
	 * @param uri
	 * @param path 日志存放路径,可以不写
	 * @param ip
	 */
	public static void writeLogo(String uri, String path,String ip) {
		//写日志
		if (StringUtils.isBlank(path)) {
			File file=new File(ConfigFile.TOMCAT_DIR+"/channel_log");
			path=file.getPath();
		}
		String date= DateFormat.getDateTimeInstance().format(new Date());
		String dates[]=date.split(" ");
		deleteLog(path);
		OutputStream out = null;
		try {
			out = new FileOutputStream(getFilePath(dates[0], path),true);
		}catch (FileNotFoundException e){
			if (ConfigFile.PRINT_ERROR) {
				e.printStackTrace();
			}
		}
		PrintStream stream=new PrintStream(out);
		stream.println(dates[1]+"-->"+uri+";ip-->"+ip);
		stream.close();
		try {
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 获取当天的文件路径
	 * @param date
	 * @param path
	 * @return
	 */
	private static File getFilePath(String date, String path) {
		File file=new File(path);
		if (!file.exists()) {
			file.mkdirs();
		}
		File filePath=new File(file+"/"+date+".log");
		return filePath;
	}
	/**
	 * 删除设定时间外的日志文件
	 * @param path
	 */
	private static void deleteLog(String path) {
		Date date=new Date();
		date=DateUtils.addDays(date, ConfigFile.LOGDAY);
		File file= getFilePath(DateFormat.getDateTimeInstance().format(date), path);
		if (file.exists()&&file.isFile()) {
			file.delete();
		}
	}
	
	/**
	 * 保存数据到文件中
	 * @param path 文件存储路径
	 * @param str 存储数据
	 */
	public static void saveFile(String str,String type) {
		try {
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
	                .getRequestAttributes()).getRequest();
			StringBuffer buffer=new StringBuffer(BaseController.getRealPath(request));
			Object comid=request.getSession().getAttribute(ConfigFile.OPERATORS_NAME);
			String com_id="001";
			if (comid!=null) {
				com_id=comid.toString().trim();
			}
			buffer.append(com_id).append("/weixinID/").append(type).append("/").append(DateTimeUtils.getNowDate()).append(".log");
			File file=new File(buffer.toString());
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			OutputStreamWriter outputStream = new OutputStreamWriter(
					new FileOutputStream(buffer.toString(),true),
					"UTF-8");
			outputStream.write(str);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
