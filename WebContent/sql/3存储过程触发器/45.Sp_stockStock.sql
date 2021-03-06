if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_stockStock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_stockStock]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--采购入库
CREATE    PROCEDURE Sp_stockStock 
	@com_ID char(10),
        @rcv_auto_no varchar(30),
        @comfirm_flag char(1)
AS
set nocount on
set xact_abort on
BEGIN TRANSACTION mytranSp_stockStock
        declare @store_struct_id varchar(30),@store_date datetime,@vendor_id varchar(30),@i_price decimal(17,6),@accn_ivt decimal(17,6),
        @item_id char(40),@lot_number varchar(40),@finacial_y int,@finacial_m tinyint,@rep_qty decimal(17,6),@st_sum decimal(17,6),
        @st_auto_no varchar(30),@price decimal(17,6),@i_currentValue int,@d_currentDate varchar(30),@arrearage decimal(17,6),
        @prefix varchar(20),@suffix varchar(20),@numb varchar(10) ,@recieved_auto_id varchar(30),@allsum_si decimal(17,6),
        @dept_id varchar(30),@ivt_oper_cfm varchar(35),@clerk_id varchar(35),@st_detail_id int ,@pay_sum decimal(17,6),
        @scurDate varchar(30),@S_RKDH varchar(30),@sort_id varchar(30),@rej_flag char(1),@settlement_type_id varchar(30),@hav_rcv decimal(17,6)
	
        SELECT  @FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M = B.FINACIAL_M,@STORE_DATE=B.STORE_DATE,@vendor_id=B.vendor_id,
        @allsum_si=b.st_sum,@ivt_oper_cfm=b.ivt_oper_cfm,@rej_flag=isnull(b.rej_flag,'1'),@settlement_type_id=b.settlement_type_id,
        @dept_id=b.dept_id,@clerk_id=b.clerk_id,@pay_sum=isnull(b.pay_sum,0)  FROM STDM03001 B
	WHERE  B.rcv_auto_no = @rcv_auto_no AND B.COM_ID = @COM_ID         
declare mycur  CURSOR FOR 
select a.item_id,a.lot_number,a.rep_qty,a.price,a.st_sum,a.store_struct_id,a.st_auto_no,a.st_detail_id,isnull(a.arrearage,0) 
from STD03001 a  
where  a.rcv_auto_no=@rcv_auto_no  and a.com_id = @com_id
  and  a.item_id in ( select p.item_id from ctl03001 p where ltrim(rtrim(isnull(p.sales_property,'')))='实物物品' )

OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@lot_number,@rep_qty,@price,@st_sum,@store_struct_id,@st_auto_no,@st_detail_id,@arrearage
WHILE @@FETCH_STATUS=0
begin
   select @store_struct_id=ltrim(rtrim(isnull(@store_struct_id,'')))  
   if ltrim(rtrim(@comfirm_flag))='Y'
   begin
     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where c.com_id = @com_id 
--and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  
and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id 
    if @@rowcount=0
     begin
       insert into IVTd01302(com_id,finacial_y,finacial_m,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,@finacial_y,@finacial_m ,@store_struct_id,@item_id,@rep_qty,0,
       case  when @rep_qty=0 then 0 else  (@st_sum+@arrearage)/@rep_qty end ) 
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) + @rep_qty,
       i_price=(case   when (@accn_ivt+@rep_qty)=0 then @i_price  else 
       ((@i_price*@accn_ivt+@st_sum+@arrearage)/(@accn_ivt+@rep_qty))  end )
       from ivtd01302 c where c.com_id =@com_id
       --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
       and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id 
     end 
     IF @@ERROR<>0 goto tag_ERROR 
     if ltrim(rtrim(@rej_flag))='1'   /*挂帐*/
     begin
       select vendor_id from stdM0201 a where a.com_id = @com_id  and a.vendor_id=@vendor_id 
