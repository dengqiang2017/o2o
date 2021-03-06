if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_StoreOperQuery]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StoreOperQuery]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--收发存流水帐
CREATE        PROCEDURE sp_StoreOperQuery
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
       @item_name1 varchar(50),
       @item_type varchar(30),
       @get_store varchar(3000),
       @get_instore varchar(3000)
)
AS 
BEGIN TRANSACTION mytranSp_StoreOperQuery 
    declare @text varchar(8000),@text1 varchar(8000),@text3 varchar(8000),@ssql varchar(8000),
    @store_struct_id varchar(30),@dept_id varchar(30),@clerk_id varchar(35),@item_id varchar(40),@ivt_oper_listing varchar(30),
    @com_id char(10),@oh_oq decimal(17,2),@oper_type varchar(20),@seeds_id int,@surplus_sum12 decimal(17,2),@peijian_id varchar(40),
    @oh_Amount decimal(17,2),@in_storenum decimal(17,2),@in_storeAmount decimal(17,2),@out_storenum decimal(17,2),
    @acct_oq decimal(17,2),@acct_price decimal(17,2),@acct_sum decimal(17,2),@store_date datetime,@surplus_oq12 decimal(17,2),
    @differ_quant decimal(17,2),@loss_oq decimal(17,2),@in_price decimal(17,2),@out_price decimal(17,2),@differ_price decimal(17,2),
    @loss_price decimal(17,2),
    @out_storeamount decimal(17,2),@differ_amount decimal(17,2),@acct_amount decimal(17,2),@loss_amount decimal(17,2)

select @text3='',@text1='',@text=''
select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id1))+''''
if  rtrim(ltrim(@type_id1))<>''
  select @text3= @text3+' and item_id in (select item_id from ctl03001 where com_id='''+@com_id1
    +''' and type_id  like '''+rtrim(ltrim(@type_id1))+'%'')'
if  rtrim(ltrim( @dept_id1))<>''
  select @text3= @text3+' and dept_id like '+''''+rtrim(ltrim( @dept_id1))+'%'''
if rtrim(ltrim( @clerk_id1))<>''
  select @text3=@text3+' and  clerk_id='+''''+rtrim(ltrim( @clerk_id1))+''''
if  rtrim(ltrim(@item_id1))<>''
  select @text3= @text3+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
if rtrim(ltrim(isnull(@vendor_id,'')))<>''
     select @text3=@text3+'  and item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id1))+''''+'  and  rtrim(ltrim(vendor_id))  like '''+rtrim(ltrim(@vendor_id)) +'%'') ' 

