package com.qianying.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.qianying.page.PageList;
import com.qianying.page.WarehouseQuery;

public interface IManagerService  extends IBaseService{

	Map<String, Object> checkLogin(String name, String comId);
	/**
	 * 获取部门第一级不部门信息Upper_dept_id为空
	 * @return 一级部门信息
	 */
	List<Map<String, Object>> getDeptByUpper_dept_id(Map<String, Object> map);
	/**
	 * 获取部门最大编号
	 * @return 部门编号
	 */
	String getMaxDeptSort_id();
	/**
	 * 保存或者更新部门
	 * @param map 部门信息
	 * @param type 1-保存,2-更新
	 */
	void saveDept(Map<String, Object> map, int type);
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
	/**
	 * 获取地区树形数据
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getRegionalismTree(Map<String, Object> map);
	/**
	 * 获取库房tree结构
	 * @param map 用于查询上级结构id值
	 * @return
	 */
	List<Map<String, Object>> getWarehouseTree(Map<String, Object> map);
	/**
	 * 获取库房信息
	 * @param com_id 
	 * @param object
	 * @return
	 */
	Map<String, Object> getWarehouse(String sort_id, String com_id);
	/**
	 * 获取库房分页列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getWarehouseByPage(Map<String, Object> map);
	/**
	 * 获取表中当前最大的指定字段(seeds_id)值,没有加1
	 * @param tableName 查询来源表
	 * @param filedName 字段查询获取的值
	 * @return
	 */
	int getMaxSeeds_id(String tableName, String filedName);
	/**
	 * 存储数据
	 * @param map 数据字段与数据值集合
	 * @param type 1==更新,0==保存
	 * @param table 表名
	 * @param findName 字段名
	 * @param id 更新查询字段值
	 */
	void insertSql(Map<String, Object> map, int type, String table, String findName,String id);
	/**
	 * 获取结算方式树以及列表
	 * @param map 
	 * @return
	 */
	List<Map<String, Object>> getSettlementList(Map<String, Object> map);
	/**
	 * 获取结算方式详细
	 * @param param
	 * @return
	 */
	Map<String, Object> getSettlement(Map<String, Object> param);
	/**
	 * 获取部门详细信息
	 * @param sort_id
	 * @return
	 */
	Map<String, Object> getDeptBySortId(String sort_id);
	/**
	 * 获取上级编码,查询一个字段的一个记录
	 * @param table 表名
	 * @param upperName 上级字段名称
	 * @param idName 查询字段名称
	 * @param sort_id 查询值
	 * @return 上级编码
	 */
//	String getUpperId(String table, String upperName, String idName,
//			String sort_id);
	String getUpperId(Map<String, Object> mapcus);
	/**
	 * 获取数据详细信息
	 * @param table 表名
	 * @param idName 查询字段名
	 * @param idVal 查询字段值
	 * @return 数据详细信息
	 */
	Map<String, Object> getDataInfo(String table, String idName,
			String idVal);
	Map<String, Object> getRegionalismInfo(String sort_id);
	/**
	 * 删除记录
	 * @param table 表名
	 * @param fieldName id名
	 * @param upperName 上级id名
	 * @param val id值
	 */
	void deleteRecord(String table, String fieldName, String upperName, String val, String com_id);
	/**
	 * 获取指定流程最大的审批数
	 * @param map
	 * @return
	 */
	Integer getApproval_step(Map<String, Object> map);
	/**
	 * 保存增加流程
	 * @param map
	 */
	void saveProcessDetail(Map<String, Object> map);
	/**
	 * 上下移动流程
	 * @param map
	 */
	void moveProcess(Map<String, Object> map);
	/**
	 * 获取流程信息
	 * @param seeds_id
	 * @param type 
	 * @return
	 */
	Map<String, Object> getProcess(Integer seeds_id, String type);
	/**
	 * 删除流程
	 * @param map
	 */
	void delProcess(Map<String, Object> map);
	/**
	 * 获取流程列表
	 * @param map 流程名称
	 * @return
	 */
	List<Map<String, Object>> getProcessList(Map<String, Object> map);
	/**
	 * 查询一个字段的值
	 * @param table 表名
	 * @param showFiledName 显示字段名称
	 * @param findFiled 查询字段名称加查询值
	 * @param com_id 
	 * @return 数据值
	 */
	Object getOneFiledNameByID(String table, String showFiledName, String findFiled, String com_id);
	/**
	 * 获取系统参数-旧版
	 * @param comId
	 * @return
	 */
	Map<String, Object> getSystemParams(String comId);
	/**
	 * 保存系统参数
	 * @param map
	 */
	void saveSystemParams(Map<String, Object> map);
	/**
	 * 
	 * @param clerk_id
	 * @param comId
	 * @return
	 */
	Map<String, Object> getClerkIdTo9003(String clerk_id, String comId);
	/**
	 *  获取员工的多来源信息进行展示
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getEmployeeInfo(Map<String, Object> map);
	/**
	 * 判断删除项是否被引用
	 * @param map
	 * @return
	 */
	String sp_BaseIsUsed(Map<String, Object> map)throws Exception;
	/**
	 * 获取供应商基本信息
	 * @param map
	 * @param all 查询所有字段数据
	 * @return
	 */
	List<Map<String, Object>> getGysTree(Map<String, Object> map);
	/**
	 * 获取供应商分页列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getGysPage(Map<String, Object> map);
	/**
	 * 获取运营商分页列表
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getOperatePage(Map<String, Object> map);
	/**
	 * 获取运营商基本信息
	 * @param map
	 * @param all 查询所有字段数据
	 * @return
	 */
	List<Map<String,Object>> getOperateTree(Map<String, Object> map);
	/**
	 * 检查手机号
	 * @param phone
	 * @param table
	 * @param sqlwhere 
	 * @return true-不存在,false-存在
	 */
	boolean checkPhone(String phone, String table, String sqlwhere);
	/**
	 * 获取电工详细
	 * @param map
	 * @return
	 */
	Map<String,Object> getElectricianInfo(Map<String, Object> map);
	/**
	 * 客户体检表分页信息
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getCustomerTijian(Map<String, Object> map);
	/**
	 * 获取第三方人员信息
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getThirdPartyPersonnelTree(Map<String, Object> map);
	
	/**
	 * 获取结算方式
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> findMeteringUnit(Map<String, Object> map);
	/**
	 * 增加结算方式
	 * @param map
	 */
	void addMeteringUnit(Map<String, Object> map);
	/**
	 * 获取产地品牌
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProducarea(Map<String, Object> map);
	/**
	 * 增加产地品牌
	 * @param map
	 */
	void addProducarea(Map<String, Object> map);
	/**
	 * 获取会计科目
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getAccountingSubjects(Map<String, Object> map);
	/**
	 * 增加会计科目
	 * @param map
	 */
	void addAccountingSubjects(Map<String, Object> map);
	/**
	 * 获取体检表详细信息
	 * @param map
	 * @return
	 */
	Map<String,Object> getTijianInfo(Map<String, Object> map);
	Integer getOperateId(String idVal);
	/**
	 * 发送推广消息
	 * @param map
	 * @param type client,gys
	 * @param datatype 1-单个,0-全部,2-筛选出的多个
	 * @param customer_id
	 * @param blessing 祝福词
	 * @param 查询参数
	 * @return
	 */
	String sendSpreadMsg(Map<String, Object> map);
	/**
	 * 删除体检表
	 * @param map
	 */
	void deltijian(Map<String, Object> map);
	/**
	 * 更新体检表
	 * @param map
	 */
	void updateTijian(Map<String, Object> map);
	/**
	 * 1.先保存体检表数据，然后取出最大seeds_id
	 * @return
	 */
	Integer saveTijian(Map<String,Object> map);
	/**
	 * 增加运营商后将001中的数据复制一份到当前运营商编码中
	 * @param com_id
	 */
	void scctl00190(String com_id);
	/**
	 * 新增采购验收入库
	 * @param map
	 * @return
	 */
	String addPurchasingCheck(Map<String,Object> map);
	/**
	 * 删除已增加入库单
	 * 
	 */
	String delPurchasingCheck(Map<String,Object> map);
	/**
	 * 采购退货单
	 */
	String purchaseReturn(Map<String,Object> map);
	/**
	 * 仓库产品退货
	 */
	String itemReturn(Map<String,Object> map);
	/**
	 * 审核采购入库单
	 */
	String saveAccount(Map<String,Object> map)throws Exception;
	/**
	 * 放弃审核采购入库单
	 */
	String returnAccount(Map<String,Object> map);
	/**
	 * 更新运营商支付状态
	 * @param map
	 * @return 返回对应员工的编码
	 */
	String updateOperateOk(Map<String, Object> map);
	/**
	 * 
	 * @param com_id
	 * @param amount 
	 * @return tel_no
	 */
	String getComIdWeixinID(String com_id, Integer amount);
	/**
	 * 获取没有发送消息的运营商消息
	 * @return
	 */
	List<Map<String, Object>> getOperateNoWorkList();
	/**
	 * 删除直接下采购订单(不走推消息流程)
	 * @param map
	 */
	String delOrderByNo(Map<String,Object> map);
	/**
	 * 更新库存表
	 */
	void updatekcTable(Map<String,Object> map);
	/**
	 * 获取系统参数新版
	 * @param comId
	 * @return
	 */
	Map<String, Object> getSystemParamsByComIdSet(String comId);
	/**
	 * 获取系统参数
	 * @param param_name
	 * @param comId
	 * @return param_val
	 */
	Map<String, Object> checkSystemSet(String param_name, String comId);
	 /**
	  * 获取表字段
	 * @param table 
	  * @return
	  */
	Map<String, Object> getTableFiled(String table);
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
	String updateProPrice(Map<String, Object> map);
	/**
	 * 更新成员的微信状态
	 */
	void updateWeixinState();
	/**
	 * 审核采购退货单
	 * @throws Exception 
	 */
	String confirmReturn(Map<String,Object> map) throws Exception;
	/**
	 * 放弃审核采购退货单
	 */
	String returnConfirm(Map<String,Object> map);
	/**
	 * 删除客户前检查客户是否生成数据
	 * @param map
	 * @return 返回数据总数
	 */
	Integer checkDelCilent(Map<String, Object> map) throws Exception;
	/**
	 * 保存模板消息到数据库中
	 * @param map
	 * @return 状态
	 */
	JSONArray saveWeixinTemplateMessageInfo(Map<String, Object> map);
	/**
	 * 更新订单状态
	 * @param map
	 * @param newname 新订单流程名称
	 * @param oldname 旧订单流程名称
	 * @return
	 */
	String updateOrderStatus(Map<String, Object> map);
	/**
	 * 获取供应商信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getGysInfo(Map<String, Object> map);
	/**
	 * 期初应付款审核
	 * @param request
	 * @param seeds_id 期初应付款编码
	 * @param shenheType  审核数据类型,yfk,ysk
	 * @param initial_flag 审核标识 Y/N
	 * @return
	 */
	String initKuanxiangShenhe(Map<String, Object> map)throws Exception;
	/**
	 * 期初库存审核
	 * @param request
	 * @param ivt_num_detail 期初库存编码
	 * @param initial_flag 审核标识 Y/N
	 * @return
	 */
	String initKucunShenhe(Map<String, Object> map)throws Exception;
	/**
	 * 更新产品和员工表中的产品类别字段
	 * @param sort_id 旧编码
	 * @param newsort_id 新编码
	 * @return 
	 * @throws Exception
	 */
	String updateProductAndEmployee(String sort_id, String newsort_id)throws Exception;
	/**
	 * 更新客户的openid到客户资料中
	 * @param map
	 * @return
	 */
	String updateWeixinOpenid(Map<String, Object> map);
	/**
	 * 将文章信息存储到数据表中
	 * @param json
	 * @return
	 */
	String saveArticleToTable(JSONObject json)throws Exception;
	/**
	 * 获取文章分页
	 * @param map
	 * @return
	 */
	PageList<Map<String, Object>> getArticlePage(Map<String, Object> map)throws Exception;
	/**
	 * 
	 * @param map
	 * @return
	 */
	Map<String, Object> getArticleInfoData(Map<String, Object> map)throws Exception;
	/**
	 * 
	 * @param map
	 * @return
	 */
	String delArticle(Map<String, Object> map)throws Exception;
	/**
	 * 更新openid
	 * @param map
	 * @return
	 */
	Integer updateOpenid(Map<String, Object> map);
	/**
	 * 
	 * @param id 内编码
	 * @param com_id
	 * @param table 表名
	 * @return
	 */
	List<Map<String, String>> getOpenidById(String id, String com_id,
			String table);
	/**
	 * 同步微信服务号模板到数据表中
	 * @param jsons
	 * @return
	 */
	String tongbuWeixinTemplate(JSONArray jsons);
	/**
	 * 从数据表中获取微信服务号消息模板
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getWexinMsgTemplate(Map<String, Object> map);
	/**
	 * 保存员工基本信息
	 * @param map
	 * @return
	 */
	String saveUserInfo(Map<String, Object> map);
	/**
	 * 更新数据库-读取sql文件第数据库进行升级
	 * @param file
	 * @return
	 */
	String updateSql(File file);
	/**
	 * 向客户批量发送营销短信
	 * @param map 
	 * @return
	 */
	String sendsms(Map<String, Object> map)throws Exception;
	/**
	 * 获取短信剩余条数
	 * @param map
	 * @return
	 */
	String getBalance(Map<String, Object> map);
	/**
	 * 获取短信发送状态
	 * @param request
	 * @return 每次最多返回200个号码的状态
	 */
	String getReport(Map<String, Object> map);
	/**
	 * 更新微信状态,获取用户数据后获取微信企业号中的状态.
	 * @param request
	 * @return
	 */
	String updateWeixinState(Map<String, Object> map);
	void updateClientType();
}