--and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
       if @@rowcount=0 
       begin
         insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,balance_sum,end_sum )
         values (@com_id,@finacial_y,@finacial_m,@vendor_id,0,@st_sum,0,0,@st_sum )
       end else begin
         update stdM0201 set increase=isnull(increase,0)+@st_sum,
         end_sum=isnull(beg_sum,0)+isnull(increase,0)+@st_sum-isnull(decrease,0)-isnull(balance_sum,0) from stdM0201 
         a where a.com_id = @com_id and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m
       end
       IF @@ERROR<>0 goto tag_ERROR
     end else if ltrim(rtrim(@rej_flag))='0' /*现款*/
     begin
       select vendor_id from stdM0201 a where a.com_id = @com_id and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
       if @@rowcount=0 
       begin
         insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,balance_sum,end_sum )
         values (@com_id,@finacial_y,@finacial_m,@vendor_id,0,@st_sum,@st_sum,0,0)
       end else begin
         update stdM0201 set increase=isnull(increase,0)+@st_sum,
         decrease=isnull(decrease,0)+@st_sum  from stdM0201 
         a where a.com_id = @com_id  and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m
       end
       IF @@ERROR<>0 goto tag_ERROR
     end   
     update STD02001 set fact_rcv=isnull(fact_rcv,0)+isnull(@rep_qty,0) ,hav_rcv=isnull(hav_rcv,0)-isnull(@rep_qty,0)    
     from  STD02001 c  where c.com_id=@com_id and c.st_auto_no=@st_auto_no  and c.item_id=@item_id  and c.seeds_id=@st_detail_id
     IF @@ERROR<>0 goto tag_ERROR

     update a set a.if_All_rcv='N'  
     --select a.com_id,a.if_All_rcv ,a.st_auto_no
     from  STDM02001 a
     where ltrim(rtrim(isnull(a.st_auto_no,''))) in
       (select  ltrim(rtrim(isnull(c.st_auto_no,''))) as st_auto_no from  VIEW_STDM02001 c
       where c.com_id=@com_id and ltrim(rtrim(isnull(c.st_auto_no,''))) =ltrim(rtrim(isnull(@st_auto_no,'')))   
       group by c.com_id,ltrim(rtrim(isnull(c.st_auto_no,''))),c.seeds_id having sum(isnull(c.hav_rcv,0))>0 )  --更改采购订单主表中的是否收完?
     IF @@ERROR<>0 goto tag_ERROR
     update a set a.if_All_rcv='Y'  
     --select a.com_id,a.if_All_rcv ,a.st_auto_no
     from  STDM02001 a
     where ltrim(rtrim(isnull(a.st_auto_no,'')))=ltrim(rtrim(isnull(@st_auto_no,''))) and ltrim(rtrim(isnull(a.st_auto_no,''))) not in
       (select DISTINCT ltrim(rtrim(isnull(c.st_auto_no,''))) as st_auto_no from  VIEW_STDM02001 c
       where c.com_id=@com_id and ltrim(rtrim(isnull(c.st_auto_no,''))) =ltrim(rtrim(isnull(@st_auto_no,''))) and (isnull(c.hav_rcv,0)>0 )  
       group by c.com_id,ltrim(rtrim(isnull(c.st_auto_no,''))) )  --更改采购订单主表中的是否收完?
     IF @@ERROR<>0 goto tag_ERROR

     update STDM02001 set alr_oq=isnull(alr_oq,0)+@rep_qty  
     from  STDM02001 c  where c.com_id=@com_id and c.st_auto_no=@st_auto_no  --更改采购订单中的收货数量和未收货数量
     IF @@ERROR<>0 goto tag_ERROR
     update Ctl03001 set bar_gb16830_1997=convert(varchar(10),@STORE_DATE,10)  from  Ctl03001 c  where c.com_id=@com_id and c.item_id=@item_id
     IF @@ERROR<>0 goto tag_ERROR
  end else begin/*弃审*/

     select @i_price=c.i_price,@accn_ivt=c.accn_ivt from ivtd01302 c where c.com_id = @com_id 
--and c.finacial_y = @finacial_y and c.finacial_m = @finacial_m  
and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id   
     if @@rowcount<>  0
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0) - @rep_qty,
          i_price=(case   when (@accn_ivt-@rep_qty)=0 then @i_price else 
          ((@i_price*@accn_ivt-@st_sum-@arrearage)/(@accn_ivt-@rep_qty))  end )
       from ivtd01302 c where c.com_id =@com_id
         --and c.finacial_y = @finacial_y and c.finacial_m  = @finacial_m
         and c.item_id = @item_id and isnull(c.store_struct_id,'')= @store_struct_id 
     end
     IF @@ERROR<>0 goto tag_ERROR
     if ltrim(rtrim(@rej_flag))='1'  /*挂帐*/
     begin     
       select vendor_id from stdM0201 a where a.com_id = @com_id  and a.vendor_id=@vendor_id  
