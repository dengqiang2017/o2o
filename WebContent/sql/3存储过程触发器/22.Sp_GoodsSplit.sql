if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_GoodsSplit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_GoodsSplit]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--物品拆卸
CREATE    PROCEDURE Sp_GoodsSplit 
	@com_id char(10),
        @ivt_oper_listing varchar(30),
        @comfirm_flag varchar(1)
  
AS
BEGIN TRANSACTION mytranSp_GoodsSplit
        declare @store_struct_id varchar(30),@so_effect_datetime datetime,@i_price decimal(17,6),@accn_ivt decimal(17,6),
        @item_id char(40),@lot_number varchar(40),@finacial_y int,@finacial_m tinyint,@sum_si decimal(17,6),
        @ivt_oper_bill varchar(30),@tax_sum_si decimal(17,6),@sd_oq decimal(15,6),@Maitem_id  char(40),
        @group_oq decimal(17,6),@group_cost  decimal(17,6),@group_sum decimal(17,6),@daistore_struct_id varchar(30),@sd_unit_price decimal(17,6)

--先处理从表
declare mycur  CURSOR FOR 
select ltrim(rtrim(isnull(a.item_id,''))) as item_id,a.lot_number,a.sum_si,a.sd_oq,a.store_struct_id,a.sd_unit_price
from VIEW_ivtd03001 a  where ltrim(rtrim(isnull(a.ivt_oper_listing,''))) = ltrim(rtrim(isnull(@ivt_oper_listing,''))) and a.com_id = @com_id
  and  ltrim(rtrim(isnull(a.item_id,''))) in ( select ltrim(rtrim(isnull(p.item_id,''))) from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )  ----从表
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@lot_number,@sum_si,@sd_oq,@daistore_struct_id,@sd_unit_price
WHILE @@FETCH_STATUS = 0
begin  
  if ltrim(rtrim(isnull(@comfirm_flag,'N')))='Y'
  begin
     select @i_price=isnull(c.i_price,0),@accn_ivt=isnull(c.accn_ivt,0) from ivtd01302 c where c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@daistore_struct_id,'')))   
     if @@rowcount =  0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,1900,01,ltrim(rtrim(isnull(@daistore_struct_id,''))),ltrim(rtrim(isnull(@item_id,''))),isnull(@sd_oq,0),isnull(@sd_oq,0),isnull(@sd_unit_price,0)) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+ isnull(@sd_oq,0), oh=isnull(accn_ivt,0)+ isnull(@sd_oq,0)   --拆卸时从表物品库房数量增加
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@daistore_struct_id,''))) 
     end

   end else begin/*------------------------------------------------弃审-----------------------------------------------------*/
     select @i_price=isnull(c.i_price,0),@accn_ivt=isnull(c.accn_ivt,0) from ivtd01302 c where c.com_id = @com_id 
     --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@daistore_struct_id,''))) 
     if @@rowcount<>  0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - isnull(@sd_oq,0),oh=isnull(accn_ivt,0)- isnull(@sd_oq,0) 
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@daistore_struct_id,''))) 
     end

  end
  FETCH NEXT FROM mycur 
	INTO @item_id,@lot_number,@sum_si,@sd_oq,@daistore_struct_id,@sd_unit_price
end
CLOSE mycur
DEALLOCATE mycur


--再处理主表

   if ltrim(rtrim(@comfirm_flag))='Y'
   begin
     SELECT  @Maitem_id=ltrim(rtrim(isnull(B.item_id,''))),@store_struct_id=B.store_struct_id,
             @group_oq=B.group_oq,@group_cost=B.group_cost,@group_sum=B.group_sum  
     FROM ivtd03001 B
     WHERE  ltrim(rtrim(isnull(B.ivt_oper_listing,''))) = ltrim(rtrim(isnull(@ivt_oper_listing,'')))  AND B.COM_ID = @COM_ID   
       and  ltrim(rtrim(isnull(B.item_id,''))) in ( select ltrim(rtrim(isnull(p.item_id,''))) from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )  --主表

     select @i_price=isnull(c.i_price,0),@accn_ivt=isnull(c.accn_ivt,0) from ivtd01302 c where c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@Maitem_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_id,'')))   
     if @@rowcount=0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,1900,01,ltrim(rtrim(isnull(@store_struct_id,''))) ,ltrim(rtrim(isnull(@Maitem_id,''))),-isnull(@group_oq,0),0,isnull(@group_cost,0)) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-isnull(@group_oq,0)
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@Maitem_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_id,'')))   
     end

   end else begin    ------------------------------------------------弃审----------------------------------------------------
     SELECT  @Maitem_id=ltrim(rtrim(isnull(B.item_id,''))),@store_struct_id=ltrim(rtrim(isnull(B.store_struct_id,''))),
             @group_oq=B.group_oq,@group_cost=B.group_cost,@group_sum=B.group_sum  
     FROM ivtd03001 B
     WHERE  ltrim(rtrim(isnull(B.ivt_oper_listing,''))) = ltrim(rtrim(isnull(@ivt_oper_listing,'')))  AND B.COM_ID = @COM_ID   
       and  ltrim(rtrim(isnull(B.item_id,''))) in ( select ltrim(rtrim(isnull(p.item_id,''))) from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )  --主表

     select @i_price=isnull(c.i_price,0),@accn_ivt=isnull(c.accn_ivt,0) from ivtd01302 c where c.com_id = @com_id
            --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m             
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@Maitem_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_id,'')))   
 
     if @@rowcount<>  0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+isnull(@group_oq,0)
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@Maitem_id,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_id,'')))   
     end
   end


IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranSp_GoodsSplit
return 0
end else
begin
COMMIT TRANSACTION MyTranSp_GoodsSplit
return 1
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

