if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SalesProfit_itemName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SalesProfit_itemName]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--销量毛利分析:分物品名称
CREATE     PROCEDURE sp_SalesProfit_itemName
(
       @com_id1 char(10),
       @star_date1 varchar(30),
       @end_date1 varchar(30),
       @dept_id1 varchar(30),
       @clerk_id1 varchar(35),
       @type_id1 varchar(30),
       @item_id1 varchar(40),
       @dept_right1 varchar(8000)
)
AS 
BEGIN TRANSACTION mytranSp_SalesProfit_itemName
    declare @text3 varchar(8000),@ssql varchar(8000),@i_price decimal(22,6),@finacial_y int,@finacial_m tinyint,
    @store_struct_id varchar(30),@sd_oq decimal(22,6),@sid int,@com_id char(10),@item_id varchar(40),
    @lot_number  varchar(40)

     create table #temp (com_id char(10),store_struct_id varchar(30),dept_id varchar(30),clerk_id varchar(35),
     store_date datetime,type_id varchar(30),item_id varchar(40),lot_number varchar(40),i_SellNum decimal(22,6),  --销售金额
     sd_oq decimal(22,6),i_cost decimal(22,6),sale_gain decimal(22,6),finacial_y int,finacial_m tinyint,sid int)

 select @text3=''
select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id1))+''''
if  rtrim(ltrim( @dept_id1))<>''
  select @text3= @text3+' and dept_id='+''''+rtrim(ltrim( @dept_id1))+''''
if rtrim(ltrim( @clerk_id1))<>''
  select @text3=@text3+' and  clerk_id='+''''+rtrim(ltrim( @clerk_id1))+''''
if rtrim(ltrim(@type_id1))<>'' 
  select @text3=@text3+' and item_id in (select item_id  from ctl03001 where com_id='+''''
  + rtrim(ltrim(@com_id1))+''''+'  and  type_id  like '''+@type_id1+'%'')'
if  rtrim(ltrim(@item_id1))<>''
  select @text3= @text3+' and item_id='''+ rtrim(ltrim(@item_id1))+''''
if rtrim(ltrim(@dept_right1))<>''
  select @text3= @text3+' and  '+@dept_right1

select @text3= @text3+'  and comfirm_flag=''Y'''

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id,dept_id,clerk_id,so_consign_date,type_id,item_id,'/*销售发货*/
      +'lot_number,sum_si,sd_oq,(tax_sum_si*sd_oq) as i_cost,0 as sale_gain,finacial_y,finacial_m,seeds_id from VIEW_SDd02020  where '
      +'  (sd_order_direct=''发货'' or sd_order_direct=''现款'') and so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''
      +rtrim(ltrim(@end_date1))+''''+@text3
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id,dept_id,clerk_id,so_consign_date,type_id,item_id,'/*销售退货*/
      +'lot_number,-sum_si,-sd_oq,-(tax_sum_si*sd_oq) as i_cost,0 as sale_gain,finacial_y,finacial_m,seeds_id from VIEW_SDd02020  where  '
      +'sd_order_direct=''退货''and so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''
      +rtrim(ltrim(@end_date1))+''''+@text3
  exec(@ssql)
 /*-- select  @ssql='select * from #temp'  
--exec(@ssql)
  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id,dept_id,clerk_id,store_date,type_id,item_id,'--采购进货
          +'lot_number,0,0,st_sum,0,finacial_y,finacial_m,seeds_id from View_STDM03001  where  stock_type=''进货'''
          +' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''+@text3 
  exec(@ssql)


  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id,dept_id,clerk_id,store_date,type_id,item_id,'--采购退货
          +'lot_number,0,0,-st_sum,0,finacial_y,finacial_m,seeds_id from View_STDM03001  where  stock_type=''退货'''
          +' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''+@text3 
  exec(@ssql)*/

  select @ssql=''
  select  @ssql=' select com_id,type_id=''小计'',item_id=null,lot_number=null,sum(i_SellNum) as i_SellNum,sum(sd_oq) as sd_oq,'
     +'sum(i_cost) as i_cost,sum(i_SellNum-i_cost) as sale_gain,order1=1,order2=type_id,order3=0 from #temp group by com_id,type_id'
     +' union all select com_id,type_id,item_id,lot_number,sum(i_SellNum) as i_SellNum,sum(sd_oq) as sd_oq,'
     +'sum(i_cost) as i_cost,sum(i_SellNum-i_cost) as sale_gain,order1=0,order2=type_id,order3=0 from #temp group by com_id,type_id,item_id,lot_number '
     +' union all select com_id,type_id=''合计'',item_id=null,lot_number=null,sum(i_SellNum) as i_SellNum,sum(sd_oq) as sd_oq,'
     +'sum(i_cost) as i_cost,sum(i_SellNum-i_cost) as sale_gain,order1=1,order2=null,order3=1 from #temp group by com_id  order by order3,order2,order1'
  exec(@ssql)


IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_SalesProfit_itemName
return 0
end else
begin
COMMIT TRANSACTION mytranSp_SalesProfit_itemName
return 1
end






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

