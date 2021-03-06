if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VIEW_ivtd03001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[VIEW_ivtd03001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.VIEW_ivtd03001
AS
SELECT dbo.ivtd03001.finacial_y, dbo.ivtd03001.finacial_m, 
      dbo.ivtd03001.store_struct_id AS manstore_struct_id, dbo.ivtd03001.dept_id, 
      dbo.ivtd03001.clerk_id, dbo.ivtd03001.so_effect_datetime, 
      dbo.ivtd03001.unit_id AS manunit_id, dbo.ivtd03001.item_id AS manitem_id, 
      dbo.ivtd03001.group_oq, dbo.ivtd03001.group_cost, dbo.ivtd03001.group_sum, 
      dbo.ivtd03001.alr_oq, dbo.ivtd03001.group_split, dbo.ivtd03001.mainten_datetime, 
      dbo.ivtd03001.comfirm_flag, dbo.ivtd03002.seeds_id, dbo.ivtd03002.com_id, 
      dbo.ivtd03002.ivt_oper_listing, dbo.ivtd03002.sd_order_id, dbo.ivtd03002.[no], 
      dbo.ivtd03002.c_memo, dbo.ivtd03002.item_id, dbo.ivtd03002.peijian_id, 
      dbo.ivtd03002.lot_number, dbo.ivtd03002.sd_oq, dbo.ivtd03002.unit_id, 
      dbo.ivtd03002.sd_unit_price, dbo.ivtd03002.discount_rate, dbo.ivtd03002.tax_rate, 
      dbo.ivtd03002.sum_si, dbo.ivtd03002.base_price, dbo.ivtd03002.store_struct_id, 
      dbo.ivtd03002.base_oq, dbo.ivtd03002.type_id, dbo.ivtd03002.send_qty, 
      dbo.ivtd03002.send_sum, dbo.ivtd03002.tax_sum_si, dbo.ivtd03002.base_unit_id, 
      dbo.ivtd03002.pack_unit, dbo.ivtd03002.pack_num, 
      dbo.ivtd03002.oddment_num
FROM dbo.ivtd03001 LEFT OUTER JOIN
      dbo.ivtd03002 ON dbo.ivtd03001.com_id = dbo.ivtd03002.com_id AND 
      dbo.ivtd03001.ivt_oper_listing = dbo.ivtd03002.ivt_oper_listing

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

