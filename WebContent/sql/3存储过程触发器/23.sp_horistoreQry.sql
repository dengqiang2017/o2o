if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_horistoreQry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_horistoreQry]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE sp_horistoreQry
       (@com_id char(10),
        @star_date varchar(30),
        @end_date varchar(30),
        @type_id varchar(30),
        @item_id varchar(40))
AS 
    declare @text3 varchar(2000),@ssql varchar(4000),@sort_id varchar(30),@sid int,@store_struct_id varchar(30),
    @iprice decimal(17,6),@year_date int,@peijian_id varchar(40),
    @month_date tinyint,@finacial_date_bigen datetime,@finacial_date_end datetime,@oh_oq decimal(17,2),
    @oh_Amount decimal(17,2),@in_storenum decimal(17,2),@in_storeAmount decimal(17,2),@out_storenum decimal(17,2),
    @acct_oq decimal(17,2),@acct_price decimal(17,2),@acct_sum decimal(17,2),@store_date datetime,@differ_quant decimal(17,2)

  create table #temp123 (com_id char(10),item_id varchar(40),peijian_id varchar(40),store_struct_id1  varchar(30),ivt_sum1 decimal(15,2),
  store_struct_id2  varchar(30),ivt_sum2 decimal(15,2),store_struct_id3  varchar(30),ivt_sum3 decimal(15,2),
  store_struct_id4  varchar(30),ivt_sum4 decimal(15,2),store_struct_id5  varchar(30),ivt_sum5 decimal(15,2),
  store_struct_id6  varchar(30),ivt_sum6 decimal(15,2),store_struct_id7  varchar(30),ivt_sum7 decimal(15,2),i_cost1 decimal(15,2),
  i_cost2 decimal(15,2),i_cost3 decimal(15,2),i_cost4 decimal(15,2),i_cost5 decimal(15,2),i_cost6 decimal(15,2),i_cost7 decimal(15,2)) 


  create table #temp (com_id char(10),store_struct_id varchar(30),item_id varchar(40),peijian_id varchar(40),
  oh_oq decimal(17,2),in_storenum decimal(17,2),out_storenum decimal(17,2),differ_quant decimal(17,2),
  acct_oq decimal(17,2),store_date datetime,sid int,maintenance_datetime datetime,loss_oq decimal(17,2))

  create table #temp1 (com_id char(10),store_struct_id varchar(30),item_id varchar(40),peijian_id varchar(40),
  oh_oq decimal(17,2),in_storenum decimal(17,2),out_storenum decimal(17,2),differ_quant decimal(17,2),
  acct_oq decimal(17,2),store_date datetime,sid int,maintenance_datetime datetime,loss_oq decimal(17,2))

  select @text3=''
  select @text3='   and  com_id='+''''+ rtrim(ltrim(@com_id))+''''
  if  rtrim(ltrim(@type_id))<>''
  select @text3= @text3+' and item_id in (select item_id from ctl03001 where com_id='''+@com_id
    +''' and type_id ='''+rtrim(ltrim(@type_id))+''')'
  if  rtrim(ltrim(@item_id))<>''
  select @text3= @text3+' and item_id='''+ rtrim(ltrim(@item_id))+''''

  select @ssql=''
  select @ssql=' insert into #temp1 select com_id,store_struct_id,item_id,(select peijian_id from ctl03001 where item_id=ivtd01300.item_id) as peijian_id,'
  +'oh,0,0,0,0,maintenance_datetime,0,maintenance_datetime,0  from ivtd01300 where  com_id='''+ rtrim(ltrim(@com_id))+''''
  if  rtrim(ltrim(@type_id))<>''
   select @ssql= @ssql+' and item_id in (select item_id  from ctl03001 where com_id='+''''
   + rtrim(ltrim(@com_id))+''''+'  and  type_id='''+@type_id+''')'
  if  rtrim(ltrim(@item_id))<>''
   select @ssql= @ssql+' and item_id='''+ rtrim(ltrim(@item_id))+''''
   select @ssql=@ssql+'  and initial_flag=''Y'''
  exec(@ssql)/*--初始化入进*/

