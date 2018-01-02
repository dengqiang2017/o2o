package com.qianying.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;

import org.apache.commons.lang.StringUtils;
/**
 * 手机号验证工具类
 * @author dengqiang
 *
 */
public abstract class CheckPhoneUtil {
	/** 电话格式验证 **/
	private static final String PHONE_CALL_PATTERN = "^(\\(\\d{3,4}\\)|\\d{3,4}-)?\\d{7,8}(-\\d{1,4})?$";

	/**
	 * 中国电信号码格式验证 手机段： 133,153,180,181,189,177,1700
	 * **/
	private static final String CHINA_TELECOM_PATTERN = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";

	/**
	 * 中国联通号码格式验证 手机段：130,131,132,155,156,185,186,145,176,1709
	 * **/
	private static final String CHINA_UNICOM_PATTERN = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";

	/**
	 * 中国移动号码格式验证
	 * 手机段：134,135,136,137,138,139,150,151,152,157,158,159,182,183,184
	 * ,187,188,147,178,1705
	 * **/
	private static final String CHINA_MOBILE_PATTERN = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";

	/**
	 * 验证电话号码的格式
	 * 
	 * @param phone
	 *            校验电话字符串
	 * @return 返回true,否则为false
	 */
	public static boolean isPhoneCallNum(String phone) {
		return phone == null || phone.trim().equals("") ? false : match(
				PHONE_CALL_PATTERN, phone);
	}

	/**
	 * 验证【电信】手机号码的格式
	 * 
	 * @param phone
	 *            校验手机字符串
	 * @return 返回true,否则为false
	 */
	public static boolean isChinaTelecomPhoneNum(String phone) {
		boolean b=phone == null || phone.trim().equals("") ? false : match(
		CHINA_TELECOM_PATTERN, phone);
		if(!b){
			if(phone.startsWith("0")||phone.indexOf("-")>=2){
				b=true;
			}
		}
		return b;
	}

	/**
	 * 验证【联通】手机号码的格式
	 * 
	 * @param phone
	 *            校验手机字符串
	 * @return 返回true,否则为false
	 */
	public static boolean isChinaUnicomPhoneNum(String phone) {

		return phone == null || phone.trim().equals("") ? false : match(
				CHINA_UNICOM_PATTERN, phone);
	}

	/**
	 * 验证【移动】手机号码的格式
	 * 
	 * @param phone
	 *            校验手机字符串
	 * @return 返回true,否则为false
	 */
	public static boolean isChinaMobilePhoneNum(String phone) {
		if (StringUtils.isNotBlank(phone)) {
			return match(CHINA_MOBILE_PATTERN, phone);
		}else{
			return false;
		}
	}

	/**
	 * 验证手机和电话号码的格式
	 * 
	 * @param phone
	 *            校验手机字符串
	 * @return 返回true,否则为false
	 */
	public static boolean isPhoneNum(String phone) {
		// 如果字符串为空，直接返回false
		if (phone == null || phone.trim().equals("")) {
			return false;
		} else {
			int comma = phone.indexOf(",");// 是否含有逗号
			int caesuraSign = phone.indexOf("、");// 是否含有顿号
			int space = phone.trim().indexOf(" ");// 是否含有空格
			if (comma == -1 && caesuraSign == -1 && space == -1) {
				// 如果号码不含分隔符,直接验证
				phone = phone.trim();
				return (isPhoneCallNum(phone) || isChinaTelecomPhoneNum(phone)
						|| isChinaUnicomPhoneNum(phone) || isChinaMobilePhoneNum(phone)) ? true
						: false;
			} else {
				// 号码含分隔符,先把分隔符统一处理为英文状态下的逗号
				if (caesuraSign != -1) {
					phone = phone.replaceAll("、", ",");
				}
				if (space != -1) {
					phone = phone.replaceAll(" ", ",");
				}

				String[] phoneNumArr = phone.split(",");
				// 遍历验证
				for (String temp : phoneNumArr) {
					temp = temp.trim();
					if (isPhoneCallNum(temp) || isChinaTelecomPhoneNum(temp)
							|| isChinaUnicomPhoneNum(temp)
							|| isChinaMobilePhoneNum(temp)) {
						continue;
					} else {
						return false;
					}
				}
				return true;
			}

		}

	}

	/**
	 * 执行正则表达式
	 * 
	 * @param pat
	 *            表达式
	 * @param phone
	 *            待验证字符串
	 * @return 返回true,否则为false
	 */
	private static boolean match(String pat, String phone) {
		Pattern pattern = Pattern.compile(pat);
		Matcher match = pattern.matcher(phone);
		return match.find();
	}
	/**
	 * 获取手机号所属运营商
	 * 
	 * @param phone
	 *            待核验手机号
	 * @return 运营商类型
	 */
	public static String getPhoneType(String phone) {
		String msg = null;
		if (isChinaMobilePhoneNum(phone)) {
			msg = "移动";
		}
		if (isChinaTelecomPhoneNum(phone)) {
			msg = "电信";
		} 
		if (isChinaUnicomPhoneNum(phone)) {
			msg = "联通";
		}
		return msg;
	}
//	public static void main(String[] args) {
//		System.out.println(getPhoneType("18181686678"));
//		System.out.println(getPhoneType("18224052021"));
//		System.out.println(getPhoneType("13950797596"));
//		System.out.println(getPhoneType("15082465058"));
//		System.out.println(getPhoneType("15884136055"));
//		System.out.println(getPhoneType("13730740458"));
//		System.out.println(getPhoneType("0596-3370653"));
//
//	}
}
