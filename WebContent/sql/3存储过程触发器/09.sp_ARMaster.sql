if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ARMaster]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ARMaster]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--应收帐薄总账
CREATE      PROCEDURE sp_ARMaster
  @com_id  varchar(10),
  @StartDate varchar(30),   
  @EndDate   varchar(30),
  @Where  varchar(8000),
  @Zero  char(1),
  @dept_id varchar(30),
  @clerk_id varchar(30),
  @get_dept varchar(8000),
  @tjfs int,
  @customer_id varchar(50)
as
BEGIN TRANSACTION mytran_sp_ARMaster
declare
  @SQL varchar(8000),                         --以下几个长度很重要
  @Where1 varchar(8000),  
  @Where2 varchar(8000),
  @Where3 varchar(8000),@Where4 varchar(8000),
  @ssql varchar(8000),
  @tjfssql varchar(150),
  @tjfssql2 varchar(150)

create table #temp (customer_id varchar(30),customer_name varchar(50),regionalism_id varchar(30),dept_id varchar(30),clerk_id varchar(30),oh_sum decimal(22,6),
                    addi_sum  decimal(22,6),rev_sum  decimal(22,6),tax_invoice_sum decimal(22,6),acct_recieve_sum  decimal(22,6))

create table #temp1 (customer_id varchar(30),customer_name varchar(50),dept_id varchar(30),clerk_id varchar(30),oh_sum decimal(22,6),
                    addi_sum  decimal(22,6),rev_sum  decimal(22,6),tax_invoice_sum decimal(22,6),acct_recieve_sum  decimal(22,6),)

set @tjfssql=( case @tjfs when 0 then '' when 1 then ',dept_id' when 2 then ',clerk_id' end )
set @tjfssql2=( case @tjfs when 0 then '' when 1 then ',c.dept_id' when 2 then ',c.clerk_id' end )

set @Where3=@Where

