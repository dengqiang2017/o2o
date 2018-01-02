package com.qianying.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.qianying.page.PageList;
import com.qianying.page.PersonnelQuery;

public interface IEmployeeService extends IBaseService {

	/**
	 * 检查员工注册手机号是否存在
	 * @param phone
	 * @param com_id 
	 * @return  存在返回false,不存在返回true
	 */
	boolean checkPhone(String phone, String com_id);
	/**
	 * 获取最大的编号
	 * @return
	 */
	String getMaxClerk_id();
	/**
	 * 检查员工登录
	 * @param name 账号
	 * @param comId 
	 * @return 
	 */
	Map<String, Object> checkLogin(String name, String comId);
	/**
	 * hqu bum xx 
	 * @param object
	 * @return
	 */
	List<Map<String, Object>> getDeptBySort_id(String sort_id);
	/**
	 * 获取员工分页列表
	 * @param request 
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getPersonnelByClerk_id(HttpServletRequest request, Map<String, Object> map);
	/**
	 * 获取员工详细信息
	 * @param clerk_id 员工内码
	 * @param comId 
	 * @return 
	 */
	Map<String, Object> getPersonnel(String clerk_id, String comId);
//	/**
//	 * 获取产品类型名称根据类型id
//	 * @param maptype 
//	 * @return 类型名称
//	 */
//	String getProclsNameById(Map<String, Object> maptype);
	/**
	 * 获取员工自己的待办事项
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getOAList(Map<String, Object> map);
	/**
	 * 获取审批详细记录
	 * @param map
	 * @param realurl 
	 * @return
	 */
	Map<String, Object> getOAInfo(Map<String, Object> map, String realurl);
	/**
	 * 保存审批记录
	 * @param map
	 * @throws Exception 
	 */
	void saveOpinion(Map<String, String> map) throws Exception;
	Integer getOACount(Map<String, Object> map);
	/**
	 * 保存文牍类申请
	 * @param map
	 */
	void saveCoordination(Map<String, Object> map) throws Exception;
	/**
	 * 根据员工获取客户列表
	 * @param object
	 * @return
	 */
	List<Map<String,String>> getCustomer_id_name(Map<String, Object> map);
//	String getCustomer_name(Map<String, Object> mapcus);
	PageList<Map<String, Object>> getCustomerByClerk_id(Map<String, Object> map);
	void updatePlanFlag(Map<String, Object> map);
	/**
	 * 处理员工离职交接换岗
	 * @param map
	 */
	void saveLeave(Map<String, Object> map);
	/**
	 * 保存订单跟踪操作状态
	 * @param map
	 * @return
	 */
	String saveHandle(Map<String, Object> map) throws Exception;
	/**
	 * 获取部门到微信需要使用的列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getDeptToWeixin(Map<String, Object> map);
	/**
	 * 获取微信导入需要使用的一个列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEmployeeToWeixin(Map<String, Object> map);
	/**
	 * 收款确认列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> collectionConfirmList(Map<String, Object> map);
	/**
	 * 更新收款确认
	 * @param map
	 * @throws Exception 
	 */
	void collConfirm(Map<String, Object> map) throws Exception;
	/**
	 * 根据员工手机号获取
	 * @param map
	 * @return
	 */
	String getPersonnelByMobile(Map<String, Object> map);
	void updateWeixinId(Map<String, Object> map);
	void savePersonnelToWeixin(Map<String, Object> map);
	Map<String, Object> getDeptByName(Map<String, Object> map);
	void updateDeptToWeixin(Map<String, Object> mapdept);
	String getDeptUpperIdByid(Map<String, Object> dept);
	void saveDeptToWeixin(Map<String, Object> dept);
	void backup(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> salesReceiptsList(Map<String, Object> map);
	/**
	 * 更新微信邀请状态,根据微信账号
	 * @param weixinID
	 */
	void updateWeixinInvite(String weixinID);
	PageList<Map<String, Object>> getPersonnelsSignInfo(Map<String, Object> map);
	/**
	 * 获取供应商weixinID
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getVendorToWeixin(Map<String, Object> map);
	/**
	 * 获取供应商订单列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> vendorOrderList(Map<String, Object> map);
	/**
	 * 获取待采购数据
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> waitingPurchasing(Map<String, Object> map);
	/**
	 * 作废采购订单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String zuofeiPOrder(Map<String, Object> map) throws Exception;
	/**
	 * 保存采购订单
	 * @param map
	 * @throws Exception
	 */
	String savePurchasingOrder(Map<String, Object> map) throws Exception;
	/**
	 * 采购订单审核
	 * @param map
	 * @return
	 */
	String purchasingOrderComfirm(Map<String, Object> map);
	/**
	 * 获取司机微信账号
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getDriverToWeixin(Map<String, Object> map);
	/**
	 * 确认更改供应商
	 * @param map
	 * @return
	 */
	String confirmGys(Map<String, Object> map);
	/**
	 * 向供应商催单
	 * @param map
	 * @return
	 */
	String cuidan(Map<String, Object> map);
	/**
	 * 获取需要验收入库的订单
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getYanshouOrder(Map<String, Object> map);
	Map<String, Object> getYanshouGysInfo(Map<String, Object> map);
	/**
	 * 通知收货
	 * @param map
	 * @param list
	 */
	void noticeReceipt(Map<String, Object> map, String[] list);
	/**
	 * 入库通知
	 * @param map
	 */
	void entryNotice(Map<String, Object> map);
	/**
	 * 门卫通知司机和库管
	 * @param customer_id
	 */
	void guardConfirmNotice(Map<String, Object> map);
	/**
	 * 通知司机过磅,通知门卫关注过磅信息
	 * @param seeds_ids
	 */
	void noticeDriveGuard(Map<String, Object> map);
	/**
	 * 向客户发送催款消息
	 * @param map
	 */
	void cuikuan(Map<String, Object> map);
	/**
	 * 获取已增加入库单
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> purchasingCheckList(Map<String, Object> map);
	/**
	 * 获取供应商
	 */
	PageList<Map<String, Object>> getSupplierByComId(Map<String, Object> map);
	/**
	 * 根据clerk_id给经办人经办部门设置默认值
	 */
	List<Map<String, Object>> setDefaultByClerkId(Map<String, Object> map);
	/**
	 * 采购入库获取已发货采购订单
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getProcurementList(Map<String, Object> map);
	/**
	 * 获取已退货产品
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> purchasingReturnList(Map<String, Object> map);
	/**
	 * 直接下采购订单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String saveDirectOrder(Map<String, Object> map);
	/**
	 * 保存签到信息
	 * @param map
	 * @return
	 */
	String saveSignInfo(Map<String, Object> map);
	/**
	 * 获取签到消息列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getSignInfoList(Map<String, Object> map);
	/**
	 * 导出签到记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> employeeSignExport(Map<String, Object> map);
	/**
	 * 每天0点生成签到表
	 */
	void GenerateSignBaseTable();
	/**
	 * 获取采购订单单号
	 */
	PageList<Map<String, Object>> getNOByComId(Map<String, Object> map);
	/**
	 * 根据采购单号计算订单金额返回数据
	 * @param map
	 * @return
	 */
	String getCgAmountByNo(Map<String, Object> map);
	/**
	 * 根据采购单号查询已付款金额
	 * @param map
	 * @return
	 */
	String getYfAmountByNo(Map<String, Object> map);
	/**
	 * 
	 * @param name
	 * @param pwd
	 * @return
	 */
	List<Map<String, Object>> loginList(Map<String,Object> map);
	/**
	 * 获取当前员工是否已经签到
	 * @param map
	 * @return
	 */
	List<Map<String, Object>>  sginedList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	String updateSignInfo(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSignInfoCount(Map<String, Object> map);
	/**
	 * 
	 * @param map 
	 * @return
	 */
	String generatePurchaseOrderByPlan(Map<String, Object> map) throws Exception;
	/**
	 * 获取供应商上报产品信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getGysUpItemInfoList(Map<String, Object> map);
	String updateGysProFlag(Map<String, Object> map);
	/**
	 * 修改订单数据
	 * @param map
	 * @return
	 */
	String editOrderNum(Map<String, Object> map);
	/**
	 * 获取已下销售开单信息列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getSalesKdList(Map<String, Object> map);
	/**
	 * 录入销售开单数据
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String saveSalesOrder(Map<String, Object> map);
	/**
	 * 审核销售开单数据
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String confirmOrder(Map<String, Object> map);
	/**
	 * 放弃审核销售开单数据
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String returnConfirm(Map<String, Object> map);
	/**
	 * 修改报价单信息
	 * @param map
	 * @return
	 */
	String editAddedInfo(Map<String, Object> map);
	/**
	 * 获取销售退货单
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getSalesReturnList(Map<String, Object> map);
	/**
	 * 保存销售退货单数据
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String saveSalesReturn(Map<String, Object> map);
	/**
	 * 保存订单跟踪操作
	 * @param map
	 * @return
	 */
	void saveOrderHandle(Map<String, Object> map) throws Exception;
	/**
	 * 生成库存调拨单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String saveTransfersBills(Map<String, Object> map);
	/**
	 * 获取库存调拨单
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getTransfersBills(Map<String, Object> map);
	/**
	 * 获取库存报损单
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getBreInventory(Map<String, Object> map);
	/**
	 * 审核库存调拨单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String confirmTransfers(Map<String, Object> map);
	/**
	 * 放弃审核库存调拨单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String returnTransfers(Map<String, Object> map);
	/**
	 * 生成库存报损单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String savebreInventory(Map<String, Object> map);
	/**
	 * 审核库存调拨单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String confirmBreInv(Map<String, Object> map);
	/**
	 * 放弃审核库存调拨单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String returnBreInv(Map<String, Object> map);
	/**
	 * 生成库存盘点单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String saveCheckInv(Map<String, Object> map);
	/**
	 * 获取库存盘点
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getCheckInv(Map<String, Object> map);
	/**
	 * 审核库存盘点单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String confirmCheckInv(Map<String, Object> map);
	/**
	 * 放弃审核库存盘点单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String returnCheckInv(Map<String, Object> map);
	/**
	 * 删除库存相关单据
	 * @param map
	 * @return
	 */
	String delInventoryRel(Map<String, Object> map);
	/**
	 * 删除销售开单,销售退货
	 * @param map
	 * @return
	 */
	String delSalesOrder(Map<String, Object> map);
	/**
	 * 根据职务获取员工信息
	 * @param mapparams
	 * @return
	 */
	List<Map<String, String>> getPersonnelNeiQing(Map<String, Object> mapparams);
	/**
	 * 获取员工信息根据openid
	 * @param com_id
	 * @param openid
	 * @param type 企业号或者服务号
	 * @return
	 */
	Map<String, Object> getEmployeeInfoByOpenid(String com_id, Object openid, String type);
	/**
	 * 审核客户所有的报价单
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	String confirmAllAdded(Map<String, Object> map) throws Exception;
	/**
	 * 通知审核客户报价单
	 * @param map
	 * @return
	 */
	String noticeComfirm(Map<String, Object> map);
	/**
	 * 通知业务员客户报价单已经审核
	 * @param map
	 * @return
	 */
	String noticeAddedConfirmed(Map<String, Object> map);
}
