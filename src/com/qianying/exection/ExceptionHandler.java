package com.qianying.exection;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import com.qianying.controller.BaseController;
import com.qianying.util.ConfigFile;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
import com.qianying.util.SendMail;

public class ExceptionHandler implements HandlerExceptionResolver{

	@Override
	public ModelAndView resolveException(HttpServletRequest request,   
            HttpServletResponse response, Object handler, Exception ex) {
		ModelAndView mv=new ModelAndView("wrong");
		LoggerUtils.error(LogUtil.getIpAddr(request));
		ex.printStackTrace();
		try {
			SendMail.sendSinaMail("系统错误"+BaseController.getRealPath(request), ConfigFile.urlPrefix+"\r\n"+ex.getMessage()+"\r\n"+ex.toString(), null, "1376528532@qq.com");
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return mv;
	}
}
