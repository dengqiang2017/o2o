if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SellTotalQry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SellTotalQry]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--销售汇总统计报表
CREATE         PROCEDURE sp_SellTotalQry
(      @com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @ivt_oper_listing varchar(30),
       @store_struct_id varchar(30),
       @regionalism_id varchar(30),
       @customer_id varchar(30),
       @dept_id varchar(30),
       @clerk_id varchar(35),
       @lot_number varchar(40),
       @HYS varchar(40),
       @get_dept varchar(8000),
       @get_store varchar(8000)  
)
AS 
BEGIN TRANSACTION mytranSP_SellTotalQry

    declare @text3 varchar(8000),@text varchar(8000),@ssql varchar(8000),@flag char(1)
    create table #temp (com_id varchar(10),sd_order_id varchar(30),store_struct_id varchar(30),regionalism_id varchar(30),
     customer_id varchar(30),dept_id varchar(30),clerk_id varchar(35),so_consign_date datetime,type_id varchar(30), 
     item_id varchar(40),peijian_id varchar(40),lot_number varchar(40),sd_oq decimal(22,6),sd_unit_price decimal(28,6),
     cost_sum decimal(28,6),sum_si decimal(28,6),profit decimal(28,6),sd_order_direct char(20),unit_id varchar(30),
     ivt_oper_listing varchar(30),send_sum decimal(28,6),discount_rate decimal(9,6),c_type char(20),pack_unit varchar(30),
     pack_num decimal(28,6),send_qty decimal(28,6),beizhu varchar(800),c_memo varchar(800),HYJE decimal(28,6),JS decimal(28,6),BXQ int,
     HYS varchar(40),FHDZ varchar(40))

  select @text3=''
  select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id))+''''
  if (rtrim(ltrim(@star_date))<>'') and (rtrim(ltrim(@end_date))<>'') 
  select @text3=@text3+' and  so_consign_date>='''+ rtrim(ltrim(@star_date))
    +''' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@ivt_oper_listing))<>''
   select @text3=@text3+' and ivt_oper_listing='''+ltrim(rtrim(@ivt_oper_listing))+''''
  if ltrim(rtrim(@store_struct_id))<>'' 
   select @text3=@text3+' and store_struct_id like '''+ltrim(rtrim(@store_struct_id))+'%'''
  if ltrim(rtrim(@regionalism_id))<>'' 
   select @text3=@text3+' and regionalism_id like '''+ltrim(rtrim(@regionalism_id))+'%'''
  if ltrim(rtrim(@customer_id))<>'' 
   select @text3=@text3+' and customer_id='''+ltrim(rtrim(@customer_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and dept_id like '''+ltrim(rtrim(@dept_id))+'%'''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and clerk_id='''+ltrim(rtrim(@clerk_id))+''''
  if ltrim(rtrim(@HYS)) <> '' 
   select @text3=@text3+' and HYS like ''%'+ltrim(rtrim(@HYS))+'%'' '

   select @text3=@text3+' and comfirm_flag=''Y'''

  if ltrim(rtrim(@lot_number))<>'' 
  begin
    if ltrim(rtrim(@lot_number))='按客户统计' 
    begin
      set @flag='1' 
    end else if ltrim(rtrim(@lot_number))='按单据统计'
    begin
      set @flag='0' 
    end
  end else set  @flag='1' 

--开始：部门仓位权限
  select @text=''
--  if ltrim(rtrim(@get_dept))<>''
--     select @text=@text+' and '+ltrim(rtrim(@get_dept))+' '
--  if ltrim(rtrim(@get_store))<>''
--     select @text=@text+' '+ltrim(rtrim(@get_store))+' '
--结束：部门仓位权限

  select @ssql=''/*销售开单*/
  select  @ssql='insert into #temp select com_id,sd_order_id,store_struct_id,regionalism_id,customer_id,dept_id,clerk_id,'
    +'so_consign_date,type_id,item_id,peijian_id,lot_number,sd_oq,sd_unit_price,sd_oq*tax_sum_si,sum_si,sum_si-sd_oq*tax_sum_si,'
    +' (case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as sd_order_direct,unit_id,ivt_oper_listing,'
    +'send_sum,discount_rate,sd_order_direct,pack_unit,pack_num,send_qty,beizhu,c_memo,HYJE,JS,BXQ,HYS,FHDZ  from View_sdd02020_LeftOuterJoin_ctl03001  where 
    (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3+@text
  exec(@ssql)

   select @ssql=''    /*销售开单优惠*/
   select  @ssql='insert into #temp select sdd02020.com_id,sd_order_id,'''',sdd02020.regionalism_id,sdd02020.customer_id,sdd02020.dept_id,sdd02020.clerk_id,
    so_consign_date,'''','''','''','''',0,0,0,-i_agiosum,0,
    (case  when sd_order_direct=''现款'' then  ''现款优惠'' else ''挂帐优惠'' end) as sd_order_direct,'''',ivt_oper_listing,
    0,0,sd_order_direct,'''',0,0,'''','''',HYJE,0 JS,0 BXQ,HYS,FHDZ  from sdd02020 LEFT JOIN SDf00504 ON sdd02020.customer_id=SDf00504.customer_id where 
    (sd_order_direct=''发货'' or sd_order_direct=''现款'') and isnull(i_agiosum,0)<>0  and  sdd02020.com_id='''+ rtrim(ltrim(@com_id))+'''
    and ivt_oper_listing in (select ivt_oper_listing from #temp) '
  exec(@ssql)

  select @ssql=''/*销售退货*/
  select  @ssql='insert into #temp select com_id,sd_order_id,store_struct_id,regionalism_id,customer_id,dept_id,'
     +'clerk_id,so_consign_date,type_id,item_id,peijian_id,lot_number,-sd_oq,sd_unit_price,-sd_oq*tax_sum_si,-sum_si,'
     +'-sum_si+sd_oq*tax_sum_si,''销售退货'',unit_id,ivt_oper_listing,send_sum,discount_rate,sd_order_direct,pack_unit,'
     +'-pack_num,-send_qty,beizhu,c_memo,HYJE,JS,BXQ,HYS,FHDZ  from View_sdd02020_LeftOuterJoin_ctl03001  where  sd_order_direct=''退货'' '+@text3+@text
  exec(@ssql)

  select @ssql=''

  if ltrim(rtrim(@flag))='1'
  begin
    select  @ssql='select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=null,'
    +'customer_id=null,dept_id=null,clerk_id=null,CONVERT(varchar(10),so_consign_date,120) as so_consign_date,type_id=null,item_id=null,peijian_id=null,'
    +'lot_number=null,unit_id=null,sd_oq=null,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +'sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +'order2=0,order3=0,sum(HYJE) as HYJE,sum(isnull(JS,0)) as JS,BXQ=null,HYS=null,FHDZ=null from  #temp  group by com_id,so_consign_date '
    +' union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=null,'
    +'customer_id=null,dept_id=null,clerk_id=null,''合计'' as so_consign_date,type_id=null,item_id=null,peijian_id=null,'
    +'lot_number=null,unit_id=null,sd_oq=null,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +'sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +'order2=null,order3=1,sum(HYJE) as HYJE,sum(isnull(JS,0)) as JS,BXQ=null,HYS=null,FHDZ=null from  #temp  group by com_id order by order3,order1,so_consign_date desc'
  end else   if ltrim(rtrim(@flag))='0' begin
    select  @ssql='select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=null,'
    +'customer_id=null,dept_id=null,clerk_id=null,CONVERT(varchar(10),so_consign_date,120) as so_consign_date,type_id=null,item_id=null,peijian_id=null,'
    +'lot_number=null,unit_id=null,sd_oq=null,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +'sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +'order2=0,order3=0,sum(HYJE) as HYJE,sum(isnull(JS,0)) as JS,BXQ=null,HYS=null,FHDZ=null from  #temp group by com_id,so_consign_date '
    +' union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=null,'
    +'customer_id=null,dept_id=null,clerk_id=null,''合计'' as so_consign_date,type_id=null,item_id=null,peijian_id=null,'
    +'lot_number=null,unit_id=null,sd_oq=null,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +'sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,order2=null,'
    +'order3=1,sum(HYJE) as HYJE,sum(isnull(JS,0)) as JS,BXQ=null,HYS=null,FHDZ=null from  #temp  group by com_id  order by order3,order1,so_consign_date desc'
  end

  exec(@ssql)


IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSP_SellTotalQry
return 0
end else
begin
COMMIT TRANSACTION mytranSP_SellTotalQry
return 1
end







GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

