--���ܱ�-���ͺż����´��������������ܱ������ݱ� 
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

--��������ȡ������-�ܱ�-���ͺż����´��������������ܱ��ж���
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Customize_Sales_ItemtypeAndRegionalism]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Customize_Sales_ItemtypeAndRegionalism]
GO
CREATE TABLE [dbo].[Customize_Sales_ItemtypeAndRegionalism] 
(  
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[serial_no] [int] NULL ,                                        --��������˳��
	[self_type] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,     --������
	[self_id] [int] NULL ,                                          --�������д�
	[table_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --������Ӧ�ı���
	[field_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --������Ӧ���ֶ�ֵ��Ӧ������
	[field_value] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --������Ӧ���ֶ�ֵ
	[field_Datasource] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --������Ӧ���ֶ�ֵ������Դ
	[field_formula] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL ,     --��ֵ��ȡ����ʽ
	[working_status] [varchar] (2) COLLATE Chinese_PRC_CI_AS NULL ,  --�е�ʹ��״̬��'��'��'��'
	[field_title] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,   --������Ӧ���ֶεı�ͷ������
	[field_row_num] [int] NULL ,                                     --��ͷ����
	[field_name_target] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,   --Ŀ�����ֶ���
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO

--���ܱ�-��Ʒ�Ʋ�Ʒ��𼰰��´������۶���ܱ������ݱ�
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

--��������ȡ������-�ܱ�-��Ʒ�Ʋ�Ʒ��𼰰��´������۶���ܱ��ж���
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Customize_Sales_vendorIDtypeIDAndRegionalism]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Customize_Sales_vendorIDtypeIDAndRegionalism]
GO
CREATE TABLE [dbo].[Customize_Sales_vendorIDtypeIDAndRegionalism] 
(  
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[serial_no] [int] NULL ,                                        --��������˳��
	[self_type] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,     --������
	[self_id] [int] NULL ,                                          --�������д�
	[table_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --������Ӧ�ı���
	[field_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,    --������Ӧ���ֶ�ֵ��Ӧ������
	[field_value] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --������Ӧ���ֶ�ֵ
	[field_Datasource] [varchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,  --������Ӧ���ֶ�ֵ������Դ
	[field_formula] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL ,     --��ֵ��ȡ����ʽ
	[working_status] [varchar] (2) COLLATE Chinese_PRC_CI_AS NULL ,  --�е�ʹ��״̬��'��'��'��'
	[field_title] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,   --������Ӧ���ֶεı�ͷ������
	[field_row_num] [int] NULL ,                                     --��ͷ����
	[field_name_target] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,   --Ŀ�����ֶ���
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO

--��ӱ�˵��
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='ctl03001'  and not isnull(f.value,'')='��Ʒ��'  
) >0
exec sp_addextendedproperty N'MS_Description', '��Ʒ��', N'user', N'dbo', N'table', N'ctl03001', NULL, NULL
go
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='Ctl01001'  and not isnull(f.value,'')='����������'  
) >0
exec sp_addextendedproperty N'MS_Description', '����������', N'user', N'dbo', N'table', N'Ctl01001', NULL, NULL
go
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='Ctl00701'  and not isnull(f.value,'')='���ű�'  
) >0
exec sp_addextendedproperty N'MS_Description', '���ű�', N'user', N'dbo', N'table', N'Ctl00701', NULL, NULL
go
if 
(
select count( isnull(f.value,'') )
from syscolumns a
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'
left join sysproperties f on d.id=f.id and f.smallid=0
where d.xtype='U' and d.name='ivt01001'  and not isnull(f.value,'')='�ⷿ�����'  
) >0
exec sp_addextendedproperty N'MS_Description', '�ⷿ�����', N'user', N'dbo', N'table', N'ivt01001', NULL, NULL
go
--����ֶ�˵������drop��add���ɣ������жϸ�������Ϊһ�����MS_Description���ڣ�����Զ��ΪMS_Description����
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl03001','column',item_type
go
exec sp_addextendedproperty N'MS_Description', N'�ͺ�', N'user', N'dbo', N'table', N'Ctl03001', N'column', N'item_type'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl03001','column',type_id
go
exec sp_addextendedproperty N'MS_Description', N'��Ʒ���', N'user', N'dbo', N'table', N'Ctl03001', N'column', N'type_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl03001','column',vendor_id
go
exec sp_addextendedproperty N'MS_Description', N'����Ʒ��', N'user', N'dbo', N'table', N'Ctl03001', N'column', N'vendor_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl01001','column',sort_id
go
exec sp_addextendedproperty N'MS_Description', N'�������Ƶ�����', N'user', N'dbo', N'table', N'Ctl01001', N'column', N'sort_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','Ctl00701','column',sort_id
go
exec sp_addextendedproperty N'MS_Description', N'�������Ƶ�����', N'user', N'dbo', N'table', N'Ctl00701', N'column', N'sort_id'
go
exec sp_dropextendedproperty 'MS_Description','user',dbo,'table','ivt01001','column',sort_id
go
exec sp_addextendedproperty N'MS_Description', N'�ⷿ���Ƶ�����', N'user', N'dbo', N'table', N'ivt01001', N'column', N'sort_id'
go
--�����˹��ʽ��㵥-��
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Salary_Convey]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Salary_Convey]
GO
CREATE TABLE [dbo].[Salary_Convey] 
(  
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[dept_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,      --��������
	[DataSource] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,   --���ݵĵ�����Դ
	[store_date] [datetime] NULL ,                                 --��������
	[ivt_oper_listing] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,  --������������
	[sd_order_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,           --�������ݱ��
	[c_memoMain] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,           --���β������ݵı�ע
	[c_memo] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,               --��ժҪ�����ݱ�ע
	[ConveyStyle] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,           --���˷�ʽ
	[oper_qty] decimal(28,6) NULL ,                                         --��������
	[oper_priceOfConvey] decimal(28,6) NULL ,                               --��Ӧ����
	[plan_price] decimal(28,6) NULL ,                                       --��Ӧ���
	[explain_memo] [varchar] (800) COLLATE Chinese_PRC_CI_AS NULL ,         --�������ע
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='ConveyStyle')
  alter  table  IVTd01202 add  ConveyStyle varchar(50) null
  else alter  table  IVTd01202 alter COLUMN ConveyStyle varchar(50) null --���˷�ʽ
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='ConveyStyle')
  alter  table  SDd02021 add  ConveyStyle varchar(50) null
  else alter  table  SDd02021 alter COLUMN ConveyStyle varchar(50) null --���˷�ʽ
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl09201' AND a.type = 'u'  and a.id=b.id  and b.name='object_name')
  alter  table  Ctl09201 add  object_name varchar(100) null
  else alter  table  Ctl09201 alter COLUMN object_name varchar(100) null --ϵͳ�˵�����Ȩ�޶��󣩱��еġ��������ơ�  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Salary_Convey' AND a.type = 'u'  and a.id=b.id  and b.name='plan_price')
  alter  table  Salary_Convey add  plan_price decimal(28,6) null
  else alter  table  Salary_Convey alter COLUMN plan_price decimal(28,6) null --���˹��ʽ��㵥���еĽ��  
go 




