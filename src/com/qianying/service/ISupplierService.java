package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.PageList;

public interface ISupplierService {

	Map<String, Object> checkLogin(String name, String comId);
	/**
	 * 检查供应商登录账号是否存在
	 * @param phone
	 * @return 存在返回false,不存在返回true
	 */
	boolean checkPhone(String phone);

	String getMaxSupplier();

	void save(Map<String, Object> map);

	PageList<Map<String, Object>> getGysOrderList(Map<String, Object> map);

	List<Map<String, Object>> gysOrderInfo(Map<String, Object> map);

	void orderReceipt(Map<String, Object> map)throws Exception;
	/**
	 * 通知供应商物流信息
	 * @param map
	 */
	void noticeGysWuliu(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 */
	void noticeShippingManager(Map<String, Object> map);
	/**
	 *  按车号汇总-列表查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getCustomerOrderList(Map<String, Object> map);
	/**
	 * 按产品汇总-类别查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getItemOrderList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSupplierItemList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	String saveUpPrice(Map<String, Object> map);
	/**
	 * 获取供应商信息根据openid
	 * @param com_id
	 * @param openid
	 * @param type 企业号或者服务号
	 * @return
	 */
	Map<String, Object> getGysInfoByOpenid(String com_id, Object openid, String type);
	/**
	 * 保存修改供应商资料
	 * @param map
	 * @return
	 */
	String saveSupplierInfo(Map<String, Object> map);
	/**
	 * 获取供应商收款数据
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getReceiptPage(Map<String, Object> map);

}
