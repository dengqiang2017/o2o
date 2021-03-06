if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_StoreCheck]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StoreCheck]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--库存盘点
CREATE       PROCEDURE sp_StoreCheck 
	@com_ID char(10),
        @ivt_oper_listing varchar(30),
        @count_flag char(1)
 
AS
BEGIN TRANSACTION mytransp_StoreCheck
      declare @store_struct_id varchar(30),@count_datetime datetime,@item_id char(40),@finacial_y int,@finacial_m int,
      @differ_quant decimal(28,6),@counted_price decimal(28,6),@differ_sum decimal(28,6),@counted_ivt decimal(28,6),@tax_sum_si decimal(28,6),
      @item_Sellprice decimal(28,6),@item_zeroSell decimal(28,6),@item_yardPrice decimal(28,6)
--@tax_sum_si:当前帐存成本价  @counted_price:实盘成本价       

	SELECT  @FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M = B.FINACIAL_M,@STORE_STRUCT_ID=B.STORE_STRUCT_ID    FROM IVTd01310 B
	WHERE  B.IVT_OPER_LISTING = @IVT_OPER_LISTING AND B.COM_ID = @COM_ID 

declare mycur  CURSOR FOR 
select a.item_id,a.differ_quant,a.counted_price,a.differ_sum,a.counted_ivt,a.tax_sum_si,
                       a.item_Sellprice,a.item_zeroSell,a.item_yardPrice
from IVTd01311 a
where  a.ivt_oper_listing =@ivt_oper_listing and a.com_id = @com_id
  and  a.item_id in ( select p.item_id from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@differ_quant,@counted_price,@differ_sum,@counted_ivt,@tax_sum_si,@item_Sellprice,@item_zeroSell,@item_yardPrice  
WHILE @@FETCH_STATUS = 0 
begin
   select @STORE_STRUCT_ID=ltrim(rtrim(isnull(@STORE_STRUCT_ID,'')))
   if ltrim(rtrim(@count_flag))='Y'
   begin
     select store_struct_id from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id
     if @@rowcount = 0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,@counted_ivt,0,@counted_price) 
     end else  begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @differ_quant,i_price=@counted_price,
                            item_Sellprice=@item_Sellprice,item_zeroSell=@item_zeroSell,item_yardPrice=@item_yardPrice
       from ivtd01302 c 
       where  c.com_id = @com_id 
       --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id
     end  
   end else begin     --弃审
     select store_struct_id from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id  
     if @@rowcount <>  0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @differ_quant,i_price=@tax_sum_si
       from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id
     end  

   end

FETCH NEXT FROM mycur 
INTO @item_id,@differ_quant,@counted_price,@differ_sum,@counted_ivt,@tax_sum_si,@item_Sellprice,@item_zeroSell,@item_yardPrice  

end
CLOSE mycur
DEALLOCATE mycur
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTransp_StoreCheck
return 0
end else
begin
COMMIT TRANSACTION MyTransp_StoreCheck
return 1
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

