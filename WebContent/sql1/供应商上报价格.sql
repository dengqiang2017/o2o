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