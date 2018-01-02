package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.qianying.dao.base.BaseDao;
import com.qianying.page.PersonnelQuery;
import com.qianying.page.ProductQuery;

public interface IEmployeeDAO extends BaseDao {
	/**
	 * 检查登录
	 * @param name 用户名
	 * @param com_id 
	 * @return 该用户的信息
	 */
	Map<String, Object> checkLogin(@Param("name")String name,@Param("com_id") String com_id);
	/**
	 * 检查员工登录手机号是否存在
	 * @param phone
	 * @param com_id 
	 * @return
	 */
	Integer checkPhone(@Param("phone")String phone, @Param("com_id")String com_id);
	/**
	 * 获取最大的员工编号
	 * @return
	 */
	String getMaxClerk_id();
	/**
	 * 
	 * @param clerk_id
	 * @return
	 */
	Map<String, Object> getPersonnel(@Param("clerk_id")String clerk_id,@Param("com_id")String com_id);
	
	List<Map<String, Object>> getDeptBySort_id(@Param("sort_id")String sort_id);
	/**
	 * 统计信息条数
	 * @param obj
	 * @return
	 */
	public int count(@Param("query")ProductQuery query); 
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> findQuery(Map<String, Object> map);
	/**
	 * 获取产品类型名称根据类型id
	 * @param typeid
	 * @return 类型名称
	 */
	String getProclsNameById(Map<String, Object> maptype);
	/**
	 * 获取员工自己的OA记录 总数
	 * @param map
	 * @return
	 */
	Integer getOACount(Map<String, Object> map);
	/**
	 * 获取员工自己的OA记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOAList(Map<String, Object> map);
	/**
	 * 获取OA详细记录
	 * @param map
	 * @return
	 */
	Map<String, Object> getOAInfo(Map<String, Object> map);
	/**
	 * 获取该审批的历史记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOAhistryList(Map<String, Object> map);
	/**
	 * 获取审批记录详细信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getOASpInfo(Map<String, String> map);
	/**
	 * 获取当前审批流程的最大步骤
	 * @param map
	 * @return
	 */
	Integer getMaxStep(Map<String, String> map);
	
	void updateApproval(Map<String, Object> map);
	void updateSkd(Map<String, Object> mapadr);
	/**
	 * 获取客户的id和名称根据员工id
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getCustomer_id_name(Map<String, Object> map);
	String getCustomer_name(Map<String, Object> mapcus);
	List<Map<String, Object>> getCustomerByClerk_id(Map<String, Object> map);
	String getEmployeeCustomer_id(Map<String, Object> map);
	int getCustomerByClerk_idCount(Map<String, Object> map);
	/**
	 * 员工离职
	 * @param map
	 */
	void employeeLeave(Map<String, Object> map);
	/**
	 * 更新订单状态
	 * @param map
	 * @return 返回客户的信息用于发微信
	 */
	Map<String, Object> getCustomerByOrder(Map<String, Object> map);
	/**
	 * 获取下一步审批人的编码
	 * @param map
	 * @return
	 */
	String getNextOA_whom(Map<String, String> map);
	/**
	 * 获取部门导入微信的列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getDeptToWeixin(Map<String, Object> map);
	/**
	 * 获取员工导入微信列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEmployeeToWeixin(Map<String, Object> map);
	Integer collectionConfirmCount(Map<String, Object> map);
	List<Map<String, Object>> collectionConfirmList(Map<String, Object> map);
	
	String getPersonnelByMobile(Map<String, Object> map);
	Map<String, Object> getDeptByName(Map<String, Object> map);
	String getDeptUpperIdByid(Map<String, Object> dept);
	void backup(Map<String, Object> map);
	Map<String, String> getPersonnelWeixinID(@Param("clerk_id")String clerk_id, @Param("com_id")String com_id);
	/**
	 * 获取职位是内勤的所有员工的微信账号
	 * @param comId
	 * @return 返回最多99条数据
	 */
	List<Map<String, String>> getPersonnelNeiQing(Map<String,Object> map);
	/**
	 * 根据seeds_id获取订单信息
	 * @param seeds_id
	 * @return
	 */
	Map<String, Object> getOrderInfoBySeeds_id(@Param("seeds_id")String seeds_id);
	/**
	 * 销售收款单查询总数
	 * @param map
	 * @return
	 */
	Integer salesReceiptsListCount(Map<String, Object> map);
	/**
	 * 销售收款单分页查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> salesReceiptsList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getPersonnelsSignInfoCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPersonnelsSignInfoList(Map<String, Object> map);
	/**
	 * 
	 * @param comId
	 * @param ivt_oper_listing
	 * @return
	 */
	String getARd02051(@Param("com_id")String comId, @Param("ivt_oper_listing")Object ivt_oper_listing);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getVendorToWeixin(Map<String, Object> map);
	/**
	 * 获取员工微信账号和手机号
	 * @param mapParam
	 * @return
	 */
	List<Map<String, String>> getPersonnelByWorkID(Map<String, Object> mapParam);
	////获取供应商采购订单分页数据
	Integer vendorOrderListCount(Map<String, Object> map);
	List<Map<String, Object>> vendorOrderList(Map<String, Object> map);
	////获取待供应商采购数据
	Integer waitingPurchasingCount(Map<String, Object> map);
	List<Map<String, Object>> waitingPurchasingList(Map<String, Object> map);
	Integer zuofeiPOrder(Map<String, Object> map);
	/**
	 * 更新采购订单编号/生产计划编号到订单从表中
	 * @param st_auto_no //采购订单编号/生产计划编号
	 * @param com_id
	 * @param orderNo 订单编号
	 * @param item_id //产品id
	 */
	void updateOrderPurchasing(Map<String, Object> mapitem);
	/**
	 * 检查
	 * @param mapitem
	 * @return
	 */
	Integer checkPur(Map<String, Object> mapitem);
	
