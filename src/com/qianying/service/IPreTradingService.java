package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.PageList;


public interface IPreTradingService {
	/**
	 * 保存预售
	 * @param map
	 * @return
	 * @throws Exception
	 */
	String savePre(Map<String, Object> map)throws Exception;
	/**
	 * 预售方确认
	 * @param map
	 * @return 影响记录数
	 */
	String preSaleConfirm(Map<String, Object> map);
	/**
	 * 预售查询分页
	 * @param map
	 * @return 返回养殖户或者收购方的预购/预售 历史预售信息,撮合成功的不成功
	 */
	PageList<Map<String, Object>> preTradingPage(Map<String, Object> map);
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
	 * 修改预售/预购的挂价
	 * @param map
	 * @return
	 */
	String editGuajia(Map<String, Object> map);
	/**
	 * 保存撮合信息
	 * @param map
	 * @return
	 */
	String saveCuoheInfo(Map<String, Object> map);
	/**
	 * 获取所有猪
	 * @param map
	 * @return
	 */
	List<Map<String,Object>> getProductByClassName(Map<String, Object> map);
	/**
	 * 预购分页查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> reserveBuyQuery(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> platformHistoryPage(Map<String, Object> map);

}
