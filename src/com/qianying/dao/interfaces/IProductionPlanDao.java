package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

public interface IProductionPlanDao {

	List<Map<String, Object>> getProductionProcessInfo(Map<String, Object> map);

	Integer getProductionTrackingPageCount(Map<String, Object> map);

	List<Map<String, Object>> getProductionTrackingPage(Map<String, Object> map);

	List<Map<String, Object>> getProductionTrackingYieM02030(
			Map<String, Object> map);
	/**
	 * 获取已派工未通知的员工
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getPaigongEmployee(Map<String, Object> map);
	/**
	 * 获取工人生产列表-总数
	 * @param map
	 * @return
	 */
	Integer getWorkerProductionCount(Map<String, Object> map);
	/**
	 * 获取工人生产列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkerProductionList(Map<String, Object> map);
	/**
	 * 获取下工序工人
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getNextWorkEmployee(Map<String, Object> map);
	/**
	 * 开始生产
	 * @param map
	 */
	void beginProduction(Map<String, Object> map);
	/**
	 * 获取指定工序的质检员工
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getQualityEmployee(Map<String, Object> map);
	/**
	 * 标识该生产计划已完成
	 * @param map
	 */
	void productionEnd(Map<String, Object> map);
	/**
	 * 获取待质检
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getQualityCheckList(Map<String, Object> map);
	/**
	 * 获取员工能质检的工序id
	 * @param map
	 * @return
	 */
	Map<String, Object> getQualityWork_id(Map<String, Object> map);
	/**
	 * 获取当前工序的下一道工序
	 * @param map
	 * @return
	 */
	Map<String, Object> getNextWorkInfo(Map<String, Object> map);
	/**
	 * 通知生产,当前工序的工人如果没有开始生产就标识为0未生产
	 * @param map
	 */
	void noticeProduction(Map<String, Object> map);
	/**
	 * 工人工价表查询记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkPriceList(Map<String, Object> map);
	/**
	 * 工价汇总表查询记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkSumPriceList(Map<String, Object> map);

	List<Map<String, Object>> getProductionEmpoyee(Map<String, Object> map);

	List<Map<String, Object>> getWorkPriceLeftList(Map<String, Object> map);

	List<Map<String, Object>> getWorkSumPriceLeftList(Map<String, Object> map);

	Integer getProductionPlanInfoCount(Map<String, Object> map);

	List<Map<String, Object>> getProductionPlanInfoList(Map<String, Object> map);
	/**
	 * 生产计划数据源-销售订单|定制订单-总数
	 * @param map
	 * @return
	 */
	Integer getPlanSourceOrderCount(Map<String, Object> map);
	/**
	 * 生产计划数据源-销售订单|定制订单-列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPlanSourceOrderList(Map<String, Object> map);
	/**
	 * 生产计划数据源-产品基础资料-总数
	 * @param map
	 * @return
	 */
	Integer getPlanSourceProductCount(Map<String, Object> map);
	/**
	 * 生产计划数据源-产品基础资料-列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPlanSourceProductList(Map<String, Object> map);
	/**
	 * 获取生产计划订单相关信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getProductionPlanInfo(Map<String, Object> map);
	/**
	 * 获取订单当前流程名称
	 * @param map
	 * @return
	 */
	Map<String, Object> getOrderProcessName(Map<String, Object> map);
	/**
	 * 更新订单状态开始生产
	 * @param mapdetail
	 */
	void updateOrderProductionBegin(Map<String, Object> mapdetail);

	void updateOrderProductionEnd(Map<String, Object> mapinfo);
	/**
	 * 获取指定工序类别下的工序数量
	 * @param map
	 * @return
	 */
	Integer getProductionProcessCount(Map<String, Object> map);
}