--and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m
       if @@rowcount<>0 
       begin
         update stdM0201 set increase=isnull(increase,0)-@st_sum,
           end_sum=isnull(beg_sum,0)+isnull(increase,0)-@st_sum-isnull(decrease,0)-isnull(balance_sum,0)  from stdM0201 a 
         where a.com_id = @com_id and a.vendor_id=@vendor_id -- and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
         IF @@ERROR<>0 goto tag_ERROR
       end
     end else  if ltrim(rtrim(@rej_flag))='0'   /*现款*/
     begin
       select vendor_id from stdM0201 a where a.com_id = @com_id  and a.vendor_id=@vendor_id  --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
       if @@rowcount<>0 
       begin
         update stdM0201 set increase=isnull(increase,0)-@st_sum,
           decrease=isnull(decrease,0)-@st_sum   from stdM0201 a 
         where a.com_id = @com_id  and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
         IF @@ERROR<>0 goto tag_ERROR
       end
     end
     update STD02001 set fact_rcv=isnull(fact_rcv,0)-@rep_qty,hav_rcv=isnull(hav_rcv,0)+@rep_qty   
       from  STD02001 c  where c.com_id=@com_id and c.st_auto_no=@st_auto_no  and c.item_id=@item_id  and c.seeds_id=@st_detail_id
     IF @@ERROR<>0 goto tag_ERROR

     update a set a.if_All_rcv='N'  
     --select a.com_id,a.if_All_rcv ,a.st_auto_no
     from  STDM02001 a
     where ltrim(rtrim(isnull(a.st_auto_no,''))) in
       (select  ltrim(rtrim(isnull(c.st_auto_no,''))) as st_auto_no from  VIEW_STDM02001 c
       where c.com_id=@com_id and ltrim(rtrim(isnull(c.st_auto_no,''))) =ltrim(rtrim(isnull(@st_auto_no,'')))   
       group by c.com_id,ltrim(rtrim(isnull(c.st_auto_no,''))),c.seeds_id having sum(isnull(c.hav_rcv,0))>0 )  --更改采购订单主表中的是否收完?
     IF @@ERROR<>0 goto tag_ERROR
     update a set a.if_All_rcv='Y'  
     --select a.com_id,a.if_All_rcv ,a.st_auto_no
     from  STDM02001 a
     where ltrim(rtrim(isnull(a.st_auto_no,'')))=ltrim(rtrim(isnull(@st_auto_no,''))) and ltrim(rtrim(isnull(a.st_auto_no,''))) not in
       (select DISTINCT ltrim(rtrim(isnull(c.st_auto_no,''))) as st_auto_no from  VIEW_STDM02001 c
       where c.com_id=@com_id and ltrim(rtrim(isnull(c.st_auto_no,''))) =ltrim(rtrim(isnull(@st_auto_no,''))) and (isnull(c.hav_rcv,0)>0 )  
       group by c.com_id,ltrim(rtrim(isnull(c.st_auto_no,''))) )  --更改采购订单主表中的是否收完?
     IF @@ERROR<>0 goto tag_ERROR

     update STDM02001 set alr_oq=isnull(alr_oq,0)-@rep_qty  
       from  STDM02001 c  where c.com_id=@com_id and c.st_auto_no=@st_auto_no  
     IF @@ERROR<>0 goto tag_ERROR
  end
   FETCH NEXT FROM mycur 
      INTO @item_id,@lot_number,@rep_qty,@price,@st_sum,@store_struct_id,@st_auto_no,@st_detail_id,@arrearage
