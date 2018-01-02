package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.ibatis.annotations.Param;

import com.qianying.dao.base.BaseDao;

public interface IManagerDAO extends BaseDao {
	/**
	 * 检查登录
	 * @param name 用户名
	 * @param com_id 
	 * @return 该用户的信息
	 */
	Map<String, Object> checkLogin(@Param("name")String name, @Param("com_id")String com_id);
	/**
	 * 获取部门列表
	 * @param map 上级部门列表
	 * @return 部门列表
	 */
	List<Map<String, Object>> getDeptByUpper_dept_id(Map<String, Object> map);
	/**
	 * 获取部门最大的部门编号
	 * @return 部门编号
	 */
	String getMaxDeptSort_id();
	/**
	 * 保存部门
	 * @param map
	 */
	void saveDept(Map<String, Object> map);
	/**
	 * 更新部门
	 * @param map
	 */
	void updateDept(Map<String, Object> map);
	/**
	 * 查找在该部门下的员工
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getDeptEmployee(Map<String, Object> map);
	/**
	 * 删除部门
	 * @param sort_id
	 */
	void deleteDept(String sort_id);
	List<Map<String, Object>> getRegionalismTree(Map<String, Object> map);
	////////////////库房相关/////////////////////
	/**
	 * 获取 库房树形列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWarehouseTree(Map<String, Object> map);
	/**
	 * 获取库房信息 
	 * @param sort_id 库房id
	 * @param com_id 
	 * @return
	 */
	Map<String, Object> getWarehouse(@Param("sort_id")String sort_id, @Param("com_id")String com_id);
	/**
	 * 获取库房信息总数
	 * @param query
	 * @return
	 */
	Integer getWarehouseByPageCount(Map<String,Object> map);
	/**
	 * 获取库房分页信息
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getWarehouseByPage(Map<String,Object> map);
	//////////////结算方式相关///////////////
	/**
	 * 获取最大的Seed_id值
	 * @param map 表名和字段名
	 * @return 最大的seed值
	 */
	Integer getMaxSeeds_id(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSettlementList(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Map<String, Object> getSettlement(Map<String, Object> map);
	/**
	 * 
	 * @param sort_id
	 * @param com_id 
	 * @return
	 */
	Map<String, Object> getDeptBySortId(@Param("sort_id")String sort_id, @Param("com_id")String com_id);
	/**
	 * 查询一条记录的一个值
	 * @param map
	 * @return
	 */
	String getUpperId(Map<String, Object> map); 
	/**
	 * 获取数据的详细信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getDataInfo(Map<String, Object> map);
	/**
	 * 
	 * @param sort_id
	 * @return
	 */
	Map<String, Object> getRegionalismInfo(@Param("sort_id")String sort_id);
	/**
	 * 删除记录
	 * @param map
	 */
	void deleteRecord(Map<String, Object> map);
	/**
	 * 获取流程步骤最大值
	 * @param map
	 * @return
	 */
	Integer getApproval_step(Map<String, Object> map);
	/**
	 * 获取流程信息
	 * @param seeds_id
	 * @return
	 */
	Map<String, Object> getProcessInfo(@Param("seeds_id")Integer seeds_id);
	/**
	 * 获取流程列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProcessList(Map<String, Object> map);
	/**
	 * 上下移动
	 * @param map
	 */
	void moveProcess(Map<String, Object> map);
	/**
	 * 获取最大的步骤数
	 * @param map
	 * @return
	 */
	Integer getMaxApproval_step(Map<String, Object> map);
	void delProcess(Map<String, Object> map);
	String getMaxApproval(Map<String, Object> map);
	/**
	 * 获取系统参数
	 * @param com_id 
	 * @return
	 */
	Map<String, Object> getSystemParams(@Param("com_id")String com_id);
	/**
	 * 获取员工编码在9003中是否存在
	 * @param clerk_id
	 * @param comId
	 * @return
	 */
	Map<String, Object> getClerkIdTo9003(@Param("clerk_id")String clerk_id,@Param("com_id") String comId);
	/**
	 * 获取员工的多来源信息进行展示
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEmployeeInfo(Map<String, Object> map);
	/**
	 * 获取所有部门信息
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getDeptAll(@Param("com_id")String com_id);
	/**
	 * 获取所有结算方式信息
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getSettlementAll(@Param("com_id")String com_id);
	/**
	 * 获取所有行政区划信息
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getRegionalismAll(@Param("com_id")String com_id);
	/**
	 * 获取所有客户信息
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getClientAll(@Param("com_id")String com_id);
	/**
	 * 获取所有库房信息
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getWarehouseAll(@Param("com_id")String com_id);
	/**
	 * 获取所有库房信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProdAll(Map<String, Object> map);
	/**
	 * 获取所有产品类别信息
	 * @param com_id
	 * @return
	 */
	List<Map<String, Object>> getProdClassAll(@Param("com_id")String com_id);
	
	String sp_BaseIsUsed(Map<String, Object> map);
	/**
	 * 获取供应商基本信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getGysTree(Map<String, Object> map);
	/**
	 * 获取供应商总数
	 * @param map
	 * @return
	 */
	Integer getGysPageCount(Map<String, Object> map);
	/**
	 * 获取供应商分页列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getGysPageList(Map<String, Object> map);
	/**
	 * 获取运营商分页总数
	 * @param map
	 * @return
	 */
	Integer getOperatePageCount(Map<String, Object> map);
	/**
	 * 获取运营商分页列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOperatePageList(Map<String, Object> map);
	/**
	 * 获取运营商列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getOperateTree(Map<String, Object> map);
	Integer checkPhone(@Param("phone")String phone,@Param("table")String table, @Param("sqlwhere")String sqlwhere);
	/**
	 * 获取电工或者司机的详细
	 * @param map
	 * @return
	 */
	Map<String, Object> getElectricianInfo(Map<String, Object> map);
	/**
	 * 获取司机或者电工信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getDriverAndDian(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getCustomerTijianCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getCustomerTijianList(Map<String, Object> map);
	/**
	 * 查询所有库存初始化信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWareinitAll(Map<String, Object> map);
	/**
	 * 查询所有结算方式
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> findMeteringUnit(Map<String, Object> map);
	/**
	 * 增加结算方式
	 * @param map
	 * @return
	 */
	void addMeteringUnit(Map<String, Object> map);
	/**
	 * 修改结算方式
	 * @param map
	 * @return
	 */
	void editMeteringUnit(Map<String, Object> map);
	/**
	 * 删除结算方式
	 * @param map
	 * @return
	 */
	void delMeteringUnit(Map<String, Object> map);
	/**
	 * 查询所有产地品牌
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProducarea(Map<String, Object> map);
	/**
	 * 增加产地品牌
	 * @param map
	 * @return
	 */
	void addProducarea(Map<String, Object> map);
	/**
	 * 修改产地品牌
	 * @param map
	 * @return
	 */
	void editProducarea(Map<String, Object> map);
	/**
	 * 删除产地品牌
	 * @param map
	 * @return
	 */
	void delProducarea(Map<String, Object> map);
	/**
	 * 查询所有会计科目
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getAccountingSubjects(Map<String, Object> map);
	/**
	 * 增加会计科目
	 * @param map
	 * @return
	 */
	void addAccountingSubjects(Map<String, Object> map);
	/**
	 * 编辑会计科目
	 * @param map
	 * @return
	 */
	void editAccountingSubjects(Map<String, Object> map);
	/**
	 * 删除会计科目
	 * @param map
	 * @return
	 */
	void delAccountingSubjects(Map<String, Object> map);
	List<Map<String, Object>> getThirdPartyPersonnelTree(Map<String, Object> map);
	List<Map<String, Object>> tijianExport(Map<String, Object> map);
	Map<String, Object> getTijianInfo(Map<String, Object> map);
	/**
	 * 查询上报地址中是否有该电工
	 * @param map
	 * @return
	 */
	Map<String, Object> findUpAddressByNo(Map<String,Object> map);
	Integer getOperateId(@Param("idVal")String idVal);
	/**
	 * 获取客户信息
	 * @param map
	 * @return
	 */
	List<Map<String,String>> getCustomerInfo(Map<String, Object> map);
	void deltijian(Map<String, Object> map);
	/**
	 * 更新体检表
	 * @param map
	 */
	void updateTijian(Map<String, Object> map);
	/**
	 * 保存体检表并返回seeds_id
	 * @param map
	 * @return
	 */
	Integer saveTijian(Map<String, Object> map);
	List<Map<String, Object>> getctl00190by001(@Param("com_id")String com_id);
	/**
	 * 获取该运营商是否在该表中
	 * @param com_id
	 * @return
	 */
	Integer getctl00190bycomid(String com_id);
	/**
	 * 更新司机信息
	 * @param mapdriver
	 */
	void updateDriveInfo(Map<String, Object> mapdriver);
	void delPurchasingCheck(Map<String, Object> mainMap);
	/**
	 * 获取指定表中的成员信息,
	 * @param table
	 * @param filedName
	 * @param val 
	 * @return
	 */
	Map<String, Object> getMemberInfo(@Param("table")String table, @Param("filedName")String filedName, @Param("val")String val);
	/**
	 * 入库存储过程调用
	 */
	Integer saveProcurement(Map<String, Object> map);
	/**
	 * 退货存储过程调用
	 */
	Object purchaseReturn(Map<String, Object> map);
	/**
	 * 查询m_flag
	 */
	Integer queryFlag(Map<String, Object> map);
	/**
	 * 更新验收入库从表
	 * @param map
	 */
	void updateRkcb(Map<String, Object> map);
	/**
	 * 更新入库主表
	 * @param map
	 */
	void updateRkzb(Map<String, Object> map);
	/**
	 * 更新已入库产品数量
	 */
	void updateRkcp(Map<String, Object> map);
	/**
	 * 更新运营商支付状态
	 * @param map
	 * @return
	 */
	String updateOperateOk(Map<String, Object> map);
	/**
	 * 
	 * @param com_id
	 * @param amount 
	 * @return
	 */
	String getComIdWeixinID(Map<String,Object> map);
	/**
	 * 
	 * @return
	 */
	List<Map<String, Object>> getOperateNoWorkList();
	/**
	 * 删除已下采购订单
	 * @param map
	 */
	void delOrder(Map<String, Object> map);
	/**
	 * 更新入库标识
	 * @param map
	 */
	void updateRkzbByFlag(Map<String, Object> map);
	/**
	 * 根据采购单号将m_flag改为4
	 */
	void updateFlagByNo(Map<String, Object> map);
	/**
	 * 根据产品Id和库房ID更新库存数量
	 */
	void updateKcById(Map<String, Object> map);
	/**
	 * 期初维护更新库存表信息
	 * @param map
	 */
	void updatekcTable(Map<String,Object> map);
	/**
	 * 根据仓库ID和产品ID查询库存表实际库存数量
	 * @param map
	 * @return string
	 */
	String getAccivt(Map<String,Object> map);
	/**
	 * 退货更新库存(自写SQL)
	 * @param map
	 */
	void updateKcReturn(Map<String,Object> map);
	/**
	 * 当前仓库产品库存为0时删除该仓库产品信息
	 */
	void delKcItem(Map<String,Object> map);
	/**
	 * 检查参数是否存在
	 * @param object
	 * @param comId
	 * @return
	 */
	Map<String,Object> checkSystem(@Param("param_name")Object paramName, @Param("com_id")String com_id);
	/**
	 * 获取系统参数根据com_id
	 * @param comId
	 * @return 该com_id下的系统参数
	 */
	List<Map<String, Object>> getSystemParamsByComId(String comId);
	/**
	 * 获取表字段
	 * @param table
	 * @return 获取第一条数据
	 */
	Map<String, Object> getTableFiled(@Param("table")String table);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getFiledList(Map<String, Object> map);
	/**
	 * 更新产品采购价
	 * @param map
	 * @return
	 */
	Integer updateProPrice(Map<String, Object> map);
	/**
	 * 获取微信状态
	 * @param com_id 
	 * @return
	 */
	List<String> getWeixinState(@Param("com_id")String com_id);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer updateWeixinState(Map<String, Object> map);
	/**
	 * 更新销售开单审核状态
	 * @param map
	 */
	void updateComfirmFlag(Map<String,Object> map);
	/**
	 * 更新采购退货单审核状态
	 * @param map
	 */
	void updateReturnFlag(Map<String,Object> map);
	/**
	 * 销售退货更新销售开单数量
	 * @param map
	 */
	void updateSalesOrder(Map<String, Object> map);
	/**
	 * 删除客户前检查客户是否生成数据
	 * @param map
	 * @return 返回数据总数
	 */
	Integer checkDelCilent(Map<String, Object> map);
	/**
	 * 保存模板消息到数据库中
	 * @param map
	 * @return 状态
	 */
	Integer saveWeixinTemplateMessageInfo(Map<String, Object> map);
	/**
	 * 获取抄送人员
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getChaosong(Map<String, Object> map);
	/**
	 * 更新报损单审核状态
	 * @param map
	 */
	void updateBsComfirmFlag(Map<String,Object> map);
	/**
	 * 查询已入库数量
	 * @param map
	 * @return
	 */
	Double selRkNum (Map<String,Object> map);
	/**
	 * 查询销售开单数量
	 * @param map
	 * @return
	 */
	Double selSalesNum (Map<String,Object> map);
	/**
	 * 更新订单状态,在修改订单流程名称时
	 * @param newname 新订单流程名称
	 * @param oldname 旧订单流程名称
	 * @return
	 */
	Integer updateOrderStatus(Map<String, Object> map);
	/**
	 * 获取供应商信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getGysInfo(Map<String, Object> map);
	/**
	 * 期初库存审核
	 * @param request
	 * @param ivt_num_detail 期初库存编码
	 * @param initial_flag 审核标识 Y/N
	 * @throws Exception
	 */
	Integer initKucunShenhe(Map<String, Object> map)throws Exception;
	/**
	 * 期初应付款审核
	 * @param request
	 * @param ivt_num_detail 期初应付款编码
	 * @param initial_flag 审核标识 Y/N
	 * @return
	 */
	Object initYfkShenHe(Map<String, Object> map);
	/**
	 * 期初应收款审核
	 * @param ivt_num_detail 期初库存应收款编码
	 * @param initial_flag 审核标识 Y/N
	 * @return
	 */
	Object initYskShenHe(Map<String, Object> map);
	/**
	 * 更新审核后的原始数据
	 * @param map
	 * @return
	 */
	Object updateShenhe(Map<String, Object> map);
	/**
	 * 采购入库审核
	 * @param map
	 * @return
	 */
	Object Sp_stockStock(Map<String, Object> map);
	/**
	 *采购退货审核
	 * @param map
	 * @return
	 */
	Object Sp_stockQuitGoods(Map<String, Object> map);
	/**
	 * 更新产品表中产品类别字段
	 * @param comId
	 * @param sort_id 旧产品类别值 查询
	 * @param newsort_id 新产品类别值 更新
	 * @return
	 */
	Integer updateProductByClass(@Param("com_id")String comId,  @Param("type_id")String sort_id, @Param("new_type_id")String newsort_id)throws Exception;
	/**
	 * 获取员工表中产品类别值根据旧产品类别值
	 * @param comId
	 * @param sort_id 旧产品类别值
	 * @return type_id,com_id,clerk_id
	 */
	List<Map<String, Object>> getEmployeeType_id(@Param("com_id")String comId, @Param("type_id")String type_id)throws Exception;
	/**
	 * 更新员工表中产品类别值 根据员工编码
	 * @param map2
	 * @return
	 */
	Integer updateEmployeeType_idById(Map<String, Object> map2)throws Exception;
	/**
	 * 更新客户的openid到资料中
	 * @param map
	 * @return
	 */
	Integer updateWeixinOpenid(Map<String, Object> map);
	/**
	 * 获取文章信息
	 * @param json
	 * @return
	 * @throws Exception
	 */
	JSONObject getArticleInfo(JSONObject json)throws Exception;
	/**
	 * 获取文章总数
	 * @param map
	 * @return
	 */
	Integer getArticleCount(Map<String, Object> map)throws Exception;
	/**
	 * 获取文章分页数据
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getArticlePage(Map<String, Object> map)throws Exception;
	/**
	 * 获取文章信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getArticleInfoData(Map<String, Object> map)throws Exception;
	/**
	 * 删除文章信息
	 * @param map
	 * @return
	 */
	Integer delArticle(Map<String, Object> map)throws Exception;
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer updateOpenid(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, String>> getOpenidById(Map<String, Object> map);
	/**
	 * 同步微信服务号模板到数据表中
	 * @param jsons
	 * @param com_id 
	 * @return
	 */
	Integer tongbuWeixinTemplate(Map<String,Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWexinMsgTemplate(Map<String, Object> map);
	/**
	 * 更新采购订单标识
	 * @param param
	 * @return
	 */
	Integer updatePurOrderFlag(Map<String, Object> param);
	/**
	 * 获取所有客户的电话号码
	 * @param com_id
	 * @return
	 */
	List<Map<String, String>> getAllClientphone(@Param("com_id")String com_id);
	/**
	 * 获取用户信息根据类型
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getUserInfoByType(Map<String, Object> map);
	/**
	 * 获取所有客户记录的seeds_id
	 * @return
	 */
	List<Map<String, Object>> getAllClient();
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer updateClientLicense(Map<String, Object> map);
}
