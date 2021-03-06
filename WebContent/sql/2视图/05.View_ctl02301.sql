if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[View_ctl02301]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[View_ctl02301]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




create view View_ctl02301 as
select dbo.Ctl03001.com_id, dbo.Ctl03001.item_id, dbo.Ctl03001.item_sim_name, 
dbo.Ctl03001.casing_unit, dbo.Ctl02301.unit_sim_name
from dbo.Ctl02301, dbo.Ctl03001
where dbo.Ctl02301.sort_id = dbo.Ctl03001.casing_unit
and dbo.Ctl02301.com_id = dbo.Ctl03001.com_id
and dbo.Ctl02301.item_id = dbo.Ctl03001.item_id
with check option


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

