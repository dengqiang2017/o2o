if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_baseinitStore]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_baseinitStore]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--库存初始化
CREATE    PROCEDURE sp_baseinitStore 
          @com_id char(10),
          @ivt_num_detail int,
          @initial_flag char(1)
AS 
BEGIN TRANSACTION mytransp_baseinitStore
   
     declare @finacial_y int,@finacial_m tinyint,@store_struct_id varchar(30),@item_id char(40),
     @lot_number varchar(40),@oh decimal(28,6),@i_price decimal(28,6),@accn_ivt decimal(28,6),
     @mainten_clerk_id varchar(35),@store_price decimal(28,6),@store_accn_ivt decimal(28,6),
     @item_yardPrice decimal(28,6),@item_Sellprice decimal(28,6),@item_zeroSell decimal(28,6)

declare mycur  CURSOR FOR 
select b.finacial_y,b.finacial_m,b.store_struct_id,b.item_id,b.oh,b.i_price,
       b.accn_ivt,b.mainten_clerk_id,b.item_yardPrice,b.item_Sellprice,b.item_zeroSell from ivtd01300 b
where  b.com_id = @com_id and b.ivt_num_detail=@ivt_num_detail
  and  ltrim(rtrim(isnull(b.item_id,''))) in ( select ltrim(rtrim(isnull(p.item_id,''))) from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )
        
OPEN mycur
FETCH NEXT FROM mycur 
INTO @finacial_y,@finacial_m,@store_struct_id,@item_id,@oh,@i_price,@accn_ivt,@mainten_clerk_id,@item_yardPrice,@item_Sellprice,@item_zeroSell
WHILE @@FETCH_STATUS = 0
begin
   select @store_struct_id=ltrim(rtrim(isnull(@store_struct_id,''))) 
  
   if ltrim(rtrim(isnull(@initial_flag,'')))='Y'
   begin  
     select  @store_price=a.i_price,@store_accn_ivt=a.accn_ivt from ivtd01302 a  where a.com_id=@com_id 
    -- and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
     and isnull(a.store_struct_id,'')=@store_struct_id and a.item_id=@item_id 
     if @@rowcount=0 
     begin
       insert into ivtd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,
       oh,i_price,accn_ivt,count_flag,initial_flag,mainten_clerk_id,maintenance_datetime,item_yardPrice,item_Sellprice,item_zeroSell ) values 
       (@com_id,@finacial_y,@finacial_m,@store_struct_id,@item_id,@oh,@i_price,@oh,'',
       '',@mainten_clerk_id,getdate(),@item_yardPrice,@item_Sellprice,@item_zeroSell )
     end else begin
       update ivtd01302 set oh=isnull(oh,0)+@oh,accn_ivt=isnull(accn_ivt,0)+@oh,
       i_price=(case   when (@store_accn_ivt+@oh)=0 then @i_price  else 
       (@store_price*@store_accn_ivt+@oh*@i_price)/(@store_accn_ivt+@oh)  end ) from ivtd01302 a  
       where a.com_id=@com_id 
       --and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
       and isnull(a.store_struct_id,'')=@store_struct_id and a.item_id=@item_id 
    end
  end else begin/*----------------------------弃审---------------------------------------*/
    select  @store_price=a.i_price,@store_accn_ivt=a.accn_ivt from ivtd01302 a  
    where a.com_id=@com_id --and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
      and ltrim(rtrim(isnull(a.store_struct_id,'')))=ltrim(rtrim(isnull(@store_struct_id,'')))
      and ltrim(rtrim(isnull(a.item_id,'')))=ltrim(rtrim(isnull(@item_id,''))) 
    if @@rowcount<>0 
    begin
      update ivtd01302 set oh=isnull(oh,0)-@oh,accn_ivt=isnull(accn_ivt,0)-@oh,
      i_price=(case   when (@store_accn_ivt-@oh)=0 then @i_price  else 
       (@store_price*@store_accn_ivt-@oh*@i_price)/(@store_accn_ivt-@oh)  end ) from ivtd01302 a  
      where a.com_id=@com_id --and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
      and ltrim(rtrim(isnull(a.store_struct_id,'')))=ltrim(rtrim(isnull(@store_struct_id,'')))
      and ltrim(rtrim(isnull(a.item_id,'')))=ltrim(rtrim(isnull(@item_id,'')))   
    end
  end
 
  FETCH NEXT FROM mycur 
INTO @finacial_y,@finacial_m,@store_struct_id,@item_id,@oh,@i_price,@accn_ivt,@mainten_clerk_id,@item_yardPrice,@item_Sellprice,@item_zeroSell

end
CLOSE mycur
DEALLOCATE mycur

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTransp_baseinitStore
end else
begin
COMMIT TRANSACTION MyTransp_baseinitStore
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

