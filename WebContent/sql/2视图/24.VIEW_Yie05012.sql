if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_Yie05012]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_Yie05012]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_Yie05012
AS
SELECT dbo.Yie05010.seeds_id, dbo.Yie05010.com_id, dbo.Yie05010.ivt_oper_listing, 
      dbo.Yie05010.sd_order_id, dbo.Yie05010.send_date, dbo.Yie05010.dept_id, 
      dbo.Yie05010.clerk_id, dbo.Yie05010.c_memo, dbo.Yie05010.mainten_clerk_id, 
      dbo.Yie05010.mainten_datetime, dbo.Yie05010.ivt_oper_cfm, 
      dbo.Yie05010.ivt_oper_cfm_time, dbo.Yie05010.comfirm_flag, 
      dbo.Yie05010.vendor_id, dbo.Yie05010.fee_sum, dbo.Yie05012.seeds_id_Yie05011, 
      dbo.Yie05012.sno, dbo.Yie05012.yieitem_id, dbo.Yie05012.item_id, 
      dbo.Yie05012.peijian_id, dbo.Yie05012.store_struct_id, dbo.Yie05012.lead_oq, 
      dbo.Yie05012.oper_price, dbo.Yie05012.plan_price, 
      dbo.Yie05012.c_memo AS c_memoYie05012, 
      dbo.Yie05012.seeds_id AS seeds_idYie05012
FROM dbo.Yie05010 LEFT OUTER JOIN
      dbo.Yie05012 ON dbo.Yie05010.com_id = dbo.Yie05012.com_id AND 
      dbo.Yie05010.ivt_oper_listing = dbo.Yie05012.ivt_oper_listing

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

