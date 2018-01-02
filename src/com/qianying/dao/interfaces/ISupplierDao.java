package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface ISupplierDao {
	
	/**
	 * 供应商登录
	 * @param name
	 * @param com_id 
	 * @return
	 */
	Map<String, Object> checkLogin(@Param("name") String name,@Param("com_id")String com_id);

	Integer checkPhone(String phone);

	String getMaxSupplier();

	int getGysOrderCount(Map<String, Object> map);

	List<Map<String, Object>> getGysOrderList(Map<String, Object> map);

	List<Map<String, Object>> gysOrderInfo(Map<String, Object> map);
	/**
	 * 更新采购订单状态,并获取物流对象
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String orderReceipt(Map<String, Object> map)throws Exception;

	Map<String, String> updateGysWuliu(Map<String, Object> map);
	/**
	 * 按车号汇总-类别查询
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
	 * 获取供应商产品列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSupplierItemList(Map<String, Object> map);
	/**
	 * 获取供应商信息根据openid
	 * @param map
	 * @return
	 */
	Map<String, Object> getGysInfoByOpenid(Map<String, Object> map);
	/**
	 * 供应商收款总数
	 * @param map
	 * @return
	 */
	Integer getReceiptCount(Map<String, Object> map);
	/**
	 * 供应商收款列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getReceiptList(Map<String, Object> map);

}
