if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pro_update_Ivtd01302]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pro_update_Ivtd01302]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--库存调拨单生产入库、物资领用、库存报损审核与弃审
CREATE    PROCEDURE pro_update_Ivtd01302 
	@com_ID char(10),
        @ivt_oper_listing varchar(30),
        @ivt_oper_id char(4),
        @comfirm_flag char(1)
 
AS
BEGIN TRANSACTION mytranpro_update_Ivtd01302
        declare @store_struct_id varchar(30),@corpstorestruct_id varchar(30),@store_date datetime,@customer_id varchar(30),
        @item_id char(40),@finacial_y int,@finacial_m int,
        @oper_qty decimal(15,6),@plan_price decimal(15,6),@oper_price decimal(15,6),  --@oper_price(同价调拨)单价  @plan_price(同价调拨)金额 
                                @pass_oq decimal(15,6),@base_oq decimal(15,6),        --@base_oq变价调入单价       @pass_oq变价调入金额
        @i_price decimal(15,6),@accn_ivt decimal(15,6),@i_suitacceptsum decimal(15,6),--应收
        @scurDate varchar(30),@S_RKDH varchar(30),@clerk_id varchar(35),
        @i_factacceptsum decimal(15,6),@prefix varchar(20),@suffix varchar(20),@numb varchar(10), @feiyongdan varchar(30),
        @d_currentDate varchar(30),@i_currentValue int,@dept_id varchar(30),@mainten_clerk_id varchar(35),@jiesuan varchar(35),/*结算方式*/
        @expenses_id varchar(35)/*费用科目*/

	SELECT  @FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M = B.FINACIAL_M,@STORE_DATE=B.STORE_DATE,@CUSTOMER_ID=B.CUSTOMER_ID,
        @i_suitacceptsum=B.i_suitacceptsum,@I_FACTACCEPTSUM=B.I_FACTACCEPTSUM,@dept_id=b.dept_id,@mainten_clerk_id=b.mainten_clerk_id,
        @expenses_id=b.store_struct_id,@jiesuan=b.ivt_oper_clerk,@clerk_id=b.clerk_id  FROM IVTD01201 B
	WHERE  B.IVT_OPER_LISTING = @IVT_OPER_LISTING AND B.COM_ID = @COM_ID AND B.IVT_OPER_ID=@IVT_OPER_ID             

