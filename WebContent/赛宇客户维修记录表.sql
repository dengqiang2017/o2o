-- 客户体检表
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SDd02010_saiyu]') AND type in (N'U'))
DROP TABLE [dbo].[SDd02010_saiyu]
GO
CREATE TABLE [dbo].[SDd02010_saiyu](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,
	[bx_oper_listing] [varchar](30) NOT NULL,
	[sd_order_id] [varchar](30) NULL,
	[customer_id] [varchar](30) NULL,
	[work_state] [char](10) NULL,--报修中,已结束
	
	[position_big] [varchar](30) NULL,  -- 位置大类
	[position] [varchar](30) NULL,  -- 位置小类
	
	[item_brand] [varchar](30) NULL, -- 灯具品牌
	[item_name] [varchar](30) NULL,  --灯具名称
	[item_standard] [varchar](50) NULL,  --灯具型号
	[item_num] [varchar](10) NULL, --产品数量
	
	[item_name_g] [varchar](30) NULL,  --光源名称
	[item_standard_g] [varchar](50) NULL,  --光源型号
	[item_color_g] [varchar](50) NULL,  --光源颜色
	[item_num_g] [int] NULL, --光源数量
	[damage_num_g] [int] NULL, --光源损坏数量
	
	[item_name_d] [varchar](30) NULL,  --电器名称
	[item_standard_d] [varchar](50) NULL,  --电器型号
	[item_num_d] [int] NULL, --电器数量
	[damage_num_d] [int] NULL, --电器损坏数量
	
	-- 光源产品id
	[item_id_g_gj1] [varchar](30) NULL,  --国际产品id
	[item_name_g_gj1] [varchar](30) NULL,  --国际产品name
	[sd_unit_price_g_gj1] [decimal](17, 6) NULL, --国际产品单价
	[sd_oq_g_gj1] [varchar](10) NULL, --国际产品数量
	[use_oq_g_gj1] [varchar](10) NULL, --国际产品可用库存数量
	
	[item_id_g_gj2] [varchar](30) NULL,  --国际产品id
	[item_name_g_gj2] [varchar](30) NULL,  --国际产品name
	[sd_unit_price_g_gj2] [decimal](17, 6) NULL, --国际产品单价
	[sd_oq_g_gj2] [varchar](10) NULL, --国际产品数量
	[use_oq_g_gj2] [varchar](10) NULL, --国际产品可用库存数量
	
	[item_id_g_gn1] [varchar](30) NULL,  --国内产品id
	[item_name_g_gn1] [varchar](30) NULL,  --国内产品name
	[sd_unit_price_g_gn1] [decimal](17, 6) NULL, --国内产品单价
	[sd_oq_g_gn1] [varchar](10) NULL, --国内产品数量
	[use_oq_g_gn1] [varchar](10) NULL, --国内产品可用库存数量
	
	[item_id_g_gn2] [varchar](30) NULL,  --国内产品id
	[item_name_g_gn2] [varchar](30) NULL,  --国内产品name
    [sd_unit_price_g_gn2] [decimal](17, 6) NULL, --国内产品单价
    [sd_oq_g_gn2] [varchar](10) NULL, --国内产品数量
    [use_oq_g_gn2] [varchar](10) NULL, --国内产品可用库存数量
    
	[item_id_g_gn3] [varchar](30) NULL,  --国内产品id
	[item_name_g_gn3] [varchar](30) NULL,  --国内产品name
	[sd_unit_price_g_gn3] [decimal](17, 6) NULL, --国内产品单价
	[sd_oq_g_gn3] [varchar](10) NULL, --国内产品数量
	[use_oq_g_gn3 ] [varchar](10) NULL, --国内产品可用库存数量
	-- 电器产品id
	[item_id_d_gj1] [varchar](30) NULL,  --国际产品id
	[item_name_d_gj1] [varchar](30) NULL,  --国际产品name
	[sd_unit_price_d_gj1] [decimal](17, 6) NULL, --国际产品单价
	[sd_oq_d_gj1] [varchar](10) NULL, --国际产品数量
	[use_oq_d_gj1] [varchar](10) NULL, --国际产品可用库存数量
	
	[item_id_d_gj2] [varchar](30) NULL,  --国际产品id
	[item_name_d_gj2] [varchar](30) NULL,  --国际产品name
	[sd_unit_price_d_gj2] [decimal](17, 6) NULL, --国际产品单价
	[sd_oq_d_gj2] [varchar](10) NULL, --国际产品数量
	[use_oq_d_gj2] [varchar](10) NULL, --国际产品可用库存数量
	
	[item_id_d_gn1] [varchar](30) NULL,  --国内产品id
	[item_name_d_gn1] [varchar](30) NULL,  --国内产品name
	[sd_unit_price_d_gn1] [decimal](17, 6) NULL, --国内产品单价
	[sd_oq_d_gn1] [varchar](10) NULL, --国内产品数量
	[use_oq_d_gn1] [varchar](10) NULL, --国内产品可用库存数量
	
	[item_id_d_gn2] [varchar](30) NULL,  --国内产品id
	[item_name_d_gn2] [varchar](30) NULL,  --国内产品name
    [sd_unit_price_d_gn2] [decimal](17, 6) NULL, --国内产品单价
    [sd_oq_d_gn2] [varchar](10) NULL, --国内产品数量
    [use_oq_d_gn2] [varchar](10) NULL, --国内产品可用库存数量
	
	[item_id_d_gn3] [varchar](30) NULL,  --国内产品id
	[item_name_d_gn3] [varchar](30) NULL,  --国内产品name
	[sd_oq_d_gn3] [varchar](10) NULL, --国内产品数量
	[use_oq_d_gn3] [varchar](10) NULL, --国内产品可用库存数量
	[sd_unit_price_d_gn3] [decimal](17, 6) NULL, --国内产品单价
	
	[c_memo] [varchar](800) NULL,
	[mainten_clerk_id] [varchar](35) NULL,
	[mainten_datetime] [datetime] NULL
	CONSTRAINT [PK_SDD02010_saiyu] PRIMARY KEY CLUSTERED 
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--员工签到表
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ctl0080_sign]') AND type in (N'U'))
DROP TABLE [dbo].[ctl0080_sign]
GO
CREATE TABLE [dbo].[ctl0080_sign](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[clerk_id] [varchar](30) NOT NULL,--员工id
	[latitude] [varchar](30) NOT NULL,--纬度
	[longitude] [varchar](30) NULL,--经度
	[accuracy] [varchar](30) NULL,--位置精度
	[signTime] [datetime] NULL,--签到时间
	[address] [varchar](100) NULL, --地址
	[c_memo] [varchar](100) NULL --备注
	CONSTRAINT [ctl0080_sign] PRIMARY KEY CLUSTERED 
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
ON [PRIMARY]
GO
--维修记录主表
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SDd02020_saiyu]') AND type in (N'U'))
DROP TABLE [dbo].[SDd02020_saiyu]
GO
CREATE TABLE [dbo].[SDd02020_saiyu](
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,--维修记录编号 
	[sd_order_id] [varchar](30) NOT NULL,
	[customer_id] [varchar](30) NULL,-- 所属客户
	[repair_datetime] [datetime] NULL,--报修时间
	[pay_datetime] [datetime] NULL,--支付完成时间
	[yhsj_customer_id] [varchar](30)  NULL,--货运司机编码
	[dian_customer_id] [varchar](30)  NULL,--电工编码
	[order_je] [decimal](17, 6) NULL,--订单总金额
	[yf_je] [decimal](17, 6) NULL,--司机运费
	[dian_je] [decimal](17, 6) NULL,--电工安装金额
	
	[c_memo] [varchar](800) NULL,
	[mainten_clerk_id] [varchar](35) NULL,
	[mainten_datetime] [datetime] NULL
) ON [PRIMARY]

