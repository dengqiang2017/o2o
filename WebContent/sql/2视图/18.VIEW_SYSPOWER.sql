if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_SYSPOWER]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_SYSPOWER]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_SYSPOWER
AS
SELECT DISTINCT 
      dbo.Ctl09003.com_id, dbo.Ctl09003.user_id, dbo.Ctl09003.usr_grp_id, 
      dbo.Ctl09201.object_id, dbo.Ctl09201.object_name, dbo.Ctl09105.insert_right, 
      dbo.Ctl09105.update_right, dbo.Ctl09105.delete_right, dbo.Ctl09105.select_right, 
      dbo.Ctl09105.print_right, dbo.Ctl09105.aud_right, dbo.Ctl09105.noaud_right
FROM dbo.Ctl09105 LEFT OUTER JOIN
      dbo.Ctl09201 ON dbo.Ctl09105.object_id = dbo.Ctl09201.object_id INNER JOIN
      dbo.Ctl09003 ON dbo.Ctl09105.com_id = dbo.Ctl09003.com_id AND 
      dbo.Ctl09105.usr_grp_id = dbo.Ctl09003.usr_grp_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

