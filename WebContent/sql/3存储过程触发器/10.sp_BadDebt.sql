if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_BadDebt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_BadDebt]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--应收呆坏帐调整
CREATE  PROCEDURE sp_BadDebt
          @com_id char(10),
          @Debt_auto_no varchar(30),
          @initial_flag char(1)
AS 
BEGIN TRANSACTION mytransp_BadDebt
     declare @finacial_y int,@finacial_m tinyint,@customer_id varchar(30),@oh_sum decimal(15,6),@tax_invoice_sum decimal(17,6),--呆坏金额
     @acct_recieve_sum decimal(17,6),  --剩余金额
     @i_currentValue int,@d_currentDate varchar(30),@prefix varchar(20),@suffix varchar(20),@numb varchar(10),@scurDate varchar(30),
     @S_RKDH varchar(30),@finacial_d datetime,@dept_id varchar(30),@clerk_id varchar(35),@settlement_type_id varchar(30),
     @mainten_clerk_id varchar(35),@expenses_id varchar(30),@c_type varchar(4)

    select @finacial_y=b.finacial_y,@finacial_m=b.finacial_m,@customer_id=b.customer_id,@finacial_d=b.finacial_d,
    @dept_id=b.dept_id,@clerk_id=b.clerk_id,@oh_sum=b.oh_sum,@tax_invoice_sum=b.tax_invoice_sum,@expenses_id=b.expenses_id,
    @settlement_type_id=b.settlement_type_id,@acct_recieve_sum=b.acct_recieve_sum,@mainten_clerk_id=b.mainten_clerk_id,
    @c_type=b.c_type  from ARfM02010  b   where  b.com_id = @com_id and b.Debt_auto_no=@Debt_auto_no
        
  if ltrim(rtrim(@c_type))='应收'
  begin
   if ltrim(rtrim(@initial_flag))='Y'
   begin
    select  customer_id  from ARdM02011 a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
    a.finacial_m=@finacial_m and a.customer_id=@customer_id 
    if @@rowcount=0 
    begin
      insert into ARdM02011(com_id,finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,
      acct_recieve_sum) values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,0,@tax_invoice_sum,-@tax_invoice_sum)
    end else begin
      update ARdM02011 set tax_invoice_sum=isnull(tax_invoice_sum,0)+@tax_invoice_sum,
      acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)-@tax_invoice_sum  from ARdM02011 a  
      where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m and a.customer_id=@customer_id   
    end

    set @scurDate=(select  convert(varchar(10),getdate(),21))   --当前日期

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
 
      if @scurDate>@d_currentDate  --如果当前日期大于实际日期
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
      (@com_id,@finacial_y,@finacial_m,@S_RKDH,@S_RKDH,@finacial_d,@dept_id,@clerk_id,@tax_invoice_sum,'应收呆坏帐',
      @settlement_type_id,'',@Debt_auto_no,@mainten_clerk_id,getdate())

      insert into SDD03001(com_id,ivt_oper_listing,expenses_id,sum_si,vendor_id,customer_id,reason,sd_order_id)
      values (@com_id,@S_RKDH,@expenses_id,@tax_invoice_sum,'',@customer_id,'',@Debt_auto_no) 
   end else begin  -------------------------------------弃审------------------------------------------------------
    select  customer_id  from ARdM02011 a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
    a.finacial_m=@finacial_m and a.customer_id=@customer_id 
    if @@rowcount<>0 
    begin
      update ARdM02011 set tax_invoice_sum=isnull(tax_invoice_sum,0)-@tax_invoice_sum,
      acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-isnull(rev_sum,0)-isnull(tax_invoice_sum,0)+@tax_invoice_sum  from ARdM02011 a  
      where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m and a.customer_id=@customer_id   
    end

    delete from  SDDM03001 where com_id=@com_id and  waigou_ivt_oper=@Debt_auto_no
    delete from  SDD03001  where com_id=@com_id and  sd_order_id=@Debt_auto_no
   end
  end
                           
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTransp_BadDebt
return 0
end else
begin
COMMIT TRANSACTION MyTransp_BadDebt
return 1
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

