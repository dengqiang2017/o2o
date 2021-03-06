if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SellAdduBill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SellAdduBill]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--应收帐款-单据
CREATE         PROCEDURE sp_SellAdduBill
     ( @com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @customer_id varchar(100),
       @dept_id varchar(100),
       @clerk_id varchar(10),
       @dept_right varchar(8000),
       @settlement_sortID varchar(100) )
AS 
BEGIN TRANSACTION mytran_Sp_SellAdduBill
    declare @text3 varchar(8000),@ssql varchar(8000),@ivt_oper_listing1 varchar(30),@accept_sum1 decimal(22,6),
    @allaccept_sum1 decimal(22,6),@surplus_sum1 decimal(22,6),@com_id1 char(10),@baddebt_sum1 decimal(22,6),
    @openbill_date1 datetime,@month_date1 tinyint,@surplus_sum12 decimal(22,6),@openbill_type1 char(40),
    @customer_id1 varchar(100),@sd_order_id1 varchar(30),@c_type1 char(300),@seeds_id1 varchar(30),@settlement_sortID1 varchar(100)

    create table #temp (com_id char(10),ivt_oper_listing varchar(30),sd_order_id varchar(30),openbill_date datetime,
    openbill_type char(20),customer_id varchar(100),accept_sum decimal(22,6),beizhu varchar(300),allaccept_sum decimal(22,6),
    baddebt_sum decimal(22,6),
    surplus_sum decimal(22,6),sid int,maintenance_datetime datetime,c_type char(20),seeds_id varchar(30),send_qty decimal(22,6),settlement_sortID varchar(100) )

    create table #temp1 (com_id char(10),ivt_oper_listing varchar(30),sd_order_id varchar(30),openbill_date datetime,
    openbill_type char(20),customer_id varchar(100),accept_sum decimal(22,6),beizhu varchar(300),allaccept_sum decimal(22,6),
    baddebt_sum decimal(22,6),
    surplus_sum decimal(22,6),sid int,maintenance_datetime datetime,c_type char(20),seeds_id varchar(30),send_qty decimal(22,6),settlement_sortID varchar(100) )

    create table #temp3 (com_id char(10),ivt_oper_listing varchar(30),sd_order_id varchar(30),openbill_date datetime,
    openbill_type char(20),customer_id varchar(100),accept_sum decimal(22,6),beizhu varchar(300),allaccept_sum decimal(22,6),
    baddebt_sum decimal(22,6),
    surplus_sum decimal(22,6),sid int,maintenance_datetime datetime,c_type char(20),seeds_id varchar(30),send_qty decimal(22,6),settlement_sortID varchar(100) )

  select @text3=''--seeds_id记录表中的不重复ID或单据号  和sid区分初始记录的
  select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id))+''''
  if ltrim(rtrim(@customer_id))<>'' 
   select @text3=@text3+' and customer_id='''+ltrim(rtrim(@customer_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and dept_id like '''+ltrim(rtrim(@dept_id))+'%'''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and clerk_id='''+ltrim(rtrim(@clerk_id))+''''
 
  select @text3=@text3+' and  '+@dept_right+' '

    select @ssql=''--应收帐初始化
    select  @ssql='insert into #temp select com_id,''上期结余'' as ivt_oper_listing,''上期结余'' as sd_order_id,'''' as openbill_date,'
    +'''期初金额'' as openbill_type,customer_id,0 as accept_sum,'''',0 as allaccept_sum,0,sum(oh_sum) as surplus_sum,0 as sid,'
    +''''',''初始'',0,0,''初始'' as settlement_sortID from  ARf02030  where com_id='''+ rtrim(ltrim(@com_id))+''' and isnull(oh_sum,0)<>0'
    if ltrim(rtrim(@customer_id))<>'' 
    select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@customer_id))+''''
    select @ssql= @ssql+'  and initial_flag=''Y'''
    select @ssql= @ssql+'  group by com_id,customer_id'
    exec(@ssql)
