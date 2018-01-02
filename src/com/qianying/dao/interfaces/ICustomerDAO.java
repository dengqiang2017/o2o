package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.ibatis.annotations.Param;

import com.qianying.dao.base.BaseDao;
import com.qianying.page.CustomerQuery;
import com.qianying.page.PersonnelQuery;
import com.qianying.page.SupplierQuery;

public interface ICustomerDAO extends BaseDao {

	Integer checkPhone(@Param("phone")String phone,@Param("com_id")String com_id);

	String getMaxCustomer_id();

	/**
	 * 分页查询
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> findQuery(CustomerQuery query)throws Exception;
	/**
	 * 获取订单编号
	 * @param map 
	 * @return
	 */
	String getOrderNo(Map<String, Object> map);
	/**
	 * 保存订单
	 * @param map
	 */
	void saveOrder(Map<String, Object> map);
	/**
	 * 客户登录
	 * @param name
	 * @param com_id 
	 * @param com_id 
	 * @return
	 */
	Map<String, Object> checkLogin(@Param("name") String name,@Param("com_id")String com_id);
	/**
	 * 客户登录
	 * @param name
	 * @param pwd
	 * @return
	 */
	List<Map<String, Object>> checkLoginEwm(Map<String,Object> map);
	/**
	 * 客户添加产品
	 * @param map
	 */
	void addProduct(Map<String, Object> map);
	/**
	 * 保存添加客户添加产品明细从表
	 * @param map
	 */
	void saveProductDetil(Map<String, Object> map);
	/**
	 * 获取客户自己添加的品种
	 * @param customer_id 客户编码
	 * @return 产品列表
	 */
	List<Map<String, Object>> getCustomerProduct(@Param("customer_id")String customer_id);
	/**
	 * 判断该产品是否已经被添加过
	 * @param map
	 * @return
	 */
	Integer getCustomerProductByItem_id(Map<String, Object> map);

	List<String> getCustomerAddedProduct(@Param("customer_id")String customer_id, @Param("com_id")String com_id);

	/**
	 * 根据customer_id获取客户资料
	 * @param customer_id 客户内码
	 * @param com_id 
	 * @return 客户信息
	 */
	Map<String, Object> getCustomerByCustomer_id(@Param("customer_id")String customer_id, @Param("com_id")String com_id);
	/**
	 * 获取指定客户及其下级所有客户
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getCustomerTree(Map<String, Object> map);

	List<Map<String, Object>> getCustomerAndEmployeeTree(Map<String, Object> map);

	int getCustomerAndEmployeeCount(PersonnelQuery query);

	List<Map<String, Object>> getCustomerAndEmployeePage(PersonnelQuery query);

	List<Map<String, Object>> getCustomerTreeByEmployeeId(
			Map<String, Object> map);
	/**
	 * 查询订单记录总数
	 * @param map
	 * @return
	 */
	int getOrderRecordCount(Map<String, Object> map);
	/**
	 * 查询订单记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderRecordPage(Map<String, Object> map);

	List<Map<String, Object>> getPayOderRecord(@Param("customer_id")String customerId,@Param("com_id")String com_id);

	Map<String, Object> getOrderCount(@Param("customer_id")String customerId,@Param("com_id")String com_id);

	List<Map<String, Object>> getAccounts(Map<String, Object> params);
	/**
	 * 获取结算方式最后一级
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSettlementLast(Map<String, Object> map);
	/**
	 * 获取审批流程当前订单最大编号
	 * @param nowdate 当前日期
	 * @return 
	 */
	String getApprovalNo(@Param("nowdate")String nowdate);

	Integer checkClientSelfId(@Param("com_id")String comId, @Param("self_id")String self_id);
	/**
	 * 订单跟踪记录总数查询
	 * @param map
	 * @return
	 */
	Integer orderTrackingRecordCount(Map<String, Object> map);
	/**
	 * 订单跟踪记录查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> orderTrackingRecord(Map<String, Object> map);
	/**
	 * 获取欠条审批记录编号,用于组合欠条路径
	 * @param map2
	 * @return
	 */
	String getIoupathByOA(Map<String, Object> map2);

	void updateOrder_Process(@Param("com_id")String comId, @Param("salesOrder_Process")String salesOrder_Process);
	/**
	 * 获取客户的微信ID
	 * @param mapOrder
	 * @return 返回微信id和手机号
	 */
	Map<String,Object> getCustomerWeixinID(Map<String, Object> mapOrder);
	/**
	 * 获取客户导入到微信中的数据
	 * @param map
	 * @return 微信号不为空的数据
	 */
	List<Map<String, Object>> getCustomerToWeixin(Map<String, Object> map);

	String getClerk_idAccountApprover(@Param("com_id") String comId);

	void deletePayInfo(Map<String, Object> map);

	Map<String, String> getCustomerName(@Param("customer_id")String customerId, @Param("com_id") String comId);
	/**
	 * 
	 * @param map
	 * @return
	 */
	String getUpper_customer_id(Map<String, Object> map);
	/**
	 * 获取订单信息根据
	 * @param seeds_ids
	 * @return
	 */
	List<Map<String, Object>> findOrderBySeeds_id(@Param("seeds_ids")String seeds_ids);
	/**
	 * 获取客户是否是最后一级
	 * 如果有下级表示,使用单位的账号进行登录
	 * @param customerId
	 * @param comId
	 * @return  返回上级客户的编码
	 */
	String getCustomerNext(Map<String,Object> map);
	/**
	 * 根据职务获取客户的微信账号和手机号
	 * @param params
	 * @return
	 */
	List<Map<String, String>> getCustomerWeixinByHeadship(
			Map<String, Object> params);

