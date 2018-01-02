package com.qianying.service;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import com.qianying.page.PageList;

public interface IProductionManagementService{
	
	/**
	 * 期初库存查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> initialMaintenancePage(Map<String, Object> map);
	/**
	 * 期初应收查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> initialReceivablePage(Map<String, Object> map);
	/**
	 * 期初应付查询
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> initialPayablePage(Map<String, Object> map);
	/**
	 * 库存调拨单
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> inventoryAllocationFind(Map<String, Object> map);
	String sp_baseinitStore(Map<String, Object> map);
	/**
	 * 库存初始化
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> wareinitPage(Map<String, Object> map);
	/**
	 * 获取生产计划单号
	 * @param map
	 * @return
	 */
	String productionPlanSdOrderID(Map<String, Object> map);
	/**
	 * 查询所有状态为使用的产品信息
	 */
	PageList<Map<String, Object>> getProductInfo(Map<String, Object> map);
	/**
	 * 查询所有订单,状态不为待支付、支付中
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getOrderInfo(Map<String, Object> map);
	/**
	 * 新增生产计划
	 * @param jsons
	 * @param map
	 */
	void addProductionPlan(JSONArray jsons, Map<String, Object> map);
	/**
	 * 查询所有已增加生产计划
	 */
	PageList<Map<String, Object>> getProductionPlanInfo(Map<String, Object> map);
	/**
	 * 删除生产计划
	 * @param jsons
	 * @param map
	 */
	void delProductionPlan(JSONArray jsons, Map<String, Object> map);
	/**
	 * 作废生产计划
	 * @param map
	 */
	void unuseProductionPlan(Map<String, Object> map);
	/**
	 * 获取工序
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductionProcessInfo(Map<String, Object> map);
	/**
	 *  获取当前工段最大工序号
	 * @param map
	 * @return
	 */
	Double getMaxNoSerial(Map<String, Object> map);
	/**
	 * 增加工序
	 * @param map
	 */
	String addProductionProcessInfo(Map<String, Object> map);
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
	 * 获取生产计划
	 * @param map
	 * @return
	 */
	Map<String, Object> getProductionPlanning(Map<String, Object> map);
	/**
	 * 获取paigong_id
	 * @param map
	 * @return
	 */
	String getPaiGongID(Map<String, Object> map);
	/**
	 * 查询已派工信息by排产编号
	 * @param map
	 * @return
	 */
	List<Object> getDispatchingWork(Map<String, Object> map);
	/**
	 * 生产派工
	 * @param jsons
	 * @param map
	 */
	void addProductionProcess(Map<String, Object> map);
	/**
	 * 删除派工
	 * @param map
	 */
	void delDispatchingWork(Map<String, Object> map);
	/**
	 * 作废派工
	 * @param map
	 */
	void unusedDispatchingWork(Map<String, Object> map);
	/**
	 * 生产派工微信通知
	 * @param map
	 */
	void dispatchingWorkSendInfo(Map<String, Object> map);
	/**
	 * 待通知质检项查询
	 * @return
	 */
	List<Object> getInformQC(Map<String, Object> map);
	/**
	 * 开始生产
	 * @param map
	 */
	void beginWork(Map<String, Object> map);
	/**
	 * 通知质检
	 * @param map
	 */
	void sendInformQC(Map<String, Object> map);
	/**
	 * 质检查询
	 * @param map
	 * @return
	 */
	List<Object> getQualityTesting(Map<String, Object> map);
	/**
	 * 通过com_id、seeds_id获取派工信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getDispatchingWorkBySeedsID(Map<String, Object> map);
	/**
	 * 质检
	 * @param map
	 */
	void qualityTest(Map<String, Object> map);
	/**
	 * 获取工序树形
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWorkProcessTree(Map<String, Object> map);
	/**
	 * 获取工人树形
	 * @param map
	 * @return
	 */
	List<Object> getWorkerTree(Map<String, Object> map);
	/**
	 * 计算各工序完工数量
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEachProcessJJSLALL(Map<String, Object> map);
	/**
     * 删除单个文件
     * @param sPath被删除文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
    public boolean deleteFile(String sPath);
    /**
     * 删除目录（文件夹）以及目录下的文件
     * @param sPath被删除目录的文件路径
     * @return 目录删除成功返回true，否则返回false
     */
    public boolean deleteDirectory(String sPath);
    /**
     * 获取目录下的所有文件名
     * @param sPath目录的路径
     * @return List
     */
    public List<String> getFileName(String sPath);
    /**
     * 库存分页记录
     * @param map
     * @return
     */
	PageList<Map<String, Object>> getWarePage(Map<String, Object> map);
	/**
	 * 分页查询定制订单生产计划数据
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getProductionPlanTailorInfo(
			Map<String, Object> map);
	/**
	 * 期初库存信息
	 * @param map
	 * @return
	 */
	Map<String, Object> initialMaintenanceInfo(Map<String, Object> map);
	/**
	 * 期初应收信息
	 * @param map
	 * @return
	 */
	Map<String, Object> initialReceivableInfo(Map<String, Object> map);
	List<Map<String, Object>> getWareList(Map<String, Object> map);
}
