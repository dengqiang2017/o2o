--【周报-分型号及办事处的销量及库存汇总表】的数据表 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Data_Report_Customize_Sales_ItemtypeAndRegionalism]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Data_Report_Customize_Sales_ItemtypeAndRegionalism]
GO
CREATE TABLE [dbo].[Data_Report_Customize_Sales_ItemtypeAndRegionalism] (
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL ,
	[C_ZXFZ_01] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_02] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_03] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_04] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_05] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_06] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXHZ_1_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_HXJS_01] [decimal](28, 6) NULL ,
	[C_HXJS_02] [decimal](28, 6) NULL ,
	[C_HXJS_03] [decimal](28, 6) NULL ,
	[C_HXJS_04] [decimal](28, 6) NULL ,
	[C_HXJS_05] [decimal](28, 6) NULL ,
	[C_HXJS_06] [decimal](28, 6) NULL ,
	[C_FSSJ_01] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_02] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_03] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_04] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_05] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_06] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

--【报表列取数定义-周报-分型号及办事处的销量及库存汇总表】列定义
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Customize_Sales_ItemtypeAndRegionalism]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Customize_Sales_ItemtypeAndRegionalism]
GO
CREATE TABLE [dbo].[Customize_Sales_ItemtypeAndRegionalism] 
(  
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[serial_no] [int] NULL ,                                        --本表排列顺序
	[self_type] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,     --列类型
	[self_id] [int] NULL ,                                          --列类型列次
	[table_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --列所对应的表名
	[field_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --列所对应的字段值对应的内码
	[field_value] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --列所对应的字段值
	[field_Datasource] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --列所对应的字段值的数据源
	[field_formula] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL ,     --列值的取数公式
	[working_status] [varchar] (2) COLLATE Chinese_PRC_CI_AS NULL ,  --列的使用状态：'是'或'否'
	[field_title] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,   --列所对应的字段的表头标题栏
	[field_row_num] [int] NULL ,                                     --表头行数
	[field_name_target] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,   --目标列字段名
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO

--【周报-分品牌产品类别及办事处的销售额汇总表】的数据表
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Data_Report_Customize_Sales_vendorIDtypeIDAndRegionalism]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Data_Report_Customize_Sales_vendorIDtypeIDAndRegionalism]
GO
CREATE TABLE [dbo].[Data_Report_Customize_Sales_vendorIDtypeIDAndRegionalism] (
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL ,
	[C_ZXFZ_01] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_02] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_03] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_04] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_05] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXFZ_06] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_ZXHZ_1_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_1_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_2_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_3_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_4_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_5_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_6_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_7_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_8_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_9_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_10_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_11_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_12_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_13_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_14_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_15_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_16_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_17_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_18_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_19_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_20_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_21_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_22_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_23_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_24_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_25_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_26_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_27_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_28_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_29_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_01] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_02] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_03] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_04] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_05] [decimal](28, 6) NULL ,
	[C_ZXHZ_30_C_HXJS_06] [decimal](28, 6) NULL ,
	[C_HXJS_01] [decimal](28, 6) NULL ,
	[C_HXJS_02] [decimal](28, 6) NULL ,
	[C_HXJS_03] [decimal](28, 6) NULL ,
	[C_HXJS_04] [decimal](28, 6) NULL ,
	[C_HXJS_05] [decimal](28, 6) NULL ,
	[C_HXJS_06] [decimal](28, 6) NULL ,
	[C_FSSJ_01] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_02] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_03] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_04] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_05] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,
	[C_FSSJ_06] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

