package com.qianying.service;

import java.util.List;
import java.util.Map;

public interface IBaseService {

	void save(Map<String, Object> map);
	void update(Map<String, Object> map);
	void delete(Long id);
	Map<String, Object> get(Long id);
	List<Map<String, Object>> getAll();
	List<Map<String, Object>> findBySql(Map<String, Object> map);
}
