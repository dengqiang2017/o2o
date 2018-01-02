package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
/**
 * 获取系统参数待查询缓存
 * @author dengqiang
 *
 */
public interface ISystemParamsDAO {
	/**
	 * 获取指定账套下所有的系统参数
	 * @param comId
	 * @return 该com_id下的系统参数
	 */
	List<Map<String, Object>> getSystemParamsByComId(@Param("com_id")String comId);
	/**
	 * 获取指定账套下单个系统参数
	 * @param param_name
	 * @param comId
	 * @return
	 */
	String checkSystem(@Param("param_name")String param_name, @Param("com_id")String comId);
	/**
	 * 获取指定账套下单个系统参数
	 * @param param_name
	 * @param defval
	 * @param comId
	 * @return
	 */
	String checkSystemDef(@Param("param_name")String param_name, @Param("defval")String defval, @Param("com_id")String comId);

}
