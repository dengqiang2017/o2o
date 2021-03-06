if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_Ivtd01310]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_Ivtd01310]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.VIEW_Ivtd01310
AS
SELECT dbo.IVTd01310.*, dbo.IVTd01311.peijian_id, dbo.IVTd01311.differ_sum, 
      dbo.IVTd01311.differ_quant, dbo.IVTd01311.counted_price, dbo.IVTd01311.accn_ivt, 
      dbo.IVTd01311.counted_ivt, dbo.IVTd01311.lot_number, dbo.IVTd01311.item_id, 
      dbo.IVTd01311.counting_no, dbo.IVTd01311.unit_id, dbo.IVTd01311.pack_unit, 
      dbo.IVTd01311.pack_num, dbo.IVTd01311.oddment_num, dbo.IVTd01311.tax_sum_si, 
      dbo.IVTd01311.c_memo AS detail_memo
FROM dbo.IVTd01310 FULL OUTER JOIN
      dbo.IVTd01311 ON dbo.IVTd01310.com_id = dbo.IVTd01311.com_id AND 
      dbo.IVTd01310.ivt_oper_listing = dbo.IVTd01311.ivt_oper_listing


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