GO
--维修记录从表
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SDd02021_saiyu]') AND type in (N'U'))
DROP TABLE [dbo].[SDd02021_saiyu]
GO
CREATE TABLE [dbo].[SDd02021_saiyu](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,--维修记录编号
	[tj_oper_listing] [varchar](30) NOT NULL,--客户体检表关联
	[sd_order_id] [varchar](30) NOT NULL, 
	[customer_id] [varchar](30) NULL,--保修人
	[bx_customer_id] [varchar](30) NOT NULL,--报修客户编码
	[repair_datetime] [datetime] NULL,--报修时间
	[item_id] [char](40) NULL,--采购产品
	[sd_oq] [decimal](15, 6) NULL,--损坏数量
	[sd_unit_price] [decimal](17, 6) NULL,--采购单价
	[num] [decimal](15, 6)  NULL,--采购数量
	[work_state] [char](10) NULL,--报修中,已结束
	
	[c_memo] [varchar](800) NULL,
	[mainten_clerk_id] [varchar](35) NULL,
	[mainten_datetime] [datetime] NULL	
	CONSTRAINT [PK_SDD02021_saiyu] PRIMARY KEY CLUSTERED 
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sdf00504_saiyu]') AND type in (N'U'))
DROP TABLE [dbo].[Sdf00504_saiyu]
GO
CREATE TABLE [dbo].[Sdf00504_saiyu](
	[seeds_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[com_id] [char](50) NOT NULL,
	[customer_id] [varchar](30) NOT NULL,
	[self_id] [varchar](30) NULL,
	[easy_id] [varchar](40) NULL,
	[corp_sim_name] [varchar](40) NULL,
	[corp_name] [varchar](40) NULL,
	[regionalism_id] [varchar](30) NULL,
	[dept_id] [varchar](60) NULL,
	[tel_no] [varchar](40) NULL,
	[e_mail] [varchar](50) NULL,
	[working_status] [varchar](2) NULL,
	[corp_reps] [varchar](40) NULL,
	[working_range] [varchar](500) NULL,
	[bank_id] [varchar](50) NULL,
	[bank_accounts] [varchar](50) NULL,
	[clerk_id] [varchar](35) NULL,
	[corp_working_lisence] [varchar](30) NULL,
	[if_whole_lisence] [char](1) NULL,
	[pay_style] [varchar](20) NULL,
	[isclient] [char](1) NULL,
	[practice_date] [datetime] NULL,
	[star_cooperate_date] [datetime] NULL,
	[end_cooperate_date] [datetime] NULL,
	[shutout_date] [datetime] NULL,
	[memo] [varchar](50) NULL,
	[mainten_clerk_id] [varchar](35) NULL,
	[mainten_datetime] [datetime] NULL,
	[user_id] [varchar](30) NULL,
	[user_password] [varchar](32) NULL,
	[license_type] [varchar](10) NULL,
	[clerk_name] [varchar](40) NULL,
	[addr1] [varchar](80) NULL,
	[movtel] [varchar](30) NULL,
	[weixin] [varchar](30) NULL,
	[qq] [varchar](30) NULL,
	[accountSum] [decimal](28, 6) NULL,
	[weixinID] [varchar](30) NULL,
	[weixinStatus] [varchar](1) NULL,
	[idcard] [varchar](20) NULL,
	[openid] [varchar](40) NULL,
 CONSTRAINT [PK_Sdf00504_saiyu] PRIMARY KEY CLUSTERED 
(
	[com_id] ASC,
	[customer_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
---采购推荐表
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SDd02012_saiyu]') AND type in (N'U'))
DROP TABLE [dbo].[SDd02012_saiyu]
GO
CREATE TABLE [dbo].[SDd02012_saiyu](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,--客户体检表关联
	[customer_id] [varchar](30) NULL,--关联客户ID 
	[item_id] [char](40) NULL,--采购产品id
	[sd_unit_price] [decimal](17, 6) NULL,--采购单价
	[num] [decimal](15, 6)  NULL,--采购数量
	
	[c_memo] [varchar](800) NULL,
	[mainten_clerk_id] [varchar](35) NULL,
	[mainten_datetime] [datetime] NULL
	
	CONSTRAINT [PK_SDD02012_saiyu] PRIMARY KEY CLUSTERED 
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
---我要预约
IF not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_reservation]') AND type in (N'U'))
-- DROP TABLE [dbo].[t_reservation]
CREATE TABLE [dbo].[t_reservation](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,--商家(运营商)编号
	[ivt_oper_listing] [varchar](30) NOT NULL,--预约编号
	[customer_id] [varchar](30) NOT NULL,-- 消费者编号
	[item_id] [varchar](30) NOT NULL,-- 服务编号
	[clerk_id] [varchar](30) NOT NULL,-- 技师编号
	[m_flag] [char](1) NOT NULL,--  状态标识 -2记录已删除-1客户取消,0未确认,1商家确认
	[reservation_time] [datetime] NOT NULL,--预约时间 
	[mainten_clerk_id] [varchar](35) NULL,-- 记录修改成员编码
	[mainten_datetime] [datetime] NULL --记录修改时间
	
	CONSTRAINT [PK_t_reservation] PRIMARY KEY CLUSTERED 
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--客户内部审批流程  在原有基础上增加客户关联字段
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='customer_id')
  alter  table  OA_ctl03001   add  customer_id varchar(40) NULL
  else alter  table  OA_ctl03001 alter COLUMN customer_id varchar(40) NULL  -- 客户OA
go
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Sdf00504_saiyu' AND a.type = 'u'  and a.id=b.id  and b.name='idcard')
  alter  table  Sdf00504_saiyu   add  idcard varchar(20) NULL
  else alter  table  Sdf00504_saiyu alter COLUMN idcard varchar(20) NULL 
go
--客户内部审批流程  在原有基础上增加客户关联字段
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001_approval' AND a.type = 'u'  and a.id=b.id  and b.name='customer_id')
  alter  table  OA_ctl03001_approval   add  customer_id varchar(40) NULL
  else alter  table  OA_ctl03001_approval alter COLUMN customer_id varchar(40) NULL  -- 客户OA
go
--客户内部审批流程  在原有基础上增加客户关联字段
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='upper_customer_id')
  alter  table  OA_ctl03001   add  upper_customer_id varchar(40) NULL
  else alter  table  OA_ctl03001 alter COLUMN upper_customer_id varchar(40) NULL  -- 客户OA
go
--客户内部审批流程  在原有基础上增加客户关联字段
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001_approval' AND a.type = 'u'  and a.id=b.id  and b.name='upper_customer_id')
  alter  table  OA_ctl03001_approval   add  upper_customer_id varchar(40) NULL
  else alter  table  OA_ctl03001_approval alter COLUMN upper_customer_id varchar(40) NULL  -- 客户OA
go
--客户内部审批流程  在原有基础上增加客户关联字段
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001_approval' AND a.type = 'u'  and a.id=b.id  and b.name='headship')
  alter  table  OA_ctl03001_approval   add  headship varchar(40) NULL
  else alter  table  OA_ctl03001_approval alter COLUMN headship varchar(40) NULL  -- 客户OA职位信息
go

  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='headship')
  alter  table  OA_ctl03001   add  headship varchar(40) NULL
  else alter  table  OA_ctl03001 alter COLUMN headship varchar(40) NULL  -- 客户OA职位信息
go

--客户内部审批流程  是否推送结果通知
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001_approval' AND a.type = 'u'  and a.id=b.id  and b.name='noticeResult')
  alter  table  OA_ctl03001_approval   add  noticeResult char(2) NULL
  else alter  table  OA_ctl03001_approval alter COLUMN noticeResult char(2) NULL  -- 客户是否推送结果通知
go

  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'OA_ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='noticeResult')
  alter  table  OA_ctl03001   add  noticeResult char(2) NULL
  else alter  table  OA_ctl03001 alter COLUMN noticeResult char(2) NULL  -- 客户是否推送结果通知
go
--客户职位
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='headship')
alter  table  sdf00504   add  headship varchar(40) NULL
else alter  table  sdf00504 alter COLUMN headship varchar(40) NULL   
go
-- 备注
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
alter  table  sdf00504   add  c_memo varchar(100) NULL
else alter  table  sdf00504 alter COLUMN c_memo varchar(100) NULL   
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='weixinStatus')
alter  table  sdf00504   add  weixinStatus varchar(1) NULL
else alter  table  sdf00504 alter COLUMN weixinStatus varchar(1) NULL  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='weixinStatus')
alter  table  ctl00504   add  weixinStatus varchar(1) NULL
else alter  table  ctl00504 alter COLUMN weixinStatus varchar(1) NULL 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'ctl00801' AND a.type = 'u'  and a.id=b.id  and b.name='weixinStatus')
alter  table  ctl00801   add  weixinStatus varchar(1) NULL
else alter  table  ctl00801 alter COLUMN weixinStatus varchar(1) NULL  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='weixinID')
alter  table  sdf00504   add  weixinID varchar(40) NULL
else alter  table  sdf00504 alter COLUMN weixinID varchar(40) NULL  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='weixinID')
alter  table  ctl00504   add  weixinID varchar(40) NULL
else alter  table  ctl00504 alter COLUMN weixinID varchar(40) NULL  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'ctl00801' AND a.type = 'u'  and a.id=b.id  and b.name='weixinStatus')
alter  table  ctl00801   add  weixinID varchar(40) NULL
else alter  table  ctl00801 alter COLUMN weixinID varchar(40) NULL   
go
--客户部门
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='dept_name')
alter  table  sdf00504   add  dept_name varchar(40) NULL
else alter  table  sdf00504 alter COLUMN dept_name varchar(40) NULL  
go
--运营商所属地区
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'ctl00501' AND a.type = 'u'  and a.id=b.id  and b.name='regionalism_name')
alter  table  ctl00501   add  regionalism_name varchar(50) NULL
else alter  table  ctl00501 alter COLUMN regionalism_name varchar(40) NULL  --  运营商所属地区
go
--运营商行业类型
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
WHERE a.name = 'ctl00501' AND a.type = 'u'  and a.id=b.id  and b.name='trade_type')
alter  table  ctl00501   add  trade_type varchar(20) NULL
else alter  table  ctl00501 alter COLUMN trade_type varchar(20) NULL  --  运营商行业类型
go
 --采购订单作废
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'std02001' AND a.type = 'u'  and a.id=b.id  and b.name='m_flag')
  alter  table  std02001   add  m_flag char(1) NULL DEFAULT 0  -- 默认为0不作废,为1作废,2-已处理,3-无货,4已发货,5已收货
  else alter  table  std02001 alter COLUMN m_flag char(1) NULL  -- 采购订单作废
