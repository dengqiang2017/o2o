package com.qianying.controller.cms;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.qianying.controller.FilePathController;
import com.qianying.service.IManagerService;

@Controller
@RequestMapping("/smg")
public class CmsController  extends FilePathController{
	@Autowired
	private IManagerService managerService;
	/**
	 * 文章短链接j跳转到文章详情页
	 * @param request
	 * @param response
	 * @param id 文章id
	 * @return 重定向到文章详情页
	 * @throws Exception
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public String shortUrlToInfoUrl(HttpServletRequest request,HttpServletResponse response,@PathVariable("id") Integer id) throws Exception {
		if (id!=null&&id>0) {
		Map<String,Object> map=new HashMap<>();
		map.put("id", id);
		map= managerService.getArticleInfoData(map);
		if (map!=null) {
			if (isNotMapKeyNull(map, "htmlname")) {
				StringBuilder builder=new StringBuilder("");
				if (MapUtils.getString(map, "htmlname").contains("001")) {
					builder.append("/client/article_detail.jsp?url=").append(map.get("htmlname")); 
				}else{
					if (MapUtils.getString(map, "projectName").startsWith("p")&&MapUtils.getString(map, "projectName").length()<=3) {
						builder.append("/").append(map.get("projectName")).append("/case_detail.jsp?url=");
					}else{
						builder.append("/").append(map.get("projectName")).append("/article_detail.jsp?url=");
					}
					builder.append(map.get("projectName")).append("/article/").append(map.get("type"));
					builder.append("/").append(map.get("htmlname"));
				}
				response.sendRedirect(builder.toString());
			}
		}
		}else{
			throw new RuntimeException("参数错误!");
		}
		return null;
	}
}
