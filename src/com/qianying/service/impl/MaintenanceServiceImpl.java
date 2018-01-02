package com.qianying.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IProductDAO;
import com.qianying.dao.interfaces.IProductionManagementDAO;
import com.qianying.dao.interfaces.ISystemParamsDAO;
import com.qianying.page.ProductQuery;
import com.qianying.service.IMaintenanceService;
import com.qianying.service.IManagerService;

@Service
@Transactional
public class MaintenanceServiceImpl extends BaseServiceImpl implements
		IMaintenanceService {
	@Autowired
	private IProductDAO productDao;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private IProductionManagementDAO productionManagementDao;
	@Autowired
	private ISystemParamsDAO systemParamsDao;

	@Override
	public StringBuffer employeeImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ctl00801";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			if(isMapKeyNull(map, "clerk_name")&&isMapKeyNull(map, "movtel")){
				continue;
			}
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", "ctl00801");
			mapquery.put("showFiledName", "clerk_name");
			mapquery.put("findFiled", "ltrim(rtrim(isnull(clerk_id,''))) =#{clerk_id}");
			mapquery.put("com_id", getComId());
			mapquery.put("clerk_id", map.get("clerk_id"));
			if (isNotMapKeyNull(map, "describe")) {
				saveFile(getPlanquery(getRequest(), map.get("clerk_id"), "describe.txt"), map.get("describe").toString());
				map.remove("describe");
			}
			Object obj = productDao.getOneFiledNameByID(mapquery);
			if (obj == null) {
				if (isMapKeyNull(map, "clerk_id")) {
					Integer  seedsId=managerService.getMaxSeeds_id(table, "seed_id");
					String clerk_id = String.format("E%06d", seedsId+1);
					map.put("clerk_id", clerk_id);
				}
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "clerk_id",
						map.get("clerk_id") + "", true));
				// buffer.append("员工编码[" + map.get("clerk_id") + "]");
			}
			if(isMapKeyNull(map, "user_id")&&isMapKeyNull(map, "movtel")){
			}else{
				map.put("name", map.get("clerk_name"));
				Object agentDeptId=systemParamsDao.checkSystem("agentDeptId",getComId());
				postInfoToweixin(map, "员工",agentDeptId);
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> employeeExport(Map<String, Object> map) {
		map.put("name", map.get("searchKey"));
		List<Map<String,Object>> list= managerDao.getDeptEmployee(map);
		if (list!=null&&list.size()>0) {
			for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
				Map<String, Object> map2 = iterator.next();
				getFileTextContent(getPlanquery(getRequest(), map2.get("clerk_id"), "describe.txt"));
			}
		}
		return list;
	}
	
/**
 * 当名称和简称有一个不为空的时候自动补全另一个为空的	
 * @param map
 * @param key 名称
 * @param key2 简称
 */