go
 --销售订单作废
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02021' AND a.type = 'u'  and a.id=b.id  and b.name='m_flag')
  alter  table  sdd02021   add  m_flag char(1) NULL DEFAULT 0  -- 默认为0-未支付提成,1-已支付提成
  else alter  table  sdd02021 alter COLUMN m_flag char(1) NULL  -- 销售订单作废
go
 --销售订单-已发货
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02021' AND a.type = 'u'  and a.id=b.id  and b.name='shipped')
  alter  table  sdd02021   add  shipped varchar(6) NULL DEFAULT 0  -- 标识已发货
  else alter  table  sdd02021 alter COLUMN shipped varchar(6) NULL  -- 标识已发货
go
 --报价单标识
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02011' AND a.type = 'u'  and a.id=b.id  and b.name='m_flag')
  alter  table  sdd02011   add  m_flag char(1) NULL DEFAULT 0  -- 默认为0-使用,1-删除
  else alter  table  sdd02011 alter COLUMN m_flag char(1) NULL  -- 报价单标识
go
 --报价单客户对应产品名称
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02011' AND a.type = 'u'  and a.id=b.id  and b.name='client_item_name')
  alter  table  sdd02011   add  client_item_name varchar(50) NULL
  else alter  table  sdd02011 alter COLUMN client_item_name varchar(50) NULL
