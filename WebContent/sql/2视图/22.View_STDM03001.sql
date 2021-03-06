if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[View_STDM03001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[View_STDM03001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.View_STDM03001
AS
SELECT dbo.STD03001.item_id, dbo.STD03001.lot_number, dbo.STD03001.rep_qty, 
      dbo.STD03001.unit_id, dbo.STDM03001.com_id, dbo.STDM03001.rcv_auto_no, 
      dbo.STDM03001.rcv_hw_no, dbo.STDM03001.vendor_id, 
      dbo.STDM03001.mainten_clerk_id, dbo.STDM03001.mainten_datetime, 
      dbo.STDM03001.comfirm_flag, dbo.STDM03001.ivt_oper_cfm, 
      dbo.STDM03001.ivt_oper_cfm_time, dbo.STD03001.seeds_id, 
      dbo.STDM03001.finacial_y, dbo.STDM03001.finacial_m, dbo.STD03001.price, 
      dbo.STD03001.discount_rate, dbo.STDM03001.cgt_day, dbo.STDM03001.store_date, 
      dbo.STDM03001.st_mode, dbo.STDM03001.payable_sum, 
      dbo.STDM03001.arrearage, dbo.STDM03001.clerk_id, dbo.STDM03001.dept_id, 
      dbo.STDM03001.st_auto_no, dbo.STD03001.tax_rate, dbo.STD03001.st_sum, 
      dbo.STD03001.type_id, dbo.STDM03001.stock_type, dbo.STDM03001.reciever, 
      dbo.STDM03001.rej_mix, dbo.STDM03001.rej_flag, dbo.STD03001.peijian_id, 
      dbo.STD03001.store_struct_id, dbo.STD03001.[no], dbo.STD03001.c_memo, 
      dbo.STD03001.oddment_num, dbo.STD03001.pack_num, dbo.STD03001.pack_unit, 
      dbo.STDM03001.c_memo AS c_memoMain, dbo.STD03001.item_Lenth, 
      dbo.STD03001.item_Width, dbo.STD03001.item_Hight, dbo.STD03001.finacial_d, 
      dbo.STD03001.at_term_datetime
FROM dbo.STD03001 FULL OUTER JOIN
      dbo.STDM03001 ON dbo.STD03001.com_id = dbo.STDM03001.com_id AND 
      dbo.STD03001.rcv_auto_no = dbo.STDM03001.rcv_auto_no

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

