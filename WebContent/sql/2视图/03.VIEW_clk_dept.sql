if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_clk_dept]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_clk_dept]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW VIEW_clk_dept
AS 
SELECT DISTINCT Ctl00801.clerk_id,Ctl09003.usr_grp_id,ctl09005.dept_id,Ctl00801.com_id,Ctl09003.user_id
FROM ctl09003 inner join 
     Ctl09005 on ctl09003.com_id=ctl09005.com_id  and ctl09003.usr_grp_id=ctl09005.usr_grp_id inner join
     Ctl00801 on ctl09003.com_id=Ctl00801.com_id  and ctl09003.clerk_id=Ctl00801.clerk_id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

