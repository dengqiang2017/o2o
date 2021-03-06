if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_clearAccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clearAccount]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE sp_clearAccount 
	@com_ID char(10)
as
BEGIN TRANSACTION mytransp_clearAccount
        declare @finacial_y int,
	@finacial_m tinyint


/*--阶段库存明细表  IVTd01302*/
DELETE FROM IVTd01302 WHERE com_id = @com_id
/*--应收帐款ARdM02011*/
DELETE FROM ARdM02011 WHERE com_id = @com_id 
/*--应付帐款stdM0201*/
DELETE FROM stdM0201 WHERE com_id = @com_id 
/*--固定资产分摊统计表  GAf02020*/
delete from  GAf02020 WHERE com_id = @com_id
/*--销售订单（数据表） SDd02010*/
update SDd02010 set comfirm_flag='N',alr_oq=0 from SDd02010 where com_id = @com_id
/*--销售发货、现金和退货（数据表） SDd02020*/
update SDd02020 set comfirm_flag='N',alr_oq=0 from SDd02020 where com_id = @com_id
/*--销售回款和采购付款 ARd02051*/
update ARd02051 set comfirm_flag='N' from ARd02051 where com_id = @com_id
/*--采购订单*/
update STDM02001 set comfirm_flag='N',alr_oq=0  from STDM02001  where com_id=@com_id 
/*--采购进货、退货*/
update STDM03001 set comfirm_flag='N',arrearage=0  from STDM03001  where com_id=@com_id 
/*--库存操作和其他物资外购入库*/
update IVTd01201 set comfirm_flag='N' from IVTd01201 where com_id = @com_id
/*--盘存数据表  IVTd01310*/
update IVTd01310 set count_flag='N' from IVTd01310 WHERE com_id = @com_id
/*--费用数据表  SDDM03001*/
update SDDM03001 set comfirm_flag='N' from SDDM03001 WHERE com_id = @com_id
/*--更改扎帐标志*/
update ctl02101 set finacial_month_status='' from ctl02101 where com_id=@com_id
select  @finacial_y=min(finacial_y),@finacial_m=min(finacial_m)  from ctl02101 where com_id=@com_id
/*--库存初始化   */
update Ivtd01300 set initial_flag='N',finacial_m=@finacial_m,finacial_y=@finacial_y from Ivtd01300 where com_id = @com_id
/*--客户应收初始化*/
update ARf02030 set initial_flag='N',finacial_m=@finacial_m,finacial_y=@finacial_y  from ARf02030 WHERE com_id = @com_id
/*--应付帐款初始化*/
update stfM0201 set initial_flag='N',finacial_m=@finacial_m,finacial_y=@finacial_y from stfM0201 WHERE com_id = @com_id

delete from  ARd02051 where com_id = @com_id and rejg_hw_no in (select ivt_oper_listing from SDd02020 
where comfirm_flag='N'  and  com_id = @com_id  )
/*--销售回款中现款销售的记录ARd02051*/

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytransp_clearAccount
end else
begin
COMMIT TRANSACTION mytransp_clearAccount
end




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

