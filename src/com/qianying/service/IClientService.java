package com.qianying.service;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import com.qianying.page.PageList;

public interface IClientService {
	/**
	 *  获取客户简单信息列表
	 * @param request
	 * @return 客户名称,记忆码,内码,userid,微信id
	 */	
	List<Map<String, Object>> getClientSimpleList(Map<String, Object> map)throws Exception;
	/**
	 * 保存客户信息
	 * @param map
	 * @return
	 */
	String saveUserInfo(Map<String, Object> map)throws Exception;
	/**
	 * 获取客户拜访记录
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getVisitPage(Map<String, Object> map)throws Exception;
	/**
	 * 删除客户记录
	 * @param map
	 * @return
	 */
	String delVisit(Map<String, Object> map)throws Exception;
	/**
	 * 保存拜访记录
	 * @param map
	 * @return 拜访编号
	 */
	String saveVisitInfo(Map<String, Object> map)throws Exception;
	/**
	 * 获取拜访记录,根据编号
	 * @param map
	 * @return
	 */
	Map<String, Object> getVisitInfo(Map<String, Object> map);
	/**
	 * 删除工作计划
	 * @param map
	 * @return
	 */
	String delWorkPlan(Map<String, Object> map);
	/**
	 * 获取工作计划信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getWorkPlanInfo(Map<String, Object> map);
	/**
	 *  获取工作计划分页数据
	 * @param request
	 * @return
	 */
	PageList<Map<String, Object>> getWorkPlanPage(Map<String, Object> map);
	/**
	 * 保存员工工作计划
	 * @param map
	 * @return
	 */
	String saveWorkPlanInfo(Map<String, Object> map)throws Exception;
	/**
	 * 根据客户编码获取客户信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getClientInfoById(Map<String, Object> map);
	/**
	 * 保存文章阅读记录
	 * @param map
	 * @return
	 */
	String saveGanzhiInfo(Map<String, Object> map) throws Exception;
	/**
	 * 更新感知记录阅读时间
	 * @param map
	 */
	void updateGanzhiEndTime(Map<String, Object> map) throws Exception;
	/**
	 * 感知记录分页
	 * @param map
	 * @return
	 * @throws Exception
	 */
	PageList<Map<String, Object>> ganzhiRecordPage(Map<String, Object> map) throws Exception;
	/**
	 * 获取客户签到信息
	 * @param map
	 * @return 1.获取当前客户的总金币2.今天是否已经签到 false-未签到
	 */
	Map<String, Object> getQiandaoInfo(Map<String, Object> map);
	/**
	 * 保存客户签到金币生成
	 * @param map
	 * @return
	 */
	Map<String, Object> saveQiandaoInfo(Map<String, Object> map);
	/**
	 * 保存获取的金币
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	String saveJinbiInfo(Map<String, Object> map) throws Exception;
	/**
	 * 获取客户浏览产品
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getProductViewPage(Map<String, Object> map);
	/**
	 * 获取客户总金币数
	 * @param map
	 * @return
	 */
	Integer getTotalJinbi(Map<String, Object> map);
	/**
	 * 检查金币抵扣中是否有该订单再内
	 * @param map
	 * @return
	 */
	String checkJinbiDikou(Map<String, Object> map);
	/**
	 * 更新金币消费为正式
	 * @param map
	 * @return
	 */
	String updateJinbiXiaofei(Map<String, Object> map);
	/**
	 * 获取金币总数,优惠券总数,浏览记录总数
	 * @param map
	 * @return
	 */
	Map<String, Object> getOtherTotal(Map<String, Object> map);
	/**
	 * 保存优惠券
	 * @param request
	 * @return
	 */
	String saveCoupon(Map<String, Object> map);
	/**
	 * 删除发布的优惠券
	 * @param request
	 * @return
	 */
	String delCoupon(Map<String, Object> map);
	/**
	 * 优惠券分页展示
	 * @param request
	 * @return
	 */
	PageList<Map<String, Object>> getCouponPage(Map<String, Object> map);
	/**
	 * 客户领取优惠券
	 * @param request
	 * @return
	 */
	String receiveCoupon(Map<String, Object> map);
	/**
	 * 获取客户的优惠券
	 * @param request
	 * @return
	 */
	PageList<Map<String, Object>> getClientCoupon(Map<String, Object> map);
	/**
	 * 获取金币分页记录
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getJinbiPage(Map<String, Object> map);
	/**
	 * 获取当前支付可使用优惠券
	 * @param request
	 * @return
	 */
	List<Map<String, Object>> getCanUseCoupon(Map<String, Object> map);
	/**
	 * 保存优惠券信息
	 * @param map
	 * @return
	 */
	String saveUseYhqInfo(Map<String, Object> map)throws Exception;
	/**
	 * 检查优惠券锁定
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
	 * 营销计划
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkPlanExcel(Map<String, Object> map);
}
