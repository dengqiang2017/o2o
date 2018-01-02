package com.qianying.util;

import java.io.File;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang.StringUtils;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import sun.util.logging.resources.logging;

public class SendMail {
//	/**
//	 * 
//	 * @param tomail
//	 * @param subject
//	 * @param text
//	 */
//	public static void  sendmail2(String tomail,String subject,String text) {
//		String username = "1376528532@qq.com"; // smtp认证用户名和密码
//		String password = "jxesbsvelasffhhf";
//		String host = "smtp.qq.com"; // 发件人使用发邮件的电子信箱服务器
//		String from = "1376528532@qq.com";
//		Properties props = System.getProperties();
//		props.put("mail.smtp.host", host);
//		props.put("mail.smtp.auth", "true");
//		props.put("mail.smtp.socketFactory.class",
//				"javax.net.ssl.SSLSocketFactory");
//		props.put("mail.smtp.socketFactory.fallback", "false");
//		props.put("mail.smtp.socketFactory.port", "465");
//		props.put("mail.debug", "false");
//		MyAuthenticator myauth = new MyAuthenticator(username, password);
//		Session session = Session.getDefaultInstance(props, myauth);
//		MimeMessage message = new MimeMessage(session);
//		try {
//			message.setFrom(new InternetAddress(from));
//			InternetAddress[] address = InternetAddress.parse(tomail);
//			message.setRecipients(Message.RecipientType.TO, address);
//			message.setSubject(subject);
////			message.setText(text);
//			 MimeBodyPart textb = new MimeBodyPart();  
//			textb.setContent(text+"<img src='cid:a'>", "text/html;charset=gb2312");
//			// 创建图片  
//            MimeBodyPart img = new MimeBodyPart();
//            /* 
//             * JavaMail API不限制信息只为文本,任何形式的信息都可能作茧自缚MimeMessage的一部分. 
//             * 除了文本信息,作为文件附件包含在电子邮件信息的一部分是很普遍的. JavaMail 
//             * API通过使用DataHandler对象,提供一个允许我们包含非文本BodyPart对象的简便方法. 
//             */  
//            DataHandler dh = new DataHandler(new FileDataSource(ConfigFile.getProjectPath()+"pc/image/bg.png"));//图片路径  
//            img.setDataHandler(dh);  
//            // 创建图片的一个表示用于显示在邮件中显示  
//            img.setContentID("a");
//            //////////////
//         // 关系 正文和图片的  
//            MimeMultipart mm = new MimeMultipart();  
//            mm.addBodyPart(textb);
//            mm.addBodyPart(img);  
//            mm.setSubType("related");// 设置正文与图片之间的关系  
//            // 图班与正文的 body  
//            MimeBodyPart all = new MimeBodyPart();  
//            all.setContent(mm);  
//			///////////
//			message.saveChanges();
//			Transport.send(message);
//		} catch (Exception ex) {
//			ex.printStackTrace();
//		}
//	}
	
//	public static void main(String[] args) {
//		sendmail("1095489191@qq.com","测试邮件发送","使用第三方进行邮件发送");
//	}
//	 public static void main(String args[]) throws MessagingException{
//	         sendSinaMail("文字加了个图片", "两个文字加图片",ConfigFile.getProjectPath()+"pc/image/bg.png", "14780007226@163.com","1095489191@qq.com");
//	        System.out.println(" 邮件发送成功.. ");  
//	    } 
	 public static boolean sendSinaMail(String subject,String text,String imgUrl,String...tomail) throws MessagingException {
		if (tomail==null||tomail.length==0) {
			return false;
		}
	 	JavaMailSenderImpl senderImpl = new JavaMailSenderImpl();  
        // 设定mail server  
        senderImpl.setHost("smtp.sina.cn");
        MimeMessage mailMessage = senderImpl.createMimeMessage();   
        MimeMessageHelper messageHelper = new MimeMessageHelper(mailMessage,true,"UTF-8");  
        // 设置收件人，寄件人 用数组发送多个邮件  
        // String[] array = new String[] {"sun111@163.com","sun222@sohu.com"};  
        // mailMessage.setTo(array);  
        messageHelper.setTo(tomail);
        messageHelper.setFrom("18224052021@sina.cn");
        senderImpl.setUsername("18224052021@sina.cn"); // 根据自己的情况,设置username  
        senderImpl.setPassword("dengqiang"); // 根据自己的情况, 设置password  
        messageHelper.setSubject(subject);   
        //true 表示启动HTML格式的邮件   
        StringBuffer bt=new StringBuffer("<html><head></head><body>");
        bt.append(text);
        String[] imgs=null;
        if (StringUtils.isBlank(imgUrl)) {
        	imgUrl="";
		}else{
			imgs=imgUrl.split(",");
			if (imgs!=null&&imgs.length>0) {
				for (int i = 0; i < imgs.length; i++) {
					bt.append("<img src=\"cid:img").append(i).append("\" style='width:300px;height:300px;'/>");
				}
			}
		}
        bt.append("</body></html>");
        messageHelper.setText(bt.toString(),true);
        if (StringUtils.isNotBlank(imgUrl)) {
        	if (imgs!=null&&imgs.length>0) {
        		for (int i = 0; i < imgs.length; i++) {
        			FileSystemResource img = new FileSystemResource(new File(ConfigFile.getProjectPath()+imgs[i].replaceAll("\\.\\.", "")));   
        			messageHelper.addInline("img"+i,img);
        		}
        	}
        }
        Properties prop = new Properties();  
        prop.put("mail.smtp.auth", "true"); // 将这个参数设为true，让服务器进行认证,认证用户名和密码是否正确  
        prop.put("mail.smtp.timeout", "25000");  
        senderImpl.setJavaMailProperties(prop);  
        // 发送邮件  
        try {
        	senderImpl.send(mailMessage);
		} catch (Exception e) {
			LoggerUtils.error(e.getMessage());
		}
        return true;
	}
}

//class MyAuthenticator extends javax.mail.Authenticator {
//	private String strUser;
//	private String strPwd;
//
//	public MyAuthenticator(String user, String password) {
//		this.strUser = user;
//		this.strPwd = password;
//	}
//
//	protected PasswordAuthentication getPasswordAuthentication() {
//		return new PasswordAuthentication(strUser, strPwd);
//	}
//
//}
