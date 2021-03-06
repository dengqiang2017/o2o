if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_CashQuery]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_CashQuery]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--现金银行汇总
CREATE     PROCEDURE SP_CashQuery
     ( @com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @dept_id  varchar(30),
       @billNO  varchar(30),
       @get_dept varchar(8000),
       @get_store varchar(8000)  
     )       
AS 
BEGIN TRANSACTION mytran_SP_CashQuery 
  declare @text3 varchar(8000),@ssql varchar(8000),@account_id char(30),@add_oq decimal(22,2),@del_oq decimal(22,2)

     create table #temp (com_id char(10),account_id char(30),oh_oq decimal(22,2),add_oq decimal(22,2),
     del_oq decimal(22,2),end_oq decimal(22,2),dept_id varchar(30),clerk_id varchar(35),billNO  varchar(30)  )

     create table #temp1 (com_id char(10),account_id char(30),oh_oq decimal(22,2),add_oq decimal(22,2),
     del_oq decimal(22,2),end_oq decimal(22,2),dept_id varchar(30),clerk_id varchar(35),billNO  varchar(30)  )

     create table #temp2 (com_id char(10),account_id char(30),oh_oq decimal(22,2),add_oq decimal(22,2),
     del_oq decimal(22,2),end_oq decimal(22,2),dept_id varchar(30),clerk_id varchar(35),billNO  varchar(30)  )

  select @text3=''
--开始：部门权限
  if ltrim(rtrim(@get_dept))<>''
     select @text3=@text3+' and '+ltrim(rtrim(@get_dept))+' '
--结束：部门权限