end
CLOSE mycur
DEALLOCATE mycur
   if ltrim(rtrim(@comfirm_flag))='Y'
   begin
     if (rtrim(ltrim(@rej_flag))='1') and  @pay_sum<>0  /*挂帐*/
     begin /*已经部分付款*/
       select vendor_id from stdM0201 a where a.finacial_y = @finacial_y and a.com_id = @com_id 
       and a.finacial_m = @finacial_m  and a.vendor_id=@vendor_id
       if @@rowcount<>0 
       begin
         update stdM0201 set decrease=isnull(decrease,0)+@pay_sum,
           end_sum=isnull(beg_sum,0)+isnull(increase,0)-isnull(decrease,0)-@pay_sum-isnull(balance_sum,0)  from stdM0201 a
         where a.com_id = @com_id  and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
         IF @@ERROR<>0 goto tag_ERROR
       end
     end
     if (rtrim(ltrim(@rej_flag))='0') or  @pay_sum<>0  /*现款*/
     begin
       select @i_currentValue=a.i_currentValue,@d_currentDate=a.d_currentDate from Ctl00190 a 
       where a.com_id=@com_id and a.ruleapply_occasion='采购付款'
       if @@rowcount=0 
       begin
         set @scurDate=(select  convert(varchar(10),getdate(),21))/*当前日期  */
         insert into ctl00190(com_id,ruleapply_occasion,prefix,suffix,d_currentDate,i_currentValue)
         values (@com_id,'采购付款','NO.','CGFK',@scurDate,1)
         IF @@ERROR<>0 goto tag_ERROR
       end
       select @i_currentValue=a.i_currentValue,@d_currentDate=a.d_currentDate from Ctl00190 a 
       where a.com_id=@com_id and a.ruleapply_occasion='采购付款'
       if ltrim(rtrim(@d_currentDate))=''
       begin
        update Ctl00190 set d_currentDate=(select  convert(varchar(10),getdate(),21)),i_currentValue=1 
        from Ctl00190 a where a.com_id=@com_id and a.ruleapply_occasion='采购付款'   
        IF @@ERROR<>0 goto tag_ERROR
       end else begin
         if (select  convert(varchar(10),getdate(),21))>@d_currentDate 
         update Ctl00190 set d_currentDate=(select  convert(varchar(10),getdate(),21)),i_currentValue=1 
         from Ctl00190 where com_id=@com_id and ruleapply_occasion='采购付款'   
         IF @@ERROR<>0 goto tag_ERROR
         else  update Ctl00190 set i_currentValue=i_currentValue+1 from Ctl00190 where com_id=@com_id and ruleapply_occasion='采购付款'   
         IF @@ERROR<>0 goto tag_ERROR
       end 
       select @i_currentValue=isnull(a.i_currentValue,1),@d_currentDate=a.d_currentDate,@prefix=a.prefix,@suffix=a.suffix 
       from Ctl00190 a where a.com_id=@com_id and a.ruleapply_occasion='采购付款'
       select @numb=cast(@i_currentValue as varchar(10))    
       select @recieved_auto_id=ltrim(rtrim(@prefix))+ltrim(rtrim(@d_currentDate))+ltrim(rtrim(@numb))+ltrim(rtrim(@suffix))
       if (rtrim(ltrim(@rej_flag))='1')  and (@pay_sum<>0)
       begin
         insert into ARd02051 (com_id,finacial_y,finacial_m,recieve_type,recieved_auto_id,recieved_id,finacial_d,customer_id,dept_id,
         clerk_id,recieved_direct,sum_si,comfirm_flag,ivt_oper_cfm,ivt_oper_cfm_time,mainten_clerk_id,mainten_datetime,rcv_hw_no,
         rejg_hw_no,type_sum,if_send) values 
        (@com_id,@finacial_y,@finacial_m,'应付款',@recieved_auto_id,@recieved_auto_id,@STORE_DATE,@vendor_id,@dept_id,
         @clerk_id,'付款',@pay_sum,'Y',@ivt_oper_cfm,getdate(),@ivt_oper_cfm,getdate(),@rcv_auto_no,@settlement_type_id,@pay_sum,'1')  
         IF @@ERROR<>0 goto tag_ERROR
       end
       if (rtrim(ltrim(@rej_flag))='0') 
       begin
         insert into ARd02051 (com_id,finacial_y,finacial_m,recieve_type,recieved_auto_id,recieved_id,finacial_d,customer_id,dept_id,
         clerk_id,recieved_direct,sum_si,comfirm_flag,ivt_oper_cfm,ivt_oper_cfm_time,mainten_clerk_id,mainten_datetime,rcv_hw_no,
         rejg_hw_no,type_sum,if_send) values 
        (@com_id,@finacial_y,@finacial_m,'应付款',@recieved_auto_id,@recieved_auto_id,@STORE_DATE,@vendor_id,@dept_id,
         @clerk_id,'付款',@allsum_si,'Y',@ivt_oper_cfm,getdate(),@ivt_oper_cfm,getdate(),@rcv_auto_no,@settlement_type_id,@allsum_si,'1')  
         IF @@ERROR<>0 goto tag_ERROR
       end
     end
   end else begin/*弃审*/
     delete from  ARd02051 where com_id=@com_id and rcv_hw_no=@rcv_auto_no/*弃审时删除生成的收款单*/
     IF @@ERROR<>0 goto tag_ERROR
     if (rtrim(ltrim(@rej_flag))='1') and  @pay_sum<>0  /*挂帐*/
     begin /*已经部分付款*/
       select vendor_id from stdM0201 a where a.com_id = @com_id  and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
       if @@rowcount<>0 
       begin
         update stdM0201 set decrease=isnull(decrease,0)-@pay_sum,
           end_sum=isnull(beg_sum,0)+isnull(increase,0)-isnull(decrease,0)+@pay_sum-isnull(balance_sum,0)  from stdM0201 a 
         where a.com_id = @com_id  and a.vendor_id=@vendor_id --and a.finacial_y = @finacial_y and a.finacial_m = @finacial_m 
         IF @@ERROR<>0 goto tag_ERROR
       end
     end
   end

tag_ERROR:
IF @@ERROR<>0 
begin
ROLLBACK TRANSACTION MyTranSp_stockStock
return -1
end else
begin
COMMIT TRANSACTION MyTranSp_stockStock
return 0
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

