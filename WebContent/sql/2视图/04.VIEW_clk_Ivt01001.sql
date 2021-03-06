if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_clk_Ivt01001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_clk_Ivt01001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE VIEW VIEW_clk_Ivt01001
AS 
SELECT Ctl09003.usr_grp_id, Ctl09003.user_id, Ivt01001.com_id, 
      Ivt01001.store_struct_name, Ivt01001.easy_id, Ctl09003.clerk_id,Ctl09003.i_browse, ctl09006.store_struct_id
FROM Ctl09003 INNER JOIN
      ctl09006 ON Ctl09003.com_id = ctl09006.com_id AND Ctl09003.user_id = ctl09006.user_id INNER JOIN
      Ivt01001 ON ctl09006.com_id = Ivt01001.com_id AND ctl09006.store_struct_id = Ivt01001.sort_id



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

