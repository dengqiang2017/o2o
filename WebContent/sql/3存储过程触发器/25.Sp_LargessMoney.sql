if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_LargessMoney]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_LargessMoney]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE Sp_LargessMoney 
	@com_id  char(10),
        @rep_auto_no  varchar(30),
        @comfirm_flag varchar(1)
 
AS
BEGIN TRANSACTION mytranSp_LargessMoney

        declare @finacial_d datetime,@st_hw_no varchar(30),@rep_qty decimal(17,6),@dept_id varchar(30),@clerk_id varchar(35),
        @item_id varchar(40),@vendor_id varchar(30),@pro_item varchar(30),@unit_id varchar(30),@gongyingshang_id varchar(30),
        @ivt_oper_cfm varchar(35),@mainten_clerk_id varchar(35),@purp_des varchar(60),@i_currentValue int,@d_currentDate varchar(30),
        @prefix varchar(20),@suffix varchar(20),@numb varchar(10),@finacial_y int,@finacial_m int,@scurDate varchar(30),@S_RKDH varchar(30)

	SELECT  @finacial_d=b.finacial_d,@st_hw_no=b.st_hw_no,@FINACIAL_Y= B.FINACIAL_Y,@FINACIAL_M=B.FINACIAL_M,
        @ivt_oper_cfm=b.ivt_oper_cfm,@dept_id=b.dept_id,@clerk_id=b.clerk_id,@mainten_clerk_id=b.mainten_clerk_id  FROM STDM01001 B
	WHERE  b.rep_auto_no = @rep_auto_no  AND b.com_id = @com_id

        declare mycur  CURSOR FOR 
		select a.item_id,a.rep_qty,a.vendor_id,a.pro_item,a.unit_id,a.purp_des  from STD01001 a
		where  a.rep_auto_no=@rep_auto_no and a.com_id=@com_id
OPEN mycur
FETCH NEXT FROM mycur 
INTO @item_id,@rep_qty,@vendor_id,@pro_item,@unit_id,@purp_des 
WHILE @@FETCH_STATUS = 0
begin
  select @item_id=ltrim(rtrim(@item_id))

  if ltrim(rtrim(@comfirm_flag))='Y'
  begin
    set @scurDate=(select  convert(varchar(10),getdate(),21))/*当前日期*/

    select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
    @i_currentValue=a.i_currentValue  from ctl00190  a
    where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
    if @@rowcount=0 
    begin
      insert into ctl00190(com_id,ruleapply_occasion,prefix,suffix,d_currentDate,i_currentValue)
      values (@com_id,'费用管理','NO.','FYGL',@scurDate,1)
    end
    select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
    @i_currentValue=a.i_currentValue  from ctl00190  a 
    where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
 
    if @scurDate>@d_currentDate  /*如果当前日期大于实际日期*/
    begin
      update ctl00190 set d_currentDate=@scurDate,i_currentValue=1 from ctl00190 a
      where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
    end else begin
      update ctl00190 set i_currentValue=i_currentValue+1 from ctl00190 a 
      where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'
    end

    select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
    @i_currentValue=a.i_currentValue  from ctl00190  a 
    where a.com_id = @com_id and a.ruleapply_occasion ='费用管理'

    set @d_currentDate=substring(@d_currentDate,1,4)+substring(@d_currentDate,6,2)+substring(@d_currentDate,9,2)
    select @S_RKDH =@i_currentValue

    while  len(ltrim(rtrim(@S_RKDH))) < 3
    begin
      select  @S_RKDH = '0'+ ltrim(rtrim(@S_RKDH))
      if len(ltrim(rtrim(@S_RKDH))) > 3
	    break
    end
    select @S_RKDH=ltrim(rtrim(@prefix))+ltrim(rtrim(@d_currentDate))
               +ltrim(rtrim(@S_RKDH))+ltrim(rtrim(@suffix))         

    if ltrim(rtrim(@st_hw_no))='供货' 
    begin
      set @gongyingshang_id='供应商返利-赠送货款' 
      set @rep_qty=-@rep_qty
    end else  
    if ltrim(rtrim(@st_hw_no))='客户' 
    set @gongyingshang_id='让利给客户-赠送货款'
    
    insert into SDDM03001(com_id,finacial_y,finacial_m,ivt_oper_listing,sd_order_id,finacial_d,dept_id,clerk_id,
    sum_si,bill_source,billNO,charg_no,waigou_ivt_oper,mainten_clerk_id,mainten_datetime) values (@com_id,@finacial_y,@finacial_m,
    @S_RKDH,@S_RKDH,@finacial_d,@dept_id,@clerk_id,@rep_qty,@gongyingshang_id,@unit_id,'',@rep_auto_no,@mainten_clerk_id,getdate())

    insert into SDD03001(com_id,ivt_oper_listing,expenses_id,sum_si,vendor_id,customer_id,reason,sd_order_id)
    values (@com_id,@S_RKDH,@item_id,@rep_qty,@vendor_id,@pro_item,@purp_des,@rep_auto_no) 

  end else begin/*-----------------------------------------------弃审----------------------------------------------------------*/

    delete from  SDDM03001 where com_id=@com_id and  waigou_ivt_oper=@rep_auto_no
    delete from  SDD03001  where com_id=@com_id and  sd_order_id=@rep_auto_no
  end

   FETCH NEXT FROM mycur 
	INTO @item_id,@rep_qty,@vendor_id,@pro_item,@unit_id,@purp_des 
end
CLOSE mycur
DEALLOCATE mycur

 
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranSp_LargessMoney
end else
begin
COMMIT TRANSACTION MyTranSp_LargessMoney
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

