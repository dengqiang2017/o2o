package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.PageList;

/**
 * 报表统计业务实现
 * @author dengqiang
 *
 */
public interface IStatisticalRreportService {
	/**
	 * 获取订单销量分部门统计列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> orderReportDeptCountlist(
			Map<String, Object> map);
	/**
	 * 获取订单销量明细列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> orderReportDeptDetailList(
			Map<String, Object> map);
	/**
	 * 获取订单记录明细
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> orderRecord(Map<String, Object> map);
	/**
	 * 销售明细订单总计
	 * @param map
	 * @return
	 */
	Map<String, Object> orderRecordSum(Map<String, Object> map);
	/**
	 * 销售收款报表列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> receivablesReportList(Map<String, Object> map);
	/**
	 * 客户对账单查询列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> accountStatementList(Map<String, Object> map);
	/**
	 * 应收款总账分页查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> accountsReceivableLedgerList(
			Map<String, Object> map);
	/**
	 * 订单明细记录导出
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> orderRecordExcel(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> orderReportDeptDetailListExcel(
			Map<String, Object> map);
	/**
	 * 邀请客户对账
	 * @param map
	 * @return
	 */
	String inviteReconciliation(Map<String, Object> map);
	/**
	 * 采购付款报表数据获取
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getPaymentSheet(Map<String, Object> map);
	/**
	 * 应付明细账查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getFkAccount(Map<String, Object> map);
	/**
	 * 采购明细账查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getCgmxStatistical(Map<String, Object> map);
	/**
	 * 获取直销提成报表数据
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getSalesCommission(Map<String, Object> map);
	/**
	 * 获取直销奖金报表数据
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getSalesBonus(Map<String, Object> map);
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
	 * 保存下计划的供应商
	 * @param map
	 * @return
	 */
	String savePlanGys(Map<String, Object> map);
	/**
	 * 明细按照分页模式进行加载
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> planReportDetailPage(Map<String, Object> map);
	/**
	 * 计划金额汇总根据店面分组
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getPlanBusinessAccontCount(Map<String, Object> map);
	String generatePurchaseOrderByPlan(Map<String, Object> map);
}
