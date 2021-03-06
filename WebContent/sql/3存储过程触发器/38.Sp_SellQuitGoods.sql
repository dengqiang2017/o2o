if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_SellQuitGoods]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_SellQuitGoods]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--销售退货
CREATE   PROCEDURE Sp_SellQuitGoods 
	@com_ID char(10),
        @ivt_oper_listing varchar(30),
        @comfirm_flag varchar(1)
  
AS
BEGIN TRANSACTION mytranSp_SellQuitGoods
        declare @store_struct_id varchar(30),@so_consign_date datetime,@customer_id varchar(30),@i_price decimal(17,6),
        @item_id char(40),@lot_number varchar(40),@finacial_y int,@finacial_m tinyint,@sd_oq decimal(17,6),@sum_si decimal(17,6),
        @ivt_oper_bill varchar(30),@tax_sum_si decimal(17,6),@accn_ivt decimal(17,6),@seeds_id int


	SELECT  @FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M = B.FINACIAL_M,@so_consign_date=B.so_consign_date,@customer_id=B.customer_id,
        @ivt_oper_bill=b.ivt_oper_bill  FROM SDd02020 B
	WHERE  B.ivt_oper_listing = @ivt_oper_listing  AND B.COM_ID = @COM_ID 

declare mycur  CURSOR FOR 
select a.item_id,a.lot_number,a.sd_oq,a.sum_si,a.store_struct_id,isnull(a.tax_sum_si,0),a.seeds_id from SDd02021 a
where  a.ivt_oper_listing=@ivt_oper_listing and a.com_id = @com_id
  and  a.item_id in ( select p.item_id from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@lot_number,@sd_oq,@sum_si,@store_struct_id,@tax_sum_si,@seeds_id
WHILE @@FETCH_STATUS = 0
begin
  select @store_struct_id=ltrim(rtrim(isnull(@store_struct_id,'')))
   
  if ltrim(rtrim(@comfirm_flag))='Y'
  begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  and 
     c.com_id = @com_id 
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
     if @@rowcount =  0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,@sd_oq,0,@tax_sum_si) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @sd_oq/*销售退货时库房数量增加*/
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end

     select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
     a.com_id = @com_id 
     and a.customer_id=@customer_id 
     if @@rowcount=0 
     begin
       insert into ARdM02011(com_id, finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum)
       values (@com_id,@finacial_y,@finacial_m,@customer_id,0,-@sum_si,0,0,-@sum_si) 
     end else  begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)-@sum_si,
       acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-@sum_si-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)  from ARdM02011 
       a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id
     end

     update SDd02020 set alr_oq=isnull(alr_oq,0)+@sd_oq  from SDd02020 a where a.com_id=@com_id 
     and a.ivt_oper_listing=@ivt_oper_bill 

    update SDd02021 set tax_sum_si=(select isnull(i_price,0)  from ivtd01302  where com_id=sdd02021.com_id  
    and store_struct_id=sdd02021.store_struct_id  and item_id=@item_id) from SDd02021  where com_id=@com_id /*审核时更改成本*/
    and ivt_oper_listing=@ivt_oper_listing  and  item_id=@item_id and seeds_id=@seeds_id  and store_struct_id= @store_struct_id  

  end else begin/*弃审*/

     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  and 
      c.com_id = @com_id 
      and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
      if @@rowcount<>  0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @sd_oq
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end

     select customer_id from ARdM02011 a where a.com_id = @com_id 
     --and a.finacial_y = @finacial_y  and a.finacial_m = @finacial_m  
     and a.customer_id=@customer_id 
     if @@rowcount<>0 
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)+@sum_si,
       acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)+@sum_si-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)  from ARdM02011 
       a where a.com_id = @com_id 
       --a.finacial_y = @finacial_y and and a.finacial_m = @finacial_m  
        and a.customer_id=@customer_id
     end

     update SDd02020 set alr_oq=isnull(alr_oq,0)-@sd_oq  from SDd02020 a where a.com_id=@com_id 
     and a.ivt_oper_listing=@ivt_oper_bill 
  end

   FETCH NEXT FROM mycur 
	INTO @item_id,@lot_number,@sd_oq,@sum_si,@store_struct_id,@tax_sum_si,@seeds_id
end
CLOSE mycur
DEALLOCATE mycur
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranSp_SellQuitGoods
end else
begin
COMMIT TRANSACTION MyTranSp_SellQuitGoods
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

