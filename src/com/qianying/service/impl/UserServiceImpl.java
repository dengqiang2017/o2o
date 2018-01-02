package com.qianying.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IUserDao;
import com.qianying.page.PageList;
import com.qianying.service.IUserService;
import com.qianying.util.ConfigFile;
import com.qianying.util.MD5Util;

@Service
public class UserServiceImpl extends BaseServiceImpl implements IUserService{
	
	@Autowired
	private IUserDao userDao;

	/**
	 * 校验用户密码是否和输入的旧密码一致
	 * @param customerId
	 * @return
	 * @throws Exception 
	 */
	@Override
	public boolean checkCustomerPwd(String id, String oldPwd, String comId) throws Exception {
		
		String pwd = userDao.checkCustomerPwd(id, comId);
		if(pwd.length() != 32){
			pwd = MD5Util.MD5(pwd);
		}
		if(oldPwd.equalsIgnoreCase(pwd)){
			return true;
		}
		return false;
	}
	@Override
	public boolean checkPassword(Map<String,Object> map) {
		Object passw=managerDao.getOneFiledNameByID(map);
		if (passw==null) {
			return false;
		}
		String pwd = passw.toString();
		if(passw.toString().length() != 32){
			pwd = MD5Util.MD5(pwd);
		}
		if(pwd.equalsIgnoreCase(map.get("oldPwd")+"")){
			return true;
		}
		return false;
	}
	/**
	 * 校验员工密码是否和输入的旧密码一致
	 * @param customerId
	 * @return
	 * @throws Exception 
	 */
	@Override
	public boolean checkEmployeePwd(String id, String oldPwd, String comId) throws Exception {

		String pwd = userDao.checkEmployeePwd(id, comId);
		if(pwd.length() != 32){
			pwd = MD5Util.MD5(pwd);
		}
		if(oldPwd.equalsIgnoreCase(pwd)){
			return true;
		}
		return false;
	}
	
	/**
	 * 校验管理员密码是否和输入的旧密码一致
	 * @param customerId
	 * @return
	 * @throws Exception 
	 */
	@Override
	public boolean checkManagerPwd(String id, String oldPwd, String comId) throws Exception {

		String pwd = userDao.checkManagerPwd(id, comId);
		if(pwd.length() != 32){
			pwd = MD5Util.MD5(pwd);
		}
		if(oldPwd.equalsIgnoreCase(pwd)){
			return true;
		}
		return false;
	}
	@Override
	public List<Map<String, Object>> checkLoginEwm(String name, String table) {
		 
		return userDao.checkLoginEwm(name,table);
	}
	
	@Override
	public Map<String, Object> checkedLogin(String name, String com_id,
			String table) {
		// TODO Auto-generated method stub
		return userDao.checkedLogin(name,com_id,table);
	}
	
	/**
	 * 将客户的旧密码更新为新密码
	 * @param customerId
	 * @return
	 * @throws Exception 
	 */
	@Override
	public void updateCustomerPwd(String id, String newPwd, String comId) throws Exception {

		userDao.updateCustomerPwd(id, newPwd,  comId);
	}

	/**
	 * 将员工的旧密码更新为新密码
	 * @param customerId
	 * @return
	 * @throws Exception 
	 */
	@Override
	public void updateEmployeePwd(String id, String newPwd, String comId) throws Exception {
		
		userDao.updateEmployeePwd(id, newPwd,  comId);
	}

	/**
	 * 将管理员的旧密码更新为新密码
	 * @param customerId
	 * @return
	 * @throws Exception 
	 */
	@Override
	public void updateManagerPwd(String id, String newPwd, String comId) throws Exception {

		userDao.updateManagerPwd(id, newPwd,  comId);
	}

	@Override
	public void updatePassword(Map<String, Object> map) throws Exception {
		StringBuffer sSql=new StringBuffer("update ");
		sSql.append(map.get("table")).append(" set user_password='").append(map.get("pwdval")).append("' where ltrim(rtrim(isnull(com_id,'')))='").append(map.get("com_id")).append("' and ");
		sSql.append(map.get("findFiled")).append("='").append(map.get("findval")).append("'");
		managerDao.insertSql(sSql.toString());
	}
	
