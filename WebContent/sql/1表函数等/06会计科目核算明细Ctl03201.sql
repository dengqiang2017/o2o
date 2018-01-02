IF exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Ctl03201]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Ctl03201]
GO

CREATE TABLE [dbo].[Ctl03201] (
	[seeds_id] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[sort_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[CheckType_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[CGGoods_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[self_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[sort_sim_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[sort_name] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[easy_id] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[upper_sort_id] [varchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[dept_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[goods_origin] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[unit_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[init_sum] [decimal](17, 6) NULL ,
	[comfirm_flag] [char] (1) COLLATE Chinese_PRC_CI_AS NULL ,
	[init_flag] [char] (1) COLLATE Chinese_PRC_CI_AS NULL ,
	[sd_oq] [decimal](17, 6) NULL ,
	[sd_price] [decimal](17, 6) NULL ,
	[zj] [varchar] (300) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_clerk_id] [varchar] (35) COLLATE Chinese_PRC_CI_AS NULL ,
	[mainten_datetime] [datetime] NULL 
) ON [PRIMARY]
GO

