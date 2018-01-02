
/****** Object:  StoredProcedure [dbo].[sp_ARMaster]    Script Date: 06/27/2016 16:17:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ARMaster]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ARMaster]
GO


/****** Object:  StoredProcedure [dbo].[sp_ARMaster]    Script Date: 06/27/2016 16:17:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- S30001Ӧ������sp_ARMaster
CREATE   PROCEDURE [dbo].[sp_ARMaster]
(
  @com_id  varchar(10),            -- ��Ӫ�̱���@com_id
  @StartDate varchar(30),          -- ��ʼʱ�䣺������Ϊ'1900-01-01'   
  @EndDate   varchar(30),          -- ��ֹʱ�䣺������Ϊ ��ǰ���ñ��洢����ʱ���������˵�ϵͳʱ�䣨��ȷ�� ΢�� convert(varchar(23),aTime,121)  ��
  @Where  varchar(200),            -- ������ѯ�����������������������������Ϊ' and (1=1)  '
  @Zero  char(1),                  -- ��ѯ�������Ƿ���ʾ���=0�ļ�¼��Ĭ�� '0'
  @clerk_id varchar(35),           -- ��ѯ��������������Ա
  @dept_id varchar(60),            -- ��ѯ�������������۲���
  @tjfs int,                       -- ͳ�Ʒ�ʽ��Ĭ�� 0
  @customer_id varchar(50),        -- ��Ҫ��ѯ�����  �ͻ�����
  @settlement_sortID varchar(30)   -- ��Ҫ��ѯ�����  ���㷽ʽ����
)
as
BEGIN TRANSACTION tran_sp_ARMaster
declare
  @SQL varchar(8000),
  @Where1 varchar(150),
  @Where2 varchar(150),
  @Where3 varchar(150),
  @Where4 varchar(1000),
  @ssql varchar(4000),
  @tjfssql varchar(150),
  @tjfssql2 varchar(150)

create table #temp (customer_id varchar(40),customer_name varchar(50),regionalism_id varchar(30),dept_id varchar(30),clerk_id varchar(30),creditSum decimal(28,6),accountPeriod decimal(28,6),
                    oh_sum decimal(28,6),addi_sum  decimal(28,6),rev_sum  decimal(28,6),tax_invoice_sum decimal(28,6),acct_recieve_sum decimal(28,6),balance decimal(28,6) )

-- create table #temp1 (customer_id varchar(40),customer_name varchar(50),dept_id varchar(30),clerk_id varchar(30),creditSum decimal(28,6),accountPeriod decimal(28,6),
--                    oh_sum decimal(28,6),addi_sum  decimal(28,6),rev_sum  decimal(28,6),tax_invoice_sum decimal(28,6),acct_recieve_sum decimal(28,6),creditSum decimal(28,6),accountPeriod decimal(28,6),balance decimal(28,6) )

set @tjfssql=(case @tjfs when 0 then '' when 1 then ',dept_id' when 2 then ',clerk_id' end)
set @tjfssql2=(case @tjfs when 0 then '' when 1 then ',c.dept_id' when 2 then ',c.clerk_id' end)

set @Where3=@Where+' and ltrim(rtrim(isnull(com_id,''''))) = '''+ltrim(rtrim(isnull(@com_id,'')))+''''
if ltrim(rtrim(isnull(@dept_id,'')))<>''
  set @Where3=@Where3+' and ltrim(rtrim(isnull(dept_id,''''))) = '''+ltrim(rtrim(isnull(@dept_id,'')))+''''
if ltrim(rtrim(@clerk_id))<>''
  set @Where3=@Where3+' and ltrim(rtrim(isnull(clerk_id,''''))) ='''+ltrim(rtrim(@clerk_id))+''''
if ltrim(rtrim(@customer_id))<>''
  set @Where3=@Where3+' and ltrim(rtrim(isnull(customer_id,''''))) ='''+ltrim(rtrim(isnull(@customer_id,'')))+''''

set @Where4=' and ltrim(rtrim(isnull(com_id,''''))) = '''+ltrim(rtrim(isnull(@com_id,'')))+''''
if ltrim(rtrim(isnull(@dept_id,'')))<>''
  set @Where4=@Where4+' and ltrim(rtrim(isnull(a.dept_id,''''))) = '''+ltrim(rtrim(isnull(@dept_id,'')))+''''
if ltrim(rtrim(@clerk_id))<>''
  set @Where4=@Where4+' and ltrim(rtrim(isnull(a.clerk_id,''''))) ='''+ltrim(rtrim(@clerk_id))+''''
if ltrim(rtrim(@customer_id))<>''
  set @Where4=@Where4+' and ltrim(rtrim(isnull(a.customer_id,''''))) ='''+ltrim(rtrim(isnull(@customer_id,'')))+''''

set @where1=' D_OPERDATE<'''+ rtrim(ltrim(@StartDate))+''''
set @where2='( D_OPERDATE>='''+ rtrim(ltrim(@StartDate))+''' and  D_OPERDATE<'''+ rtrim(ltrim(@EndDate))+''')'

select @SQL='insert into #temp(customer_id,customer_name,regionalism_id'+@tjfssql+',creditSum,accountPeriod,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,balance )  
     select customer_id,corp_name,regionalism_id'+@tjfssql+',creditSum,accountPeriod,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,balance from (
     select a.customer_id,a.corp_name,a.regionalism_id'+@tjfssql2+',a.creditSum,a.accountPeriod,c.oh_sum,c.addi_sum,c.rev_sum,c.tax_invoice_sum,isnull(c.oh_sum,0)+isnull(c.addi_sum,0)-isnull(c.rev_sum,0)-isnull(c.tax_invoice_sum,0) as acct_recieve_sum,
       isnull(c.oh_sum,0)+isnull(c.addi_sum,0)-isnull(c.rev_sum,0)-isnull(c.tax_invoice_sum,0)-isnull(c.creditSum,0) as balance 
   from SDf00504 a ' 
   +' left join '
  --  +'  full join '

select @SQL=@SQL+'(select customer_id'+@tjfssql+',creditSum=null,accountPeriod=null,sum(isnull(oh_sum,0)) as oh_sum,sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,balance=null from ('
-- ��ʼ����ǰ
  -- Ӧ���ڳ�
select @SQL=@SQL+'
   select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,oh_sum,0 as addi_sum,0 as rev_sum,0 as tax_invoice_sum,null as balance from ARf02030 where isnull(initial_flag,''N'') =''Y'' and com_id='''+@com_id
       +''''+@Where3+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+' 
   union all
	select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,oh_sum,addi_sum,rev_sum,tax_invoice_sum,balance
	from
	(
	   select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,sum_si as oh_sum,0 as addi_sum,0 as rev_sum,0 as tax_invoice_sum,null as balance,isnull(so_consign_date,''1900-01-01 00:00:00.000'') as so_consign_date
	   from View_sdd02020 where (sd_order_direct=''����'' or sd_order_direct=''�ֿ�'')  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y''  and com_id='''+@com_id+''''+@Where3
	   +' and ltrim(rtrim(isnull(shipped,'''')))=''�ѷ���''  and settlement_type_id like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))
       +'%'' '+'    and ( convert(varchar(23),so_consign_date,121) < '''+ isnull(@StartDate,'1900-01-01 00:00:00.000') +''')'
       +'union all
	   select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,-sum_si as oh_sum,0 as addi_sum,0 as rev_sum,0 as tax_invoice_sum,null as balance,isnull(so_consign_date,''1900-01-01 00:00:00.000'') as so_consign_date
	   from View_sdd02020 where sd_order_direct=''�˻�''   and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y''  and com_id='''+@com_id+''''+@Where3+' and settlement_type_id like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))
       +'%'' '+'    and ( convert(varchar(23),so_consign_date,121) < '''+ isnull(@StartDate,'1900-01-01 00:00:00.000') +''')'
       +') a1 '

  -- �ڳ�����
select @SQL=@SQL+'  
   union all
     select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,-sum_si as oh_sum,0,0,0,null as balance 
      from  
       (select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,finacial_d,sum_si,null as balance
       from ARd02051 where recieved_direct=''�տ�''  and recieve_type<>''�˻�����'' and isnull(comfirm_flag,''N'')=''Y''  and com_id='''+@com_id+''''+@Where3+' and rcv_hw_no like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+' 
        union all 
       select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,finacial_d,(sum_si) as sum_si,null as balance
       from ARd02051 where recieved_direct=''�տ�''  and recieve_type=''�˻�����'' and isnull(comfirm_flag,''N'')=''Y''  and com_id='''+@com_id+''''+@Where3+' and rcv_hw_no like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+'   
       ) a2  where  convert(varchar(23),finacial_d,121)  < '''+ isnull(@StartDate,'1900-01-01 00:00:00.000')+'''
   union all
     select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,-tax_invoice_sum as Amount,0,0,0,null as balance 
      from  
       (select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,finacial_d,tax_invoice_sum,null as balance
       from ARfM02010 where c_type=''Ӧ��''  and isnull(initial_flag,''N'') =''Y''  and com_id='''+@com_id+''''+@Where3+' and settlement_type_id like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+'  
       ) a3  where  convert(varchar(23),finacial_d,121) < '''+ isnull(@StartDate,'1900-01-01 00:00:00.000')+''' '
-- ͳ��ʱ���ڷ�����
  -- ����Ӧ��
select @SQL=@SQL+'  
   union all	  
   select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,oh_sum,addi_sum,0,0,null as balance
   from
       (
       select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,0 as oh_sum,sum_si as addi_sum,0 as rev_sum,0 as tax_invoice_sum,null as balance,isnull(so_consign_date,''1900-01-01 00:00:00.000'') as so_consign_date
       from View_sdd02020 where (sd_order_direct=''����'' or sd_order_direct=''�ֿ�'')   and isnull(comfirm_flag,''N'')=''Y''  and com_id='''+@com_id+''''+@Where3
       +'  and ltrim(rtrim(isnull(shipped,'''')))=''�ѷ���''  and ltrim(rtrim(isnull(settlement_type_id,''''))) like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))
       +'%'' '+'    and ( convert(varchar(23),so_consign_date,121) >= '''+ isnull(@StartDate,'1900-01-01 00:00:00.000') +''' and  convert(varchar(23),so_consign_date,121) < '''+ isnull(@EndDate,'1900-01-01 23:59:59.999') +''')'
       +'union all
       select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,0 as oh_sum,-sum_si as addi_sum,0 as rev_sum,0 as tax_invoice_sum,null as balance,isnull(so_consign_date,''1900-01-01 00:00:00.000'') as so_consign_date
       from View_sdd02020 where sd_order_direct=''�˻�''  and isnull(comfirm_flag,''N'')=''Y''  and com_id='''+@com_id+''''+@Where3
       +' and ltrim(rtrim(isnull(settlement_type_id,''''))) like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))
       +'%'' '+'    and ( convert(varchar(23),so_consign_date,121) >= '''+ isnull(@StartDate,'1900-01-01 00:00:00.000') +''' and  convert(varchar(23),so_consign_date,121) < '''+ isnull(@EndDate,'1900-01-01 23:59:59.999') +''')'
       +') a4 '


  -- ��������
select @SQL=@SQL+'  
    union all
    select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,0,0,sum_si as Amount,0,null as balance
    from 
      (select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,finacial_d,sum_si,null as balance
       from ARd02051 where  recieved_direct=''�տ�'' and recieve_type<>''�˻�����'' and isnull(comfirm_flag,''N'')=''Y''  and com_id='''+@com_id+''''+@Where3
       +' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+'    
       union all 
       select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,finacial_d,(sum_si) as sum_si,null as balance
       from ARd02051 where recieved_direct=''�տ�''  and recieve_type=''�˻�����'' and isnull(comfirm_flag,''N'')=''Y''  and com_id='''+@com_id+''''+@Where3
       +' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+' 
       ) a5  where    '+ '( convert(varchar(23),finacial_d,121) >= '''+ isnull(@StartDate,'1900-01-01 00:00:00.000')+''' and  convert(varchar(23),finacial_d,121) < '''+ isnull(@EndDate,'1900-01-01 23:59:59.999') +''')'

  -- ����
select @SQL=@SQL+'
    union all
	select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,0,0,0,tax_invoice_sum as Amount,null as balance 
      from  
       (select customer_id,dept_id,clerk_id,null as creditSum,null as accountPeriod,finacial_d,tax_invoice_sum,null as balance
       from ARfM02010 where c_type=''Ӧ��''  and isnull(initial_flag,''N'') =''Y''  and com_id='''+@com_id+''''+@Where3
       +' and ltrim(rtrim(isnull(settlement_type_id,''''))) like '''+ltrim(rtrim(isnull(@settlement_sortID,'')))+'%'' '+' 
       ) a6  where  ( convert(varchar(23),finacial_d,121) >= '''+ isnull(@StartDate,'1900-01-01 00:00:00.000') +''' and  convert(varchar(23),finacial_d,121) < '''+ isnull(@EndDate,'1900-01-01 23:59:59.999') +''')'

select @SQL=@SQL+') b group by customer_id'+@tjfssql+
		 ') c on a.customer_id=c.customer_id where 1=1 '+@Where4+' ) d '

exec(@SQL)

-- ����Ϊ��������
   if @tjfs=0
   begin
     if @Zero='0'
     begin
	    select  @ssql=' select ltrim(rtrim(isnull(customer_id,''''))) as customer_id, ltrim(rtrim(isnull(customer_name,''''))) as customer_name,regionalism_id,dept_id,clerk_id,isnull(creditSum,0) as creditSum,isnull(accountPeriod,0) as accountPeriod,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,'
            select  @ssql=@ssql+' ( case when isnull(acct_recieve_sum,0)<0 then ( isnull(acct_recieve_sum,0)-isnull(creditSum,0) ) else ( isnull(creditSum,0)-isnull(acct_recieve_sum,0) ) end ) as balance,'
            select  @ssql=@ssql+' order1=0,order2=(customer_id),order3=0 from  #temp '
            select  @ssql=@ssql+' where ltrim(rtrim(isnull(customer_id,'''')))<>''CS1''  '+@Where  +' and isnull(acct_recieve_sum,0.000000)=0.000000 '
            select  @ssql=@ssql+'  union all select customer_id=''�ܼ�'',customer_name=''�ܼ�'',regionalism_id=null,dept_id=null,clerk_id=null,sum(isnull(creditSum,0)) as creditSum,accountPeriod=null,sum(isnull(oh_sum,0)) oh_sum,'
            select  @ssql=@ssql+' sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0.000000)) acct_recieve_sum,'
            select  @ssql=@ssql+' ( sum(isnull(acct_recieve_sum,0))-sum(isnull(creditSum,0)) ) as balance,'
            select  @ssql=@ssql+'  order1=1,order2=null,order3=1 from  #temp '   
            +' where isnull(acct_recieve_sum,0.000000)=0.000000  '
        select @ssql=@ssql+' order by ltrim(rtrim(isnull(customer_name,''''))),order3,order2 asc,order1 '
        exec(@ssql)
     end else
     if @Zero='1'
     begin
	    select  @ssql=' select ltrim(rtrim(isnull(customer_id,''''))) as customer_id,ltrim(rtrim(isnull(customer_name,''''))) as customer_name,regionalism_id,dept_id,clerk_id,isnull(creditSum,0) as creditSum,isnull(accountPeriod,0) as accountPeriod,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,'
            select  @ssql=@ssql+' ( case when isnull(acct_recieve_sum,0)<0 then ( isnull(acct_recieve_sum,0)-isnull(creditSum,0) ) else ( isnull(creditSum,0)-isnull(acct_recieve_sum,0) ) end ) as balance,'
            select  @ssql=@ssql+' order1=0,order2=(customer_id),order3=0 from  #temp '
            select  @ssql=@ssql+' where ltrim(rtrim(isnull(customer_id,'''')))<>''CS1''  '+@Where +' and not isnull(acct_recieve_sum,0.000000)=0.000000 '
            select  @ssql=@ssql+'  union all select customer_id=''�ܼ�'',customer_name=''�ܼ�'',regionalism_id=null,dept_id=null,clerk_id=null,sum(isnull(creditSum,0)) as creditSum,accountPeriod=null,sum(isnull(oh_sum,0)) oh_sum,'
            select  @ssql=@ssql+' sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,'
            select  @ssql=@ssql+' ( sum(isnull(acct_recieve_sum,0))-sum(isnull(creditSum,0)) ) as balance,'
            select  @ssql=@ssql+'  order1=1,order2=null,order3=1 from  #temp   '
            +' where not isnull(acct_recieve_sum,0.000000)=0.000000  '            
        select @ssql=@ssql+' order by ltrim(rtrim(isnull(customer_name,''''))),order3,order2 asc,order1 '
        exec(@ssql)
     end else
     begin
	    select  @ssql=' select ltrim(rtrim(isnull(customer_id,''''))) as customer_id,ltrim(rtrim(isnull(customer_name,''''))) as customer_name,regionalism_id,dept_id,clerk_id,isnull(creditSum,0) as creditSum,isnull(accountPeriod,0) as accountPeriod,oh_sum,addi_sum,rev_sum,tax_invoice_sum,acct_recieve_sum,'
            select  @ssql=@ssql+' ( case when isnull(acct_recieve_sum,0)<0 then ( isnull(acct_recieve_sum,0)-isnull(creditSum,0) ) else ( isnull(creditSum,0)-isnull(acct_recieve_sum,0) ) end ) as balance,'
            select  @ssql=@ssql+' order1=0,order2=(customer_id),order3=0 from  #temp '
            select  @ssql=@ssql+' where ltrim(rtrim(isnull(customer_id,'''')))<>''CS1''  '+@Where
            select  @ssql=@ssql+'  union all select customer_id=''�ܼ�'',customer_name=''�ܼ�'',regionalism_id=null,dept_id=null,clerk_id=null,sum(isnull(creditSum,0)) as creditSum,accountPeriod=null,sum(isnull(oh_sum,0)) oh_sum,'
            select  @ssql=@ssql+' sum(isnull(addi_sum,0)) addi_sum,sum(isnull(rev_sum,0)) rev_sum,sum(isnull(tax_invoice_sum,0)) tax_invoice_sum,sum(isnull(acct_recieve_sum,0)) acct_recieve_sum,'
            select  @ssql=@ssql+' ( sum(isnull(acct_recieve_sum,0))-sum(isnull(creditSum,0)) ) as balance,'
            select  @ssql=@ssql+'  order1=1,order2=null,order3=1 from  #temp   '           
        select @ssql=@ssql+' order by ltrim(rtrim(isnull(customer_name,''''))),order3,order2 asc,order1 '
        exec(@ssql)
     end           
   end

IF @@ERROR <> 0 
begin
  ROLLBACK TRANSACTION tran_sp_ARMaster
  return 0
end else
begin
  COMMIT TRANSACTION tran_sp_ARMaster
  return 1
end


GO


