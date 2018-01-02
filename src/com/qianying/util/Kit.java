package com.qianying.util;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.Scanner;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.qianying.bean.ResultInfo;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun.xml.internal.messaging.saaj.util.ByteInputStream;

public abstract class Kit { 
	public static final String ERROR_MESSAGE = "error_message";
	public static final String ERROR_PAGE = "Error/error1";
	public static final boolean DEBUG = true; 
	 
	/**
	 * 生成随机字符串
	 * @return
	 */
	public static String getRandom(){
		char[] c = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','Y','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'};
		//char[] c = {'0','1','2','3','4','5','6','7','8','9'};
		int max = c.length-1;
		String code = "";
		String[] time = (new Date().getTime() + "").trim().split("");
		//for(int i=0;i<time.length;i++){ //27wei
		for(int i=0;i<8;i++){ //15wei
	        int num = (int)Math.round(Math.random()*max);
	        code+=c[num]+time[i];
	    }
	    return code;
	}
	
	/**
	 * 生成随机字符串
	 * @return
	 */
	public static String getRandompwd(){
		char[] c = {'0','1','2','3','4','5','6','7','8','9'};
		int max = c.length-1;
		String code = "";
		String[] time = (new Date().getTime() + "").trim().split("");
		//for(int i=0;i<time.length;i++){ //27wei
		for(int i=0;i<8;i++){ //15wei
	        int num = (int)Math.round(Math.random()*max);
	        code+=c[num]+time[i];
	    }
	    return code;
	}
	
	/**
	 * 生成6位随机数
	 * 2014-4-29
	 * @return
	 */
	public static String genRandom(){
		Random random6 = new Random();
		String result="";
		for(int i=0;i<6;i++){
		  result+=random6.nextInt(10);
		}
		//System.out.print(result);
		return result;
	}
	
	/**
	 * 生成6位不重复的随机数
	 * 2014-4-29
	 * @return
	 */
	public static String generalRandom(){
		//生成6位不重复的随机数 start
		int[] array = {0,1,2,3,4,5,6,7,8,9};
		Random rand = new Random();
		for (int i = 10; i > 1; i--) {
		    int index = rand.nextInt(i);
		    int tmp = array[index];
		    array[index] = array[i - 1];
		    array[i - 1] = tmp;
		}
		int result = 0;
		for(int i = 0; i < 6; i++)
		    result = result * 10 + array[i];
		LoggerUtils.info(result);
		//生成6位不重复的随机数 end
		return String.valueOf(result);
	}
	                             
