package com.qianying.page;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.qianying.util.ConfigFile;

/**
 * 查询对象基类
 * @author dengqiang
 *
 */
public abstract class ObjectQuery {
	// 当前页
	private Integer page=0;
	//每页记录数
	private Integer rows=10;
	
	private Map<String, Object> params=new HashMap<String,Object>();
	protected String searchKey;
	protected String queryParams;
	
	public void setSearchKey(String searchKey) {
		try {
			this.searchKey =URLDecoder.decode(searchKey, "utf-8");
		} catch (UnsupportedEncodingException e) {
			if (ConfigFile.PRINT_ERROR) {				
				e.printStackTrace();
			}
		}
	}
 
	public Integer getPage() {
			return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public String getSearchKey() {
		if (StringUtils.isNotBlank(searchKey)&&!"null".equals(searchKey)) {			
			return "%"+searchKey+"%";
		}else {
			return null;
		}
	}

	public abstract void addParams();
	
	public Map<String, Object> getParams() {
			return params;
	}

	public void setParams(Map<String, Object> params) {
		this.params = params;
	}
	/**
	 * 获取分页查询时开始记录数
	 * @return  beginRow
	 */
	public Integer getBeginRow(){
		return (page-1)*rows;
	}
	
	public String likeparam(String name){
		if (StringUtils.isNotBlank(name)&&!"null".equals(name)) {
			return "%"+name+"%";
		}else {
			return null;
		}
	}

	public String getQueryParams() {
		if (StringUtils.isBlank(queryParams)) {
			queryParams=null;
		}
		return queryParams;
	}

	public void setQueryParams(String queryParams) {
		if (StringUtils.isBlank(queryParams)) {
			this.queryParams=null;
		}
		this.queryParams = queryParams;
	}
	
}