--小于开始日期@star_date1
    select @ssql=''--销售开单
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +' (case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as openbill_type ,customer_id,'
    +'sum_si,'''',(case  when sd_order_direct=''现款'' then  sum_si else youhui_sum  end) as allaccept_sum,0,0,1,mainten_datetime,'
    +'sd_order_direct,ivt_oper_listing,0,settlement_type_id as settlement_sortID  from SDd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3
    select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--销售优惠
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +' (case  when sd_order_direct=''现款'' then  ''现款优惠'' else ''挂帐优惠'' end) as openbill_type ,customer_id,'
    +'-i_agiosum,'''',0 as allaccept_sum,0,0,1,mainten_datetime,'
    +'''销售优惠'',ivt_oper_listing,0,settlement_type_id as settlement_sortID  from SDd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3
    select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date))+''' and isnull(i_agiosum,0)<>0 '
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--销售收款
    select  @ssql='insert into #temp select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
    +'customer_id,0,'''',type_sum,0,0,1,mainten_datetime,recieved_direct,seeds_id,0,rcv_hw_no as settlement_sortID  from ARd02051 '
    +'where recieved_direct=''收款'' and isnull(if_send,''0'')<>''1'' ' +@text3  --应收，不要现款
    select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--销售退货
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,''销售退货'',customer_id,'
    +'-sum_si,'''',0,0,0,1,mainten_datetime,sd_order_direct,ivt_oper_listing,0,settlement_type_id as settlement_sortID   from SDd02020 where sd_order_direct=''退货'''+@text3
    select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

     select @ssql=''--呆坏帐处理
    select  @ssql='insert into #temp select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''应收呆坏帐'' as openbill_type,customer_id,'
    +'0,'''',0,tax_invoice_sum,0,1,mainten_datetime,''呆坏帐'' as c_type,seeds_id,0,settlement_type_id as settlement_sortID   from ARfM02010 where c_type=''应收'''+@text3
    select @ssql=@ssql+' and  finacial_d<'''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and initial_flag=''Y'''
    exec(@ssql)
 
  declare mycur  CURSOR FOR 
        select a.com_id,a.ivt_oper_listing,a.sd_order_id,a.openbill_date,a.openbill_type,a.customer_id,
        isnull(a.accept_sum,0),isnull(a.allaccept_sum,0),isnull(a.baddebt_sum,0),isnull(a.surplus_sum,0),a.c_type,a.seeds_id,a.settlement_sortID
    from #temp a   order by customer_id,sid,openbill_date,maintenance_datetime
  OPEN mycur
    FETCH NEXT FROM mycur 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1,@seeds_id1,@settlement_sortID1
  WHILE @@FETCH_STATUS = 0
  begin
    
    select @ivt_oper_listing1=ivt_oper_listing  from #temp1   where com_id=@com_id and customer_id=@customer_id1 
    if @@rowcount=0 
    begin
      insert into  #temp1(com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,customer_id,
      accept_sum,beizhu,allaccept_sum,baddebt_sum,surplus_sum,sid,c_type,seeds_id,settlement_sortID) 
      values(@com_id1,'上期结余','上期结余','','期初金额',@customer_id1,@accept_sum1,'',@allaccept_sum1,@baddebt_sum1,
      isnull(@surplus_sum1,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0),0,'期初','0',@settlement_sortID1)            
    end  else begin
      update #temp1 set surplus_sum=isnull(surplus_sum,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0),
      openbill_date=@star_date   from #temp1  where com_id=@com_id  and customer_id=@customer_id1  
    end    -- allaccept_sum已收 ，accept_sum应收 and c_type=@c_type1 and seeds_id=@seeds_id1一个客户只有一条记录    
    FETCH NEXT FROM mycur 
      INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1,@seeds_id1,@settlement_sortID1
    end
  CLOSE mycur       
  DEALLOCATE mycur


  insert into  #temp3(com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,customer_id,accept_sum,beizhu,
                      allaccept_sum,baddebt_sum,surplus_sum,sid,c_type,seeds_id,send_qty,settlement_sortID)
  select com_id,ivt_oper_listing,sd_order_id,
  openbill_date,openbill_type,customer_id,0,'',0,0,surplus_sum,sid,c_type,seeds_id,send_qty,isnull(settlement_sortID,'')
  from #temp1
--  select com_id,'' as ivt_oper_listing,'' as sd_order_id,
--  '' as openbill_date,'' as openbill_type,customer_id,0,'',0,0,sum(isnull(surplus_sum,0)),'' as sid,'期初' as c_type,'' as seeds_id,0 as send_qty,isnull(settlement_sortID,'')
--  from #temp1 group by com_id,customer_id,isnull(settlement_sortID,'')
--开始:小于开始日期@star_date1 大于结束日期
    select @ssql=''--销售开单
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +'(case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as openbill_type ,customer_id,'
    +'sum_si,c_memo,(case  when sd_order_direct=''现款'' then  sum_si else youhui_sum  end) as allaccept_sum,0,0,'
    +'1,mainten_datetime,sd_order_direct,ivt_oper_listing,0,settlement_type_id as settlement_sortID  from sdd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3
    select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date))
      +''' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--销售优惠
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +'(case  when sd_order_direct=''现款'' then  ''现款优惠'' else ''挂帐优惠'' end) as openbill_type ,customer_id,'
    +'-i_agiosum,c_memo,0 as allaccept_sum,0,0,1,mainten_datetime,''销售优惠'',ivt_oper_listing,0,settlement_type_id as settlement_sortID from sdd02020 '
    +'where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3
    select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date))
      +''' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+'''   and isnull(i_agiosum,0)<>0  '
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--销售收款
    select  @ssql='insert into #temp3 select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
    +' customer_id,0,'''',type_sum,0,0,1,mainten_datetime,recieved_direct,seeds_id,0,rcv_hw_no as settlement_sortID  '
    +' from ARd02051 where recieved_direct=''收款'' and isnull(if_send,''0'')<>''1''  ' +@text3
    select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))
    +''' and  finacial_d<='''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--销售退货
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,''销售退货'','
    +'customer_id,-sum_si,c_memo,0,0,0,1,mainten_datetime,'
    +'sd_order_direct,ivt_oper_listing,0,settlement_type_id as settlement_sortID  from sdd02020 where sd_order_direct=''退货'' ' +@text3
    select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date))
    +''' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)

    select @ssql=''--呆坏帐处理
    select  @ssql='insert into #temp3 select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''应收呆坏帐'' as openbill_type,customer_id,'
    +'0,'''',0,tax_invoice_sum,0,1,mainten_datetime,''呆坏帐'' as c_type,seeds_id,0,settlement_type_id as settlement_sortID   from ARfM02010 where c_type=''应收'' '+@text3
    select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date))
    +''' and  finacial_d<='''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and initial_flag=''Y'''
    exec(@ssql)  

   declare mycur1  CURSOR FOR 
        select a.com_id,a.ivt_oper_listing,a.sd_order_id,a.openbill_date,a.openbill_type,a.customer_id,
        a.accept_sum,a.allaccept_sum,a.baddebt_sum,a.surplus_sum,a.c_type,a.seeds_id,a.settlement_sortID
    from #temp3 a   order by customer_id,openbill_date,maintenance_datetime,sid 
  OPEN mycur1
    FETCH NEXT FROM mycur1 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1,@seeds_id1,@settlement_sortID1
  select @surplus_sum12=@surplus_sum1
  WHILE @@FETCH_STATUS = 0
  begin
     update #temp3 set surplus_sum=isnull(@surplus_sum12,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0)  
     from #temp3   where com_id=@com_id and ivt_oper_listing=@ivt_oper_listing1 and customer_id=@customer_id1 and isnull(settlement_sortID,'')=isnull(@settlement_sortID1,'') 
     and c_type=@c_type1 and seeds_id=@seeds_id1 

     select @surplus_sum12=isnull(surplus_sum,0)  from #temp3 where com_id=@com_id 
     and ivt_oper_listing=@ivt_oper_listing1 and customer_id=@customer_id1 and c_type=@c_type1 and seeds_id=@seeds_id1 and isnull(settlement_sortID,'')=isnull(@settlement_sortID1,'') 
  
    FETCH NEXT FROM mycur1 
      INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@baddebt_sum1,@surplus_sum1,@c_type1,@seeds_id1,@settlement_sortID1
    end
  CLOSE mycur1       
  DEALLOCATE mycur1 
  
  select @ssql=''
  select  @ssql='select  *  from #temp3 order by customer_id,openbill_date,maintenance_datetime,sid '
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytran_Sp_SellAdduBill
return 0
end else
begin
COMMIT TRANSACTION mytran_Sp_SellAdduBill
return 1
end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

