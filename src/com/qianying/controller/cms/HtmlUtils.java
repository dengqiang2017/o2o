package com.qianying.controller.cms;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.qianying.bean.ResultInfo;
import com.qianying.util.LoggerUtils;

import freemarker.template.Configuration;
import freemarker.template.Template;

public abstract class HtmlUtils {
	/**
	 * 新生成或者替换后生成新的html内容
	 * 
	 * @param destpath
	 *            文件生成路径
	 * @param newContent
	 *            需要替换的html内容
	 */
	public static ResultInfo saveHtmlContent(String destpath, String newContent) {
		boolean success = false;
		String msg = null;
		try {
			if (StringUtils.isBlank(newContent)) {
				msg="保存页面数据不能为空";
			}else{
				// 1.组装html内容&&newContent.contains("<head>")
				StringBuffer buffer =new StringBuffer();
//				if (!newContent.contains("<!Doctype html>")) {
//					buffer.append("<!Doctype html><html>");
//					buffer.append(newContent).append("</html>");
//				}else {
					buffer.append(newContent);
//				}
				destpath=destpath.split("\\?")[0];
				File file = new File(destpath);// 2.新文件路径准备
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}else if (file.exists()&&file.isFile())// 2.2判断将要另存的文件是否存在,存在就删除,
					file.delete();
				else
					file.createNewFile();
				// 2.3设置保存路径
				OutputStreamWriter out = new OutputStreamWriter(new FileOutputStream(destpath),"UTF-8");
				// 3.开始生成html文件
				out.write(buffer.toString());
				out.flush();
				out.close();
				success = true;
			}
		} catch (FileNotFoundException e) {
			msg = "文件找不到!" + e.getMessage();
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			msg = e.getMessage();
			e.printStackTrace();
		} catch (IOException e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 新生成或者替换后生成新的html内容
	 * 
	 * @param srcpath
	 *            源html路径
	 * @param destpath
	 *            新生成
	 * @param newContent
	 *            需要替换的html内容
	 */
	@SuppressWarnings("resource")
	public static void saveHtmlContent(String srcpath, String destpath,
			String newContent) {
		try {
			FileReader fr = new FileReader(srcpath);// 1.获取文件
			BufferedReader br = new BufferedReader(fr);
			String node = null;
			StringBuffer buffer = new StringBuffer();
			System.out.println("=================原始文件html内容==============");
			while ((node = br.readLine()) != null) {// 1.将内容读取到buffer内存中
				buffer.append(node);
			}
			int startIndex = buffer.indexOf("<body>");// 1.2查找到需要替换的标签
			int endIndex = buffer.lastIndexOf("</body>");
			if (startIndex != -1 && endIndex != -1) {// 1.3判断标签是否存在

				StringBuffer str = buffer.replace(startIndex, endIndex,
						newContent);//
				File file = new File(destpath);// 2.新文件路径准备
				if (file.exists()&&file.isFile())// 2.2判断将要另存的文件是否存在,存在就删除,
					file.delete();
				else
					file.createNewFile();
				FileWriter fileWriter = new FileWriter(destpath);
				fileWriter.write(str.toString());// 3.开始文件另存储
				fileWriter.flush();
				fileWriter.close();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据模板创建文件
	 * 
	 * @param path
	 *            路径
	 * @param ftlFile
	 *            模板文件
	 * @param destPath
	 *            生成文件目标路径
	 * @param filename
	 *            文件名
	 * @param data
	 *            模板数据源
	 * @throws Exception
	 */
	public static void createFileByTemplet(String path, String ftlFile,
			String destPath, String filename, Map<String, Object> data)
			throws Exception {
		Configuration configuration = new Configuration();
		configuration.setDirectoryForTemplateLoading(new File(path));
		// 加载模板文件
		Template template = configuration.getTemplate(ftlFile);
		File filePath = new File(destPath);
		if (!filePath.exists()) {
			filePath.mkdirs();
		}
		File file = new File(filePath.getPath() + filename);
		LoggerUtils.info(file.getPath());
		if (!file.exists()) {
			file.createNewFile();
		}
		// 显示生成的数据
		Writer writer = new FileWriter(file);
		template.process(data, writer);
		writer.flush();
		writer.close();
	}
}
