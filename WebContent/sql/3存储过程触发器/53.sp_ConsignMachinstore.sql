if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ConsignMachinstore]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ConsignMachinstore]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--委托加工
CREATE  PROCEDURE sp_ConsignMachinstore 
	@com_ID char(10),
        @ivt_oper_listing varchar(30),
        @comfirm_flag char(1)
AS
BEGIN TRANSACTION mytransp_ConsignMachinstore
declare @vendor_id varchar(30),@all_oq decimal(17,6), -- @fee_sum decimal(17,6),
                @store_struct_idYie05011 varchar(30),@item_idYie05011 char(40),@lead_oqYie05011 decimal(17,6),
                @oper_priceYie05011 decimal(17,6),@plan_priceYie05011 decimal(17,6),@snoYie05011 int,@seeds_idYie05011 int,
                @i_priceYie05011 decimal(17,6),@accn_ivtYie05011 decimal(17,6),     @st_auto_no varchar(30) , @st_detail_id int,
                @store_struct_idYie05012 varchar(30),@item_idYie05012 char(40),@lead_oqYie05012 decimal(17,6),
                @oper_priceYie05012 decimal(17,6),@plan_priceYie05012 decimal(17,6),@snoYie05012 int,@seeds_idYie05012 int,
                @i_priceYie05012 decimal(17,6),@accn_ivtYie05012 decimal(17,6)

--select @fee_sum=isnull(fee_sum,0) from Yie05010 
--where ltrim(rtrim(isnull(ivt_oper_listing,'')))=ltrim(rtrim(isnull(@ivt_oper_listing,''))) 
--  and ltrim(rtrim(isnull(com_id,'')))=ltrim(rtrim(isnull(@com_id,'')))

--先处理委托加工产品入库               
declare mycurYie05011  CURSOR FOR 
  select ltrim(rtrim(isnull(a.item_id,''))),isnull(a.lead_oq,0),isnull(a.oper_price,0),isnull(a.plan_price,0),a.sno,
    ltrim(rtrim(isnull(a.store_struct_id,''))),a.seeds_id,ltrim(rtrim(isnull(a.st_auto_no,''))),isnull(a.st_detail_id,-999) from Yie05011 a
  where  ltrim(rtrim(isnull(a.ivt_oper_listing,'')))=ltrim(rtrim(isnull(@ivt_oper_listing,'')))
     and ltrim(rtrim(isnull(a.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
OPEN mycurYie05011
FETCH NEXT FROM mycurYie05011 
INTO @item_idYie05011,@lead_oqYie05011,@oper_priceYie05011,@plan_priceYie05011,@snoYie05011,@store_struct_idYie05011,@seeds_idYie05011,@st_auto_no,@st_detail_id 
WHILE @@FETCH_STATUS = 0
begin
   select @store_struct_idYie05011=ltrim(rtrim(isnull(@store_struct_idYie05011,'')))   --委托加工产品入库
   select @item_idYie05011=ltrim(rtrim(isnull(@item_idYie05011,'')))
   if rtrim(ltrim(@comfirm_flag))<>'Y'
   begin
     select @i_priceYie05011=c.i_price,@accn_ivtYie05011=c.accn_ivt from ivtd01302 c 
     where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05011,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05011,''))) 
     if @@rowcount =  0  --增加数量
     begin
       insert into IVTd01302(com_id,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,ltrim(rtrim(isnull(@store_struct_idYie05011,''))),ltrim(rtrim(isnull(@item_idYie05011,''))),
              @lead_oqYie05011,@lead_oqYie05011,@oper_priceYie05011)
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+@lead_oqYie05011,oh=isnull(oh,0)+@lead_oqYie05011,
       i_price=(case when (@accn_ivtYie05011+@lead_oqYie05011)=0 then 0 
                else (@accn_ivtYie05011*@i_priceYie05011+@plan_priceYie05011)/(@accn_ivtYie05011+@lead_oqYie05011) end )
       from ivtd01302 c 
       where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
         and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05011,''))) 
         and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05011,''))) 
     end
     --更新采购订单从表:减少数量
     if @st_detail_id<>-999  
     update a set a.hav_rcv=a.hav_rcv-@lead_oqYie05011 from STD02001 a 
       where ltrim(rtrim(isnull(a.com_id,''))) = ltrim(rtrim(isnull(@com_id,''))) 
         and ltrim(rtrim(isnull(a.st_auto_no,''))) = ltrim(rtrim(isnull(@st_auto_no,''))) 
         and isnull(seeds_id,-999)=isnull(@st_detail_id,-999)
   end else begin  --弃审
     select @i_priceYie05011=c.i_price,@accn_ivtYie05011=c.accn_ivt from ivtd01302 c 
     where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05011,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05011,'')))
     if @@rowcount <> 0  --增加负数
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-@lead_oqYie05011,oh=isnull(oh,0)-@lead_oqYie05011,
       i_price=(case when (@accn_ivtYie05011-@lead_oqYie05011)=0 then 0 
                else (@accn_ivtYie05011*@i_priceYie05011-@plan_priceYie05011)/(@accn_ivtYie05011-@lead_oqYie05011) end )
       from ivtd01302 c 
       where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
         and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05011,''))) 
         and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05011,''))) 
     end
     --更新采购订单从表:增加数量
     if @st_detail_id<>-999  
     update a set a.hav_rcv=a.hav_rcv+@lead_oqYie05011 from STD02001 a 
       where ltrim(rtrim(isnull(a.com_id,''))) = ltrim(rtrim(isnull(@com_id,''))) 
         and ltrim(rtrim(isnull(a.st_auto_no,''))) = ltrim(rtrim(isnull(@st_auto_no,''))) 
         and isnull(seeds_id,-999)=isnull(@st_detail_id,-999)
   end
