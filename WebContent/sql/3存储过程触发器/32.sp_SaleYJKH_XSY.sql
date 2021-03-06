if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SaleYJKH_XSY]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SaleYJKH_XSY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--销售业绩考核:按销售人员
CREATE     PROCEDURE sp_SaleYJKH_XSY
       (@com_id1 char(10),
       @star_date1 varchar(30),
       @end_date1 varchar(30),
       @dept_id1 varchar(30),
       @clerk_id1 varchar(35),
       @Cus_id1 varchar(30),
       @BillNo varchar(40),
       @dept_right1 varchar(8000))
AS 
BEGIN TRANSACTION mytranSp_SaleYJKH_XSY
    declare @text3 varchar(8000),@ssql varchar(8000),@finacial_y int,@finacial_m tinyint,
    @store_struct_id varchar(30),@sd_oq decimal(22,6),@item_id varchar(40),@lot_number  varchar(40),@YYSL decimal(22,6)


     create table #temp  (com_id char(10),store_struct_id varchar(30),dept_id varchar(30),clerk_id varchar(35),
     store_date datetime,type_id varchar(30),item_id varchar(40),lot_number varchar(40),i_SellNum decimal(22,6),--销售金额
     sd_oq decimal(22,6),i_cost decimal(22,6),sale_gain decimal(22,6),finacial_y int,finacial_m tinyint,XSFY decimal(22,6),DJH varchar(30),WDJH varchar(30),cus_id varchar(30))

     create table #temp1 (com_id char(10),store_struct_id varchar(30),dept_id varchar(30),clerk_id varchar(35),
     store_date datetime,type_id varchar(30),item_id varchar(40),lot_number varchar(40),i_SellNum decimal(22,6),--销售金额
     sd_oq decimal(22,6),i_cost decimal(22,6),sale_gain decimal(22,6),finacial_y int,finacial_m tinyint,XSFY decimal(22,6),DJH varchar(30),WDJH varchar(30),cus_id varchar(30))

select @YYSL=isnull((select TOP 1 YYSL FROM CTLf01000),0)

select @text3=''
select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id1))+''''
if  rtrim(ltrim( @dept_id1))<>''
  select @text3= @text3+' and dept_id='+''''+rtrim(ltrim( @dept_id1))+''''
if rtrim(ltrim( @clerk_id1))<>''
  select @text3=@text3+' and  clerk_id='+''''+rtrim(ltrim( @clerk_id1))+''''
if rtrim(ltrim( @Cus_id1))<>''
  select @text3=@text3+' and  customer_id='+''''+rtrim(ltrim( @Cus_id1))+''''
if rtrim(ltrim( @BillNo))<>''
  select @text3=@text3+' and sd_order_id like ''%'+rtrim(ltrim( @BillNo))+'%'''
