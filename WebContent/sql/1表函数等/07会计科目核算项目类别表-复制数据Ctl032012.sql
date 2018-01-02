if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Ctl032012]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Ctl032012]
GO

CREATE TABLE [dbo].[Ctl032012] (
	[seeds_id] [numeric](18, 0) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[CheckType_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[CheckType_name] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[c_flag] [char] (1) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

