package com.qianying.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public abstract class ChartData {
	public static List<Object> jqChartData(List<Map<String, Object>> itemMaps) {
		List<Object> list=new ArrayList<Object>();
			for (Map<String, Object> itemMap : itemMaps) {
				List<Object> item=new ArrayList<Object>();
				item.add(itemMap.get("label"));
				item.add(itemMap.get("val"));
				list.add(item);
			}
		return list;
	}
	
	public static List<List<Object>> jqChartDatas(Map<String, Object> map) {
		List<List<Object>> list=new ArrayList<List<Object>>();
		for (int i = 0; i < 2; i++) {
			List<Object> item=new ArrayList<Object>();
			List<Map<String, Object>> itemMaps=new ArrayList<Map<String,Object>>();
			if (i==0) {
//				  itemMaps=appDao.getAppCountRecord(map);				
			} else if (i==1) {
//				itemMaps=appDao.getAppCountRecordWifi(map);				
			} else {
				break;
			}
			for (Map<String, Object> itemMap : itemMaps) {
				List<Object> itemList=new ArrayList<Object>();
				itemList.add(itemMap.get("label"));
				itemList.add(itemMap.get("val"));
				item.add(itemList);
			}
			list.add(item);
		}
		return list;
	}
}
