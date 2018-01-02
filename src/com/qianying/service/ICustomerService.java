package com.qianying.service;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.qianying.bean.ResultInfo;
import com.qianying.page.CustomerQuery;
import com.qianying.page.PageList;
import com.qianying.page.PersonnelQuery;
import com.qianying.page.ProductQuery;
import com.qianying.page.SupplierQuery;

public interface ICustomerService extends IBaseService{

	boolean checkPhone(String phone, String com_id);

	String getMaxCustomer_id();
	PageList<Map<String, Object>> findQuery(CustomerQuery query);
	/**
	 * 获取订单编号
	 * @param orderName 要获取的单号名称
	 * @return
	 */
	String getOrderNo(String orderName,String com_id);
	/**
	 * 保存订单信息
	 * @param map
	 */
	void saveOrder(Map<String, Object> map) throws Exception;
	/**
	 * 客户登录
	 * @param name
	 * @param comId 
	 * @return
	 */
	Map<String, Object> checkLogin(String name, String comId);
	/**
	 * 客户登录
	 * @param name
	 * @param pwd
	 * @return
	 */
	List<Map<String, Object>> checkLoginEwm(Map<String,Object> map);
	/**
	 * 确认登录的运营商,获取该运营商下客户信息
	 * @param name
	 * @param pwd
	 * @return
	 */
	Map<String, Object> checkedLogin(String name, String pwd);
	
	/**
	 * 客户自己增加产品
	 * @param customer
	 * @return 
	 */
	String addProduct(Map<String, Object> customer) throws Exception;

	/**
	 * 获取客户自己添加的品种
	 * @param customer_id 客户编码
	 * @return 产品列表
	 */
	public List<Map<String, Object>> getCustomerProduct(Object customer_id);

	/**
	 * 获取已经添加过的产品item_id
	 * @param customer_id  客户编码
	 * @param comId 
	 * @return 产品的item_id列表
	 */
	List<String> getCustomerAddedProduct(Object customer_id, String comId);
	
	/**
	 * 根据customer_id获取客户资料
	 * @param customer_id 客户内码
	 * @param comId 
	 * @return 客户信息
	 */
	Map<String, Object> getCustomerByCustomer_id(String customer_id, String comId);
	/**
	 * 获取指定客户以及下级客户
	 * @param map 指定客户
	 * @return
	 */
	List<Map<String, Object>> getCustomerTree(Map<String, Object> map);

		/**
	 * 获取客户树形,根据员工所在id
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getCustomerAndEmployeeTree(Map<String, Object> map);
	PageList<Map<String, Object>> getCustomerAndEmployeePage(
			PersonnelQuery query);

	List<Map<String, Object>> getCustomerTreeByEmployeeId(Map<String,Object> map);
	/**
	 * 获取订单相关数据
	 * @param type 0==未确认,1=待支付,2=已支付
	 * @param query 查询参数对象
	 * @return 查询结果列表
	 */
	PageList<Map<String, Object>> getOrderRecord(String type,
			String customerId, ProductQuery query);
	/**
	 * 用于在未支付页面对订单的支付 更新订单状态为待支付
	 * @param sd_order_ids 订单号数组
	 */
	void orderSelectConfirm(String[] sd_order_ids);
	/**
	 * 获取待支付的记录
	 * @param customerId
	 * @param comId 
	 * @return
	 */
	Map<String, Object> getPayOderRecord(String customerId, String comId);
	/**
	 * 订单进入支付状态
	 * @param seeds_ids
	 */
	void orderPay(String[] seeds_ids); 
	void orderPayment(Map<String, Object> map); 
	/**
	 * 获取审批流程当天最大值编号
	 * @param nowdate
	 * @return 审批流程编号
	 */
	Integer getApprovalNo(String nowdate);
	/**
	 * 提交审批路程数据
	 * @param mapsp
	 */
	void postApproval(Map<String, Object> mapsp);
	/**
	 * 订单支付
	 * @param mapjson json相关数据
	 * @param maporder 订单相关数据
	 * @param request 
	 * @return 执行结果
	 */
	ResultInfo orderPaymentTwo(Map<String, String[]> mapjson,
			Map<String, String> maporder);
	/**
	 * 检查外码是否存在,
	 * @param comId
	 * @param self_id
	 * @return 存在就返回true,不存在返回false
	 */
	boolean checkClientSelfId(String comId, String self_id);
	/**
	 * 打欠条存储欠条审批流程 
	 * @param map
	 * @return 返回审批流程单号
	 */
	String saveIouOA_ctl03001_approval(Map<String, Object> map);
	/**
	 * 订单跟踪记录查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> orderTrackingRecord(Map<String, Object> map);
	/**
	 * 更新销售订单流程
	 * @param comId
	 * @param salesOrder_Process 流程值
	 */
	void updateOrder_Process(String comId, String salesOrder_Process);
	/**
	 * 获取结算方式
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSettlementList(Map<String, Object> map);
	/**
	 * 保存账户充值
	 * @param map
	 * @param maporder 
	 * @throws Exception 
	 */
	void savePaymoney(Map<String, Object> map, Map<String, Object> maporder) throws Exception;
	/**
	 * 获取客户导入到微信中的数据
	 * @param map
	 * @return 微信号不为空的字段
	 */
	List<Map<String, Object>> getCustomerToWeixin(Map<String, Object> map);

