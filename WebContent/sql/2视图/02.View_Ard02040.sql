if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[View_Ard02040]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[View_Ard02040]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.View_Ard02040
AS
SELECT dbo.ARd02040.com_id, dbo.ARd02040.auto_tax_invoice_id, 
      dbo.ARd02040.finacial_y, dbo.ARd02040.finacial_m, dbo.ARd02040.tax_invoice_id, 
      dbo.ARd02040.dept_id, dbo.ARd02040.clerk_id, dbo.ARd02040.tax_invoice_date, 
      dbo.ARd02040.invoicer, dbo.ARd02040.tax_invoice_direct, dbo.ARd02040.tax_type, 
      dbo.ARd02041.item_id, dbo.ARd02041.sum_ti, dbo.ARd02041.c_memo, 
      dbo.ARd02041.customer_id, dbo.ARd02041.vendor_id, 
      dbo.ARd02041.settlement_type_id, dbo.ARd02041.unit_id, dbo.ARd02041.sd_oq, 
      dbo.ARd02041.sd_unit_price, dbo.ARd02041.peijian_id, dbo.ARd02041.old_id, 
      dbo.ARd02041.dept_id AS detail_dept_id, dbo.ARd02040.comfirm_flag, 
      dbo.ARd02040.ivt_oper_cfm, dbo.ARd02040.ivt_oper_cfm_time, 
      dbo.ARd02040.mainten_clerk_id, dbo.ARd02040.mainten_datetime, 
      dbo.ARd02041.sd_order_id, dbo.ARd02041.SEEDS_ID, dbo.ARd02041.pack_unit, 
      dbo.ARd02041.pack_num, dbo.ARd02041.oddment_num, 
      dbo.ARd02041.store_struct_id
FROM dbo.ARd02040 INNER JOIN
      dbo.ARd02041 ON dbo.ARd02040.com_id = dbo.ARd02041.com_id AND 
      dbo.ARd02040.auto_tax_invoice_id = dbo.ARd02041.auto_tax_invoice_id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

