if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SellQry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SellQry]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--销售统计报表：版本说明：物品资料中的长宽高，而非业务单据中的长宽高
CREATE      PROCEDURE sp_SellQry
(      @com_id char(10),
       @star_date varchar(30),
       @end_date varchar(30),
       @ivt_oper_listing varchar(30),
       @store_struct_id varchar(30),
       @regionalism_id varchar(30),
       @customer_id varchar(30),
       @dept_id varchar(30),
       @clerk_id varchar(35),
       @type_id varchar(30),
       @item_type varchar(40),
       @item_id varchar(40),
       @lot_number varchar(40),
       @vendor_id varchar(40),
       @HYS varchar(40),
       @c_memo varchar(800),
       @beizhu varchar(800),
       @sd_order_direct varchar(20),
       @get_dept varchar(8000),
       @get_store varchar(8000),
       @item_Lenth1 decimal(28,6),
       @item_Lenth2 decimal(28,6),
       @item_Width1 decimal(28,6),
       @item_Width2 decimal(28,6),
       @item_Hight1 decimal(28,6),
       @item_Hight2 decimal(28,6)
)
AS
BEGIN TRANSACTION mytranSp_SellQry 
  declare @text3 varchar(8000),@text varchar(8000),@ssql varchar(8000),@flag char(1)
  create table #temp
   ( com_id char(10),sd_order_id varchar(30),store_struct_id varchar(30),regionalism_id varchar(30),
     customer_id varchar(30),dept_id varchar(30),clerk_id varchar(35),so_consign_date datetime,type_id varchar(30), 
     item_id varchar(40),peijian_id varchar(40),item_spec varchar(40),sd_oq decimal(28,6),sd_unit_price decimal(28,6),
     cost_sum decimal(28,6),sum_si decimal(28,6),profit decimal(28,6),sd_order_direct varchar(20),unit_id varchar(30),
     ivt_oper_listing varchar(30),send_sum decimal(28,6),discount_rate decimal(9,6),c_type char(20),pack_unit varchar(30),
     pack_num decimal(28,6),send_qty decimal(28,6),beizhu varchar(800),c_memo varchar(800),HYJE decimal(28,6),JS decimal(28,6),ZJS decimal(28,6),BXQ int,
     HYS varchar(40),FHDZ varchar(40),
     item_yardPrice decimal(28,6), item_yardAmount decimal(28,6),    --item_yardPrice出厂价；item_yardAmount出厂金额
     item_Sellprice decimal(28,6), item_SellAmount decimal(28,6),    --item_Sellprice批发价；item_SellAmount批金额；
     item_zeroSell decimal(28,6),                                    --item_zeroSell零售价
     difference_item_yardPriceANDitem_Sellprice decimal(28,6),                               --出厂价与该仓库销售批发价的价差  
     difference_item_yardPriceANDitem_zeroSell decimal(28,6),                                --出厂价与该仓库销售零售价的价差
     difference_cost_sumANDitem_yardPrice decimal(28,6),                                     --该仓库出库成本价与出厂价的价差
     vendor_id varchar(30),item_type varchar(40),c_color varchar(30),    --产地品牌，物品型号,颜色
     i_weight decimal(22,6),volume decimal(22,6),item_Lenth decimal(28,6),item_Width decimal(28,6),item_Hight decimal(28,6) --重量,体积，长度mm，宽度mm，高(厚)度mm
   )          

--开始：部门仓位权限
  select @text=''
