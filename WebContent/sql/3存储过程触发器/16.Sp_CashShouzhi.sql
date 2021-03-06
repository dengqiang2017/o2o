if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_CashShouzhi]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_CashShouzhi]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--现金收支表
CREATE     PROCEDURE Sp_CashShouzhi 
      (@com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @dept_id  varchar(30),
       @settlement_type_id varchar(30),
       @get_dept varchar(8000),
       @get_store varchar(8000)  
      )
AS 
BEGIN TRANSACTION mytran_Sp_CashShouzhi 
    declare @text3 varchar(8000),@ssql varchar(8000),@pass_sum decimal(22,2),@sd_order_id varchar(30),@sort_id varchar(30),@sid int,
    @cash_in decimal(22,2),@Cash_out  decimal(22,2),@Cash_Check decimal(22,2),@xid int ,
    @current_sum decimal(22,2),@danhao varchar(30),@abc varchar(30),@Take_date datetime,@c_type varchar(10)

    create table #temp (ivt_oper_listing varchar(30),sd_order_id varchar(30),com_id char(10),sort_id varchar(30),
    settlement_type_id varchar(30),c_type varchar(10),Take_Date datetime,Cash_in decimal(22,2),Cash_out  decimal(22,2), 
    Cash_Check decimal(22,2),sid int,mainten_datetime datetime,customer_id varchar(30),vendor_id varchar(30),recieve_type varchar(20),dept_id varchar(30),clerk_id varchar(35) ) 
 
    create table #temp1(ivt_oper_listing varchar(30),sd_order_id varchar(30),com_id char(10),sort_id varchar(30),
    settlement_type_id varchar(30),c_type varchar(10),Take_Date datetime,Cash_in decimal(22,2),Cash_out  decimal(22,2),
    Cash_Check decimal(22,2),sid int,mainten_datetime datetime,customer_id varchar(30),vendor_id varchar(30),recieve_type varchar(20),dept_id varchar(30),clerk_id varchar(35) ) 

   select @abc=(select (convert(varchar(10),finacial_date_bigen,21)) as finacial_date_bigen  from ctl02101 where com_id=@com_id  
   and finacial_date_bigen=(select min(finacial_date_bigen) from ctl02101 where com_id=@com_id)
   and finacial_y=(select min(finacial_y) from ctl02101 where com_id=@com_id)
   and finacial_m=(select min(finacial_m) from ctl02101 where com_id=@com_id))

  select @text3=''
--开始：部门权限
  if ltrim(rtrim(@get_dept))<>''
     select @text3=@text3+' and  '+ltrim(rtrim(@get_dept))+' '
--结束：部门权限

   select @ssql=''                               
   select @ssql='insert into #temp1 select '''','''',com_id,sort_id,''初始金额'',''初始'','''+@abc+''',0 as Cash_in,'
   +'0 as Cash_out,isnull(I_Amount,0) as Cash_Check,0,'''','''','''','''',ltrim(rtrim(isnull(dept_id,''''))) as dept_id,'''' as clerk_id  from Ctl02107  '
   +'where  com_id='''+@com_id+''' '   --结算方式表
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(sort_id,''''))) like '''+ltrim(rtrim(isnull(@settlement_type_id,'')))+'%'' '
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'')))+'%'' '
   select @ssql=@ssql+@text3 
   exec(@ssql)  
