if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_SellConsignment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_SellConsignment]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--销售开票：审核与弃审 
CREATE     PROCEDURE Sp_SellConsignment 
	@com_ID char(10),
        @ivt_oper_listing varchar(30),
        @comfirm_flag varchar(1)  
AS
BEGIN TRANSACTION mytranSp_SellConsignment
        declare @store_struct_id varchar(30),@so_consign_date datetime,@customer_id varchar(30),@i_price decimal(17,6),
        @item_id char(40),@lot_number varchar(40),@finacial_y int,@finacial_m int,@sd_oq decimal(17,6),@sum_si decimal(17,6),
        @ivt_oper_bill varchar(30),@tax_sum_si  decimal(17,6),@sd_order_direct char(4),@i_currentValue int,@d_currentDate varchar(30),
        @prefix varchar(20),@suffix varchar(20),@numb varchar(10) ,@recieved_auto_id varchar(30),@allsum_si decimal(17,6),
        @dept_id varchar(30),@ivt_oper_cfm varchar(35),@clerk_id varchar(35),@settlement_type_id varchar(30),@rev_days int,
        @vendor_id varchar(30),@scurDate varchar(30),@unit_id varchar(30),@type_id varchar(30),@peijian_id varchar(40),@seeds_id int,
        @S_RKDH varchar(30),@longdate varchar(30),@sort_id varchar(30),@sid int,@youhui_sum decimal(17,6),@accn_ivt decimal(17,6),
        @i_agiosum decimal(17,6)
           
     SELECT  @FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M = B.FINACIAL_M,@so_consign_date=B.so_consign_date,@customer_id=B.customer_id,
     @sd_order_direct=b.sd_order_direct,@allsum_si=b.sum_si,@ivt_oper_cfm=b.ivt_oper_cfm,@youhui_sum=isnull(b.youhui_sum,0),
     @dept_id=b.dept_id,@clerk_id=b.clerk_id,@settlement_type_id=b.settlement_type_id,@i_agiosum=isnull(b.i_agiosum,0)  FROM SDd02020 B
     WHERE  B.ivt_oper_listing = @ivt_oper_listing  AND B.COM_ID = @COM_ID    

declare mycur  CURSOR FOR 
select a.item_id,a.lot_number,a.sd_oq,a.sum_si,isnull(a.tax_sum_si,0),a.store_struct_id,a.vendor_id,a.rev_days,
       a.unit_id,a.type_id,a.peijian_id,a.ivt_oper_bill,a.sid,a.seeds_id  from SDd02021 a
