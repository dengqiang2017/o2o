package com.qianying.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.qianying.page.PageList;
import com.qianying.page.ProductClassQuery;
import com.qianying.page.ProductQuery;

public interface IProductService extends IBaseService{

	public String getMaxItem_id();

	public void delpro(String item_id);
	PageList<Map<String, Object>> findQuery(Map<String, Object> map);

	public void connDB();
	/**
	 * 
	 * 根据item_id获取产品信息
	 * @param itemId
	 * @return 
	 */
	public Map<String, Object> getByItemId(String itemId);
	/**
	 * 获取产品类别列表
	 * @param request 
	 * @param sort_id 产品类别id
	 * @return
	 */
	public List<Map<String, Object>> getProductClass(HttpServletRequest request);
	/**
	 * 获取产品类型信息
	 * @param map 产品类别id
	 * @return
	 */
	public Map<String, Object> getProductClassBySordId(Map<String, Object> map);
	/**
	 * 获取最大的产品类别表id
	 * @return
	 */
	public String getMaxProductClass_id();
	/**
	 * 保存或者更新类别
	 * @param map 数据
	 * @param type 1=保存,0=更新
	 */
	public void saveClass(Map<String, Object> map, int type);
	/**
	 * 查询产品类别分页
	 * @param query
	 * @return
	 */
	public PageList<Map<String, Object>> getProductClassPage(
			ProductClassQuery query);

	/**
	 * 获取客户添加的产品
	 * @param map 
	 * @return
	 */
	PageList<Map<String, Object>> getCustomerAddProduct(Map<String,Object> map);
	/**
	 * 下订单
	 * @param map
	 * @return 返回结果,成功返回null,错误返回错误信息
	 */
	public String addOrder(Map<String, Object> map)throws Exception;
	/**
	 * 获取客户已经添加的品种
	 * @param map
	 * @param customer_id 
	 * @return 分页数据
	 */
	public PageList<Map<String, Object>> getClientAdded(Map<String, Object> map);
	/**
	 * 获取客户已经下订单的数据
	 * @param query
	 * @return
	 */
	public PageList<Map<String, Object>> getClientOrdered(ProductQuery query);
	/**
	 * 增加计划
	 * @param map
	 */
	public void addPlan(Map<String, Object> map);
	
	/**
	 * 获取计划列表
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> getPlanList(Map<String, Object> map);
	/**
	 * 删除计划
	 * @param map
	 */
	public void delPlan(Map<String, Object> map);
	/**
	 * 获取计划单号在从表中是否还有
	 * @param param
	 * @return
	 */
	public Integer getPlanDetailCount(Map<String, Object> param);
	/**
	 * 删除主表数据
	 * @param param
	 */
	public void delPlanMain(Map<String, Object> param);
	/**
	 * 删除增加品种
	 * @param map
	 */
	public void delAddPro(Map<String, Object> map);
	/**
	 * 获取增加品种从表对应的单号总数
	 * @param param
	 * @return
	 */
	public Integer getAddDetailCount(Map<String, Object> param);
	/**
	 * 删除增加品种主表数据
	 * @param param
	 */
	public void delAddProMain(Map<String, Object> param);

	public PageList<Map<String, Object>> findAddQuery(Map<String, Object> map);

	public PageList<Map<String, Object>> getPlanOrder(ProductQuery query);
	/**
	 * 周计划-需导入Oracle
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> weeklyPlanAllProduct(
			Map<String, Object> map);
	/**
	 * 获取计划报表中的总计
	 * @param planReportParams
	 * @return
	 */
	public Map<String, Object> weeklyPlanAllProductCount(
			Map<String, Object> map);
	/**
	 * 周计划-需导入Oracle 生成并导出excel
	 * @param map
	 * @return
	 */
	public Map<String, Object> weeklyPlanAllProductExcel(Map<String, Object> map);
	/**
	 * 查询一个字段值为一个的动态查询
	 * @param mapquery
	 * @param table 表名
	 * @param showFiledName 显示字段名称
	 * @param findFiled 查询字段名称加查询值
	 * @param com_id 
	 * @return 
	 */
	public Object getOneFiledNameByID(Map<String, Object> mapquery);
	/**
	 * 保存Excel导入数据
	 * @param request 用于将进度数据放入session中进行界面显示
	 * @param list 从表数据
	 * @param mainlist 主表数据
	 */
	public void saveExcelImportData(Map<String,List<Map<String,Object>>> map, HttpServletRequest request);
	/**
	 * 查询明细记录
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> planDayDetail(Map<String, Object> map);
	/**
	 * 发送订单导入发货短信
	 * @param map
	 * @param request 
	 * @return 
	 */
	public String sendSms(Map<String, Object> map, HttpServletRequest request);
	/**
	 * 保存收款单Excel导入数据
	 * @param readExcelPoi 
	 * @param request 用于将进度数据放入session中进行界面显示
	 * @param mainlist 主表数据
	 */
	public void saveArdExcelImportData(
			Map<String, List<Map<String, Object>>> readExcelPoi,
			HttpServletRequest request);
	/**
	 * 期初应收Excel数据保存
	 * @param readExcelPoi
	 * @param request
	 */
	public void saveArfExcelImportData(
			Map<String, List<Map<String, Object>>> readExcelPoi,
			HttpServletRequest request);
	/**
	 * 日计划分客户
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> dayProduct(Map<String, Object> map);
	/**
	 * 周计划分产品
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> weekProduct(Map<String, Object> map);
	/**
	 * 月计划分产品,客户查询
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> monthlyPlan(Map<String, Object> map);
	/**
	 * 月计划导出数据准备
	 * @param map
	 * @return
	 */
	public Map<String, Object> monthlyPlanExcel(Map<String, Object> map);
	/**
	 * 周计划分产品导出Excel
	 * @param map
	 * @return
	 */
	public Map<String, Object> weekProductExcel(Map<String, Object> map);
	/**
	 * 日计划分产品胡Excel
	 * @param map
	 * @return
	 */
	public Map<String, Object> dayProductExcel(Map<String, Object> map);