go

 --销售订单从表与采购订单表关联
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02021' AND a.type = 'u'  and a.id=b.id  and b.name='st_hw_no')
  alter  table  sdd02021   add  st_hw_no varchar(30) NULL  -- 采购订单号
  else alter  table  sdd02021 alter COLUMN st_hw_no varchar(30) NULL  -- 采购订单号
go
 -- 体检表与报修单号关联
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02010_saiyu' AND a.type = 'u'  and a.id=b.id  and b.name='bx_oper_listing')
  alter  table  SDd02010_saiyu   add  bx_oper_listing varchar(30) NULL  -- 报修单号
  else alter  table  SDd02010_saiyu alter COLUMN bx_oper_listing varchar(30) NULL  -- 报修单号
go
/////////////////////////////////////////
 --客户对账单签收确认
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARd02051' AND a.type = 'u'  and a.id=b.id  and b.name='qianming')
  alter  table  ARd02051   add  qianming varchar(100) NULL  -- 默认为0未签字确认,为1签字确认 
  else alter  table  ARd02051 alter COLUMN qianming varchar(100) NULL
go
 --客户对账单签收确认时间
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARd02051' AND a.type = 'u'  and a.id=b.id  and b.name='qianmingTime')
  alter  table  ARd02051   add  qianmingTime datetime NULL   
  else alter  table  ARd02051 alter COLUMN qianmingTime datetime NULL  
go
 --客户对账单签收确认-期初应收
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARf02030' AND a.type = 'u'  and a.id=b.id  and b.name='qianming')
  alter  table  ARf02030   add  qianming varchar(100) NULL  -- 默认为0未签字确认,为1签字确认 
  else alter  table  ARf02030 alter COLUMN qianming varchar(100) NULL
go
 --客户对账单签收确认时间-期初应收
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARf02030' AND a.type = 'u'  and a.id=b.id  and b.name='qianmingTime')
  alter  table  ARf02030   add  qianmingTime datetime NULL   
  else alter  table  ARf02030 alter COLUMN qianmingTime datetime NULL  
go
 --客户对账单签收确认-呆坏帐处理
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARfM02010' AND a.type = 'u'  and a.id=b.id  and b.name='qianming')
  alter  table  ARfM02010   add  qianming varchar(100) NULL  -- 默认为0未签字确认,为1签字确认 
  else alter  table  ARfM02010 alter COLUMN qianming varchar(100) NULL
go
 --客户对账单签收确认时间-呆坏帐处理
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARfM02010' AND a.type = 'u'  and a.id=b.id  and b.name='qianmingTime')
  alter  table  ARfM02010   add  qianmingTime datetime NULL   
  else alter  table  ARfM02010 alter COLUMN qianmingTime datetime NULL  
