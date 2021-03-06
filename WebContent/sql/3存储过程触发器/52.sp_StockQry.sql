if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_StockQry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockQry]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--采购明细查询
CREATE      PROCEDURE sp_StockQry
     ( @com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @store_struct_id varchar(30),
       @rcv_auto_no varchar(30),
       @corp_id varchar(30),
       @dept_id varchar(30),
       @clerk_id varchar(35),
       @type_id varchar(30),
       @item_id varchar(40),
       @lot_number varchar(40), 
       @vendor_id varchar(40),
       @item_type varchar(40),
       @stock_type varchar(10),
       @c_memoMain varchar(150), 
       @c_memo varchar(150),
       @get_dept varchar(8000),
       @get_store varchar(8000)
     )
AS 
BEGIN TRANSACTION mytranSP_StockQry

    declare @text3 varchar(8000),@text varchar(8000),@ssql varchar(8000)
    create table #temp (com_id char(10),rcv_hw_no varchar(30),vendor_id varchar(30),dept_id varchar(30),clerk_id varchar(35),stock_type char(10),
     store_date datetime,item_id varchar(40),peijian_id varchar(40),lot_number varchar(40),rep_qty decimal(17,6),unit_id varchar(30),
     price decimal(17,6),st_sum decimal(17,6),store_struct_id varchar(30),rcv_auto_no varchar(30),c_type char(10),
     discount_rate decimal(9,6),pack_unit varchar(30),pack_num decimal(17,6),oddment_num decimal(17,6),c_memoMain varchar(150),c_memo varchar(150),
     finacial_d datetime,at_term_datetime datetime )
 
  select @text3=''
  select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id))+''''
  if (ltrim(rtrim(@star_date))<>'') and (ltrim(rtrim(@end_date))<>'')
  select @text3=@text3+' and  store_date>='''+ rtrim(ltrim(@star_date))
    +''' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@store_struct_id))<>'' 
   select @text3=@text3+' and store_struct_id like '''+ltrim(rtrim(@store_struct_id))+'%'''
  if ltrim(rtrim(@rcv_auto_no))<>''
   select @text3=@text3+' and rcv_auto_no='''+ltrim(rtrim(@rcv_auto_no))+'''' 
  if ltrim(rtrim(@corp_id))<>'' 
   select @text3=@text3+' and vendor_id='''+ltrim(rtrim(@corp_id))+''''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and clerk_id='''+ltrim(rtrim(@clerk_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and dept_id like '''+ltrim(rtrim(@dept_id))+'%'''
  if ltrim(rtrim(@type_id))<>'' 
     select @text3=@text3+' and  item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id))+''''+'  and  type_id  like '''+@type_id+'%'')'
  if ltrim(rtrim(@item_id)) <> '' 
     select @text3=@text3+' and item_id='''+ltrim(rtrim(@item_id))+''' '
     select @text3=@text3+' and comfirm_flag=''Y'''
  if ltrim(rtrim(@lot_number))<>'' 
     select @text3=@text3+' and lot_number like '''+ltrim(rtrim(@lot_number))+'%''' 
  if ltrim(rtrim(@vendor_id))<>''
     select @text3=@text3+' and  item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id))+''''+'  and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'')'
  if ltrim(rtrim(@item_type))<>''
     select @text3=@text3+' and  item_id in (select item_id  from ctl03001 where com_id='+''''
     + rtrim(ltrim(@com_id))+''''+'  and  ltrim(rtrim(isnull(item_type,''''))) like ''%'+ltrim(rtrim(@item_type))+'%'')'
  if ltrim(rtrim(@stock_type))<>'' 
     select @text3=@text3+' and (case isnull(rej_flag,'''') when ''1'' then  ''挂帐采购'' when ''0'' then  ''现款采购'' else ''采购退货'' end)  = '''
     +ltrim(rtrim(@stock_type))+''' ' 
  if ltrim(rtrim(@c_memoMain))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(c_memoMain,''''))) like ''%'+ltrim(rtrim(isnull(@c_memoMain,'')))+'%'''
  if ltrim(rtrim(@c_memo))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(c_memo,''''))) like ''%'+ltrim(rtrim(isnull(@c_memo,'')))+'%'''
--开始：部门仓位权限
  select @text=''
  if ltrim(rtrim(@get_dept))<>'' 
     select @text=@text+' and  '+@get_dept+' '
  if ltrim(rtrim(@get_store))<>''
     select @text=@text+' '+@get_store+' '
--结束：部门仓位权限
 
  select @ssql=''/*进货开单*/
  select  @ssql='insert into #temp select com_id,rcv_hw_no,vendor_id,dept_id,clerk_id,'
  +' (case  when isnull(rej_flag,'''')=''1'' then  ''挂帐采购'' else ''现款采购'' end) as stock_type ,'
  +'store_date ,item_id ,peijian_id,lot_number,rep_qty,unit_id,price,st_sum,store_struct_id,rcv_auto_no,'
  +'stock_type,discount_rate,pack_unit,pack_num,oddment_num,'
  +'ltrim(rtrim(isnull(c_memoMain,''''))) as c_memoMain,ltrim(rtrim(isnull(c_memo,''''))) as c_memo,finacial_d,at_term_datetime from VIEW_STDM03001  '
  +'where  (stock_type=''进货'' or stock_type=''借货'')'+@text3+@text
  exec(@ssql)

  select @ssql=''/*进货退货*/
  select @ssql='insert into #temp select com_id,rcv_hw_no,vendor_id,dept_id,clerk_id,''采购退货'',store_date,item_id,peijian_id,'
  +'lot_number,-rep_qty,unit_id,price,-st_sum,store_struct_id,rcv_auto_no,stock_type,discount_rate,pack_unit,-pack_num,-oddment_num,'
  +'ltrim(rtrim(isnull(c_memoMain,''''))) as c_memoMain,ltrim(rtrim(isnull(c_memo,''''))) as c_memo,finacial_d,at_term_datetime from VIEW_STDM03001  '
  +' where  stock_type=''退货'' '+@text3+@text
  exec(@ssql)

  select @ssql=''
  select @ssql='select com_id=null,rcv_hw_no=null,vendor_id=null,dept_id=null,clerk_id=null,stock_type=''小计'','
    +'store_date=null,item_id=null,peijian_id=null,lot_number=null,sum(rep_qty) as rep_qty,unit_id=null,price=null,'
    +'sum(st_sum) as st_sum,store_struct_id=null,rcv_auto_no=null,c_type=null,discount_rate=null,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(oddment_num) as oddment_num,'
    +'null as c_memoMain,null as c_memo,finacial_d=null,at_term_datetime=null, '
    +' order1=1,order2=vendor_id,order3=0 from #temp    group by com_id,vendor_id  '
    +'          union all select com_id,rcv_hw_no,vendor_id,dept_id,clerk_id,stock_type,store_date,item_id,peijian_id,lot_number,'
    +'rep_qty,unit_id,price,st_sum,store_struct_id,rcv_auto_no,c_type,discount_rate,pack_unit,pack_num,oddment_num,'
    +'ltrim(rtrim(isnull(c_memoMain,''''))) as c_memoMain,ltrim(rtrim(isnull(c_memo,''''))) as c_memo,finacial_d,at_term_datetime, '
    +' order1=0,order2=vendor_id,order3=0 from #temp   '
    +'          union all select com_id=null,rcv_hw_no=null,vendor_id=null,dept_id=null,clerk_id=null,stock_type=''合计'','
    +'store_date=null,item_id=null,peijian_id=null,lot_number=null,sum(rep_qty) as rep_qty,unit_id=null,price=null,'
    +'sum(st_sum) as st_sum,store_struct_id=null,rcv_auto_no=null,c_type=null,discount_rate=null,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(oddment_num) as oddment_num,'
    +'null as c_memoMain,null as c_memo,finacial_d=null,at_term_datetime=null, '
    +' order1=1,order2=null,order3=1 from #temp  group by com_id  order by order3,order2,order1,store_date '
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSP_StockQry
return 0
end else
begin
COMMIT TRANSACTION mytranSP_StockQry
return 1
end





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

