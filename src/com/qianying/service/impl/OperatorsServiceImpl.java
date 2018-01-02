package com.qianying.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qianying.dao.interfaces.IOperatorsDAO;
import com.qianying.dao.interfaces.SqlExecDao;
import com.qianying.service.IOperatorsService;
@Service
public class OperatorsServiceImpl implements
		IOperatorsService {

	@Autowired
	private IOperatorsDAO operatorsDao;
	@Autowired
	private SqlExecDao sql;
	@Override@Transactional
	public void save(Map<String, Object> map) {
		// TODO Auto-generated method stub
		
	}

	@Override@Transactional
	public void update(Map<String, Object> map) {
		// TODO Auto-generated method stub
		
	}

	@Override@Transactional
	public void delete(Long id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Map<String, Object> get(Long id) {
		return null;
	}

	@Override
	public List<Map<String, Object>> getAll() {
		return operatorsDao.getAll();
	}
	@Override
	public List<Map<String, Object>> getNextComs(Map<String, Object> map) {
		 
		return operatorsDao.getNextComs(map);
	}
	@Override
	public List<Map<String, Object>> findBySql(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@Transactional
	public void initTable(String dataname)throws Exception {
			operatorsDao.initTable(dataname);
			operatorsDao.alterField();
	}
	
	@Override
	@Transactional
	public List<Map<String, Object>> sqlExec(Map<String, Object> map)throws Exception {
		 
		return sql.sqlExec(map);
	}
	@Override
	@Transactional
	public void initData(String com_id) throws Exception {
		operatorsDao.initData(com_id);
	}
}
