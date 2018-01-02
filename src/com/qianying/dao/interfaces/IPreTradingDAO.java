package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

public interface IPreTradingDAO {
	/**
	 * 预售方确认
	 * @param map
	 * @return 影响记录数
	 */
	Integer preSaleConfirm(Map<String, Object> map);
	/**
	 * 预售查询分页-总数
	 * @param map
	 * @return 返回养殖户或者收购方的预购/预售 历史预售信息,撮合成功的不成功
	 */
	Integer preTradingPageCount(Map<String, Object> map);
	/**
	 * 预售查询分页
	 * @param map
	 * @return 返回养殖户或者收购方的预购/预售 历史预售信息,撮合成功的不成功
	 */
	List<Map<String, Object>> preTradingPage(Map<String, Object> map);
	/***
	 * 养殖户预购确认数据列表
	 * @param map
	 * @return 返回需要养殖户确认
	 */
	List<Map<String, Object>> preSaleConfirmListQuery(Map<String, Object> map);
	/**
	 * 获取指定猪种的平均 养殖户挂价,数量和收购方挂价,数量
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPreAverageInfo(Map<String, Object> map);
	/**
	 *  获取指定猪种下的预购方/预售方
	 * @param request
	 * @return 预购方或者预售方预售相关信息
	 */
	List<Map<String, Object>> getPreCustomerInfo(Map<String, Object> map);
	/**
	 * 更新sql
	 * @param map
	 * @return 返回影响条数
	 */
	Integer updateSql(Map<String, Object> map);
	/**
	 * 获取所有的产品 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductByClassName(Map<String, Object> map);
	/**
	 * 预购记录总数
	 * @param map
	 * @return
	 */
	Integer reserveBuyQueryCount(Map<String, Object> map);
	/**
	 * 预购记录分页查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> reserveBuyQuery(Map<String, Object> map);
	/**
	 * 
	 * @param ygf
	 * @return
	 */
	Integer updateYgfInfo(JSONObject ygf);
	/**
	 * 
	 * @param ysf
	 * @return
	 */
	Integer updateYsfInfo(JSONObject ysf);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer platformHistoryCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> platformHistoryPage(Map<String, Object> map);

}
