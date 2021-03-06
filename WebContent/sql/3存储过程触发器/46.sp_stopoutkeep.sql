if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_stopoutkeep]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_stopoutkeep]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--收发存汇总表
CREATE       PROCEDURE sp_stopoutkeep
(
       @com_id1 char(10),
       @star_date1 varchar(30),
       @end_date1 varchar(30),
       @store_struct_id1 varchar(30),
       @dept_id1 varchar(30),
       @clerk_id1 varchar(35),
       @type_id1 varchar(30),
       @item_id1 varchar(40),
       @vendor_id varchar(50),
       @zero char(1),
       @get_store varchar(3000),
       @get_instore varchar(3000)
)      
AS 
BEGIN TRANSACTION mytranSp_stopoutkeep 
    declare @text varchar(8000),@text1 varchar(8000),@text3 varchar(8000),@ssql varchar(8000),@finacial_y int,@finacial_m tinyint,
    @store_struct_id varchar(30),@item_id varchar(40),@lot_number varchar(40),@iprice decimal(28,6),@year_date int,
    @month_date tinyint,@finacial_date_bigen datetime,@finacial_date_end datetime,@com_id char(10),@oh_oq decimal(28,6),
    @oh_Amount decimal(28,6),@in_storenum decimal(28,6),@in_storeAmount decimal(28,6),@out_storenum decimal(28,6),
    @acct_oq decimal(28,6),@acct_price decimal(28,6),@acct_sum decimal(28,6),@store_date datetime,@differ_quant decimal(28,6)

  create table #temp (com_id char(10),item_id varchar(40),oh_oq decimal(28,6),oh_Amount decimal(28,6),in_storenum decimal(28,6),
  in_storeAmount decimal(28,6),out_storenum decimal(28,6),out_storeamount decimal(28,6),differ_quant decimal(28,6),
  differ_amount decimal(28,6),acct_oq decimal(28,6),acct_sum decimal(28,6),store_date datetime,sid int,maintenance_datetime datetime,
  loss_oq decimal(28,6),loss_amount decimal(28,6) )

  create table #temp1 (com_id char(10),item_id varchar(40),oh_oq decimal(28,6),oh_Amount decimal(28,6),in_storenum decimal(28,6),
  in_storeAmount decimal(28,6),out_storenum decimal(28,6),out_storeamount decimal(28,6),differ_quant decimal(28,6),
  differ_amount decimal(28,6),acct_oq decimal(28,6),acct_sum decimal(28,6),store_date datetime,sid int,maintenance_datetime datetime,
  loss_oq decimal(28,6),loss_amount decimal(28,6) )

  create table #temp2 (com_id char(10),item_id varchar(40),oh_oq decimal(28,6),oh_Amount decimal(28,6),in_storenum decimal(28,6),
  in_storeAmount decimal(28,6),out_storenum decimal(28,6),out_storeamount decimal(28,6),differ_quant decimal(28,6),
  differ_amount decimal(28,6),acct_oq decimal(28,6),acct_sum decimal(28,6),store_date datetime,sid int,maintenance_datetime datetime,
  loss_oq decimal(28,6),loss_amount decimal(28,6) )

  create table #temp3 (com_id char(10),item_id varchar(40),peijian_id varchar(40),oh_oq decimal(28,6),oh_Amount decimal(28,6),in_storenum decimal(28,6),
  in_storeAmount decimal(28,6),out_storenum decimal(28,6),out_storeamount decimal(28,6),differ_quant decimal(28,6),
  differ_amount decimal(28,6),acct_oq decimal(28,6),acct_sum decimal(28,6),store_date datetime,sid int,maintenance_datetime datetime,
  loss_oq decimal(28,6),loss_amount decimal(28,6) )

  create table #temp4 (com_id char(10),item_id varchar(40),peijian_id varchar(40),oh_oq decimal(28,6),oh_Amount decimal(28,6),in_storenum decimal(28,6),
  in_storeAmount decimal(28,6),out_storenum decimal(28,6),out_storeamount decimal(28,6),differ_quant decimal(28,6),
  differ_amount decimal(28,6),acct_oq decimal(28,6),acct_amount decimal(17,2),store_date datetime,sid int,maintenance_datetime datetime,
  loss_oq decimal(28,6),loss_amount decimal(28,6) )

