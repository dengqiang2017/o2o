if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_fareTone]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_fareTone]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--经营利润分析
CREATE    PROCEDURE SP_fareTone
(
       @com_id1 char(10),
       @star_date1 varchar(30),
       @end_date1 varchar(30),
       @dept_id1 varchar(30),
       @dept_right1 varchar(8000)
)      
AS 
BEGIN TRANSACTION mytranSP_fareTone
    declare @text3 varchar(8000),@ssql varchar(8000),@com_id char(10)   
     create table #temp (com_id char(10),Sell_receipt decimal(22,6),Sell_cost decimal(22,6),Sell_rate decimal(22,6),
     Sell_gain decimal(22,6))

 select @text3=''
 select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id1))+''' '
 if  rtrim(ltrim( @dept_id1))<>''
   select @text3= @text3+' and dept_id='+''''+rtrim(ltrim( @dept_id1))+''''
 if rtrim(ltrim(@dept_right1))<>''
   select @text3= @text3+' and '+@dept_right1+' '

/* select  @ssql=''--采购进货入库
  select  @ssql='insert into #temp select com_id,0,isnull(st_sum,0),0,0 from View_STDM03001  where  stock_type=''进货'''+@text3
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  exec(@ssql)

  select  @ssql=''--采购退货出库
  select  @ssql='insert into #temp select com_id,0,-isnull(st_sum,0),0,0  from View_STDM03001  where  stock_type=''退货'''+@text3
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,0,isnull(plan_price,0),0,0  from VIEW_ivt01201  where  ivt_oper_id=''外入'''+@text3--入库
  select @ssql=@ssql+' and  store_date>='''+ rtrim(ltrim(@star_date1))+''' and  store_date<='''+rtrim(ltrim(@end_date1))+''''
  exec(@ssql)*/

  select  @ssql=''/*--销售出库 +其他应收 =销售收入    销售成本+其他应付 =销售成本   ？？？采购是否作为成本*/
  select  @ssql='insert into #temp select com_id,isnull(sum_si,0),(sd_oq*tax_sum_si),0,0 from View_sdd02020 where (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3 
  select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date1))
  +''' and  so_consign_date<='''+rtrim(ltrim(@end_date1))+''' and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''/*--销售退货入库*/
  select  @ssql='insert into #temp select com_id,-isnull(sum_si,0),-(sd_oq*tax_sum_si),0,0   from View_sdd02020 where sd_order_direct=''退货'''+@text3
  select @ssql=@ssql+' and  so_consign_date>='''+ rtrim(ltrim(@star_date1))
  +''' and  so_consign_date<='''+rtrim(ltrim(@end_date1))+''' and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''/*--费用*/
  select  @ssql='insert into #temp select com_id,0,0,isnull(sum_si,0),0  from SDDM03001 where (1=1)'+@text3 
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date1))+''' and  finacial_d<='''+rtrim(ltrim(@end_date1))+''''
  exec(@ssql)
 /* select  @ssql=''--其他应收
  select  @ssql='insert into #temp select com_id,0,0,isnull(sum_si,0),0  from SDDM03001 where (1=1)'+@text3 
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date1))+''' and  finacial_d<='''+rtrim(ltrim(@end_date1))+''''--费用
  exec(@ssql)
  select  @ssql=''--其他应付款
  select  @ssql='insert into #temp select com_id,0,0,isnull(sum_si,0),0  from SDDM03001 where (1=1)'+@text3 
  select @ssql=@ssql+' and  finacial_d>='''+ rtrim(ltrim(@star_date1))+''' and  finacial_d<='''+rtrim(ltrim(@end_date1))+''''--费用
  exec(@ssql)*/

  select @ssql=''
  select @ssql=' select com_id,sum(Sell_receipt) as Sell_receipt,sum(Sell_cost) as Sell_cost,sum(Sell_rate) as Sell_rate,'
  +'(sum(Sell_receipt-Sell_cost-Sell_rate)) as Sell_gain  from #temp group by  com_id '
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSP_fareTone
return 0
end else
begin
COMMIT TRANSACTION mytranSP_fareTone
return 1
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