	/**
	 * 校验管理员输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	@Override
	public boolean checkManagerPhone(String mobileNum, String comId) {
		Integer i = userDao.checkManagerPhone(mobileNum,  comId);
		if(i<1){
			return false;
		}
		return true;
	}

	/**
	 * 校验员工输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return 存在返回true,不存在返回false
	 */
	@Override
	public boolean checkEmployeePone(String mobileNum, String comId) {
		Integer i = userDao.checkEmployeePone(mobileNum,  comId);
		if(i < 1){//大于0就存在,小于0就不存在
			return false;
		}
		return true;
	}

	@Override
	public boolean checkOperatePone(String mobileNum) {
		Integer i = userDao.checkOperatePone(mobileNum);
		if(i < 1){//大于0就存在,小于0就不存在
			return false;
		}
		return true;
	}
	
	/**
	 * 校验客户输入的手机号是否存在
	 * @param managerId
	 * @param value
	 * @return
	 */
	@Override
	public boolean checkCustomerPone(String mobileNum, String comId) {
		Integer i = userDao.checkCustomerPone(mobileNum,  comId);
		if(i<1){
			return false;
		}
		return true;
	}

	/**
	 * 将管理员的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	@Override
	public void updateForgetManagerPwd(String mobileNum, String newPwd, String comId) {

		userDao.updateForgetManagerPwd(mobileNum, newPwd,  comId);
	}

	/**
	 * 将员工的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	@Override
	public void updateForgetEmployeePwd(String mobileNum, String newPwd, String comId) {
		
		userDao.updateForgetEmployeePwd(mobileNum, newPwd, comId);
	}

	/**
	 * 将客户的旧密码更新为新密码
	 * @param customerId
	 * @return
	 */
	@Override
	public void updateForgetCustomerPwd(String mobileNum, String newPwd, String comId) {
		
		userDao.updateForgetCustomerPwd(mobileNum, newPwd, comId);
	}
	
	@Override
	public int getWorking_status(String mobileNum, String comId) {
		Integer i=userDao.getWorking_status(mobileNum,comId);
		if (i==null) {
			i=1;
		}
		return i;
	}

	@Override
	public List<Map<String, Object>> getEmployeeWeixinID(Map<String, Object> map) {
		 
		return userDao.getEmployeeWeixinID(map);
	}

	@Override
	public List<Map<String, Object>> getCustomerWeixinID(Map<String, Object> map) {
		 
		return userDao.getCustomerWeixinID(map);
	}

	@Override
	public String getKfWeixinID(String comId) {
		return userDao.getKfWeixinID(comId);
	}
	@Override
	public List<String> getPersonnelNeiQing(Map<String, Object> mapper) {
		List<String> list=new ArrayList<String>();
		 List<Map<String, String>> lis= employeeDao.getPersonnelNeiQing(mapper);
		 for (Map<String, String> map : lis) {
			list.add(map.get("weixinID"));
		}
		 return list;
	}
	
	@Override
	public String updateWeixin(Map<String, String> map) {
		return userDao.updateWeixin(map);
	}
	
	@Override
	public void savePhone(Map<String, Object> map) {
		StringBuffer sSql=new StringBuffer("update ");
		sSql.append(map.get("table")).append(" set  user_id='");
		sSql.append(map.get("phone")).append("',movtel='").append(map.get("phone"));
		sSql.append("' where ltrim(rtrim(isnull(com_id,'')))='").append(map.get("com_id")).append("' and ").append(map.get("findFiled")).append("='").append(map.get("id")).append("'");
		managerDao.insertSql(sSql.toString());
		
	}
	
	@Override
	public boolean checkEvalPone(String value, String com_id,int type) {
		// TODO Auto-generated method stub
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("value", value);
		map.put("com_id", com_id);
		map.put("type", type);
		String i= userDao.checkEvalPone(map);
		if(StringUtils.isNotBlank(i)){
			return true;
		}else{
			return false;
		}
			
	}
	
