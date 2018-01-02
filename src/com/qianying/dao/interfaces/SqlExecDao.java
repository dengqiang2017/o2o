package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;
/**
 * 执行sql语句
 * @author dengqiang
 * 2014-06-23:14:30
 */
public interface SqlExecDao {
	public List<Map<String, Object>> sqlExec(Map<String, Object> map);
}
