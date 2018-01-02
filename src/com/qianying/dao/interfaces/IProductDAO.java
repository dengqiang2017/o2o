package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.ibatis.annotations.Param;

import com.qianying.dao.base.BaseDao;
import com.qianying.page.ProductQuery;

public interface IProductDAO extends BaseDao {

	String getMaxItem_id();

	void delpro(String item_id);
	/**
	 * 分页查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> findQuery(Map<String, Object> map);

	Integer connDB()throws Exception;

	Map<String, Object> getByItemId(@Param("item_id")String itemId, @Param("com_id")String com_id);
	
	/**
	 * 获取产品类别列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductClass(Map<String, Object> map);
	/**
	 * 获取产品类型信息
	 * @param sort_id
	 * @return
	 */
	Map<String, Object> getProductClassBySordId(Map<String,Object> map);

	String getMaxProductClass_id();
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductClassPage(Map<String, Object> map);

	int getCustomerAddProductCount(Map<String, Object> map);

	List<Map<String, Object>> getCustomerAddProduct(Map<String, Object> map);
	/**
	 * 获取增加品种信息
	 * @param customer_id 客户id
	 * @param com_id 
	 * @return
	 */
	Map<String, Object> getAddProInfo(JSONObject json);
	/**
	 * 查询增加品种明细信息
	 * @param mapParam
	 * @return
	 */
	Map<String, Object> getAddProDetailInfo(Map<String, Object> mapParam);
	/**
	 * 获取相同产品,客户下有没有还没有审核的的订单,
	 * @param orderParam 获取
	 * @return
	 */
	Map<String, Object> getOrderComfirm_flag(Map<String, Object> orderParam);
	/**
	 * 客户已经添加的总数
	 * @param map
	 * @return
	 */
	Integer getClientAddedCount(Map<String, Object> map);
	/**
	 * 客户已经添加产品的列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getClientAdded(Map<String, Object> map);
	List<Map<String,Object>> getquotationSheet(ProductQuery query);
	/**
	 * 获取客户已下订单的总数
	 * @param query
	 * @return
	 */
	Integer getClientOrderedCount(ProductQuery query);
	/**
	 * 获取客户已下订单数据
	 * @param query
	 * @return
	 */
	List<Map<String, Object>> getClientOrdered(ProductQuery query);

	int getPlanListCount(Map<String, Object> map);

	List<Map<String, Object>> getPlanList(Map<String, Object> map);
	/**
	 * 删除计划从表
	 * @param map
	 */
	void delPlan(Map<String, Object> map);

	Integer getPlanDetailCount(Map<String, Object> param);

	void delPlanMain(Map<String, Object> param);
	/**
	 * 删除增加品种从表
	 * @param map
	 */
	void delAddPro(Map<String, Object> map);
	/**
	 * 获取增加品种从表总数
	 * @param param
	 * @return
	 */
	Integer getAddDetailCount(Map<String, Object> param);
	/**
	 * 删除增加的品种主表
	 * @param param
	 */
	void delAddProMain(Map<String, Object> param);

	Integer countAdd(Map<String, Object> map);

	List<Map<String, Object>> findAddQuery(Map<String, Object> map);

	Integer getPlanOrderCount(Map<String, Object> map);

	List<Map<String, Object>> getPlanOrderPage(Map<String, Object> map);

	Map<String, Object> getProductByItem_id(Map<String,String> item_id);
	/**
	 * 获取一个数据
	 * @param no
	 * @return
	 */
	Map<String, Object> getRecordByNo(Map<String, String> no);

	Map<String, Object> getPlanProInfo(String customer_id);

