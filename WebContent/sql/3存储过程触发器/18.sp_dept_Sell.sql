if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dept_Sell]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dept_Sell]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--部门销售分析
CREATE   PROCEDURE sp_dept_Sell
      (@com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @store_struct_id varchar(30),
       @regionalism_id varchar(30),
       @customer_id varchar(30),
       @dept_id varchar(30),
       @clerk_id varchar(30),
       @type_id varchar(30),
       @item_id varchar(40),
       @desc char(1),    -- desc=1：  降序排列
       @ilist int,
       @dept_right varchar(8000))

AS 
BEGIN TRANSACTION mytranSp_dept_Sell
    declare @text3 varchar(8000),@ssql varchar(8000)

   create table #temp (com_id char(10),dept_id varchar(30),Sell_Amount decimal(28,6),Sell_cost decimal(28,6),
   Sell_gain decimal(28,6),Sell_rate decimal(28,6))

     select @text3=''
     select @text3='  and com_id='+''''+@com_id+''''
   if ltrim(rtrim(@store_struct_id))<>'' 
     select @text3=@text3+' and store_struct_id like '+''''+ltrim(rtrim(@store_struct_id))+'%'''  
   if ltrim(rtrim(@regionalism_id))<>'' 
     select @text3=@text3+' and customer_id in (select customer_id  from SDf00504 where com_id='+''''
      + rtrim(ltrim(@com_id))+'''  and  regionalism_id like '''+ltrim(rtrim(@regionalism_id))+'%'')'
   if ltrim(rtrim(@customer_id))<>'' 
     select @text3=@text3+' and customer_id='+''''+ltrim(rtrim(@customer_id))+''''  
   if ltrim(rtrim(@dept_id))<>'' 
     select @text3=@text3+' and  dept_id like '+''''+ltrim(rtrim(@dept_id))+'%'''  
   if ltrim(rtrim(@clerk_id))<>'' 
     select @text3=@text3+' and clerk_id='+''''+ltrim(rtrim(@clerk_id))+'''' 
   if ltrim(rtrim(@type_id))<>'' 
     select @text3=@text3+' and item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id))+''''+'  and  type_id like  '''+ltrim(rtrim(@type_id))+'%'')'
   if ltrim(rtrim(@item_id))<>'' 
     select @text3=@text3+' and item_id='+''''+ltrim(rtrim(@item_id))+''''  
   if ltrim(rtrim(@dept_right))<>'' 
     select @text3=@text3+' and  '+@dept_right

   select @text3=@text3+'  and comfirm_flag=''Y'''

   select @ssql=''                               
   select @ssql='insert into #temp select com_id,dept_id,sum_si,sd_oq*tax_sum_si as Sell_cost,0 as Sell_gain,0 as sell_rate from View_sdd02020 where  '
      +' (sd_order_direct=''发货'' or sd_order_direct=''现款'')  and (so_consign_date>='''+rtrim(ltrim(@star_date))+''' and so_consign_date<='''
      +rtrim(ltrim(@end_date))+''')'+@text3
    exec(@ssql)  /*销售发货*/

   select @ssql=''
   select @ssql='insert into #temp select com_id,dept_id,-sum_si,-sd_oq*tax_sum_si as Sell_cost,0 as Sell_gain,0 as sell_rate from View_sdd02020 where  '
      +'sd_order_direct=''退货'' and (so_consign_date>='''+rtrim(ltrim(@star_date))+''' and so_consign_date<='''
      +rtrim(ltrim(@end_date))+''')'+@text3
    exec(@ssql)  /*销售退货*/

   select @ssql=''
   if @ilist=0 
   begin
     select @ssql='select  com_id,dept_id,sum(Sell_Amount) as Sell_Amount,case when sum(Sell_Amount)=0  then 0 else '
     +' ((sum(Sell_Amount)-sum(Sell_cost))/sum(Sell_Amount)) end as Sell_rate,order0=0 '
     +' from #temp group by com_id,dept_id union all select  com_id,dept_id=''合计'',sum(Sell_Amount) as Sell_Amount,'
     +'case when sum(Sell_Amount)=0  then 0 else ((sum(Sell_Amount)-sum(Sell_cost))/sum(Sell_Amount)) end as Sell_rate,order0=1 '
     +' from #temp group by com_id  order by   order0,Sell_Amount desc'
   end else begin
     select @ssql='select  top 10 com_id,dept_id,sum(Sell_Amount) as Sell_Amount,case when sum(Sell_Amount)=0  then 0 else '
     +' ((sum(Sell_Amount)-sum(Sell_cost))/sum(Sell_Amount)) end as Sell_rate from #temp group by com_id,dept_id  order by Sell_Amount'
     if ltrim(rtrim(@desc))='1'   --前十名不加为后十名
     select @ssql=@ssql+'  desc '
   end 
   exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_dept_Sell
return 0
end else
begin
COMMIT TRANSACTION mytranSp_dept_Sell
return 1
end





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