go

 --订单从表签收确认
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02021' AND a.type = 'u'  and a.id=b.id  and b.name='qianming')
  alter  table  sdd02021   add  qianming varchar(100) NULL  -- 默认为0未签字确认,为1签字确认 
  else alter  table  sdd02021 alter COLUMN qianming varchar(100) NULL  
go
 --订单从表签收确认时间
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02021' AND a.type = 'u'  and a.id=b.id  and b.name='qianmingTime')
  alter  table  sdd02021   add  qianmingTime datetime NULL   
  else alter  table  sdd02021 alter COLUMN qianmingTime datetime NULL  
go
 --订单从表签收确认
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02020' AND a.type = 'u'  and a.id=b.id  and b.name='qianming')
  alter  table  sdd02020   add  qianming varchar(100) NULL  -- 默认为0未签字确认,为1签字确认 
  else alter  table  sdd02020 alter COLUMN qianming varchar(100) NULL  
go
 --订单从表签收确认时间
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02020' AND a.type = 'u'  and a.id=b.id  and b.name='qianmingTime')
  alter  table  sdd02020   add  qianmingTime datetime NULL   
  else alter  table  sdd02020 alter COLUMN qianmingTime datetime NULL  
go
/////////////////////////////////////////////////////////////////
 --客户来源
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='c_source')
  alter  table  sdf00504   add  c_source varchar(100) NULL
  else alter  table  sdf00504 alter COLUMN c_source varchar(100) NULL
go
 --供应商物流消息
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'std02001' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  std02001   add  c_memo varchar(300) NULL 
  else alter  table  std02001 alter COLUMN c_memo varchar(300)   NULL  
go 

 --安装费
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='AZTS_free')
  alter  table  ctl03001   add  AZTS_free decimal(17, 6) NULL   
  else alter  table  ctl03001 alter COLUMN AZTS_free decimal(17, 6) NULL  
go
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='cover_img')
  alter  table  ctl03001   add  cover_img char(1) NULL   
  else alter  table  ctl03001 alter COLUMN cover_img char(1) NULL  
go
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='main_img')
  alter  table  ctl03001   add  main_img char(1) NULL   
  else alter  table  ctl03001 alter COLUMN main_img char(1) NULL  
go
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='detail_cms')
  alter  table  ctl03001   add  detail_cms char(1) NULL   
  else alter  table  ctl03001 alter COLUMN detail_cms char(1) NULL  
go
 --电工状态
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02021' AND a.type = 'u'  and a.id=b.id  and b.name='elecState')
  alter  table  sdd02021   add  elecState int NULL   -- 0-未预约,1-已预约,2-已安装,3-已支付,4-已确认评价
  else alter  table  sdd02021 alter COLUMN elecState int NULL  
go 
   --客户登录时间
 IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='loginTime')
  alter  table  sdf00504   add  loginTime datetime NULL   -- 客户登录时间
  else alter  table  sdf00504 alter COLUMN loginTime datetime NULL  
go

 View_sdd02020+st_hw_no   View_demand  [sp_SellAdduPQry  beizhu,c_memo varchar(800)]

alter  table  sdf00504 alter COLUMN corp_name varchar(200) NULL  
alter  table  sdf00504 alter COLUMN corp_sim_name varchar(200) NULL  

alter  table  sdf00504 alter COLUMN customer_id varchar(100) NULL  
alter  table  sdf00504 alter COLUMN upper_customer_id varchar(100) NULL  
alter  table  sdf00504 alter COLUMN self_id varchar(100) NULL  
alter  table  sdf00504 alter COLUMN headship varchar(300) NULL  
alter  table  ctl00801 alter COLUMN headship varchar(300) NULL 
alter  table  sdd02020 alter COLUMN customer_id varchar(100) NULL  
alter  table  sdd02021 alter COLUMN customer_id varchar(100) NULL  
alter  table  sdd02021 alter COLUMN transport_AgentClerk_Reciever varchar(100) NULL  
alter  table  ARd02051 alter COLUMN customer_id varchar(100) NULL  
alter  table  sdd02011 alter COLUMN customer_id varchar(100) NULL  
alter  table  sdd02010 alter COLUMN customer_id varchar(100) NULL  
alter  table  SDd02010_saiyu alter COLUMN customer_id varchar(100) NULL
alter  table  SDd02010_saiyu alter COLUMN item_name_g_gj1 varchar(100) NULL
alter  table  SDd02010_saiyu alter COLUMN item_name_g_gj2 varchar(100) NULL
alter  table  SDd02010_saiyu alter COLUMN item_name_g_gn1 varchar(100) NULL
alter  table  SDd02010_saiyu alter COLUMN item_name_g_gn2 varchar(100) NULL
alter  table  SDd02010_saiyu alter COLUMN item_name_g_gn3 varchar(100) NULL
alter  table  SDd02010_saiyu alter COLUMN item_name_d_gj1 varchar(100) NULL  
alter  table  SDd02010_saiyu alter COLUMN item_name_d_gj2 varchar(100) NULL  
alter  table  SDd02010_saiyu alter COLUMN item_name_d_gn1 varchar(100) NULL  
alter  table  SDd02010_saiyu alter COLUMN item_name_d_gn2 varchar(100) NULL  
alter  table  SDd02010_saiyu alter COLUMN item_name_d_gn3 varchar(100) NULL  


alter  table  ctl00801 alter COLUMN work_id varchar(100) NULL  

alter  table  SDd02010_saiyu alter COLUMN item_name varchar(100) NULL