--  if ltrim(rtrim(@get_dept))<>'' 
--     select @text=@text+' and  '+@get_dept+' '
--  if ltrim(rtrim(@get_store))<>''
--     select @text=@text+' '+@get_store+' '
--结束：部门仓位权限

  select @text3=''

  select @text3=' and  com_id='+''''+ rtrim(ltrim(@com_id))+''''
  if (rtrim(ltrim(@star_date))<>'') and (rtrim(ltrim(@end_date))<>'') 
   select @text3=@text3+' and  so_consign_date>='''+ rtrim(ltrim(@star_date))
    +''' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+''''
  if ltrim(rtrim(@store_struct_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(store_struct_id,''''))) like '''+ltrim(rtrim(isnull(@store_struct_id,'')))+'%'''
  if ltrim(rtrim(@regionalism_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(regionalism_id,'''')))  like '''+ltrim(rtrim(isnull(@regionalism_id,'')))+'%'''
  if ltrim(rtrim(@customer_id))<>'' 
   select @text3=@text3+' and customer_id='''+ltrim(rtrim(@customer_id))+''''
  if ltrim(rtrim(@dept_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(dept_id,''''))) like '''+ltrim(rtrim(isnull(@dept_id,'')))+'%'''
  if ltrim(rtrim(@clerk_id))<>'' 
   select @text3=@text3+' and ltrim(rtrim(isnull(clerk_id,'''')))='''+ltrim(rtrim(isnull(@clerk_id,'')))+''''
  if ltrim(rtrim(@type_id))<>'' 
     select @text3=@text3+'  and ltrim(rtrim(isnull(type_id_ctl03001,'''')))  like '''+ltrim(rtrim(isnull(@type_id,'')))+'%'' '
  if ltrim(rtrim(@item_type))<>'' 
     select @text3=@text3+'  and ltrim(rtrim(isnull(item_type_ctl03001,'''')))  like '''+ltrim(rtrim(isnull(@item_type,'')))+'%'' '
  if ltrim(rtrim(@item_id)) <> '' 
   select @text3=@text3+' and ltrim(rtrim(isnull(item_id,'''')))='''+ltrim(rtrim(isnull(@item_id,'')))+''' '
  if ltrim(rtrim(@HYS)) <> '' 
   select @text3=@text3+' and HYS like ''%'+ltrim(rtrim(@HYS))+'%'' '
  if ltrim(rtrim(@ivt_oper_listing))<>''   --单号
   select @text3=@text3+' and ltrim(rtrim(isnull(sd_order_id,''''))) like ''%'+ltrim(rtrim(isnull(@ivt_oper_listing,'')))+'%'''
  if rtrim(ltrim(isnull(@beizhu,'')))<>''    --行备注
  begin
    if rtrim(ltrim(isnull(@beizhu,'')))='包含：促销价、特价、处理价的所有单据'
    begin
      select @text3=@text3+' and ivt_oper_listing in ( select ivt_oper_listing  from View_sdd02020 where com_id='''
      + rtrim(ltrim(@com_id))+''' and ( ( ltrim(rtrim(isnull(beizhu,'''')))  like ''%促销价%'' )   '
      +' or ( ltrim(rtrim(isnull(beizhu,''''))) like ''%特价%'' ) '
      +' or ( ltrim(rtrim(isnull(beizhu,''''))) like ''%处理价%'' ) )  ) '
    end else if rtrim(ltrim(isnull(@beizhu,'')))='不包含：促销价、特价、处理价的所有单据'
    begin
      select @text3=@text3+' and ivt_oper_listing in ( select ivt_oper_listing  from View_sdd02020 where com_id='''
      + rtrim(ltrim(@com_id))+''' and not ( ( ltrim(rtrim(isnull(beizhu,'''')))  like ''%促销价%'' )   '
      +' or ( ltrim(rtrim(isnull(beizhu,''''))) like ''%特价%'' ) '
      +' or ( ltrim(rtrim(isnull(beizhu,''''))) like ''%处理价%'' ) )  ) '
    end else if rtrim(ltrim(isnull(@beizhu,'')))='包含：赠送柜的所有单据'
    begin
      select @text3=@text3+' and ivt_oper_listing in ( select ivt_oper_listing  from View_sdd02020 where com_id='''
      + rtrim(ltrim(@com_id))+''' and ( ( ltrim(rtrim(isnull(beizhu,'''')))  like ''%赠送柜%'' ) )  ) '
    end else if rtrim(ltrim(isnull(@beizhu,'')))='不包含：赠送柜的所有单据'
    begin
      select @text3=@text3+' and ivt_oper_listing in ( select ivt_oper_listing  from View_sdd02020 where com_id='''
      + rtrim(ltrim(@com_id))+''' and not ( ( ltrim(rtrim(isnull(beizhu,'''')))  like ''%赠送柜%'' ) )  ) '
    end else
    begin
      select @text3=@text3+' and ivt_oper_listing in (select ivt_oper_listing  from View_sdd02020 where com_id='''
      + rtrim(ltrim(@com_id))+''' and  ltrim(rtrim(isnull(beizhu,'''')))  like ''%'+ltrim(rtrim(isnull(@beizhu,'')))+'%'' ) '
    end
  end
  if ltrim(rtrim(@c_memo)) <> ''  --单据备注
    select @text3=@text3+' and ltrim(rtrim(isnull(c_memo,''''))) like ''%'+ltrim(rtrim(@c_memo))+'%'' '

  if ltrim(rtrim(@sd_order_direct))='挂帐销售'  --业务类型：开始
  begin
    select @sd_order_direct='发货'
  end 
  else if ltrim(rtrim(@sd_order_direct))='现款销售' 
  begin
    select @sd_order_direct='现款'
  end 
  else if ltrim(rtrim(@sd_order_direct))='销售退货' 
  begin
    select @sd_order_direct='退货'
  end
  if ltrim(rtrim(@sd_order_direct)) <> ''      --业务类型：结束
    select @text3=@text3+' and ltrim(rtrim(isnull(sd_order_direct,''''))) = '''+ltrim(rtrim(@sd_order_direct))+''' '

  select @text3=@text3+' and comfirm_flag=''Y'' '

  if ltrim(rtrim(@lot_number))<>'' 
  begin
    if ltrim(rtrim(@lot_number))='按物品统计' 
    begin
      set @flag='1' 
    end else if ltrim(rtrim(@lot_number))='按单据统计'
    begin
      set @flag='2' 
    end else if ltrim(rtrim(@lot_number))='按客户统计'
    begin
      set @flag='3' 
    end
  end else set  @flag='1' 

  if ltrim(rtrim(@vendor_id))<>'' 
     select @text3=@text3+' and item_id in (select item_id  from ctl03001 where com_id='''
     +rtrim(ltrim(@com_id))+''' and  vendor_id  like '''+ltrim(rtrim(@vendor_id))+'%'') '

  if @item_Lenth2<>0
   select @text3=@text3+' and  item_Lenth>='''+ rtrim(ltrim(cast(@item_Lenth1 as varchar(40))))
    +''' and  item_Lenth<='''+ rtrim(ltrim(cast(@item_Lenth2 as varchar(40))))+''''
  if @item_Width2<>0
   select @text3=@text3+' and  item_Width>='''+ rtrim(ltrim(cast(@item_Width1 as varchar(40))))
    +''' and  item_Width<='''+ rtrim(ltrim(cast(@item_Width2 as varchar(40))))+''''
  if @item_Hight2<>0
   select @text3=@text3+' and  item_Hight>='''+ rtrim(ltrim(cast(@item_Hight1 as varchar(40))))
    +''' and  item_Hight<='''+ rtrim(ltrim(cast(@item_Hight2 as varchar(40))))+''''

  select @ssql=''     --销售退货
  select  @ssql='insert into #temp select com_id,sd_order_id,store_struct_id,regionalism_id,customer_id,dept_id,'
    +'clerk_id,so_consign_date,type_id_ctl03001 as type_id,item_id,peijian_id,item_spec,-sd_oq,sd_unit_price,-sd_oq*tax_sum_si,-sum_si,'
    +'-sum_si+sd_oq*tax_sum_si,''销售退货'',unit_id,ivt_oper_listing,send_sum,discount_rate,sd_order_direct,pack_unit,'
    +'-pack_num,-send_qty,beizhu,c_memo,HYJE,isnull(JS,0) as JS,-isnull(JS,0)*isnull(sd_oq,0) as ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,-( isnull(item_yardPrice,0)*isnull(sd_oq,0) ) as item_yardAmount,item_Sellprice,'
    +' -( isnull(item_Sellprice,0)*isnull(sd_oq,0) ) as item_SellAmount,item_zeroSell,' 
    +' -(isnull(item_Sellprice,0)-isnull(item_yardPrice,0))*isnull(sd_oq,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' -(isnull(item_zeroSell,0)-isnull(item_yardPrice,0))*isnull(sd_oq,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' -(isnull(tax_sum_si,0)-isnull(item_yardPrice,0))*isnull(sd_oq,0) as difference_cost_sumANDitem_yardPrice,vendor_id ,item_type_ctl03001 as item_type,c_color, '
    +' -isnull(i_weight,0)*isnull(sd_oq,0) as i_weight,-isnull(volume,0)*isnull(sd_oq,0) as volume,isnull(item_Lenth,0),isnull(item_Width,0),isnull(item_Hight,0) '
    +' from View_sdd02020  where  sd_order_direct=''退货'' '+' '+ltrim(rtrim(@text3))+' '+@text
  exec(@ssql)

  select @ssql=''     --销售开单
  select  @ssql='insert into #temp select com_id,sd_order_id,store_struct_id,regionalism_id,customer_id,dept_id,clerk_id,'
    +' so_consign_date,type_id_ctl03001 as type_id,item_id,peijian_id,item_spec,sd_oq,sd_unit_price,sd_oq*tax_sum_si,sum_si,sum_si-sd_oq*tax_sum_si,'
    +' (case  when sd_order_direct=''现款'' then  ''现款销售'' else ''挂帐销售'' end) as sd_order_direct,unit_id,ivt_oper_listing,'
    +' send_sum,discount_rate,sd_order_direct,pack_unit,pack_num,send_qty,beizhu,c_memo,HYJE,isnull(JS,0) as JS,isnull(JS,0)*isnull(sd_oq,0) as ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(item_yardPrice,0)*isnull(sd_oq,0) ) as item_yardAmount,item_Sellprice,'
    +' ( isnull(item_Sellprice,0)*isnull(sd_oq,0) ) as item_SellAmount,item_zeroSell,' 
    +' (isnull(item_Sellprice,0)-isnull(item_yardPrice,0))*isnull(sd_oq,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' (isnull(item_zeroSell,0)-isnull(item_yardPrice,0))*isnull(sd_oq,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' (isnull(tax_sum_si,0)-isnull(item_yardPrice,0))*isnull(sd_oq,0) as difference_cost_sumANDitem_yardPrice,vendor_id ,item_type_ctl03001 as item_type,c_color, '
    +' isnull(i_weight,0)*isnull(sd_oq,0) as i_weight,isnull(volume,0)*isnull(sd_oq,0) as volume,isnull(item_Lenth,0),isnull(item_Width,0),isnull(item_Hight,0) '
    +' from View_sdd02020  where (sd_order_direct=''发货'' or sd_order_direct=''现款'') '+' '+ltrim(rtrim(@text3))+' '+@text
  exec(@ssql)

  select @ssql=''    --销售开单优惠
  select  @ssql='insert into #temp select sdd02020.com_id,sd_order_id,'''',sdd02020.regionalism_id,sdd02020.customer_id,sdd02020.dept_id,sdd02020.clerk_id,
    so_consign_date,'''' as type_id,'''','''','''',0,0,0,-i_agiosum,0,
    (case  when sd_order_direct=''现款'' then  ''现款优惠'' else ''挂帐优惠'' end) as sd_order_direct,'''',ivt_oper_listing,
    0,0,sd_order_direct,'''',0,0,'''','''',HYJE,0 as JS,0 as ZJS,0 BXQ,HYS,FHDZ,'
    +' item_yardPrice=0,item_yardAmount=0,item_Sellprice=0,item_SellAmount=0,item_zeroSell=0,' 
    +' difference_item_yardPriceANDitem_Sellprice=0,'
    +' difference_item_yardPriceANDitem_zeroSell=0,'
    +' difference_cost_sumANDitem_yardPrice=0,'''' as vendor_id ,'''' as item_type ,'''' as c_color, '
    +' i_weight=null,volume=null,item_Lenth=null,item_Width=null,item_Hight=null '
    +' from sdd02020 LEFT JOIN SDf00504 ON sdd02020.customer_id=SDf00504.customer_id where 
    (sd_order_direct=''发货'' or sd_order_direct=''现款'') and isnull(i_agiosum,0)<>0  and  sdd02020.com_id='''+ rtrim(ltrim(@com_id))+'''
    and ivt_oper_listing in (select ivt_oper_listing from #temp )  '
  exec(@ssql)

  select @ssql=''
  if ltrim(rtrim(@flag))='1'
  begin
    select  @ssql=' select com_id,sd_order_id,store_struct_id,regionalism_id,sd_order_direct,customer_id,dept_id,'
    +' clerk_id,so_consign_date,ltrim(rtrim(isnull(type_id,''''))) as type_id,item_id,peijian_id,item_spec,unit_id,sd_oq,sd_unit_price,cost_sum,sum_si,profit,'
    +' ivt_oper_listing,send_sum,discount_rate,c_type,pack_unit,pack_num,send_qty,beizhu,c_memo,order1=''1000'','
    +' isnull(HYJE,0) as HYJE,JS,ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice,'
    +' item_SellAmount,item_zeroSell,' 
    +' isnull(difference_item_yardPriceANDitem_Sellprice,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' isnull(difference_item_yardPriceANDitem_zeroSell,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' isnull(difference_cost_sumANDitem_yardPrice,0) as difference_cost_sumANDitem_yardPrice ,'
    +' ltrim(rtrim(isnull(vendor_id,''''))) as vendor_id ,ltrim(rtrim(isnull(item_type,''''))) as item_type,ltrim(rtrim(isnull(c_color,''''))) as c_color, '
    +' isnull(i_weight,0) as i_weight,isnull(volume,0) as volume,'
    +' item_Lenth,item_Width,item_Hight ' 
    +' from  #temp  '
    +'union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''型号小计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,ltrim(rtrim(isnull(type_id,''''))) as type_id,item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=''1100'','
    +' sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' ltrim(rtrim(isnull(vendor_id,''''))) as vendor_id ,ltrim(rtrim(isnull(item_type,''''))) as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +' from  #temp  group by com_id,ltrim(rtrim(isnull(vendor_id,''''))) ,ltrim(rtrim(isnull(type_id,''''))),ltrim(rtrim(isnull(item_type,''''))) '
    +'union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''类别小计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,ltrim(rtrim(isnull(type_id,''''))) as type_id,item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=''1110'','
    +' sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' ltrim(rtrim(isnull(vendor_id,''''))) as vendor_id ,'''' as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +' from  #temp  group by com_id,ltrim(rtrim(isnull(vendor_id,''''))) ,ltrim(rtrim(isnull(type_id,''''))) '
    +'union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''品牌合计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id='''',item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=''1111'','
    +' sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' ltrim(rtrim(isnull(vendor_id,''''))) as vendor_id ,'''' as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +' from  #temp group by com_id,ltrim(rtrim(isnull(vendor_id,'''')))  '
    +'union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''总计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id='''',item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=''2000'','
    +' sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' '''' as vendor_id ,'''' as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +' from  #temp group by com_id order by com_id,vendor_id desc,type_id desc,item_type desc,order1 asc '
  end else   if ltrim(rtrim(@flag))='2' begin
    select  @ssql=' select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''小计'','
    +'customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id='''',item_id=null,peijian_id=null,'
    +'item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +'sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +'order2=(ivt_oper_listing),order3=0,sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' '''' as vendor_id ,'''' as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +'  from  #temp group by com_id,ivt_oper_listing '
    +'union all select com_id,sd_order_id,store_struct_id,regionalism_id,sd_order_direct,customer_id,dept_id,'
    +' clerk_id,so_consign_date,ltrim(rtrim(isnull(type_id,''''))) as type_id,item_id,peijian_id,item_spec,unit_id,sd_oq,sd_unit_price,cost_sum,sum_si,profit,'
    +' ivt_oper_listing,send_sum,discount_rate,c_type,pack_unit,pack_num,send_qty,beizhu,c_memo,order1=0,'
    +' order2=(ivt_oper_listing),order3=0,isnull(HYJE,0) as HYJE,JS,ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice,'
    +' item_SellAmount,item_zeroSell,' 
    +' isnull(difference_item_yardPriceANDitem_Sellprice,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' isnull(difference_item_yardPriceANDitem_zeroSell,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' isnull(difference_cost_sumANDitem_yardPrice,0) as difference_cost_sumANDitem_yardPrice, '
    +' ltrim(rtrim(isnull(vendor_id,''''))) as vendor_id ,ltrim(rtrim(isnull(item_type,''''))) as item_type,ltrim(rtrim(isnull(c_color,''''))) as c_color, '
    +' isnull(i_weight,0) as i_weight,isnull(volume,0) as volume,'
    +' item_Lenth,item_Width,item_Hight ' 
    +'  from  #temp '
    +'union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''合计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id='''',item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,order2=null,'
    +' order3=1,sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' '''' as vendor_id ,'''' as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +'  from  #temp  group by com_id  order by order3,order2 desc,order1,so_consign_date desc '
  end else   if ltrim(rtrim(@flag))='3' begin
    select  @ssql=' select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''小计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id='''',item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +' order2=(customer_id),order3=0,sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' '''' as vendor_id ,'''' as item_type,'''' as c_color, '    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null ' 
    +' from  #temp  group by com_id,customer_id '
    +'union all select com_id,sd_order_id,store_struct_id,regionalism_id,sd_order_direct,customer_id,dept_id,'
    +' clerk_id,so_consign_date,ltrim(rtrim(isnull(type_id,''''))) as type_id,item_id,peijian_id,item_spec,unit_id,sd_oq,sd_unit_price,cost_sum,sum_si,profit,'
    +' ivt_oper_listing,send_sum,discount_rate,c_type,pack_unit,pack_num,send_qty,beizhu,c_memo,order1=0,order2=(customer_id),'
    +' order3=0,isnull(HYJE,0) as HYJE,JS,ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice,'
    +' item_SellAmount,item_zeroSell,' 
    +' isnull(difference_item_yardPriceANDitem_Sellprice,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' isnull(difference_item_yardPriceANDitem_zeroSell,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' isnull(difference_cost_sumANDitem_yardPrice,0) as difference_cost_sumANDitem_yardPrice, '
    +' ltrim(rtrim(isnull(vendor_id,''''))) as vendor_id ,ltrim(rtrim(isnull(item_type,''''))) as item_type,ltrim(rtrim(isnull(c_color,''''))) as c_color, '
    +' isnull(i_weight,0) as i_weight,isnull(volume,0) as volume,'
    +' item_Lenth,item_Width,item_Hight ' 
    +' from  #temp  '
    +'union all select com_id,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''合计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id='''',item_id=null,peijian_id=null,'
    +' item_spec=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +' order2=null,order3=1,sum(isnull(HYJE,0)) as HYJE,JS=null,sum(isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice, '
    +' '''' as vendor_id ,'''' as item_type,'''' as c_color, '
    +' sum(isnull(i_weight,0)) as i_weight,sum(isnull(volume,0)) as volume, '
    +' item_Lenth=null,item_Width=null,item_Hight=null '
    +' from  #temp  group by com_id order by order3,order2,order1,so_consign_date desc '
  end
  exec(@ssql)

/*
  select @ssql=''
  if ltrim(rtrim(@flag))='1'
  begin
    select  @ssql=' select com_id=null,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''小计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id=null,item_id=null,peijian_id=null,'
    +' lot_number=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +' order2=(customer_id),order3=0,sum(isnull(HYJE,0)) as HYJE,sum(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice '
    +' from  #temp  group by com_id,customer_id '
    +'union all select com_id,sd_order_id,store_struct_id,regionalism_id,sd_order_direct,customer_id,dept_id,'
    +' clerk_id,so_consign_date,type_id,item_id,peijian_id,lot_number,unit_id,sd_oq,sd_unit_price,cost_sum,sum_si,profit,'
    +' ivt_oper_listing,send_sum,discount_rate,c_type,pack_unit,pack_num,send_qty,beizhu,c_memo,order1=0,order2=(customer_id),'
    +' order3=0,isnull(HYJE,0) as HYJE,(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice,'
    +' item_SellAmount,item_zeroSell,' 
    +' isnull(difference_item_yardPriceANDitem_Sellprice,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' isnull(difference_item_yardPriceANDitem_zeroSell,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' isnull(difference_cost_sumANDitem_yardPrice,0) as difference_cost_sumANDitem_yardPrice '
    +' from  #temp  '
    +'union all select com_id=null,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''合计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id=null,item_id=null,peijian_id=null,'
    +' lot_number=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +' order2=null,order3=1,sum(isnull(HYJE,0)) as HYJE,sum(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice '
    +' from  #temp  group by com_id order by order3,order2,order1,so_consign_date '
  end else   if ltrim(rtrim(@flag))='2' begin
    select  @ssql=' select com_id=null,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''小计'','
    +'customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id=null,item_id=null,peijian_id=null,'
    +'lot_number=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +'sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +'sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +'order2=(ivt_oper_listing),order3=0,sum(isnull(HYJE,0)) as HYJE,sum(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice '
    +'  from  #temp group by com_id,ivt_oper_listing '
    +'union all select com_id,sd_order_id,store_struct_id,regionalism_id,sd_order_direct,customer_id,dept_id,'
    +' clerk_id,so_consign_date,type_id,item_id,peijian_id,lot_number,unit_id,sd_oq,sd_unit_price,cost_sum,sum_si,profit,'
    +' ivt_oper_listing,send_sum,discount_rate,c_type,pack_unit,pack_num,send_qty,beizhu,c_memo,order1=0,'
    +' order2=(ivt_oper_listing),order3=0,isnull(HYJE,0) as HYJE,(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice,'
    +' item_SellAmount,item_zeroSell,' 
    +' isnull(difference_item_yardPriceANDitem_Sellprice,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' isnull(difference_item_yardPriceANDitem_zeroSell,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' isnull(difference_cost_sumANDitem_yardPrice,0) as difference_cost_sumANDitem_yardPrice '
    +'  from  #temp '
    +'union all select com_id=null,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''合计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id=null,item_id=null,peijian_id=null,'
    +' lot_number=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,order2=null,'
    +' order3=1,sum(isnull(HYJE,0)) as HYJE,sum(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice '
    +'  from  #temp  group by com_id  order by order3,order2,order1,so_consign_date '
  end else   if ltrim(rtrim(@flag))='3' begin
    select  @ssql=' select com_id=null,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''小计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id=null,item_id=null,peijian_id=null,'
    +' lot_number=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=NULL,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +' order2=(item_id),order3=0,sum(isnull(HYJE,0)) as HYJE,sum(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice '
    +' from  #temp  group by com_id,item_id '
    +'union all select com_id,sd_order_id,store_struct_id,regionalism_id,sd_order_direct,customer_id,dept_id,'
    +' clerk_id,so_consign_date,type_id,item_id,peijian_id,lot_number,unit_id,sd_oq,sd_unit_price,cost_sum,sum_si,profit,'
    +' ivt_oper_listing,send_sum,discount_rate,c_type,pack_unit,pack_num,send_qty,beizhu,c_memo,order1=0,order2=(item_id),'
    +' order3=0,isnull(HYJE,0) as HYJE,(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ,HYS,FHDZ,'
    +' item_yardPrice,( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice,'
    +' item_SellAmount,item_zeroSell,' 
    +' isnull(difference_item_yardPriceANDitem_Sellprice,0) as difference_item_yardPriceANDitem_Sellprice,'
    +' isnull(difference_item_yardPriceANDitem_zeroSell,0) as difference_item_yardPriceANDitem_zeroSell,'
    +' isnull(difference_cost_sumANDitem_yardPrice,0) as difference_cost_sumANDitem_yardPrice '
    +' from  #temp  '
    +'union all select com_id=null,sd_order_id=null,store_struct_id=null,regionalism_id=null,sd_order_direct=''合计'','
    +' customer_id=null,dept_id=null,clerk_id=null,so_consign_date=null,type_id=null,item_id=null,peijian_id=null,'
    +' lot_number=null,unit_id=null,sum(sd_oq) as sd_oq,sd_unit_price=null,sum(cost_sum) as cost_sum,sum(sum_si) as sum_si,'
    +' sum(sum_si-cost_sum) as profit,ivt_oper_listing=null,send_sum=null,discount_rate=null,c_type=null,pack_unit=null,'
    +' sum(pack_num) as pack_num,sum(send_qty) as send_qty,beizhu=null,c_memo=null,order1=1,'
    +' order2=null,order3=1,sum(isnull(HYJE,0)) as HYJE,sum(isnull(sd_oq,0)*isnull(ZJS,0)) as ZJS,BXQ=null,HYS=null,FHDZ=null,'
    +' item_yardPrice=null,sum( isnull(sd_oq,0)*isnull(item_yardPrice,0) ) as item_yardAmount,item_Sellprice=null,'
    +' sum(item_SellAmount) as item_SellAmount,item_zeroSell=null,' 
    +' sum(isnull(difference_item_yardPriceANDitem_Sellprice,0)) as difference_item_yardPriceANDitem_Sellprice,'
    +' sum(isnull(difference_item_yardPriceANDitem_zeroSell,0)) as difference_item_yardPriceANDitem_zeroSell,'
    +' sum(isnull(difference_cost_sumANDitem_yardPrice,0)) as difference_cost_sumANDitem_yardPrice '
    +' from  #temp  group by com_id order by order3,order2,order1,so_consign_date '
  end
  exec(@ssql)
*/
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_SellQry
return 0
end else
begin
COMMIT TRANSACTION mytranSp_SellQry
return 1
end














GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

