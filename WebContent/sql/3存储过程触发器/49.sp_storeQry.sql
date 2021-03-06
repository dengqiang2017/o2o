if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_storeQry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_storeQry]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--库存数量及成本:
CREATE  PROCEDURE sp_storeQry
(
       @com_id char(10),
       @finacial_y char(10), 
       @finacial_m char(10),
       @store_struct_id varchar(30),
       @type_id varchar(30),
       @item_id varchar(40),
       @item_spec varchar(40),
       @item_type varchar(40),
       @vendor_id varchar(40),
       @get_store varchar(3000),
       @get_instore varchar(3000)
)
AS 
BEGIN TRANSACTION mytranSp_storeQry
    declare @text varchar(8000),@text1 varchar(8000),@text3 varchar(8000),@ssql varchar(4000),
          @peijian_id varchar(40),@oh decimal(28,6),@accn_ivt decimal(28,6),@i_price decimal(28,6),@i_Amount decimal(28,6),
          @com_id1 char(10),@store_struct_id1 varchar(30),@item_id1 varchar(40),@peijian_id1 varchar(40),
          @oh1 decimal(28,6),@accn_ivt1 decimal(28,6),@i_price1 decimal(28,6),@i_Amount1 decimal(28,6)

  create table #temp (com_id char(10),store_struct_id  varchar(30),item_id char(40),peijian_id char(40),
  pack_num decimal(28,6),pack_unit varchar(30),oddment_num decimal(28,6),accn_ivt decimal(28,6),
  i_price decimal(28,6),i_Amount decimal(28,6))

  create table #temp1 (com_id char(10),store_struct_id  varchar(30),item_id char(40),peijian_id char(40),
  pack_num decimal(28,6),pack_unit varchar(30),oddment_num decimal(28,6),accn_ivt decimal(28,6),
  i_price decimal(28,6),i_Amount decimal(28,6))

select @text3='',@text1='',@text=''
select @text3='  and  a.com_id='+''''+ rtrim(ltrim(@com_id))+''''
if  rtrim(ltrim( @store_struct_id))<>''
  select @text3= @text3+' and a.store_struct_id like '+''''+rtrim(ltrim( @store_struct_id))+'%'''