	List<Map<String, Object>> getDriverToWeixin(Map<String, Object> map);
	void confirmGys(Map<String, Object> map);
	
	Map<String, Object> getGysInfoByOrder(Map<String, Object> map);
	/**
	 * 获取需要验收入库的采购订单
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getYanshouOrder(Map<String, Object> map);
	Map<String, Object> getYanshouGysInfo(Map<String, Object> map);
	void updateOrderStatus(Map<String, Object> map);
	void collConfirm(Map<String, Object> map);
	Map<String, String> getOrderNoAndItemIdBySeeds_is(@Param("seeds_id")Object seeds_id);
	/**
	 * 获取已增加入库单
	 */
	Integer purchasingCheckListCount(Map<String, Object> map);
	List<Map<String, Object>> purchasingCheckList(Map<String, Object> map);
	/**
	 * 已增加入库单导出
	 */
	List<Map<String, Object>> purchasingSheetExport(Map<String, Object> map);

	/**
	 * 库管装货货更新订单状态
	 * @param map
	 */
	void updateOrderchuku(Map<String, Object> map);
	/**
	 * 获取供应商信息
	 */
	List<Map<String, Object>> getSupplierByComId(Map<String, Object> map);
	String getSupplierId(Map<String, Object> map);
	/**
	 * 获取自己申请的OA协同记录总数
	 * @param map
	 * @return
	 */
	Integer getMySqOACount(Map<String, Object> map);
	/**
	 * 获取自己申请的OA协同记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getMySqOAList(Map<String, Object> map);
	Integer getProcurementListCount(Map<String, Object> map);
	List<Map<String, Object>> getProcurementList(Map<String, Object> map);
	List<Map<String, Object>> setDefaultByClerkId(Map<String, Object> map);
	/**
	 * 获取已退货产品
	 */
	Integer purchasingReturnListCount(Map<String, Object> map);
	List<Map<String, Object>> purchasingReturnList(Map<String, Object> map);
	/**
	 * 根据入库单号和运营商查询入库产品信息
	 */
	Map<String, Object> queryByrcvNo(Map<String,Object> map);
	/**
	 * 获取签到消息列表总数
	 * @param map
	 * @return
	 */
	Integer getSignInfoListCount(Map<String, Object> map);
	/**
	 * 获取签到消息列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSignInfoList(Map<String, Object> map);
	/**
	 * 导出签到记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> employeeSignExport(Map<String, Object> map);
	/**
	 * 生成签到表
	 * 2.判断当天签到表是否生成,
	 * 2.1生成就直接跳过
		//3.循环生成签到表数据
	 * @param map3
	 */
	String GenerateSignBaseTable(Map<String, String> map);
	/**
	 * 保存签到信息 已经签到就更新
	 * @param map
	 * @return
	 */
	Map<String,Object> saveSignInfo(Map<String, Object> map);
	/**
	 * 获取采购订单信息
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getNOByComIdList(Map<String, Object> map);
	Integer getNOByComIdCount(Map<String, Object> map);
	/**
	 * 根据采购订单号计算订单金额返回数据
	 * @param map
	 * @return
	 */
	String getCgAmountByNo(Map<String, Object> map);
	/**
	 * 根据采购订单号查询已付金额
	 * @param map
	 * @return
	 */
	String getYfAmountByNo(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> loginList(Map<String, Object> map);
	/**
	 * 
	 * @param param
	 * @return
	 */
	Map<String,Object> getOrderNoByRecieved(Map<String, Object> param);
	/**
	 * 获取员工签到信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>>  sginedList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getSellerSignInfoListCount(Map<String, Object> map);
		/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getNoticeInfoPageCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getNoticeInfoPage(Map<String, Object> map);
	
	void updateNotice(Map<String, Object> map);
	void updateSignInfo(Map<String, Object> map);
	/**
	 * 获取客户信息中销售代表微信,手机等消息
	 * @param map
	 * @return
	 */
	Map<String, String> getEmployeeByCustomerId(Map<String, Object> map);
	/**
	 * 签到汇总查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSignInfoCount(Map<String, Object> map);
	/**
	 * 根据计划下采购订单
	 * @param map
	 * @return
	 */
	Map<String, Object> generatePurchaseOrderByPlan(Map<String, Object> map);
	/**
	 * 获取向供应商下计划信息
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getPlanSupplierInfo(Map<String, Object> map);
	/**
	 * 更新供应商上报产品信息标识
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getGysUpItemInfoList(Map<String, Object> map);
	/**
	 * 更新供应商上报产品信息标识
	 * @param map
	 * @return
	 */
	Integer updateGysProFlag(Map<String, Object> map);
	/**
	 * 修改订单数量
	 * @param map
	 * @return
	 */
	Integer editOrderNum(Map<String, Object> map);
	/**
	 * 获取业务员的所有客户总数
	 * @param map
	 * @return
	 */
	Integer getEmployeeCustomerCount(Map<String, Object> map);
	/**
	 * 获取业务员的所有客户列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEmployeeCustomerList(Map<String, Object> map);
	/**
	 * 获取已下销售开单数据
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getSalesKdList(Map<String, Object> map);
	/**
	 * 获取已下销售开单信息列表
	 * @param map
	 * @return
	 */
	Integer getSalesKdListCount(Map<String, Object> map);
	/**
	 * 修改报价单信息
	 * @param map
	 * @return
	 */
	Integer editAddedInfo(Map<String, Object> map);
	/**
	 * 获取销售退货单数据
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getSalesReturnList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getSalesReturnListCount(Map<String, Object> map);
	/**
	 * 获取客户所属业务员信息
	 * @param mapOrder
	 * @return
	 */
	Map<String, String> getSalespersonInfo(Map<String, Object> mapOrder);
	/**
	 * 销售开单审核与弃审核
	 * @param com_id
	 * @param ivt_oper_listing
	 * @param comfirm_flag
	 * @return
	 */
	Map<String,Object> Sp_SellConsignment(Map<String,Object> map);
	/**
	 * 采购入库
	 * @param com_id
	 * @param rcv_auto_no
	 * @param comfirm_flag
	 * @return
	 */
	Map<String,Object> Sp_stockStock(Map<String,Object> map);
	/**
	 * 检查指定库房下产品库存是否存在
	 * @param mapquery
	 * @return
	 */
	Map<String, Object> checkProductWare(Map<String, Object> mapquery);
	/**
	 * 查询该产品在调入仓库是否存在
	 * @param map
	 */
	Integer selectItemByStore(Map<String,Object> map);
	/**
	 * 获取库存报损单
	 * @param map
	 * @return
	 */
	Integer getBreInventoryCount(Map<String, Object> map);
	/**
	 * 获取库存报损单数据
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getBreInventory(Map<String, Object> map);
	/**
	 * 获取库存调拨单
	 * @param map
	 * @return
	 */
	Integer getTransfersBillsCount(Map<String, Object> map);
	/**
	 * 获取库存调拨单数据
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getTransfersBills(Map<String, Object> map);
	/**
	 * 获取库存盘点单数量
	 * @param map
	 * @return
	 */
	Integer getCheckInvCount (Map<String, Object> map);
	/**
	 * 获取库存盘点单数据
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getCheckInv (Map<String, Object> map);
	/**
	 * 获取供应商信息根据订单seeds_id
	 * @param seeds
	 * @return 供应商信息和采购单号
	 */
	List<Map<String, String>> getGysByOrderSeeds(Object seeds);
	/**
	 * 通过收款单id获取订单id
	 * @param params
	 * @return
	 */
	String getOrderSeeds(Map<String, Object> params);
	/**
	 * 获取设计师总数
	 * @param map
	 * @return
	 */
	Integer getDesignerCount(Map<String, Object> map);
	/**
	 * 获取设计师
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getDesigner(Map<String, Object> map);
	/**
	 * 获取一个信息根据openid
	 * @param map
	 * @return
	 */
	Map<String, Object> getEmployeeInfoByOpenid(Map<String, Object> map);
	/**
	 * 同步更新采购订单状态和物流信息根据订单信息
	 * @param params
	 * @return
	 */
	Integer updatePurOrderInfo(Map<String, Object> params);
	/**
	 * 采购订单审核
	 * @param map
	 * @return
	 */
	Integer purchasingOrderComfirm(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getAddedFlagCount(Map<String, Object> map);
}
