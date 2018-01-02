--生产
--委托加工
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Yie05010]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[Yie05010] (
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[ivt_oper_listing] [varchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sd_order_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[finacial_y] [int] NULL ,
	[finacial_m] [tinyint] NULL ,
	[send_date] [datetime] NULL ,
	[dept_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[fee_sum] [decimal](17, 6) NULL ,
	[comfirm_flag] [char] (1) COLLATE Chinese_PRC_CI_AS NULL ,
	[count_flag] [char] (1) COLLATE Chinese_PRC_CI_AS NULL ,
	[ivt_oper_cfm] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[ivt_oper_cfm_time] [datetime] NULL ,
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL ,
	[c_memo] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Yie05011]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[Yie05011] (
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[ivt_oper_listing] [varchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sno] [int] NULL ,
	[item_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[peijian_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[item_code] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[work_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[lead_oq] [decimal](17, 6) NULL ,
	[unit_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[store_struct_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[c_memo] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[cost_price] [decimal](17, 6) NULL ,
	[customer_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[PH] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[if_anomaly] [varchar] (4) COLLATE Chinese_PRC_CI_AS NULL ,
	[lot_number] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[item_type] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[item_color] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[class_card] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[i_weight] [decimal](17, 6) NULL ,
	[memo_other] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[memo_color] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[mps_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[mps_seeds_id] [int] NULL ,
	[item_struct] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Yie05012]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[Yie05012] (
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[ivt_oper_listing] [varchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sno] [int] NULL ,
	[item_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[syieno] [int] NULL ,
	[yieitem_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[peijian_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[lead_oq] [decimal](17, 6) NULL ,
	[i_dosage] [decimal](13, 4) NULL ,
	[cost_price] [decimal](17, 6) NULL ,
	[store_struct_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[c_memo] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[work_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[item_code] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[customer_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[PH] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05010' AND a.type = 'u'  and a.id=b.id  and b.name='vendor_id')
  alter  table  Yie05010 add  vendor_id varchar(30) null
  else alter  table  Yie05010 alter COLUMN vendor_id varchar(30) null --委托加工单供应商内码 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='oper_price')
  alter  table  Yie05011 add  oper_price decimal(28,6) null
  else alter  table  Yie05011 alter COLUMN oper_price decimal(28,6) null --委托加工单产品成本价 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='plan_price')
  alter  table  Yie05011 add  plan_price decimal(28,6) null
  else alter  table  Yie05011 alter COLUMN plan_price decimal(28,6) null --委托加工单产品成本金额
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='oper_price_Materials')
  alter  table  Yie05011 add  oper_price_Materials decimal(28,6) null
  else alter  table  Yie05011 alter COLUMN oper_price_Materials decimal(28,6) null --委托加工单产品表中的材料成本单价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='plan_price_Materials')
  alter  table  Yie05011 add  plan_price_Materials decimal(28,6) null
  else alter  table  Yie05011 alter COLUMN plan_price_Materials decimal(28,6) null --委托加工单产品表中的材料成本金额
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='oper_price_Fee')
  alter  table  Yie05011 add  oper_price_Fee decimal(28,6) null
  else alter  table  Yie05011 alter COLUMN oper_price_Fee decimal(28,6) null --委托加工单产品表中的加工单价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='st_detail_id')
  alter  table  Yie05011 add  st_detail_id int null
  else alter  table  Yie05011 alter COLUMN st_detail_id int null --委托加工单产品中的采购订单产品表的行种子
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05011' AND a.type = 'u'  and a.id=b.id  and b.name='st_auto_no')
  alter  table  Yie05011 add  st_auto_no varchar(30) null
  else alter  table  Yie05011 alter COLUMN st_auto_no varchar(30) null --委托加工单产品中的产品采购订单号
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05012' AND a.type = 'u'  and a.id=b.id  and b.name='oper_price')
  alter  table  Yie05012 add  oper_price decimal(28,6) null
  else alter  table  Yie05012 alter COLUMN oper_price decimal(28,6) null --委托加工单材料表中的材料成本单价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05012' AND a.type = 'u'  and a.id=b.id  and b.name='plan_price')
  alter  table  Yie05012 add  plan_price decimal(28,6) null
  else alter  table  Yie05012 alter COLUMN plan_price decimal(28,6) null --委托加工单材料表中的材料成本金额
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Yie05012' AND a.type = 'u'  and a.id=b.id  and b.name='seeds_id_Yie05011')
  alter  table  Yie05012 add  seeds_id_Yie05011 int null
  else alter  table  Yie05012 alter COLUMN seeds_id_Yie05011 int null --委托加工单材料表中的委托加工产品表的行种子
go