alter  table  OA_ctl03001 alter COLUMN customer_id varchar(100) NULL 
alter  table  OA_ctl03001 alter COLUMN upper_customer_id varchar(100) NULL  
alter  table  OA_ctl03001_approval alter COLUMN customer_id varchar(100) NULL  
alter  table  OA_ctl03001_approval alter COLUMN upper_customer_id varchar(100) NULL
alter  table  OA_ctl03001_approval alter COLUMN OA_who varchar(200) NULL  
alter  table  OA_ctl03001_approval alter COLUMN OA_whom varchar(200) NULL    
alter  table  OA_ctl03001_approval alter COLUMN headship varchar(300) NULL
alter  table  OA_ctl03001_approval alter COLUMN upper_customer_id varchar(100) NULL  

alter  table  SDd02020_saiyu alter COLUMN customer_id varchar(100) NULL  
alter  table  SDd02021_saiyu alter COLUMN customer_id varchar(100) NULL  
alter  table  SDd02012_saiyu alter COLUMN customer_id varchar(100) NULL  
alter  table  demand_saiyu alter COLUMN customer_id varchar(100) NULL  
alter  table  upaddress_saiyu alter COLUMN customer_id varchar(100) NULL 
alter  table  ARfM02010 alter COLUMN customer_id varchar(100) NULL 
alter  table  ARf02030 alter COLUMN customer_id varchar(100) NULL 
alter  table  sdd02022 alter COLUMN customer_id varchar(100) NULL 


--客户所属司机2016-04-13
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='driveId')
  alter  table  sdf00504   add  driveId varchar(100) NULL 
  else alter  table  sdf00504 alter COLUMN driveId varchar(100) NULL  
--订单跟踪流程中每一步客户对应消息接收人2016-04-11
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='orderStepRecipient')
  alter  table  sdf00504   add  orderStepRecipient varchar(100) NULL 
  else alter  table  sdf00504 alter COLUMN orderStepRecipient varchar(100) NULL 
  --性别 2016-04-19
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='sex')
  alter  table  sdf00504   add  sex char(2) NULL 
  else alter  table  sdf00504 alter COLUMN sex char(2) NULL
  ---客户支付订单百分比
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdf00504' AND a.type = 'u'  and a.id=b.id  and b.name='payPercentage')
  alter  table  sdf00504   add  payPercentage varchar(5) NULL  DEFAULT '100'
  else alter  table  sdf00504 alter COLUMN payPercentage varchar(5) NULL DEFAULT '100'
  
--订单跟踪流程中每一步员工对应消息接收人2016-04-11
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00801' AND a.type = 'u'  and a.id=b.id  and b.name='orderStepRecipient')
  alter  table  ctl00801   add  orderStepRecipient varchar(100) NULL
  else alter  table  ctl00801 alter COLUMN orderStepRecipient varchar(100) NULL
  
  ---公告信息表
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_notice_info]') AND type in (N'U'))
CREATE TABLE [dbo].[t_notice_info](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[clerk_id] [varchar](30) NOT NULL,
	[clerk_name] [varchar](30) NOT NULL,
	[notice_title] [varchar](100) NULL,
	[notice_content] [varchar](500) NULL,
	[notice_time] [datetime] NULL
	CONSTRAINT [PK_t_notice_info] PRIMARY KEY CLUSTERED
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
---德阳通威预售表
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Pre_Trading]') AND type in (N'U'))
CREATE TABLE [dbo].[t_Pre_Trading](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,-- 预售预购记录编号
	[item_id] [varchar](30) NOT NULL,-- 內杂猪->仔猪,商品猪->10-20KG
	[customer_id] [varchar](100) NOT NULL,-- 预售养殖户,收购商
	[address] [varchar](100) NULL,--地址
	[latlng] [varchar](40) NULL,--坐标
	[sd_oq] [int] NOT NULL,-- 预售或预购数量
	[jiaoyi_num] [int] NOT NULL,-- 已交易数量
	[sd_unit_price] [decimal](17, 6) NOT NULL, --挂价 仔猪按头计
	[selling_price] [decimal](17, 6) NULL, --卖出价 
	[guajia_datetime] [datetime] NOT NULL, --挂价时间
	[mainten_clerk_id] [varchar](35) NOT NULL,--维护人
	[mainten_datetime] [datetime] NOT NULL --维护时间
	CONSTRAINT [PK_t_Pre_Trading] PRIMARY KEY CLUSTERED
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--订单跟踪流程中每一步员工对应消息接收人2016-04-11
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 't_Pre_Trading' AND a.type = 'u'  and a.id=b.id  and b.name='address')
  alter  table  t_Pre_Trading   add  address varchar(100) NULL
  else alter  table  t_Pre_Trading alter COLUMN address varchar(100) NULL

  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 't_article' AND a.type = 'u' and a.id=b.id and b.name='show')
  alter table t_article add show varchar(5) NULL
  else alter  table  t_article alter COLUMN show varchar(5) NULL
  
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 't_Pre_Trading' AND a.type = 'u'  and a.id=b.id  and b.name='latlng')
  alter  table  t_Pre_Trading   add  latlng varchar(40) NULL
  else alter  table  t_Pre_Trading alter COLUMN latlng varchar(40) NULL
