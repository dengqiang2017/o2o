package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

public interface IClientDAO {
	
	Integer getVisitPageCount(Map<String, Object> map)throws Exception;
	/**
	 * 获取客户拜访记录分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getVisitPage(Map<String, Object> map)throws Exception;
	/**
	 * 删除客户拜访记录
	 * @param map
	 * @return
	 */
	Integer delVisit(Map<String, Object> map)throws Exception;
	/**
	 * 获取拜访记录信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getVisitInfo(Map<String, Object> map);
	/**
	 * 删除员工工作计划
	 * @param map
	 * @return
	 */
	Integer delWorkPlan(Map<String, Object> map);
	/**
	 * 获取员工工作计划详情
	 * @param map
	 * @return
	 */
	Map<String, Object> getWorkPlanInfo(Map<String, Object> map);
	/**
	 * 获取员工跟踪计划汇总数
	 * @param map
	 * @return
	 */
	Integer getWorkPlanPageCount(Map<String, Object> map);
	/**
	 * 获取员工工作计划分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkPlanPage(Map<String, Object> map);
	/**
	 * 获取客户信息根据客户编码
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getClientInfoById(Map<String, Object> map);
	/**
	 * 保存客户阅读记录
	 * @param map
	 * @return
	 */
	Integer saveGanzhiInfo(Map<String, Object> map)throws Exception;
	/**
	 * 
	 * @param map
	 */
	void updateGanzhiEndTime(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer ganzhiRecordCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> ganzhiRecordPage(Map<String, Object> map);
	/**
	 * 获取客户签到信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getQiandaoInfo(Map<String, Object> map);
	/**
	 * 获取客户的总金币数
	 * @param map
	 * @return
	 */
	Integer getTotalJinbi(Map<String, Object> map);
	/**
	 * 检查该产品是否被客户分享
	 * @param map
	 * @return
	 */
	Integer checkFenxByItemId(Map<String, Object> map);
	/**
	 * 获取产品浏览记录总数
	 * @param map
	 * @return
	 */
	Integer getProductViewCount(Map<String, Object> map);
	/**
	 * 获取产品浏览记录分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductViewPage(Map<String, Object> map);
	/**
	 * 获取金币消息根据订单编号
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getJinbiInfoByOrderNo(Map<String, Object> map);
	/**
	 * 更新金币消费记录
	 * @param map
	 * @return
	 */
	Integer updateJinbiXiaofei(Map<String, Object> map);
	/**
	 * 客户所属优惠券总数
	 * @param map
	 * @return
	 */
	Integer getClientCouponCount(Map<String, Object> map);
	/**
	 * 删除优惠券
	 * @param map
	 * @return
	 */
	Integer delCoupon(Map<String, Object> map);
	/**
	 * 优惠券总数
	 * @param map
	 * @return
	 */
	Integer getCouponCount(Map<String, Object> map);
	/**
	 * 优惠券分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getCouponPage(Map<String, Object> map);
	/**
	 * 检查客户是否已经领取过优惠券
	 * @param map
	 * @return
	 */
	Integer checkCoupon(Map<String, Object> map);
	/**
	 * 获取客户所属优惠券
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getClientCouponList(Map<String, Object> map);
	/**
	 * 获取客户所属优惠券分页总数
	 * @param map
	 * @return
	 */
	Integer getClientCouponC(Map<String, Object> map);
	/**
	 * 获取金币分页列表总数
	 * @param map
	 * @return
	 */
	Integer getJinbiCount(Map<String, Object> map);
	/**
	 * 获取金币分页列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getJinbiPage(Map<String, Object> map);
	/**
	 * 获取当前支付可使用优惠券
	 * @param request
	 * @return
	 */
	List<Map<String, Object>> getCanUseCoupon(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<String> getProClassByOrder(Map<String, Object> map);
	/**
	 * 更新使用优惠券状态和关联订单编号
	 * @param map
	 * @return
	 */
	Integer saveUseYhqInfo(Map<String, Object> map);
	/**
	 * 解除锁定优惠券
	 * @param map
	 * @return
	 */
	Integer checkYhq(Map<String, Object> map);
	/**
	 * 客户拜访记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getVisitExcel(Map<String, Object> map);
	/**
	 * 营销计划记录
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkPlanExcel(Map<String, Object> map);
}
