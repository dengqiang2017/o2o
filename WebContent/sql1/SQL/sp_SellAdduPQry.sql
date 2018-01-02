

/****** Object:  StoredProcedure [dbo].[sp_SellAdduPQry]    Script Date: 06/27/2016 16:13:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_SellAdduPQry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_SellAdduPQry]
GO

/****** Object:  StoredProcedure [dbo].[sp_SellAdduPQry]    Script Date: 06/27/2016 16:13:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- �ϰ汾S30003Ӧ����Ʒ��ϸsp_SellAdduPQry :���㷽ʽ ��= ��Ϊlike���� ������ ���㷽ʽ �������� ���� Ҫ�� ���¼� ������ϵ
CREATE    PROCEDURE [dbo].[sp_SellAdduPQry]
( 
       @com_id char(10),
       @star_date varchar(100),            -- ��ʼʱ��
       @end_date varchar(100),             -- ��ֹʱ�� 
       @customer_id varchar(100),          -- �ͻ����� 
       @dept_id varchar(60),              -- �������� 
       @clerk_id varchar(35),             -- Ա������:���ſͻ���
       @dept_right varchar(6000),         -- ����Ȩ��=''
       @settlement_sortID varchar(100),    -- ���㷽ʽ����
       @key_words varchar(60),            -- �ؼ���  
       @if_check varchar(20),            -- �Ƿ��Ѷ���=��'ȫ��' '�Ѷ���' 'δ����'
       @if_LargessGoods varchar(60)      -- �Ƿ����ϣ� '��'��'��'
            
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

  select @text3='' -- seeds_id��¼���еĲ��ظ�ID�򵥾ݺ�  ��sid���ֳ�ʼ��¼��
  select @text3='   and  ltrim(rtrim(isnull(com_id,''''))) ='+''''+ rtrim(ltrim(@com_id))+''''
  if ltrim(rtrim(@customer_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(customer_id,''''))) ='''+ltrim(rtrim(@customer_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(dept_id,''''))) ='''+ltrim(rtrim(@dept_id))+''''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(clerk_id,''''))) ='''+ltrim(rtrim(@clerk_id))+''''

  if ltrim(rtrim(isnull(@if_check,'ȫ��')))<>'ȫ��' 
  begin
    if ltrim(rtrim(isnull(@if_check,'ȫ��')))='δ����' select @text3=@text3+' and ( (isnull(qianming,''δ����'') =''δ����'') or (isnull(qianming,'''') ='''') ) '
    if ltrim(rtrim(isnull(@if_check,'ȫ��')))='�Ѷ���' select @text3=@text3+' and not ( (isnull(qianming,''δ����'') =''δ����'') or (isnull(qianming,'''') ='''') ) '    
  end
 
   select @text3=@text3+'   '+@dept_right

    select @ssql='' -- Ӧ���ʳ�ʼ��ARf02030
    select  @ssql='insert into #temp select com_id,''���ڽ���'' as ivt_oper_listing,''���ڽ���'' as sd_order_id,'''' as openbill_date,'
    +'''�ڳ����'' as openbill_type,customer_id,'''','''',0,'''',0,0 as accept_sum,'''',0 as allaccept_sum,sum(oh_sum) as surplus_sum,0 as sid,'
    +''''',''��ʼ'',0,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,rcv_hw_no=null,null as qianming,null as qianmingTime '
    +' from  ARf02030  where com_id='''+ rtrim(ltrim(@com_id))+''' and isnull(oh_sum,0)<>0'
    if ltrim(rtrim(@customer_id))<>'' 
    select @ssql=@ssql+' and customer_id='''+ltrim(rtrim(@customer_id))+''''
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(initial_flag,''N''))) =''Y'''
    select @ssql= @ssql+'  group by com_id,customer_id'
    exec(@ssql)

  -- С�ڿ�ʼ����@star_date1-------------------------------------------------------------------------------------------------------------------------------
 
    select @ssql='' -- ���ۿ���SDd02021 
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +' (case  when sd_order_direct=''�ֿ�'' then  ''�ֿ�����'' else ''��������'' end) as openbill_type ,customer_id,'''','''',0,'''',0,'
    +'(isnull(sum_si,0)+isnull(tax_sum,0)),'''',(case  when sd_order_direct=''�ֿ�'' then  sum_si else 0  end) as allaccept_sum,0,1,mainten_datetime,'
    +'sd_order_direct,0,0,0,0,0,'
    +'null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime '
    +' from View_sdd02020 where (sd_order_direct=''����'' or sd_order_direct=''�ֿ�'') and ltrim(rtrim(isnull(shipped,'''')))=''�ѷ���'' '+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'��')))='��'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '

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

    select @ssql='' -- �����տ�
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +' (case  when sd_order_direct=''�ֿ�'' then  ''�ֿ�����'' else ''�����տ�'' end) as openbill_type ,customer_id,'''','''',0,'''',0,'
    +'0,'''',(case  when sd_order_direct=''�ֿ�'' then  sum_si else youhui_sum  end) as allaccept_sum,0,1,mainten_datetime,'
    +'sd_order_direct,0,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,null as qianming,null as qianmingTime '
    +' from SDd02020 where sd_order_direct=''����'' ' + @text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' and isnull(youhui_sum,0)<>0 '
    exec(@ssql)

   select @ssql='' --  �����տ�ARd02051
   select  @ssql='insert into #temp select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
    +'customer_id,'''','''',0,'''',0,0,'''',sum_si,0,1,mainten_datetime,recieved_direct,seeds_id,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,rcv_hw_no as expenses_id,qianming,qianmingTime '
    +' from ARd02051 where recieved_direct=''�տ�'' and isnull(if_send,''0'')<>''1'' ' +@text3  -- Ӧ�գ���Ҫ�ֿ�
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),finacial_d,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'''
    exec(@ssql)

    select @ssql=''  -- �����˻�
    select  @ssql='insert into #temp select com_id,ivt_oper_listing,sd_order_id,so_consign_date,''�����˻�'',customer_id,'''','''','
    +'0,'''',0,-(isnull(sum_si,0)+isnull(tax_sum,0)),'''',0,0,1,mainten_datetime,sd_order_direct,0,0,0,0,0,'
    +'null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime  '
    +' from View_sdd02020 where sd_order_direct=''�˻�'''+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@star_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'��')))='��'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '
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

    select @ssql=''  -- �����ʴ���ARfM02010
    select  @ssql='insert into #temp select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''Ӧ�մ�����'',customer_id,'''','''','
    +'0,'''',0,0,'''',0,0,1,mainten_datetime,''Ӧ�մ�����'',0,0,0,0,tax_invoice_sum,null,null,null,null,null,null,null,null,null,null,null,settlement_type_id as expenses_id,qianming,qianmingTime  '
    +' from ARfM02010 where c_type=''Ӧ��'''+@text3
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
      values(@com_id1,'���ڽ���','���ڽ���','','�ڳ����',@customer_id1,'','',0,'',0,@accept_sum1,'',@allaccept_sum1,
      isnull(@surplus_sum1,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0),0,'�ڳ�','0',isnull(@baddebt_sum1,0),@expenses_id,@qianming,@qianmingTime)            
    end  else begin
      update #temp1 set surplus_sum=isnull(surplus_sum,0)+isnull(@accept_sum1,0)-isnull(@baddebt_sum1,0)-isnull(@allaccept_sum1,0),
      openbill_date=@star_date  from #temp1  where com_id=@com_id  and customer_id=@customer_id1
    end    -- allaccept_sum���� ��accept_sumӦ�� and c_type=@c_type1 and seeds_id=@seeds_id1һ���ͻ�ֻ��һ����¼    
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
 -- ��ʼ����-��ֹ����֮�䷢����@star_date1

    select @ssql='' -- ���ۿ���
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +'(case  when sd_order_direct=''�ֿ�'' then  ''�ֿ�����'' else ''��������'' end) as openbill_type ,customer_id,item_id,peijian_id,'
    +'sd_oq,unit_id,sd_unit_price,(isnull(sum_si,0)+isnull(tax_sum,0)) ,beizhu,(case  when sd_order_direct=''�ֿ�'' then  sum_si else 0  end) as allaccept_sum,0,'
    +'sid,mainten_datetime,sd_order_direct,seeds_id,send_qty,send_sum,discount_rate,0,'
    +'ivt_oper_bill,if_anomaly,lot_number,item_type,item_color,item_struct,class_card,memo_other,memo_color,c_memo,c_memoMain,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime'
    +' from View_sdd02020 where (sd_order_direct=''����'' or sd_order_direct=''�ֿ�'') and ltrim(rtrim(isnull(shipped,'''')))=''�ѷ���''  '+@text3 
 
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) >= '''+ rtrim(ltrim(@star_date))
      +''' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'��')))='��'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '
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

    select @ssql=''  -- �����տ� 
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,'
    +'(case  when sd_order_direct=''�ֿ�'' then  ''�ֿ�����'' else ''�����տ�'' end) as openbill_type ,customer_id,'''','''','
    +'0,'''',0,0,'''',(case  when sd_order_direct=''�ֿ�'' then  sum_si else youhui_sum  end) as allaccept_sum,0,'
    +'-1,mainten_datetime,sd_order_direct,0,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,ltrim(rtrim(isnull(settlement_type_id,''''))) as expenses_id,qianming,qianmingTime  '
    +' from sdd02020 where sd_order_direct=''����'' '+@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) >= '''+ rtrim(ltrim(@star_date))
      +''' and  convert(varchar(23),so_consign_date,121)  < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y''  and isnull(youhui_sum,0)<>0 '
    exec(@ssql)

    select @ssql='' -- �����տ�qianming,qianmingTime,
    select  @ssql='insert into #temp3 select com_id,recieved_auto_id,recieved_id,finacial_d,recieve_type,'
    +'customer_id,'''','''',0,'''',0,0,c_memo,sum_si,0,-1,mainten_datetime,recieved_direct,seeds_id,0,0,0,0,null,null,null,null,null,null,null,null,null,null,null,rcv_hw_no as expenses_id,qianming,qianmingTime '
    +' from ARd02051 where recieved_direct=''�տ�'' and isnull(if_send,''0'')<>''1''  ' +@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(rcv_hw_no,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),finacial_d,121) >= '''+ rtrim(ltrim(@star_date))
    +''' and  convert(varchar(23),finacial_d,121) < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'''
    exec(@ssql)

    select @ssql=''  -- �����˻�
    select  @ssql='insert into #temp3 select com_id,ivt_oper_listing,sd_order_id,so_consign_date,''�����˻�'','
    +'customer_id,item_id,peijian_id,-sd_oq,unit_id,sd_unit_price,-(isnull(sum_si,0)+isnull(tax_sum,0)),beizhu,0,0,sid,mainten_datetime,'
    +'sd_order_direct,seeds_id,send_qty,send_sum,discount_rate,0,'
    +'ivt_oper_bill,if_anomaly,lot_number,item_type,item_color,item_struct,class_card,memo_other,memo_color,c_memo,c_memoMain,settlement_type_id as expenses_id,qianming,qianmingTime  '
    +' from View_sdd02020 where sd_order_direct=''�˻�'' ' +@text3
    if ltrim(rtrim(@settlement_sortID))<>'' select @ssql=@ssql+' and ltrim(rtrim(isnull(settlement_type_id,''''))) like ''%'+ltrim(rtrim(@settlement_sortID))+'%'''
    select @ssql=@ssql+' and  convert(varchar(23),so_consign_date,121) >= '''+ rtrim(ltrim(@star_date))
    +''' and  convert(varchar(23),so_consign_date,121) < '''+ rtrim(ltrim(@end_date))+''''
    select @ssql= @ssql+'  and ltrim(rtrim(isnull(comfirm_flag,''N'')))=''Y'' '
    if ltrim(rtrim(isnull(@if_LargessGoods,'��')))='��'  select @ssql=@ssql+' and (isnull(sum_si,0.000000)+isnull(tax_sum,0.000000)) = 0.000000 '
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
 
    select @ssql='' -- �����ʴ���
    select  @ssql='insert into #temp3 select com_id,Debt_auto_no,Debt_ha_no,finacial_d,''Ӧ�մ�����'',customer_id,'''','''','
    +'0,'''',0,0,'''',0,0,-1,mainten_datetime,''Ӧ�մ�����'',0,0,0,0,tax_invoice_sum,null,null,null,null,null,null,null,null,null,null,null,settlement_type_id as expenses_id,qianming,qianmingTime  '
    +' from ARfM02010 where c_type=''Ӧ��'''+@text3
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
-------------���ս����ʱ�� ��Ӧ �ֶ� ˵��
-- #temp3 (com_id char(10),ivt_oper_listing varchar(100),sd_order_id varchar(100),      -- ��Ӫ�̱���,     ��������     ,����
-- openbill_date datetime, openbill_type char(10),customer_id varchar(100),            -- ��������,       ҵ������     ,�ͻ�����
-- item_id varchar(40),peijian_id varchar(40),sd_oq decimal(28,6),                    -- ��Ʒ����,       ��Ʒ����     ,�����еķ��� ����          
-- unit_id varchar(100),sd_unit_price decimal(28,6),accept_sum decimal(28,6),          -- ������λ,       ���㵥��     ,Ӧ�ս��     
-- beizhu varchar(150),allaccept_sum decimal(28,6), surplus_sum decimal(28,6),        -- �ӱ�ע,       ʵ�ս��     ,������(Ƿ����) 
-- sid int,maintenance_datetime datetime,c_type char(10),                             -- �����к�  ,     ά��ʱ��     ,ҵ������(���õ�)
-- seeds_id varchar(100),send_qty decimal(28,6), send_sum decimal(28,6),               -- ������,         �ѷ�����     ,�Żݽ��
-- discount_rate decimal(9,6),baddebt_sum decimal(28,6),ivt_oper_bill varchar(100),    -- �ۿ���,         �������     ,���۱��۵����
-- if_anomaly varchar(4),lot_number varchar(100),item_type varchar(100),                -- ��Ʒ����?,      ���         ,�ͺ�
-- item_color varchar(100),item_struct  varchar(100), class_card  varchar(100),          -- ��ɫ,           �ṹ         ,Ʒ��
-- memo_other varchar(150),memo_color varchar(150),detail_c_memo varchar(150),        -- ������ע,       ������ɫ     ,���ݵ���ϸ��ע
-- c_memo varchar(150), expenses_id varchar(100)                                       -- ����ע,       ���㷽ʽ
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
    +'openbill_type=''�ϼ�'',customer_id=null,item_id=null,peijian_id=null,sum(isnull(sd_oq,0.000000)) as sd_oq,'
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


