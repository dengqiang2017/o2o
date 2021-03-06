if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_view_ivt01201_Ctl03001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_view_ivt01201_Ctl03001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_view_ivt01201_Ctl03001
AS
SELECT dbo.Ctl03001.i_weight, dbo.Ctl03001.volume, dbo.Ctl03001.item_Lenth, 
      dbo.Ctl03001.item_Width, dbo.Ctl03001.item_Hight, dbo.Ctl03001.type_id, 
      dbo.Ctl03001.item_type, dbo.Ctl03001.item_spec, dbo.Ctl03001.item_status, 
      dbo.Ctl03001.m_flag, dbo.Ctl03001.item_unit, dbo.Ctl03001.c_color, dbo.Ctl03001.JS, 
      dbo.Ctl03001.sales_property, dbo.VIEW_ivt01201.item_id, 
      dbo.VIEW_ivt01201.lot_number, dbo.VIEW_ivt01201.plan_price, 
      dbo.VIEW_ivt01201.oper_price, dbo.VIEW_ivt01201.oper_qty, 
      dbo.VIEW_ivt01201.base_oq, dbo.VIEW_ivt01201.unit_id, 
      dbo.VIEW_ivt01201.shipping_unit_id, dbo.VIEW_ivt01201.base_unit_id, 
      dbo.VIEW_ivt01201.sID, dbo.VIEW_ivt01201.com_id, 
      dbo.VIEW_ivt01201.ivt_oper_listing, dbo.VIEW_ivt01201.sd_order_id, 
      dbo.VIEW_ivt01201.finacial_y, dbo.VIEW_ivt01201.finacial_m, 
      dbo.VIEW_ivt01201.finacial_datetime, dbo.VIEW_ivt01201.voucher_id, 
      dbo.VIEW_ivt01201.origin_voucher_id, dbo.VIEW_ivt01201.ivt_oper_id, 
      dbo.VIEW_ivt01201.voucher_status, dbo.VIEW_ivt01201.ivt_whyoper_id, 
      dbo.VIEW_ivt01201.store_date, dbo.VIEW_ivt01201.dept_id, 
      dbo.VIEW_ivt01201.regionalism_id, dbo.VIEW_ivt01201.customer_id, 
      dbo.VIEW_ivt01201.clerk_id, dbo.VIEW_ivt01201.corp_id, 
      dbo.VIEW_ivt01201.ivt_operator, dbo.VIEW_ivt01201.ivt_oper_clerk, 
      dbo.VIEW_ivt01201.ivt_oper_time, dbo.VIEW_ivt01201.check_comfirm_flag, 
      dbo.VIEW_ivt01201.check_and_acceptor, dbo.VIEW_ivt01201.CheckAndAcceptTime, 
      dbo.VIEW_ivt01201.comfirm_flag, dbo.VIEW_ivt01201.ivt_oper_cfm, 
      dbo.VIEW_ivt01201.ivt_oper_cfm_time, dbo.VIEW_ivt01201.mainten_clerk_id, 
      dbo.VIEW_ivt01201.maintenance_datetime, dbo.VIEW_ivt01201.ivt_oper_bill, 
      dbo.VIEW_ivt01201.i_factacceptsum, dbo.VIEW_ivt01201.i_suitacceptsum, 
      dbo.VIEW_ivt01201.i_oweacceptsum, dbo.VIEW_ivt01201.peijian_id, 
      dbo.VIEW_ivt01201.corpstorestruct_id, dbo.VIEW_ivt01201.store_struct_id, 
      dbo.VIEW_ivt01201.pack_unit, dbo.VIEW_ivt01201.pack_num, 
      dbo.VIEW_ivt01201.oddment_num, dbo.VIEW_ivt01201.pass_oq, 
      dbo.VIEW_ivt01201.item_yardPrice, dbo.VIEW_ivt01201.item_Sellprice, 
      dbo.VIEW_ivt01201.item_zeroSell, dbo.VIEW_ivt01201.c_memo, 
      dbo.VIEW_ivt01201.ConveyStyle
FROM dbo.VIEW_ivt01201 LEFT OUTER JOIN
      dbo.Ctl03001 ON dbo.VIEW_ivt01201.com_id = dbo.Ctl03001.com_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