	String getOrderPayState(Map<String, Object> map);
	/**
	 * 在客户登录的时候修改客户登录时间
	 * @param map
	 */
	void updateLoginTime(Map<String, Object> map);

	Map<String,Object> getComIdByAddress(Map<String, Object> map);
	/**
	 * 获取订单金额根据seeds_id,然后根据com_id分组 ,不等于当前运营商
	 * @param mapparam
	 * @return
	 */
	List<Map<String, Object>> getJeByseedsIdGcomId(Map<String, Object> mapparam);
	/**
	 * 判断当前客户是否在该运营商下面存在
	 * @param customer_id
	 * @param com_id
	 * @return
	 */
	Map<String, Object> getCustomerByCid(@Param("customer_id")String customer_id, @Param("com_id")String com_id);
	/**
	 * 获取上级和下级客户信息
	 * @param customer_id
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getUpNextCustomerByCid(@Param("customer_id")String customer_id,
			@Param("com_id")Object com_id);
	/**
	 * 更新订单中客户编码为当前IP地址的订单为正式客户编码
	 * @param map
	 */
	void updatOrderCustomerId(Map<String, Object> map);
	/**
	 * 获取参与人员消息
	 * @param map
	 * @return
	 */
	String getMembersInfo(Map<String, Object> map);
	/**
	 * 更新客户的收货地址
	 * @param json
	 */
	void updateFhdz(Map<String, Object> json);

	void updateClientOrderDriveInfo(Map<String, Object> map);
	/**
	 * 获取客户所属员工的微信信息
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getClerk_idByCustomer_id(Map<String, Object> map);
	/**
	 * 分页查询供应商信息
	 * @param query
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> findSupplier(SupplierQuery query)throws Exception;
	/**
	 * 统计供应商信息条数
	 * @param obj
	 * @return
	 */
	int getSupplierCount(SupplierQuery query);
	/**
	 * 检查产品唯一编码是否已经被购买
	 * @param map
	 * @return
	 */
	Integer checkSN(Map<String, String> map);
	/**
	 * 更新订单状态
	 * @param map
	 * @return
	 */
	void updateOrderStatus(Map<String, Object> map);
	/**
	 * 获取带计划数的产品分页列表
	 * @param map
	 * @return
	 */
	Integer getPlanProductPageCount(Map<String, Object> map);
	/**
	 * 获取带计划数的产品分页列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPlanProductPage(Map<String, Object> map);
	/**
	 * 获取带有昨日计划数和零售价的产品详细
	 * @param map
	 * @return
	 */
	Map<String, Object> getPlanProductInfo(Map<String, Object> map);
	/**
	 * 
	 * @param comId
	 * @param customerId 
	 * @return
	 */
	String getNoDeliveryOrderSum_si(@Param("customer_id")String customerId,@Param("com_id")String comId);
	/**
	 * 更新订单状态根据客户编码
	 * @param map
	 * @return
	 */
	Integer updateOrderStatusBycustomer_id(Map<String, String> map);
	/**
	 * 更新订单状态为支付中,并同步更新数量
	 * @param json
	 * @return
	 */
	Integer updateOrderStatusPay(JSONObject json);
	/**
	 * 获取订单记录在客户个人中心中
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderStateRecord(Map<String, Object> map);
	/**
	 * 获取支付中订单编号
	 * @param map
	 * @return
	 */
	List<String> getSimpleOrderPayInfoOrderNo(Map<String, Object> map);
	/**
	 * 简单支付中订单信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getSimpleOrderPayInfo(Map<String, Object> map);
	/**
	 * 获取支付中产品名称
	 * @param map
	 * @return
	 */
	List<String> getPayOrderProductName(Map<String, Object> map);
	/**
	 * 更新订单数量
	 * @param map
	 * @return
	 */
	Integer updateOrderSdOq(Map<String, Object> map);
	/**
	 * 获取支付中订单的seeds_id,用于在微信支付调用结束后生成付款单数据
	 * @param map
	 * @return
	 */
	List<Integer> getPayOrderSeeds_id(Map<String, Object> map);
	/**
	 * 获取客户信息根据weixinID
	 * @param map
	 * @return
	 */
	Map<String, Object> getCustomerInfoByWeixinID(Map<String, Object> map);

	Integer updateFHDZToOrder(Map<String, Object> map);
	/**
	 * 获取客户信息根据openid
	 * @param com_id
	 * @param openid
	 * @return
	 */
	Map<String, Object> getCustomerInfoByOpenid(Map<String, Object> map);
	/**
	 * 检查当前支付订单编号是否全部一样,
	 * @param map
	 * @return 返回订单编号数量,大于1就说明不一样
	 */
	Integer checkPayOrderNoSame(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer collectionConfirmListCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> collectionConfirmList(Map<String, Object> map);
	/**
	 * 获取支付消息是否已经确认
	 * @param map
	 * @return
	 */
	String getPayInfoFlag(Map<String, Object> map);
	/**
	 * 获取客户简单信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getCustomerSimpleInfo(Map<String, Object> map);

}