where  a.ivt_oper_listing=@ivt_oper_listing and a.com_id = @com_id
  and ( ltrim(rtrim(isnull(a.item_id,''))) in ( select ltrim(rtrim(isnull(p.item_id,''))) from ctl03001 p where p.com_id=@com_id and ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' ) )
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@lot_number,@sd_oq,@sum_si,@tax_sum_si,@store_struct_id,@vendor_id,@rev_days,@unit_id,@type_id,@peijian_id,@ivt_oper_bill,@sid,@seeds_id
WHILE @@FETCH_STATUS = 0
begin  
 select  @store_struct_id=ltrim(rtrim(isnull(@store_struct_id,'') ))
 if ltrim(rtrim(@comfirm_flag))='Y'
 begin
   select @tax_sum_si=isnull(i_price,0) from ivtd01302 where com_id=@com_id and store_struct_id=@store_struct_id and item_id=@item_id
   update SDd02021 set tax_sum_si=@tax_sum_si from  SDd02021 where  ivt_oper_listing=@ivt_oper_listing and com_id = @com_id
   and store_struct_id=@store_struct_id and item_id=@item_id 

   if @rev_days=1 /*借货管理*/
   begin   
     set @scurDate=(select  convert(varchar(10),getdate(),21))/*当前日期*/
     select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
     @i_currentValue=a.i_currentValue  from ctl00190  a 
     where a.com_id = @com_id and a.ruleapply_occasion ='采购进货'
     if @@rowcount=0 
     begin
       insert into ctl00190(com_id,ruleapply_occasion,prefix,suffix,d_currentDate,i_currentValue)
       values (@com_id,'采购进货','NO.','CGJH',@scurDate,1)
     end
     select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
     @i_currentValue=a.i_currentValue  from ctl00190  a
     where a.com_id = @com_id and a.ruleapply_occasion ='采购进货'
     if @scurDate>@d_currentDate  /*如果当前日期大于实际日期*/
     begin
        update ctl00190 set d_currentDate=@scurDate,i_currentValue=1 from ctl00190 a 
	where a.com_id = @com_id and a.ruleapply_occasion ='采购进货'
     end else begin
       update ctl00190 set i_currentValue=i_currentValue+1 from ctl00190 a 
       where a.com_id = @com_id and a.ruleapply_occasion ='采购进货'
     end
     select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
     @i_currentValue=a.i_currentValue  from ctl00190  a 
     where a.com_id = @com_id and a.ruleapply_occasion ='采购进货'
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
     set @longdate=(select  convert(varchar(19),getdate(),21))/*当前日期*/
     insert into STDM03001(com_id,finacial_y,finacial_m,rej_flag,store_date,rcv_auto_no,rcv_hw_no,vendor_id,dept_id,clerk_id,
      st_sum,comfirm_flag,ivt_oper_cfm,ivt_oper_cfm_time,mainten_clerk_id,mainten_datetime,stock_type,c_memo,payable_sum,adress_id,arrearage)
      values (@com_id,@finacial_y,@finacial_m,'1',@so_consign_date,@S_RKDH,@S_RKDH,@vendor_id,@dept_id,@clerk_id,@tax_sum_si*@sd_oq,'Y',
      @ivt_oper_cfm,@longdate,@ivt_oper_cfm,@longdate,'借货','借货',@sd_oq,@ivt_oper_listing,@tax_sum_si*@sd_oq)

     insert into STD03001(com_id,rcv_auto_no,rcv_hw_no,item_id,rep_qty,lot_number,unit_id,price,st_sum,type_id,
      peijian_id,store_struct_id,no,st_auto_no) values (@com_id,@S_RKDH,@S_RKDH,@item_id,@sd_oq,@lot_number,@unit_id,
      @tax_sum_si,@tax_sum_si*@sd_oq,@type_id,@peijian_id,@store_struct_id,1,@ivt_oper_listing)
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and 
       c.com_id = @com_id 
       --and c.finacial_m = @finacial_m  
       and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id   
     if @@rowcount =  0/*增加库存数量*/
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,@sd_oq,0,@tax_sum_si) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @sd_oq,
       i_price=(case   when (@accn_ivt+@sd_oq)=0 then @i_price  else 
      ((@i_price*@accn_ivt+@tax_sum_si*@sd_oq)/(@accn_ivt+@sd_oq))  end )
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id 
     end   
     select vendor_id from stdM0201 a where --a.finacial_y = @finacial_y and 
       a.com_id = @com_id 
       --and a.finacial_m = @finacial_m  
       and a.vendor_id=@vendor_id 
     if @@rowcount=0 
     begin
       insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,end_sum )
       values (@com_id,@finacial_y,@finacial_m,@vendor_id,0,@tax_sum_si*@sd_oq,0,@tax_sum_si*@sd_oq )
     end else begin
       update stdM0201 set increase=isnull(increase,0)+@tax_sum_si*@sd_oq,
       end_sum=isnull(beg_sum,0)+isnull(increase,0)+@tax_sum_si*@sd_oq-isnull(decrease,0) from stdM0201 a 
       where --a.finacial_y = @finacial_y and 
          a.com_id = @com_id 
        -- and a.finacial_m = @finacial_m  
          and a.vendor_id=@vendor_id
     end
   end
   if rtrim(ltrim(@sd_order_direct))='发货'
   begin 
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where c.com_id = @com_id 
--     and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
     if @@rowcount= 0
     begin 
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,-@sd_oq,0,@tax_sum_si) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-@sd_oq
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
     select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and 
        a.com_id = @com_id 
        --and a.finacial_m = @finacial_m  
        and a.customer_id=@customer_id 
     if @@rowcount=0 
     begin
       insert into ARdM02011(com_id, finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum)
       values (@com_id,@finacial_y,@finacial_m,@customer_id,0,@sum_si,0,0,@sum_si) 
     end else 
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)+@sum_si,
       acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)+@sum_si-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)  
       from ARdM02011 a where --a.finacial_y = @finacial_y and 
          a.com_id = @com_id 
          --and a.finacial_m = @finacial_m  
          and a.customer_id=@customer_id
     end    
  end
  if rtrim(ltrim(@sd_order_direct))='现款'
  begin   
    select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and 
     c.com_id = @com_id 
     --and c.finacial_m = @finacial_m  
     and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
     if @@rowcount= 0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,-@sd_oq,0,@tax_sum_si) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-@sd_oq
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
     select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and 
       a.com_id = @com_id 
       --and a.finacial_m = @finacial_m  
       and a.customer_id=@customer_id 
     if @@rowcount=0 
     begin
       insert into ARdM02011(com_id, finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum)
       values (@com_id,@finacial_y,@finacial_m,@customer_id,0,@sum_si,@sum_si,0,0) 
     end else 
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)+@sum_si,rev_sum=isnull(rev_sum,0)+@sum_si  from ARdM02011 
       a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id
     end
   end
   update SDd02011 set send_qty=isnull(send_qty,0)-@sd_oq,send_sum=isnull(send_sum,0)+@sd_oq from SDd02011 a where a.com_id=@com_id /*明细中未发*/
   and a.ivt_oper_listing=@ivt_oper_bill  and  a.item_id=@item_id and a.seeds_id=@sid
   update SDd02010 set alr_oq=isnull(alr_oq,0)+@sd_oq  from SDd02010 a where a.com_id=@com_id and a.ivt_oper_listing=@ivt_oper_bill /*主表中已发  */ 
   update Ctl03001 set bar_gb12904_91=convert(varchar(10),@so_consign_date,10)  from  Ctl03001 c  where c.com_id=@com_id and c.item_id=@item_id
   
   update SDd02021 set tax_sum_si=(select isnull(i_price,0)  from ivtd01302  where com_id=sdd02021.com_id  
   and store_struct_id=sdd02021.store_struct_id  and item_id=@item_id) from SDd02021  where com_id=@com_id /*审核时更改成本*/
   and ivt_oper_listing=@ivt_oper_listing  and  item_id=@item_id and seeds_id=@seeds_id  and store_struct_id= @store_struct_id  

 end else begin/*弃审*/
   if @rev_days=1 /*借货管理*/
   begin   
     delete from  STDM03001 where com_id=@com_id and  adress_id=@ivt_oper_listing
     delete from  STD03001  where com_id=@com_id and  st_auto_no=@ivt_oper_listing
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  and 
       c.com_id = @com_id 
       and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id   
     if @@rowcount<> 0/*减少库存数量*/
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @sd_oq,
       i_price=(case   when (@accn_ivt-@sd_oq)=0 then @i_price else 
       ((@i_price*@accn_ivt-@tax_sum_si*@sd_oq)/(@accn_ivt-@sd_oq))  end )
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id 
     end   
     select vendor_id from stdM0201 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
     a.com_id = @com_id 
     and a.vendor_id=@vendor_id 
     if @@rowcount<>0 
     begin
       update stdM0201 set increase=isnull(increase,0)-@tax_sum_si*@sd_oq,
       end_sum=isnull(beg_sum,0)+isnull(increase,0)-@tax_sum_si*@sd_oq-isnull(decrease,0) from stdM0201 
       a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
         a.com_id = @com_id 
         and a.vendor_id=@vendor_id
     end
   end
   if rtrim(ltrim(@sd_order_direct))='发货'
   begin 
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  and 
        c.com_id = @com_id 
        and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
     if @@rowcount<> 0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+@sd_oq
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
     select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id 
     if @@rowcount<>0 
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)-@sum_si,
       acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-@sum_si-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)  
       from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
         a.com_id = @com_id 
         and a.customer_id=@customer_id
     end
   end
   if rtrim(ltrim(@sd_order_direct))='现款'
   begin   
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where --c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  and 
        c.com_id = @com_id 
        and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id   
     if @@rowcount<> 0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+@sd_oq
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'') = @store_struct_id 
     end
     select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m   and 
        a.com_id = @com_id 
        and a.customer_id=@customer_id 
     if @@rowcount<>0 
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)-@sum_si,rev_sum=isnull(rev_sum,0)-@sum_si  from ARdM02011 
       a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id
     end
   end
   update SDd02011 set send_qty=isnull(send_qty,0)+@sd_oq,send_sum=isnull(send_sum,0)-@sd_oq  from SDd02011 a where a.com_id=@com_id 
   and a.ivt_oper_listing=@ivt_oper_bill  and  a.item_id=@item_id and a.seeds_id=@sid
   update SDd02010 set alr_oq=isnull(alr_oq,0)-@sd_oq  from SDd02010 a where a.com_id=@com_id and a.ivt_oper_listing=@ivt_oper_bill 
 end
   FETCH NEXT FROM mycur 
	INTO @item_id,@lot_number,@sd_oq,@sum_si,@tax_sum_si,@store_struct_id,@vendor_id,@rev_days,@unit_id,@type_id,@peijian_id,@ivt_oper_bill,@sid,@seeds_id