/*-----------------------------------------小于开始日期@star_date1-----------------------------------------------------------*/
  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,isnull(rep_qty,0),0,0,0,store_date,1,mainten_datetime,0 '
  +'from View_STDM03001  where  (stock_type=''进货'' or stock_type=''借货'')'+@text3/*--采购入库*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,-isnull(rep_qty,0),0,0,0,store_date,1,mainten_datetime,0 '
  +'from View_STDM03001  where  stock_type=''退货'''+@text3/*--采购退货出库*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,isnull(sd_oq,0),0,0,so_consign_date,1,mainten_datetime,0 '
  +'  from View_sdd02020  where  (sd_order_direct=''发货'' or sd_order_direct=''现款'')'+@text3/*--销售出库*/
  select @ssql=@ssql+' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,-isnull(sd_oq,0),0,0,so_consign_date,1,mainten_datetime,0  '
  +'from View_sdd02020 where sd_order_direct=''退货'''+@text3 /*--销售退货*/
  select @ssql=@ssql+' and  so_consign_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,isnull(oper_qty,0),0,0,0,store_date,1,maintenance_datetime,0  '
  +'from VIEW_ivt01201 where ivt_oper_id=''入库'''+@text3/* --入库*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,isnull(oper_qty,0),0,0,store_date,1,maintenance_datetime,0 '
  +' from VIEW_ivt01201 where ivt_oper_id=''出库'''+@text3 /*--出库*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,corpstorestruct_id,item_id,peijian_id,0,isnull(oper_qty,0),0,0,0,store_date,1,maintenance_datetime,0  '
  +'from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3 /*--调拨入库*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,isnull(oper_qty,0),0,0,store_date,1,maintenance_datetime,0 '
  +'from VIEW_ivt01201 where ivt_oper_id=''调拨'''+@text3 /*--调拨出库*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,0,0,0,store_date,1,maintenance_datetime,isnull(oper_qty,0) '
  +' from VIEW_ivt01201 where ivt_oper_id=''报损'''+@text3 /*--库存报损*/
  select @ssql=@ssql+' and  store_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,0,differ_quant,0,count_datetime,1,maintenance_datetime,0 '
  +' from  VIEW_Ivtd01310 where (1=1)  '+@text3 /*--盘点数量*/
  select @ssql=@ssql+' and  count_datetime<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and count_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,(select peijian_id from ctl03001 where item_id=ivtd03001.item_id) as peijian_id,'
  +'0,isnull(group_oq,0),0,0,0,so_effect_datetime,1,mainten_datetime,0 '
  +'from ivtd03001  where group_split=''组装'''+@text3 /*--组装入库*/

  select @ssql=@ssql+' and  so_effect_datetime<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,0,isnull(sd_oq,0),0,0,so_effect_datetime,1,mainten_datetime,0 '
  +'from VIEW_ivtd03001 where group_split=''组装'''+@text3 /*--组装出库*/
  select @ssql=@ssql+' and  so_effect_datetime<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,(select peijian_id from ctl03001 where item_id=ivtd03001.item_id) as peijian_id,'
  +'0,0,isnull(group_oq,0),0,0,so_effect_datetime,1,mainten_datetime,0  '
  +' from ivtd03001  where group_split=''拆卸'''+@text3 /*--拆卸出库*/
  select @ssql=@ssql+' and  so_effect_datetime<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,store_struct_id,item_id,peijian_id,0,isnull(sd_oq,0),0,0,0,so_effect_datetime,1,mainten_datetime,0  '
  +' from VIEW_ivtd03001 where group_split=''拆卸''' /*--拆卸入库*/
  select @ssql=@ssql+' and  so_effect_datetime<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,sd_order_id,item_id,peijian_id,0,isnull(sd_oq,0),0,0,0,tax_invoice_date,1,mainten_datetime,0  '
  +'from VIEW_Ard02040 where tax_invoice_direct=''供货'''+@text3 /*--供货入库*/
  select @ssql=@ssql+' and  tax_invoice_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  select  @ssql=''
  select  @ssql='insert into #temp1 select com_id,sd_order_id,item_id,peijian_id,0,0,isnull(sd_oq,0),0,0,tax_invoice_date,1,mainten_datetime,0 '
  +' from VIEW_Ard02040 where tax_invoice_direct=''客户'''+@text3 /*--客户出库*/
  select @ssql=@ssql+' and  tax_invoice_date<='''+ rtrim(ltrim(@end_date))+''''
  select @ssql= @ssql+'  and comfirm_flag=''Y'''
  exec(@ssql)

  insert into #temp (com_id,store_struct_id,item_id,oh_oq,in_storenum,out_storenum,differ_quant,acct_oq,
  store_date,sid,loss_oq) select com_id,store_struct_id,item_id,sum(oh_oq) as oh_oq,sum(in_storenum) as in_storenum,
  sum(out_storenum) as out_storenum,sum(differ_quant) as differ_quant,
  (sum(oh_oq)+sum(in_storenum)-sum(out_storenum)-sum(differ_quant)-sum(loss_oq)) as acct_oq,
  getdate(),0 as sid,sum(loss_oq) as loss_oq from #temp1  group by com_id,store_struct_id,item_id  

  select @ssql=''
  select @ssql='insert into  #temp123 (com_id,item_id,peijian_id)  select com_id,item_id,'
  +'(select peijian_id from ctl03001 where item_id=#temp.item_id) as peijian_id  from #temp  group by com_id,item_id '
  exec(@ssql)

  declare mycur  CURSOR FOR 
         select a.item_id from #temp123  a   order by com_id,item_id
   OPEN mycur
     FETCH NEXT FROM mycur 
       INTO @item_id
   WHILE @@FETCH_STATUS = 0
   begin
      set @sid=1

      declare mycur12  CURSOR FOR 
         select a.sort_id from ivt01001 a   order by com_id,store_struct_id
      OPEN mycur12
      FETCH NEXT FROM mycur12 
       INTO @sort_id
      WHILE @@FETCH_STATUS=0
      begin         
        if @sid<=7
        begin
          if @sid=1
          begin          
            update #temp123 set store_struct_id1=@sort_id,ivt_sum1=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost1=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id) 
            from #temp123  where  item_id=@item_id 
          end
          if @sid=2
          begin          
            update #temp123 set store_struct_id2=@sort_id,ivt_sum2=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost2=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id) 
            from #temp123  where  item_id=@item_id 
          end
          if @sid=3
          begin          
            update #temp123 set store_struct_id3=@sort_id,ivt_sum3=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost3=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id) 
            from #temp123  where  item_id=@item_id 
          end
          if @sid=4
          begin          
            update #temp123 set store_struct_id4=@sort_id,ivt_sum4=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost4=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id) 
            from #temp123  where  item_id=@item_id 
          end
          if @sid=5
          begin          
            update #temp123 set store_struct_id5=@sort_id,ivt_sum5=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost5=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id)  
            from #temp123  where  item_id=@item_id 
          end
          if @sid=6
          begin          
            update #temp123 set store_struct_id6=@sort_id,ivt_sum6=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost6=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id) 
            from #temp123  where  item_id=@item_id 
          end
          if @sid=7
          begin          
            update #temp123 set store_struct_id7=@sort_id,ivt_sum7=(select isnull(acct_oq,0) from #temp where 
            store_struct_id=@sort_id  and item_id=@item_id),
            i_cost7=(select isnull(i_price,0) from ivtd01302 where com_id=@com_id  and store_struct_id=@sort_id  and item_id=@item_id)  
            from #temp123  where  item_id=@item_id 
          end


        end
        set @sid=@sid+1

        FETCH NEXT FROM mycur12 
        INTO @sort_id

       end
       CLOSE mycur12       
       DEALLOCATE mycur12


       FETCH NEXT FROM mycur 
       INTO @item_id
    end
    CLOSE mycur       
    DEALLOCATE mycur


  select @ssql=''
  select  @ssql=' select com_id,item_id,peijian_id,store_struct_id1,ivt_sum1,store_struct_id2,ivt_sum2,store_struct_id3,ivt_sum3,'
  +'store_struct_id4,ivt_sum4,store_struct_id5,ivt_sum5 ,store_struct_id6,ivt_sum6 ,store_struct_id7,ivt_sum7,i_cost1,i_cost2,'
  +'i_cost3,i_cost4,i_cost5,i_cost6,i_cost7  from #temp123 order by com_id,peijian_id'
  exec(@ssql)



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

