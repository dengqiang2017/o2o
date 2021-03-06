if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[view_sdd02010]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[view_sdd02010]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.view_sdd02010
AS
SELECT dbo.SDd02010.com_id, dbo.SDd02010.ivt_oper_listing, 
      dbo.SDd02010.sd_order_id, dbo.SDd02010.customer_id, dbo.SDd02010.dept_id, 
      dbo.SDd02010.clerk_id, dbo.SDd02010.at_term_datetime, dbo.SDd02010.pay_style, 
      dbo.SDd02010.settlement_type_id, dbo.SDd02010.comfirm_flag, 
      dbo.SDd02010.ivt_oper_cfm, dbo.SDd02010.ivt_oper_cfm_time, 
      dbo.SDd02010.finacial_y, dbo.SDd02010.finacial_m, dbo.SDd02010.mainten_clerk_id, 
      dbo.SDd02010.mainten_datetime, dbo.SDd02011.item_id, dbo.SDd02011.lot_number, 
      dbo.SDd02011.unit_id, dbo.SDd02011.sd_oq, dbo.SDd02011.sd_unit_price, 
      dbo.SDd02011.discount_rate, dbo.SDd02011.tax_rate, dbo.SDd02011.tax_sum_si, 
      dbo.SDd02010.sum_si, dbo.SDd02010.all_oq, 
      dbo.SDd02011.sum_si AS Detail_sum_si, dbo.SDd02011.base_oq, 
      dbo.SDd02011.base_unit_id, dbo.SDd02010.so_effect_datetime, 
      dbo.SDd02011.seeds_id, dbo.SDd02011.send_qty, dbo.SDd02011.peijian_id, 
      dbo.SDd02011.store_struct_id, dbo.SDd02011.type_id, dbo.SDd02011.c_memo, 
      dbo.SDd02011.send_sum, dbo.SDd02010.c_memo AS manc_memo, 
      dbo.SDd02011.select_pd, dbo.SDd02011.pack_unit, dbo.SDd02011.pack_num, 
      dbo.SDd02011.oddment_num, dbo.SDd02011.item_zeroSell, 
      dbo.SDd02011.item_Sellprice, dbo.SDd02011.item_yardPrice, 
      dbo.SDd02010.regionalism_id, dbo.SDd02010.delivery_Add
FROM dbo.SDd02010 FULL OUTER JOIN
      dbo.SDd02011 ON dbo.SDd02010.com_id = dbo.SDd02011.com_id AND 
      dbo.SDd02010.ivt_oper_listing = dbo.SDd02011.ivt_oper_listing


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

