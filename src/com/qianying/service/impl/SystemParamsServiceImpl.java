package com.qianying.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.qianying.service.ISystemParamsService;
/**
 * 获取当前操作账套下的系统参数
 * @author dengqiang
 *
 */
@Service
public class SystemParamsServiceImpl extends BaseServiceImpl implements
		ISystemParamsService {
	
	@Override
	public Map<String, Object> getSystemParamsByComId(String comId) {
		List<Map<String,Object>> list=systemParamsDao.getSystemParamsByComId(getComId()); 
		Map<String,Object> map=new HashMap<String, Object>();
		for (Map<String, Object> map2 : list) {
			map.put(map2.get("param_name")+"", map2.get("param_val"));
		}
		return map;
	}

	@Override
	public Object checkSystem(String param_name) {
		return systemParamsDao.checkSystem(param_name, getComId());
	}
	@Override
	public String checkSystem(String param_name, String defval) {
		String val= systemParamsDao.checkSystemDef(param_name,defval, getComId());
		if(StringUtils.isBlank(val)){
			return defval;
		}
		return val;
	}
}