if  rtrim(ltrim(@item_id))<>''
  select @text3= @text3+' and a.item_id='''+ rtrim(ltrim(@item_id))+''''
if rtrim(ltrim(@type_id))<>'' 
  select @text3=@text3+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id))+''''+'  and  type_id  like '''+@type_id+'%'')'
if rtrim(ltrim(@item_spec))<>'' --规格 
  select @text3=@text3+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id))+''''+'  and  item_spec  like '''+@item_spec+'%'')'
if rtrim(ltrim(@item_type))<>'' --型号
  select @text3=@text3+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id))+''''+'  and  item_type  like '''+@item_type+'%'')'
if rtrim(ltrim(@vendor_id))<>'' --产地
  select @text3=@text3+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id))+''''+'  and  vendor_id  like '''+@vendor_id+'%'')'
--销售属性=实物物品的
--select @text3=@text3+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
--  + rtrim(ltrim(@com_id))+''''+'  and  ltrim(rtrim(isnull(sales_property,'''')))  = ''实物物品'') '


--开始：仓位权限
--  if ltrim(rtrim(@get_store))<>''    select @text1=@text1+' '+ltrim(rtrim(isnull(@get_store,'')))+' '    --普通仓位
--  if ltrim(rtrim(@get_instore))<>''  select @text=@text+' '+ltrim(rtrim(isnull(@get_instore,'')))+' '    --调拨入库仓位
--结束：仓位权限

  select @ssql=''   --初始化入进
  select @ssql=' insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.oh,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.oddment_num,
    isnull(a.oh,0),isnull(a.i_price,0),a.oh*a.i_price
                                   from ivtd01300 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                   where b.item_id=a.item_id '+@text3+@text1
   select @ssql=@ssql+'  and a.initial_flag=''Y'''
  exec(@ssql)

  select  @ssql=''   --委托加工产品入库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    0 as pack_num,
    '''' as pack_unit,0 as oddment_num,'
  +'isnull(a.lead_oq,0),isnull(a.oper_price,0),isnull(a.plan_price,0)
                                   from VIEW_Yie05010 a, 
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                   where  b.item_id=a.item_id and 1=1 '+@text3+@text1
  select @ssql= @ssql+'  and isnull(a.comfirm_flag,''N'')=''Y'''
  exec(@ssql) 

  select  @ssql=''   --委托加工材料出库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    0 as pack_num,
    '''' as pack_unit,0 as oddment_num,'
  +'-isnull(a.lead_oq,0),isnull(a.oper_price,0),-isnull(a.plan_price,0)
                                   from VIEW_Yie05012 a, 
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                   where  b.item_id=a.item_id and 1=1 '+@text3+@text1
  select @ssql= @ssql+'  and isnull(a.comfirm_flag,''N'')=''Y'''
  exec(@ssql)

  select  @ssql=''  --采购入库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.rep_qty,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.oddment_num,'
  +'isnull(a.rep_qty,0),isnull(a.price,0),isnull(a.st_sum,0)
                                   from View_STDM03001 a, 
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                   where  b.item_id=a.item_id and (a.stock_type=''进货'' or a.stock_type=''借货'') '+@text3+@text1
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)  

  select  @ssql='' --采购退货
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.rep_qty,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.oddment_num,'
  +'-isnull(a.rep_qty,0),isnull(a.price,0),-isnull(a.st_sum,0) 
                                  from View_STDM03001 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                  where  b.item_id=a.item_id and a.stock_type=''退货'''+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)   

  select  @ssql='' --销售开票
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.sd_oq,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,-a.send_qty,'
  +'-isnull(a.sd_oq,0),isnull(a.tax_sum_si,0) as i_price,-isnull(a.sd_oq,0)*isnull(a.tax_sum_si,0) as i_Amount  
                                  from View_sdd02020 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                  where  b.item_id=a.item_id and (a.sd_order_direct=''发货'' or a.sd_order_direct=''现款'')'+@text3+@text1
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)  

  select  @ssql='' --销售退货
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.sd_oq,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.send_qty,'
  +'isnull(a.sd_oq,0),isnull(a.tax_sum_si,0) as i_price,isnull(a.sd_oq,0)*isnull(a.tax_sum_si,0) as i_Amount   
                                  from View_sdd02020 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                  where  b.item_id=a.item_id and a.sd_order_direct=''退货'''+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql) 


  select  @ssql=''  --其它入库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.oper_qty,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.oddment_num,'
  +'isnull(a.oper_qty,0),a.oper_price,isnull(a.plan_price,0) 
                                  from VIEW_ivt01201 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                  where  b.item_id=a.item_id and a.ivt_oper_id=''入库'''+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''  --其它出库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.oper_qty,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,-a.oddment_num,'
  +'isnull(-a.oper_qty,0),a.oper_price,-isnull(a.oper_qty,0)*isnull(a.oper_price,0) as i_Amount 
                                  from VIEW_ivt01201 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b 
                                  where  b.item_id=a.item_id and a.ivt_oper_id=''出库'''+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)


  select  @ssql=''    --调拨入库，入库单价上：存在同价调拨和变价调拨的区别
  if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id )='1' --MoveStore_Style='1'同价调拨   
  begin
    select  @ssql='insert into #temp select a.com_id,a.corpstorestruct_id,a.item_id,'''',
      ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.oper_qty,0)/b.pack_unit) else 0 end ) as pack_num,
      a.pack_unit,a.oddment_num,'
      +'isnull(a.oper_qty,0),a.oper_price,isnull(a.plan_price,0)  
                                  from VIEW_ivt01201 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b  
                                  where  b.item_id=a.item_id and a.ivt_oper_id=''调拨'' '
  end else if ( select isnull(MoveStore_Style,'1') from CTLf01000 where com_id=@com_id )='0'  --MoveStore_Style='0'变价调拨
  begin
    select  @ssql='insert into #temp select a.com_id,a.corpstorestruct_id,a.item_id,'''',
      ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.oper_qty,0)/b.pack_unit) else 0 end ) as pack_num,
      a.pack_unit,a.oddment_num,'
      +'isnull(a.oper_qty,0),a.base_oq,isnull(a.pass_oq,0)  
                                  from VIEW_ivt01201 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b  
                                  where  b.item_id=a.item_id and a.ivt_oper_id=''调拨'' '
  end
  if  rtrim(ltrim( @store_struct_id))<>''
    select @ssql= @ssql+' and a.corpstorestruct_id like '+''''+rtrim(ltrim( @store_struct_id))+'%'''
  if  rtrim(ltrim(@item_id))<>''
    select @ssql= @ssql+' and a.item_id='''+ rtrim(ltrim(@item_id))+''''
  if rtrim(ltrim(@type_id))<>'' 
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  type_id  like '''+@type_id+'%'')'
  if rtrim(ltrim(@item_spec))<>'' --规格
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  item_spec  like '''+@item_spec+'%'')'
  if rtrim(ltrim(@item_type))<>'' --型号
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  item_type  like '''+@item_type+'%'')'
  if rtrim(ltrim(@vendor_id))<>'' --产地
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  vendor_id  like '''+@vendor_id+'%'')'
--销售属性=实物物品的
  select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id))+''''+'  and  ltrim(rtrim(isnull(sales_property,'''')))  = ''实物物品'') '

  select @ssql= @ssql+'  and a.comfirm_flag=''Y'' '+@text
  exec(@ssql)


  select  @ssql=''  --调拨出库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.oper_qty,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,-a.oddment_num,'
  +'isnull(-a.oper_qty,0),a.oper_price,isnull(-a.plan_price,0) 
                                   from VIEW_ivt01201 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b  
                                  where  b.item_id=a.item_id and a.ivt_oper_id=''调拨'''+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''  --库存报损
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.oper_qty,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,-a.oddment_num,'
  +'isnull(-a.oper_qty,0),a.oper_price,-isnull(a.oper_qty,0)*isnull(a.oper_price,0) as i_Amount 
                                   from VIEW_ivt01201 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b  
                                  where  b.item_id=a.item_id and a.ivt_oper_id=''报损'''+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql='' --组装入库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    0,
    '''',0,'
  +'isnull(a.group_oq,0),a.group_cost,isnull(a.group_sum,0)  
                                   from ivtd03001 a 
                                   where a.group_split=''组装''  '+@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql='' --组装出库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.sd_oq,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,-a.oddment_num,'
  +'isnull(-a.sd_oq,0),a.sd_unit_price,isnull(-a.sum_si,0) 
                                   from VIEW_ivtd03001 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b  
                                  where  b.item_id=a.item_id and a.group_split=''组装'' ' +@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql='' --拆卸出库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    0,
    '''',0,'
  +'isnull(-a.group_oq,0),a.group_cost,isnull(-a.group_sum,0)  
                                   from ivtd03001 a 
                                   where a.group_split=''拆卸'' ' +@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql='' --拆卸入库
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.sd_oq,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.oddment_num,'
  +'isnull(a.sd_oq,0),a.sd_unit_price,isnull(a.sum_si,0)  
                                   from VIEW_ivtd03001 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b
                                  where  b.item_id=a.item_id and a.group_split=''拆卸'' ' +@text3+@text1 
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''  --返利供户赠送入库
  select  @ssql='insert into #temp select a.com_id,a.sd_order_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(isnull(a.sd_oq,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,a.oddment_num,'
  +'isnull(a.sd_oq,0),a.sd_unit_price,isnull(a.sd_oq,0)*isnull(a.sd_unit_price,0) as i_Amount  
                                   from VIEW_Ard02040 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b
                                  where  b.item_id=a.item_id and a.tax_invoice_direct=''供货'''
  if  rtrim(ltrim( @store_struct_id))<>''
    select @ssql= @ssql+' and a.store_struct_id like '+''''+rtrim(ltrim( @store_struct_id))+'%'''
  if  rtrim(ltrim(@item_id))<>''
    select @ssql= @ssql+' and a.item_id='''+ rtrim(ltrim(@item_id))+''''
  if rtrim(ltrim(@type_id))<>'' 
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  type_id  like '''+@type_id+'%'')'
  if rtrim(ltrim(@item_spec))<>'' --规格
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  item_spec  like '''+@item_spec+'%'')'
  if rtrim(ltrim(@item_type))<>''--型号
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  item_type  like '''+@item_type+'%'')'
  if rtrim(ltrim(@vendor_id))<>'' --产地
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  vendor_id  like '''+@vendor_id+'%'')'
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'' '+@text3+@text1
  exec(@ssql)


  select  @ssql=''  --返利客户赠送出库
  select  @ssql='insert into #temp select a.com_id,a.sd_order_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.sd_oq,0)/b.pack_unit) else 0 end ) as pack_num,
a.pack_unit,-a.oddment_num,'
  +'isnull(-a.sd_oq,0),a.sd_unit_price,-isnull(sd_oq,0)*isnull(sd_unit_price,0) as i_Amount  
                                   from VIEW_Ard02040 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b
                                  where  b.item_id=a.item_id and a.tax_invoice_direct=''客户''' 
  if  rtrim(ltrim( @store_struct_id))<>''
    select @ssql= @ssql+' and a.store_struct_id like '+''''+rtrim(ltrim( @store_struct_id))+'%'''
  if  rtrim(ltrim(@item_id))<>''
    select @ssql= @ssql+' and a.item_id='''+ rtrim(ltrim(@item_id))+''''
  if rtrim(ltrim(@type_id))<>'' 
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  type_id  like '''+@type_id+'%'')'
  if rtrim(ltrim(@item_spec))<>'' --规格
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  item_spec  like '''+@item_spec+'%'')'
  if rtrim(ltrim(@item_type))<>''--型号
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  item_type  like '''+@item_type+'%'')'
  if rtrim(ltrim(@vendor_id))<>'' --产地
    select @ssql=@ssql+' and a.item_id in (select item_id  from ctl03001 where com_id='+''''
    + rtrim(ltrim(@com_id))+''''+'  and  vendor_id  like '''+@vendor_id+'%'')'
  select @ssql= @ssql+'  and a.comfirm_flag=''Y'' '+@text3+@text1
  exec(@ssql)

  select  @ssql='' --库存盘点
  select  @ssql='insert into #temp select a.com_id,a.store_struct_id,a.item_id,'''',
    ( case when ( isnull(b.casing_unit,'''')<>'''' and isnull(b.pack_unit,0)>0 ) then floor(-isnull(a.differ_quant,0)/b.pack_unit) else 0 end ) as pack_num,
    a.pack_unit,-a.oddment_num,'
  +'-isnull(differ_quant,0) as accn_ivt,isnull(tax_sum_si,0) as i_price,-isnull(differ_sum,0) as i_Amount 
                                   from  VIEW_Ivtd01310 a,
                                   (select c.casing_unit,c.pack_unit,c.item_id from ctl03001 c ) b  
                                  where  b.item_id=a.item_id '  +@text3+@text1 
  select @ssql= @ssql+'  and a.count_flag=''Y'''
  exec(@ssql)

  select @ssql=''
  select @ssql='insert into #temp1(com_id,store_struct_id,item_id,peijian_id,pack_num,pack_unit,oddment_num,accn_ivt,i_price,i_Amount) 
    select com_id,store_struct_id,item_id,'''' as peijian_id,sum(pack_num) as pack_num,'''' as pack_unit,
    sum(oddment_num) as oddment_num,sum(accn_ivt) as accn_ivt,0 as i_price,sum(i_Amount) as i_Amount 
    from #temp  group by  com_id,store_struct_id,item_id'
  exec(@ssql)

  select @ssql=''
  select @ssql='select com_id=''小计'',store_struct_id=null,item_id=null,peijian_id=null,sum(pack_num) as pack_num,pack_unit=null,
    sum(oddment_num) as oddment_num,sum(accn_ivt) as accn_ivt,i_price=null,sum(isnull(i_Amount,0)) as i_Amount,
    order1=1,order2=store_struct_id,order3=0  from #temp1  group by com_id,store_struct_id 
    union all select com_id,store_struct_id,item_id,'''',
    pack_num,NULL pack_unit,oddment_num,accn_ivt,( case when isnull(accn_ivt,0)<=0 then null else isnull(i_Amount,0)/accn_ivt end ) as i_price,
    ( case when isnull(accn_ivt,0)<=0 then null else isnull(i_Amount,0) end ) as i_Amount,
    order1=0,order2=store_struct_id,order3=0 from #temp1 
    union all select com_id=''合计'',store_struct_id=null,item_id=null,peijian_id=null,sum(pack_num) as pack_num,'''',
    sum(oddment_num) as oddment_num,sum(accn_ivt) as accn_ivt,i_price=null,sum(isnull(i_Amount,0)) as i_Amount,
    order1=1,order2=null,order3=1 from #temp1 group by com_id order by order3,order2,order1,item_id'
  exec(@ssql)

declare mycur  CURSOR FOR 
  select com_id,store_struct_id,item_id,peijian_id,accn_ivt,
    ( case when isnull(accn_ivt,0)=0 then null else isnull(i_Amount,0)/accn_ivt end ) as i_price,
    ( case when isnull(accn_ivt,0)=0 then null else isnull(i_Amount,0) end ) as i_Amount
  from #temp1 order by com_id,store_struct_id,item_id
OPEN mycur
FETCH NEXT FROM mycur 
INTO @com_id1,@store_struct_id1,@item_id1,@peijian_id1,@accn_ivt1,@i_price1,@i_Amount1
WHILE @@FETCH_STATUS = 0
begin   
  select com_id,store_struct_id,item_id,oh,accn_ivt,i_price,i_Amount from ivtd01302
          where rtrim(ltrim(isnull(ivtd01302.com_id,'')))=rtrim(ltrim(isnull(@com_id1,'')))
            and rtrim(ltrim(isnull(ivtd01302.item_id,'')))=rtrim(ltrim(isnull(@item_id1,'')))
            and rtrim(ltrim(isnull(ivtd01302.store_struct_id,'')))=rtrim(ltrim(isnull(@store_struct_id1,''))) 
  if @@rowcount<> 0
  begin
    update ivtd01302 set ivtd01302.accn_ivt=ISNULL(@accn_ivt1,0),ivtd01302.i_price=ISNULL(@i_price1,0),
                         ivtd01302.oh=ISNULL(@accn_ivt1,0),ivtd01302.i_Amount=ISNULL(@i_Amount1,0)
    from  ivtd01302
    where       rtrim(ltrim(isnull(ivtd01302.com_id,'')))=rtrim(ltrim(isnull(@com_id1,'')))
            and rtrim(ltrim(isnull(ivtd01302.item_id,'')))=rtrim(ltrim(isnull(@item_id1,'')))
            and rtrim(ltrim(isnull(ivtd01302.store_struct_id,'')))=rtrim(ltrim(isnull(@store_struct_id1,''))) 
  end else
  begin
    insert into ivtd01302(com_id,finacial_y,finacial_m,item_id,store_struct_id,accn_ivt,oh,i_price,i_Amount )
    values(rtrim(ltrim(isnull(@com_id1,''))),@finacial_y,@finacial_m,rtrim(ltrim(isnull(@item_id1,''))),ISNULL(@store_struct_id1,0),
           ISNULL(@accn_ivt1,0),ISNULL(@accn_ivt1,0),ISNULL(@i_price1,0),ISNULL(@i_Amount1,0) )
  end
FETCH NEXT FROM mycur 
INTO @com_id1,@store_struct_id1,@item_id1,@peijian_id1,@accn_ivt1,@i_price1,@i_Amount1
end
CLOSE mycur
DEALLOCATE mycur

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_storeQry
return 0
end else
begin
COMMIT TRANSACTION mytranSp_storeQry
return 1
end




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

