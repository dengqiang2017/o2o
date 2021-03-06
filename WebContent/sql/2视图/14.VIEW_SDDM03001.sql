if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_SDDM03001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_SDDM03001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.VIEW_SDDM03001
AS
SELECT dbo.SDD03001.expenses_id, dbo.SDD03001.sum_si, dbo.SDD03001.reason, 
      dbo.SDDM03001.ivt_oper_listing, dbo.SDDM03001.sd_order_id, 
      dbo.SDDM03001.com_id, dbo.SDDM03001.finacial_y, dbo.SDDM03001.finacial_m, 
      dbo.SDDM03001.dept_id, dbo.SDDM03001.clerk_id, dbo.SDDM03001.finacial_d, 
      dbo.SDDM03001.sum_si AS Allsum_si, dbo.SDDM03001.billNO, 
      dbo.SDDM03001.bill_source, dbo.SDDM03001.waigou_ivt_oper, 
      dbo.SDD03001.vendor_id, dbo.SDD03001.customer_id, 
      dbo.SDDM03001.mainten_datetime, dbo.SDD03001.ID, dbo.SDD03001.YWLX, 
      dbo.SDD03001.DJH, dbo.SDD03001.WDJH
FROM dbo.SDDM03001 FULL OUTER JOIN
      dbo.SDD03001 ON 
      dbo.SDDM03001.ivt_oper_listing = dbo.SDD03001.ivt_oper_listing AND 
      dbo.SDDM03001.com_id = dbo.SDD03001.com_id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

