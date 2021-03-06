if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_Ctl03001_IVTd01302]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_Ctl03001_IVTd01302]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_Ctl03001_IVTd01302
AS
SELECT dbo.Ctl03001.com_id, dbo.IVTd01302.store_struct_id, dbo.Ctl03001.item_id, 
      dbo.Ctl03001.type_id, dbo.Ctl03001.item_type, dbo.Ctl03001.item_sim_name, 
      dbo.Ctl03001.item_name, dbo.Ctl03001.item_spec, dbo.Ctl03001.goods_origin, 
      dbo.Ctl03001.item_status, dbo.Ctl03001.m_flag, dbo.Ctl03001.vendor_id, 
      dbo.Ctl03001.c_color, dbo.Ctl03001.i_weight, dbo.Ctl03001.volume, 
      dbo.Ctl03001.item_Lenth, dbo.Ctl03001.item_Width, dbo.Ctl03001.item_Hight, 
      dbo.Ctl03001.JS, dbo.Ctl03001.item_yardPrice, dbo.Ctl03001.item_Sellprice, 
      dbo.Ctl03001.item_zeroSell, dbo.Ctl03001.item_cost, dbo.Ctl03001.goods_type, 
      dbo.Ctl03001.sales_property, dbo.Ctl03001.peijian_id, dbo.IVTd01302.oh, 
      dbo.IVTd01302.accn_ivt, dbo.IVTd01302.i_price, dbo.IVTd01302.i_Amount, 
      dbo.Ctl03001.Statistic
FROM dbo.Ctl03001 LEFT OUTER JOIN
      dbo.IVTd01302 ON dbo.Ctl03001.item_id = dbo.IVTd01302.item_id AND 
      dbo.Ctl03001.com_id = dbo.IVTd01302.com_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

