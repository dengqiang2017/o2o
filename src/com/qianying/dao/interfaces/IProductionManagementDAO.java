package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface IProductionManagementDAO {

	Integer initialMaintenanceCount(Map<String, Object> map);
	/**
	 * 期初库存分页查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> initialMaintenancePage(Map<String, Object> map);
	/**
	 * 期初应收查询总数
	 * @param map
	 * @return
	 */
	Integer initialReceivableCount(Map<String, Object> map);
	/**
	 * 期初应收查询分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> initialReceivablePage(Map<String, Object> map);
	/**
	 * 期初应付查询总数
	 * @param map
	 * @return
	 */
	Integer initialPayableCount(Map<String, Object> map);
	/**
	 * 期初应付查询分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> initialPayablePage(Map<String, Object> map);
	Integer findInventoryAllocationCount(Map<String, Object> map);
	List<Map<String, Object>> findInventoryAllocationFindQuery(
			Map<String, Object> map);
	/**
	 * 库存初始化审批存储过程
	 * @param map
	 */
	void sp_baseinitStore(Map<String, Object> map);
	/**
	 * 库存初始化查询总数
	 * @param map
	 */
	int wareinitCount(Map<String, Object> map);
	/**
	 * 库存初始化查询
	 * @param map
	 */
	List<Map<String, Object>> wareinitPage(Map<String, Object> map);
	/**
	 * 分页查询状态为使用的所以产品信息总记录数
	 * @param map
	 * @return
	 */
	Integer getProductInfoCount(Map<String, Object> map);
	/**
	 * 分页查询状态为使用的所以产品信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductInfoList(Map<String, Object> map);
	/**
	 * 分页 查询状态不为待支付、支付中的销售开单信息总记录数
	 * @param map
	 * @return
	 */
	Integer getOrderInfoCount(Map<String, Object> map);
	/**
	 * 分页 查询状态不为待支付、支付中的销售开单信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOrderInfoList(Map<String, Object> map);
	/**
	 * 通过com_id、ivt_oper_listing获取YieM02010中记录数
	 */
	Integer getYieM02010Count(@Param("com_id")String com_id, @Param("ivt_oper_listing")String ivt_oper_listing);
	/**
	 * 获取PH数量
	 */
	Integer getPHNum(@Param("PH")String PH);
	/**
	 * 通过com_id、ivt_oper_listing获取生成PH尾部信息
	 */
	String getPHTail(@Param("com_id")String com_id, @Param("ivt_oper_listing")String ivt_oper_listing);
	/**
	 * 已下生产计划总记录数
	 * @param map
	 * @return
	 */
	Integer getProductionPlanInfoCount(Map<String, Object> map);
	/**
	 * 分页查询已下生产计划
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductionPlanInfoList(Map<String, Object> map);
	/**
	 * 删除已下生产计划
	 * @param delMap
	 */
	void delProductionPlan(Map<String, Object> delMap);
	/**
	 * 作废生产计划
	 * @param map
	 */
	void unuseProductionPlan(Map<String, Object> map);
	/**
	 * 查询所有工序 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductionProcessInfo(Map<String, Object> map);
	/**
	 * 通过序号查询工序
	 * @param map
	 * @return
	 */
	Map<String,Object> getProductionProcessByNoSerial(Map<String, Object> map);
	/**
	 * 通过work_id查询工序
	 * @param map
	 * @return
	 */
	Map<String,Object> getProductionProcessByWorkID(Map<String, Object> map);
	/**
	 * 查询工序中最大id
	 * @param map
	 * @return
	 */
	Integer getProductionProcessMaxID(Map<String, Object> map);
	/**
	 * 查询工序表最大序号
	 * @param map
	 * @return
	 */
	Double getMaxNoSerial(Map<String, Object> map);
	/**
	 * 更新工序
	 * @param map
	 * @return
	 */
	void updateProductionProcessInfo(Map<String, Object> map);
	/**
	 * 删除工序
	 * @param map
	 */
	void delProductionProcessInfo(Map<String, Object> map);
	/**
	 * 移动工序
	 * @param map
	 */
	void moveProductionProcessInfo(Map<String, Object> map);
	/**
	 * 查询已派工信息by排产编号
	 * @param map
	 * @return
	 */
	List<Object> getDispatchingWork(Map<String, Object> map);
	/**
	 * 通过派工单号查询生产流程卡主表信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getDispatchingWorkMain(Map<String, Object> map);
	/**
	 * 修改派工任务
	 * @param map
	 */
	void editDispatchingWork(Map<String, Object> map);
	/**
	 * 删除派工任务
	 * @param map
	 */
	void delDispatchingWork(Map<String, Object> map);
	/**
	 * 作废派工任务
	 * @param map
	 */
	void unusedDispatchingWork(Map<String, Object> map);
	/**
	 * 修改生产计划从表状态为生产中
	 * @param map
	 */
	void updateYieM02031Status(Map<String, Object> map);
	/**
	 * 获取工人树
	 * @param map
	 * @return
	 */
	List<Object> getWorkerTree(Map<String, Object> map);
	/**
	 * 待通知质检项查询
	 * @param map
	 * @return
	 */
	List<Object> getInformQC(Map<String, Object> map);
	/**
	 * 开始生产
	 * @param map
	 */
	void beginWork(Map<String, Object> map);
	/**
	 * 通过生产计划单号、产品代码获取生产计划信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getProductionPlanning(Map<String, Object> map);
	/**
	 * 通过生产计划单号、产品代码、工序、工人获取派工信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getDispatchingWorkBySeedsID(Map<String, Object> map);
	/**
	 * 质检查询
	 * @param map
	 * @return
	 */
	List<Object> getQualityTesting(Map<String, Object> map);
	/**
	 * 质检
	 * @param map
	 */
	void qualityTest(Map<String, Object> map);
	/**
	 * 计算该工序完工数量
	 * @param map
	 * @return
	 */
	Double getJJSLALL(Map<String, Object> map);
	/**
	 * 计算各工序完工数量
	 * @param mapQry
	 * @return
	 */
	List<Map<String, Object>> getEachProcessJJSLALL(Map<String, Object> map);
	/**
	 * 更新生产计划已完工数量为计划数量
	 * @param allsend_oq
	 */
	void updateAllsendOQ(Map<String, Object> allsend_oq);
	/**
	 * 通过store_struct_id、item_id、auto_mps_id、mps_id获取库存信息
	 * @param fromMap
	 * @return
	 */
	Map<String, Object> getStoreInfo(Map<String, Object> map);
	/**
	 * 通过store_struct_id、item_id、auto_mps_id、mps_id更新库存信息
	 * @param fromMap
	 */
	void updateStoreInfo(Map<String, Object> map);
	/**
	 * 通过com_id、item_id获取产品信息
	 * @param string
	 * @param string2
	 * @return
	 */
	Map<String, Object> getProdInfoByItemId(@Param("item_id")String item_id, @Param("com_id")String com_id);
	Integer getWarePageCount(Map<String, Object> map);
	List<Map<String, Object>> getWarePageList(Map<String, Object> map);
	/**
	 * 定制订单生产计划
	 * @param map
	 * @return
	 */
	Integer getProductionPlanTailorInfoCount(Map<String, Object> map);
	/**
	 * 定制订单生产计划
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductionPlanTailorInfo(
			Map<String, Object> map);
	List<Map<String, Object>> getProductionPlanInfo(Map<String, Object> map);
	/**
	 * 更新计划从表所属工序
	 * @param mapdetail
	 * @return
	 */
	Integer updateYieM02011(Map<String, Object> mapdetail);
	/**
	 * 期初库存信息
	 * @param map
	 * @return
	 */
	Map<String, Object> initialMaintenanceInfo(Map<String, Object> map);
	/**
	 * 期初应收导出
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> initialReceivableList(Map<String, Object> map);
	List<Map<String, Object>> getWareList(Map<String, Object> map);
}