declare mycur  CURSOR FOR 
select a.item_id,a.oper_qty,a.plan_price,a.oper_price,a.base_oq,a.pass_oq,a.store_struct_id,a.corpstorestruct_id from IVTd01202 a
where  a.ivt_oper_listing =@ivt_oper_listing and a.com_id = @com_id
  and  a.item_id in ( select p.item_id from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@oper_qty,@plan_price,@oper_price,@base_oq,@pass_oq,@store_struct_id,@corpstorestruct_id
WHILE @@FETCH_STATUS = 0
begin
   select @store_struct_id=ltrim(rtrim(isnull(@store_struct_id,'')))        --入库、出库或调出
   select @corpstorestruct_id=ltrim(rtrim(isnull(@corpstorestruct_id,'')))  --调入仓
   if rtrim(ltrim(@comfirm_flag))='Y'
   begin
    
   if ltrim(rtrim(@ivt_oper_id))='入库'  
   begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id  
     if @@rowcount =  0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,@oper_qty,0,@oper_price) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @oper_qty,       
       i_price=(case   when (@accn_ivt+@oper_qty)=0 then @i_price  else 
      ((@i_price*@accn_ivt+@plan_price)/(@accn_ivt+@oper_qty))  end )
       from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end  
   end

   if ltrim(rtrim(@ivt_oper_id))='报损'
   begin  
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     if @@rowcount <> 0
     begin
       update ivtd01302 set accn_ivt=accn_ivt - @oper_qty
       from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end 

     set @scurDate=(select  convert(varchar(10),getdate(),21))

     select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
     @i_currentValue=a.i_currentValue  from ctl00190  a 
     where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
     if @@rowcount=0 
     begin
       insert into ctl00190(com_id,ruleapply_occasion,prefix,suffix,d_currentDate,i_currentValue)
       values (@com_id,'费用管理','NO.','FYGL',@scurDate,1)
     end
     select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
     @i_currentValue=a.i_currentValue  from ctl00190  a 
     where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
 
     if @scurDate>@d_currentDate       --如果当前日期大于实际日期
     begin
       update ctl00190 set d_currentDate=@scurDate,i_currentValue=1 from ctl00190 a 
       where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
     end else begin
       update ctl00190 set i_currentValue=i_currentValue+1 from ctl00190 a 
       where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
     end

     select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
     @i_currentValue=a.i_currentValue  from ctl00190  a 
     where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'

     set @d_currentDate=substring(@d_currentDate,1,4)+substring(@d_currentDate,6,2)+substring(@d_currentDate,9,2)
     select @S_RKDH =@i_currentValue

     while  len(ltrim(rtrim(@S_RKDH))) < 3
     begin
       select  @S_RKDH = '0'+ ltrim(rtrim(@S_RKDH))
       if len(ltrim(rtrim(@S_RKDH))) > 3
           break
     end
     select @S_RKDH=ltrim(rtrim(@prefix))+ltrim(rtrim(@d_currentDate))
               +ltrim(rtrim(@S_RKDH))+ltrim(rtrim(@suffix))         
   
     insert into SDDM03001(com_id,finacial_y,finacial_m,ivt_oper_listing,sd_order_id,finacial_d,dept_id,clerk_id,
     sum_si,bill_source,billNO,charg_no,waigou_ivt_oper) values (@com_id,@finacial_y,@finacial_m,@S_RKDH,@S_RKDH,@STORE_DATE,
     @dept_id,@clerk_id,@plan_price,'库存报损',@jiesuan,'',@ivt_oper_listing)

     insert into SDD03001(com_id,ivt_oper_listing,expenses_id,sum_si,vendor_id,customer_id,reason,sd_order_id)
     values (@com_id,@S_RKDH,@expenses_id,@plan_price,'','','',@ivt_oper_listing) 

   end

   if ltrim(rtrim(@ivt_oper_id))='出库'
   begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id  
     if @@rowcount =  0   --增加负数
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,-@oper_qty,0,@oper_price) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-@oper_qty,
       i_price=(case   when (@accn_ivt-@oper_qty)=0 then @i_price else 
       ((@i_price*@accn_ivt-@plan_price)/(@accn_ivt-@oper_qty))  end )   from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id  
     end
   end

   if ltrim(rtrim(@ivt_oper_id))='调拨'  
   begin
                                 --调拨出库
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id --调拨出库
     if @@rowcount=  0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,-@oper_qty,0,@oper_price) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-@oper_qty,
         i_price=(case   when (@accn_ivt-@oper_qty)=0 then @i_price else 
         ((@i_price*@accn_ivt-@plan_price)/(@accn_ivt-@oper_qty))  end )   from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id  --调拨出库
     end
                                 --调拨入库，入库单价上：存在同价调拨和变价调拨的区别
     if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id )='1' --MoveStore_Style='1'同价调拨  
     begin
       select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库
       if @@rowcount =  0
       begin
         insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
         values(@com_id,@finacial_y,@finacial_m ,@corpstorestruct_id,@item_id,@oper_qty,0,@oper_price) 
       end else begin
         update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @oper_qty,
           i_price=(case   when (@accn_ivt+@oper_qty)=0 then @i_price  else 
           ((@i_price*@accn_ivt+@plan_price)/(@accn_ivt+@oper_qty))  end ) from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库
       end
     end else   --MoveStore_Style='0'变价调拨
     begin
       select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库
       if @@rowcount =  0
       begin
         insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
         values(@com_id,@finacial_y,@finacial_m ,@corpstorestruct_id,@item_id,@oper_qty,0,@base_oq)    --@base_oq:变价调拨单价
       end else begin
         update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @oper_qty,
           i_price=(case   when (@accn_ivt+@oper_qty)=0 then @base_oq  else 
          ((@i_price*@accn_ivt+@pass_oq)/(@accn_ivt+@oper_qty))  end ) from ivtd01302 c 
         where  c.com_id = @com_id 
         --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
         and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库     --@pass_oq:变价调拨金额
       end
     end
   end
   end else begin    -----------------------------------------弃审-------------------------------------------------------

   if ltrim(rtrim(@ivt_oper_id))='入库'
   begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
     if @@rowcount <>0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @oper_qty,       
       i_price=(case   when (@accn_ivt-@oper_qty)=0 then @i_price else 
       ((@i_price*@accn_ivt-@plan_price)/(@accn_ivt-@oper_qty))  end ) 
       from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end  
   end

   if ltrim(rtrim(@ivt_oper_id))='报损'
   begin  
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     if @@rowcount<> 0
     begin
       update ivtd01302 set accn_ivt=accn_ivt + @oper_qty
       from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end  
     delete from  SDDM03001 where com_id=@com_id and  waigou_ivt_oper=@ivt_oper_listing
     delete from  SDD03001  where com_id=@com_id and  sd_order_id=@ivt_oper_listing

   end

   if ltrim(rtrim(@ivt_oper_id))='出库'
   begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     if @@rowcount <> 0    --增加数量
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+@oper_qty,
       i_price=(case   when (@accn_ivt+@oper_qty)=0 then @i_price  else 
      ((@i_price*@accn_ivt+@plan_price)/(@accn_ivt+@oper_qty))  end )   from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
   end

   if ltrim(rtrim(@ivt_oper_id))='调拨'  
   begin
                                 --调拨出库弃审
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id --调拨出库
     if @@rowcount<> 0    --增加负数
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+@oper_qty, 
         i_price=(case   when (@accn_ivt+@oper_qty)=0 then @i_price  else 
         ((@i_price*@accn_ivt+@plan_price)/(@accn_ivt+@oper_qty))  end ) from ivtd01302 c 
     where  c.com_id = @com_id 
     --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
                                 --调拨入库弃审，入库单价上：存在同价调拨和变价调拨的区别
     if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id )='1'   --MoveStore_Style='1' 同价调拨
     begin
       select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
       where  c.com_id = @com_id 
       --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库 
       if @@rowcount <>  0
       begin
         update ivtd01302 set accn_ivt=isnull(accn_ivt,0)- @oper_qty,  
           i_price=(case   when (@accn_ivt-@oper_qty)=0 then @i_price else 
           ((@i_price*@accn_ivt-@plan_price)/(@accn_ivt-@oper_qty))  end )   from ivtd01302 c 
       where  c.com_id = @com_id 
       --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库
       end
     end else   --MoveStore_Style='0' 变价调拨
     begin
       select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
       where  c.com_id = @com_id 
       --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库
       if @@rowcount <>  0
       begin
         update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @oper_qty,
           i_price=(case   when (@accn_ivt-@oper_qty)=0 then @base_oq  else 
          ((@i_price*@accn_ivt-@pass_oq)/(@accn_ivt-@oper_qty))  end ) from ivtd01302 c 
       where  c.com_id = @com_id 
       --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库    --@pass_oq:变价调拨金额
       end
     end
   end


   if ltrim(rtrim(@ivt_oper_id))='调拨'
   begin
     select accn_ivt from ivtd01302 c 
       where  c.com_id = @com_id 
       --and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @corpstorestruct_id  --调拨入库

   end

   end

FETCH NEXT FROM mycur 
INTO @item_id,@oper_qty,@plan_price,@oper_price,@base_oq,@pass_oq,@store_struct_id,@corpstorestruct_id
end
CLOSE mycur
DEALLOCATE mycur
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranpro_update_Ivtd01302
end else
begin
COMMIT TRANSACTION MyTranpro_update_Ivtd01302
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

