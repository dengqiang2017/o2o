package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

public interface IStatisticalRreportDAO {
	/**
	 * 获取订单销量分部门统计列表
	 * @param map
	 * @return
	 */
	List<Map<String,Object>> orderReportDeptCountlist(
			Map<String, Object> map);
	/**
	 * 获取订单销量明细列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> orderReportDeptDetailList(Map<String, Object> map);
	/**
	 * 订单记录明细
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> orderRecord(Map<String, Object> map);
	/**
	 * 订单销售记录总计
	 * @param map
	 * @return
	 */
	Map<String, Object> orderRecordSum(Map<String, Object> map);
	/**
	 * 销售收款报表列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> receivablesReportList(Map<String, Object> map);
	/**
	 * 客户对账单查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> accountStatementList(Map<String, Object> map);
	/**
	 * 应收款总账查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> accountsReceivableLedgerList(
			Map<String, Object> map);
	/**
	 * 采购付款报表数据获取
	 * @param map
	 * @return
	 */
	Integer getPaymentSheetCount(Map<String, Object> map);
	List<Map<String, Object>> getPaymentSheetList(Map<String, Object> map);
	/**
	 * 应付明细账查询
	 */
	List<Map<String, Object>> getFkAccount(Map<String, Object> map);//调用存储过程
	Integer getFkAccountCount(Map<String, Object> map);
	List<Map<String, Object>> getFkAccountList(Map<String, Object> map);
	/**
	 * 获取采购明细账数据
	 */
	Integer getCgmxStatisticalCount(Map<String, Object> map);
	List<Map<String, Object>> getCgmxStatisticalList(Map<String, Object> map);
	/**
	 * 获取直销提成报表数据-总数
	 * @param map
	 * @return
	 */
	Integer getSalesCommissionCount(Map<String, Object> map);
	/**
	 * 获取直销提成报表数据
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSalesCommissionList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getSalesBonusCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSalesBonusList(Map<String, Object> map);
	/**
	 * 按产品进行分类汇总
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> planReportCount(Map<String, Object> map);
	/**
	 * 按产品,客户查询明细
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> planReportDetail(Map<String, Object> map);
	/**
	 * 更新计划对应供应商
	 * @param map
	 */
	void updatePlanGys(Map<String, Object> map);
	/**
	 * 明细统计-汇总
	 * @param map
	 * @return
	 */
	Integer planReportDetailPageCount(Map<String, Object> map);
	/**
	 * 明细统计分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> planReportDetailPage(Map<String, Object> map);
	/**
	 * 计划金额汇总根据店面分组
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPlanBusinessAccontCount(Map<String, Object> map);
}
