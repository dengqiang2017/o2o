if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[View_STDM03001]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[View_STDM03001]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW View_STDM03001
AS
SELECT STD03001.item_id,STD03001.lot_number,STD03001.rep_qty,STD03001.unit_id,STDM03001.com_id,
       STDM03001.rcv_auto_no,STDM03001.rcv_hw_no,STDM03001.vendor_id,STDM03001.mainten_clerk_id,
       STDM03001.mainten_datetime,STDM03001.comfirm_flag,STDM03001.ivt_oper_cfm,
       STDM03001.ivt_oper_cfm_time,STD03001.seeds_id,STDM03001.finacial_y,STDM03001.finacial_m,
       STD03001.price,STD03001.discount_rate,STDM03001.cgt_day,STDM03001.store_date,
       STDM03001.st_mode,STDM03001.payable_sum,STDM03001.arrearage,STDM03001.clerk_id,STDM03001.dept_id,
       STDM03001.st_auto_no,STD03001.tax_rate,STD03001.st_sum,STD03001.type_id,STDM03001.stock_type,
       STDM03001.reciever,STDM03001.rej_mix,STDM03001.rej_flag,STD03001.peijian_id,
       STD03001.store_struct_id,STD03001.[no],STD03001.c_memo,STD03001.oddment_num,STD03001.pack_num, 
       STD03001.pack_unit
FROM   STD03001 FULL OUTER JOIN
       STDM03001 ON STD03001.com_id=STDM03001.com_id AND 
       STD03001.rcv_auto_no=STDM03001.rcv_auto_no


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

