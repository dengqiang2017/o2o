if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_lookCheckObjectinit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lookCheckObjectinit]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE sp_lookCheckObjectinit
          @com_id char(10),
          @CGGoods_id varchar(30),/*科目*/
          @sort_id varchar(30),/*核算项目*/
          @CheckType_id varchar(30),
          @finacial_y int,
          @finacial_m tinyint,
          @comfirm_flag char(1)
AS 
BEGIN TRANSACTION mytransp_lookCheckObjectinit
     declare @init_sum decimal(15,6),@debitandcredit_type char(1),@sort_id1 varchar(30)

    select @init_sum=b.init_sum  from ctl03201 b where  b.com_id = @com_id and b.CGGoods_id=@CGGoods_id 
    and b.sort_id = @sort_id and b.CheckType_id=@CheckType_id

    select @debitandcredit_type=b.debitandcredit_type  from ctl04100 b where  b.com_id = @com_id and b.sort_id=@CGGoods_id
        
    if rtrim(ltrim(@comfirm_flag))<>'Y'
    begin
      update ctl04100 set expenses_unitprice=isnull(expenses_unitprice,0)+@init_sum 
      from ctl04100 where expenses_id=@CGGoods_id and com_id=@com_id

      select @sort_id1=sort_id  from account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
      a.finacial_m=@finacial_m and a.expenses_id=@CGGoods_id and operation_type='核算项目' and self_id=@sort_id
      if @@rowcount=0 
      begin
        if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
        begin
          insert into account_turn(com_id,finacial_y,finacial_m,sort_id,expenses_id,self_id,start_borrow_sum,end_borrow_sum,operation_type) values 
          (@com_id,@finacial_y,@finacial_m,@CGGoods_id,@CGGoods_id,@sort_id,@init_sum,@init_sum,'核算项目')
        end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
        begin
          insert into account_turn(com_id,finacial_y,finacial_m,sort_id,expenses_id,self_id,start_lend_sum,end_lend_sum,operation_type) values 
          (@com_id,@finacial_y,@finacial_m,@CGGoods_id,@CGGoods_id,@sort_id,@init_sum,@init_sum,'核算项目')
        end
      end else  begin
       if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
       begin
         update account_turn set start_borrow_sum=isnull(start_borrow_sum,0)+@init_sum,
         end_borrow_sum=isnull(start_borrow_sum,0)+@init_sum+isnull(this_borrow_sum,0)-isnull(this_lend_sum,0)
         from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
         a.finacial_m=@finacial_m and a.expenses_id=@CGGoods_id and operation_type='核算项目'  and self_id=@sort_id
       end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
       begin
         update account_turn set start_lend_sum=isnull(start_lend_sum,0)+@init_sum,
         end_borrow_sum=isnull(start_lend_sum,0)+@init_sum+isnull(this_lend_sum,0)-isnull(this_borrow_sum,0)
         from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
         a.finacial_m=@finacial_m and a.expenses_id=@CGGoods_id and operation_type='核算项目'  and self_id=@sort_id
      end
    end
   end else begin
     update ctl04100 set expenses_unitprice=isnull(expenses_unitprice,0)-@init_sum 
     from ctl04100 where expenses_id=@CGGoods_id and com_id=@com_id

     select  @sort_id1=sort_id  from account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
     a.finacial_m=@finacial_m and a.expenses_id=@CGGoods_id and operation_type='核算项目' and self_id=@sort_id
     if @@rowcount<>0 
     begin
       if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
       begin
         update account_turn set start_borrow_sum=isnull(start_borrow_sum,0)-@init_sum,
         end_borrow_sum=isnull(start_borrow_sum,0)-@init_sum+isnull(this_borrow_sum,0)-isnull(this_lend_sum,0)
         from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
         a.finacial_m=@finacial_m and a.expenses_id=@CGGoods_id  and operation_type='核算项目'  and self_id=@sort_id
       end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
       begin
         update account_turn set start_lend_sum=isnull(start_lend_sum,0)-@init_sum,
         end_borrow_sum=isnull(start_lend_sum,0)-@init_sum+isnull(this_lend_sum,0)-isnull(this_borrow_sum,0)
         from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
         a.finacial_m=@finacial_m and a.expenses_id=@CGGoods_id  and operation_type='核算项目'  and self_id=@sort_id
      end
    end
  end
                           
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTransp_lookCheckObjectinit
end else
begin
COMMIT TRANSACTION MyTransp_lookCheckObjectinit
end




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