/*-------------------------------------------小于@star_date的金额数----------------------------------------------------*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select  recieved_auto_id,recieved_id,com_id,rejg_hw_no,rejg_hw_no,''付款'',finacial_d,'
   +'0 as Cash_in,type_sum,0 as Cash_Check,seeds_id,mainten_datetime,'''',customer_id,recieve_type,dept_id,clerk_id  from ARd02051  '
   +'where  com_id='''+@com_id+''' and  recieved_direct=''付款'''/*--  and  rejg_hw_no in (select sort_id  from Ctl02107  '
--   +'where  com_id='''+@com_id+''' )*/
   +' and comfirm_flag=''Y''  and finacial_d<'''+rtrim(ltrim(@star_date))+''''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and rejg_hw_no like '''+@settlement_type_id+'%'' '
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'')))+'%'' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*采购付款*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select recieved_auto_id,recieved_id,com_id,rcv_hw_no,rcv_hw_no,''收款'',finacial_d,type_sum,'
   +'0 as Cash_out,0 as Cash_Check,seeds_id,mainten_datetime,customer_id,'''',recieve_type,dept_id,clerk_id  from ARd02051  '
   +'where  com_id='''+@com_id+''' and  recieved_direct=''收款'' and comfirm_flag=''Y'' and finacial_d<'''+rtrim(ltrim(@star_date))+''' '
   if rtrim(ltrim(@settlement_type_id))<>''  
   select @ssql=@ssql+'  and rcv_hw_no='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*销售收款*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select  cash_code,cash_code,com_id,account_id,account_id,''银行'',cash_date,'
   +'0 as Cash_in,account_Amount,0 as Cash_Check,sid,maintenance_datetime,'''','''',''银行取款'',dept_id,clerk_id  from Ctl04090  '
   +'where  com_id='''+@com_id+'''   and cash_date<'''+rtrim(ltrim(@star_date))+''''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and account_id='''+@settlement_type_id+''' '
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*银行取*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select cash_code,cash_code,com_id,inaccount_id,inaccount_id,''银行'',cash_date,account_Amount,'
   +'0 as Cash_out,0 as Cash_Check,sid,maintenance_datetime,'''','''',''银行存款'',dept_id,clerk_id  from Ctl04090  '
   +'where  com_id='''+@com_id+'''     and cash_date<'''+rtrim(ltrim(@star_date))+''' '
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and inaccount_id='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*银行存*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select ivt_oper_listing,sd_order_id,com_id,billNO,billNO,''费用'',finacial_d,'
   +'0 as Cash_in,sum_si,0 as Cash_Check,0,mainten_datetime,'''','''',bill_source,dept_id,clerk_id  from SDDM03001  '
   +'where  com_id='''+@com_id+''' and  bill_source=''费用报销'' '
   +' and  finacial_d<'''+rtrim(ltrim(@star_date))+''''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and billNO='''+@settlement_type_id+'''' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*费用支出*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select rep_auto_no,rep_hw_no,com_id,unit_id,unit_id,''返利'',finacial_d,'
   +'0 as Cash_in,rep_qty,0 as Cash_Check,0,mainten_datetime,pro_item,'''',''客户让利'',dept_id,clerk_id  from View_STDM01001  '
   +'where  com_id='''+@com_id+''' and  st_hw_no=''客户''  and comfirm_flag=''Y'' '
   +' and  finacial_d<'''+rtrim(ltrim(@star_date))+''''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and unit_id='''+@settlement_type_id+'''' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*客户让利*/

   select @ssql=''                               
   select @ssql='insert into #temp1 select rep_auto_no,rep_hw_no,com_id,unit_id,unit_id,''返利'',finacial_d,'
   +'rep_qty,0  as Cash_out ,0 as Cash_Check,0,mainten_datetime,'''',vendor_id,''供应商返利'',dept_id,clerk_id  from View_STDM01001  '
   +'where  com_id='''+@com_id+''' and  st_hw_no=''供货''  and comfirm_flag=''Y'' '
   +' and  finacial_d<'''+rtrim(ltrim(@star_date))+''''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and unit_id='''+@settlement_type_id+'''' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*供应商返利*/

   select @ssql=''                               
   select @ssql='insert into #temp select '''','''',com_id,sort_id,''初始金额'','''',Take_Date=null,0 as Cash_in,'
   +'0 as Cash_out,(sum(Cash_Check)+sum(Cash_in)-sum(Cash_out)) as Cash_Check,0,'''','''','''','''','''' as dept_id,'''' as clerk_id  from #temp1    '
   +'where  com_id='''+@com_id+''' group by com_id,sort_id'
   exec(@ssql)  

   update #temp set Take_Date=@star_date,c_type='初始',recieve_type='上期结余',sd_order_id='上期结余'  
/*-------------------------------------------小于@star_date的金额数----------------------------------------------------*/     
   select @ssql=''                               
   select @ssql='insert into #temp select  recieved_auto_id,recieved_id,com_id,rejg_hw_no,rejg_hw_no,''付款'',finacial_d,'
   +'0 as Cash_in,type_sum,0 as Cash_Check,seeds_id,mainten_datetime,'''',customer_id,recieve_type,dept_id,clerk_id  from ARd02051  '
   +'where  com_id='''+@com_id+''' and  recieved_direct=''付款'' and comfirm_flag=''Y'' and (finacial_d>='''
   +rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''') and recieve_type<>''退货收款'''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and rejg_hw_no='''+@settlement_type_id+''' '
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*采购付款*/

   select @ssql=''                               
   select @ssql='insert into #temp select  recieved_auto_id,recieved_id,com_id,rejg_hw_no,rejg_hw_no,''付款'',finacial_d,'
   +'sum_si as Cash_in,0,0 as Cash_Check,seeds_id,mainten_datetime,'''',customer_id,recieve_type,dept_id,clerk_id  from ARd02051  '
   +'where  com_id='''+@com_id+''' and  recieved_direct=''付款'' and comfirm_flag=''Y'' and (finacial_d>='''
   +rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''') and recieve_type=''退货收款'''
   if rtrim(ltrim(@settlement_type_id))<>''  
   select @ssql=@ssql+'  and rejg_hw_no='''+@settlement_type_id+''' '
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*采购付款   退货收款*/

   select @ssql=''                               
   select @ssql='insert into #temp select recieved_auto_id,recieved_id,com_id,rcv_hw_no,rcv_hw_no,''收款'',finacial_d,type_sum,'
   +'0 as Cash_out,0 as Cash_Check,seeds_id,mainten_datetime,customer_id,'''',recieve_type,dept_id,clerk_id  from ARd02051  '
   +'where  com_id='''+@com_id+''' and  recieved_direct=''收款''  and comfirm_flag=''Y''  and (finacial_d>='''
   +rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''')  and  recieve_type<>''退货付款'''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and rcv_hw_no='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*销售收款*/

   select @ssql=''                               
   select @ssql='insert into #temp select recieved_auto_id,recieved_id,com_id,rcv_hw_no,rcv_hw_no,''收款'',finacial_d,0,'
   +'sum_si as Cash_out,0 as Cash_Check,seeds_id,mainten_datetime,customer_id,'''',recieve_type,dept_id,clerk_id  from ARd02051  '
   +'where  com_id='''+@com_id+''' and  recieved_direct=''收款''  and comfirm_flag=''Y''  and (finacial_d>='''
   +rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''') and  recieve_type=''退货付款'''
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and rcv_hw_no='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*销售收款  退货付款*/

   select @ssql=''                               
   select @ssql='insert into #temp select  cash_code,cash_code,com_id,account_id,account_id,''银行'',cash_date,'
   +'0 as Cash_in,account_Amount,0 as Cash_Check,sid,maintenance_datetime,'''','''',''银行取款'',dept_id,clerk_id  from Ctl04090  '
   +'where  com_id='''+@com_id+'''    and (cash_date>='''
   +rtrim(ltrim(@star_date))+''' and cash_date<='''+rtrim(ltrim(@end_date))+''')'
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and account_id='''+@settlement_type_id+''' '
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*银行取*/

   select @ssql=''                               
   select @ssql='insert into #temp select cash_code,cash_code,com_id,inaccount_id,inaccount_id,''银行'',cash_date,account_Amount,'
   +'0 as Cash_out,0 as Cash_Check,sid,maintenance_datetime,'''','''',''银行存款'',dept_id,clerk_id  from Ctl04090  '
   +'where  com_id='''+@com_id+'''    and (cash_date>='''
   +rtrim(ltrim(@star_date))+''' and cash_date<='''+rtrim(ltrim(@end_date))+''') '
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and inaccount_id='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*银行存*/

   select @ssql=''                               
   select @ssql='insert into #temp select ivt_oper_listing,sd_order_id,com_id,billNO,billNO,''费用'',finacial_d,'
   +'0 as Cash_in,sum_si,0 as Cash_Check,id,mainten_datetime,customer_id,vendor_id,bill_source,dept_id,clerk_id  from VIEW_SDDM03001  '
   +'where  com_id='''+@com_id+'''  and  bill_source=''费用报销'' '
   +' and (finacial_d>='''+rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''')'
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and billNO='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*费用支出*/

   select @ssql=''                               
   select @ssql='insert into #temp select rep_auto_no,rep_hw_no,com_id,unit_id,unit_id,''返利'',finacial_d,'
   +'0 as Cash_in,rep_qty,0 as Cash_Check,0,mainten_datetime,pro_item,'''',''客户让利'',dept_id,clerk_id  from View_STDM01001  '
   +'where  com_id='''+@com_id+''' and  st_hw_no=''客户''  and comfirm_flag=''Y'' '
   +' and (finacial_d>='''+rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''')'
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and unit_id='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*客户让利*/

   select @ssql=''                               
   select @ssql='insert into #temp select rep_auto_no,rep_hw_no,com_id,unit_id,unit_id,''返利'',finacial_d,'
   +'rep_qty,0  as Cash_out ,0 as Cash_Check,0,mainten_datetime,'''',vendor_id,''供应商返利'',dept_id,clerk_id  from View_STDM01001  '
   +'where  com_id='''+@com_id+''' and  st_hw_no=''供货''  and comfirm_flag=''Y'' '
   +' and (finacial_d>='''+rtrim(ltrim(@star_date))+''' and finacial_d<='''+rtrim(ltrim(@end_date))+''')'
   if rtrim(ltrim(@settlement_type_id))<>'' 
   select @ssql=@ssql+'  and unit_id='''+@settlement_type_id+''' ' 
   if rtrim(ltrim(@dept_id))<>'' 
   select @ssql=@ssql+'  and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(isnull(@dept_id,'')))+''' ' 
   select @ssql=@ssql+@text3 
   exec(@ssql)  /*供应商返利*/