-- 交易记录主表 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sdd02030]') AND type in (N'U'))
CREATE TABLE [dbo].[sdd02030](
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,-- 交易记录编号
	[item_id] [varchar](30) NULL,-- 猪种 內杂猪->仔猪
	[sg_num] [int] NOT NULL,-- 收购方交易总数量 收购数量
	[mc_num] [int] NOT NULL,-- 养殖户交易总数量 卖出数量
	[buy_unit_price] [decimal](17, 6) NOT NULL, -- 收购均价
	[selling_price] [decimal](17, 6) NOT NULL, -- 卖出均价
	[cuohe_datetime] [datetime] NOT NULL, -- 撮合时间
	[mainten_clerk_id] [varchar](35) NOT NULL,--维护人
	[mainten_datetime] [datetime] NOT NULL --维护时间
	CONSTRAINT [PK_sdd02030] PRIMARY KEY CLUSTERED
(
	[com_id] ASC,
	[ivt_oper_listing] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- 交易记录从表 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sdd02031]') AND type in (N'U'))
CREATE TABLE [dbo].[sdd02031](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](30) NOT NULL,-- 交易记录编号
	[item_id] [varchar](30) NOT NULL,-- 內杂猪->仔猪,商品猪->10-20KG
	[customer_id] [varchar](100) NOT NULL,-- 预售养殖户编码
	[pre_trading_no] [varchar](30) NOT NULL,-- 预售记录编号
	[sd_oq] [int] NOT NULL,-- 交易数量
	[sd_unit_price] [decimal](17, 6) NOT NULL, -- 交易价格
	[cuohe_datetime] [datetime] NOT NULL, -- 撮合时间
	[confirm_datetime] [datetime] NULL, -- 养殖户确认时间
	-- ---------------
	[buyer_id] [varchar](30) NOT NULL,-- 收购方编码
	[buyer_sd_oq] [int] NOT NULL,-- 收购数量
	[buyer_sd_unit_price] [decimal](17, 6) NOT NULL, -- 收购价格
	[buyer_pre_trading_no] [varchar](30) NOT NULL,-- 预售记录编号
	
	[buyer_confirm_datetime] [datetime] NULL, -- 收购方确认时间
	[m_flag] [char](1) NOT NULL --  状态  0-双方未确认,1-养殖户确认,2-收购方确认,3-双方已确认
	CONSTRAINT [PK_sdd02031] PRIMARY KEY CLUSTERED
(
	[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'sdd02031' AND a.type = 'u'  and a.id=b.id  and b.name='buyer_pre_trading_no')
  alter  table  sdd02031   add  buyer_pre_trading_no varchar(30) NULL
  else alter  table  sdd02031 alter COLUMN buyer_pre_trading_no varchar(30) NULL
  
-- 供应商上报价格 DROP TABLE [dbo].[stdM02010]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stdM02010]') AND type in (N'U'))
CREATE TABLE [dbo].[stdM02010](
[com_id] [char](10) NOT NULL,
[ivt_oper_listing] [varchar](30) NOT NULL,-- 上报记录编号
[item_id] [varchar](30) NOT NULL,--产品
[ware_num] [decimal](17, 6) NOT NULL,--库存
[price] [decimal](17, 6) NOT NULL,-- 价格
[up_datetime] [datetime] NOT NULL,--上报时间
[vendor_id] [varchar](30) NOT NULL,--上报供应商
[m_flag] [char](1) NOT NULL-- 0-验证中,1-验证通过,2验证失败,
CONSTRAINT [PK_stdM02010] PRIMARY KEY CLUSTERED
(   [com_id] ASC,
	[ivt_oper_listing] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- 产品浏览记录表
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ctl03010]') AND type in (N'U'))
CREATE TABLE [dbo].[Ctl03010](
[seeds_id] [int] IDENTITY(1,1) NOT NULL,
[com_id] [char](10) NOT NULL,
[item_id] [varchar](30) NOT NULL,--产品
[view_time] [datetime] NOT NULL,--浏览时间
[customer_id] [varchar](100) NOT NULL,--浏览客户  document.referrer
[view_address] [varchar](100) NULL,-- IP地址所属物理地址
[view_ip] [varchar](20) NOT NULL-- 浏览器产品时的IP地址
CONSTRAINT [PK_Ctl03010] PRIMARY KEY CLUSTERED
(
[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- 微信服务号模板
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_weixin_template]') AND type in (N'U'))
CREATE TABLE [dbo].[t_weixin_template](
[seeds_id] [int] IDENTITY(1,1) NOT NULL,
[com_id] [char](10) NOT NULL,
[template_id] [varchar](50) NOT NULL,--模板id
[title] [varchar](100) NOT NULL,-- 模板标题
[content] [varchar](300) NULL-- 模板内容
CONSTRAINT [PK_t_weixin_template] PRIMARY KEY CLUSTERED
(
[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- 客户拜访记录
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sdf00504_visit]') AND type in (N'U'))
CREATE TABLE [dbo].[sdf00504_visit](
[seeds_id] [int] IDENTITY(1,1) NOT NULL,
[com_id] [char](10) NOT NULL,
[customer_id] [varchar](100) NOT NULL,-- 客户编码
[visitContent] [varchar](100) NOT NULL,-- 拜访描述
[visitResult] [varchar](30) NULL,-- 拜访结果
[visitTime] [datetime] not NULL,-- 拜访时间
[mainten_clerk_id] [varchar](30) NULL,-- 维护人员
[maintenance_datetime] [datetime] not NULL-- 维护时间
CONSTRAINT [PK_sdf00504_visit] PRIMARY KEY CLUSTERED
(
[seeds_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- 首页文章信息存放表
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_article]') AND type in (N'U'))
CREATE TABLE [dbo].[t_article](
[id] [int] IDENTITY(1,1) NOT NULL,
[com_id] [char](10) NOT NULL,
[projectName] [varchar](30) NOT NULL,-- 项目名称p1,p2...
[htmlname] [varchar](100) NULL,-- 
[publisher] [varchar](30) NULL,-- 发布人
[clerk_id] [varchar](30) NULL,-- 所属员工
[zhiding] [char](1) NULL DEFAULT 0,-- 置顶 0-不置顶,1-置顶
[filetype] [char](1) NULL DEFAULT 0,-- 图文或者视频 0-图文,1-视频
[projectType] [char](2) NULL DEFAULT 0,-- 图文或者视频 2-案例,1-口碑,3-服务
[title] [varchar](200) NOT NULL,-- 标题
[gjc] [varchar](200) NULL,--关键词
[img] [varchar](100) NULL,--封面图
[poster] [varchar](30) NULL,--视频封面图
[releaseTime] [datetime] NULL,-- 发布时间
[mainten_clerk_id] [varchar](30) NULL,-- 维护人员
[maintenance_datetime] [datetime] not NULL-- 维护时间
CONSTRAINT [PK_t_article] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 't_article' AND a.type = 'u' and a.id=b.id and b.name='projectName')
  alter table t_article add projectName varchar(30) NULL
  else alter  table  t_article alter COLUMN projectName varchar(30) NULL
  
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 't_article' AND a.type = 'u' and a.id=b.id and b.name='publisher')
  alter table t_article add publisher varchar(40) NULL
  else alter  table  t_article alter COLUMN publisher varchar(40) NULL
  
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD02001' AND a.type = 'u' and a.id=b.id and b.name='mps_id')
  alter table STD02001 add mps_id varchar(30) NULL
  else alter  table  STD02001 alter COLUMN mps_id varchar(30) NULL
  
  IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 't_article' AND a.type = 'u' and a.id=b.id and b.name='img')
  alter table t_article add img varchar(100) NULL
  else alter  table  t_article alter COLUMN img varchar(100) NULL
-- 文章阅读记录
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_ganzhi]') AND type in (N'U'))
CREATE TABLE [dbo].[t_ganzhi](
[id] [varchar] (17) NOT NULL,
[com_id] [char](10) NOT NULL,
[corp_name] [varchar](30) NULL, 
[article_name] [varchar](100) NULL, 
[article_id] [varchar](100) NULL, 
[read_time] [datetime] not NULL, 
[end_time] [datetime] NULL, 
[clerk_id] [varchar](30) NULL,-- 所属员工
[ip] [varchar](30) NULL,
[userid] [varchar](32) NULL
CONSTRAINT [PK_t_ganzhi] PRIMARY KEY CLUSTERED
(
 [com_id] ASC,
[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- 微信服务号消息模板
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_weixin_template]') AND type in (N'U'))
CREATE TABLE [dbo].[t_weixin_template](
[com_id] [char](10) NOT NULL,
[title] [varchar](30) NULL, 
[template_id] [varchar](100) NULL, 
--[primary_industry] [varchar](30) NULL, 
--[deputy_industry] [varchar](30) NULL, 
[content] [varchar](30) NULL
CONSTRAINT [PK_t_weixin_template] PRIMARY KEY CLUSTERED
(
 [com_id] ASC,
[template_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sdf00504_jinbi]') AND type in (N'U'))
CREATE TABLE [dbo].[sdf00504_jinbi](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[customer_id] [varchar](100) NOT NULL, <!-- 客户内编码 -->
	[f_num] [int] NOT NULL DEFAULT 0, <!-- 获取或者消费数量 -->
	[f_time] [datetime] NOT NULL,<!-- 消费或者获取时间 -->
	[f_source] [varchar](10) NOT NULL, <!-- 金币来源:签到,分享,评价 -->
	[orderNo] [varchar](30) NULL, <!-- 存储消费时的订单编号 -->
	[c_memo] [varchar](100) NULL, <!--   -->
	[flag] [int] NOT NULL DEFAULT 0 <!-- 消费时暂存标志,0-等于正式,1-等于暂存  -->	
	CONSTRAINT [PK_sdf00504_jinbi] PRIMARY KEY CLUSTERED 
([seeds_id] ASC)
<!-- WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) --> 
ON [PRIMARY]) ON [PRIMARY];
-- 优惠券
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[t_coupon]') AND type in (N'U'))
CREATE TABLE [dbo].[t_coupon](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[ivt_oper_listing] [varchar](100) NOT NULL, <!-- 优惠券编码 -->
	[type_id] [varchar](100) NULL, <!-- 限制购买对应产品类别编码  为空为全品类-->
	[f_amount] [int] NOT NULL DEFAULT 0, <!-- 优惠券金额-->
	[up_amount] [int] NOT NULL DEFAULT 0, <!-- 优惠券使用金额 -->
	[create_time] [datetime] NOT NULL,<!-- 优惠券创建时间 -->
	[begin_use_date] [datetime] NOT NULL,<!-- 优惠券开始使用时间 -->
	[end_use_date] [datetime] NOT NULL<!-- 优惠券结束使用时间 -->
	CONSTRAINT [PK_t_coupon] PRIMARY KEY CLUSTERED 
([seeds_id] ASC)
<!-- WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) --> 
ON [PRIMARY]) ON [PRIMARY];
-- 客户优惠券记录
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sdf00504_coupon]') AND type in (N'U'))
CREATE TABLE [dbo].[sdf00504_coupon](
	[seeds_id] [int] IDENTITY(1,1) NOT NULL,
	[com_id] [char](10) NOT NULL,
	[customer_id] [varchar](100) NOT NULL, <!-- 客户编码 -->
	[ivt_oper_listing] [varchar](30) NOT NULL, <!-- 优惠券编码 -->
	[orderNo] [varchar](100) NULL, <!-- 对应订单编码 -->
	[get_time] [datetime] NOT NULL,<!-- 优惠券获取时间 -->
	[use_time] [datetime] NULL,<!-- 优惠券使用时间 -->
	[f_type] [int] NOT NULL DEFAULT 0 <!-- 是否使用 0-未使用,1-已使用,2-已过期 -->
	CONSTRAINT [PK_sdf00504_coupon] PRIMARY KEY CLUSTERED 
([seeds_id] ASC)
<!-- WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) --> 
ON [PRIMARY]) ON [PRIMARY];
 