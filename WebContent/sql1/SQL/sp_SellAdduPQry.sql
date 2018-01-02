

/****** Object:  StoredProcedure [dbo].[sp_SellAdduPQry]    Script Date: 06/27/2016 16:13:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_SellAdduPQry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_SellAdduPQry]
GO

/****** Object:  StoredProcedure [dbo].[sp_SellAdduPQry]    Script Date: 06/27/2016 16:13:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- 老版本S30003应收物品明细sp_SellAdduPQry :结算方式 把= 改为like，但 条件是 结算方式 基础资料 编码 要是 上下级 包含关系
CREATE    PROCEDURE [dbo].[sp_SellAdduPQry]
( 
       @com_id char(10),
       @star_date varchar(100),            -- 起始时间
       @end_date varchar(100),             -- 截止时间 
       @customer_id varchar(100),          -- 客户内码 
       @dept_id varchar(60),              -- 部门内码 
       @clerk_id varchar(35),             -- 员工内码:跟着客户走
       @dept_right varchar(6000),         -- 部门权限=''
       @settlement_sortID varchar(100),    -- 结算方式内码
       @key_words varchar(60),            -- 关键词  
       @if_check varchar(20),            -- 是否已对账=：'全部' '已对账' '未对账'
       @if_LargessGoods varchar(60)      -- 是否赠料？ '是'或'否'
            
)
AS 
BEGIN TRANSACTION tran_sp_SellAdduPQry
    declare @text3 varchar(8000),@ssql varchar(8000),@ivt_oper_listing1 varchar(100),@accept_sum1 decimal(28,6),
    @allaccept_sum1 decimal(28,6),@surplus_sum1 decimal(28,6),@com_id1 char(10),@baddebt_sum1 decimal(28,6),
    @openbill_date1 datetime,@month_date1 tinyint,@surplus_sum12 decimal(28,6),@openbill_type1 char(4),
    @customer_id1 varchar(100),@sd_order_id1 varchar(100),@c_type1 char(10),@seeds_id1 varchar(100),@expenses_id varchar(100),
    @qianming varchar(100), @qianmingTime datetime

    create table #temp (com_id char(10),ivt_oper_listing varchar(100),sd_order_id varchar(100),openbill_date datetime,
    openbill_type char(10),customer_id varchar(100),item_id varchar(40),peijian_id varchar(40),sd_oq decimal(28,6),
    unit_id varchar(100),sd_unit_price decimal(28,6),accept_sum decimal(28,6),beizhu varchar(1000),allaccept_sum decimal(28,6),
    surplus_sum decimal(28,6),sid int,maintenance_datetime datetime,c_type char(10),seeds_id varchar(100),send_qty decimal(28,2),
    send_sum decimal(28,6),discount_rate decimal(9,6),baddebt_sum decimal(28,6),ivt_oper_bill varchar(100),
    if_anomaly varchar(4),lot_number varchar(100),item_type varchar(100),item_color varchar(100),item_struct  varchar(100),
    class_card  varchar(100),memo_other varchar(150),memo_color varchar(150),detail_c_memo varchar(150),c_memo varchar(800),
    expenses_id varchar(100),qianming varchar(100), qianmingTime datetime )

    create table #temp1 (com_id char(10),ivt_oper_listing varchar(100),sd_order_id varchar(100),openbill_date datetime,
    openbill_type char(10),customer_id varchar(100),item_id varchar(40),peijian_id varchar(40),sd_oq decimal(28,6),
    unit_id varchar(100),sd_unit_price decimal(28,6),accept_sum decimal(28,6),beizhu varchar(1000),allaccept_sum decimal(28,6),
    surplus_sum decimal(28,6),sid int,maintenance_datetime datetime,c_type char(10),seeds_id varchar(100),send_qty decimal(28,2),
    send_sum decimal(28,6),discount_rate decimal(9,6),baddebt_sum decimal(28,6),ivt_oper_bill varchar(100),
    if_anomaly varchar(4),lot_number varchar(100),item_type varchar(100),item_color varchar(100),item_struct  varchar(100),
    class_card  varchar(100),memo_other varchar(150),memo_color varchar(150),detail_c_memo varchar(150),c_memo varchar(800),
    expenses_id varchar(100),qianming varchar(100), qianmingTime datetime )

    create table #temp3 (com_id char(10),ivt_oper_listing varchar(100),sd_order_id varchar(100),openbill_date datetime,
    openbill_type char(10),customer_id varchar(100),item_id varchar(40),peijian_id varchar(40),sd_oq decimal(28,6),
    unit_id varchar(100),sd_unit_price decimal(28,6),accept_sum decimal(28,6),beizhu varchar(1000),allaccept_sum decimal(28,6),
    surplus_sum decimal(28,6),sid int,maintenance_datetime datetime,c_type char(10),seeds_id varchar(100),send_qty decimal(28,6),
    send_sum decimal(28,6),discount_rate decimal(9,6),baddebt_sum decimal(28,6),ivt_oper_bill varchar(100),
    if_anomaly varchar(4),lot_number varchar(100),item_type varchar(100),item_color varchar(100),item_struct  varchar(100),
    class_card  varchar(100),memo_other varchar(150),memo_color varchar(150),detail_c_memo varchar(150),c_memo varchar(800),
    expenses_id varchar(100),qianming varchar(100), qianmingTime datetime )

  select @text3='' -- seeds_id记录表中的不重复ID或单据号  和sid区分初始记录的
  select @text3='   and  ltrim(rtrim(isnull(com_id,''''))) ='+''''+ rtrim(ltrim(@com_id))+''''
  if ltrim(rtrim(@customer_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(customer_id,''''))) ='''+ltrim(rtrim(@customer_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(dept_id,''''))) ='''+ltrim(rtrim(@dept_id))+''''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(clerk_id,''''))) ='''+ltrim(rtrim(@clerk_id))+''''

  if ltrim(rtrim(isnull(@if_check,'全部')))<>'全部' 
  begin
    if ltrim(rtrim(isnull(@if_check,'全部')))='未对账' select @text3=@text3+' and ( (isnull(qianming,''未对账'') =''未对账'') or (isnull(qianming,'''') ='''') ) '
    if ltrim(rtrim(isnull(@if_check,'全部')))='已对账' select @text3=@text3+' and not ( (isnull(qianming,''未对账'') =''未对账'') or (isnull(qianming,'''') ='''') ) '    
  end
 
   select @text3=@text3+'   '+@dept_right

    select @ssql='' -- 应收帐初始化ARf02030
    select  @ssql='insert into #temp select com_id,''上期结余'' as ivt_oper_listing,''上期结余'' as sd_order_id,'''' as openbill_date,'
    +'''期初金额'' as openbill_type,customer_id,'''','''',0,'''',0,0 as accept_sum,'''',0 as allaccept_sum,sum(oh_sum) as surplus_sum,0 as sid,'
    +''''',''初始'',0,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,rcv_hw_no=null,null as qianming,null as qianmingTime '
    +' from  ARf02030  where com_id='''+ rtrim(ltrim(@com_id))+''' and isnull(oh_sum,0)<>0'
    if ltrim(rtrim(@customer_id))<>'' 
    select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@customer_id))+''''
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(initial_flag,''N''))) =''Y'''
    select @ssql= @ssql+'  group by com_id,customer_id'
    exec(@ssql)

  -- 小于开始日期@star_date1-------------------------------------------------------------------------------------------------------------------------------
 
    select @ssql='' -- 销售开单SDd02021 
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +' (case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as openbill_type ,customer_id,'''','''',0,'''',0,'
    +'(isnull(sum_si,0)+isnull(tax_sum,0)),'''',(case  when sd_order_direct=''现款'' then  sum_si else 0  end) as allaccept_sum,0,1,mainten_datetime,'
    +'sd_order_direct,0,0,0,0,0,'
    +'null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime '
    +' from View_sdd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'') and ltrim(rtrim(isnull(shipped,'''')))=''已发货'' '+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'否')))='是'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '

    if ltrim(rtrim(isnull(@key_words,'')))<>'' 
    select @ssql=@ssql
      +' and ( '  
      +'         ( ltrim(rtrim(isnull(c_memo,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  '
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) = '''+ltrim(rtrim(@key_words))+''' )  '                              
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_sim_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_spec,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_type,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(class_card,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_color,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_status,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(goods_origin,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(qianming,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'     ) '
    exec(@ssql)

    select @ssql='' -- 挂帐收款
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +' (case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐收款'' end) as openbill_type ,customer_id,'''','''',0,'''',0,'
    +'0,'''',(case  when sd_order_direct=''现款'' then  sum_si else youhui_sum  end) as allaccept_sum,0,1,mainten_datetime,'
    +'sd_order_direct,0,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,null as qianming,null as qianmingTime '
    +' from SDd02020 where sd_order_direct=''发货'' ' + @text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' and isnull(youhui_sum,0)<>0 '
    exec(@ssql)

   select @ssql='' --  销售收款ARd02051
   select  @ssql='insert into #temp select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
    +'customer_id,'''','''',0,'''',0,0,'''',sum_si,0,1,mainten_datetime,recieved_direct,seeds_id,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,rcv_hw_no as expenses_id,qianming,qianmingTime '
    +' from ARd02051 where recieved_direct=''收款'' and isnull(if_send,''0'')<>''1'' ' +@text3  -- 应收，不要现款
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),finacial_d,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'''
    exec(@ssql)

    select @ssql=''  -- 销售退货
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,''销售退货'',customer_id,'''','''','
    +'0,'''',0,-(isnull(sum_si,0)+isnull(tax_sum,0)),'''',0,0,1,mainten_datetime,sd_order_direct,0,0,0,0,0,'
    +'null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime  '
    +' from View_sdd02020 where sd_order_direct=''退货'''+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'否')))='是'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '
    if ltrim(rtrim(isnull(@key_words,'')))<>'' 
    select @ssql=@ssql
      +' and ( '  
      +'         ( ltrim(rtrim(isnull(c_memo,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  '
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) = '''+ltrim(rtrim(@key_words))+''' )  '                              
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_sim_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_spec,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_type,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(class_card,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_color,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_status,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(goods_origin,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(qianming,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'     ) '
    exec(@ssql)

    select @ssql=''  -- 呆坏帐处理ARfM02010
    select  @ssql='insert into #temp select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''应收呆坏帐'',customer_id,'''','''','
    +'0,'''',0,0,'''',0,0,1,mainten_datetime,''应收呆坏帐'',0,0,0,0,tax_invoice_sum,null,null,null,null,null,null,null,null,null,null,null,settlement_type_id as expenses_id,qianming,qianmingTime  '
    +' from ARfM02010 where c_type=''应收'''+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),finacial_d,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(initial_flag,''N''))) =''Y'''
    exec(@ssql)

   declare mycur  CURSOR FOR 
        select a.com_id,a.ivt_oper_listing,a.sd_order_id,a.openbill_date,a.openbill_type,a.customer_id,
        a.accept_sum,a.allaccept_sum,a.surplus_sum,a.c_type,a.seeds_id,a.baddebt_sum,a.expenses_id,a.qianming,a.qianmingTime
    from #temp a   order by customer_id,sid,openbill_date,maintenance_datetime
  OPEN mycur
    FETCH NEXT FROM mycur 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@surplus_sum1,@c_type1,@seeds_id1,@baddebt_sum1,@expenses_id,@qianming,@qianmingTime
  WHILE @@FETCH_STATUS = 0
  begin
    
    select @ivt_oper_listing1=ivt_oper_listing  from #temp1   where com_id=@com_id and customer_id=@customer_id1 
    if @@rowcount=0 
    begin
      insert into  #temp1(com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,customer_id,item_id ,
      peijian_id,sd_oq,unit_id,sd_unit_price,accept_sum,beizhu,allaccept_sum,surplus_sum,sid,c_type,seeds_id,baddebt_sum,expenses_id,qianming,qianmingTime) 
      values(@com_id1,'上期结余','上期结余','','期初金额',@customer_id1,'','',0,'',0,@accept_sum1,'',@allaccept_sum1,
      isnull(@surplus_sum1,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0),0,'期初','0',isnull(@baddebt_sum1,0),@expenses_id,@qianming,@qianmingTime)            
    end  else begin
      update #temp1 set surplus_sum=isnull(surplus_sum,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0),
      openbill_date=@star_date  from #temp1  where com_id=@com_id  and customer_id=@customer_id1
    end    -- allaccept_sum已收 ，accept_sum应收 and c_type=@c_type1 and seeds_id=@seeds_id1一个客户只有一条记录    
    FETCH NEXT FROM mycur 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@surplus_sum1,@c_type1,@seeds_id1,@baddebt_sum1,@expenses_id,@qianming,@qianmingTime
    end
  CLOSE mycur       
  DEALLOCATE mycur

  insert into  #temp3(com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,customer_id,item_id,peijian_id,sd_oq,
    unit_id,sd_unit_price,accept_sum,beizhu,allaccept_sum,surplus_sum,sid,c_type,seeds_id,send_qty,baddebt_sum,expenses_id,qianming,qianmingTime)
  select com_id,ivt_oper_listing,sd_order_id,openbill_date,openbill_type,customer_id,'','',0,
    '',0,0,'',0,surplus_sum,sid,c_type,seeds_id,send_qty,0,expenses_id, qianming,qianmingTime from #temp1  
 -- 开始日期-截止日期之间发生额@star_date1

    select @ssql='' -- 销售开单
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +'(case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as openbill_type ,customer_id,item_id,peijian_id,'
    +'sd_oq,unit_id,sd_unit_price,(isnull(sum_si,0)+isnull(tax_sum,0)) ,beizhu,(case  when sd_order_direct=''现款'' then  sum_si else 0  end) as allaccept_sum,0,'
    +'sid,mainten_datetime,sd_order_direct,seeds_id,send_qty,send_sum,discount_rate,0,'
    +'ivt_oper_bill,if_anomaly,lot_number,item_type,item_color,item_struct,class_card,memo_other,memo_color,c_memo,c_memoMain,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime'
    +' from View_sdd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'') and ltrim(rtrim(isnull(shipped,'''')))=''已发货''  '+@text3 
 
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) >= '''+ rtrim(ltrim(@star_date))
      +''' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'否')))='是'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '
    if ltrim(rtrim(isnull(@key_words,'')))<>'' 
    select @ssql=@ssql
      +' and ( '  
      +'         ( ltrim(rtrim(isnull(c_memo,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  '
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) = '''+ltrim(rtrim(@key_words))+''' )  '                              
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_sim_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_spec,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_type,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(class_card,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_color,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_status,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(goods_origin,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(qianming,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
     
      +'     ) '
    exec(@ssql)

    select @ssql=''  -- 挂帐收款 
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +'(case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐收款'' end) as openbill_type ,customer_id,'''','''','
    +'0,'''',0,0,'''',(case  when sd_order_direct=''现款'' then  sum_si else youhui_sum  end) as allaccept_sum,0,'
    +'-1,mainten_datetime,sd_order_direct,0,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime  '
    +' from sdd02020 where sd_order_direct=''发货'' '+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) >= '''+ rtrim(ltrim(@star_date))
      +''' and  convert(varchar(23),so_consign_date,121)  < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y''  and isnull(youhui_sum,0)<>0 '
    exec(@ssql)

    select @ssql='' -- 销售收款qianming,qianmingTime,
    select  @ssql='insert into #temp3 select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
    +'customer_id,'''','''',0,'''',0,0,c_memo,sum_si,0,-1,mainten_datetime,recieved_direct,seeds_id,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,rcv_hw_no as expenses_id,qianming,qianmingTime '
    +' from ARd02051 where recieved_direct=''收款'' and isnull(if_send,''0'')<>''1''  ' +@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),finacial_d,121) >= '''+ rtrim(ltrim(@star_date))
    +''' and  convert(varchar(23),finacial_d,121) < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'''
    exec(@ssql)

    select @ssql=''  -- 销售退货
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,''销售退货'','
    +'customer_id,item_id,peijian_id,-sd_oq,unit_id,sd_unit_price,-(isnull(sum_si,0)+isnull(tax_sum,0)),beizhu,0,0,sid,mainten_datetime,'
    +'sd_order_direct,seeds_id,send_qty,send_sum,discount_rate,0,'
    +'ivt_oper_bill,if_anomaly,lot_number,item_type,item_color,item_struct,class_card,memo_other,memo_color,c_memo,c_memoMain,settlement_type_id as expenses_id,qianming,qianmingTime  '
    +' from View_sdd02020 where sd_order_direct=''退货'' ' +@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) >= '''+ rtrim(ltrim(@star_date))
    +''' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'否')))='是'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '
    if ltrim(rtrim(isnull(@key_words,'')))<>'' 
    select @ssql=@ssql
      +' and ( '  
      +'         ( ltrim(rtrim(isnull(c_memo,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  '
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) = '''+ltrim(rtrim(@key_words))+''' )  '                              
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_sim_name,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_spec,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_type,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(class_card,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_color,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(item_status,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(goods_origin,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'      or ( ltrim(rtrim(isnull(item_id,''''))) in ( select ltrim(rtrim(isnull(item_id,'''')))  from ctl03001 where com_id='''+ rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(qianming,''''))) like ''%'+ltrim(rtrim(@key_words))+'%'' )  )' 
      +'     ) '
    exec(@ssql)
 
    select @ssql='' -- 呆坏帐处理
    select  @ssql='insert into #temp3 select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''应收呆坏帐'',customer_id,'''','''','
    +'0,'''',0,0,'''',0,0,-1,mainten_datetime,''应收呆坏帐'',0,0,0,0,tax_invoice_sum,null,null,null,null,null,null,null,null,null,null,null,settlement_type_id as expenses_id,qianming,qianmingTime  '
    +' from ARfM02010 where c_type=''应收'''+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),finacial_d,121) >= '''+ rtrim(ltrim(@star_date))
    +''' and  finacial_d<='''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(initial_flag,''N'')))=''Y'''
    exec(@ssql)
  
    
  declare mycur1  CURSOR FOR 
        select a.com_id,a.ivt_oper_listing,a.sd_order_id,a.openbill_date,a.openbill_type,a.customer_id,
        a.accept_sum,a.allaccept_sum,a.surplus_sum,a.c_type,a.seeds_id,a.baddebt_sum,a.expenses_id,a.qianming,a.qianmingTime
    from #temp3 a   order by customer_id,openbill_date,maintenance_datetime,sid 
  OPEN mycur1
    FETCH NEXT FROM mycur1 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@surplus_sum1,@c_type1,@seeds_id1,@baddebt_sum1,@expenses_id,@qianming,@qianmingTime
  select @surplus_sum12=@surplus_sum1
  WHILE @@FETCH_STATUS = 0
  begin
     update #temp3 set surplus_sum=isnull(@surplus_sum12,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0) 
     from #temp3  where com_id=@com_id and ivt_oper_listing=@ivt_oper_listing1 and customer_id=@customer_id1 
     and c_type=@c_type1 and seeds_id=@seeds_id1 

     set @surplus_sum12= ( select isnull(surplus_sum,0)  from #temp3 where com_id=@com_id 
     and ivt_oper_listing=@ivt_oper_listing1 and customer_id=@customer_id1 and c_type=@c_type1 and seeds_id=@seeds_id1  )
  
    FETCH NEXT FROM mycur1 
     INTO @com_id1,@ivt_oper_listing1,@sd_order_id1,@openbill_date1,@openbill_type1,@customer_id1,
        @accept_sum1,@allaccept_sum1,@surplus_sum1,@c_type1,@seeds_id1,@baddebt_sum1,@expenses_id,@qianming,@qianmingTime
    end
  CLOSE mycur1       
  DEALLOCATE mycur1 
  
  set @ssql=''
--  select  @ssql='select * from #temp3 order by customer_id,openbill_date,maintenance_datetime,sid '
-------------最终结果临时表 对应 字段 说明
-- #temp3 (com_id char(10),ivt_oper_listing varchar(100),sd_order_id varchar(100),      -- 运营商编码,     单号内码     ,单号
-- openbill_date datetime, openbill_type char(10),customer_id varchar(100),            -- 单据日期,       业务类型     ,客户内码
-- item_id varchar(40),peijian_id varchar(40),sd_oq decimal(28,6),                    -- 产品内码,       产品编码     ,单据中的发生 数量          
-- unit_id varchar(100),sd_unit_price decimal(28,6),accept_sum decimal(28,6),          -- 基本单位,       结算单价     ,应收金额     
-- beizhu varchar(150),allaccept_sum decimal(28,6), surplus_sum decimal(28,6),        -- 从表备注,       实收金额     ,结余金额(欠款金额) 
-- sid int,maintenance_datetime datetime,c_type char(10),                             -- 订单行号  ,     维护时间     ,业务类型(不用的)
-- seeds_id varchar(100),send_qty decimal(28,6), send_sum decimal(28,6),               -- 行种子,         已发数量     ,优惠金额
-- discount_rate decimal(9,6),baddebt_sum decimal(28,6),ivt_oper_bill varchar(100),    -- 折扣率,         呆坏金额     ,销售报价单编号
-- if_anomaly varchar(4),lot_number varchar(100),item_type varchar(100),                -- 产品异型?,      规格         ,型号
-- item_color varchar(100),item_struct  varchar(100), class_card  varchar(100),          -- 颜色,           结构         ,品牌
-- memo_other varchar(150),memo_color varchar(150),detail_c_memo varchar(150),        -- 其它备注,       特殊配色     ,单据的明细备注
-- c_memo varchar(150), expenses_id varchar(100)                                       -- 主表备注,       结算方式
--  )


  set  @ssql=' select com_id,ivt_oper_listing,sd_order_id,openbill_date,'
    +'openbill_type,customer_id,item_id,peijian_id,isnull(sd_oq,0.000000) as sd_oq,'
    +'unit_id,sd_unit_price,accept_sum,beizhu,allaccept_sum,'
    +'surplus_sum,sid,maintenance_datetime,c_type,seeds_id,send_qty,'
    +'send_sum,discount_rate,baddebt_sum,ivt_oper_bill,'
    +'isnull(if_anomaly,'''') as if_anomaly,lot_number,item_type,item_color,item_struct,'
    +'class_card,memo_other,memo_color,detail_c_memo,c_memo,expenses_id,qianming,qianmingTime ' 
    +' from #temp3 '
  set  @ssql=@ssql
    +' union all  select com_id,ivt_oper_listing=null,sd_order_id=null,openbill_date=null,'
    +'openbill_type=''合计'',customer_id=null,item_id=null,peijian_id=null,sum(isnull(sd_oq,0.000000)) as sd_oq,'
    +'unit_id=null,sd_unit_price=null,sum(isnull(accept_sum,0.000000)) as accept_sum,beizhu=null,sum(isnull(allaccept_sum,0.000000)) as allaccept_sum,'
    +'( sum(isnull(accept_sum,0.000000))-sum(isnull(allaccept_sum,0.000000))-sum(isnull(baddebt_sum,0.000000)) ) as surplus_sum,sid=null,maintenance_datetime=null,c_type=null,seeds_id=null,sum(isnull(send_qty,0.000000)) as send_qty,'
    +'sum(isnull(send_qty,0.000000)) as send_sum,discount_rate=null,sum(isnull(baddebt_sum,0.000000)) as baddebt_sum,ivt_oper_bill=null,'
    +'if_anomaly=null,lot_number=null,item_type=null,item_color=null,item_struct=null,'
    +'class_card=null,memo_other=null,memo_color=null,detail_c_memo=null,c_memo=null,expenses_id=null,qianming=null,qianmingTime=null ' 
    +' from #temp3 '  
    +' group by com_id '    
    +' order by customer_id desc,openbill_date,maintenance_datetime,sid '

  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION tran_sp_SellAdduPQry
return 0
end else
begin
COMMIT TRANSACTION tran_sp_SellAdduPQry
return 1
end






GO


