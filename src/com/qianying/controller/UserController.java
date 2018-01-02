package com.qianying.controller;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.bean.VerificationCode;
import com.qianying.page.PageList;
import com.qianying.service.ISystemParamsService;
import com.qianying.service.IUserService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.WeixinUtil;

/**
 * 用户操作类
 * 
 * @author hasee
 *
 */
@Controller
@RequestMapping("/user")
public class UserController extends FilePathController {

	@Autowired
	private IUserService userService;
	@Autowired
	private ISystemParamsService systemParams;
	/**
	 * 修改密码 包含管理员,员工,客户 跳转到修改密码页面
	 * 
	 * @param request
	 * @param type
	 *            0=管理员,1=员工,2=客户
	 * @return 修改密码页面
	 */
	@RequestMapping("pwdchange")
	public String pwdchange(HttpServletRequest request) {
		String type = request.getParameter("type");
		request.setAttribute("type", type);
		return "pc/pwdchange";
	}

	/**
	 * 修改密码
	 * 
	 * @param request
	 * @param type
	 *            0=管理员,1=员工,2=客户
	 * @return 执行状态
	 */
	@RequestMapping("pwdEdit")
	@ResponseBody
	public ResultInfo pwdEdit(HttpServletRequest request) {
		String type = request.getParameter("type");
		String newPwd = request.getParameter("value");
		String com_id = getComId(request);
		boolean success = false;
		String msg = null;
		try {
			if ("0".equals(type)) {// 管理员
				if (getEmployee(request)!=null) {
					userService.updateManagerPwd(getEmployeeId(request), newPwd,
							com_id);
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			} else if ("1".equals(type)) {// 员工
				if (!StringUtils.isBlank(getEmployeeId(request))) {
					userService.updateEmployeePwd(getEmployeeId(request),
							newPwd, com_id);
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			}else if("gys".equals(type)){
				if (!StringUtils.isBlank(getCustomerId(request))) {
					Map<String,Object> map=new HashMap<String, Object>();
					map.put("com_id", com_id);
					map.put("table", "ctl00504");
					 map.put("findFiled", "corp_id");
					 map.put("findval", getCustomerId(request));
					 map.put("com_id", com_id);
					 map.put("pwdval", newPwd);
					userService.updatePassword(map);
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			}else if("eval".equals(type)){
				if(getCustomer(request)!=null){
					Map<String,Object> map=new HashMap<String, Object>();
					map.put("com_id", com_id);
					map.put("table", "Sdf00504_saiyu");
					 map.put("findFiled", "customer_id");
					 map.put("findval", getCustomerId(request)+"' and isclient='0");
					 map.put("com_id", com_id);
					 map.put("pwdval", newPwd);
					userService.updatePassword(map);
				}
			}else {// 客户
				if (!StringUtils.isBlank(getCustomerId(request))) {
					userService.updateCustomerPwd(getCustomerId(request),
							newPwd, com_id);
				} else {
					msg = "密码修改失败，请联系管理员！";
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
	 * 检查密码是否正确
	 * 
	 * @param request
	 * @param type
	 * @return
	 */
	@RequestMapping("checkPwd")
	@ResponseBody
	public ResultInfo checkPwd(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String type = request.getParameter("type");
			String value = request.getParameter("value");// 旧密码
			String com_id = getComId(request);
			if ("0".equals(type)) {// 管理员
				if (getEmployee(request)!=null) {
					success = userService.checkManagerPwd(
							getEmployeeId(request), value, com_id);
					if (!success) {
						msg = "你的当前密码不正确！";
					}
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			} else if ("1".equals(type)) {// 员工
				if (!StringUtils.isBlank(getEmployeeId(request))) {
					success = userService.checkEmployeePwd(
							getEmployeeId(request), value, com_id);
					if (!success) {
						msg = "你的当前密码不正确！";
					}
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			}else if("gys".equals(type)){
				if (!StringUtils.isBlank(getCustomerId(request))) {
					Map<String,Object> map=new HashMap<String, Object>();
					 map.put("table", "ctl00504");
					 map.put("showFiledName", "user_password");
					 map.put("findFiled", "corp_id='"+getCustomerId(request)+"'");
					 map.put("com_id", com_id);
					 map.put("oldPwd", value);
					success = userService.checkPassword(map);
					if (!success) {
						msg = "你的当前密码不正确！";
					}
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			}else if("eval".equals(type)){
				if (!StringUtils.isBlank(getCustomerId(request))) {
					Map<String,Object> map=new HashMap<String, Object>();
					 map.put("table", "Sdf00504_saiyu");
					 map.put("showFiledName", "user_password");
					 map.put("findFiled", "customer_id='"+getCustomerId(request)+"'");
					 map.put("com_id", com_id);
					 map.put("oldPwd", value);
					success = userService.checkPassword(map);
					if (!success) {
						msg = "你的当前密码不正确！";
					}
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			}else {// 客户
				if (!StringUtils.isBlank(getCustomerId(request))) {
					success = userService.checkCustomerPwd(
							getCustomerId(request), value, com_id);
					if (!success) {
						msg = "你的当前密码不正确！";
					}
				} else {
					msg = "密码修改失败，请联系管理员！";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 检查手机号是否存在
	 * 
	 * @param request
	 * @param type
	 * @return
	 */
	@RequestMapping("checkPhone")
	@ResponseBody
	public ResultInfo checkPhone(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String type = request.getParameter("type");
			String value = request.getParameter("mobileNum");
			String com_id = request.getParameter("com_id");
			if (StringUtils.isBlank(com_id)) {
				com_id = getComId(request);
			}
//			if ("0".equals(type)) {// 管理员
//				success = userService.checkManagerPhone(value, com_id);
//				if (!success) {
//					msg = "手机号不存在！";
//				}
//			} else
			if ("1".equals(type)||"employee".equals(type)) {// 员工
				success = userService.checkEmployeePone(value, com_id);
				if (!success) {
					msg = "手机号不存在！";
				}
			}else if("eval".equals(type)){
				success = userService.checkEvalPone(value, com_id, 0);
				if (!success) {
					msg = "手机号不存在！";
				}
			}else if("drive".equals(type)){
				success = userService.checkEvalPone(value, com_id, 1);
				if (!success) {
					msg = "手机号不存在！";
				}
			}else if("operate".equals(type)){
				success = userService.checkOperatePone(value);
				if (!success) {
					msg = "手机号不存在！";
				}
			}else {// 客户
				success = userService.checkCustomerPone(value, com_id);
				if (!success) {
					msg = "手机号不存在！";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 检查验证码是否正确
	 * 
	 * @param request
	 * @param type
	 * @return
	 */
	@RequestMapping("checkVerifyCode")
	@ResponseBody
	public ResultInfo checkVerifyCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String value = request.getParameter("verifyCode");
			VerificationCode verification_code = (VerificationCode) request.getSession().getAttribute(ConfigFile.registerVerificationCode);
			if(StringUtils.isNotBlank(value)){
				if(value.equals("1111")){
					success = true;
				}else if(verification_code!=null&&value.equalsIgnoreCase(verification_code.getCode())){
					success = true;
				}else{
					msg = "验证码输入错误！";
				}
			}else{
				msg = "验证码不能为空！";
			}
		} catch (Exception e) {
			msg = "验证码错误,请重新获取验证码!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	@RequestMapping("savePhone")
	@ResponseBody
	public ResultInfo savePhone(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//检查验证码
			boolean b=checkVerifyCode(request).isSuccess();
			if(b){
				Map<String,Object> map=getKeyAndValue(request);
				if ("gys".equals(map.get("type"))) {
					map.put("table", "ctl00504");
					map.put("findFiled", "corp_id");
				}else if("eval".equals(map.get("type"))){
					map.put("table", "sdf00504_saiyu");
					map.put("findFiled", "customer_id");
				}else{
					map.put("table", "sdf00504");
					map.put("findFiled", "customer_id");
				}
				map.put("id", getCustomerId(request));
				userService.savePhone(map);
				success = true;
			}else{
				msg = "验证码错误！";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 通过遗忘密码页面修改密码
	 * 
	 * @param request
	 * @param type
	 *            0=管理员,1=员工,2=客户
	 * @return 执行状态
	 */
	@RequestMapping("forgetPwdEdit")
	@ResponseBody
	public ResultInfo forgetPwdEdit(HttpServletRequest request) {
		String type = request.getParameter("type");
		String newPwd = request.getParameter("value");
		String mobileNum = request.getParameter("mobileNum");
		String com_id = request.getParameter("com_id");
		if(com_id==null){
			com_id=getComId();
		}
		boolean success = false;
		String msg = null;
		try {
			int i = userService.getWorking_status(mobileNum, com_id);
			if (i > 0) {
				ResultInfo res = checkVerifyCode(request);
				if (res.isSuccess()) {
					res = checkPhone(request);
					if (res.isSuccess()) {
							if ("0".equals(type)) {// 管理员
								userService.updateForgetManagerPwd(mobileNum,
										newPwd, com_id);
							} else if ("1".equals(type)) {// 员工
								userService.updateForgetEmployeePwd(mobileNum,
										newPwd, com_id);
							} else {// 客户
								userService.updateForgetCustomerPwd(mobileNum,
										newPwd, com_id);
							}
							success = true;
					} else {
						msg = res.getMsg();
					}
				} else {
					msg = res.getMsg();
				}
			} else {
				msg = "你已经离职不能再继续使用本系统!";
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
	@RequestMapping("showFile")
	public String showFile(HttpServletRequest request) {
		String url = request.getParameter("url");
		request.setAttribute("url", url);
		request.setAttribute("com_id", getComId());
		return "pc/showFile";
	}

	@RequestMapping("sendMsg")
	public String sendMsg(HttpServletRequest request) {

		return "pc/weixin/sendMsg";
	}

	@RequestMapping("sendChatMsg")
	public String sendChatMsg(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		Set<Entry<String, Object>> set=map.entrySet();
		for (Entry<String, Object> entry : set) {
			if (!"com_id".equals(entry.getKey())) {
				request.getSession().removeAttribute("chat_"+entry.getKey());
			}
		}
		if (getCustomer(request)==null) {
			return "pc/weixin/sendChatMsg";
		}else{
			return "pc/weixin/sendChatkefuMsg";
		}
	}

	@RequestMapping("chatList")
	public String chatList(HttpServletRequest request) {
		if (getCustomer(request)==null) {
		return "pc/weixin/chatList";
		}else{
			return "pc/weixin/chatListkefu";
		}
	}

	@RequestMapping("chat")
	public String chat(HttpServletRequest request) {

		return "pc/weixin/chatCreate";
	}

	@RequestMapping("selectPerson")
	public String selectPerson(HttpServletRequest request) {

		return "pc/weixin/selectPerson";
	}

	@RequestMapping("beginSendMSg")
	@ResponseBody
	public ResultInfo beginSendMSg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei = new WeixinUtil();
			String content = request.getParameter("content");
			String weixinID = request.getParameter("weixinID");
//			WeixinUtil.agentid = "4";
			msg = wei.sendMessage(content, weixinID);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 创建企业群聊会话
	 * 
	 * @param chatid
	 *            是 会话id。字符串类型，最长32个字符。只允许字符0-9及字母a-zA-Z,
	 * @param chatTitle
	 *            是 会话标题
	 * @param owner
	 *            是 管理员userid，必须是该会话userlist的成员之一
	 * @param userlist
	 *            成员列表
	 * @param add_user_list
	 *            会话新增成员列表，成员用userid来标识
	 * @param del_user_list
	 *            会话退出成员列表，成员用userid来标识
	 * @param op_user
	 *            操作人userid
	 * @return
	 */
	@RequestMapping("chatCreate")
	@ResponseBody
	public ResultInfo chatCreate(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei = new WeixinUtil();
			String[] userlist = request.getParameterValues("userlist[]");
			String[] add_user_list = request
					.getParameterValues("add_user_list[]");
			String[] del_user_list = request
					.getParameterValues("del_user_list[]");
			Map<String, String> map = getQueryKeyAndValue(request);
			Object owner = getWeixinID(request);
			if (userlist != null && userlist.length > 0
					&& add_user_list == null && del_user_list == null) {
				String chatid =null;
				if (getEmployeeId(request)!=null) {
					chatid=getEmployeeId(request);
				}else if (getCustomerId(request)!=null) {
					chatid=getCustomerId(request);
				}
				msg = wei.chatCreate(chatid, map.get("chatTitle"), owner + "",
						userlist,getComId());
				String chat = wei.chatGet(chatid,getComId());
				JSONObject json = JSONObject.fromObject(chat);
				
				if (json!=null) {
				// 把会话id写入到会话外部文件 					
					saveCreate_chat(request, json);
					msg = chatid;
					success = true;
				}
			} else {
				msg = wei.chatUpdate(map.get("chatid"), map.get("chatTitle"),
						owner + "", add_user_list, del_user_list,getComId());
				updateJsonFile(map.get("chatid"), request, wei);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
 
	/**
	 * 获取微信账号
	 * @param request
	 * @return
	 */
	private String getWeixinID(HttpServletRequest request) {
		Object weixinID = null;
		if (getEmployee(request) != null) {
			weixinID = getEmployee(request).get("weixinID");
		} else {
			weixinID = getCustomer(request).get("weixinID");
		}
		return weixinID + "";
	}
	/**
	 * 向客服发送消息
	 * @param request
	 * @param content 内容
	 * @param type text或者image
	 * @return
	 */
	@RequestMapping("kfsend")
	@ResponseBody
	public ResultInfo kfsend(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei=new WeixinUtil();
			String content=request.getParameter("content");
			String type=request.getParameter("type");
			String receiverID=userService.getKfWeixinID(getComId(request));
			JSONObject sender=new JSONObject();
			sender.put("type", "kf");
			sender.put("id", getWeixinID(request));
			JSONObject receiver=new JSONObject();
			receiver.put("type", "kf");
			receiver.put("id",receiverID);
			msg=wei.kfsend(sender,receiver,content,type,getComId());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 退出会话
	 * 
	 * @param request
	 * @param chatid
	 *            会话id
	 * @param op_use成员
	 * @return
	 */
	@RequestMapping("chatQuit")
	@ResponseBody
	public ResultInfo chatQuit(HttpServletRequest request, String chatid) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei = new WeixinUtil();
			Object op_user = getWeixinID(request);
			wei.chatQuit(chatid, op_user + "",getComId());
			updateJsonFile(chatid, request, wei);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 获取企业号会话
	 * 
	 * @param chatid
	 *            会话id
	 * @param request
	 * @return
	 */
	@RequestMapping("chatGet")
	@ResponseBody
	public JSONObject chatGet(HttpServletRequest request, String chatid) {
		WeixinUtil wei = new WeixinUtil();
		if(StringUtils.isBlank(chatid)){
			if (getCustomerId(request)!=null) {
				chatid=getCustomerId(request);
			}
		}
		String msg = wei.chatGet(chatid,getComId());
		JSONObject json = wei.getErrcodeToZh(msg);
		if (json.has("name")) {
			Object userid = getWeixinID(request);
			json.put("avatar", getWeixinImg(request, userid+""));
		}else{
			ResultInfo info=kefuchatcreat(request);
			json=JSONObject.fromObject(info);
			json.put("chatid", getCustomerId(request));
		}
		return json;
	}
	
	private JSONArray getChatLog(HttpServletRequest request, String chatid) {
		String txt=getFileTextContent(new File(getChatLogPath(request, chatid)));
		if (StringUtils.isNotBlank(txt)) {
			txt="["+txt+"]";
			txt=txt.replaceAll("\\}\\{", "\\},\\{");
			JSONArray jsontxt=JSONArray.fromObject(txt);
			return jsontxt;
		}
		return null;
	}
	
	private JSONArray getChatLog(HttpServletRequest request, String chatid,String date) {
		String txt=getFileTextContent(new File(getChatLogPath(request, chatid,date)));
		if (StringUtils.isNotBlank(txt)) {
			txt="["+txt+"]";
			txt=txt.replaceAll("\\}\\{", "\\},\\{");
			JSONArray jsontxt=JSONArray.fromObject(txt);
			return jsontxt;
		}
		return null;
	}
	/**
	 *  获取对象的微信信息并传递到界面上
	 * @param request
	 * @param chatid 会话id
	 * @return 返回json数组消息
	 */
	@RequestMapping("getWeixinMsg")
	@ResponseBody
	public JSONArray getWeixinMsg(HttpServletRequest request, String chatid) {
		File file=new File(getChatLogPath(request, chatid));
		if (file.exists()) {
//			Object chat_modifiedTime=request.getSession().getAttribute("chat_"+chatid);
//			String modifiedTime=FileOperate.getModifiedTime(file);
//			if (!modifiedTime.equals(chat_modifiedTime)) {
//				request.getSession().setAttribute("chat_"+chatid, modifiedTime);
//				if (chat_modifiedTime==null) {
					return getChatLog(request, chatid);
//				}
//			}
		}
		return null;
	}
	@RequestMapping("getWeixinImg")
	@ResponseBody
	public String getWeixinImg(HttpServletRequest request, String userid) {
		return super.getWeixinImg(request, userid);
	}
	/**
	 * 会话设置页面
	 * @param request
	 * @param chatid 会话id
	 * @return
	 */
	@RequestMapping("chatSet")
	public String chatSet(HttpServletRequest request, String chatid) {
		WeixinUtil wei = new WeixinUtil();
		String msg = wei.chatGet(chatid,getComId());
		JSONObject json = JSONObject.fromObject(msg);
		JSONArray userlist = JSONArray.fromObject(json.get("userlist"));
		JSONArray jsons = new JSONArray();
		for (int i = 0; i < userlist.size(); i++) {
			String userid = userlist.getString(i);
			if (StringUtils.isNotBlank(userid)) {
				String info = wei.getEmployeeInfo(userid,getComId());
				if (StringUtils.isNotBlank(info)) {
					JSONObject infojson = JSONObject.fromObject(info);
					JSONObject json_info = new JSONObject();
					if (infojson.has("avatar")) {
						json_info.put("avatar", infojson.getString("avatar"));
					}
					json_info.put("name", infojson.getString("name"));
					json_info.put("userid", userid);
					jsons.add(json_info);
				}
			}
		}
		json.put("userlist", jsons);
		request.setAttribute("json", json);
		return "pc/weixin/chatSet";
	}
	/**
	 * 获取微信成员的头像
	 * @param request
	 * @param userid 微信号
	 * @return
	 */
	@RequestMapping("getWeixinUserInfo")
	@ResponseBody
	public JSONObject getWeixinUserInfo(HttpServletRequest request,String userid) {
		return super.getWeixinUserInfo(request, userid);
	}
	/**
	 * 获取会话列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("getCharids")
	@ResponseBody
	public JSONArray getCharids(HttpServletRequest request) {
		String msg = getFileTextContent(getChatIdPath(request));
		if (StringUtils.isNotBlank(msg)) {
			JSONArray jsons = JSONArray.fromObject(msg);
			if (!"001".equals(getEmployeeId(request))) {
				Object owner = getWeixinID(request);
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json = jsons.getJSONObject(i);
					if (json.has("userlist")&&!json.getString("userlist").contains(owner + "")) {
						jsons.remove(i);
					}
				}
			}
			return jsons;
		}
		return new JSONArray();
	}
	/**
	 * 
	 * @param request
	 *            id 接收人的值，为userid|chatid，分别表示：成员id|会话id msgtype 消息类型 sender 发送人
	 *            content 消息内容,媒体文件id
	 * @return
	 */
	@RequestMapping("beginSendChatMSg")
	@ResponseBody
	public ResultInfo beginSendChatMSg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei = new WeixinUtil();
			Map<String, String> map = getQueryKeyAndValue(request);
			Object sender = getWeixinID(request);
			String msgtype="text";
			if (map.get("type")!=null) {
				msgtype=map.get("type");
			}
			if(StringUtils.isBlank(map.get("id"))){
				map.put("id", getCustomerId(request));
			}
			msg = wei.chatSend(map.get("id"),msgtype, sender + "",
					map.get("content"),getComId());
			JSONObject item=new JSONObject();
			item.put("FromUserName", sender);
			item.put("MsgType", msgtype);
			item.put("CreateTime", new Date().getTime());
			if ("image".equals(msgtype)) {
				item.put("PicUrl", map.get("content"));
			}else{
				item.put("Content", map.get("content"));
			}
			item.put("weixinimg", super.getWeixinImg(request, item.getString("FromUserName")));
			saveFile(getChatLogPath(request,map.get("id")), item.toString()+",",true);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	@RequestMapping("getEmployeeWeixinID")
	@ResponseBody
	public List<Map<String, Object>> getEmployeeWeixinID(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return userService.getEmployeeWeixinID(map);
	}

	@RequestMapping("getCustomerWeixinID")
	@ResponseBody
	public List<Map<String, Object>> getCustomerWeixinID(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return userService.getCustomerWeixinID(map);
	}

	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getImgToWeixin")
	@ResponseBody
	public ResultInfo getImgToWeixin(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			WeixinUtil wei = new WeixinUtil();
			String path = getRealPath(request) + "001/" + new Date().getTime()
					+ ".jpg";
			wei.saveImageToDisk(request.getParameter("serverId"), path,getComId());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 零时---移动文件夹到另一个文件夹中
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("movefileplan")
	@ResponseBody
	public ResultInfo movefileplan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			File file = new File(getComIdPath(request) + "planquery/");
			File[] files = file.listFiles();
			for (File file2 : files) {
				File file3 = new File(file2.getPath()
						+ "/planquery/customer_id.sql");
				if (file3.exists()) {
					FileUtils.moveFileToDirectory(file3, file2, true);
				}
				file3 = new File(file2.getPath() + "/planquery/deptIdInfo.sql");
				if (file3.exists()) {
					FileUtils.moveFileToDirectory(file3, file2, true);
				}
				file3 = new File(file2.getPath()
						+ "/planquery/store_struct_id_Info.sql");
				if (file3.exists()) {
					FileUtils.moveFileToDirectory(file3, file2, true);
				}
				file3 = new File(file2.getPath() + "/planquery/type_id.sql");
				if (file3.exists()) {
					FileUtils.moveFileToDirectory(file3, file2, true);
				}
				file3 = new File(file2.getPath() + "/planquery");
				if (file3.exists() && file3.isFile()) {
					file3.delete();
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	@RequestMapping("useProject")
	@ResponseBody
	public ResultInfo useProject(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String projectName = request.getParameter("name");
			if (StringUtils.isNotBlank(projectName)) {
				File file = new File(ConfigFile.TOMCAT_DIR).getParentFile();
				File srcDir = new File(file + "\\" + projectName);
				if (srcDir.exists()) {
					File destDir = new File(ConfigFile.TOMCAT_DIR + "\\"
							+ projectName);
					FileUtils.moveDirectory(srcDir, destDir);
					success = true;
				} else {
					msg = "项目不存在!";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	@RequestMapping("moveProject")
	@ResponseBody
	public ResultInfo moveProject(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String projectName = request.getParameter("name");
			if (StringUtils.isNotBlank(projectName)) {
				File file = new File(ConfigFile.TOMCAT_DIR).getParentFile();
				File srcDir = new File(ConfigFile.TOMCAT_DIR + "\\"
						+ projectName);
				if (srcDir.exists()) {
					File destDir = new File(file + "\\" + projectName);
					FileUtils.moveDirectory(srcDir, destDir);
					success = true;
				} else {
					msg = "项目不存在!";
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
	@RequestMapping("getChatHistory")
	@ResponseBody
	public JSONArray getChatHistory(HttpServletRequest request) {
		String chatid=request.getParameter("chatid");
		String historyDate=request.getParameter("historyDate");
		Date date=DateUtils.addDays(DateTimeUtils.strToDate(historyDate), -1);
		historyDate=DateTimeUtils.dateToStr(date);
		File file=new File(getChatLogPath(request, chatid,historyDate));
		JSONArray jsons=null;
		if (file.exists()) {
			jsons=getChatLog(request, chatid,historyDate);
			jsons.add(0,historyDate);
			return jsons;
		}else{
			
		}
		jsons=new JSONArray();
		jsons.add(historyDate);
		return jsons;
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("kefuchat")
	public String kefuchat(HttpServletRequest request) {
		return "pc/weixin/sendChatkefuMsg";
	}
	
	@RequestMapping("kefuchatcreat")
	@ResponseBody
	public ResultInfo kefuchatcreat(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			//1.获取客服职位的一个
			 Map<String,Object> mapper=new HashMap<String, Object>();
				mapper.put("com_id", getComId());
				mapper.put("headship", "%客服%");
				List<String> touserList=userService.getPersonnelNeiQing(mapper);
				WeixinUtil wei=new WeixinUtil();
				try {
					if (getCustomer(request)==null&&getEmployee(request)==null) {
					 	throw new RuntimeException("登录超时!");
					}
					Object owner =null;
					if (getCustomer(request)!=null) {
						owner = getCustomer(request).get("weixinID");
					}
					if (getEmployee(request)!=null) {
						owner = getEmployee(request).get("weixinID");
					}
					if (touserList != null && touserList.size() > 0 ) {
						String chatid =getCustomerId(request);
						touserList.add(owner+"");
						msg = wei.chatCreate(chatid, "在线咨询", owner + "",
								touserList,getComId());
						String chat = wei.chatGet(chatid,getComId());
						JSONObject json = JSONObject.fromObject(chat);
						if (json!=null&&!json.has("errmsg")) {
						// 把会话id写入到会话外部文件
//							if (!json.has("userlist")&&!"[]".equals(json.getString("userlist"))) {
//								System.out.println(json.getString("userlist"));
//								json.put("userlist", touserList);
//							}
//							saveCreate_chat(request, json);
//							msg = chatid;
							success = true;
						}
					}
				} catch (Exception e) {
					msg = e.getMessage();
					e.printStackTrace();
				}
			success = true;
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
	@RequestMapping("addWeixin")
	@ResponseBody
	public ResultInfo addWeixin(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String phone=request.getParameter("phone");
			String weixin=request.getParameter("weixin");
			String type=request.getParameter("type");
			if (StringUtils.isNotBlank(phone)) {
				if (StringUtils.isNotBlank(weixin)) {
			        if (isLetterDigit(weixin)) {
			        	Map<String,String> map=new HashMap<String, String>();
			        	map.put("phone", phone);
			        	map.put("weixin", weixin);
			        	map.put("type", type);
			        	map.put("com_id", getComId());
			        	String weixinID=userService.updateWeixin(map);
			        	if (StringUtils.isBlank(weixinID)) {
			        		weixinID=weixin;
						}
			        	WeixinUtil wei = new WeixinUtil();
						Map<String,Object> map2=new HashMap<String, Object>();
						map2.put("userid", phone);
						map2.put("weixinid", weixin);
//						int[] dept={1001};
//						map2.put("department",  dept);
//						map2.put("mobile",phone);
						JSONObject json = JSONObject.fromObject(map2);
			        	msg=wei.saveEmployee(json, "update",getComId());
//						msg = wei.invite_send(weixinID);
//						json =wei.getErrcodeToZh(msg);
						if ("".equals(msg)) {
							success = true;
						}else {msg="绑定失败,请联系客服!";
//							msg=json.getString("errmsg");
						}
			        }else{
			        	msg="微信号格式不正确!";
			        }
				}else{
					msg="请输入微信号!";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 判断是否值包含数字和字母
	 * @param str
	 * @return true-只包含数字和字母,false
	 */
	public boolean isLetterDigit(String str) {
		  String regex = "^[a-z0-9A-Z]+$";
		  return str.matches(regex);
	}
	
	/**
	 *  获取指定订单产品的历史记录
	 * @param request
	 * @param orderNo 订单编号
	 * @param item_id 订单产品内码
	 * @return 该订单产品对应的历史记录
	 */
	@RequestMapping("getOrderProductHistory")
	@ResponseBody
	public JSONArray getOrderProductHistory(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return userService.getOrderProductHistory(map);
	}
	
	/**
	 * 获取客户的司机信息
	 * @param searchKey 查询关键词
	 * @param driveId 所属客户编码
	 * @return 该客户的司机信息
	 */
	@RequestMapping("getClientDriver")
	@ResponseBody
	public List<Map<String,Object>> getClientDriver(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id",getCustomerId(request));
		return userService.getClientDriver(map);
	}
	/**
	 * 提交客户的司机编码
	 * @param customer_id 
	 * @param driveId 
	 * @return 
	 */
	@RequestMapping("postCientDriveId")
	@ResponseBody
	public ResultInfo postCientDriveId(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			userService.postCientDriveId(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 根据职务获取平台员工电话
	 * @param headship 员工职务
	 * @return 对应职务的员工姓名和电话
	 */
	@RequestMapping("getPlatformsPhone")
	@ResponseBody
	public List<Map<String, String>> getPlatformsPhone(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if ("业务员".equals(map.get("headship"))) {
			map.put("customer_id", getCustomerId(request));
		}
		if (isMapKeyNull(map, "headship")) {
			map.put("headship", "%客服%");
		}else{
			map.put("headship", "%"+map.get("headship")+"%");
		}
		return userService.getPlatformsPhone(map);
	}
	/**
	 * 通知内勤
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeNeiqing")
	@ResponseBody
	public ResultInfo noticeNeiqing(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			userService.noticeNeiqing(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}///////////////////////////
	/**
	 * 保存公告信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveNoticeInfo")
	@ResponseBody
	public ResultInfo saveNoticeInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("notice_time", getNow());
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			if (isMapKeyNull(map, "m_flag")) {
			map.put("m_flag", "0");
			}
			userService.saveNoticeInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  调整公告列表界面
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeInfoHistory")
	public String noticeInfoHistory(HttpServletRequest request) {
		
		return "pc/notice/noticeInfoHistory";
	}
	
	/**
	 *  获取公告分页数据
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeInfoPage")
	@ResponseBody
	public PageList<Map<String,Object>> noticeInfoPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getEmployee(request)!=null) {
			Map<String,Object> mapa=getTxtKeyVal(request, getEmployeeId(request));
			if(isMapKeyNull(mapa, "allNotice")){
				map.put("clerk_id", getEmployeeId(request));
			}
		}
		return userService.getNoticeInfoPage(map);
	}
	/**
	 *  获取客户或者员工基础信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getUserInfo")
	@ResponseBody
	public Map<String,Object> getUserInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if(getCustomer(request)!=null){
			map.put("customerId", getCustomerId(request));
		}else{
			map.put("clerkId", getEmployeeId(request));
		}
		return userService.getUserInfo(map);
	}
	@RequestMapping("userRegisterQRCode")
	@ResponseBody
	public ResultInfo userRegisterQRCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
				Map<String,Object> map=getKeyAndValue(request);
				Integer width=MapUtils.getInteger(map, "width");
				Integer height=MapUtils.getInteger(map, "height");
				Integer image_width=MapUtils.getInteger(map, "image_width");
				Integer image_height=MapUtils.getInteger(map, "image_height");
				String type=MapUtils.getString(map, "type");
				if (type==null) {
					type="";
				} 
				request.getSession().setAttribute(ConfigFile.OPERATORS_NAME, map.get("com_id"));
				String qrurl=systemParams.checkSystem("urlPrefix").toString();
				qrurl=qrurl+"/login/register.do?com_id="+map.get("com_id")+"&type="+type+"&ver="+Math.random();
				String logopath=getRealPath(request)+map.get("com_id")+"/image/logo.png";
				File file=new File(logopath);
				if (!file.exists()) {
					String logo=request.getParameter("logo");
					if (StringUtils.isBlank(logo)) {
						logo="pc/image/logo.png";
					}
					logopath=getRealPath(request)+logo;
				}
				msg="/"+map.get("com_id")+"/register"+type+".jpg";
				QRCodeUtil.generateQRCode(qrurl, width, height,logopath, image_width, image_height,getRealPath(request)+msg);
				success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存员工或者客户的姓名
	 * @param request
	 * @return
	 */
	@RequestMapping("saveUserInfo")
	@ResponseBody
	public ResultInfo saveUserInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(getCustomer(request)!=null){
				map.put("customer_id", getCustomerId(request));
			}else{
				map.put("clerk_id", getEmployeeId(request));
			}
			msg=userService.saveUserInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取系统设计师
	 * @param rows 等于一条再加上员工内码,即可获取员工消息
	 * @return
	 */
	@RequestMapping("getDesigner")
	@ResponseBody
	public PageList<Map<String,Object>> getDesigner(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return userService.getDesigner(map);
	}
	
}
