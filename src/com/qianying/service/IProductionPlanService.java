package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.PageList;

public interface IProductionPlanService {
	/**
	 * 获取工序列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductionProcessInfo(Map<String, Object> map);
	/**
	 *  获取生产计划跟踪报表分页数据
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getProductionTrackingPage(
			Map<String, Object> map);
	/**
	 * 保存派工信息
	 * @param map
	 * @return 派工专业编号
	 */
	String savePaigong(Map<String, Object> map);
	/**
	 * 通知工人开始生产
	 * @param map
	 * @return
	 */
	String noticeProduction(Map<String, Object> map);
	/**
	 * 获取工人生产列表
	 * @param map
	 * @param all 不为空的时候查询所有记录
	 * @return  不查询已完成的数量
	 */
	PageList<Map<String, Object>> getWorkerProductionList(Map<String, Object> map);
	/**
	 * 开始生产
	 * @param map
	 * @return
	 */
	String beginProduction(Map<String, Object> map);
	/**
	 * 通知质检
	 * @param map
	 * @return
	 */
	String noticeQualityCheck(Map<String, Object> map);
	/**
	 * 质检通过数据保存
	 * @param map
	 * @return
	 */
	String qualityChecked(Map<String, Object> map);
	/**
	 * 获取待质检数据列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getQualityCheckList(Map<String, Object> map);
	/**
	 * 工人工价表查询记录
	 * @param map
	 * @return
	 */
	Map<String, Object> getWorkPriceList(Map<String, Object> map);
	/**
	 * 工价汇总表查询记录
	 * @param map
	 * @return
	 */
	Map<String, Object> getWorkSumPriceList(Map<String, Object> map);
	/**
	 * 分页查询已下生产计划
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getProductionPlanInfo(Map<String, Object> map);
	/**
	 * 保存生产计划
	 * @param map
	 * @return
	 */
	String saveProductionPlan(Map<String, Object> map);
	/**
	 * 查询下生产计划数据来源
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getProductInfo(Map<String, Object> map);
}