end
CLOSE mycur
DEALLOCATE mycur

   if ltrim(rtrim(@comfirm_flag))='Y'
   begin
     if (@i_agiosum<>0) and (rtrim(ltrim(@sd_order_direct))='发货')  
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)-@i_agiosum,
       acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-@i_agiosum-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)  
       from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
         a.com_id = @com_id 
         and a.customer_id=@customer_id
     end
     if (@i_agiosum<>0) and (rtrim(ltrim(@sd_order_direct))='现款')  
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)-@i_agiosum,
       rev_sum=isnull(rev_sum,0)-@i_agiosum
       from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id
     end/*现款或发货中优惠的金额*/
        
     if (rtrim(ltrim(@sd_order_direct))='发货') and  (@youhui_sum<>0)
     begin/*已经收了一部分款*/
       select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id 
       if @@rowcount<>0 
       begin
         update ARdM02011 set rev_sum=isnull(rev_sum,0)+@youhui_sum,
         acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-isnull(rev_sum,0)-@youhui_sum-isnull(tax_invoice_sum,0)  from ARdM02011 
         a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
          a.com_id = @com_id 
          and a.customer_id=@customer_id
       end
     end
     if (rtrim(ltrim(@sd_order_direct))='现款') or (@youhui_sum<>0)
     begin
       select @i_currentValue=a.i_currentValue,@d_currentDate=a.d_currentDate from Ctl00190 a 
       where a.com_id=@com_id and a.ruleapply_occasion='销售收款'
       if @@rowcount=0 
       begin
         set @scurDate=(select  convert(varchar(10),getdate(),21))
         insert into ctl00190(com_id,ruleapply_occasion,prefix,suffix,d_currentDate,i_currentValue)
         values (@com_id,'销售收款','NO.','XSSK',@scurDate,1)
       end
       select @i_currentValue=a.i_currentValue,@d_currentDate=a.d_currentDate from Ctl00190 a 
       where a.com_id=@com_id and a.ruleapply_occasion='销售收款'
       if ltrim(rtrim(@d_currentDate))=''
       begin
        update Ctl00190 set d_currentDate=(select  convert(varchar(10),getdate(),21)),i_currentValue=1 from Ctl00190 a where a.com_id=@com_id and a.ruleapply_occasion='销售收款'   
       end else begin
         if (select  convert(varchar(10),getdate(),21))>@d_currentDate 
         update Ctl00190 set d_currentDate=(select  convert(varchar(10),getdate(),21)),i_currentValue=1 from Ctl00190 where com_id=@com_id and ruleapply_occasion='销售收款'   
         else  update Ctl00190 set i_currentValue=i_currentValue+1 from Ctl00190 where com_id=@com_id and ruleapply_occasion='销售收款'   
       end 
       select @i_currentValue=isnull(a.i_currentValue,1),@d_currentDate=a.d_currentDate,@prefix=a.prefix,@suffix=a.suffix 
        from Ctl00190 a where a.com_id=@com_id and a.ruleapply_occasion='销售收款'
       select @numb=cast(@i_currentValue as varchar(10))    
       select @recieved_auto_id=ltrim(rtrim(@prefix))+ltrim(rtrim(@d_currentDate))+ltrim(rtrim(@numb))+ltrim(rtrim(@suffix))
       if (rtrim(ltrim(@sd_order_direct))='发货') and  (@youhui_sum<>0) 
       begin 
         insert into ARd02051 (com_id,finacial_y,finacial_m,recieve_type,recieved_auto_id,recieved_id,finacial_d,customer_id,dept_id,
         clerk_id,recieved_direct,sum_si,comfirm_flag,ivt_oper_cfm,ivt_oper_cfm_time,mainten_clerk_id,mainten_datetime,rcv_hw_no,
         rejg_hw_no,type_sum,if_send) values /*销售单号*/
         (@com_id,@finacial_y,@finacial_m,'应收款',@recieved_auto_id,@recieved_auto_id,@so_consign_date,@customer_id,@dept_id,@clerk_id,
         '收款',@youhui_sum,'Y',@ivt_oper_cfm,getdate(),@ivt_oper_cfm,getdate(),@settlement_type_id ,@ivt_oper_listing,@youhui_sum,'1')  
       end
       if (rtrim(ltrim(@sd_order_direct))='现款')
       begin
         insert into ARd02051 (com_id,finacial_y,finacial_m,recieve_type,recieved_auto_id,recieved_id,finacial_d,customer_id,dept_id,
         clerk_id,recieved_direct,sum_si,comfirm_flag,ivt_oper_cfm,ivt_oper_cfm_time,mainten_clerk_id,mainten_datetime,rcv_hw_no,
         rejg_hw_no,type_sum,if_send) values /*销售单号*/
         (@com_id,@finacial_y,@finacial_m,'应收款',@recieved_auto_id,@recieved_auto_id,@so_consign_date,@customer_id,@dept_id,@clerk_id,
         '收款',@allsum_si,'Y',@ivt_oper_cfm,getdate(),@ivt_oper_cfm,getdate(),@settlement_type_id ,@ivt_oper_listing,@allsum_si,'1')  
       end 
     end
   end else begin/*弃审*/
     delete from  ARd02051 where com_id=@com_id and rejg_hw_no=@ivt_oper_listing/*弃审时删除生成的收款单*/
     if (rtrim(ltrim(@sd_order_direct))='发货') and  (@youhui_sum<>0)
     begin/*已经收了一部分款*/
       select customer_id from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
       a.com_id = @com_id 
       and a.customer_id=@customer_id 
       if @@rowcount<>0 
       begin
         update ARdM02011 set rev_sum=isnull(rev_sum,0)-@youhui_sum,
         acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-isnull(rev_sum,0)+@youhui_sum-isnull(tax_invoice_sum,0)  from ARdM02011 
         a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
         a.com_id = @com_id 
         and a.customer_id=@customer_id
       end
     end

     if (@i_agiosum<>0) and (rtrim(ltrim(@sd_order_direct))='发货')  
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)+@i_agiosum,
       acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)+@i_agiosum-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)  
       from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
        a.com_id = @com_id 
        and a.customer_id=@customer_id
     end
     if (@i_agiosum<>0) and (rtrim(ltrim(@sd_order_direct))='现款')  
     begin
       update ARdM02011 set addi_sum=isnull(addi_sum,0)+@i_agiosum,
       rev_sum=isnull(rev_sum,0)+@i_agiosum
       from ARdM02011 a where --a.finacial_y = @finacial_y and a.finacial_m = @finacial_m  and 
         a.com_id = @com_id 
         and a.customer_id=@customer_id
     end/*现款或发货中优惠的金额*/
   end


IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranSp_SellConsignment
return 0
end else
begin
COMMIT TRANSACTION MyTranSp_SellConsignment
return 1
end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

