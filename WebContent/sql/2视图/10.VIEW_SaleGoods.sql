if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_SaleGoods]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_SaleGoods]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW VIEW_SaleGoods
AS 
SELECT 
      SDd02020.sd_order_id,SDd02020.customer_id,SDd02021.item_id,SDd02021.seeds_id,SDd02020.regionalism_id,
      SDd02020.dept_id,SDd02020.clerk_id,SDd02020.com_id,SDd02020.ivt_oper_listing,
      SDd02020.so_consign_date,SDd02020.settlement_type_id,Ctl03001.type_id,
      SDd02020.tax_type,SDd02020.pay_style,SDd02020.sd_order_direct,
      SDd02021.rev_days,Ctl03001.item_name,Ctl03001.item_type,
      Ctl03001.item_spec,Ctl03001.m_flag,SDd02021.vendor_id as gonghuoshang,SDd02021.store_struct_id,
      Ctl03001.item_unit,Ctl03001.item_cost,Ctl03001.item_zeroSell,
      Ctl03001.item_Sellprice,Ctl03001.peijian_id,Ctl03001.vendor_id,
      Ctl03001.bar_gb16830_1997,Ctl03001.easy_id,SDd02020.comfirm_flag
FROM  Ctl03001 RIGHT OUTER JOIN
      SDd02021 ON Ctl03001.com_id=SDd02021.com_id AND
      Ctl03001.item_id=SDd02021.item_id RIGHT OUTER JOIN
      SDd02020 ON  SDd02021.com_id=SDd02020.com_id AND
      SDd02021.ivt_oper_listing=SDd02020.ivt_oper_listing

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

