package com.qianying.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

/**
 * 日期时间工具
 * 
 * @author dengqiang
 * 
 */
public abstract class DateTimeUtils {

	/**
	 * 日期时间格式化
	 */
	public static final SimpleDateFormat dateTime_format = new SimpleDateFormat(
			ConfigFile.DATETIME_FORMAT, Locale.CHINA);
	public static final SimpleDateFormat date_format = new SimpleDateFormat(
			ConfigFile.DATE_FORMAT, Locale.CHINA);

	/**
	 * 字符串转换为日期
	 * 
	 * @param source
	 * @return 转换后的日期
	 */
	public static Date strToDate(String source) {
		try {
			return date_format.parse(source);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 字符串转换为日期时间型
	 * 
	 * @param source
	 * @return 转换后的日期时间
	 */
	public static Date strToDateTime(String source) {
		try {
			return dateTime_format.parse(source);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 日期转换为字符串
	 * 
	 * @param date
	 * @return 转换后的字符串
	 */
	public static String dateToStr(Date date) {
		return date_format.format(date);
	}

	/**
	 * 日期时间型转换为字符串
	 * 
	 * @param date
	 * @return 转换后的字符串
	 */
	public static String dateTimeToStr(Date date) {
		return dateTime_format.format(date);
	}

	/**
	 * 日期转换为字符串 获取当前时间
	 * 
	 * @return 转换后的字符串
	 */
	public static String dateToStr() {
		return date_format.format(new Date());
	}

	/**
	 * 日期时间型转换为字符串
	 * 
	 * @return 转换后的字符串
	 */
	public static String dateTimeToStr() {
		return dateTime_format.format(new Date());
	}

	/**
	 * 获得本周一0点时间
	 * 
	 * @return
	 */
	public static String getTimesWeekmorning() {
		Calendar cal = Calendar.getInstance();
		cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONDAY),
				cal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		return dateTime_format.format(cal.getTime());
	}

	/**
	 * 获得本月第一天0点时间
	 * 
	 * @return
	 */
	public static String getTimesMonthmorning() {
		Calendar cal = Calendar.getInstance();
		cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONDAY),
				cal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		cal.set(Calendar.DAY_OF_MONTH,
				cal.getActualMinimum(Calendar.DAY_OF_MONTH));
		return dateTime_format.format(cal.getTime());
	}

	/**
	 * 获得本月最后一天24点时间
	 * 
	 * @return
	 */
	public static String getTimesMonthnight() {
		Calendar cal = Calendar.getInstance();
		cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONDAY),
				cal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		cal.set(Calendar.DAY_OF_MONTH,
				cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		cal.set(Calendar.HOUR_OF_DAY, 24);
		return dateTime_format.format(cal.getTime());
	}

	/**
	 * 获取指定日期所在的周数
	 * 
	 * @param date
	 *            查询日期 yyyy-MM-dd
	 * @return 周数
	 */
	public static int getWeekNum(String date) {
		Calendar cl = Calendar.getInstance();
		try {
			cl.setTime(date_format.parse(date));
		} catch (ParseException e) {
		}
		int week = cl.get(Calendar.WEEK_OF_YEAR);
		cl.add(Calendar.DAY_OF_MONTH, -7);
		// int year = cl.get(Calendar.YEAR);
		// if(week<cl.get(Calendar.WEEK_OF_YEAR)){
		// year+=1;
		// }
		if (!DateTimeUtils.isSUNDAY(date)) {
			week=week+1;
		}
		return week;
	}
	/**
	 * 判断是否是星期天
	 * @param source 查询日期
	 * @return 是返回true,否则返回false
	 */
	public static boolean isSUNDAY(String source) {
		Date bdate = strToDate(source);
		Calendar cal = Calendar.getInstance();
		cal.setTime(bdate);
		if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
			return true;
		} else
			return false;
	}
	/**
	 * 判断是否是星期六
	 * @param source 查询日期
	 * @return 是返回true,否则返回false
	 */
	public static boolean isSATURDAY(String source) {
		Date bdate = strToDate(source);
		Calendar cal = Calendar.getInstance();
		cal.setTime(bdate);
		if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
			return true;
		} else
			return false;
	}