	@Override
	public JSONArray getOrderProductHistory(
			Map<String, Object> map) {
		String path=getOrderHistoryPath(map.get("orderNo"),map.get("item_id"));
		String content=getFileTextContent(path);
		if(StringUtils.isNotBlank(content)){
			content="["+content+"]";
			return JSONArray.fromObject(content);
		}
		return null;
	}
	@Override
	public List<Map<String, Object>> getClientDriver(Map<String, Object> map) {
//		if(isMapKeyNull(map, "driveId")){
//			return null;
//		}
		return userDao.getClientDriver(map);
	}
	@Override
	@Transactional
	public void postCientDriveId(Map<String, Object> map) {
		if (isMapKeyNull(map, "driveId")) {
			map.put("driveId", "");
		}
		userDao.postCientDriveId(map);
	}
	@Override
	public List<Map<String, String>> getPlatformsPhone(Map<String, Object> map) {
		return userDao.getPlatformsPhone(map);
	}
	@Override
	public void noticeNeiqing(Map<String, Object> map) {
		List<Map<String,Object>> list= saiYuDao.getOrderInfoByIdsDrive(map.get("seeds_id").toString().replace("[", "").replace("]", ""));
		List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
		Map<String,Object> mapMsg=new HashMap<String, Object>();
		mapMsg.put("title", map.get("title"));
		String[] HYS=list.get(0).get("HYS").toString().split(",");
		mapMsg.put("description",list.get(0).get("corp_name")+"客户的司机已经前来提货,请提前准备好货物,"+HYS[0]+","+HYS[1]);
		mapMsg.put("picurl",ConfigFile.urlPrefix+"/weixinimg/msg.png");
		mapMsg.put("url", ConfigFile.urlPrefix+"/login/toUrl.do?url=/employee/orderTracking.do?seeds_id="+map.get("seeds_id")+"|"+utf8to16(map.get("processName")+""));
		news.add(mapMsg); 
		sendWexinMsgToEmployee(news, map.get("headship"));
		saveOrderHistory(map.get("seeds_id"), "司机在路上通知内勤提前准备好货物");
	}
	
	@Override
	public String saveNoticeInfo(Map<String, Object> map) {
		if(isMapKeyNull(map, "seeds_id")){
			employeeDao.insertSql(getInsertSql("t_notice_info", map));
		}else{
			String sSql="update t_notice_info set notice_title=#{notice_title},"
					+ "notice_content=#{notice_content},clerk_id=#{clerk_id},"
					+ "clerk_name=#{clerk_id},notice_time=#{notice_time} where seeds_id=#{seeds_id}";
			map.put("sSql", sSql);
			productDao.insertSqlByPre(map);
			employeeDao.updateNotice(map);
		}
		
		return null;
	}
	@Override
	public PageList<Map<String, Object>> getNoticeInfoPage(
			Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getNoticeInfoPageCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getNoticeInfoPage(map);
		pages.setRows(list);
		return pages;
	}
	
	@Override
	public Map<String, Object> getUserInfo(Map<String, Object> map) {
		if(isNotMapKeyNull(map, "customerId")){
			return customerDao.getCustomerByCustomer_id(map.get("customerId")+"", map.get("com_id")+"");
		}
		if(isNotMapKeyNull(map, "clerkId")){
			return employeeDao.getPersonnel(map.get("clerkId")+"", map.get("com_id")+"");
		}
		return null;
	}
	
	@Override
	public String saveUserInfo(Map<String, Object> map) {
		
		return userDao.saveUserInfo(map)+"";
	}

	@Override
	public PageList<Map<String,Object>> getDesigner(Map<String, Object> map) {
		Integer totalRecord=0;
		Integer currentPage=1;
		Integer pageRecord=10;
		pageRecord=Integer.parseInt(map.get("rows")+"");
		if (getTotalRecord(map, currentPage, pageRecord)==null) {
			totalRecord=employeeDao.getDesignerCount(map);
		}else{
			totalRecord=Integer.parseInt(map.get("count")+"");
		}
		currentPage=Integer.parseInt(map.get("page")+"");
		PageList<Map<String,Object>> pages=new PageList<Map<String,Object>>(currentPage, pageRecord, totalRecord);
		List<Map<String, Object>>list=employeeDao.getDesigner(map);
		pages.setRows(list);
		return pages;
	}
}
