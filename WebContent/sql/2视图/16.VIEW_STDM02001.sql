if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_STDM02001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_STDM02001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_STDM02001
AS
SELECT dbo.STDM02001.st_auto_no, dbo.STDM02001.st_hw_no, 
      dbo.STDM02001.finacial_y, dbo.STDM02001.finacial_m, dbo.STDM02001.vendor_id, 
      dbo.STDM02001.dept_id, dbo.STDM02001.clerk_id, dbo.STDM02001.finacial_d, 
      dbo.STDM02001.bgn_id, dbo.STDM02001.rep_reason, dbo.STDM02001.comfirm_flag, 
      dbo.STDM02001.ivt_oper_cfm, dbo.STDM02001.ivt_oper_cfm_time, 
      dbo.STD02001.item_id, dbo.STD02001.lot_number, dbo.STD02001.rep_qty, 
      dbo.STD02001.unit_id, dbo.STD02001.price, dbo.STD02001.discount_rate, 
      dbo.STD02001.tax_rate, dbo.STD02001.st_sum, dbo.STD02001.type_id, 
      dbo.STD02001.[no], dbo.STD02001.peijian_id, dbo.STD02001.fact_rcv, 
      dbo.STD02001.seeds_id, dbo.STD02001.hav_rcv, dbo.STD02001.adress_id, 
      dbo.STD02001.store_struct_id, dbo.STDM02001.com_id, dbo.STD02001.pack_unit, 
      dbo.STD02001.pack_num, dbo.STD02001.oddment_num, 
      dbo.STD02001.at_term_datetime, dbo.STD02001.item_type, 
      dbo.STDM02001.expenses_id, dbo.STDM02001.deal_flag, 
      dbo.STDM02001.pay_days, dbo.STDM02001.cgt_day, dbo.STDM02001.pay_style, 
      dbo.STDM02001.bill_sum, dbo.STDM02001.coin_id, dbo.STDM02001.isbudget, 
      dbo.STDM02001.budget_id, dbo.STDM02001.mainten_clerk_id, 
      dbo.STDM02001.mainten_datetime, dbo.STDM02001.st_mode, 
      dbo.STDM02001.rep_stat, dbo.STDM02001.stat_des, dbo.STD02001.item_Lenth, 
      dbo.STD02001.item_Width, dbo.STD02001.item_Hight, 
      dbo.STDM02001.if_All_rcv
FROM dbo.STDM02001 LEFT OUTER JOIN
      dbo.STD02001 ON dbo.STDM02001.com_id = dbo.STD02001.com_id AND 
      dbo.STDM02001.st_auto_no = dbo.STD02001.st_auto_no

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