/*   --查询条件放入各单据的select中
  select @text3=''
  if ltrim(rtrim(isnull(@dept_id,'''')))<>'' 
    select @text3=@text3+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'')))+'%'' '
  if ltrim(rtrim(isnull(@billNO,'')))<>'' 
    select @text3=@text3+' and ltrim(rtrim(isnull(billNO,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
*/
  select @ssql=''                               
  select @ssql='insert into #temp1 select com_id,sort_id,isnull(I_Amount,0) as oh_oq,0,0,'
   +' isnull(I_Amount,0) as end_oq,ltrim(rtrim(isnull(dept_id,''''))) as dept_id,'''' as clerk_id,sort_id as billNO from Ctl02107  where  com_id='''+@com_id+''' '
   +' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'')))+'%'' '+' and ltrim(rtrim(isnull(sort_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)  
/*-------------------------------------------小于@star_date的金额数----------------------------------------------------*/
  select  @ssql=''/*采购付款*/
  select  @ssql='insert into #temp1 select com_id,rejg_hw_no,0,0,isnull(type_sum,0),0,dept_id,clerk_id,rejg_hw_no as billNO from ARd02051 where '
  +' recieved_direct=''付款'' and  com_id='+''''+ rtrim(ltrim(@com_id))+''' and comfirm_flag=''Y'''
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'')))+'%'' '+' and ltrim(rtrim(isnull(rejg_hw_no,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*销售收款*/
  select  @ssql='insert into #temp1 select com_id,rcv_hw_no,0,isnull(type_sum,0),0,0,dept_id,clerk_id,rcv_hw_no as billNO from ARd02051 where '
  +' recieved_direct=''收款'' and  com_id='+''''+ rtrim(ltrim(@com_id))+''' and comfirm_flag=''Y'' '
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*费用报销*/
  select  @ssql='insert into #temp1 select com_id,billNO,0,0,isnull(sum_si,0),0,dept_id,clerk_id,billNO as billNO from SDDM03001 where '
  +'  com_id='+''''+ rtrim(ltrim(@com_id))+''' and  bill_source=''费用报销'' '
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(billNO,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*客户让利*/
  select  @ssql='insert into #temp1 select com_id,unit_id,0,0,isnull(rep_qty,0),0,dept_id,clerk_id,unit_id as billNO from View_STDM01001 where '
  +'  com_id='+''''+ rtrim(ltrim(@com_id))+''' and  st_hw_no=''客户'' and comfirm_flag=''Y'' '
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(unit_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*供应商返利*/
  select  @ssql='insert into #temp1 select com_id,unit_id,0,isnull(rep_qty,0),0,0,dept_id,clerk_id,unit_id as billNO from View_STDM01001 where '
  +'  com_id='+''''+ rtrim(ltrim(@com_id))+''' and  st_hw_no=''供货''  and comfirm_flag=''Y'' '
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(unit_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*银行存取收入*/
  select  @ssql='insert into #temp1 select com_id,inaccount_id,0,isnull(account_Amount,0),0,0,dept_id,clerk_id,inaccount_id as billNO from '
  +' Ctl04090 where com_id='+''''+ rtrim(ltrim(@com_id))+''' '
  select @ssql=@ssql+' and  cash_date<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(inaccount_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*银行存取支出*/
  select  @ssql='insert into #temp1 select com_id,account_id,0,0,isnull(account_Amount,0),0,dept_id,clerk_id,account_id as billNO  from '
  +' Ctl04090 where com_id='+''''+ rtrim(ltrim(@com_id))+''' '
  select @ssql=@ssql+' and  cash_date<'''+ rtrim(ltrim(@star_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(account_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select @ssql=''
  select @ssql=' insert into #temp2 select com_id,account_id,sum(oh_oq)+sum(add_oq)-sum(del_oq)  as oh_oq,0 as add_oq,'
  +'0 as del_oq,0  as end_oq,'''' as dept_id,'''' as clerk_id,'''' as billNO from #temp1 group by  com_id,account_id '
  exec(@ssql)
/*-------------------------------------------小于@star_date的金额数----------------------------------------------------*/
  select  @ssql=''/*采购付款*/
  select  @ssql='insert into #temp2 select com_id,rejg_hw_no,0,0,isnull(type_sum,0),0,dept_id,clerk_id,rejg_hw_no as billNO from ARd02051 where '
  +' recieved_direct=''付款'' and  com_id='+''''+ rtrim(ltrim(@com_id))+''' and comfirm_flag=''Y'' and recieve_type<>''退货收款'''
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(rejg_hw_no,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*采购付款   退货收款*/
  select  @ssql='insert into #temp2 select com_id,rejg_hw_no,0,isnull(sum_si,0),0,0,dept_id,clerk_id,rejg_hw_no as billNO from ARd02051 where '
  +' recieved_direct=''付款'' and  com_id='+''''+ rtrim(ltrim(@com_id))+''' and comfirm_flag=''Y'' and recieve_type=''退货收款'''
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(rejg_hw_no,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*销售收款*/
  select  @ssql='insert into #temp2 select com_id,rcv_hw_no,0,isnull(type_sum,0),0,0,dept_id,clerk_id,rcv_hw_no as billNO from ARd02051 where '
  +' recieved_direct=''收款'' and  com_id='+''''+ rtrim(ltrim(@com_id))+''' and comfirm_flag=''Y'' and  recieve_type<>''退货付款'''
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*销售收款  退货付款*/
  select  @ssql='insert into #temp2 select com_id,rcv_hw_no,0,0,isnull(sum_si,0),0,dept_id,clerk_id,rcv_hw_no as billNO from ARd02051 where '
  +' recieved_direct=''收款'' and  com_id='+''''+ rtrim(ltrim(@com_id))+''' and comfirm_flag=''Y'' and  recieve_type=''退货付款'''
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*费用报销*/
  select  @ssql='insert into #temp2 select com_id,billNO,0,0,isnull(sum_si,0),0,dept_id,clerk_id,billNO from SDDM03001 where '
  +'  com_id='+''''+ rtrim(ltrim(@com_id))+'''  and  bill_source=''费用报销'' '
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(billNO,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*客户让利*/
  select  @ssql='insert into #temp2 select com_id,unit_id,0,0,isnull(rep_qty,0),0,dept_id,clerk_id,unit_id as billNO from View_STDM01001 where '
  +'  com_id='+''''+ rtrim(ltrim(@com_id))+''' and  st_hw_no=''客户''  and comfirm_flag=''Y'' '
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(unit_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*供应商返利*/
  select  @ssql='insert into #temp2 select com_id,unit_id,0,isnull(rep_qty,0),0,0,dept_id,clerk_id,unit_id as billNO from View_STDM01001 where '
  +'  com_id='+''''+ rtrim(ltrim(@com_id))+''' and  st_hw_no=''供货''  and comfirm_flag=''Y'' '
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(unit_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*银行存取收入*/
  select  @ssql='insert into #temp2 select com_id,inaccount_id,0,isnull(account_Amount,0),0,0,dept_id,clerk_id,inaccount_id as billNO from '
  +' Ctl04090 where com_id='+''''+ rtrim(ltrim(@com_id))+''' '
  select @ssql=@ssql+' and  cash_date>='''+ rtrim(ltrim(@star_date))+''' and  cash_date<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(inaccount_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select  @ssql=''/*银行存取支出*/
  select  @ssql='insert into #temp2 select com_id,account_id,0,0,isnull(account_Amount,0),0,dept_id,clerk_id,account_id as billNO from '
  +' Ctl04090 where com_id='+''''+ rtrim(ltrim(@com_id))+''' '
  select @ssql=@ssql+' and  cash_date>='''+ rtrim(ltrim(@star_date))+''' and  cash_date<='''+rtrim(ltrim(@end_date))+''' '+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'''')))+'%'' '+' and ltrim(rtrim(isnull(account_id,''''))) like '''+ltrim(rtrim(isnull(@billNO,'')))+'%'' '
  select @ssql=@ssql+@text3 
  exec(@ssql)

  select @ssql=''
  select @ssql=' select com_id,account_id,sum(oh_oq) as oh_oq,sum(add_oq) as add_oq,sum(del_oq) as del_oq,'
  +'(sum(oh_oq)+sum(add_oq)-sum(del_oq)) as end_oq,'''' as dept_id,'''' as clerk_id,'''' as billNO,order1=0  from #temp2  group by  com_id,account_id  '
  +'union all select com_id=null,account_id=''合计'',sum(oh_oq) as oh_oq,sum(add_oq) as add_oq,sum(del_oq) as del_oq,'
  +'(sum(oh_oq)+sum(add_oq)-sum(del_oq)) as end_oq,'''' as dept_id,'''' as clerk_id,'''' as billNO,order1=1 from #temp2  group by com_id order by order1,account_id desc'
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytran_SP_CashQuery
return 0
end else
begin
COMMIT TRANSACTION mytran_SP_CashQuery
return 1
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

