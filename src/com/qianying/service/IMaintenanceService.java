package com.qianying.service;

import java.util.List;
import java.util.Map;

import com.qianying.page.ProductQuery;

public interface IMaintenanceService {
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer employeeImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> employeeExport(Map<String, Object> map);

	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer departmentImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> departmentExport(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer settlementImport(Map<String, List<Map<String, Object>>> readExcel);
	
	List<Map<String, Object>> settlementExport(Map<String, Object> map);

	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer regionalismImport(Map<String, List<Map<String, Object>>> readExcel);
	
	List<Map<String, Object>> regionalismExport(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer clientImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> clientExport(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer warehouseImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> warehouseExport(Map<String, Object> map);

	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer prodImport(Map<String, List<Map<String, Object>>> readExcel);
	
	List<Map<String, Object>> prodExport(Map<String, Object> map);

	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer prodClassImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> prodClassExport(Map<String, Object> map);

	String wareImport(Map<String, List<Map<String, Object>>> readExcel);
	/**
	 * 库存调拨单导入
	 * @param excelData
	 * @return
	 */
	String inventoryAllocation(Map<String, List<Map<String, Object>>> excelData);

	/**
	 * 
	 * @param excelData
	 * @return
	 */
	String wareinit(Map<String, List<Map<String, Object>>> excelData);
	
	String vendorinit(Map<String, List<Map<String, Object>>> excelData);

	List<Map<String, Object>> vendorExport(Map<String, Object> map);

	String operateInit(Map<String, List<Map<String, Object>>> excelData);

	List<Map<String, Object>> operateExport(Map<String, Object> map);

	String driverAndDianInit(Map<String, List<Map<String, Object>>> excelData, String type);

	List<Map<String, Object>> driverAndDianExport(Map<String, Object> map);
	/**
	 * 期初应收导入
	 * @param excelData
	 * @return
	 */
	String receivableImport(Map<String, List<Map<String, Object>>> excelData);

	StringBuffer wareinitImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> getWareinitAll(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer meteringUnitImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> getMeteringUnitAll(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer payableImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> getPayableAll(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer producareaImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> getProducareaAll(Map<String, Object> map);
	
	/**
	 * 
	 * @param readExcel
	 */
	StringBuffer accountingSubjectsImport(Map<String, List<Map<String, Object>>> readExcel);

	List<Map<String, Object>> getAccountingSubjectsAll(Map<String, Object> map);

	List<Map<String, Object>> tijianExport(Map<String, Object> map);

	String tijianInit(Map<String, List<Map<String, Object>>> excelData);
	
	/**
	 * @param readExcel
	 */
	StringBuffer quotationSheetImport(Map<String, List<Map<String, Object>>> readExcel);
	List<Map<String, Object>> quotationSheetExport(ProductQuery query);
	StringBuffer productionPlanSheetImport(Map<String, List<Map<String, Object>>> readExcel);
	StringBuffer materialproductionPlanSheetImport(Map<String, List<Map<String, Object>>> readExcel);
	/**
	 * 导出产品生产计划
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> exportProductionPlan(Map<String, Object> map);
	/**
	 * 导入导出采购验收入库单
	 */
	StringBuffer purchasingSheetImport(Map<String, List<Map<String, Object>>> readExcel);
	List<Map<String, Object>> purchasingSheetExport(Map<String, Object> map);
	/**
	 * 期初应收导出
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> initialReceivableExcel(Map<String, Object> map);
}