select @xid=0
 declare mycur  CURSOR FOR 
		select a.sort_id,a.Cash_in,a.Cash_out,a.Cash_Check,a.sid,a.Take_date,a.c_type 
      from #temp a  order by com_id,sort_id ,Take_Date,mainten_datetime
OPEN mycur
FETCH NEXT FROM mycur 
INTO @sort_id,@Cash_in,@Cash_out,@Cash_Check,@sid,@Take_date,@c_type

WHILE @@FETCH_STATUS = 0
begin
   if @xid=0 
   select @pass_sum=isnull(@Cash_Check,0)

   select @danhao=@sort_id
   select @xid=1
   select @current_sum=@pass_sum+isnull(@Cash_in,0)-isnull(@Cash_out,0)

   update #temp set Cash_Check=@current_sum  from #temp where com_id=@com_id 
   and sort_id=@sort_id  and sid=@sid and Take_date=@Take_date and c_type=@c_type

   select @pass_sum=@current_sum

   FETCH NEXT FROM mycur 
      INTO @sort_id,@Cash_in,@Cash_out,@Cash_Check,@sid,@Take_date,@c_type
   if @danhao<>@sort_id 
   begin
     select @pass_sum=0
     select @xid=0 
   end 
end
CLOSE mycur
DEALLOCATE mycur


 select @ssql=''
 select @ssql='select  com_id=null,ivt_oper_listing=null,sd_order_id=null,sort_id,settlement_type_id=''小计'','
 +'Take_Date=null,sum(Cash_in) as Cash_in,sum(Cash_out) as Cash_out,Cash_Check=null,mainten_datetime=null,'
 +'customer_id=null,vendor_id=null,c_type=null,recieve_type=null,sid=null,'''' as dept_id,'''' as clerk_id,order1=1,order2=sort_id,order3=0   '
 +'from #temp group by com_id,sort_id '
 +' union all select  com_id,ivt_oper_listing,sd_order_id,sort_id,settlement_type_id,Take_Date,Cash_in,'
 +'Cash_out,Cash_Check,mainten_datetime,customer_id,vendor_id,c_type,recieve_type,sid,dept_id,clerk_id,order1=0,order2=sort_id,order3=0  from #temp '
 +'union all select  com_id=null,ivt_oper_listing=null,sd_order_id=null,sort_id=null,settlement_type_id=''合计'','
 +'Take_Date=null,sum(Cash_in) as Cash_in,sum(Cash_out) as Cash_out,Cash_Check=null,mainten_datetime=null,'
 +'customer_id=null,vendor_id=null,c_type=null,recieve_type=null,sid=null,'''' as dept_id,'''' as clerk_id,order1=1,order2=null,order3=1 from #temp '
 +'order by order3,order2,order1,sort_id,Take_Date,mainten_datetime,sid '     --*/
 exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytran_Sp_CashShouzhi
return 0
end else
begin
COMMIT TRANSACTION mytran_Sp_CashShouzhi
return 1
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

