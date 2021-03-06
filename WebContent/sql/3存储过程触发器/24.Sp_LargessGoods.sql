if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_LargessGoods]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_LargessGoods]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--赠送货品
CREATE PROCEDURE Sp_LargessGoods 
	@com_id  char(10),
        @auto_tax_invoice_id  varchar(30),
        @comfirm_flag varchar(1)
AS
BEGIN TRANSACTION mytranSp_LargessGoods

        declare @tax_invoice_date datetime,@tax_invoice_direct varchar(6),@dept_id varchar(30),@clerk_id varchar(35),
        @item_id char(40),@sd_oq decimal(17,6),@sd_unit_price decimal(17,6),@vendor_id varchar(30),@customer_id varchar(30),
        @settlement_type_id varchar(30),@gongyingshang_id varchar(30),@ivt_oper_cfm varchar(35),@mainten_clerk_id varchar(35),
        @i_currentValue int,@d_currentDate varchar(30),@prefix varchar(20),@suffix varchar(20),@numb varchar(10),
        @finacial_y int,@finacial_m int,@scurDate varchar(30),@S_RKDH varchar(30),@sd_order_id varchar(30),
        @i_price decimal(17,6),@accn_ivt decimal(17,6),@sum_ti decimal(17,6),@feiyong_id varchar(30)


	SELECT  @tax_invoice_date=b.tax_invoice_date,@tax_invoice_direct=b.tax_invoice_direct,@FINACIAL_Y= B.FINACIAL_Y,
        @FINACIAL_M=B.FINACIAL_M,@ivt_oper_cfm=b.ivt_oper_cfm,@dept_id=b.dept_id,@clerk_id=b.clerk_id,
        @mainten_clerk_id=b.mainten_clerk_id  FROM ARd02040 B
	WHERE  b.auto_tax_invoice_id = @auto_tax_invoice_id  AND b.com_id = @com_id

        declare mycur  CURSOR FOR 
		select a.item_id,a.sd_oq,a.sd_unit_price,a.vendor_id,a.customer_id,a.settlement_type_id,
                a.sd_order_id,a.sum_ti,a.dept_id   from ARd02041 a
		where  a.auto_tax_invoice_id=@auto_tax_invoice_id and a.com_id=@com_id
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@sd_oq,@sd_unit_price,@vendor_id,@customer_id,@settlement_type_id,@sd_order_id,@sum_ti,@feiyong_id
WHILE @@FETCH_STATUS = 0
begin
  if ltrim(rtrim(@comfirm_flag))='Y'
  begin
    if ltrim(rtrim(@tax_invoice_direct))='客户' 
    begin
      select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
      where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
      and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房 
      if @@rowcount <> 0
      begin
        update ivtd01302 set accn_ivt=isnull(accn_ivt,0)- @sd_oq
        from ivtd01302 c where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
      and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房
      end
  
      set @gongyingshang_id='让利给客户-赠送货品'

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
 
      if @scurDate>@d_currentDate  /*如果当前日期大于实际日期*/
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
      sum_si,bill_source,billNO,charg_no,waigou_ivt_oper,mainten_clerk_id,mainten_datetime) values 
      (@com_id,@finacial_y,@finacial_m,@S_RKDH,@S_RKDH,@tax_invoice_date,@dept_id,@clerk_id,@sum_ti,@gongyingshang_id,
      @settlement_type_id,'',@auto_tax_invoice_id,@mainten_clerk_id,getdate())

      insert into SDD03001(com_id,ivt_oper_listing,expenses_id,sum_si,vendor_id,customer_id,reason,sd_order_id)
      values (@com_id,@S_RKDH,@feiyong_id,@sum_ti,@vendor_id,@customer_id,'',@auto_tax_invoice_id) 
    end
 
    if ltrim(rtrim(@tax_invoice_direct))='供货' 
    begin 
      select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
      where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
      and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房  
      if @@rowcount =  0/*增加库存数量*/
      begin
        insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
        values(@com_id,@finacial_y,@finacial_m ,@sd_order_id,@item_id,@sd_oq,0,@sd_unit_price) 
      end else begin
        update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @sd_oq,
        i_price=(case   when ((@accn_ivt)+(@sd_oq))=0 then @i_price  else 
        (((@i_price*@accn_ivt)+(@sum_ti))/((@accn_ivt)+(@sd_oq)))  end )
        from ivtd01302 c 
        where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
        and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房
        end
    end
       
  end else begin/*弃审*/
 
    if ltrim(rtrim(@tax_invoice_direct))='客户' 
    begin
      select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
      where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
      and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房
      if @@rowcount <> 0/*增加库存数量*/
      begin
        update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+ @sd_oq
        from ivtd01302 c 
      where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
      and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房
      end

      delete from  SDDM03001 where com_id=@com_id and  waigou_ivt_oper=@auto_tax_invoice_id
      delete from  SDD03001  where com_id=@com_id and  sd_order_id=@auto_tax_invoice_id
    end

    if ltrim(rtrim(@tax_invoice_direct))='供货' 
    begin 
      select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c 
      where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
      and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房   
      if @@rowcount =  0/*减少库存数量*/
      begin
        insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
        values(@com_id,@finacial_y,@finacial_m ,@sd_order_id,@item_id,-@sd_oq,0,@sd_unit_price) 
      end else begin
        update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @sd_oq,
        i_price=(case   when (@accn_ivt-@sd_oq)=0 then @i_price  else 
        ((@i_price*@accn_ivt-@sum_ti)/(@accn_ivt-@sd_oq))  end )
        from ivtd01302 c 
        where c.com_id = @com_id  and c.item_id = @item_id and isnull(c.store_struct_id,'')= @sd_order_id 
        and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  --@sd_order_id库房
      end
    end

  end

   FETCH NEXT FROM mycur 
	INTO @item_id,@sd_oq,@sd_unit_price,@vendor_id,@customer_id,@settlement_type_id,@sd_order_id,@sum_ti,@feiyong_id
end
CLOSE mycur
DEALLOCATE mycur

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranSp_LargessGoods
end else
begin
COMMIT TRANSACTION MyTranSp_LargessGoods
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