--if rtrim(ltrim(isnull(@item_name1,'''')))<>''
--     select @text3=@text3+'  and rtrim(ltrim(isnull(item_id,''''))) in (select rtrim(ltrim(isnull(item_id,'''')))  from ctl03001 where com_id='+''''
--     + rtrim(ltrim(@com_id1))+''''+'  and  rtrim(ltrim(isnull(item_name,'''')))  like ''% '+rtrim(ltrim(isnull(@item_name1,'')))+'%'') '
--if rtrim(ltrim(isnull(@item_type,'''')))<>''
--     select @text3=@text3+'  and rtrim(ltrim(isnull(item_id,''''))) in (select rtrim(ltrim(isnull(item_id,'''')))  from ctl03001 where com_id='+''''
--     + rtrim(ltrim(@com_id1))+''''+'  and  rtrim(ltrim(isnull(item_type,'''')))  like '''+rtrim(ltrim(isnull(@item_type,'')))+'%'') '

--开始：仓位权限
  if ltrim(rtrim(@get_store))<>''  select @text1=@text1+' '+ltrim(rtrim(@get_store))+' '  --普通仓位
  if ltrim(rtrim(@get_instore))<>''  select @text=@text+' '+ltrim(rtrim(@get_instore))+' '  --调拨入库仓位
--结束：仓位权限

  create table #temp1 (com_id char(10),store_struct_id varchar(30),dept_id varchar(30),clerk_id  varchar(35),
  item_id varchar(40),oh_oq decimal(17,2),in_storenum decimal(17,2),out_storenum decimal(17,2),differ_quant decimal(17,2),
  acct_oq decimal(17,2),ivt_oper_listing varchar(30),oper_type varchar(20),store_date datetime,seeds_id int,
  maintenance_datetime datetime,sd_order_id varchar(30),customer_id varchar(30),vendor_id varchar(30),no_id int,loss_oq decimal(17,2),
  oh_amount decimal(17,2),in_storeamount decimal(17,2),out_storeamount decimal(17,2),differ_amount decimal(17,2),
  acct_amount decimal(17,2),loss_amount decimal(17,2),in_price decimal(17,2),out_price decimal(17,2),differ_price decimal(17,2),
  loss_price decimal(17,2),pack_num decimal(17,6),pack_unit varchar(30),oddment_num decimal(17,6))

  create table #temp2 (com_id char(10),store_struct_id varchar(30),dept_id varchar(30),clerk_id  varchar(35),
  item_id varchar(40),oh_oq decimal(17,2),in_storenum decimal(17,2),out_storenum decimal(17,2),differ_quant decimal(17,2),
  acct_oq decimal(17,2),ivt_oper_listing varchar(30),oper_type varchar(20),store_date datetime,seeds_id int,
  maintenance_datetime datetime,sd_order_id varchar(30),customer_id varchar(30),vendor_id varchar(30),no_id int,loss_oq decimal(17,2),
  oh_amount decimal(17,2),in_storeamount decimal(17,2),out_storeamount decimal(17,2),differ_amount decimal(17,2),
  acct_amount decimal(17,2),loss_amount decimal(17,2),in_price decimal(17,2),out_price decimal(17,2),differ_price decimal(17,2),
  loss_price decimal(17,2),pack_num decimal(17,6),pack_unit varchar(30),oddment_num decimal(17,6))

  create table #temp3 (com_id char(10),store_struct_id varchar(30),dept_id varchar(30),clerk_id  varchar(35),
  item_id varchar(40),oh_oq decimal(17,2),in_storenum decimal(17,2),out_storenum decimal(17,2),differ_quant decimal(17,2),
  acct_oq decimal(17,2),ivt_oper_listing varchar(30),oper_type varchar(20),store_date datetime,seeds_id int,
  maintenance_datetime datetime,sd_order_id varchar(30),customer_id varchar(30),vendor_id varchar(30),no_id int,loss_oq decimal(17,2),
  oh_amount decimal(17,2),in_storeamount decimal(17,2),out_storeamount decimal(17,2),differ_amount decimal(17,2),
  acct_amount decimal(17,2),loss_amount decimal(17,2),in_price decimal(17,2),out_price decimal(17,2),differ_price decimal(17,2),
  loss_price decimal(17,2),pack_num decimal(17,6),pack_unit varchar(30),oddment_num decimal(17,6))

  select @ssql=''
  select @ssql=' insert into #temp1 select com_id,store_struct_id,'''','''',item_id,oh,0,0,0,oh,''期初'','''','
  +'maintenance_datetime,0,maintenance_datetime,'''','''','''',-1,0,i_Amount,0,0,0,i_Amount,0,0,0,0,0,pack_num,pack_unit,oddment_num  '
  +'from ivtd01300 where  com_id='''+ rtrim(ltrim(@com_id1))+''''
  if  rtrim(ltrim( @store_struct_id1))<>''
   select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  if  rtrim(ltrim(@type_id1))<>''
   select @ssql= @ssql+' and item_id in (select item_id  from ctl03001 where com_id='+''''
   + rtrim(ltrim(@com_id1))+''''+'  and  type_id  like '''+@type_id1+'%'')'
  if  rtrim(ltrim(@item_id1))<>''
   select @ssql= @ssql+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
  if rtrim(ltrim(@vendor_id))<>''
     select @ssql=@ssql+'  and item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id1))+''''+'  and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'')'
   select @ssql=@ssql+'  and initial_flag=''Y'' '+@text1
   exec(@ssql)
--委托加工产品入库
  select @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,isnull(lead_oq,0),0,0,0,'
  +'ivt_oper_listing, ''委托加工'' as oper_type,'
  +'send_date,seeds_idYie05011,mainten_datetime,sd_order_id,'''',vendor_id,12,0,0,isnull(plan_price,0),0,0,0,0,isnull(oper_price,0),0,0,0,0 as pack_num,'''' as pack_unit,0 as oddment_num '
  +' from VIEW_Yie05010  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  send_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

--委托加工材料出库
  select @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,isnull(lead_oq,0),0,0,'
  +'ivt_oper_listing, ''委托加工'' as oper_type,'
  +'send_date,seeds_idYie05012,mainten_datetime,sd_order_id,'''',vendor_id,12,0,0,0,isnull(plan_price,0),0,0,0,isnull(oper_price,0),0,0,0,0 as pack_num,'''' as pack_unit,0 as oddment_num '
  +' from VIEW_Yie05012  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  send_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,rep_qty,0,0,0,'
  +'rcv_auto_no, (case  when isnull(rej_flag,'''')=''1'' then  ''挂帐采购'' else ''现款采购'' end) as oper_type,'
  +'store_date,seeds_id,mainten_datetime,rcv_hw_no,'''',vendor_id,0,0,0,st_sum,0,0,0,0,0,0,0,0,pack_num,pack_unit,oddment_num '
  +' from View_STDM03001  where (stock_type=''进货'' or stock_type=''借货'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,rep_qty,0,0,'
  +'rcv_auto_no,''采购退货'',store_date,seeds_id,mainten_datetime,rcv_hw_no,'''',vendor_id,1,0,0,0,st_sum,0,0,0,0,0,0,0,'
  +'pack_num,pack_unit,oddment_num  from View_STDM03001  where  stock_type=''退货'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,sd_oq,0,0,'
  +'ivt_oper_listing,(case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as oper_type,'
  +'so_consign_date,seeds_id,mainten_datetime,sd_order_id,customer_id,'''',2,0,0,0,sd_oq*tax_sum_si,0,0,0,0,0,0,0'
  +',pack_num,pack_unit,send_qty  from View_sdd02020  where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date1))+''' '
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)
 
  select @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,sd_oq,0,0,0,ivt_oper_listing,'
  +'''销售退货'',so_consign_date,seeds_id,mainten_datetime,sd_order_id,customer_id,'''',3,0,0,sd_oq*tax_sum_si,0,0,0,0,0,0,0,0,'
  +'pack_num,pack_unit,send_qty from View_sdd02020  where  sd_order_direct=''退货'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  so_consign_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,dept_id,clerk_id,item_id,0,oper_qty,0,0,0,ivt_oper_listing,'
  +'''其他入库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',4,0,0,plan_price,0,0,0,0,0,0,0,0,pack_num,pack_unit,'
  +'oddment_num  from VIEW_ivt01201  where  ivt_oper_id=''入库'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''' ' 
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,oper_qty,0,0,ivt_oper_listing,'
  +'''其他出库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',5,0,0,0,plan_price,0,0,0,0,0,0,0,pack_num,pack_unit,'
  +'oddment_num  from VIEW_ivt01201 where ivt_oper_id=''出库'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,0,0,0,ivt_oper_listing,'
  +'''库存报损'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',10,oper_qty,0,0,0,0,0,plan_price,0,0,0,0,pack_num,'
  +'pack_unit,oddment_num  from VIEW_ivt01201 where ivt_oper_id=''报损'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,oper_qty,0,0,ivt_oper_listing,'
  +'''调拨出库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',6,0,0,0,plan_price,0,0,0,0,0,0,0,pack_num,'
  +'pack_unit,oddment_num  from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''' '
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''    --调拨入库，入库单价上：存在同价调拨和变价调拨的区别
  if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='1' --MoveStore_Style='1'同价调拨:plan_price/oper_price调:入金额/单价   
  begin
    select  @ssql='insert into #temp1  select com_id,corpstorestruct_id,dept_id,clerk_id,item_id,0,oper_qty,0,0,0,ivt_oper_listing,'
    +'''调拨入库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',6,0,0,plan_price,0,0,0,0,0,0,0,0,pack_num,pack_unit,'
    +'oddment_num   from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text 
    if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and corpstorestruct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''' '
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end else if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='0'  --MoveStore_Style='0'变价调拨:pass_oq/base_oq:调入金额/单价
  begin
    select  @ssql='insert into #temp1  select com_id,corpstorestruct_id,dept_id,clerk_id,item_id,0,oper_qty,0,0,0,ivt_oper_listing,'
    +'''调拨入库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',6,0,0,pass_oq,0,0,0,0,0,0,0,0,pack_num,pack_unit,'
    +'oddment_num   from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text 
    if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and corpstorestruct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date<'''+ rtrim(ltrim(@star_date1))+''' '
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,isnull(group_oq,0),0,0,0,ivt_oper_listing,'
  +'''组装入库'',so_effect_datetime,3,mainten_datetime,sd_order_id,'''','''',8,0,0,group_sum,0,0,0,0,0,0,0,0,0,'''',0 '
  +'  from ivtd03001  where group_split=''组装'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''' '  
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,isnull(sd_oq,0),0,0,ivt_oper_listing,'
  +'''组装出库'',so_effect_datetime,seeds_id,mainten_datetime,sd_order_id,'''','''',8,0,0,0,sum_si,0,0,0,0,0,0,0,pack_num,pack_unit,'
  +'oddment_num  from VIEW_ivtd03001  where group_split=''组装'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''' '  
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,isnull(group_oq,0),0,0,ivt_oper_listing,'
  +'''拆卸出库'',so_effect_datetime,5,mainten_datetime,sd_order_id,'''','''',9,0,0,0,group_sum,0,0,0,0,0,0,0,0,'''',0  from ivtd03001  where group_split=''拆卸'''
  +@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''' '  
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,isnull(sd_oq,0),0,0,0,ivt_oper_listing,'
  +'''拆卸入库'',so_effect_datetime,seeds_id,mainten_datetime,sd_order_id,'''','''',9,0,0,sum_si,0,0,0,0,0,0,0,0,pack_num,pack_unit,'
  +'oddment_num  from VIEW_ivtd03001  where group_split=''拆卸'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id   like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime<'''+ rtrim(ltrim(@star_date1))+''' ' 
    select @ssql= @ssql+'  and comfirm_flag=''Y''' 
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,sd_order_id,dept_id,clerk_id,item_id,0,0,sd_oq,0,0,auto_tax_invoice_id,'
  +'''客户让利'',tax_invoice_date,SEEDS_ID,mainten_datetime,tax_invoice_id,'''','''',11,0,0,0,sum_ti,0,0,0,0,0,0,0,pack_num,'
  +'pack_unit,oddment_num  from VIEW_Ard02040 where tax_invoice_direct=''客户'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  tax_invoice_date<'''+ rtrim(ltrim(@star_date1))+''' '
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1  select com_id,sd_order_id,dept_id,clerk_id,item_id,0,sd_oq,0,0,0,auto_tax_invoice_id,'
  +'''供货商返利'',tax_invoice_date,SEEDS_ID,mainten_datetime,tax_invoice_id,'''','''',11,0,0,sum_ti,0,0,0,0,0,0,0,0,pack_num,'
  +'pack_unit,oddment_num   from VIEW_Ard02040 where tax_invoice_direct=''供货'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  tax_invoice_date<'''+ rtrim(ltrim(@star_date1))+''' '
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)


  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,'''',clerk_id,item_id,0,0,0,differ_quant,'
  +'0,ivt_oper_listing,''库存盘点'',count_datetime,3,maintenance_datetime,sd_order_id,'''','''',7,0,0,0,0,differ_sum,0,0,0,0,'
  +'0,0,pack_num,pack_unit,oddment_num  from  VIEW_Ivtd01310 where (1=1)  '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  count_datetime<'''+ rtrim(ltrim(@star_date1))+''''
    select @ssql= @ssql+'  and count_flag=''Y'' '
  exec(@ssql)
/*
  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,'''',clerk_id,item_id,0,0,0,differ_quant,'
  +'0,ivt_oper_listing,''库存盘点'',count_datetime,3,maintenance_datetime,sd_order_id,'''','''',7,0,0,0,0,differ_sum,0,0,0,0,'
  +'0,0,pack_num,pack_unit,oddment_num  from  VIEW_Ivtd01310 where com_id='''
  + rtrim(ltrim(@com_id1))+''''
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  count_datetime<'''+ rtrim(ltrim(@star_date1))+''''
  if rtrim(ltrim( @clerk_id1))<>''
   select @ssql=@ssql+' and  clerk_id='+''''+rtrim(ltrim( @clerk_id1))+''''
  if  rtrim(ltrim(@item_id1))<>''
   select @ssql= @ssql+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
  if rtrim(ltrim(@vendor_id))<>''
        select @ssql=@ssql+'  and item_id in (select item_id  from ctl03001 where com_id='+''''
        + rtrim(ltrim(@com_id1))+''''+'  and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'')'
  if rtrim(ltrim(@type_id1))<>''
        select @ssql= @ssql+' and item_id in (select item_id from ctl03001 where com_id='''+@com_id1
        +''' and type_id  like '''+rtrim(ltrim(@type_id1))+'%'')'
  select @ssql= @ssql+'  and count_flag=''Y'' '+@text1
  exec(@ssql)
*/
  insert into #temp2 (com_id,item_id,oh_oq,in_storenum,out_storenum,differ_quant,acct_oq,loss_oq,oh_amount,in_storeamount,
  out_storeamount,differ_amount,acct_amount,loss_amount)  select com_id,item_id,sum(oh_oq),sum(in_storenum),sum(out_storenum),
  sum(differ_quant),(sum(oh_oq)+sum(in_storenum)-sum(out_storenum)-sum(differ_quant)-sum(loss_oq)) as acct_oq,
  sum(loss_oq) as loss_oq,sum(oh_amount) as oh_amount,sum(in_storeamount) as in_storeamount,sum(out_storeamount) as out_storeamount,
  sum(differ_amount) as differ_amount,(sum(oh_amount)+sum(in_storeamount)-sum(out_storeamount)-sum(differ_amount)-sum(loss_amount)) as acct_amount,
  sum(loss_amount) as loss_amount from #temp1  group by com_id,item_id  

  insert into #temp3 (com_id,store_struct_id,item_id,oh_oq,in_storenum,out_storenum,differ_quant,acct_oq,seeds_id,
  store_date,maintenance_datetime,oper_type,ivt_oper_listing,sd_order_id,loss_oq,oh_amount,in_storeamount,out_storeamount,
  differ_amount,acct_amount,loss_amount) select com_id,store_struct_id,item_id,0,0,0,0,acct_oq,0,'','','上期结余','上期结余','上期结余',
  0,0,0,0,0,acct_amount,0  from #temp2

