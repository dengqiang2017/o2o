if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[View_sdd02020_LeftOuterJoin_ctl03001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[View_sdd02020_LeftOuterJoin_ctl03001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*版本说明：物品资料中的长宽高，而非业务单据中的长宽高*/
CREATE VIEW dbo.View_sdd02020_LeftOuterJoin_ctl03001
AS
SELECT dbo.Ctl03001.vendor_id, dbo.Ctl03001.type_id, dbo.Ctl03001.item_type, 
      dbo.Ctl03001.item_spec, dbo.Ctl03001.c_color, dbo.Ctl03001.i_weight, 
      dbo.Ctl03001.volume, dbo.Ctl03001.item_Lenth, dbo.Ctl03001.item_Width, 
      dbo.Ctl03001.item_Hight, dbo.View_sdd02020.com_id, 
      dbo.View_sdd02020.customer_id, dbo.View_sdd02020.clerk_id, 
      dbo.View_sdd02020.dept_id, dbo.View_sdd02020.comfirm_flag, 
      dbo.View_sdd02020.sd_order_direct, dbo.View_sdd02020.item_id, 
      dbo.View_sdd02020.lot_number, dbo.View_sdd02020.unit_id, 
      dbo.View_sdd02020.sd_oq, dbo.View_sdd02020.c_memo, 
      dbo.View_sdd02020.no_acceptsum, dbo.View_sdd02020.base_oq, 
      dbo.View_sdd02020.base_unit_id, dbo.View_sdd02020.tax_sum_si, 
      dbo.View_sdd02020.ivt_oper_listing, dbo.View_sdd02020.sd_order_id, 
      dbo.View_sdd02020.i_agiosum, dbo.View_sdd02020.discount_rate, 
      dbo.View_sdd02020.sd_unit_price, dbo.View_sdd02020.tax_rate, 
      dbo.View_sdd02020.sum_si, dbo.View_sdd02020.send_sum, 
      dbo.View_sdd02020.so_consign_date, dbo.View_sdd02020.send_qty, 
      dbo.View_sdd02020.seeds_id, dbo.View_sdd02020.at_term_datetime, 
      dbo.View_sdd02020.settlement_type_id, dbo.View_sdd02020.tax_type, 
      dbo.View_sdd02020.pay_style, dbo.View_sdd02020.ivt_oper_bill, 
      dbo.View_sdd02020.regionalism_id, dbo.View_sdd02020.mainten_clerk_id, 
      dbo.View_sdd02020.mainten_datetime, dbo.View_sdd02020.youhui_sum, 
      dbo.View_sdd02020.store_struct_id, dbo.View_sdd02020.beizhu, 
      dbo.View_sdd02020.peijian_id, dbo.View_sdd02020.pack_unit, 
      dbo.View_sdd02020.pack_num, dbo.View_sdd02020.HYJE, dbo.View_sdd02020.BXQ, 
      dbo.View_sdd02020.HYS, dbo.View_sdd02020.FHDZ, dbo.View_sdd02020.zip, 
      dbo.View_sdd02020.item_Sellprice, dbo.View_sdd02020.item_zeroSell, 
      dbo.View_sdd02020.item_yardPrice, dbo.View_sdd02020.finacial_y, 
      dbo.View_sdd02020.finacial_m, dbo.Ctl03001.sales_property, dbo.Ctl03001.JS, 
      dbo.View_sdd02020.item_type AS Expr4
FROM dbo.View_sdd02020 LEFT OUTER JOIN
      dbo.Ctl03001 ON dbo.View_sdd02020.com_id = dbo.Ctl03001.com_id AND 
      dbo.View_sdd02020.item_id = dbo.Ctl03001.item_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