if rtrim(ltrim(@dept_right1))<>''
  select @text3= @text3+' and '+@dept_right1

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id,dept_id,clerk_id,so_consign_date,type_id=null,item_id,'  --销售发货
      +'lot_number=null,isnull(sum_si,0),isnull(sd_oq,0),(isnull(tax_sum_si,0)*isnull(sd_oq,0)) as i_cost,0 as sale_gain,finacial_y,finacial_m,0 as XSFY,ivt_oper_listing,sd_order_id,customer_id as cus_id from VIEW_SDd02020  where '
      +'  (sd_order_direct=''发货'' or sd_order_direct=''现款'') and so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''
      +rtrim(ltrim(@end_date1))+''' '+@text3+'  and comfirm_flag=''Y'' '
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id,dept_id,clerk_id,so_consign_date,type_id=null,item_id,'  --销售退货
      +'lot_number=null,-isnull(sum_si,0),-isnull(sd_oq,0),-(isnull(tax_sum_si,0)*isnull(sd_oq,0)) as i_cost,0 as sale_gain,finacial_y,finacial_m,0 as XSFY,ivt_oper_listing,sd_order_id,customer_id as cus_id from VIEW_SDd02020  where  '
      +'sd_order_direct=''退货''and so_consign_date>='''+ rtrim(ltrim(@star_date1))+''' and  so_consign_date<='''
      +rtrim(ltrim(@end_date1))+''' '+@text3+'  and comfirm_flag=''Y'' ' 
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp select com_id,store_struct_id=null,dept_id,clerk_id,finacial_d,type_id=null,item_id=null,'  --销售费用
      +' lot_number=null,0 as i_SellNum,0 as sd_oq,0 as i_cost,0 as sale_gain,finacial_y,finacial_m,sum_si as XSFY,ivt_oper_listing,sd_order_id,customer_id as cus_id from VIEW_SDDM03001  where  '
      +' finacial_d>='''+ rtrim(ltrim(@star_date1))+''' and  finacial_d<='''+rtrim(ltrim(@end_date1))+''' and ltrim(rtrim(isnull(vendor_id,'''')))='''' '+@text3
  exec(@ssql)

--对上述单据进行汇总
  select  @ssql=''
  select  @ssql=' insert into #temp1 select com_id,store_struct_id=null,dept_id,clerk_id,store_date=null,type_id=null,item_id=null,'  
      +' lot_number=null,sum(isnull(i_SellNum,0)),sum(isnull(sd_oq,0)),sum(isnull(i_cost,0)) as i_cost,0 as sale_gain,finacial_y=null,finacial_m=null,sum(isnull(XSFY,0)) as XSFY,ivt_oper_listing=null,sd_order_id=null,cus_id from #temp '
      +' group by com_id,dept_id,clerk_id,cus_id  ' 
  exec(@ssql)
/*
  select @ssql=''
  select @ssql='select com_id,dept_id=''小计'',clerk_id,store_date=null,DJH=null,WDJH=null,customer_id=null,i_SellNum=sum(isnull(i_SellNum,0)),i_cost=sum(isnull(i_cost,0)),sale_gain=sum(isnull(i_SellNum,0))-sum(isnull(i_cost,0)),XSFY=sum(isnull(XSFY,0)),YYS=sum(isnull(i_SellNum,0))*'+cast(@YYSL as varchar)+'/100,order1=1,'
    +' order2=(clerk_id),order3=(dept_id) from  #temp1  group by com_id,dept_id,clerk_id '
    +' union all select com_id,dept_id,clerk_id,store_date=null,DJH=null,WDJH=null,cus_id,i_SellNum,i_cost,sale_gain=isnull(i_SellNum,0)-isnull(i_cost,0),XSFY,YYS=isnull(i_SellNum,0)*'+cast(@YYSL as varchar)+'/100,order1=0,order2=(clerk_id),order3=(dept_id) from  #temp1 '
    +' union all select com_id,dept_id=''合计'',clerk_id=null,store_date=null,DJH=null,WDJH=null,cus_id=null,i_SellNum=sum(isnull(i_SellNum,0)),i_cost=sum(isnull(i_cost,0)),sale_gain=sum(isnull(i_SellNum,0))-sum(isnull(i_cost,0)),XSFY=sum(isnull(XSFY,0)),YYS=sum(isnull(i_SellNum,0))*'+cast(@YYSL as varchar)+'/100,order1=1,'
    +' order2=null, CAST((sum(isnull(i_SellNum,0))) AS int) as order3 from  #temp1 group by com_id order by order3,order2,order1  '
  exec(@ssql)
*/
  select @ssql=''
  select @ssql='select com_id,dept_id=''小计'',clerk_id,store_date=null,DJH=null,WDJH=null,customer_id=null,i_SellNum=sum(isnull(i_SellNum,0)),i_cost=sum(isnull(i_cost,0)),sale_gain=sum(isnull(i_SellNum,0))-sum(isnull(i_cost,0)),XSFY=sum(isnull(XSFY,0)),YYS=sum(isnull(i_SellNum,0))*'+cast(@YYSL as varchar)+'/100,order1=1,'
    +' order2=(dept_id+clerk_id),order3=0 from  #temp1  group by com_id,dept_id,clerk_id '
    +' union all select com_id,dept_id,clerk_id,store_date=null,DJH=null,WDJH=null,cus_id,i_SellNum,i_cost,sale_gain=isnull(i_SellNum,0)-isnull(i_cost,0),XSFY,YYS=isnull(i_SellNum,0)*'+cast(@YYSL as varchar)+'/100,order1=0,order2=(dept_id+clerk_id),order3=0 from  #temp1 '
    +' union all select com_id,dept_id=''合计'',clerk_id=null,store_date=null,DJH=null,WDJH=null,cus_id=null,i_SellNum=sum(isnull(i_SellNum,0)),i_cost=sum(isnull(i_cost,0)),sale_gain=sum(isnull(i_SellNum,0))-sum(isnull(i_cost,0)),XSFY=sum(isnull(XSFY,0)),YYS=sum(isnull(i_SellNum,0))*'+cast(@YYSL as varchar)+'/100,order1=1,'
    +' order2=null, order3=1 from  #temp1 group by com_id order by order3,order2,order1  '
  exec(@ssql)

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION mytranSp_SaleYJKH_XSY
return 0
end else
begin
COMMIT TRANSACTION mytranSp_SaleYJKH_XSY
return 1
end





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