if ltrim(rtrim(@dept_id))<>''
  set @Where3=@Where3+' and ltrim(rtrim(isnull(dept_id,'''')))='''+ltrim(rtrim(@dept_id))+''' '
if ltrim(rtrim(@clerk_id))<>''
  set @Where3=@Where3+' and ltrim(rtrim(isnull(clerk_id,'''')))='''+ltrim(rtrim(@clerk_id))+''' '
if ltrim(rtrim(@customer_id))<>''
  set @Where3=@Where3+' and ltrim(rtrim(isnull(customer_id,'''')))='''+ltrim(rtrim(isnull(@customer_id,'')))+''''

set @where1=' D_OPERDATE<'''+ rtrim(ltrim(@StartDate))+''''
set @where2='( D_OPERDATE>='''+ rtrim(ltrim(@StartDate))+''' and  D_OPERDATE<='''+ rtrim(ltrim(@EndDate))+''' ) '

select @Where4=''
select @Where4=@Where4+' and  '+ltrim(rtrim(@get_dept))+' '  --部门权限

select @SQL='insert into #temp(customer_id,customer_name,regionalism_id '+@tjfssql+',oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum)  
select customer_id,corp_name,regionalism_id'+@tjfssql+',oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum  from (
   select a.customer_id,a.corp_name,a.regionalism_id'+@tjfssql2+',c.oh_sum,c.addi_sum,c.rev_sum,c.tax_invoice_sum,isnull(c.oh_sum,0)+isnull(c.addi_sum,0)-isnull(c.rev_sum,0)-isnull(c.tax_invoice_sum,0) as acct_recieve_sum
   from SDf00504 a 
   left join '

select @SQL=@SQL+' ( select customer_id'+@tjfssql+',sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum from ( '

--期初应收
select @SQL=@SQL+'
   select customer_id,dept_id,clerk_id,isnull(oh_sum,0) as oh_sum,0 as addi_sum,0 as rev_sum,0 as tax_invoice_sum from  ARf02030 where initial_flag=''Y'' and com_id='''+@com_id+''''+@Where3+'  
   union all
	select customer_id,dept_id,clerk_id,sum_si as Amount,0,0,0
	from
	(
	select customer_id,dept_id,clerk_id,so_consign_date,(sum_si-isnull(i_agiosum,0)) as sum_si
	from SDd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'')  and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'  
	union all
	select customer_id,dept_id,clerk_id,so_consign_date,-sum_si  as sum_si
	from SDd02020 where sd_order_direct=''退货''   and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+' 
	) a1
	where  so_consign_date<'''+ rtrim(ltrim(@StartDate))+'''
   union all
     select customer_id,dept_id,clerk_id,-sum_si as Amount,0,0,0 
      from  
       (select customer_id,dept_id,clerk_id,finacial_d,sum_si
       from ARd02051 where recieved_direct=''收款''  and recieve_type<>''退货付款'' and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'  
        union all 
       select customer_id,dept_id,clerk_id,finacial_d,(-sum_si) as sum_si
       from ARd02051 where recieved_direct=''收款''  and recieve_type=''退货付款'' and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'  
       ) a2  where    finacial_d<'''+ rtrim(ltrim(@StartDate))+'''
  union all
     select customer_id,dept_id,clerk_id,-tax_invoice_sum as Amount,0,0,0 
      from  
       (select customer_id,dept_id,clerk_id,finacial_d,tax_invoice_sum
       from ARfM02010 where c_type=''应收''  and initial_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'  
       ) a3  where    finacial_d<'''+ rtrim(ltrim(@StartDate))+''''


--本期应收
select @SQL=@SQL+'  
     union all	  
     select customer_id,dept_id,clerk_id,0,sum_si as Amount,0,0
     from
       (
       select customer_id,dept_id,clerk_id,so_consign_date,(sum_si-isnull(i_agiosum,0)) as sum_si
       from SDd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'')   and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'  
       union all
       select customer_id,dept_id,clerk_id,so_consign_date,(-sum_si) as sum_si
       from SDd02020 where sd_order_direct=''退货''  and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+' 
       ) a4
    where ' + '( so_consign_date>='''+ rtrim(ltrim(@StartDate))+''' and  so_consign_date<='''+ rtrim(ltrim(@EndDate))+''')'


/*本期已收*/
select @SQL=@SQL+'  
  union all
    select customer_id,dept_id,clerk_id,0,0,sum_si as Amount,0
    from 
      (select customer_id,dept_id,clerk_id,finacial_d,sum_si
       from ARd02051 where  recieved_direct=''收款'' and recieve_type<>''退货付款'' and comfirm_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'     
       union all 
       select customer_id,dept_id,clerk_id,finacial_d,(-sum_si) as sum_si
       from ARd02051 where recieved_direct=''收款''  and recieve_type=''退货付款'' and comfirm_flag=''Y''  and com_id='''+@com_id+''''+' 
       ) a5  where    '+ '( finacial_d>='''+ rtrim(ltrim(@StartDate))+''' and  finacial_d<='''+ rtrim(ltrim(@EndDate))+''')'

/*呆坏*/
select @SQL=@SQL+'
    union all
	select customer_id,dept_id,clerk_id,0,0,0,tax_invoice_sum as Amount 
      from  
       (select customer_id,dept_id,clerk_id,finacial_d,tax_invoice_sum
       from ARfM02010 where c_type=''应收''  and initial_flag=''Y''  and com_id='''+@com_id+''''+@Where3+'  
       ) a6  where  ( finacial_d>='''+ rtrim(ltrim(@StartDate))+''' and  finacial_d<='''+ rtrim(ltrim(@EndDate))+''')'

select @SQL=@SQL+') b group by customer_id'+@tjfssql+
		 ') c on a.customer_id=c.customer_id where 1=1  ) d '
--		 ') c on a.customer_id=c.customer_id where 1=1 '+@Where4+' ) d '

if  ltrim(rtrim(isnull(@Zero,'')))='1'
  select @SQL=@SQL+' where isnull(acct_recieve_sum,0)<>0 '
if  ltrim(rtrim(isnull(@Zero,'')))='0'
  select @SQL=@SQL+' where 1=1 '

exec(@SQL)

    if @tjfs=0
	    select  @ssql='select customer_id=''小计'',customer_name=''小计'',regionalism_id,dept_id=null,clerk_id=null,sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,order1=1,'
	    +' order2=(regionalism_id),order3=0 from  #temp '+' where 1=1 '+@Where3--+@Where4
            +' group by regionalism_id '
	    +' union all select customer_id,customer_name,regionalism_id,dept_id,clerk_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,order1=0,order2=(regionalism_id),order3=0 from  #temp '+' where 1=1 '+@Where3--+@Where4
	    +' union all select customer_id=''合计'',customer_name=''合计'',regionalism_id=null,dept_id=null,clerk_id=null,sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,order1=1,'
	    +' order2=null,order3=1 from  #temp order by order3,order2,order1'
    if @tjfs=1
	    select  @ssql='select customer_id=''小计'',customer_name=''小计'',regionalism_id=null,dept_id,clerk_id=null,sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,order1=1,'
	    +' order2=(dept_id),order3=0 from  #temp '+' where 1=1 '+@Where3--+@Where4
            +' group by dept_id '
	    +' union all select customer_id,customer_name,regionalism_id,dept_id,clerk_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,order1=0,order2=(dept_id),order3=0 from  #temp '+' where 1=1 '+@Where3--+@Where4
	    +' union all select customer_id=''合计'',customer_name=''合计'',regionalism_id=null,dept_id=null,clerk_id=null,sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,order1=1,'
	    +' order2=null,order3=1 from  #temp order by order3,order2,order1'
    if @tjfs=2
	    select  @ssql='select customer_id=''小计'',customer_name=''小计'',regionalism_id=null,dept_id=null,clerk_id,sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,order1=1,'
	    +' order2=(clerk_id),order3=0 from  #temp '+' where 1=1 '+@Where3--+@Where4
            +' group by clerk_id '
	    +' union all select customer_id,customer_name,regionalism_id,dept_id,clerk_id,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,order1=0,order2=(clerk_id),order3=0 from  #temp '+' where 1=1 '+@Where3--+@Where4
	    +' union all select customer_id=''合计'',customer_name=''合计'',regionalism_id=null,dept_id=null,clerk_id=null,sum(isnull(oh_sum,0)) oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,order1=1,'
	    +' order2=null,order3=1 from  #temp order by order3,order2,order1'

/*

*/
--print @ssql
    exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytran_sp_ARMaster
return 0
end else
begin
COMMIT TRANSACTION mytran_sp_ARMaster
return 1
end




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