	Map<String, Object> getPlanProDetailInfo(Map<String, Object> mapParam);
	/**
	 * 周计划-需导入Oracle总数
	 * @param map
	 * @return
	 */
	Map<String, Object> weeklyPlanAllProductCount(Map<String, Object> map);
	/**
	 * 周计划-需导入Oracle分页列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> weeklyPlanAllProduct(Map<String, Object> map);
	/**
	 * 获取指定日期导出excel
	 * @param mapparam
	 * @return
	 */
	String getPlanOutExcelTime(Map<String, Object> mapparam);
	/**
	 * 根据客户名称和产品id获取计划信息
	 * @param mapinfo
	 * @return
	 */
	Map<String, Object> getPlanInfoByCustomerPro(Map<String, Object> mapinfo);

	List<Map<String, Object>> dayPlanAllProduct(Map<String, Object> map);
	/**
	 * 以预处理方式执行插入或者更新语句
	 * @param map 存放sql和参数
	 * @param sSql 生成的插入或者更新sql 
	 */
	void insertSqlByPre(Map<String, Object> map);
	/**
	 * 更新订单主表的总金额
	 * @param mapsdd  
	 * @return 更新到主表的金额
	 */
	String updatesdd02020Sum_si(Map<String, Object> mapsdd);
	/**
	 * 根据订单编号获取订单信息用于发送短信
	 * @param mapsdd
	 * @return 短信相关需要的信息
	 */
	List<Map<String, Object>> getOrderSmsMsg(Map<String, Object> mapsdd);

	List<Map<String, Object>> planDayDetail(Map<String, Object> map);

	/**
	 * 获取发送短信列表 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getSensSmsList(Map<String, Object> map);

	Object getExcelOrderInfo(Map<String, Object> mapitemquery);
	/**
	 * 计划统计报表--日计划分产品
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> dayProduct(Map<String, Object> map);
	/**
	 * 计划统计报表--周计划分产品
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> weekProduct(Map<String, Object> map);
	/**
	 * 月计划查询
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> monthlyPlan(Map<String, Object> map);
	/**
	 * 查询客户报价单从表记录是否重复
	 * @param map
	 * @return object
	 */
	Object getExcelQuotationSheetInfo(Map<String, Object> mapitemquery);

	Map<String, Object> getProcessInfoByName(Map<String, Object> mapone);

	List<Map<String, Object>> getOrderInfoByNo(@Param("ivt_oper_listing")String no, @Param("com_id")String comId);
	/**
	 * 查询库存调拨中是否重复
	 * @param mapitemquery
	 * @return
	 */
	Object getExcelInventoryAllocationInfo(Map<String, Object> mapitemquery);
	/**
	 * 获取产品名称列表
	 * @param map
	 * @return
	 */
	List<String> getProductName(Map<String, Object> map);

	Integer getOneProductFiledCount(Map<String, Object> map);

	List<Map<String, Object>> getOneProductFiledList(Map<String, Object> map);

	List<Map<String, Object>> getProductList(Map<String, Object> map);

