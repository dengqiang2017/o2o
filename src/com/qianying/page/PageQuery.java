package com.qianying.page;
/**
 * 分页查询对象
 * @author dengqiang
 *
 */
public class PageQuery extends ObjectQuery {
	private String sord="asc";//排序

	public String getSord() {
		return sord;
	}

	public void setSord(String sord) {
		this.sord = sord;
	}

	/**
	 * 添加查询参数
	 */
	@Override
	public void addParams() {}

}
