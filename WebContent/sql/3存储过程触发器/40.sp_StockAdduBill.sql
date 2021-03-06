if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_StockAdduBill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockAdduBill]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--应付明细账：应付单据流水帐
CREATE    PROCEDURE sp_StockAdduBill
       (@com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @vendor_id varchar(30),
       @dept_id varchar(30),
       @clerk_id varchar(35),
       @dept_right varchar(8000))
AS 
BEGIN TRANSACTION mytran_Sp_StockAdduBill 
    declare @text3 varchar(8000),@ssql varchar(8000),@ivt_oper_listing1 varchar(30),@accept_sum1 decimal(17,6),
    @allaccept_sum1 decimal(17,6),@surplus_sum1 decimal(17,6),@com_id1 char(10),
    @openbill_date1 datetime,@surplus_sum12 decimal(17,6),@openbill_type1 char(10),@baddebt_sum1 decimal(17,6),
    @vendor_id1 varchar(30),@sd_order_id1 varchar(30),@c_type1 char(10),@seeds_id1 varchar(30)

     create table #temp (com_id char(10),ivt_oper_listing varchar(30),sd_order_id varchar(30),openbill_date datetime,
     openbill_type char(10),vendor_id varchar(30),c_memo varchar(100),accept_sum decimal(17,6),allaccept_sum decimal(17,6),
     baddebt_sum decimal(17,6),surplus_sum decimal(17,6),sid int,maintenance_datetime datetime,c_type char(10),seeds_id varchar(30))

     create table #temp1 (com_id char(10),ivt_oper_listing varchar(30),sd_order_id varchar(30),openbill_date datetime,
     openbill_type char(10),vendor_id varchar(30),c_memo varchar(100),accept_sum decimal(17,6),allaccept_sum decimal(17,6),
     baddebt_sum decimal(17,6),surplus_sum decimal(17,6),sid int,maintenance_datetime datetime,c_type char(10),seeds_id varchar(30))

     create table #temp2 (com_id char(10),ivt_oper_listing varchar(30),sd_order_id varchar(30),openbill_date datetime,
     openbill_type char(10),vendor_id varchar(30),c_memo varchar(100),accept_sum decimal(17,2),allaccept_sum decimal(17,2),
     baddebt_sum decimal(17,2),surplus_sum decimal(17,2),sid int,maintenance_datetime datetime,c_type char(10),seeds_id varchar(30))

  select @text3=''
  select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and dept_id like  '''+ltrim(rtrim(@dept_id))+'%'''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and clerk_id='''+ltrim(rtrim(@clerk_id))+''''

  select @text3=+' and  '+ltrim(rtrim(@dept_right))+' '

  select @ssql=''/*应付初始化*/
  select  @ssql='insert into #temp select com_id,''上期结余'' as ivt_oper_listing,''上期结余'' as sd_order_id,'''' as openbill_date,'
  +'''期初金额'',vendor_id,'''',0 as accept_sum,0 as allaccept_sum,0 as baddebt_sum,sum(beg_sum) as surplus_sum,0 as sid,'
  +''''',''期初金额'',0  from stfM0201 where  (1=1)  and isnull(beg_sum,0)<>0' +@text3
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and initial_flag=''Y'''
   select @ssql= @ssql+' group by com_id,vendor_id'
  exec(@ssql)
   /*小于开始日期@star_date1*/
  select @ssql=''/*进货开单*/
  select  @ssql='insert into #temp select com_id,rcv_auto_no,rcv_hw_no,store_date,'
  +'(case  when isnull(rej_flag,'''')=''1'' then  ''挂帐采购'' else ''现款采购'' end) as openbill_type ,vendor_id,'
  +'c_memo,st_sum,(case  when isnull(rej_flag,'''')=''1'' then isnull(pay_sum,0) else st_sum end) as allaccept_sum,0 as baddebt_sum,0,1,'
  +'mainten_datetime,stock_type,rcv_auto_no  from STDM03001 where (stock_type=''借货'' or stock_type=''进货'') ' +@text3
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''/*进货退货*/
  select  @ssql='insert into #temp select com_id,rcv_auto_no,rcv_hw_no,store_date,''采购退货'',vendor_id,c_memo,'
  +'-st_sum,0,0 as baddebt_sum,0,1,mainten_datetime,stock_type,rcv_auto_no  from STDM03001 where stock_type=''退货''' +@text3
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''/*采购付款*/
  select  @ssql='insert into #temp select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
  +'customer_id,c_memo,0,type_sum,0 as baddebt_sum,0,1,mainten_datetime,recieved_direct,seeds_id  '
  +'from ARd02051 where recieved_direct=''付款''  and  isnull(if_send,''0'')<>''1'' ' +@text3
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''/*呆坏帐处理*/
  select  @ssql='insert into #temp select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''应付呆坏帐'' as openbill_type,customer_id,'
  +'c_memo,0,0,tax_invoice_sum,0,0,mainten_datetime,''呆坏帐'' as c_type,seeds_id  from ARfM02010 where c_type=''应付'''+@text3
  select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@vendor_id))+''''
  select @ssql= @ssql+'  and initial_flag=''Y'''
  exec(@ssql)

  select @ssql=''  --委托加工
  select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,send_date,'
  +' ''委托加工'' as openbill_type,vendor_id,'
  +' '''' as c_memo,isnull(lead_oq,0)*isnull(oper_price_Fee,0) as accept_sum,0 as allaccept_sum,0 as baddebt_sum,0,0,'
  +'mainten_datetime,''委托加工'' as stock_type,seeds_idYie05011  from VIEW_Yie05010 where 1=1 ' +@text3
  select @ssql=@ssql+' and  send_date<'''+ rtrim(ltrim(@star_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and isnull(comfirm_flag,''N'')=''Y'''
  exec(@ssql)

  declare mycur  CURSOR FOR 
        select a.com_id,a.ivt_oper_listing,a.sd_order_id,a.openbill_date,a.openbill_type,a.vendor_id,
        isnull(a.accept_sum,0),isnull(a.allaccept_sum,0),isnull(a.baddebt_sum,0),isnull(a.surplus_sum,0),a.c_type
    from #temp a   order by vendor_id,sid,openbill_date,maintenance_datetime

  OPEN mycur
    FETCH NEXT FROM mycur 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@vendor_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1
  WHILE @@FETCH_STATUS = 0
  begin
    
    select @ivt_oper_listing1=ivt_oper_listing  from #temp1   where com_id=@com_id and vendor_id=@vendor_id1 
    if @@rowcount=0 
    begin
      insert into  #temp1(com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,vendor_id,
      c_memo,accept_sum,allaccept_sum,baddebt_sum,surplus_sum,sid,c_type,seeds_id) values(@com_id1,'上期结余','上期结余','','期初金额',
      @vendor_id1,'',@accept_sum1,@allaccept_sum1,@baddebt_sum1,
      isnull(@surplus_sum1,0)+isnull(@accept_sum1,0)-isnull(@allaccept_sum1,0)-isnull(@baddebt_sum1,0),0,'期初金额','0')            
    end  else begin
      update #temp1 set surplus_sum=isnull(surplus_sum,0)+@accept_sum1-@allaccept_sum1-@baddebt_sum1,openbill_date=@star_date
      from #temp1  where com_id=@com_id  and vendor_id=@vendor_id1 /*allaccept_sum已收 ，accept_sum应收*/
    end
    FETCH NEXT FROM mycur 
      INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@vendor_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1
    end
  CLOSE mycur       
  DEALLOCATE mycur

  insert into  #temp2(com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,vendor_id,
  c_memo,accept_sum,allaccept_sum,baddebt_sum,surplus_sum,sid,c_type,seeds_id)  select com_id,ivt_oper_listing,sd_order_id,
  openbill_date,openbill_type,vendor_id,c_memo,0,0,0,surplus_sum,sid,c_type,seeds_id from #temp1 
/*小于开始日期@star_date1*/
  select @ssql=''/*进货开单*/
  select  @ssql='insert into #temp2 select com_id,rcv_auto_no,rcv_hw_no,store_date,'
  +' (case  when isnull(rej_flag,'''')=''1'' then  ''挂帐采购'' else ''现款采购'' end) as rej_flag,vendor_id,'
  +'c_memo,st_sum,(case  when isnull(rej_flag,'''')=''1'' then  isnull(pay_sum,0) else st_sum end) as allaccept_sum,0,'
  +'0,1,mainten_datetime,stock_type,rcv_auto_no  from STDM03001 where (stock_type=''借货'' or stock_type=''进货'') ' +@text3
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date))
    +''' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''/*进货退货*/
  select  @ssql='insert into #temp2 select com_id,rcv_auto_no,rcv_hw_no,store_date,''采购退货'',vendor_id,'
  +'c_memo,-st_sum,0,0,0,1,mainten_datetime,stock_type,rcv_auto_no  from STDM03001 where stock_type=''退货''' +@text3
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date))
    +''' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''/*采购付款*/
  select  @ssql='insert into #temp2 select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,customer_id,'
  +'c_memo,0,type_sum,0,0,1,mainten_datetime,recieved_direct,seeds_id from ARd02051 where '
  +' recieved_direct=''付款''  and isnull(if_send,''0'')<>''1'' ' +@text3
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))
    +''' and  finacial_d<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''/*呆坏帐处理*/
  select  @ssql='insert into #temp2 select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''应付呆坏帐'' as openbill_type,customer_id,'
  +'c_memo,0,0,tax_invoice_sum,0,0,mainten_datetime,''呆坏帐'' as c_type,seeds_id  from ARfM02010 where c_type=''应付'''+@text3
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))+''' and  finacial_d<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@vendor_id))+''''
  select @ssql= @ssql+'  and initial_flag=''Y'''
  exec(@ssql)

  select @ssql=''  --委托加工
  select  @ssql='insert into #temp2 select com_id,ivt_oper_listing,sd_order_id,send_date,'
  +' ''委托加工'' as openbill_type,vendor_id,'
  +' '''' as c_memo,isnull(lead_oq,0)*isnull(oper_price_Fee,0) as accept_sum,0 as allaccept_sum,0 as baddebt_sum,0,0,'
  +'mainten_datetime,''委托加工'' as stock_type,seeds_idYie05011  from VIEW_Yie05010 where 1=1 ' +@text3
  select @ssql=@ssql+' and  send_date>='''+ rtrim(ltrim(@star_date))
    +''' and  send_date<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@vendor_id))<>'' 
   select @ssql=@ssql+' and vendor_id='''+ltrim(rtrim(@vendor_id))+''''
   select @ssql= @ssql+'  and isnull(comfirm_flag,''N'')=''Y'''
  exec(@ssql)
  
  declare mycur1  CURSOR FOR 
        select a.com_id,a.ivt_oper_listing,a.sd_order_id,a.openbill_date,a.openbill_type,a.vendor_id,
        isnull(a.accept_sum,0),isnull(a.allaccept_sum,0),isnull(a.baddebt_sum,0),isnull(a.surplus_sum,0),a.c_type,a.seeds_id
    from #temp2 a   order by vendor_id,openbill_date,maintenance_datetime,sid 
  OPEN mycur1
    FETCH NEXT FROM mycur1 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@vendor_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1,@seeds_id1
  select @surplus_sum12=@surplus_sum1
  WHILE @@FETCH_STATUS = 0
  begin
     update #temp2 set surplus_sum=@surplus_sum12+@accept_sum1-@allaccept_sum1-@baddebt_sum1 from #temp2 
     where com_id=@com_id and ivt_oper_listing=@ivt_oper_listing1 and vendor_id=@vendor_id1 and c_type=@c_type1 and seeds_id=@seeds_id1 

     select @surplus_sum12=isnull(surplus_sum,0)  from #temp2 where com_id=@com_id 
     and ivt_oper_listing=@ivt_oper_listing1 and vendor_id=@vendor_id1  and c_type=@c_type1 and seeds_id=@seeds_id1 
  
    FETCH NEXT FROM mycur1 
      INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@vendor_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1,@seeds_id1
  end
  CLOSE mycur1       
  DEALLOCATE mycur1 

  select @ssql=''
  select  @ssql='select  *  from #temp2 order by vendor_id,openbill_date,maintenance_datetime,sid'
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytran_Sp_StockAdduBill
return 0
end else
begin
COMMIT TRANSACTION mytran_Sp_StockAdduBill
return 1
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