FETCH NEXT FROM mycurYie05011 
INTO @item_idYie05011,@lead_oqYie05011,@oper_priceYie05011,@plan_priceYie05011,@snoYie05011,@store_struct_idYie05011,@seeds_idYie05011,@st_auto_no,@st_detail_id 
end
CLOSE mycurYie05011
DEALLOCATE mycurYie05011


--再处理材料领用出库        
declare mycurYie05012  CURSOR FOR 
  select ltrim(rtrim(isnull(a.item_id,''))),isnull(a.lead_oq,0),isnull(a.oper_price,0),isnull(a.plan_price,0),a.sno,
    ltrim(rtrim(isnull(a.store_struct_id,''))),a.seeds_id from Yie05012 a
  where  ltrim(rtrim(isnull(a.ivt_oper_listing,'')))=ltrim(rtrim(isnull(@ivt_oper_listing,'')))
     and ltrim(rtrim(isnull(a.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
OPEN mycurYie05012
FETCH NEXT FROM mycurYie05012 
INTO @item_idYie05012,@lead_oqYie05012,@oper_priceYie05012,@plan_priceYie05012,@snoYie05012,@store_struct_idYie05012,@seeds_idYie05012
WHILE @@FETCH_STATUS = 0
begin
   select @store_struct_idYie05012=ltrim(rtrim(isnull(@store_struct_idYie05012,'')))   --委托加工材料领用出库
   select @item_idYie05012=ltrim(rtrim(isnull(@item_idYie05012,'')))
   if rtrim(ltrim(@comfirm_flag))<>'Y'
   begin
     select @i_priceYie05011=c.i_price,@accn_ivtYie05011=c.accn_ivt from ivtd01302 c 
     where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05012,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05012,''))) 
     if @@rowcount =  0  --增加负数
     begin
       insert into IVTd01302(com_id,store_struct_id,item_id,accn_ivt,oh,i_price)
       values(@com_id,ltrim(rtrim(isnull(@store_struct_idYie05012,''))),ltrim(rtrim(isnull(@item_idYie05012,''))),
              -@lead_oqYie05012,-@lead_oqYie05012,@oper_priceYie05012)
     end else begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)-@lead_oqYie05012,oh=isnull(oh,0)-@lead_oqYie05012,
       i_price=(case when (@accn_ivtYie05011-@lead_oqYie05012)=0 then 0 
                else (@accn_ivtYie05011*@i_priceYie05011-@plan_priceYie05012)/(@accn_ivtYie05011-@lead_oqYie05012) end )
       from ivtd01302 c 
       where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
         and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05012,''))) 
         and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05012,''))) 
     end
   end else begin  --弃审
     select @i_priceYie05011=c.i_price,@accn_ivtYie05011=c.accn_ivt from ivtd01302 c 
     where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
       and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05012,''))) 
       and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05012,'')))
     if @@rowcount <> 0  --增加数量
     begin
       update ivtd01302 set accn_ivt=isnull(accn_ivt,0)+@lead_oqYie05012,oh=isnull(oh,0)+@lead_oqYie05012,
       i_price=(case when (@accn_ivtYie05011+@lead_oqYie05012)=0 then 0 
                else (@accn_ivtYie05011*@i_priceYie05011+@plan_priceYie05012)/(@accn_ivtYie05011+@lead_oqYie05012) end )
       from ivtd01302 c 
       where ltrim(rtrim(isnull(c.com_id,''))) = ltrim(rtrim(isnull(@com_id,'')))
         and ltrim(rtrim(isnull(c.item_id,''))) = ltrim(rtrim(isnull(@item_idYie05012,''))) 
         and ltrim(rtrim(isnull(c.store_struct_id,''))) = ltrim(rtrim(isnull(@store_struct_idYie05012,''))) 
     end
   end
FETCH NEXT FROM mycurYie05012 
INTO @item_idYie05012,@lead_oqYie05012,@oper_priceYie05012,@plan_priceYie05012,@snoYie05012,@store_struct_idYie05012,@seeds_idYie05012
end
CLOSE mycurYie05012
DEALLOCATE mycurYie05012


   
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTransp_ConsignMachinstore
end else
begin
COMMIT TRANSACTION MyTransp_ConsignMachinstore
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