  	/**
  	 * 获取日期时间差
  	 * @param endTime yyyy-MM-dd HH:mm:ss格式
  	 * @return 日期加时间 [yyyy-MM-dd HH:mm:ss]
  	 */
  	public synchronized static String getDateTimeDifference(String endTime){
  		if (StringUtils.isBlank(endTime)) {
  			return "不能使用空字符串!,请输入一个日期yyyy-MM-dd HH:mm:ss格式.";
		}

  		SimpleDateFormat formatTime=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
  		SimpleDateFormat formatDate=new SimpleDateFormat("yyyy-MM-dd", Locale.CHINA);
  		Date begin=new Date();
  		
  		Date end=null;
  		try {
  			end=formatTime.parse(endTime);
  			LoggerUtils.info("end:"+formatTime.format(end));
		} catch (Exception e) {
			return "日期格式不正确!";
		}
  		Long beginL=begin.getTime();
  		LoggerUtils.info("beginL:"+formatTime.format(beginL));
  		Long endL=end.getTime();
  		LoggerUtils.info("endL"+formatTime.format(endL));
  	/*	if (beginL>endL) {
  			
  			return "结束时间小于开始时间!";
  		}*/
  		String now=formatDate.format(new Date());
  		Long cha=endL-beginL;
  		try {
  			String s = null;
  			s=formatTime.format(new Date(formatDate.parse(now).getTime()+ cha));
			return s;
		} catch (ParseException e) {
			return "计算日期差值出错!";
		}
  	}
  	/**
  	 * 获取时间差
  	 * @param endTime yyyy-MM-dd HH:mm:ss格式
  	 * @return 时间差值[时:分:秒]
  	 */
  	public synchronized static String getTimeDifference(String endTime){
  		
  		if (StringUtils.isBlank(endTime)) {
  			return "不能使用空字符串!,请输入一个日期yyyy-MM-dd HH:mm:ss格式.";
		}
  		LoggerUtils.info(endTime);
  		String[] times=getDateTimeDifference(endTime).split(" ");
  		LoggerUtils.info(times);
  		if (times.length>0) {
			return times[1];
		}else{
			return "没有分钟值";
		}
	}
  	/**
  	 * 获取时间差值的数组
  	 * @param endTime yyyy-MM-dd HH:mm:ss格式
  	 * @return 时间差值数组[时,分,秒]
  	 */
  	public synchronized static String[] getTimesDifference(String endTime) {
  		if (StringUtils.isBlank(endTime)) {
  			throw new RuntimeException("不能使用空字符串!,请输入一个日期yyyy-MM-dd HH:mm:ss格式.");
		}
		return getTimeDifference(endTime).split(":");
	}
	/**
	 * 获取日期差
	 * @param endTime yyyy-MM-dd HH:mm:ss格式或者传入yyyy-MM-dd格式,将会自动在后面添加00:00:00
	 * @return 日期天数间隔[天]
	 */
  	public synchronized static String getDateDifference(String endTime){
  		if (StringUtils.isBlank(endTime)) {
  			return "不能使用空字符串!,请输入一个日期yyyy-MM-dd HH:mm:ss格式.";
		}
  		String[] end=endTime.split(" ");
  		if (end.length>0&&end.length<2) {
			endTime=endTime+" 00:00:00";
		}
  		String date=getDateTimeDifference(endTime).split(" ")[0];
  		date=date.split("-")[2];
		return date;
	}
  	/**
  	 * 
  	 * @Description: 去除字符串中的空格、回车、换行符、制表符
  	 * @param @param str
  	 * @param @return   
  	 * @return String  
  	 * @throws
  	 * @author XT
  	 * @date 2014年12月2日
  	 */
    public synchronized static String replaceBlank(String str) {
        String dest = "";
        if (str!=null) {
            Pattern p = Pattern.compile("\\s*|\t|\r|\n");
            java.util.regex.Matcher m = p.matcher(str);
            dest = m.replaceAll("");
        }
        return dest;
    }
    public synchronized static String timeDifference(String endTime){
       SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	
    	long l;
    	String timeDate=null;
		try {
			l = sdf.parse(endTime).getTime() - new Date().getTime();
			if (l > 0) {
	              long day = l / (24 * 60 * 60 * 1000);
	              long hour = (l / (60 * 60 * 1000) - day * 24);
	              long min = ((l / (60 * 1000)) - day * 24 * 60 - hour * 60);
	              long se = (l / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
	              timeDate = hour+":"+min+":"+se;
	             // LoggerUtils.info("：" + hour + "小时" + min + "分" + se + "秒 ");
	              LoggerUtils.info("timeDate:"+timeDate);
	    }
		} catch (ParseException e) {
			e.printStackTrace();
		}
          
		return timeDate;
}
	public synchronized static void writeJson(HttpServletResponse response,String msg) throws IOException {
		ResultInfo info=new ResultInfo(true,msg);
		JSONObject json=JSONObject.fromObject(info);
		response.setContentType("text/html;charset=utf-8");
		response.getOutputStream().write(json.toString().getBytes("utf-8"));
	}
	private synchronized static int getFontSize(int height) {
		int size=4;
		if (height>200&&height<400) {
			size=16;
		}else if (height>400&&height<500) {
			size=25;
		}else if (height>500&&height<600) {
			size=30;
		}else if (height>600&&height<800) {
			size=35;
		}else if (height>800&&height<1000) {
			size=40;
		}else{
			size=48;
		}
		return size;
	}
	/**
     * 打印文字水印图片
	 * @param watermark 是否添加水印默认添加
     * @param targetImg --
     *            目标图片
     * @param fontName --
     *            字体名
     * @param fontStyle --
     *            字体样式
     * @param color --
     *            字体颜色
     * @param fontSize --
     *            字体大小
     * @param x --
     *            偏移量
     * @param y
     */
    public static void pressText(File file,MultipartFile fileReq, String watermark) {
    	String ext=FilenameUtils.getExtension(file.getName());
    	if (StringUtils.isNotBlank(watermark)||StringUtils.isBlank(ConfigFile.TEXT_WATERMARK)) {
    		try {
				fileReq.transferTo(file);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} 
    		return;
		}
    	if ("jpg".equalsIgnoreCase(ext)||"png".equalsIgnoreCase(ext)||"gif".equalsIgnoreCase(ext)||"jpeg".equalsIgnoreCase(ext)||"bmp".equalsIgnoreCase(ext)) {
        try {
            ByteInputStream stream= new ByteInputStream(fileReq.getBytes(), fileReq.getBytes().length);
            Image src = ImageIO.read(stream);
            int wideth = src.getWidth(null);
            int height = src.getHeight(null);
            int fontSize=getFontSize(wideth);
            int x=wideth/10;
            int y=height/10;
            BufferedImage image = new BufferedImage(wideth, height,
                    BufferedImage.TYPE_INT_RGB);
            Graphics2D g = image.createGraphics();
            g.drawImage(src, 0, 0, wideth, height, null);
            String[] pressText=new String(ConfigFile.TEXT_WATERMARK).split(":");            
            g.setColor(new Color(159, 147, 123));//|Font.ITALIC
            g.setFont(new Font("宋体", Font.BOLD, fontSize));
            g.rotate(Math.toRadians(20));//,(double) x, (double) y);
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP,0.8f));
            g.drawString(pressText[0],  x,y );
//            g.drawString(pressText[1],  x,y+fontSize+30);
//            g.drawString(pressText[2],  x+20,y+fontSize+100);
            g.dispose();
            if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
            FileOutputStream out = new FileOutputStream(file);
            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
            encoder.encode(image); 
            out.close();
        } catch (Exception e) {
           e.printStackTrace();
        }
    	}else if("xls".equals(ext)||"xlsx".equals(ext)){//修改 
    		try {
				fileReq.transferTo(file);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} 
    	}else{	//修改 
    		try {
				fileReq.transferTo(file);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} 
    	}
    	
    }
    /**
     * 获取客户端访问
     * @param request
     * @return
     */
	public static synchronized String getPctype(HttpServletRequest request) {
		String requestHeader = request.getHeader("user-agent");
		String[] deviceArray = new String[]{"android","mac os","windows phone"};
		String pctype=null;
        if(requestHeader == null){
        	pctype="pc/";
        }
        requestHeader = requestHeader.toLowerCase();
        LoggerUtils.info("使用web浏览器");
        pctype="pc/";
        if (ConfigFile.DEBUG_PHONE) {
        	pctype="phone/";
        }
        for(int i=0;i<deviceArray.length;i++){
            if(requestHeader.indexOf(deviceArray[i])>0){
            	LoggerUtils.info("使用手机浏览器");
            	pctype="phone/";
            }
        }
        return pctype;
	}
	/**
	 * 获取txt中的配置信息
	 * @param buffer
	 * @return
	 * @throws FileNotFoundException
	 */
	public static synchronized Map<String,Object> getTxtKeyVal(StringBuffer buffer) throws FileNotFoundException {
		File file=new File(buffer.toString());
		if (file.exists()&&file.isFile()) {
			Scanner scanner=new Scanner(file,"UTF-8");
			Map<String,Object> map=new HashMap<String, Object>();
			while (scanner.hasNext()) {
				String item = scanner.nextLine();
				if (!item.startsWith("#")) {//不是以#开头的
					String[] keys=item.split("=");
					if (keys.length>1) {///将从配置文件中读取出来的放入到map中
						map.put(keys[0], keys[1]);
					}
				}
			}
			scanner.close();
			return map;
		}
		return null;
	}
	/**
	 * 获取txt中的配置信息
	 * @param buffer
	 * @return
	 * @throws IOException 
	 */
	public static synchronized Map<String,Object> getTxtKeyVal(InputStream in) throws IOException {
		if (in!=null) {
			Scanner scanner=new Scanner(in,"UTF-8");
			Map<String,Object> map=new HashMap<String, Object>();
			while (scanner.hasNext()) {
				String item = scanner.nextLine();
				LoggerUtils.info(item);
				if (!item.startsWith("#")) {//不是以#开头的
					String[] keys=item.split("=");
					if (keys.length>1) {///将从配置文件中读取出来的放入到map中
						map.put(keys[0], keys[1]);
					}
				}
			}
			scanner.close();
			in.close();
			return map;
		}
		return null;
	}
	/**
	 * 删除客户
	 * @param file
	 */
	public static synchronized void deleteFile(File file) {
		if (file.exists()&&file.isFile()) {
			file.delete();
		}
	}
	/**
	 * 判断是否是文件和文件是否存在
	 * @param file
	 * @return 存在是文件就返回truem,反之返回false
	 */
	public static synchronized boolean isFile(File file) {
		if (file.exists()&&file.isFile()) {
			return true;
		}
		return false;
	}
	
	/**
	  * 解压zip或者rar包的内容到指定的目录下，可以处理其文件夹下包含子文件夹的情况
	  *
	  * @param zipFilename
	  *            要解压的zip或者rar包文件
	  * @param outputDirectory
	  *            解压后存放的目录
	  */
	 public static synchronized void unzip(String zipFilename, String outputDirectory)
	   throws IOException {
	  File outFile = new File(outputDirectory);
	  if (!outFile.exists()) {
	   outFile.mkdirs();
	  }
	  ZipFile zipFile = new ZipFile(zipFilename);
	  Enumeration en = zipFile.entries();
	  ZipEntry zipEntry = null;
	  while (en.hasMoreElements()) {
	   zipEntry = (ZipEntry) en.nextElement();
	   if (zipEntry.isDirectory()) {
	    // mkdir directory
	    String dirName = zipEntry.getName();
	    //System.out.println("=dirName is:=" + dirName + "=end=");
	    dirName = dirName.substring(0, dirName.length() - 1);
	    File f = new File(outFile.getPath() + File.separator + dirName);
	    f.mkdirs();
	   } else {
	    //unzip file
	    String strFilePath = outFile.getPath() + File.separator
	      + zipEntry.getName();
	    File f = new File(strFilePath);
	    //the codes remedified by can_do on 2010-07-02 =begin=
	    // /////begin/////
	   //判断文件不存在的话，就创建该文件所在文件夹的目录
	    if (!f.exists()) {
	     String[] arrFolderName = zipEntry.getName().split("/");
	     String strRealFolder = "";
	     for (int i = 0; i < (arrFolderName.length - 1); i++) {
	      strRealFolder += arrFolderName[i] + File.separator;
	     }
	     strRealFolder = outFile.getPath() + File.separator
	       + strRealFolder;
	     File tempDir = new File(strRealFolder);
	     //此处使用.mkdirs()方法，而不能用.mkdir()
	     tempDir.mkdirs();
	    }
	    //////end///
	    // the codes remedified by can_do on 2010-07-02 =end=
	    f.createNewFile();
	    InputStream in = zipFile.getInputStream(zipEntry);
	    FileOutputStream out = new FileOutputStream(f);
	    try {
	     int c;
	     byte[] by = new byte[BUFFEREDSIZE];
	     while ((c = in.read(by)) != -1) {
	      out.write(by, 0, c);
	     }
	     //out.flush();
	    } catch (IOException e) {
	     throw e;
	    } finally {
	     out.close();
	     in.close();
	    }
	   }
	  }
	 }
	 private static final int BUFFEREDSIZE = 1024;
	 
}