--委托加工产品入库
  select @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,isnull(lead_oq,0),0,0,0,'
  +'ivt_oper_listing, ''委托加工'' as oper_type,'
  +'send_date,seeds_idYie05011,mainten_datetime,sd_order_id,'''',vendor_id,12,0,0,isnull(plan_price,0),0,0,0,0,isnull(oper_price,0),0,0,0,0 as pack_num,'''' as pack_unit,0 as oddment_num '
  +' from VIEW_Yie05010  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  send_date>='''+ rtrim(ltrim(@star_date1))+''' and  send_date<='''+rtrim(ltrim(@end_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

--委托加工材料出库
  select @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,isnull(lead_oq,0),0,0,'
  +'ivt_oper_listing, ''委托加工'' as oper_type,'
  +'send_date,seeds_idYie05012,mainten_datetime,sd_order_id,'''',vendor_id,12,0,0,0,isnull(plan_price,0),0,0,0,0,isnull(oper_price,0),0,0,0 as pack_num,'''' as pack_unit,0 as oddment_num '
  +' from VIEW_Yie05012  where 1=1 '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  send_date>='''+ rtrim(ltrim(@star_date1))+''' and  send_date<='''+rtrim(ltrim(@end_date1))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,rep_qty,0,0,0,'
  +'rcv_auto_no, (case  when isnull(rej_flag,'''')=''1'' then  ''挂帐采购'' else ''现款采购'' end) as oper_type,'
  +'store_date,seeds_id,mainten_datetime,rcv_hw_no,'''',vendor_id,0,0,0,st_sum,0,0,0,0,price,0,0,0,pack_num,pack_unit,'
  +'oddment_num  from View_STDM03001  where (stock_type=''进货'' or stock_type=''借货'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,rep_qty,0,0,rcv_auto_no,'
  +'''采购退货'',store_date,seeds_id,mainten_datetime,rcv_hw_no,'''',vendor_id,1,0,0,0,st_sum,0,0,0,0,price,0,0,pack_num,'
  +'pack_unit,oddment_num   from View_STDM03001  where  stock_type=''退货'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,sd_oq,0,0,'
  +'ivt_oper_listing,(case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as oper_type,'
  +'so_consign_date,seeds_id,mainten_datetime,sd_order_id,customer_id,'''',2,0,0,0,sd_oq*tax_sum_si,0,0,0,0,tax_sum_si,0,0,'
  +'pack_num,pack_unit,send_qty  from View_sdd02020  where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)
 
  select @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,sd_oq,0,0,0,'
  +'ivt_oper_listing,''销售退货'',so_consign_date,seeds_id,mainten_datetime,sd_order_id,customer_id,'''',3,0,0,sd_oq*tax_sum_si,0,0,'
  +'0,0,tax_sum_si,0,0,0,pack_num,pack_unit,send_qty  from View_sdd02020  where  sd_order_direct=''退货'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select  @ssql='insert into #temp3 select com_id,store_struct_id,dept_id,clerk_id,item_id,0,oper_qty,0,0,0,'
  +'ivt_oper_listing,''其他入库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',4,0,0,plan_price,0,0,0,0,'
  +'oper_price,0,0,0,pack_num,pack_unit,oddment_num  from VIEW_ivt01201  where  ivt_oper_id=''入库'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3 select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,oper_qty,0,0,'
  +'ivt_oper_listing,''其他出库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',5,0,0,0,plan_price,0,0,0,0,'
  +'oper_price,0,0,pack_num,pack_unit,oddment_num   from VIEW_ivt01201 where ivt_oper_id=''出库'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3 select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,0,0,0,'
  +'ivt_oper_listing,''库存报损'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',10,oper_qty,0,0,0,0,0,'
  +'plan_price,0,0,0,oper_price,pack_num,pack_unit,oddment_num from VIEW_ivt01201 where ivt_oper_id=''报损'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,oper_qty,0,0,'
  +'ivt_oper_listing,''调拨出库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',6,0,0,0,plan_price,0,0,0,0,'
  +'oper_price,0,0,pack_num,pack_unit,oddment_num  from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''    --调拨入库，入库单价上：存在同价调拨和变价调拨的区别
  if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='1' --MoveStore_Style='1'同价调拨:plan_price/oper_price调:入金额/单价   
  begin
    select  @ssql='insert into #temp3  select com_id,corpstorestruct_id,dept_id,clerk_id,item_id,0,oper_qty,0,0,0,'
    +'ivt_oper_listing,''调拨入库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',6,0,0,plan_price,0,0,0,0,'
    +'oper_price,0,0,0,pack_num,pack_unit,oddment_num  from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text 
    if  rtrim(ltrim( @store_struct_id1))<>''
      select @ssql= @ssql+' and corpstorestruct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
      select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
      select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end else if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id1 )='0'  --MoveStore_Style='0'变价调拨:pass_oq/base_oq:调入金额/单价
  begin
    select  @ssql='insert into #temp3  select com_id,corpstorestruct_id,dept_id,clerk_id,item_id,0,oper_qty,0,0,0,'
    +'ivt_oper_listing,''调拨入库'',store_date,sID,maintenance_datetime,sd_order_id,'''','''',6,0,0,pass_oq,0,0,0,0,'
    +'base_oq,0,0,0,pack_num,pack_unit,oddment_num  from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3+@text 
    if  rtrim(ltrim( @store_struct_id1))<>''
      select @ssql= @ssql+' and corpstorestruct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
      select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
      select @ssql= @ssql+'  and comfirm_flag=''Y'''
    exec(@ssql)
  end

  select  @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,isnull(group_oq,0),0,0,0,'
  +'ivt_oper_listing,''组装入库'',so_effect_datetime,3,mainten_datetime,sd_order_id,'''','''',8,0,0,group_sum,0,0,0,0,'
  +'group_cost,0,0,0,0,'''',0   from ivtd03001  where group_split=''组装'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,isnull(sd_oq,0),0,0,'
  +'ivt_oper_listing,''组装出库'',so_effect_datetime,seeds_id,mainten_datetime,sd_order_id,'''','''',8,0,0,0,sum_si,0,0,0,0,'
  +'sd_unit_price,0,0,pack_num,pack_unit,oddment_num   from VIEW_ivtd03001  where group_split=''组装'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,0,isnull(group_oq,0),0,0,'
  +'ivt_oper_listing,''拆卸出库'',so_effect_datetime,5,mainten_datetime,sd_order_id,'''','''',9,0,0,0,group_sum,0,0,0,0,'
  +'group_cost,0,0,0,'''',0  from ivtd03001  where group_split=''拆卸'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3  select com_id,store_struct_id,dept_id,clerk_id,item_id,0,isnull(sd_oq,0),0,0,0,'
  +'ivt_oper_listing,''拆卸入库'',so_effect_datetime,seeds_id,mainten_datetime,sd_order_id,'''','''',9,0,0,sum_si,0,0,0,0,'
  +'sd_unit_price,0,0,0,pack_num,pack_unit,oddment_num  from VIEW_ivtd03001  where group_split=''拆卸'''+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  so_effect_datetime>='''+ rtrim(ltrim(@star_date1))+''' and  so_effect_datetime<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3 select com_id,sd_order_id,dept_id,clerk_id,item_id,0,0,sd_oq,0,0,auto_tax_invoice_id,'
  +'''客户让利'',tax_invoice_date,SEEDS_ID,mainten_datetime,tax_invoice_id,'''','''',11,0,0,0,sum_ti,0,0,0,0,sd_unit_price,0,0'
  +',pack_num,pack_unit,oddment_num   from VIEW_Ard02040 where tax_invoice_direct=''客户'''+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  tax_invoice_date>='''+ rtrim(ltrim(@star_date1))+''' and  tax_invoice_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3  select com_id,sd_order_id,dept_id,clerk_id,item_id,0,sd_oq,0,0,0,auto_tax_invoice_id,'
  +'''供货商返利'',tax_invoice_date,SEEDS_ID,mainten_datetime,tax_invoice_id,'''','''',11,0,0,sum_ti,0,0,0,0,sd_unit_price,0,0,0'
  +',pack_num,pack_unit,oddment_num    from VIEW_Ard02040 where tax_invoice_direct=''供货'' '+@text3+@text1 
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  tax_invoice_date>='''+ rtrim(ltrim(@star_date1))+''' and  tax_invoice_date<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp3 select com_id,store_struct_id,'''',clerk_id,item_id,0,0,0,differ_quant,'
  +'0,ivt_oper_listing,''库存盘点'',count_datetime,3,maintenance_datetime,sd_order_id,'''','''',7,0,0,0,0,differ_sum,'
  +'0,0,0,0,counted_price,0,pack_num,pack_unit,oddment_num   from  VIEW_Ivtd01310 where (1=1)  '+@text3+@text1
  if  rtrim(ltrim( @store_struct_id1))<>''
    select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
    select @ssql=@ssql+' and  count_datetime>='''+ rtrim(ltrim(@star_date1))+''' and count_datetime<='''+rtrim(ltrim(@end_date1))+''''
    select @ssql= @ssql+'  and count_flag=''Y'' '
  exec(@ssql)
/*
  select  @ssql=''
  select  @ssql='insert into #temp3 select com_id,store_struct_id,'''',clerk_id,item_id,0,0,0,differ_quant,'
  +'0,ivt_oper_listing,''库存盘点'',count_datetime,3,maintenance_datetime,sd_order_id,'''','''',7,0,0,0,0,differ_sum,'
  +'0,0,0,0,counted_price,0,pack_num,pack_unit,oddment_num   from  VIEW_Ivtd01310 where com_id='''
  + rtrim(ltrim(@com_id1))+''' '
  if  rtrim(ltrim( @store_struct_id1))<>''
  select @ssql= @ssql+' and store_struct_id like '+''''+rtrim(ltrim( @store_struct_id1))+'%'''
  select @ssql=@ssql+' and  count_datetime>='''+ rtrim(ltrim(@star_date1))+''' and count_datetime<='''+rtrim(ltrim(@end_date1))+''''
  if rtrim(ltrim( @clerk_id1))<>''
   select @ssql=@ssql+' and  clerk_id='+''''+rtrim(ltrim( @clerk_id1))+''''
  if  rtrim(ltrim(@item_id1))<>''
   select @ssql= @ssql+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
  if rtrim(ltrim(@vendor_id))<>''
     select @ssql=@ssql+'  and item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id1))+''''+'  and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'')'
  if rtrim(ltrim(@type_id1))<>''
     select @ssql= @ssql+' and item_id in (select item_id from ctl03001 where com_id='''+@com_id1
    +''' and type_id  like '''+rtrim(ltrim(@type_id1))+'%'')'
  select @ssql= @ssql+'  and count_flag=''Y'' '
  exec(@ssql)
*/
 declare mycur1  CURSOR FOR 
        select a.com_id,a.store_struct_id,a.dept_id,a.clerk_id,a.item_id,isnull(a.oh_oq,0),isnull(a.in_storenum,0),
        isnull(a.out_storenum,0),isnull(a.differ_quant,0),isnull(a.acct_oq,0),a.ivt_oper_listing,
        a.oper_type,a.store_date,a.seeds_id,isnull(a.loss_oq,0),isnull(a.oh_amount,0),isnull(a.in_storeamount,0),
        isnull(a.out_storeamount,0),isnull(a.differ_amount,0),isnull(a.acct_amount,0),isnull(a.loss_amount,0)
        from #temp3  a   order by item_id,store_date,maintenance_datetime,seeds_id
  OPEN mycur1
    FETCH NEXT FROM mycur1 
      INTO @com_id,@store_struct_id,@dept_id,@clerk_id,@item_id,@oh_oq,@in_storenum,@out_storenum,@differ_quant,@acct_oq,
      @ivt_oper_listing,@oper_type,@store_date,@seeds_id,@loss_oq,@oh_amount,@in_storeamount, @out_storeamount,
      @differ_amount,@acct_amount,@loss_amount
  set @peijian_id=@item_id 
  select @surplus_sum12=@acct_amount
  select @surplus_oq12=@acct_oq
  WHILE @@FETCH_STATUS = 0
  begin
     update #temp3 set acct_oq=@surplus_oq12+@in_storenum-@out_storenum-@differ_quant-@loss_oq,
     acct_amount=@surplus_sum12+@in_storeamount-@out_storeamount-@differ_amount-@loss_amount from #temp3 
     where com_id=@com_id and isnull(ivt_oper_listing,'')=rtrim(ltrim(@ivt_oper_listing)) and item_id=@item_id
     and oper_type=@oper_type and seeds_id=@seeds_id 
    
     select @surplus_oq12=isnull(acct_oq,0),@surplus_sum12=isnull(acct_amount,0) from #temp3 where com_id=@com_id and 
     isnull(ivt_oper_listing,'')=rtrim(ltrim(@ivt_oper_listing)) and item_id=@item_id  and oper_type=@oper_type and seeds_id=@seeds_id 
     
     set @peijian_id=@item_id 
    
    FETCH NEXT FROM mycur1 
      INTO @com_id,@store_struct_id,@dept_id,@clerk_id,@item_id,@oh_oq,@in_storenum,@out_storenum,@differ_quant,@acct_oq,
      @ivt_oper_listing,@oper_type,@store_date,@seeds_id,@loss_oq,@oh_amount,@in_storeamount, @out_storeamount,
      @differ_amount,@acct_amount,@loss_amount

      if ltrim(rtrim(@peijian_id))<>ltrim(rtrim(@item_id))
      begin
        select @surplus_oq12=@acct_oq
        select @surplus_sum12=@acct_amount
      end
    end
  CLOSE mycur1       
  DEALLOCATE mycur1 
  
  select @ssql=''
  select  @ssql='select  *  from #temp3 order by item_id,(select peijian_id from ctl03001 where item_id=#temp3.item_id),store_date,maintenance_datetime,seeds_id'
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_StoreOperQuery
return 0
end else
begin
COMMIT TRANSACTION mytranSp_StoreOperQuery
return 1
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