	/**
	 * 获取指定日期所在周一和周日的日期
	 * 
	 * @param source
	 *            需要查询的字符串日期
	 * @return 周一和周日的日期
	 * @throws ParseException
	 */
	public static Map<String, String> getConvertWeekByDate(String source) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			Date time = date_format.parse(source);
			Calendar cal = Calendar.getInstance();
			cal.setTime(time);
			// 判断要计算的日期是否是周日，如果是则减一天计算周六的，否则会出问题，计算到下一周去了
			int dayWeek = cal.get(Calendar.DAY_OF_WEEK);// 获得当前日期是一个星期的第几天
			if (1 == dayWeek) {
				cal.add(Calendar.DAY_OF_MONTH, -1);
			}
			cal.setFirstDayOfWeek(Calendar.MONDAY);// 设置一个星期的第一天，按中国的习惯一个星期的第一天是星期一
			int day = cal.get(Calendar.DAY_OF_WEEK);// 获得当前日期是一个星期的第几天
			cal.add(Calendar.DATE, cal.getFirstDayOfWeek() - day);// 根据日历的规则，给当前日期减去星期几与一个星期第一天的差值
			String imptimeBegin = date_format.format(cal.getTime())
					+ " 00:00:00";
			map.put("beginTime", imptimeBegin);
			cal.add(Calendar.DATE, 6);
			String imptimeEnd = date_format.format(cal.getTime()) + " 23:59:59";
			map.put("endTime", imptimeEnd);
			return map;
		} catch (Exception e) {
			map.put("err", "日期格式不正确!");
			return map;
		}
	}

	/**
	 * 返回指定日期的月的第一天
	 * 
	 * @param source
	 *
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getFirstDayOfMonth(String source) {
		try {
			Date date = date_format.parse(source);
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.set(calendar.get(Calendar.YEAR),
					calendar.get(Calendar.MONTH), 1);
			return date_format.format(calendar.getTime()) + " 00:00:00";
		} catch (ParseException e) {
			e.printStackTrace();
			return "日期格式不正确!";
		}
	}
	/**
	 * 返回指定日期的月的第一天
	 * 
	 * @param source
	 *
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getFirstDayOfMonth(Date date) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.set(calendar.get(Calendar.YEAR),
					calendar.get(Calendar.MONTH), 1);
			return date_format.format(calendar.getTime()) + " 00:00:00";
	}

	/**
	 * 返回指定日期的月的最后一天
	 *
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getLastDayOfMonth(String source) {
		try {
			Date date = date_format.parse(source);
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.set(calendar.get(Calendar.YEAR),
					calendar.get(Calendar.MONTH), 1);
			calendar.roll(Calendar.DATE, -1);
			return date_format.format(calendar.getTime()) + " 23:59:59";
		} catch (Exception e) {
			e.printStackTrace();
			return "日期格式不正确!";
		}
	}
	/**
	 * 返回指定日期的月的最后一天
	 *
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getLastDayOfMonth(Date date) {
		try {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.set(calendar.get(Calendar.YEAR),
					calendar.get(Calendar.MONTH), 1);
			calendar.roll(Calendar.DATE, -1);
			return date_format.format(calendar.getTime()) + " 23:59:59";
		} catch (Exception e) {
			e.printStackTrace();
			return "日期格式不正确!";
		}
	}
	/**
	 * 获取日期时间
	 * @return 返回格式为yyyyMMddHHmmss
	 */
	public static String getNowDateTime() {
		SimpleDateFormat format=new SimpleDateFormat("yyyyMMddHHmmss", Locale.CHINA);
		return format.format(new Date());
	}
	/**
	 * 获取日期时间 17位
	 * @return 返回格式为yyyyMMddHHmmssSSS
	 */
	public static String getNowDateTimeS() {
		SimpleDateFormat format=new SimpleDateFormat("yyyyMMddHHmmssSSS", Locale.CHINA);
		return format.format(new Date());
	}
	
	/**
	 * 获取日期时间
	 * @return 返回格式为yyyyMMdd
	 */
	public static String getNowDate() {
		SimpleDateFormat format=new SimpleDateFormat("yyyyMMdd", Locale.CHINA);
		return format.format(new Date());
	}
	/**
	 * 获取一年中的每一天
	 * @return
	 */
	public static List<Map<String,Object>> getDay(int year) {
		List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
		 int m=1;//月份计数
		 while (m<13)
		 {
		  int month=m;
		  Calendar cal=Calendar.getInstance();//获得当前日期对象
		  cal.clear();//清除信息
		  cal.set(Calendar.YEAR,year-1);
		  cal.set(Calendar.MONTH,month-1);//1月从0开始
		  cal.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天 
		  int count=cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		  for (int j=0;j<=(count - 2);){
		  cal.add(Calendar.DAY_OF_MONTH,1);
		  j++;
		  Map<String,Object> map=new HashMap<String, Object>();
		  map.put("week", getWeekNum(date_format.format(cal.getTime())));
		  map.put("day",date_format.format(cal.getTime()));
		  if(MapUtils.getString(map, "day").endsWith("02")){
			  Map<String,Object> map1=new HashMap<String, Object>();
			  map1.put("week", getWeekNum(date_format.format(cal.getTime())));
			  String[] days=MapUtils.getString(map, "day").split("-");
			  map1.put("day",days[0]+"-"+days[1]+"-01");
			  list.add(map1);
		  }
		  list.add(map);
		  }
		  m++;
		 }
		 return list;
	} 
}