select @text3='',@text1='',@text=''
select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id1))+''''
if rtrim(ltrim( @clerk_id1))<>''
  select @text3=@text3+' and  clerk_id='+''''+rtrim(ltrim( @clerk_id1))+''''
if  rtrim(ltrim(@type_id1))<>''
  select @text3= @text3+' and item_id in (select item_id from ctl03001 where com_id='''+@com_id1
    +''' and type_id  like '''+rtrim(ltrim(@type_id1))+'%'')'
if  rtrim(ltrim(@item_id1))<>''
  select @text3= @text3+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
if rtrim(ltrim(@vendor_id))<>''
     select @text3=@text3+'  and item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id1))+''''+'  and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'')'
--开始：仓位权限
  if ltrim(rtrim(@get_store))<>''  select @text1=@text1+' '+ltrim(rtrim(@get_store))+' '  --普通仓位
  if ltrim(rtrim(@get_instore))<>''  select @text=@text+' '+ltrim(rtrim(@get_instore))+' '  --调拨入库仓位
--结束：仓位权限


 select @ssql=''
  select @ssql=' insert into #temp1 select com_id,item_id,oh,oh*i_price,0,0,0,0,0,0,oh,oh*i_price,'
  +'maintenance_datetime,0,maintenance_datetime,0,0  from ivtd01300 where  com_id='''+ rtrim(ltrim(@com_id1))+''''
  if  rtrim(ltrim( @store_struct_id1))<>''
   select @ssql= @ssql+' and store_struct_id   like  '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  if  rtrim(ltrim(@type_id1))<>''
   select @ssql= @ssql+' and item_id in (select item_id  from ctl03001 where com_id='+''''
   + rtrim(ltrim(@com_id1))+''''+'  and  type_id  like '''+@type_id1+'%'')'
  if  rtrim(ltrim(@item_id1))<>''
   select @ssql= @ssql+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
  if rtrim(ltrim(@vendor_id))<>''
   select @ssql=@ssql+'  and item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id1))+''''+'  and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'')'
   select @ssql=@ssql+'  and initial_flag=''Y'' ' +@text1
  exec(@ssql)  --初始化入进

--小于开始日期@star_date1
  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(lead_oq,0),isnull(plan_price,0),'  --委托加工入库
  +'0,0,0,0,0,0,send_date,1,mainten_datetime,0,0 from VIEW_Yie05010  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  send_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and isnull(comfirm_flag,''N'')=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(lead_oq,0),isnull(plan_price,0),0,'  --委托加工材料出库
  +'0,0,0,send_date,1,mainten_datetime,0,0 from VIEW_Yie05012  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  send_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and isnull(comfirm_flag,''N'')=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(rep_qty,0),isnull(st_sum,0),'  --采购入库
  +'0,0,0,0,0,0,store_date,1,mainten_datetime,0,0 from View_STDM03001  where  (stock_type=''进货'' or stock_type=''借货'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(rep_qty,0),isnull(st_sum,0),0,'
  +'0,0,0,store_date,1,mainten_datetime,0,0 from View_STDM03001  where  stock_type=''退货'''+@text3+@text1   --采购退货出库
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(sd_oq,0),sd_oq*tax_sum_si,0,0,0,0,'/*销售出库*/
  +'so_consign_date,1,mainten_datetime,0,0  from View_sdd02020  where  (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(sd_oq,0),sd_oq*tax_sum_si,0,0,0,0,0,0,'
  +'so_consign_date,1,mainten_datetime,0,0  from View_sdd02020 where sd_order_direct=''退货'''+@text3+@text1 /*销售退货*/
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

   select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(oper_qty,0),isnull(plan_price,0),'
  +'0,0,0,0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''入库'''+@text3+@text1 /*入库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(oper_qty,0),isnull(plan_price,0),0,'
  +'0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''出库'''+@text3+@text1  /*出库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)


  select  @ssql=''    --调拨入库，入库单价上：存在同价调拨和变价调拨的区别
  if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='1' --MoveStore_Style='1'同价调拨   
  begin
    select @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(oper_qty,0),isnull(plan_price,0), '
             +'0,0,0,0,0,0,store_date,1,maintenance_datetime,0,0  from VIEW_ivt01201 where ivt_oper_id=''调拨'' '+@text3+@text
    if  rtrim(ltrim( @store_struct_id1))<>''
      select @ssql= @ssql+' and  corpstorestruct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
      select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
    if  rtrim(ltrim( @dept_id1))<>''
      select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
      select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end else if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='0'  --MoveStore_Style='0'变价调拨
  begin
    select @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(oper_qty,0),isnull(pass_oq,0), '
             +'0,0,0,0,0,0,store_date,1,maintenance_datetime,0,0  from VIEW_ivt01201 where ivt_oper_id=''调拨'' '+@text3+@text
    if  rtrim(ltrim( @store_struct_id1))<>''
      select @ssql= @ssql+' and  corpstorestruct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
      select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
    if  rtrim(ltrim( @dept_id1))<>''
      select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
      select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(oper_qty,0),isnull(plan_price,0),'
  +'0,0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text1 --调拨出库
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,0,0,0,0,0,0,store_date,1,'
  +'maintenance_datetime,isnull(oper_qty,0),isnull(plan_price,0)  from VIEW_ivt01201 where ivt_oper_id=''报损'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and  store_struct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''/*库存报损*/
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(group_oq,0),isnull(group_sum,0),'
  +'0,0,0,0,0,0,so_effect_datetime,1,mainten_datetime,0,0 from ivtd03001  where group_split=''组装''  '+@text3+@text1 /*组装入库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(sd_oq,0),isnull(sum_si,0),0,'
  +'0,0,0,so_effect_datetime,1,mainten_datetime,0,0 from VIEW_ivtd03001 where group_split=''组装'' ' +@text3+@text1 /*组装出库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(group_oq,0),isnull(group_sum,0),0,'
  +'0,0,0,so_effect_datetime,1,mainten_datetime,0,0  from ivtd03001  where group_split=''拆卸'' ' +@text3+@text1 /*拆卸出库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(sd_oq,0),isnull(sum_si,0),0,0,'
  +'0,0,0,0,so_effect_datetime,1,mainten_datetime,0,0  from VIEW_ivtd03001 where group_split=''拆卸'' ' +@text3+@text1 /*拆卸入库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,isnull(sd_oq,0),isnull(sum_ti,0),0,'
  +'0,0,0,0,0,tax_invoice_date,1,mainten_datetime,0,0  from VIEW_Ard02040 where tax_invoice_direct=''供货'''+@text3+@text1   --供货入库
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and  store_struct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  tax_invoice_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,isnull(sd_oq,0),isnull(sum_ti,0),0,'
  +'0,0,0,tax_invoice_date,1,mainten_datetime,0,0  from VIEW_Ard02040 where tax_invoice_direct=''客户'''+@text3+@text1  --客户出库
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  tax_invoice_date<'''+ rtrim(ltrim(@star_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,item_id,0,0,0,0,'
  +'0,0,differ_quant,differ_sum,0,0,count_datetime,1,maintenance_datetime,0,0 from  VIEW_Ivtd01310 where (1=1)  '+@text3+@text1 --盘点数量
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  count_datetime<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and count_flag=''Y'''
  exec(@ssql)

  insert into #temp2 (com_id,item_id,oh_oq,oh_Amount,in_storenum,in_storeAmount,out_storenum,out_storeamount,differ_quant,differ_amount,
  acct_oq,acct_sum,store_date,sid,loss_oq,loss_amount) select com_id,item_id,sum(oh_oq) as oh_oq,sum(oh_Amount) as oh_Amount,
  sum(in_storenum) as in_storenum,sum(in_storeamount) as in_storeAmount,sum(out_storenum) as out_storenum,sum(out_storeamount) as out_storeamount,
  sum(differ_quant) as differ_quant,sum(differ_amount) as differ_amount,(sum(oh_oq)+sum(in_storenum)-sum(out_storenum)-sum(differ_quant)-sum(loss_oq)) as acct_oq,
  (sum(oh_amount)+sum(in_storeamount)-sum(out_storeamount)-sum(differ_amount)-sum(loss_amount)) as acct_amount,getdate(),0 as sid,
  sum(loss_oq) as loss_oq,sum(loss_amount) as loss_amount from #temp1  group by com_id,item_id 

  insert into #temp (com_id,item_id,oh_oq,oh_Amount,in_storenum ,in_storeAmount,out_storenum,out_storeamount,differ_quant,
  differ_amount,acct_oq,acct_sum,store_date,sid,loss_oq,loss_amount) select com_id,item_id,acct_oq,acct_sum,0,0,0,0,0,0,
  acct_oq,acct_sum,store_date,sid,0 loss_oq,0 loss_amount  from #temp2
--小于开始日期@star_date1

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(lead_oq,0),isnull(plan_price,0),'  --委托加工产品入库
  +'0,0,0,0,0,0,send_date,1,mainten_datetime,0,0 from VIEW_Yie05010  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  send_date>='''+ rtrim(ltrim(@star_date1))+''' and  send_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and isnull(comfirm_flag,''N'')=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(lead_oq,0),isnull(plan_price,0),0,0,'  --委托加工材料出库
  +'0,0,send_date,1,mainten_datetime,0,0 from VIEW_Yie05012  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  send_date>='''+ rtrim(ltrim(@star_date1))+''' and  send_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and isnull(comfirm_flag,''N'')=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(rep_qty,0),isnull(st_sum,0),'/*采购入库*/
  +'0,0,0,0,0,0,store_date,1,mainten_datetime,0,0 from View_STDM03001  where  (stock_type=''进货'' or stock_type=''借货'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(rep_qty,0),isnull(st_sum,0),0,0,'
  +'0,0,store_date,1,mainten_datetime,0,0 from View_STDM03001  where  stock_type=''退货'''+@text3+@text1/*采购退货出库*/
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(sd_oq,0),sd_oq*tax_sum_si,0,0,0,0,'/*销售出库*/
  +'so_consign_date,1,mainten_datetime,0,0  from View_sdd02020  where  (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(sd_oq,0),sd_oq*tax_sum_si,0,0,0,0,0,0,'
  +'so_consign_date,1,mainten_datetime,0,0  from View_sdd02020 where sd_order_direct=''退货'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(oper_qty,0),isnull(plan_price,0),'
  +'0,0,0,0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''入库'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(oper_qty,0),isnull(plan_price,0),0,'
  +'0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''出库'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,0,0,0,0,0,0,store_date,1,maintenance_datetime,'
  +'isnull(oper_qty,0),isnull(plan_price,0) from VIEW_ivt01201 where ivt_oper_id=''报损'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)


  select  @ssql=''    --调拨入库，入库单价上：存在同价调拨和变价调拨的区别
  if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='1' --MoveStore_Style='1'同价调拨   
  begin
    select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(oper_qty,0),isnull(plan_price,0),'
             +'0,0,0,0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text
    if  rtrim(ltrim( @store_struct_id1))<>''
      select @ssql= @ssql+' and  corpstorestruct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
      select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    if  rtrim(ltrim( @dept_id1))<>''
      select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
      select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end else if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='0'  --MoveStore_Style='0'变价调拨
  begin
    select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(oper_qty,0),isnull(pass_oq,0), '
             +'0,0,0,0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text
    if  rtrim(ltrim( @store_struct_id1))<>''
      select @ssql= @ssql+' and  corpstorestruct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
      select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    if  rtrim(ltrim( @dept_id1))<>''
      select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
      select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end

  select  @ssql=''  --调拨出库
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(oper_qty,0),isnull(plan_price,0),'
  +'0,0,0,0,store_date,1,maintenance_datetime,0,0 from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(group_oq,0),isnull(group_sum,0),'
  +'0,0,0,0,0,0,so_effect_datetime,1,mainten_datetime,0,0 from ivtd03001  where group_split=''组装''  '+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''  
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(sd_oq,0),isnull(sum_si,0),0,'
  +'0,0,0,so_effect_datetime,1,mainten_datetime,0,0 from VIEW_ivtd03001 where group_split=''组装''  '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''  
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(group_oq,0),isnull(group_sum,0),0,'
  +'0,0,0,so_effect_datetime,1,mainten_datetime,0,0 from ivtd03001  where group_split=''拆卸''  '+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''  
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(sd_oq,0),isnull(sum_si,0),0,0,'
  +'0,0,0,0,so_effect_datetime,1,mainten_datetime,0,0 from VIEW_ivtd03001 where group_split=''拆卸''  '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''  
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,isnull(sd_oq,0),isnull(sum_ti,0),0,'
  +'0,0,0,0,0,tax_invoice_date,1,mainten_datetime,0,0  from VIEW_Ard02040 where tax_invoice_direct=''供货'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and  store_struct_id  like '''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  tax_invoice_date>='''+ rtrim(ltrim(@star_date1))+''' and  tax_invoice_date<='''+rtrim(ltrim(@end_date1))+''''  
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,isnull(sd_oq,0),isnull(sum_ti,0),0,'
  +'0,0,0,tax_invoice_date,1,mainten_datetime,0,0 from VIEW_Ard02040 where tax_invoice_direct=''客户'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  tax_invoice_date>='''+ rtrim(ltrim(@star_date1))+''' and  tax_invoice_date<='''+rtrim(ltrim(@end_date1))+''''  
  if  rtrim(ltrim( @dept_id1))<>''
  select @ssql= @ssql+' and dept_id  like '+''''+rtrim(ltrim( @dept_id1))+'%'''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

--盘点数量
  select  @ssql=''
  select  @ssql='insert into #temp select com_id,item_id,0,0,0,0,0,'
  +'0,differ_quant,differ_sum,0,0,count_datetime,1,maintenance_datetime,0,0 from  VIEW_Ivtd01310 where (1=1)  '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id  like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  count_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  count_datetime<='''+rtrim(ltrim(@end_date1))+''''
  select @ssql= @ssql+'  and count_flag=''Y'' '
  exec(@ssql)

--作合并
  insert into #temp3 (com_id,item_id,peijian_id,oh_oq,oh_Amount,in_storenum,in_storeAmount,out_storenum,out_storeamount,
  differ_quant,differ_amount,acct_oq,acct_sum,store_date,sid,loss_oq,loss_amount) select com_id,item_id,
  (select peijian_id from ctl03001 where item_id=#temp.item_id),oh_oq,oh_Amount,in_storenum,in_storeAmount,
  out_storenum,out_storeamount,differ_quant,differ_amount,acct_oq,acct_sum,store_date,sid,loss_oq,loss_amount  from #temp 
   
  select  @ssql='' 
  select  @ssql='insert into #temp4 (com_id,item_id,peijian_id,oh_oq,oh_Amount,in_storenum,in_storeAmount,out_storenum,out_storeamount,
  differ_quant,differ_amount,loss_oq,loss_amount,acct_oq,acct_amount) 
  select com_id,item_id,peijian_id,sum(oh_oq) as oh_oq,sum(oh_Amount) as oh_Amount,sum(in_storenum) as in_storenum,'
  +'sum(in_storeamount) as in_storeamount,sum(out_storenum) as out_storenum,sum(out_storeamount) as out_storeamount,'
  +'sum(differ_quant) as differ_quant,sum(differ_amount) as differ_amount,sum(loss_oq) as loss_oq,'
  +'sum(loss_amount) as loss_amount,(sum(oh_oq)+sum(in_storenum)-sum(out_storenum)-sum(differ_quant)-sum(loss_oq)) as acct_oq,'
  +'(sum(oh_amount)+sum(in_storeamount)-sum(out_storeamount)-sum(differ_amount)-sum(loss_amount)) as acct_amount from #temp3 '
  +' group  by   com_id,item_id,peijian_id  '
  exec(@ssql)

  select  @ssql='' 
  select  @ssql='select com_id,item_id,peijian_id,oh_oq,oh_Amount,in_storenum,in_storeamount,out_storenum,out_storeamount,'
  +'differ_quant,differ_amount,loss_oq,loss_amount,acct_oq,acct_amount,order0=0  from #temp4 '
  if ltrim(rtrim(@zero))='1'
  select @ssql=@ssql+' where isnull(acct_oq,0)<>0 '
  select @ssql=@ssql+'union all select com_id=null,item_id=''合计'',peijian_id=null,sum(oh_oq) as oh_oq,sum(oh_Amount) as oh_Amount,'
  +'sum(in_storenum) as in_storenum ,sum(in_storeamount) as in_storeamount,sum(out_storenum) as out_storenum,'
  +'sum(out_storeamount) as out_storeamount,sum(differ_quant) as differ_quant,sum(differ_amount) as differ_amount,sum(loss_oq) as loss_oq,'
  +'sum(loss_amount) as loss_amount,sum(acct_oq) as acct_oq,sum(acct_amount) as acct_amount,order0=1 from #temp4 group by com_id 
   order by order0,peijian_id'
  exec(@ssql)
  
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_stopoutkeep
return 0
end else
begin
COMMIT TRANSACTION mytranSp_stopoutkeep
return 1
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

