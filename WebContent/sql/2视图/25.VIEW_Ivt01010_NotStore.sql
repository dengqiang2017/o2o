if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_Ivt01010_NotStore]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_Ivt01010_NotStore]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_Ivt01010_NotStore
AS
SELECT dbo.Ivt01010.max_stock, dbo.Ivt01010.safety_stock, dbo.Ivt01010.reorder_point, 
      dbo.Ivt01010.type_id, dbo.Ivt01010.com_id, dbo.Ivt01010.item_id, 
      dbo.IVTd01302.accn_ivt, dbo.IVTd01302.oh, dbo.IVTd01302.i_price, 
      dbo.IVTd01302.item_Sellprice, dbo.IVTd01302.item_zeroSell, 
      dbo.IVTd01302.item_yardPrice, dbo.IVTd01302.item_source, 
      dbo.IVTd01302.lot_number, dbo.Ivt01010.lead_time, dbo.Ivt01010.economic_oq, 
      dbo.Ivt01010.store_struct_id
FROM dbo.Ivt01010 LEFT OUTER JOIN
      dbo.IVTd01302 ON dbo.Ivt01010.com_id = dbo.IVTd01302.com_id AND 
      dbo.Ivt01010.item_id = dbo.IVTd01302.item_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

