if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_stockAndSale_pay]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_stockAndSale_pay]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE SP_stockAndSale_pay 
	@com_ID char(10),
        @recieved_auto_id varchar(30),
        @recieved_direct char(4),/*收款或付款*/
        @comfirm_flag char(1)
 
AS
BEGIN TRANSACTION mytranSP_stockAndSale_pay
        declare @customer_id varchar(30),@sum_si decimal(15,6),@finacial_y int, @finacial_m tinyint,@recieve_type varchar(20)
     
     if ltrim(rtrim(@comfirm_flag))='Y'
     begin
        select @customer_id=b.customer_id,@sum_si=b.sum_si,@finacial_y=b.finacial_y,@finacial_m=b.finacial_m,@recieve_type=b.recieve_type
        from ARd02051 b where  b.recieved_auto_id =@recieved_auto_id and b.com_id = @com_id and b.recieved_direct=@recieved_direct             
        if rtrim(ltrim(@recieved_direct))='付款'
        begin
          if rtrim(ltrim(@recieve_type))='应付款'
          begin
            select vendor_id from stdM0201 where com_id=@com_id and vendor_id=@customer_id  and 
            finacial_y=@finacial_y and finacial_m=@finacial_m
            if @@rowcount=0 
            begin
              insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,balance_sum,end_sum )
              values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,@sum_si,0,-@sum_si )
            end else begin
              update stdM0201 set decrease=isnull(decrease,0)+@sum_si,
              end_sum=isnull(beg_sum,0)+isnull(increase,0)-(isnull(decrease,0)+@sum_si)-isnull(balance_sum,0) from stdM0201 
              a where a.finacial_y = @finacial_y and a.com_id = @com_id 
              and a.finacial_m = @finacial_m  and a.vendor_id=@customer_id 
            end
          end

          if rtrim(ltrim(@recieve_type))='预付款'
          begin
            select vendor_id from stdM0201 where com_id=@com_id and vendor_id=@customer_id  and 
            finacial_y=@finacial_y and finacial_m=@finacial_m
            if @@rowcount=0 
            begin
              insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,balance_sum,end_sum )
              values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,@sum_si,0,-@sum_si )
            end else begin
              update stdM0201 set decrease=isnull(decrease,0)+@sum_si,
              end_sum=isnull(beg_sum,0)+isnull(increase,0)-(isnull(decrease,0)+@sum_si)-isnull(balance_sum,0) from stdM0201 
              a where a.finacial_y = @finacial_y and a.com_id = @com_id 
              and a.finacial_m = @finacial_m  and a.vendor_id=@customer_id 
            end
          end

          if rtrim(ltrim(@recieve_type))='退货收款'
          begin
            select vendor_id from stdM0201 where com_id=@com_id and vendor_id=@customer_id  and 
            finacial_y=@finacial_y and finacial_m=@finacial_m
            if @@rowcount=0 
            begin
              insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,balance_sum,end_sum )
              values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,-@sum_si,0,@sum_si )
            end else begin
              update stdM0201 set decrease=isnull(decrease,0)-@sum_si,
              end_sum=isnull(beg_sum,0)+isnull(increase,0)-(isnull(decrease,0)-@sum_si)-isnull(balance_sum,0) from stdM0201 
              a where a.finacial_y = @finacial_y and a.com_id = @com_id 
              and a.finacial_m=@finacial_m  and a.vendor_id=@customer_id 
            end
          end

        end
     
        if rtrim(ltrim(@recieved_direct))='收款'
        begin
          if rtrim(ltrim(@recieve_type))='应收款'
          begin
            select customer_id from ARdM02011 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
            and a.finacial_m = @finacial_m  and a.customer_id=@customer_id 
            and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m
            if @@rowcount=0 
            begin
              insert into ARdM02011(com_id,finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum )
              values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,@sum_si,0,-@sum_si )
            end else begin
              update ARdM02011 set rev_sum=isnull(rev_sum,0)+@sum_si,
              acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-(isnull(rev_sum,0)+@sum_si)-isnull(tax_invoice_sum,0)  from ARdM02011 
              a where a.finacial_y = @finacial_y and a.com_id = @com_id 
              and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
            end
          end
          if rtrim(ltrim(@recieve_type))='预收款'
          begin
            select customer_id from ARdM02011 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
            and a.finacial_m = @finacial_m  and a.customer_id=@customer_id 
            and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m
            if @@rowcount=0 
            begin
              insert into ARdM02011(com_id,finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum )
              values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,@sum_si,0,-@sum_si )
            end else begin
              update ARdM02011 set rev_sum=isnull(rev_sum,0)+@sum_si,
              acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-(isnull(rev_sum,0)+@sum_si)-isnull(tax_invoice_sum,0)  from ARdM02011 
              a where a.finacial_y = @finacial_y and a.com_id = @com_id 
              and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
            end
          end
          if rtrim(ltrim(@recieve_type))='退货付款'
          begin
            select customer_id from ARdM02011 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
            and a.finacial_m = @finacial_m  and a.customer_id=@customer_id 
            and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m
            if @@rowcount=0 
            begin
              insert into ARdM02011(com_id,finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum )
              values (@com_id,@finacial_y,@finacial_m,@customer_id,0,0,-@sum_si,0,@sum_si )
            end else begin
              update ARdM02011 set rev_sum=isnull(rev_sum,0)-@sum_si,
              acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-(isnull(rev_sum,0)-@sum_si)-isnull(tax_invoice_sum,0)  from ARdM02011 
              a where a.finacial_y = @finacial_y and a.com_id = @com_id 
              and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
            end
          end


        end

     end else begin  /*---------------------------------------弃审----------------------------------------------------*/
       select @customer_id=b.customer_id,@sum_si=b.sum_si,@finacial_y=b.finacial_y,@finacial_m=b.finacial_m,@recieve_type=b.recieve_type 
       from ARd02051 b where  b.recieved_auto_id =@recieved_auto_id and b.com_id = @com_id and b.recieved_direct=@recieved_direct             
       if rtrim(ltrim(@recieved_direct))='付款'
       begin
         if rtrim(ltrim(@recieve_type))='应付款'
         begin
           select vendor_id from stdM0201 where com_id=@com_id and vendor_id=@customer_id  and 
           finacial_y=@finacial_y and finacial_m=@finacial_m
           if @@rowcount<>0 
           begin
             update stdM0201 set decrease=isnull(decrease,0)-@sum_si,
             end_sum=isnull(beg_sum,0)+isnull(increase,0)-(isnull(decrease,0)-@sum_si)-isnull(balance_sum,0) from stdM0201 
             a where a.finacial_y = @finacial_y and a.com_id = @com_id 
             and a.finacial_m = @finacial_m  and a.vendor_id=@customer_id 
           end
         end
         if rtrim(ltrim(@recieve_type))='预付款'
         begin
           select vendor_id from stdM0201 where com_id=@com_id and vendor_id=@customer_id  and 
           finacial_y=@finacial_y and finacial_m=@finacial_m
           if @@rowcount<>0 
           begin
             update stdM0201 set decrease=isnull(decrease,0)-@sum_si,
             end_sum=isnull(beg_sum,0)+isnull(increase,0)-(isnull(decrease,0)-@sum_si)-isnull(balance_sum,0) from stdM0201 
             a where a.finacial_y = @finacial_y and a.com_id = @com_id 
             and a.finacial_m = @finacial_m  and a.vendor_id=@customer_id 
           end
         end

         if rtrim(ltrim(@recieve_type))='退货收款'
         begin
           select vendor_id from stdM0201 where com_id=@com_id and vendor_id=@customer_id  and 
           finacial_y=@finacial_y and finacial_m=@finacial_m
           if @@rowcount<>0 
           begin
             update stdM0201 set decrease=isnull(decrease,0)+@sum_si,
             end_sum=isnull(beg_sum,0)+isnull(increase,0)-(isnull(decrease,0)+@sum_si)-isnull(balance_sum,0) from stdM0201 
             a where a.finacial_y = @finacial_y and a.com_id = @com_id 
             and a.finacial_m = @finacial_m  and a.vendor_id=@customer_id 
           end
         end
       end
     
       if rtrim(ltrim(@recieved_direct))='收款'
       begin
         if ltrim(rtrim(@recieve_type))='应收款'
         begin
           select customer_id from ARdM02011 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
           and a.finacial_m = @finacial_m  and a.customer_id=@customer_id 
           and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m
           if @@rowcount<>0 
           begin
             update ARdM02011 set rev_sum=isnull(rev_sum,0)-@sum_si,
             acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-(isnull(rev_sum,0)-@sum_si)-isnull(tax_invoice_sum,0)  from ARdM02011 
             a where a.finacial_y = @finacial_y and a.com_id = @com_id 
             and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
           end
         end

         if rtrim(ltrim(@recieve_type))='预收款'
         begin
           select customer_id from ARdM02011 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
           and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
           and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m
           if @@rowcount<>0 
           begin
             update ARdM02011 set rev_sum=isnull(rev_sum,0)-@sum_si,
             acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-(isnull(rev_sum,0)-@sum_si)-isnull(tax_invoice_sum,0)  from ARdM02011 
             a where a.finacial_y = @finacial_y and a.com_id = @com_id 
             and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
           end
         end
         if rtrim(ltrim(@recieve_type))='退货付款'
         begin
           select customer_id from ARdM02011 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
           and a.finacial_m = @finacial_m  and a.customer_id=@customer_id 
           and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m
           if @@rowcount<>0 
           begin
             update ARdM02011 set rev_sum=isnull(rev_sum,0)+@sum_si,
             acct_recieve_sum=isnull(oh_sum,0)+isnull(addi_sum,0)-(isnull(rev_sum,0)+@sum_si)-isnull(tax_invoice_sum,0)  from ARdM02011 
             a where a.finacial_y = @finacial_y and a.com_id = @com_id 
             and a.finacial_m = @finacial_m  and a.customer_id=@customer_id
           end
         end
 
       end

     end 

IF @@ERROR<>0 
begin
ROLLBACK TRANSACTION MyTranSP_stockAndSale_pay
end else
begin
COMMIT TRANSACTION MyTranSP_stockAndSale_pay
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

