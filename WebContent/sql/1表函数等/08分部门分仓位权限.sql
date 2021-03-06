--管理模式驾驶仓表中的参数:是否控制部门权限:isprvdeptdata   是否控制仓位权限:bysendbill  是否控制只浏览自己的信息:ivt_if_y_setacct
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='isprvdeptdata')
  alter  table  CTLf01000 add  isprvdeptdata char(1)  NULL
  else alter  table  CTLf01000 alter COLUMN isprvdeptdata char(1) NULL 
GO
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='bysendbill')
  alter  table  CTLf01000 add  bysendbill char(1)  NULL
  else alter  table  CTLf01000 alter COLUMN bysendbill char(1) NULL 
GO
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='ivt_if_y_setacct')
  alter  table  CTLf01000 add  ivt_if_y_setacct char(1)  NULL
  else alter  table  CTLf01000 alter COLUMN ivt_if_y_setacct char(1) NULL 
GO
--部门权限表
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ctl09005]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[ctl09005] (
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[usr_grp_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[dept_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL 
) ON [PRIMARY]
GO
--仓位权限表
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ctl09006]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[ctl09006] (
	[seeds_id] [int] IDENTITY (1, 1) NOT NULL ,
	[com_id] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[user_id] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[store_struct_id] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO
--用户及其操作权限表中的参数:只浏览自己的信息?
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl09003' AND a.type = 'u'  and a.id=b.id  and b.name='i_browse')
  alter  table  Ctl09003 add  i_browse char(1)  NULL
  else alter  table  Ctl09003 alter COLUMN i_browse char(1) NULL 
GO
--库房定义表中的参数
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivt01001' AND a.type = 'u'  and a.id=b.id  and b.name='down_flag')
  alter  table  Ivt01001 add  down_flag char(1)  NULL
  else alter  table  Ivt01001 alter COLUMN down_flag char(1) NULL 
GO
