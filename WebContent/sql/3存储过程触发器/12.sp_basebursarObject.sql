if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_basebursarObject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_basebursarObject]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



--会计科目初始化审核与弃审
CREATE PROCEDURE sp_basebursarObject
          @com_id char(10),
          @sort_id varchar(30),
          @finacial_y int,
          @finacial_m tinyint,
          @comfirm_flag char(1)
AS 
BEGIN TRANSACTION mytransp_basebursarObject
     declare @expenses_id  varchar(40),@expenses_unitprice decimal(15,6),@sort_id1 varchar(40),@hesuan_id varchar(30),
             @debitandcredit_type char(1),@CheckType_id varchar(30),@seeds_id int,@init_sum decimal(17,6),@adas varchar(30),
             @cash_subject char(1),@icount int,@item_style varchar(40),@sd_oq decimal(17,6),@sd_price decimal(17,6)

   select @expenses_id=b.expenses_id,@debitandcredit_type=b.debitandcredit_type,@CheckType_id=isnull(b.CheckType_id,''),
   @cash_subject=isnull(b.cash_subject,'0')   from ctl04100 b  where  b.com_id = @com_id and b.sort_id=@sort_id

   set @CheckType_id=ltrim(rtrim(@CheckType_id))
 
   if rtrim(ltrim(@comfirm_flag))='Y'
   begin
     delete from account_turn where com_id=@com_id and finacial_y=@finacial_y and 
      finacial_m=@finacial_m and sort_id=@sort_id 

     select @adas=sort_id from ctl03201  where com_id=@com_id and isnull(CheckType_id,'')=@CheckType_id 
     and CGGoods_id=@sort_id  and isnull(init_flag,'N')='Y'   
     if @@rowcount<>0 
     begin
       select @init_sum=sum(init_sum) from ctl03201  where com_id=@com_id and CGGoods_id=@sort_id  
       and isnull(init_flag,'N')='Y' group by CGGoods_id

       update ctl04100 set expenses_unitprice=@init_sum from ctl04100 where sort_id=@sort_id and com_id=@com_id  

       declare mycur  CURSOR FOR 
       select isnull(init_sum,0),seeds_id,sort_id,sd_oq,sd_price  from ctl03201  where com_id=@com_id 
       and isnull(CheckType_id,'')=@CheckType_id and CGGoods_id=@sort_id  and isnull(init_flag,'N')='Y'
       OPEN mycur
       FETCH NEXT FROM mycur 
         INTO @init_sum,@seeds_id,@hesuan_id,@sd_oq,@sd_price
       WHILE @@FETCH_STATUS=0
       begin

         select @sort_id1=sort_id  from account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
         a.finacial_m=@finacial_m and a.expenses_id=@expenses_id  and self_id=@hesuan_id 
         if @@rowcount=0 
         begin
           if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
           begin
             insert into account_turn(com_id,finacial_y,finacial_m,sort_id,expenses_id,self_id,start_borrow_oq,start_borrow_sum,
             year_borrow_sum,end_borrow_oq,end_borrow_sum,CheckType_id) values (@com_id,@finacial_y,@finacial_m,@sort_id,
             @expenses_id,@hesuan_id,@sd_oq,@init_sum,0,@sd_oq,@init_sum,@CheckType_id)
           end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
           begin
             insert into account_turn(com_id,finacial_y,finacial_m,sort_id,expenses_id,self_id,start_lend_oq,start_lend_sum,
             year_lend_sum,end_lend_oq,end_lend_sum,CheckType_id) values (@com_id,@finacial_y,@finacial_m,@sort_id,@expenses_id,
             @hesuan_id,@sd_oq,@init_sum,0,@sd_oq,@init_sum,@CheckType_id)
           end
         end else begin
           if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
           begin
             update account_turn set start_borrow_sum=isnull(start_borrow_sum,0)+@init_sum,
             end_borrow_sum=isnull(start_borrow_sum,0)+@init_sum+isnull(this_borrow_sum,0)-isnull(this_lend_sum,0),
             start_borrow_oq=isnull(start_borrow_oq,0)+@sd_oq,
             end_borrow_oq=isnull(start_borrow_oq,0)+@sd_oq+isnull(this_borrow_oq,0)-isnull(this_lend_oq,0)
             from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
             and a.expenses_id=@expenses_id and self_id=@hesuan_id 

           end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
           begin
             update account_turn set start_lend_sum=isnull(start_lend_sum,0)+@init_sum,
             end_lend_sum=isnull(start_lend_sum,0)+@init_sum+isnull(this_lend_sum,0)-isnull(this_borrow_sum,0),
             start_lend_oq=isnull(start_lend_oq,0)+@sd_oq,
             end_lend_oq=isnull(start_lend_oq,0)+@sd_oq+isnull(this_lend_oq,0)-isnull(this_borrow_oq,0)
             from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
             and a.expenses_id=@expenses_id and self_id=@hesuan_id 
           end
         end

         FETCH NEXT FROM mycur 
            INTO @init_sum,@seeds_id,@hesuan_id,@sd_oq,@sd_price
       end
       CLOSE mycur
       DEALLOCATE mycur

     end  else begin  /********************************科目的核算明晰中没有数据************************************/
       select @expenses_unitprice=b.expenses_unitprice  from ctl04100 b  where  b.com_id = @com_id and b.expenses_id=@expenses_id

       select @sort_id1=sort_id  from account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
       a.finacial_m=@finacial_m and a.expenses_id=@expenses_id 
       if @@rowcount=0 
       begin
         if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
         begin
           insert into account_turn(com_id,finacial_y,finacial_m,sort_id,expenses_id,start_borrow_sum,year_borrow_sum,
           end_borrow_sum,CheckType_id) values  (@com_id,@finacial_y,@finacial_m,@sort_id,@expenses_id,@expenses_unitprice,
           0,@expenses_unitprice,@CheckType_id)
         end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
         begin
           insert into account_turn(com_id,finacial_y,finacial_m,sort_id,expenses_id,start_lend_sum,year_lend_sum,end_lend_sum,
           CheckType_id) values (@com_id,@finacial_y,@finacial_m,@sort_id,@expenses_id,@expenses_unitprice,0,
           @expenses_unitprice,@CheckType_id)
         end
       end else  begin
         if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
         begin
           update account_turn set start_borrow_sum=isnull(start_borrow_sum,0)+@expenses_unitprice,
           end_borrow_sum=isnull(start_borrow_sum,0)+@expenses_unitprice+isnull(this_borrow_sum,0)-isnull(this_lend_sum,0)
           from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
           a.finacial_m=@finacial_m and a.expenses_id=@expenses_id 
         end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
         begin
           update account_turn set start_lend_sum=isnull(start_lend_sum,0)+@expenses_unitprice,
           end_lend_sum=isnull(start_lend_sum,0)+@expenses_unitprice+isnull(this_lend_sum,0)-isnull(this_borrow_sum,0)
           from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
           a.finacial_m=@finacial_m and a.expenses_id=@expenses_id 
         end
       end
     end  /********************************科目的核算明晰中没有数据************************************/

   end else begin/* 放弃审核*/
     select @adas=sort_id from ctl03201  where com_id=@com_id and isnull(CheckType_id,'')=@CheckType_id 
     and CGGoods_id=@sort_id  and isnull(init_flag,'N')='Y'   
     if @@rowcount<>0 
     begin
       declare mycur  CURSOR FOR 
       select isnull(init_sum,0),seeds_id,sort_id,sd_oq,sd_price  from ctl03201  where com_id=@com_id 
       and isnull(CheckType_id,'')=@CheckType_id and CGGoods_id=@sort_id and isnull(init_flag,'N')='Y'
       OPEN mycur
       FETCH NEXT FROM mycur 
         INTO @init_sum,@seeds_id,@hesuan_id,@sd_oq,@sd_price
       WHILE @@FETCH_STATUS=0
       begin
         /*update ctl04100 set expenses_unitprice=isnull(expenses_unitprice,0)-@init_sum 
         from ctl04100 where expenses_id=@expenses_id and com_id=@com_id*/

         select @sort_id1=sort_id  from account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
         a.finacial_m=@finacial_m and a.expenses_id=@expenses_id and self_id=@hesuan_id 
         if @@rowcount<>0 
         begin
           if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
           begin
             update account_turn set start_borrow_sum=isnull(start_borrow_sum,0)-@init_sum,
             end_borrow_sum=isnull(start_borrow_sum,0)-@init_sum+isnull(this_borrow_sum,0)-isnull(this_lend_sum,0),
             start_borrow_oq=isnull(start_borrow_oq,0)-@sd_oq,
             end_borrow_oq=isnull(start_borrow_oq,0)-@sd_oq+isnull(this_borrow_oq,0)-isnull(this_lend_oq,0)
             from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
             and a.expenses_id=@expenses_id and self_id=@hesuan_id 
           end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
           begin
             update account_turn set start_lend_sum=isnull(start_lend_sum,0)-@init_sum,
             end_lend_sum=isnull(start_lend_sum,0)-@init_sum+isnull(this_lend_sum,0)-isnull(this_borrow_sum,0),
             start_lend_oq=isnull(start_lend_oq,0)-@init_sum,
             end_lend_oq=isnull(start_lend_oq,0)-@init_sum+isnull(this_lend_oq,0)-isnull(this_borrow_oq,0)
             from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
             and a.expenses_id=@expenses_id and self_id=@hesuan_id 
           end
         end

         FETCH NEXT FROM mycur 
           INTO @init_sum,@seeds_id,@hesuan_id,@sd_oq,@sd_price
       end
       CLOSE mycur
       DEALLOCATE mycur

     end else begin /********************************科目的核算明晰中没有数据************************************/
       select  @sort_id1=sort_id  from account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
       a.finacial_m=@finacial_m and a.expenses_id=@expenses_id  
       if @@rowcount<>0 
       begin
         if ltrim(rtrim(@debitandcredit_type))='1'/*借方*/
         begin
           update account_turn set start_borrow_sum=isnull(start_borrow_sum,0)-@expenses_unitprice,
           end_borrow_sum=isnull(start_borrow_sum,0)-@expenses_unitprice+isnull(this_borrow_sum,0)-isnull(this_lend_sum,0)
           from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
           a.finacial_m=@finacial_m and a.expenses_id=@expenses_id  
         end else if ltrim(rtrim(@debitandcredit_type))='0' /*贷方*/
         begin
           update account_turn set start_lend_sum=isnull(start_lend_sum,0)-@expenses_unitprice,
           end_lend_sum=isnull(start_lend_sum,0)-@expenses_unitprice+isnull(this_lend_sum,0)-isnull(this_borrow_sum,0)
           from  account_turn a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
           a.finacial_m=@finacial_m and a.expenses_id=@expenses_id 
         end
       end

     end /********************************科目的核算明晰中没有数据************************************/
  end /*弃审*/

                           
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTransp_basebursarObject
end else
begin
COMMIT TRANSACTION MyTransp_basebursarObject
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