	Map<String, Object> getByItemMap(Map<String, Object> map);
	/**
	 * 获取购物车商品列表
	 * @param map
	 * @return
	 */
	Integer getShoppingCount(Map<String, Object> map);
	/**
	 * 获取购物车商品列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getShoppingList(Map<String, Object> map);

	void updateOrder(Map<String, Object> map);

	void postShopping(Map<String, Object> map);
	/**
	 * 获取已经添加到购物车的产品信息
	 * @param mapDetail
	 * @return
	 */
	Map<String, Object> getProductAdded(Map<String, Object> mapDetail);
	/**
	 * 更新已经添加到购物车产品的数量
	 * @param mapDetail
	 */
	void updateAddProduct(Map<String, Object> mapDetail);
	/**
	 * 获取订单信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getOrderInfo(Map<String, Object> map);
	/**
	 * 获取订单信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getOrderInfoList(Map<String, Object> map);
	/**
	 *  获取指定订单编号和产品内码的订单产品列表
	 * @param orderlist
	 * @param orderNo 
	 * @param item_id
	 * @param com_id
	 * @return 订单产品列表
	 */
	List<Map<String, Object>> getOrderProductList(Map<String, Object> map);
	/**
	 * 更新采购从表
	 */
	void updateCgcb(Map<String, Object> map);
	/**
	 * 更新已入库产品从表
	 */
	void updateRkcbByNo(Map<String, Object> map);
	void updateCgcbByNo(Map<String, Object> map);
	void updateRkzb(Map<String, Object> map);
	/**
	 * 获取基础产品详情
	 * @param map
	 * @return
	 */
	Map<String, Object> getProductBasicDetailByItemId(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Map<String, Object> getProductOrderDetailByItemId(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Map<String, Object> getProductPlanDetailByItemId(Map<String, Object> map);
	/**
	 * 获取指定客户和时间下客户计划信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getAddedPlanInfo(Map<String, Object> map);
	/**
	 * 获取当前运营商仓库商品列表
	 * @param map
	 * @return
	 */
	Integer getStoreProductCount(Map<String, Object> map);
	/**
	 * 获取当前运营商仓库商品列表
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getStoreProductList(Map<String, Object> map);
	/**
	 * 获取产品浏览历史总数
	 * @param map
	 * @return
	 */
	Integer getProductViewCount(Map<String, Object> map);
	/**
	 * 获取产品浏览历史分页
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductViewPage(Map<String, Object> map);
	/**
	 * 获取产品浏览历史
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductViewList(Map<String, Object> map);
	/**
	 * 获取address地址为空的产品浏览记录
	 * @return seeds_id和IP地址
	 */
	List<Map<String, Object>> getProductViewByAddressNull();
	/**
	 * 更新地址
	 * @param map2
	 * @return
	 */
	Integer updateProductView(Map<String, Object> map2);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductByName(Map<String, Object> map);
	/**
	 * 获取指定产品指定时间段内的销量
	 * @param map
	 * @return
	 */
	Integer getProductSalesVolume(Map<String, Object> map);
	/**
	 * 获取产品名称根据类型名称
	 * @param map
	 * @return 前rows条数据
	 */
	List<Map<String, Object>> getProductByTypeName(Map<String, Object> map);
	/**
	 * 获取产品名称根据类型名称
	 * @param map
	 * @return 分页汇总数
	 */
	Integer getProductPageByTypeNameCount(Map<String, Object> map);
	/**
	 * 获取产品名称根据类型名称
	 * @param map
	 * @return 分页数据
	 */
	List<Map<String, Object>> getProductPageByTypeName(Map<String, Object> map);
	/**
	 * 家装案例详情+设计师信息
	 * @param request
	 * @return 案例详情与设计师详情
	 */
	Map<String, Object> getSpruceInfo(Map<String, Object> map);
	/**
	 *  获取产品参数根据指定字段
	 * @param request
	 * @return
	 */
	List<Map<String, Object>> getProductParam(Map<String, Object> map);
	/**
	 * 获取产品列表根据多级类型名称
	 * @param request
	 * @return 库存数
	 */
	Map<String, Object> getProductAccnIvt(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	Integer getZEROMOrderProductCount(Map<String, Object> map);
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getZEROMOrderProduct(Map<String, Object> map);
	/**
	 * 获取产品信息包含库存总数
	 * @param map
	 * @return
	 */
	Integer getProductWareCount(Map<String, Object> map);
	/**
	 * 获取产品信息包含库存
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getProductWareList(Map<String, Object> map);
	/**
	 * 更新产品所属供应商
	 * @param itemMap
	 * @return
	 */
	Integer updateProductGys(JSONObject json);
	/**
	 * 计划修改保存
	 * @param map
	 * @return
	 */
	Integer savePlanEidt(Map<String, Object> map);
	/**
	 * 获取计划产品信息
	 * @param map
	 * @return
	 */
	Map<String, Object> getPlanProInfo(JSONObject json);

	Integer updatePlanNumByOrder(JSONObject json);
	/**
	 * 下订单时更新报价单中的单价为最新的单价.
	 * @param mapDetail
	 * @return
	 */
	Integer updateAddedPrice(Map<String, Object> mapDetail);

}
