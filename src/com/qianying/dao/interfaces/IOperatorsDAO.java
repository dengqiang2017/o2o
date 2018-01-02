package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.qianying.dao.base.BaseDao;

public interface IOperatorsDAO extends BaseDao {
	
	/**
	 * 初始化数据表
	 * @param databaseName 
	 */
	void initTable(@Param("dataname")String dataname);
	/**
	 * 初始化数据
	 * @param com_id
	 */
	void initData(@Param("com_id")String com_id);
	
	void alterField();
	/**
	 * 
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> getNextComs(Map<String, Object> map);
	

}
