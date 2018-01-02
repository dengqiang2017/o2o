package com.qianying.dao.interfaces;

import java.util.List;
import java.util.Map;

public interface ITailorMadeDao {

	Integer getTailorMadeInfoPageCount(Map<String, Object> map);

	List<Map<String, Object>> getTailorMadeInfoPage(Map<String, Object> map);
	/**
	 * 删除报价单,如果被订单引用就标识为删除
	 * @param orderNo 报价单号
	 * @return 引用次数,0标示为没有引用,直接删除
	 */
	Integer delTailorMade(String orderNo);

	void saveSum_si(Map<String, Object> map);
	
	Map<String, Object> getPayPercentage(Map<String, Object> map);

	Integer getTailorMadeOrderPageCount(Map<String, Object> map);

	List<Map<String, Object>> getTailorMadeOrderPage(Map<String, Object> map);

}
