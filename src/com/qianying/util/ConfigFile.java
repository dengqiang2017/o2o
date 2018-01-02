package com.qianying.util;

/**
 * 项目配置文件
 * 
 * @author dengqiang
 * 
 */
public abstract class ConfigFile {
	public static boolean DEBUG = true;
	/**
	 * 订单短信是否发送,true发送
	 */
	public static boolean ORDER_SMS = false;
	
	/**
	 * 是否记录日志
	 */
	public static boolean LOG = true; 
	
	/**
	 * 日志保存时间 默认15天
	 */
	public static int  LOGDAY = 15;
	/**
	 * 是否打印错误信息
	 */
	 public static boolean  PRINT_ERROR =false;
	
	/**
	 * 推送间隔时间 默认10秒钟
	 */
	public static int  POLLDATATIME =3000*1000;  
	/**
	 * 初始化配置文件的修改时间,用来判断文件是否在运行期被修改,修改后就重新加载
	 */
	public static String initModifiedTime;
	/**
	 * 放行xml修改时间
	 */
	public static String passModifiedTime; 

	public static final String USERINFO="userinfo";
	public static final String ERWEIMA = "erweima";
	public static final String ROOT = "/";
	/**
	 * 用户登录session
	 */
	public static final String SESSION_USER_INFO = "userInfo";//员工
	public static final String CUSTOMER_SESSION_LOGIN="customerInfo";//客户,供应商,司机等
	
	// 验证码有效时间
	public static int code_Obsolete_date = 1000;
	public static final String registerVerificationCode = "registerVerificationCode";
	///////
	public static final String DATETIME_FORMAT="yyyy-MM-dd HH:mm:ss";

	public static final String DATE_FORMAT =  "yyyy-MM-dd";
	
	/**
	 * 服务器安装目录
	 */
	public static String TOMCAT_DIR =  null;
	
	public static final String SYSTEM_NAME = "systemName";
	
	public static final String SPLIT = "/";

	public static boolean DEBUG_PHONE = false; 
	/**
	 * 系统logo路径
	 */
	public static String LOGO_URL = "/images/logo.png"; 
	/**
	 * 图片水印
	 */
	public static String TEXT_WATERMARK = "";// 
	/**
	 * 图片存储路径
	 */
	public static String IMG_URL_PREFIX = "/userpic/";
	/**
	 * 运营商编码
	 */
	public final static String OPERATORS_NAME="operators_name";
	public static final String JS000SYS = "JS001,JS002,JS001JS003,JS001JS004";
	public static String systemWeixin = "";
	public static boolean ORDER_SMS_DEBUG = true;//订单短信调试

	public static String PC_OR_PHONE="phone/"; 

	public static String NoticeStyle = "0";
	/**
	 * 订单名称
	 */
	public static String subject="jiajuruanjian";
	/**
	 * 订单描述
	 */
	public static String body="chanpingmiaoshu";
	
	public static String projectName="o2o";

	/**
	 * 订单短信调试发送地方
	 */
	public static String ORDER_SMS_NO="13086652206";
	public static String salesOrder_ProcessA="1";
	public static String Res_Ver="0001";
	/**
	 * 当前域名前缀 http://
	 */
	public static String urlPrefix="http://www.pulledup.cn";
	/**
	 * 行业分类
	 */
//	public static String o2o="jiaju";
	/**
	 * 生产计划推送离散或流程 默认0-离散
	 */
	public static Integer PlanPush=0;//生产计划推送离散或流程
	/**
	 * 产品 或 订单 生产计划流程控制 默认0-产品
	 */
	public static Integer PlanSource=0;//产品 或 订单
	/**
	 * 质检方式,生产人员自己检测,专业质检员质检
	 */
	public static Integer QCWay=0;//质检方式,生产人员自己检测,专业质检员质检
	/**
	 * 是否通知流程中设置的所有人,默认true-不通知 
	 */
	public static boolean NoticeResultAll=true;//是否通知流程中设置的所有人,默认通知
	/**
	 * 是否自动生成采购订单
	 */
	public static boolean isAutoGPOrder;
	/**
	 * 开始生成采购订单时间
	 */
	public static String autoGPOBeginTime;
	/**
	 * 截止生成采购订单时间
	 */
	public static String autoGPOEndTime;
	/**
	 * 生成间隔周期
	 */
	public static Integer autoIntervalTime;
	/**
	 * 员工首页指向后缀
	 */
	public static String emplName="";
//	/**
//	 * 电工选择后通知客户角色
//	 */
//	public static String clientElecHeadship="";
//	/**
//	 * 电工选择后通知员工角色
//	 */
//	public static String employeeElecHeadship="";
//	/**
//	 * 电工确认后通知平台内部员工职务
//	 */
//	public static String elecEmployeeHeadship="";
//	/**
//	 *  电工确认后通知客户员工职务
//	 */
//	public static String elecClientHeadship="";
//	/**
//	 * 客户支付安装费后通知客户员工职务
//	 */
//	public static String payNoticeClientHeadship="";
//	/**
//	 * 客户支付安装费后通知平台内部员工职务
//	 */
//	public static String payNoticeEmployeeHeadship="";
//	/**
//	 * 客户验收后通知平台内部员工职务
//	 */
//	public static String acceptanceNoticeClientHeadship;
//	/**
//	 * 客户验收后通知客户员工职务
//	 */
//	public static String acceptanceNoticeElpoyeeHeadship;
//	/**
//	 * 客户登录通知员工职务
//	 */
//	public static String loginNoticeHeadship;
//	/**
//	 * 微信进入时是否自动查询
//	 */
//	public static Boolean isAutoFind=true;
	/**
	 * 是否显示其他运营商的消息
	 */
	public static boolean isShowAllProduct=false;
//	/**
//	 * 订单消息接收类型
//	 * 0-根据职务 默认
//	 * 1-根据基础资料表的人员
//	 * 2-先根据职务再根据基础资料表的人员
//	 */
//	public static Integer ordersMessageReceivedType=0;
//	/**
//	 * 客户收货后通知员工职务
//	 */
//	public static String Eheadshiped;
//	/**
//	 * 客户收款确认通知的职务
//	 */
//	public static String paymentConfirmationHeadship;
	/**
	 * 本机外网IP地址
	 */
//	public static String LocalIP="115.159.198.31";
	public static String LocalIP="222.209.185.157";
	public static String ACAO="http://p1.pulledup.cn,http://p2.pulledup.cn,http://p8.pulledup.cn,http://p9.pulledup.cn";
	public static boolean NOSQL=false;
	/**
	 * 获取项目根路径
	 * @return 项目根路径
	 */
	public static String getProjectPath() {
		String path = ConfigFile.class.getClassLoader()
				.getResource("jdbc.properties").getPath();
		return path.replaceFirst("/", "").replace("WEB-INF/classes/jdbc.properties", "");
	}
}