--【报表列取数定义-周报-分品牌产品类别及办事处的销售额汇总表】列定义
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Customize_Sales_vendorIDtypeIDAndRegionalism]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Customize_Sales_vendorIDtypeIDAndRegionalism]
GO
CREATE TABLE [dbo].[Customize_Sales_vendorIDtypeIDAndRegionalism] 
(  
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[serial_no] [int] NULL ,                                        --本表排列顺序
	[self_type] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,     --列类型
	[self_id] [int] NULL ,                                          --列类型列次
	[table_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --列所对应的表名
	[field_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --列所对应的字段值对应的内码
	[field_value] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --列所对应的字段值
	[field_Datasource] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --列所对应的字段值的数据源
	[field_formula] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL ,     --列值的取数公式
	[working_status] [varchar] (2) COLLATE Chinese_PRC_CI_AS NULL ,  --列的使用状态：'是'或'否'
	[field_title] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,   --列所对应的字段的表头标题栏
	[field_row_num] [int] NULL ,                                     --表头行数
	[field_name_target] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,   --目标列字段名
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO

--添加表说明
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='ctl03001'  and not isnull(f.value,'')='物品表'  
) >0
exec sp_addextendedproperty N'MS_Description', '物品表', N'user', N'dbo', N'table', N'ctl03001', NULL, NULL
go
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='Ctl01001'  and not isnull(f.value,'')='行政区划表'  
) >0
exec sp_addextendedproperty N'MS_Description', '行政区划表', N'user', N'dbo', N'table', N'Ctl01001', NULL, NULL
go
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='Ctl00701'  and not isnull(f.value,'')='部门表'  
) >0
exec sp_addextendedproperty N'MS_Description', '部门表', N'user', N'dbo', N'table', N'Ctl00701', NULL, NULL
go
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='ivt01001'  and not isnull(f.value,'')='库房定义表'  
) >0
exec sp_addextendedproperty N'MS_Description', '库房定义表', N'user', N'dbo', N'table', N'ivt01001', NULL, NULL
go
--添加字段说明：先drop后add即可，不能判断个数，因为一旦表的MS_Description存在，它永远认为MS_Description存在
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl03001','column',item_type
go
exec sp_addextendedproperty N'MS_Description', N'型号', N'user', N'dbo', N'table', N'Ctl03001', N'column', N'item_type'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl03001','column',type_id
go
exec sp_addextendedproperty N'MS_Description', N'物品类别', N'user', N'dbo', N'table', N'Ctl03001', N'column', N'type_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl03001','column',vendor_id
go
exec sp_addextendedproperty N'MS_Description', N'产地品牌', N'user', N'dbo', N'table', N'Ctl03001', N'column', N'vendor_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl01001','column',sort_id
go
exec sp_addextendedproperty N'MS_Description', N'地区名称的内码', N'user', N'dbo', N'table', N'Ctl01001', N'column', N'sort_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl00701','column',sort_id
go
exec sp_addextendedproperty N'MS_Description', N'部门名称的内码', N'user', N'dbo', N'table', N'Ctl00701', N'column', N'sort_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','ivt01001','column',sort_id
go
exec sp_addextendedproperty N'MS_Description', N'库房名称的内码', N'user', N'dbo', N'table', N'ivt01001', N'column', N'sort_id'
go
--【搬运工资结算单-表】
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Salary_Convey]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Salary_Convey]
GO
CREATE TABLE [dbo].[Salary_Convey] 
(  
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[dept_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,      --发生部门
	[DataSource] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,   --数据的单据来源
	[store_date] [datetime] NULL ,                                 --发生日期
	[ivt_oper_listing] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,  --发生单据内码
	[sd_order_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,           --发生单据编号
	[c_memoMain] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,           --本次产生数据的备注
	[c_memo] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,               --（摘要）单据备注
	[ConveyStyle] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,           --搬运方式
	[oper_qty] decimal(28,6) NULL ,                                         --出货数量
	[oper_priceOfConvey] decimal(28,6) NULL ,                               --对应单价
	[plan_price] decimal(28,6) NULL ,                                       --对应金额
	[explain_memo] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,         --（手填）备注
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='ConveyStyle')
  alter  table  IVTd01202 add  ConveyStyle varchar(50) null
  else alter  table  IVTd01202 alter COLUMN ConveyStyle varchar(50) null --搬运方式
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='ConveyStyle')
  alter  table  SDd02021 add  ConveyStyle varchar(50) null
  else alter  table  SDd02021 alter COLUMN ConveyStyle varchar(50) null --搬运方式
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl09201' AND a.type = 'u'  and a.id=b.id  and b.name='object_name')
  alter  table  Ctl09201 add  object_name varchar(100) null
  else alter  table  Ctl09201 alter COLUMN object_name varchar(100) null --系统菜单对象（权限对象）表中的“对象名称”  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Salary_Convey' AND a.type = 'u'  and a.id=b.id  and b.name='plan_price')
  alter  table  Salary_Convey add  plan_price decimal(28,6) null
  else alter  table  Salary_Convey alter COLUMN plan_price decimal(28,6) null --搬运工资结算单表中的金额  
go 




