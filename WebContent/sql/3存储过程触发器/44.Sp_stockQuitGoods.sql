if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_stockQuitGoods]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_stockQuitGoods]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--采购退货
CREATE   PROCEDURE Sp_stockQuitGoods 
	@com_ID char(10),
        @rcv_auto_no varchar(30),
        @comfirm_flag char(1)
 
AS
BEGIN TRANSACTION mytranSp_stockQuitGoods
        declare @store_struct_id varchar(30),@store_date datetime,@vendor_id varchar(30),@i_price decimal(17,6),@accn_ivt decimal(17,6),
        @item_id char(40),@lot_number varchar(40),@finacial_y int,@finacial_m tinyint,@rep_qty decimal(17,6),@st_sum decimal(17,6),
        @st_auto_no varchar(30),@price decimal(17,6)


SELECT  @FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M = B.FINACIAL_M,@STORE_DATE=B.STORE_DATE,@vendor_id=B.vendor_id
FROM STDM03001 B  WHERE  B.rcv_auto_no = @rcv_auto_no AND B.COM_ID = @COM_ID

declare mycur  CURSOR FOR 
select a.item_id,a.lot_number,a.rep_qty,a.st_sum,a.store_struct_id,a.price from STD03001 a
where  a.rcv_auto_no=@rcv_auto_no  and a.com_id = @com_id
  and  a.item_id in ( select p.item_id from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )

OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@lot_number,@rep_qty,@st_sum,@store_struct_id,@price
WHILE @@FETCH_STATUS = 0
begin
  select @store_struct_id=ltrim(rtrim(isnull(@store_struct_id,'')))
  
  if rtrim(ltrim(@comfirm_flag))='Y'
  begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     if @@rowcount=  0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,-@rep_qty,0,@price) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @rep_qty,
       i_price=(case   when (@accn_ivt-@rep_qty)=0 then @i_price else 
       ((@i_price*@accn_ivt-@st_sum)/(@accn_ivt-@rep_qty))  end )
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
     
     select vendor_id from stdM0201 a where a.com_id = @com_id and a.vendor_id=@vendor_id --a.finacial_y = @finacial_y and  and a.finacial_m = @finacial_m 
     if @@rowcount=0 
     begin
       insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,balance_sum,end_sum )
       values (@com_id,@finacial_y,@finacial_m,@vendor_id,0,-@st_sum,0,0,-@st_sum )
     end else begin
       update stdM0201 set increase=isnull(increase,0)-@st_sum,
       end_sum=isnull(beg_sum,0)+isnull(increase,0)-@st_sum-isnull(decrease,0)-isnull(balance_sum,0) from stdM0201 
       a where a.com_id = @com_id and a.vendor_id=@vendor_id --a.finacial_y = @finacial_y and  and a.finacial_m = @finacial_m
     end
     update STDM03001 set arrearage=isnull(arrearage,0)+@rep_qty  from STDM03001 a where a.com_id=@com_id 
     and a.rcv_auto_no=@st_auto_no 

  end else begin/*------------------------------------------------------弃审------------------------------------------------------*/
 
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id  
     if @@rowcount <>  0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @rep_qty,
      i_price=(case   when (@accn_ivt+@rep_qty)=0 then @i_price  else 
      ((@i_price*@accn_ivt+@st_sum)/(@accn_ivt+@rep_qty))  end )
       from ivtd01302 c where c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id
     end
     
     select vendor_id from stdM0201 a where a.com_id = @com_id and a.vendor_id=@vendor_id --a.finacial_y = @finacial_y and  and a.finacial_m = @finacial_m
     if @@rowcount<>0 
     begin
       update stdM0201 set increase=isnull(increase,0)+@st_sum,
       end_sum=isnull(beg_sum,0)+isnull(increase,0)+@st_sum-isnull(decrease,0)-isnull(balance_sum,0)  from stdM0201 
       a where a.com_id = @com_id and a.vendor_id=@vendor_id --a.finacial_y = @finacial_y and  and a.finacial_m = @finacial_m
     end
     
     update STDM03001 set arrearage=isnull(arrearage,0)-@rep_qty  from STDM03001 a where a.com_id=@com_id 
     and a.rcv_auto_no=@st_auto_no /*'借货'防止销售弃审删除已经退货的借货记录；主要是防止帐务出错。*/

  end


   FETCH NEXT FROM mycur 
       INTO @item_id,@lot_number,@rep_qty,@st_sum,@store_struct_id,@price
end
CLOSE mycur
DEALLOCATE mycur

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranSp_stockQuitGoods
end else
begin
COMMIT TRANSACTION MyTranSp_stockQuitGoods
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