	String getClerk_idAccountApprover(String comId);
	/**
	 * 支付取消
	 * @param map
	 * @return
	 */
	String alipayCancel(Map<String, Object> map);
	/**
	 * 支付完成确认
	 * @param map
	 * @return
	 */
	String alipayOK(Map<String, Object> map);
	/**
	 * 保存订单并提交支付
	 * @param map
	 */
	void saveOrderAndPay(Map<String, String> map) throws Exception ;
	/**
	 * 更新订单标识为结算
	 * @param map
	 * @throws Exception
	 */
	void saveOrderBYShopping(Map<String, String> map) throws Exception ;

	void saveOrderToShopping(Map<String, String> map)throws Exception ;

	void sendMsg(String customerId, String comId, String msginfo);

	String getCustomerName(String customerId, String comId);
	/**
	 * 获取上级编码
	 * @param customer_id
	 * @param comId
	 * @return
	 */
	String getUpper_customer_id(String customer_id, String comId);

	void confimShouhuo(Map<String, Object> map)throws Exception;
	/**
	 * 查询订单根据seeds
	 * @param seeds_ids
	 * @return
	 */
	List<Map<String, Object>> findOrderBySeeds_id(String seeds_ids);
	/**
	 * 客户确认签名
	 * @param jsons
	 * @param map
	 * @return
	 */
	String confirmQianming(JSONArray jsons, Map<String, Object> map);
	/**
	 * 通知员工客户已经登录
	 * @param map
	 */
	void noticeEmployee(Map<String, Object> map);

	String getOrderPayState(Map<String, Object> map);
	/**
	 * 客户登录时修改登录时间
	 * @param map
	 */
	void updateLoginTime(Map<String, Object> map);

	Map<String,Object> getComIdByAddress(Map<String, Object> map);
	/**
	 * 更新订单中客户编码为当前IP地址的订单为正式客户编码
	 * @param map
	 */
	void updatOrderCustomerId(Map<String, Object> map);
	/**
	 * 获取接收人和发送人名称
	 * @param map
	 * @return
	 */
	Map<String, Object> getMembersInfo(Map<String, Object> map);
	/**
	 * 更新客户的发货地址
	 * @param json 
	 */
	void updateFhdz(JSONObject json);
	
	void noticeDrive(Map<String, Object> map);
	/**
	 * 提交对账单备注信息
	 * @param map
	 */
	void postdzdMemo(Map<String, Object> map); 
	/**
	 * 获取供应商信息
	 * @param query
	 * @return
	 */
	PageList<Map<String, Object>> findSupplier(SupplierQuery query);
	/**
	 * 保存采购付款
	 * @param map
	 * @param maporder
	 * @throws Exception
	 */
	void savePayProcurement(Map<String, Object> map, Map<String, Object> maporder) throws Exception;

	Map<String, Object> getCustomerWeixinID(Map<String, Object> map);
	/**
	 * 更新订单状态
	 * @param map
	 * @return
	 */
	String updateOrderStatus(Map<String, Object> map);
	/**
	 * 获取带计划数的产品分页列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getPlanProductPage(Map<String, Object> map);
	/**
	 * 获取带有昨日计划数和零售价的产品详细
	 * @param map
	 * @return
	 */
	Map<String, Object> getPlanProductInfo(Map<String, Object> map);
	/**
	 * 获取支付中的订单信息,用于结算支付
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderStatusPaying(Map<String, Object> map);
	/**
	 * 获取订单状态记录,用于客户端分状态显示
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderStateRecord(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Map<String, Object> getSimpleOrderPayInfo(Map<String, Object> map);
	/**
	 * 更新订单数量
	 * @param map
	 * @return
	 */
	String updateOrderSdOq(Map<String, Object> map);
	/**
	 * 获取支付中订单的seeds_id,用于在微信支付调用结束后生成付款单数据
	 * @param map
	 * @return
	 */
	List<Integer> getPayOrderSeeds_id(Map<String, Object> map);
	/**
	 * 生成付款单数据
	 * @param fkdmap
	 * @return
	 */
	String savePayInfo(Map<String, Object> fkdmap);
	/**
	 * 订单提交,货到付款
	 * @param map
	 * @return
	 */
	String cashDelivery(Map<String, Object> map);
	/**
	 * 获取支付中的订单产品名称
	 * @param map
	 * @return
	 */
	List<String> getPayOrderProductName(Map<String, Object> map);
	/**
	 * 获取客户信息根据微信id
	 * @param map
	 * @return
	 */
	Map<String, Object> getCustomerInfoByWeixinID(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	String updateFHDZToOrder(Map<String, Object> map);
	/**
	 * 根据openid获取客户信息
	 * @param com_id
	 * @param openid
	 * @param type 企业号或者服务号
	 * @return
	 */
	Map<String, Object> getCustomerInfoByOpenid(String com_id, Object openid, String type);
	/**
	 * 获取客户自己的付款列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> collectionConfirmList(Map<String, Object> map);
	/**
	 * 删除付款记录
	 * @param map
	 * @return
	 */
	String delPayInfo(Map<String, Object> map);
	/**
	 * 保存修改后的支付信息
	 * @param map
	 * @return
	 */
	String saveEditPayInfo(Map<String, Object> map);
	/**
	 * 获取客户对应销售代表
	 * @param map
	 * @return
	 */
	Map<String, String> getSalesInfo(Map<String, Object> map);

	Map<String, Object> getCustomerSimpleInfo(Map<String,Object> map);
}
