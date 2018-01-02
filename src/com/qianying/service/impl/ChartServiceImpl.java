package com.qianying.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.qianying.dao.interfaces.IChartDao;
import com.qianying.service.IChartService;
@Service
public class ChartServiceImpl extends BaseServiceImpl implements IChartService {

	@Resource
	private IChartDao chartDao;
	
	@Override
	public List<Map<String, Object>> productViewAndOrder(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chartDao.productViewAndOrder(map);
	}
	
	@Override
	public List<Map<String, Object>> salesCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chartDao.salesCount(map);
	}

}
