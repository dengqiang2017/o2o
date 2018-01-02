package com.qianying.service;

import java.util.Map;
/**
 * 获取当前操作账套下的系统参数
 * @author dengqiang
 *
 */
public interface ISystemParamsService {
	/**
	 * 
	 * @param comId
	 * @return
	 */
	Map<String, Object> getSystemParamsByComId(String comId);
	/**
	 * 获取系统指定参数值
	 * @param param_name 参数名称
	 * @return
	 */
	Object checkSystem(String param_name);
	/**
	 * 获取系统指定参数值
	 * @param param_name 参数名称
	 * @param defval 默认值 
	 * @return
	 */
	String checkSystem(String param_name, String defval);
}
