if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[View_sdd02020]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[View_sdd02020]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.View_sdd02020
AS
SELECT a.com_id, a.customer_id, a.clerk_id, a.dept_id, a.comfirm_flag, a.finacial_y, 
      a.finacial_m, a.sd_order_direct, b.item_id, b.lot_number, b.unit_id, b.sd_oq, 
      a.c_memo, a.no_acceptsum, b.base_oq, b.base_unit_id, b.tax_sum_si, 
      a.ivt_oper_listing, a.sd_order_id, a.i_agiosum, b.discount_rate, b.sd_unit_price, 
      b.tax_rate, b.sum_si, b.send_sum, a.so_consign_date, b.send_qty, b.seeds_id, 
      a.at_term_datetime, a.settlement_type_id, a.tax_type, a.pay_style, a.ivt_oper_bill, 
      b.type_id AS Expr1, a.regionalism_id, a.mainten_clerk_id, a.mainten_datetime, 
      a.youhui_sum, b.store_struct_id, b.beizhu, b.peijian_id, b.pack_unit, b.pack_num, 
      a.HYJE, b.BXQ, c.HYS, c.FHDZ, c.zip, b.item_type, b.item_Sellprice, b.item_zeroSell, 
      b.item_yardPrice, b.item_Lenth, b.item_Width, b.item_Hight, b.oddment_num, 
      b.type_id, d.type_id AS type_id_ctl03001, d.item_type AS item_type_ctl03001, 
      d.item_spec, d.JS, d.vendor_id, d.c_color, d.i_weight, d.volume, d.sales_property, 
      d.sd_tax, a.sum_si AS sum_siMain, d.item_sim_name, d.item_name, d.goods_type, 
      d.goods_origin, d.item_status, d.m_flag, b.accountTurn_Flag, b.ConveyStyle, 
      d.Statistic AS Statistic_ctl03001
FROM dbo.SDd02020 a LEFT OUTER JOIN
      dbo.Sdf00504 c ON a.customer_id = c.customer_id LEFT OUTER JOIN
      dbo.SDd02021 b ON a.com_id = b.com_id AND 
      a.ivt_oper_listing = b.ivt_oper_listing LEFT OUTER JOIN
      dbo.Ctl03001 d ON LTRIM(RTRIM(ISNULL(d.com_id, ''))) 
      = LTRIM(RTRIM(ISNULL(b.com_id, ''))) AND LTRIM(RTRIM(ISNULL(d.item_id, ''))) 
      = LTRIM(RTRIM(ISNULL(b.item_id, '')))

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

