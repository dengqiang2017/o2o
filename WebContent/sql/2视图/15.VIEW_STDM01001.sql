if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_STDM01001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_STDM01001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW VIEW_STDM01001
AS
SELECT STDM01001.com_id,STDM01001.finacial_y,STDM01001.finacial_m,STDM01001.rep_auto_no,
       STDM01001.rep_hw_no,STDM01001.dept_id,STDM01001.clerk_id,STDM01001.finacial_d,STDM01001.rep_reason,
       STDM01001.st_hw_no,STD01001.item_id,STD01001.rep_qty,STD01001.purp_des,STD01001.pro_item,
       STD01001.vendor_id,STD01001.unit_id,STDM01001.comfirm_flag,STDM01001.ivt_oper_cfm,
       STDM01001.ivt_oper_cfm_time,STDM01001.mainten_clerk_id,STDM01001.mainten_datetime
FROM   STD01001 INNER JOIN
       STDM01001 ON STD01001.com_id=STDM01001.com_id AND 
       STD01001.rep_auto_no=STDM01001.rep_auto_no


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

