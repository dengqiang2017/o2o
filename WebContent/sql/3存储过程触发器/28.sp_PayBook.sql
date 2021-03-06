if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PayBook]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PayBook]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--应付帐薄总账
CREATE       PROCEDURE sp_PayBook
@com_id varchar(10),
@StartDate varchar(30),   
@EndDate   varchar(30),
@Where  varchar(8000),
@zero char(1),
@clerk_id varchar(30),
@dept_id varchar(30),
@get_dept varchar(8000)
as
BEGIN TRANSACTION mytran_sp_PayBook
declare
@SQL varchar(8000),
@Where1 varchar(8000),
@Where2 varchar(8000),
@ssql varchar(4000)

create table #temp (vendor_id varchar(30),vendor_name varchar(50),beg_sum decimal(17,6),increase  decimal(17,6),
                   decrease   decimal(17,6),balance_sum decimal(17,6),end_sum decimal(17,6),dept_id varchar(30),clerk_id varchar(30) )
select @Where=@Where+' and  '+ltrim(rtrim(@get_dept))+' '  --部门权限
set @where1=' D_OPERDATE<'''+ rtrim(ltrim(@StartDate))+''''
set @where2='( D_OPERDATE>='''+ rtrim(ltrim(@StartDate))+''' and  D_OPERDATE<='''+ rtrim(ltrim(@EndDate))+''')'

select @SQL='insert into #temp(vendor_id,vendor_name,beg_sum,increase,decrease,balance_sum,end_sum,dept_id,clerk_id )
select corp_id as vendor_id,corp_name as vendor_name,beg_sum,increase,decrease,balance_sum,end_sum,dept_id,clerk_id from (
   select a.corp_id,a.corp_name,
      isnull(b.Amount,0)+isnull(c.Amount,0)-isnull(d.Amount,0)-isnull(g.Amount,0) as beg_sum,
      isnull(e.Amount,0) as increase,
      isnull(f.Amount,0) as decrease, 
      isnull(h.amount,0) as balance_sum, 
      isnull(b.Amount,0)+isnull(c.Amount,0)-isnull(d.Amount,0)-isnull(g.Amount,0)
      +isnull(e.Amount,0)-isnull(f.Amount,0)-isnull(h.Amount,0) as end_sum,a.dept_id,a.clerk_id
   from ctl00504  a  
     
   left join 
     (
     select vendor_id,sum(beg_sum) as Amount
     from  stfM0201 where com_id='''+@com_id+'''  
     and  initial_flag=''Y'' group by vendor_id ) b  on a.corp_id=b.vendor_id
             
   left join
     ( 
     select vendor_id,sum(st_sum) as Amount
     from
       (
       select vendor_id,send_date as store_date,fee_sum as st_sum
       from Yie05010 where comfirm_flag=''Y''  and com_id='''+@com_id+'''
       union all
       select vendor_id,store_date,st_sum
       from STDM03001 where (stock_type=''进货'' or stock_type=''借货'') and comfirm_flag=''Y''  and com_id='''+@com_id+'''
       union all
       select vendor_id,store_date,-st_sum
       from STDM03001 where stock_type=''退货''   and comfirm_flag=''Y'' and com_id='''+@com_id+'''
       ) a
     where  store_date<'''+ rtrim(ltrim(@StartDate))+'''
     group by vendor_id
     ) c on a.corp_id=c.vendor_id
  
   left join
     (select customer_id,sum(sum_si) as Amount 
      from  
       (select customer_id,finacial_d,(-sum_si) as sum_si
       from ARd02051 where recieved_direct=''付款'' and recieve_type=''退货收款'' and comfirm_flag=''Y''  and com_id='''+@com_id+'''
       union all 
       select customer_id,finacial_d,sum_si
       from ARd02051 where recieved_direct=''付款'' and recieve_type<>''退货收款'' and comfirm_flag=''Y''  and com_id='''+@com_id+'''
       ) a  where    finacial_d<'''+ rtrim(ltrim(@StartDate))+'''' + '
       group by customer_id
     ) d on a.corp_id=d.customer_id
   
  left join
     (select customer_id,sum(tax_invoice_sum) as Amount 
      from  
       (select customer_id,finacial_d,tax_invoice_sum
       from ARfM02010 where c_type=''应付''  and initial_flag=''Y''  and com_id='''+@com_id+''' 
       ) a  where    finacial_d<'''+ rtrim(ltrim(@StartDate))+'''' + '
       group by customer_id
     ) g  on a.corp_id=g.customer_id
  
   
   left join
     ( 
     select vendor_id,sum(st_sum) as Amount
     from
       (
       select vendor_id,send_date as store_date,fee_sum as st_sum
       from Yie05010 where comfirm_flag=''Y''  and com_id='''+@com_id+'''
       union all
       select vendor_id,store_date,st_sum
       from STDM03001 where (stock_type=''进货'' or stock_type=''借货'')  and comfirm_flag=''Y''  and com_id='''+@com_id+'''
       union all
       select vendor_id,store_date,-st_sum
       from STDM03001 where stock_type=''退货''   and comfirm_flag=''Y''  and com_id='''+@com_id+'''
       ) a
    where ' + '( store_date>='''+ rtrim(ltrim(@StartDate))+''' and  store_date<='''+ rtrim(ltrim(@EndDate))+''')' + '
    group by vendor_id
    ) e on a.corp_id=e.vendor_id  
   
  left join
    (
    select customer_id,sum(sum_si) as Amount
    from 
      (select customer_id,finacial_d,(-sum_si) as sum_si
       from ARd02051 where  recieved_direct=''付款'' and recieve_type=''退货收款''  and comfirm_flag=''Y''  and com_id='''+@com_id+'''   
       union all 
       select customer_id,finacial_d,sum_si
       from ARd02051 where recieved_direct=''付款'' and recieve_type<>''退货收款'' and comfirm_flag=''Y''  and com_id='''+@com_id+'''

       ) a  where    '+ '( finacial_d>='''+ rtrim(ltrim(@StartDate))+''' and  finacial_d<='''+ rtrim(ltrim(@EndDate))+''')' + '
    group by customer_id
    ) f on a.corp_id=f.customer_id

  left join
     (select customer_id,sum(tax_invoice_sum) as Amount 
      from  
       (select customer_id,finacial_d,tax_invoice_sum
       from ARfM02010 where c_type=''应付''  and initial_flag=''Y''  and com_id='''+@com_id+''' 
       ) a  where ( finacial_d>='''+ rtrim(ltrim(@StartDate))+''' and  finacial_d<='''+ rtrim(ltrim(@EndDate))+''')
       group by customer_id
     ) h  on a.corp_id=H.customer_id

 ) tmp  where  ' + @Where 
exec(@SQL)
  

  if ltrim(rtrim(@zero))='1'
  begin
    select @ssql=''
    select  @ssql='select vendor_id,vendor_name,beg_sum,increase,decrease,balance_sum,end_sum,order0=0 from #temp   '
      +' where isnull(end_sum,0)<>0  union all select vendor_id=null,vendor_name=''合计'',sum(beg_sum) as beg_sum,
      sum(increase) as increase,sum(decrease) as decrease,sum(balance_sum) as balance_sum,sum(end_sum) as end_sum,
      order0=1 from #temp   order by order0,vendor_id'
    exec(@ssql)   
  end else if ltrim(rtrim(@zero))='0'
  begin
    select @ssql=''
    select  @ssql='select vendor_id,vendor_name,beg_sum,increase,decrease,balance_sum,end_sum,order0=0 from #temp   '
      +' union all select vendor_id=null,vendor_name=''合计'',sum(beg_sum) as beg_sum,sum(increase) as increase,'
      +'sum(decrease) as decrease,sum(balance_sum) as balance_sum,sum(end_sum) as end_sum,order0=1 from #temp  
      order by order0,vendor_id'
    exec(@ssql)   
  end

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytran_sp_PayBook
return 0
end else
begin
COMMIT TRANSACTION mytran_sp_PayBook
return 1
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