	public StringBuffer delOrderPro(String[] itemIds, String com_id);

	/**
	 * 期初应收Excel数据保存
	 * @param readExcelPoi
	 * @param request
	 */
	public void saveQuotationSheetExcelImportData(
			Map<String, List<Map<String, Object>>> readExcelPoi,
			HttpServletRequest request);

	public List<String> getProductName(Map<String, Object> map);

	public PageList<Map<String, Object>> getOneProductFiledList(
			Map<String, Object> map);
	/**
	 * 获取产品列表
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getProductList(Map<String, Object> map);

	public Map<String,Object> getByItemId(Map<String, Object> map);

	public PageList<Map<String, Object>> getShopping(Map<String, Object> map);

	public String delShopping(Map<String, Object> map);

	public void postShopping(Map<String, Object> map);

	public void updateOrder(Map<String, Object> map);
	/**
	 * 获取订单信息
	 * @param orderInfo 
	 * @return 
	 */
	public Map<String, Object> getOrderInfo(String orderInfo);
	/**
	 *  获取指定订单编号和产品内码的订单产品列表
	 * @param orderlist
	 * @param orderNo 
	 * @param item_id
	 * @param com_id
	 * @return 订单产品列表
	 */
	public List<Map<String, Object>> getOrderProductList(Map<String, Object> map);
	/**
	 * 获取基础产品详情
	 * @param map
	 * @return
	 */
	public Map<String,Object> getProductBasicDetailByItemId(Map<String, Object> map);
	
	public Map<String,Object> getProductOrderDetailByItemId(Map<String, Object> map);

	public Map<String,Object> getProductPlanDetailByItemId(Map<String, Object> map);
	/**
	 * 保存计划
	 * @param map
	 * @return
	 */
	public String savePlan(Map<String, Object> map);
	/**
	 * 获取仓库产品列表
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> getStoreProductList(Map<String, Object> map);
	/**
	 * 增加订单根据零售客户报价单
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public String addOrderByZEROM(Map<String, Object> map) throws Exception;
	/**
	 * 保存产品的浏览历史记录
	 * @param map
	 * @return
	 */
	public String saveProductView(Map<String, Object> map) throws Exception;
	/**
	 * 获取产品浏览历史记录
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getProductViewList(
			Map<String, Object> map);
	/**
	 * 获取产品浏览历史分页记录
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> getProductViewPage(
			Map<String, Object> map);
	/**
	 *  获取同一个产品名称下不同规格,颜色的产品
	 * @param request
	 * @return
	 */
	public List<Map<String, Object>> getProductByName(Map<String, Object> map);
	/**
	 * 获取产品根据类型名称
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getProductByTypeName(
			Map<String, Object> map);
	/**
	 * 获取产品列表分页根据多级类型名称
	 * @param request
	 * @return 分页数据
	 */
	public PageList<Map<String, Object>> getProductPageByTypeName(
			Map<String, Object> map);
	/**
	 * 家装案例详情+设计师信息
	 * @param request
	 * @return 案例详情与设计师详情
	 */
	public Map<String, Object> getSpruceInfo(Map<String, Object> map);
	/**
	 *  获取产品参数根据指定字段
	 * @param request
	 * @return
	 */
	public List<Map<String, Object>> getProductParam(Map<String, Object> map);
	/**
	 * 获取指定产品颜色的库存
	 * @param map
	 * @return
	 */
	public Map<String, Object> getProductAccnIvt(Map<String, Object> map);
	/**
	 * 获取零售客户报价单
	 * @param map
	 * @return
	 */
	public PageList<Map<String, Object>> getZEROMOrderProduct(
			Map<String, Object> map);
	/**
	 * 获取产品信息包含库存
	 * @param request
	 * @param type 生产或者采购
	 * @return 产品信息和库存数量,采购时返回供应商信息
	 */
	public PageList<Map<String, Object>> getProductWarePage(
			Map<String, Object> map);
	/**
	 * 审核和弃审报价单
	 * @param request
	 * @return
	 */
	public String confirmAddPro(Map<String, Object> map);
	/**
	 * 计划修改保存
	 * @param map
	 * @return
	 */
	public String savePlanEidt(Map<String, Object> map);
	/**
	 * 更新产品主图和封面图到数据库中
	 * @param basePath
	 * @return
	 */
	public String updateProFile(String basePath);
	/**
	 * 保存订单信息
	 * @param map
	 * @return
	 */
	public String saveOrder(Map<String, Object> map)throws Exception;
}
