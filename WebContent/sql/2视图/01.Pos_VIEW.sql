if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Pos_VIEW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[Pos_VIEW]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW Pos_VIEW
AS 
SELECT PosBill.com_id, PosBill.ivt_oper_listing, PosBill.BillDate, 
      PosBill.store_struct_id, PosBill.clerk_id, PosBill.i_AMount, 
      PosBill.RealAmount, PosBill.CashAmount, PosBill.ChangeAmount, 
      PosBill.IsCloseOff, PosBill.sumoq, PosDetail.sno, PosBill.sd_date,
      PosDetail.item_id, PosDetail.peijian_id, PosDetail.sd_oq, 
      PosDetail.sd_price, PosDetail.i_discount, PosDetail.Amount, 
      PosDetail.seeds_id
FROM PosBill INNER JOIN
      PosDetail ON PosBill.ivt_oper_listing = PosDetail.ivt_oper_listing AND 
      PosBill.com_id = PosDetail.com_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