private void buquanname(Map<String,Object> map,String key,String key2) {
	if (isNotMapKeyNull(map, key)) {
		if (isMapKeyNull(map, key2)) {
			map.put(key2, map.get(key));
		}
	}
	if (isNotMapKeyNull(map, key2)) {
		if (isMapKeyNull(map, key)) {
			map.put(key, map.get(key2));
		}
	}
}
	@Override
	public StringBuffer departmentImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ctl00701";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			if(isMapKeyNull(map, "dept_sim_name")&&isMapKeyNull(map, "dept_name")){
				continue;
			}
			buquanname(map, "dept_name", "dept_sim_name");
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			Object obj =null;
			if (isNotMapKeyNull(map, "sort_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", "ctl00701");
				mapquery.put("showFiledName", "dept_name");
				mapquery.put("findFiled", " (ltrim(rtrim(isnull(dept_id,''))) =#{dept_id} or ltrim(rtrim(isnull(sort_id,''))) =#{sort_id})");
				mapquery.put("com_id", getComId());
				mapquery.put("sort_id", map.get("sort_id"));
				mapquery.put("dept_id", map.get("dept_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				String sort_id = getSortId(table,"DE",managerService);
				map.put("sort_id", sort_id);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "sort_id",
						map.get("sort_id") + "", true));
				// buffer.append("部门编码[" + map.get("dept_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> departmentExport(Map<String, Object> map) {
		return managerDao.getDeptAll((String) map.get("com_id"));
	}

	@Override
	public StringBuffer settlementImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ctl02107";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			if(isMapKeyNull(map, "settlement_sim_name")){
				continue;
			}
			// map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			Object obj =null;
			if (isNotMapKeyNull(map, "sort_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", "ctl02107");
				mapquery.put("showFiledName", "settlement_sim_name");
				mapquery.put("findFiled", "ltrim(rtrim(isnull(sort_id,''))) =#{sort_id}");
				mapquery.put("com_id", getComId());
				mapquery.put("sort_id", map.get("sort_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				Integer  seedsId=managerService.getMaxSeeds_id(table, "seeds_id");
				String sort_id=String.format("JS%03d", seedsId+1);
				map.put("sort_id", sort_id);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "sort_id",
						map.get("sort_id") + "", true));
				// buffer.append("结算方式内码[" + map.get("sort_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> settlementExport(Map<String, Object> map) {
		return managerDao.getSettlementAll((String) map.get("com_id"));
	}

	@Override
	public StringBuffer regionalismImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "Ctl01001";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			if(isMapKeyNull(map, "regionalism_name_cn")){
				continue;
			}
			// 去除表中不存在的字段
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			Object obj =null;
			if (isNotMapKeyNull(map, "sort_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", "Ctl01001");
				mapquery.put("showFiledName", "regionalism_name_cn");
				mapquery.put("findFiled", "ltrim(rtrim(isnull(sort_id,''))) =#{sort_id}");
				mapquery.put("com_id", getComId());
				mapquery.put("sort_id", map.get("sort_id"));
				 obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				String sort_id= getSortId(table, "R",managerService); 
				map.put("sort_id", sort_id);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "sort_id",
						map.get("sort_id") + "", true));
				// buffer.append("行政区划内码[" + map.get("sort_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> regionalismExport(Map<String, Object> map) {
		return managerDao.getRegionalismAll((String) map.get("com_id"));
	}

	@Override
	public StringBuffer clientImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "sdf00504";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 计算名称是否存在
			if(isMapKeyNull(map, "corp_name")&&isMapKeyNull(map, "corp_sim_name")){
				continue;
			}
			buquanname(map, "corp_name", "corp_sim_name");
			Object obj =null;
			if (isNotMapKeyNull(map, "customer_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", table);
				mapquery.put("showFiledName", "corp_name");
				mapquery.put("findFiled", "ltrim(rtrim(isnull(customer_id,''))) =#{customer_id}");
				mapquery.put("com_id", getComId());
				mapquery.put("customer_id", map.get("customer_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				String customer_id = getSortId(table,"C",managerService);
				customer_id=map.get("upper_customer_id")+customer_id;
				map.put("customer_id", customer_id);
				if(isMapKeyNull(map, "self_id")){
					map.put("self_id", customer_id);
				}
			}
			if (map.get("customer_id").toString().contains("null")) {
				continue;
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
//				productDao.insertSql(getInsertSql(table, map));
			} else {
				productDao.insertSql(getUpdateSql(map, table, "customer_id",
						map.get("customer_id") + "", true));
				// buffer.append("客户编码[" + map.get("customer_id") + "]");
			}
			if(isMapKeyNull(map, "user_id")&&isMapKeyNull(map, "movtel")){
			}else{
				map.put("name", map.get("corp_name"));
				Object agentDeptId=systemParamsDao.checkSystem("agentDeptId",getComId());
				postInfoToweixin(map, "客户",agentDeptId);
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> clientExport(Map<String, Object> map) {
		return managerDao.getClientAll(map.get("com_id").toString());
	}

	@Override
	public StringBuffer warehouseImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ivt01001";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			// map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", table);
			mapquery.put("showFiledName", "store_struct_name");
			mapquery.put("findFiled", "ltrim(rtrim(isnull(sort_id,''))) = #{sort_id}");
			mapquery.put("com_id", getComId());
			mapquery.put("sort_id", map.get("sort_id"));
			Object obj = productDao.getOneFiledNameByID(mapquery);
			if (obj == null) {
				String sort_id=getSortId(table, "WH",managerService);
				map.put("sort_id", sort_id);
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "sort_id",
						map.get("sort_id") + "", true));
				// buffer.append("库房内码[" + map.get("sort_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> warehouseExport(Map<String, Object> map) {
		return managerDao.getWarehouseAll((String) map.get("com_id"));
	}

	@Override
	public StringBuffer prodImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ctl03001";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			// map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			if (isMapKeyNull(map, "item_name")&&isMapKeyNull(map, "item_sim_name")) {
				if (isNotMapKeyNull(map, "peijian_id")&&isNotMapKeyNull(map, "serve_id")&&isNotMapKeyNull(map, "item_cost")) {
					Map<String,Object> param=new HashMap<>();
					param.put("com_id", getComId());
					param.put("peijian_id", map.get("peijian_id"));
					param.put("vendor_id", map.get("serve_id"));
					param.put("item_cost", map.get("item_cost"));
					param.put("sSql", "update ctl03001 set vendor_id=#{vendor_id},item_cost=#{item_cost} where ltrim(rtrim(isnull(com_id,'')))=#{com_id} and ltrim(rtrim(isnull(peijian_id,'')))=#{peijian_id};");
					productDao.insertSqlByPre(param);
				}
				continue;
			}
			buquanname(map, "item_name", "item_sim_name");
			Object obj =null;
			if (isNotMapKeyNull(map, "item_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", table);
				mapquery.put("showFiledName", "item_name");
				mapquery.put("findFiled", "ltrim(rtrim(isnull(item_id,''))) =#{item_id}");
				mapquery.put("com_id", getComId());
				mapquery.put("item_id", map.get("item_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				String item_id=productDao.getMaxItem_id();
				if(StringUtils.isBlank(item_id)){
					item_id="0";
				}
				item_id=String.format("CP%06d", Integer.parseInt(item_id)+1);
				map.put("item_id", item_id);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "item_id",
						map.get("item_id") + "", true));
				// buffer.append("产品内码[" + map.get("item_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> prodExport(Map<String, Object> map) {
		return managerDao.getProdAll(map);
	}

	@Override
	public StringBuffer prodClassImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ctl03200";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			// map.remove("mainten_clerk_id");
			if(isMapKeyNull(map, "sort_name")){
				continue;
			}
			map.remove("mainten_datetime");
			// 计算名称是否存在
			//计算“sort_id”和“self_id”是否存在，不存在就生成一个。
			map.put("maintenance_datetime", getNow());
			if (isMapKeyNull(map, "sort_name")) {
				continue;
			}
			Object obj =null;
			if (isNotMapKeyNull(map, "sort_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", "ctl03200");
				mapquery.put("showFiledName", "sort_name");
				mapquery.put("findFiled", "ltrim(rtrim(isnull(sort_id,''))) =#{sort_id}");
				mapquery.put("com_id", getComId());
				mapquery.put("sort_id", map.get("sort_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				Integer seedsId = managerService.getMaxSeeds_id(table,
						"seeds_id");
				String newsort_id = String.format("TY%03d", seedsId + 1);
				if (isNotMapKeyNull(map, "upper_sort_id")) {
					newsort_id=map.get("upper_sort_id")+newsort_id;
				}
				map.put("sort_id", newsort_id);
				if (isMapKeyNull(map, "self_id")) {
					map.put("self_id", newsort_id);
				}
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "sort_id",
						map.get("sort_id") + "", true));
				// buffer.append("产品类别编码[" + map.get("sort_id") + "]");
			}
		}

		return buffer;
	}

	@Override
	public List<Map<String, Object>> prodClassExport(Map<String, Object> map) {
		return managerDao.getProdClassAll((String) map.get("com_id"));
	}

	@Override
	public String wareImport(Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "IVTd01302";// /库存表
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			if (isMapKeyNull(map, "item_id")) {
				continue;
			}
			map.remove("mainten_datetime");
//			map.remove("use_oq");
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", table);
			mapquery.put("com_id", getComId());
			mapquery.put("showFiledName", "item_id");
			// ///////////////////////////////////////
			mapquery.put("findFiled","ltrim(rtrim(isnull(item_id,'')))=#{item_id}");
			mapquery.put("com_id", getComId());
			mapquery.put("item_id", map.get("item_id"));
			Object obj = productDao.getOneFiledNameByID(mapquery);
			// map.put("finacial_datetime", new Date().getTime());
			map.put("finacial_datetime", getNow());
			map.put("maintenance_datetime", getNow());
			if(map.get("store_struct_id")==null){
				map.put("store_struct_id", "");
			}
			// getFinacial(map, "finacial_datetime");
			if (obj == null) {
				if (map.get("item_id")!=null) {
//					if (map.get("store_struct_id") != null) {
//						String sort_id = getSortId3(table, "WH", managerService);
//						map.put("store_struct_id", sort_id);
//					}
					map.remove("peijian_id");
					String sSql = getInsertSqlByPre(table, map);
					map.put("sSql", sSql);
					productDao.insertSqlByPre(map);
				}else{
					if(!isMapKeyNull(map, "peijian_id")){
						buffer.append("产品[" + map.get("peijian_id")+ "]");
					}
					if(!isMapKeyNull(map, "item_id")){
						buffer.append("产品[" + map.get("item_id")+ "]");
					}
				}
			} else {
				map.remove("peijian_id");
				productDao.insertSql(getUpdateSql(map, table, "item_id",
						obj + "", true));
				// buffer.append("产品编码[" + map.get("item_id") + "]");
			}
		}
		return buffer.toString();
	}

	@Override
	public String receivableImport(
			Map<String, List<Map<String, Object>>> excelData) {
		List<Map<String, Object>> mainlist = excelData.get("mainlist");
		String table = "ARf02030";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			map.remove("use_oq");
			String sSql = getInsertSqlByPre(table, map);
			map.put("sSql", sSql);
			productDao.insertSqlByPre(map);
		}
		return buffer.toString();
	}

	@Override
	public String inventoryAllocation(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> list = maplist.get("list");
		List<Map<String, Object>> mainlist = maplist.get("mainlist");

		String maintable = "ivtd01201";
		String itemtable = "ivtd01202";
		String com_id = getComId();
		StringBuffer buffer = new StringBuffer();
		try {
			for (Map<String, Object> map : mainlist) {
				// 获取外部单号
				if (map.get("sd_order_id") != null) {
					String sd_order_id = map.get("sd_order_id").toString();
					// 查询数据库检查外部单号是否存在
					Map<String, Object> mapquery = new HashMap<String, Object>();
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "sd_order_id");
					mapquery.put("findFiled", "ltrim(rtrim(isnull(sd_order_id,'')))=#{sd_order_id}");
					mapquery.put("com_id", com_id);
					mapquery.put("sd_order_id",sd_order_id );
					// 判断l
					Object obj = productDao.getOneFiledNameByID(mapquery);
					if (obj == null) {
						// 不等于空说明已经存储过主表将不再存储
						String no = getOrderNo(customerDao, "库存调拨", com_id);
						map.put("ivt_oper_listing", no);
						map.put("ivt_oper_cfm", map.get("mainten_clerk_id"));
						map.put("ivt_oper_cfm_time", getNow());
						// 移除不存在的项,添加需要的项
						map.put("maintenance_datetime",
								map.get("mainten_datetime"));
						map.remove("mainten_datetime");

						String sSql = getInsertSqlByPre(maintable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
				}
			}

			for (Map<String, Object> map : list) {
				// 获取外部单号
				if (map.get("sd_order_id") != null) {
					String sd_order_id = map.get("sd_order_id").toString();
					Map<String, Object> mapquery = new HashMap<String, Object>();
					// 从主表中获取单号，根据订单外部单号
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "ivt_oper_listing");
					mapquery.put("findFiled", "ltrim(rtrim(isnull(sd_order_id,'')))=#{sd_order_id}");
					mapquery.put("com_id", com_id);
					mapquery.put("sd_order_id", sd_order_id);
					Object no = productDao.getOneFiledNameByID(mapquery);
					if (no != null) {
						map.put("ivt_oper_listing", no);
						map.remove("sd_order_id");

						if (map.get("item_id") == null) {
							buffer.append("excel行号:")
									.append(map.get("excelIndex"))
									.append(",产品编码为空");
						} else if (map.get("store_struct_id") == null) {
							buffer.append(",调出库房为空");
						} else if (map.get("corpstorestruct_id") == null) {
							buffer.append(",调入库房为空");
						} else if (map.get("oper_qty") == null) {
							buffer.append(",调拨数量为空");
						} else {
							// 根据订单号,产品编码判断库存调拨单从表是否重复
							Map<String, Object> mapitemquery = new HashMap<String, Object>();
							mapitemquery.put("com_id", com_id);
							mapitemquery.put("ivt_oper_listing",
									map.get("ivt_oper_listing"));
							mapitemquery.put("item_id", map.get("item_id"));
							Object obj = productDao
									.getExcelInventoryAllocationInfo(mapitemquery);

							if (obj == null) {
								String sSql = getInsertSqlByPre(itemtable, map);
								map.put("sSql", sSql);
								productDao.insertSqlByPre(map);
							} else {
								buffer.append("excel此行重复行号:")
										.append(map.get("excelIndex"))
										.append(",");
								buffer.append("单号:").append(sd_order_id)
										.append(",产品编码:")
										.append(map.get("item_id"));
								buffer.append("\n");
							}
						}
					} else {
						buffer.append("excel行号:").append(map.get("excelIndex"));
						buffer.append("没有在主表中找到对应单号:").append(sd_order_id)
								.append("\n");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return buffer.toString();
	}

	@Override
	public String wareinit(Map<String, List<Map<String, Object>>> maplist) {

		List<Map<String, Object>> mainlist = maplist.get("mainlist");

		String table = "IVTd01300";// 库存初始化
		StringBuffer buffer = new StringBuffer();

		for (Map<String, Object> map : mainlist) {
			map.remove("mainten_datetime");
			StringBuffer findFiled = new StringBuffer();
			findFiled.append("ltrim(rtrim(isnull(store_struct_id,'')))=#{store_struct_id} and ")
					.append("ltrim(rtrim(isnull(item_id,'')))=#{item_id}");
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", table);
			mapquery.put("showFiledName", "ivt_num_detail");
			mapquery.put("findFiled", findFiled);
			mapquery.put("com_id", getComId());
			Object obj = productDao.getOneFiledNameByID(mapquery);

			map.put("finacial_datetime", getNow());
			map.put("maintenance_datetime", getNow());

			if (obj == null) {
				String sort_id = getSortId(table, "TY", managerService);
				map.put("sort_id", sort_id);
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				buffer.append("库房编码[" + map.get("store_struct_id") + "] 产品编码["
						+ map.get("item_id") + "] 已存在    <br>");
			}
		}
		return buffer.toString();
	}

	@Override
	public String vendorinit(Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");

		String table = "Ctl00504";
		StringBuffer buffer = new StringBuffer();

		for (Map<String, Object> map : mainlist) {
			if(isMapKeyNull(map, "corp_name")&&isMapKeyNull(map, "corp_sim_name")){
				continue;
			}
			buquanname(map, "corp_name", "corp_sim_name");
			Object obj =null;
			if (isNotMapKeyNull(map, "corp_id")) {
				StringBuffer findFiled = new StringBuffer();
				findFiled.append("(ltrim(rtrim(isnull(corp_name,''))) =#{corp_name}").append(" or ltrim(rtrim(isnull(self_id,'')))= #{self_id})");
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", table);
				mapquery.put("showFiledName", "corp_id");
				mapquery.put("findFiled", findFiled);
				mapquery.put("com_id", getComId());
				mapquery.put("corp_name",map.get("corp_name"));
				mapquery.put("self_id",map.get("self_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				String corp_id = getSortId(table, "G", managerService);
				map.put("corp_id", corp_id);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "corp_id",
						obj.toString(), true));
				buffer.append("供应商编码[" + map.get("self_id") + "]已存在,并更新!<br>");
			}
			if(isMapKeyNull(map, "user_id")&&isMapKeyNull(map, "movtel")){
			}else{
				map.put("name", map.get("corp_name"));
				Object agentDeptId=systemParamsDao.checkSystem("agentDeptId",getComId());
				postInfoToweixin(map, "供应商",agentDeptId);
			}
		}
		return buffer.toString();
	}

	@Override
	public List<Map<String, Object>> vendorExport(Map<String, Object> map) {
		map.put("all", "all");
		return managerDao.getGysTree(map);
	}

	@Override
	public String operateInit(Map<String, List<Map<String, Object>>> excelData) {
		List<Map<String, Object>> mainlist = excelData.get("mainlist");
		String table = "Ctl00501";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			if(isMapKeyNull(map, "com_name")&&isMapKeyNull(map, "com_sim_name")){
				continue;
			}
			buquanname(map, "com_name", "com_sim_name");
			StringBuffer findFiled = new StringBuffer();
			findFiled.append("ltrim(rtrim(isnull(com_name,'')))=#{com_name}");
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", table);
			mapquery.put("showFiledName", "com_id");
			mapquery.put("findFiled", findFiled);
			mapquery.put("com_id", getComId());
			mapquery.put("com_name", map.get("com_name"));
			Object obj = productDao.getOneFiledNameByID(mapquery);
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			if (obj == null) {
				String corp_id = getSortId3(table, "", managerService);
				map.put("com_id", corp_id);
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "com_id",
						obj.toString(), true));
				buffer.append("运营商编码[" + map.get("com_name") + "]已存在,并更新!<br>");
			}
		}
		return buffer.toString();
	}

	@Override
	public List<Map<String, Object>> operateExport(Map<String, Object> map) {
		map.put("all", "all");
		return managerDao.getOperateTree(map);
	}

	@Override
	public String driverAndDianInit(
			Map<String, List<Map<String, Object>>> excelData,String type) {
		List<Map<String, Object>> mainlist = excelData.get("mainlist");
		String table = "Sdf00504_saiyu";
		StringBuffer buffer = new StringBuffer();
		if (StringUtils.isBlank(type)||"1".equals(type)||type.contains("D")) {
			type = "D";// 司机driver
		} else{
			type = "E";// 电工Electrician
		}
		for (Map<String, Object> map : mainlist) {
			if(isMapKeyNull(map, "corp_name")&&isMapKeyNull(map, "corp_sim_name")){
				continue;
			}
			if("D".equals(type)){
				map.put("isclient", "1");
			}else{
				map.put("isclient", "0");
			}
			buquanname(map, "corp_name", "corp_sim_name");
			Object obj =null;
			if (isNotMapKeyNull(map, "customer_id")) {
				StringBuffer findFiled = new StringBuffer();
				findFiled.append(" com_id='").append(getComId())
				.append("' and ( corp_name = '")
				.append(map.get("corp_name")).append("' or self_id='")
				.append(map.get("self_id")).append("') ");
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", table);
				mapquery.put("showFiledName", "customer_id");
				mapquery.put("findFiled", findFiled);
				obj = productDao.getOneFiledNameByID(mapquery);
			}else{
				String corp_id = getSortId(table, type, managerService);
				map.put("customer_id", corp_id);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table, "customer_id",
						obj.toString()));
				buffer.append("外编码[" + map.get("self_id") + "]已存在,并更新!<br>");
			}
			if(isMapKeyNull(map, "user_id")&&isMapKeyNull(map, "movtel")){
			}else{
				map.put("name", map.get("corp_name"));
				Object agentDeptId=systemParamsDao.checkSystem("agentDeptId",getComId());
				postInfoToweixin(map, "司机",agentDeptId);
			}
		}
		return buffer.toString();
	}

	@Override
	public List<Map<String, Object>> driverAndDianExport(Map<String, Object> map) {
		return managerDao.getDriverAndDian(map);
	}

	@Override
	public StringBuffer wareinitImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "IVTd01300";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			// map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			String sSql = getInsertSqlByPre(table, map);
			map.put("sSql", sSql);
			productDao.insertSqlByPre(map);
		}
		return buffer;
	}
	@Override
	public List<Map<String, Object>> getWareinitAll(Map<String, Object> map) {
		return managerDao.getWareinitAll(map);
	}

	@Override
	public StringBuffer meteringUnitImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "Ctl04004";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", "Ctl04004");
			mapquery.put("showFiledName", "unit_name");
			mapquery.put("findFiled", "ltrim(rtrim(isnull(sort_id,''))) =#{sort_id}");
			mapquery.put("com_id", getComId());
			mapquery.put("sort_id", map.get("sort_id"));
			Object obj = productDao.getOneFiledNameByID(mapquery);
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				buffer.append("计量单位编码[" + map.get("sort_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> getMeteringUnitAll(Map<String, Object> map) {
		map.put("name", map.get("searchKey"));
		return managerDao.findMeteringUnit(map);
	}

	@Override
	public StringBuffer payableImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "stfM0201";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			map.remove("mainten_datetime");
			String sSql = getInsertSqlByPre(table, map);
			map.put("sSql", sSql);
			productDao.insertSqlByPre(map);
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> getPayableAll(Map<String, Object> map) {
		map.put("name", map.get("searchKey"));
		return productionManagementDao.initialPayablePage(map);
	}

	@Override
	public StringBuffer producareaImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "Ctl04005";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			// TODO 产地品牌导入
			Object obj =null;
			if (isNotMapKeyNull(map, "producarea_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", "Ctl04005");
				mapquery.put("showFiledName", "producarea_name");
				mapquery.put("findFiled", "ltrim(rtrim(isnull(producarea_id,''))) = #{producarea_id}");
				mapquery.put("com_id", getComId());
				mapquery.put("com_id", map.get("producarea_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				buffer.append("产地品牌编码[" + map.get("producarea_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> getProducareaAll(Map<String, Object> map) {
		map.put("name", map.get("searchKey"));
		return managerDao.getProducarea(map);
	}

	@Override
	public StringBuffer accountingSubjectsImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		String table = "ctl04100";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			// 去除表中不存在的字段
			map.remove("mainten_clerk_id");
			map.remove("mainten_datetime");
			// 计算名称是否存在
			// TODO 会计科目导入
			Object obj =null;
			if (isNotMapKeyNull(map, "expenses_id")) {
				Map<String, Object> mapquery = new HashMap<String, Object>();
				mapquery.put("table", "ctl04100");
				mapquery.put("showFiledName", "expenses_name");
				mapquery.put("com_id", getComId());
				mapquery.put("filed", "expenses_id");
				mapquery.put("filedVal", map.get("expenses_id"));
				obj = productDao.getOneFiledNameByID(mapquery);
			}
			if (obj == null) {
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				buffer.append("会计科目编码[" + map.get("expenses_id") + "]");
			}
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> getAccountingSubjectsAll(
			Map<String, Object> map) {
		map.put("name", map.get("searchKey"));
		return managerDao.getAccountingSubjects(map);
	}

	@Override
	public List<Map<String, Object>> tijianExport(Map<String, Object> map) {

		return managerDao.tijianExport(map);
	}

	@Override
	public String tijianInit(Map<String, List<Map<String, Object>>> excelData) {
		List<Map<String, Object>> mainlist = excelData.get("mainlist");
		String table = "SDd02010_saiyu";
		StringBuffer buffer = new StringBuffer();
		for (Map<String, Object> map : mainlist) {
			Map<String, Object> mapquery = new HashMap<String, Object>();
			mapquery.put("table", table);
			mapquery.put("showFiledName", "ivt_oper_listing");
			StringBuffer findsql = new StringBuffer("(ltrim(rtrim(isnull(sd_order_id,''))=#{sd_order_id} ")
					.append("or ltrim(rtrim(isnull(ivt_oper_listing,'')))=#{sd_order_id})");
			mapquery.put("findFiled", findsql.toString());
			mapquery.put("com_id", getComId());
			mapquery.put("sd_order_id", map.get("sd_order_id"));
			Object obj = productDao.getOneFiledNameByID(mapquery);
			if (obj == null) {
				String corp_id = getSortId(table, "TJ", managerService);
				map.put("ivt_oper_listing", corp_id);
				String sSql = getInsertSqlByPre(table, map);
				map.put("sSql", sSql);
				productDao.insertSqlByPre(map);
			} else {
				productDao.insertSql(getUpdateSql(map, table,
						"ivt_oper_listing", obj.toString(), true));
				buffer.append("体检表编码[" + getMapKey(map, "sd_order_id")
						+ getMapKey(map, "position_big")
						+ getMapKey(map, "position") + "]已存在,并更新!<br>");
			}
		}
		return buffer.toString();
	}

	@Override
	@Transactional
	public StringBuffer quotationSheetImport(
			Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		List<Map<String,Object>>  list =maplist.get("list");
		String maintable = "SDd02010";
		String itemtable = "SDd02011";
		String com_id = mainlist.get(0).get("com_id").toString();
		Calendar c = Calendar.getInstance();
		StringBuffer buffer = new StringBuffer();
		try {
			for (Map<String, Object> map : mainlist) {
				// 获取外部单号
					if (isMapKeyNull(map,"customer_id")) {
						continue;
					}
					Map<String, Object> mapquery = new HashMap<String, Object>();
					// 从主表中获取单号根据订单外部单号
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "ivt_oper_listing");
					mapquery.put("findFiled", "ltrim(rtrim(isnull(customer_id,'')))=#{customer_id}");
					mapquery.put("com_id", com_id);
					mapquery.put("customer_id", map.get("customer_id"));
					Object No = productDao.getOneFiledNameByID(mapquery);
					if(No!=null||isNotMapKeyNull(map, "ivt_oper_listing")){
						//更新
						if(isNotMapKeyNull(map, "ivt_oper_listing")){
							No=map.get("ivt_oper_listing");
						}
						map.remove("ivt_oper_listing");
						String sSql = getUpdateSql(map, maintable, "ivt_oper_listing", No+"");
						productDao.insertSql(sSql);
					}else{
						//插入
						if(isMapKeyNull(map, "ivt_oper_listing")){
							String no = getOrderNo(customerDao, "销售订单", com_id);
							map.put("ivt_oper_listing", no);
							map.put("sd_order_id", no);
						}else{
							map.put("sd_order_id", map.get("ivt_oper_listing"));
						}
						String sSql = getInsertSqlByPre(maintable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
			}
			for (Map<String, Object> map : list) {
				// 获取外部单号
				if (isNotMapKeyNull(map, "item_id")&&isNotMapKeyNull(map, "customer_id")) {
					map.remove("excelIndex");
					//0.根据客户编码和产品编码从从表中获取编码
					//1.从主表获取订单编号
					Map<String, Object> mapquery = new HashMap<String, Object>();
					// 从主表中获取单号根据订单外部单号
					mapquery.put("table", itemtable);
					mapquery.put("showFiledName", "ivt_oper_listing");
					mapquery.put("findFiled", "ltrim(rtrim(isnull(customer_id,'')))=#{customer_id}"
							+ " and ltrim(rtrim(isnull(item_id,'')))=#{item_id}");
					mapquery.put("com_id", com_id);
					mapquery.put("customer_id", map.get("customer_id"));
					mapquery.put("item_id", map.get("item_id"));
					Object no = productDao.getOneFiledNameByID(mapquery);
					if(no!=null||isNotMapKeyNull(map, "ivt_oper_listing")){
						//更新isNotMapKeyNull(map, "ivt_oper_listing")||
						if(isNotMapKeyNull(map, "ivt_oper_listing")){
							no=map.get("ivt_oper_listing");
						}
						map.put("sd_order_id",no);
						map.put("ivt_oper_listing",no);
						String sSql = getUpdateSql(map, itemtable, "ivt_oper_listing",no+"");
						productDao.insertSql(sSql//+" and ltrim(rtrim(isnull(customer_id,'')))='"+map.get("customer_id")
						+"' and ltrim(rtrim(isnull(item_id,'')))='"+map.get("item_id")+"'");
					}else{
						//插入
						//1.从主表获取订单编号
						// 从主表中获取单号根据订单外部单号
						if(isMapKeyNull(map, "ivt_oper_listing")){
							mapquery.put("table", maintable);
							mapquery.put("showFiledName", "ivt_oper_listing");
							mapquery.put("findFiled", "ltrim(rtrim(isnull(customer_id,'')))=#{customer_id}");
							mapquery.put("com_id", com_id);
							mapquery.put("customer_id", map.get("customer_id"));
							no = productDao.getOneFiledNameByID(mapquery);
							//2.
							map.put("sd_order_id",no);
							map.put("ivt_oper_listing",no);
						}else{
							map.put("sd_order_id",map.get("ivt_oper_listing"));
						}
						map.put("m_flag","1");
						String sSql = getInsertSqlByPre(itemtable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
				}
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return buffer;
	}
	
	@Override
	public List<Map<String, Object>> quotationSheetExport(ProductQuery query) {
		
		return productDao.getquotationSheet(query);
	}

	@Override
	@Transactional
	public StringBuffer productionPlanSheetImport(Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		List<Map<String,Object>>  list =maplist.get("list");
		String maintable = "YieM02010";
		String itemtable = "YieM02011";
		StringBuffer buffer = new StringBuffer();
		String com_id = mainlist.get(0).get("com_id").toString();
		try {
			//导入主表数据
			for (Map<String, Object> map : mainlist) {
				Object obj=null;
				// 获取外部单号
				if (isNotMapKeyNull(map, "sd_order_id")) {
					// 从主表中获取单号根据订单外部单号
					Map<String, Object> mapquery = new HashMap<String, Object>();
					mapquery.put("table", maintable);
					mapquery.put("showFiledName", "ivt_oper_listing");
					mapquery.put("findFiled", "ltrim(rtrim(isnull(sd_order_id,'')))=#{sd_order_id}");
					mapquery.put("com_id", com_id);
					mapquery.put("sd_order_id", map.get("sd_order_id"));
					obj = productDao.getOneFiledNameByID(mapquery);
				}
				if(obj==null){
					String no = getOrderNo(customerDao, "销售订单", com_id);
					map.put("ivt_oper_listing",no);
					String sSql = getInsertSqlByPre(maintable, map);
					map.put("sSql", sSql);
					productDao.insertSqlByPre(map);
				}else{
					productDao.insertSql(getUpdateSql(map, maintable, "sd_order_id",
							map.get("sd_order_id") + "", true));
				}
			}
			//导入从表数据
			for(Map<String,Object> map : list){
				//获取外部单号
				if(isNotMapKeyNull(map, "item_id")&&isNotMapKeyNull(map, "JHSL")){
					String jhsl=map.get("JHSL").toString();
					BigDecimal JHSL=new BigDecimal(jhsl);
					if(JHSL.compareTo(BigDecimal.ZERO)!=1){
						continue;
					}
					Object obj=null;
					if (isNotMapKeyNull(map, "sd_order_id")) {
						String sd_order_id = map.get("sd_order_id").toString();
						Map<String, Object> mapquery = new HashMap<String, Object>();
						// 从主表中获取单号根据订单外部单号
						mapquery.put("table", maintable);
						mapquery.put("showFiledName", "ivt_oper_listing");
						mapquery.put("findFiled", "ltrim(rtrim(isnull(sd_order_id,'')))=#{sd_order_id}");
						mapquery.put("com_id", com_id);
						mapquery.put("sd_order_id", map.get("sd_order_id"));
						obj = productDao.getOneFiledNameByID(mapquery);
					}
					if(obj==null){
						map.remove("excelIndex");
						String no = getOrderNo(customerDao, "销售订单", com_id);
						map.put("ivt_oper_listing", no);
						String sSql = getInsertSqlByPre(itemtable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					} else {
						map.remove("excelIndex");
						productDao.insertSql(getUpdateSql(map, itemtable, "sd_order_id",
								map.get("sd_order_id") + "", true));
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return buffer;
	}

	@Override
	public StringBuffer materialproductionPlanSheetImport(Map<String, List<Map<String, Object>>> readExcel) {
		
		return null;
	}

	@Override
	public List<Map<String, Object>> exportProductionPlan(Map<String, Object> map) {
		
		return productionManagementDao.getProductionPlanInfo(map);
	}

	@Override
	@Transactional
	public StringBuffer purchasingSheetImport(Map<String, List<Map<String, Object>>> maplist) {
		List<Map<String, Object>> mainlist = maplist.get("mainlist");
		List<Map<String,Object>>  list =maplist.get("list");
		String maintable="STDM03001";//主表
		String itemtable="STD03001";//从表
		StringBuffer buffer = new StringBuffer();
		String com_id = mainlist.get(0).get("com_id").toString();
		Calendar c=Calendar.getInstance();
		try {
			//导入主表数据
			for (Map<String, Object> map : mainlist) {
				Object obj=null;
				//存在供应商时才导入
				if(isNotMapKeyNull(map,"vendor_id")){
					// 存在入库单号外码
					if (isNotMapKeyNull(map, "rcv_hw_no")) {
						// 根据入库单号外码查内码
						String rcv_hw_no = map.get("rcv_hw_no").toString();
						Map<String, Object> mapquery = new HashMap<String, Object>();
						mapquery.put("table", maintable);
						mapquery.put("showFiledName", "rcv_auto_no");
						mapquery.put("findFiled", "ltrim(rtrim(isnull(rcv_hw_no,'')))=#{rcv_hw_no}");
						mapquery.put("com_id", com_id);
						mapquery.put("rcv_hw_no", map.get("rcv_hw_no"));
						obj = productDao.getOneFiledNameByID(mapquery);
						//不存在内码,则执行插入,内码等于外码
						if(obj==null){
							map.put("ivt_oper_cfm", map.get("com_id"));
							map.put("ivt_oper_cfm_time", getNow());
							map.put("rcv_auto_no",rcv_hw_no);
							map.put("finacial_y", c.get(Calendar.YEAR));
							map.put("finacial_m", c.get(Calendar.MONTH));
							String sSql = getInsertSqlByPre(maintable, map);
							map.put("sSql", sSql);
							productDao.insertSqlByPre(map);
						//存在则执行更新
						}else{
							map.put("ivt_oper_cfm", map.get("com_id"));
							map.put("ivt_oper_cfm_time", getNow());
							map.put("finacial_y", c.get(Calendar.YEAR));
							map.put("finacial_m", c.get(Calendar.MONTH));
							productDao.insertSql(getUpdateSql(map, maintable, "rcv_hw_no",
									map.get("rcv_hw_no") + ""));
						}
					//不存在外码,系统自动生成内外码插入
					}else{
						String no = getOrderNo(customerDao, "采购订单", com_id);
						map.put("ivt_oper_cfm", map.get("com_id"));
						map.put("ivt_oper_cfm_time", getNow());
						map.put("rcv_hw_no",no);
						map.put("rcv_auto_no",no);
						map.put("finacial_y", c.get(Calendar.YEAR));
						map.put("finacial_m", c.get(Calendar.MONTH));
						String sSql = getInsertSqlByPre(maintable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
				}
			}
			//导入从表数据
			for(Map<String,Object> map : list){
				Object obj=null;
				//存在产品名时才导入从表
				if(isNotMapKeyNull(map,"item_name")){
					// 存在入库单号外码
					if (isNotMapKeyNull(map, "rcv_hw_no")) {
						// 根据入库单号外码查内码
						String rcv_hw_no = map.get("rcv_hw_no").toString();
						Map<String, Object> mapquery = new HashMap<String, Object>();
						mapquery.put("table", itemtable);
						mapquery.put("showFiledName", "rcv_auto_no");
						mapquery.put("findFiled", "ltrim(rtrim(isnull(rcv_hw_no,'')))=#{rcv_hw_no}");
						mapquery.put("com_id", com_id);
						mapquery.put("rcv_hw_no", rcv_hw_no);
						obj = productDao.getOneFiledNameByID(mapquery);
						if(obj==null){
							map.remove("excelIndex");
							map.put("rcv_auto_no",rcv_hw_no);
							map.put("at_term_datetime",getNow());
							map.put("finacial_d",getNow());
							String sSql = getInsertSqlByPre(itemtable, map);
							map.put("sSql", sSql);
							productDao.insertSqlByPre(map);
						}else{
							map.remove("excelIndex");
							map.put("at_term_datetime",getNow());
							map.put("finacial_d",getNow());
							productDao.insertSql(getUpdateSql(map, itemtable, "rcv_hw_no",
									map.get("rcv_hw_no") + ""));
//							buffer.append("入库单号[" + map.get("rcv_hw_no") + "]已存在,并更新!<br>");
						}
					}else{
						map.remove("excelIndex");
						String no = getOrderNo(customerDao, "采购订单", com_id);
						map.put("rcv_hw_no",no);
						map.put("rcv_auto_no",no);
						map.put("at_term_datetime",getNow());
						map.put("finacial_d",getNow());
						String sSql = getInsertSqlByPre(itemtable, map);
						map.put("sSql", sSql);
						productDao.insertSqlByPre(map);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			buffer.append(e.getMessage());
		}
		return buffer;
	}

	@Override
	public List<Map<String, Object>> purchasingSheetExport(Map<String, Object> map) {
		return employeeDao.purchasingSheetExport(map);
	}
	@Override
	public List<Map<String, Object>> initialReceivableExcel(
			Map<String, Object> map) {
		return productionManagementDao.initialReceivableList(map);
	}
}
