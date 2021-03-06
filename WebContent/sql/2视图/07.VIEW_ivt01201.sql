if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_ivt01201]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_ivt01201]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_ivt01201
AS
SELECT dbo.IVTd01202.item_id, dbo.IVTd01202.lot_number, dbo.IVTd01202.plan_price, 
      dbo.IVTd01202.oper_price, dbo.IVTd01202.oper_qty, dbo.IVTd01202.base_oq, 
      dbo.IVTd01202.unit_id, dbo.IVTd01202.shipping_unit_id, dbo.IVTd01202.base_unit_id, 
      dbo.IVTd01202.ID AS sID, dbo.IVTd01201.com_id, dbo.IVTd01201.ivt_oper_listing, 
      dbo.IVTd01201.sd_order_id, dbo.IVTd01201.finacial_y, dbo.IVTd01201.finacial_m, 
      dbo.IVTd01201.finacial_datetime, dbo.IVTd01201.voucher_id, 
      dbo.IVTd01201.origin_voucher_id, dbo.IVTd01201.ivt_oper_id, 
      dbo.IVTd01201.voucher_status, dbo.IVTd01201.ivt_whyoper_id, 
      dbo.IVTd01201.store_date, dbo.IVTd01201.dept_id, dbo.IVTd01201.regionalism_id, 
      dbo.IVTd01201.customer_id, dbo.IVTd01201.clerk_id, dbo.IVTd01201.corp_id, 
      dbo.IVTd01201.ivt_operator, dbo.IVTd01201.ivt_oper_clerk, 
      dbo.IVTd01201.ivt_oper_time, dbo.IVTd01201.check_comfirm_flag, 
      dbo.IVTd01201.check_and_acceptor, dbo.IVTd01201.CheckAndAcceptTime, 
      dbo.IVTd01201.comfirm_flag, dbo.IVTd01201.ivt_oper_cfm, 
      dbo.IVTd01201.ivt_oper_cfm_time, dbo.IVTd01201.mainten_clerk_id, 
      dbo.IVTd01201.maintenance_datetime, dbo.IVTd01201.ivt_oper_bill, 
      dbo.IVTd01201.i_factacceptsum, dbo.IVTd01201.i_suitacceptsum, 
      dbo.IVTd01201.i_oweacceptsum, dbo.IVTd01202.peijian_id, 
      dbo.IVTd01202.corpstorestruct_id, dbo.IVTd01202.store_struct_id, 
      dbo.IVTd01202.pack_unit, dbo.IVTd01202.pack_num, dbo.IVTd01202.oddment_num, 
      dbo.IVTd01202.pass_oq, dbo.IVTd01202.item_yardPrice, 
      dbo.IVTd01202.item_Sellprice, dbo.IVTd01202.item_zeroSell, 
      dbo.IVTd01201.c_memo
FROM dbo.IVTd01201 LEFT OUTER JOIN
      dbo.IVTd01202 ON dbo.IVTd01201.com_id = dbo.IVTd01202.com_id AND 
      dbo.IVTd01201.ivt_oper_listing = dbo.IVTd01202.ivt_oper_listing

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

