if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pro_getNo_Ivtd01201]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pro_getNo_Ivtd01201]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--单号
CREATE  PROCEDURE pro_getNo_Ivtd01201 
	@com_ID char(10),
        @machine_mac varchar(40),/*不用但为了不改程序可以保留*/
        @rule_name varchar(20),/*规则名称*/
	@S_RKDH char(30) output
AS 
BEGIN TRANSACTION mytranpro_getNo_Ivtd01201
	declare @scurDate varchar(30),@prefix varchar(20),@suffix varchar(20),@d_currentDate varchar(30),
        @i_currentValue	int

	select  ruleapply_occasion  from ctl00190 
	where com_id = @com_id and ruleapply_occasion =@rule_name
	if @@rowcount =0 
        begin/*没有单号就增加单据号*/
            set @prefix='NO.'
          if rtrim(ltrim(@rule_name))='采购订单'
            set @suffix='CGDD'   
          if rtrim(ltrim(@rule_name))='采购进货'
            set @suffix='CGJH'    
          if rtrim(ltrim(@rule_name))='采购退货'
            set @suffix='CGTH'   
          if rtrim(ltrim(@rule_name))='采购付款'
            set @suffix='CGFK'   
          if rtrim(ltrim(@rule_name))='借货管理'
            set @suffix='JHGL'   
          if rtrim(ltrim(@rule_name))='外购入库'
            set @suffix='WGRK'   
          if rtrim(ltrim(@rule_name))='销售订单'
            set @suffix='XSDD'   
          if rtrim(ltrim(@rule_name))='销售开单'
            set @suffix='XSKD'   
          if rtrim(ltrim(@rule_name))='现款销售'
            set @suffix='XKXS'   
          if rtrim(ltrim(@rule_name))='销售退货'
            set @suffix='XSTH'   
          if rtrim(ltrim(@rule_name))='销售收款'
            set @suffix='XSSK'   
          if rtrim(ltrim(@rule_name))='入库登记'
            set @suffix='RKDJ'   
          if rtrim(ltrim(@rule_name))='出库登记'
            set @suffix='CKDJ'   
          if rtrim(ltrim(@rule_name))='库存调拨'
            set @suffix='KCDB'   
          if rtrim(ltrim(@rule_name))='库存报损'
            set @suffix='KCSY'   
          if rtrim(ltrim(@rule_name))='库存盘点'
            set @suffix='KCPD'   
          if rtrim(ltrim(@rule_name))='费用管理'
            set @suffix='FYGL'   
          if rtrim(ltrim(@rule_name))='赠送货款'
            set @suffix='ZSHK'  
          if rtrim(ltrim(@rule_name))='赠送货品'
            set @suffix='ZSHP'
          if rtrim(ltrim(@rule_name))='固定资产'
            set @suffix='GDZC'     
          if rtrim(ltrim(@rule_name))='物品组装'
            set @suffix='WPZZ'     
          if rtrim(ltrim(@rule_name))='物品拆卸'
            set @suffix='WPCX'  
          if rtrim(ltrim(@rule_name))='应收坏帐'
            set @suffix='YSHZ'     
          if rtrim(ltrim(@rule_name))='应付坏帐'
            set @suffix='YFHZ'           
          if rtrim(ltrim(@rule_name))='零售单据'
            set @suffix='LSDJ'  
          if rtrim(ltrim(@rule_name))='凭证录入'
            set @suffix='PZLY'  
          if rtrim(ltrim(@rule_name))='项目文件'
            set @suffix='XMWJ'   
          if rtrim(ltrim(@rule_name))='生产排程'
            set @suffix='SCPC'   
          if rtrim(ltrim(@rule_name))='生产领料'
            set @suffix='SCLL'
          if rtrim(ltrim(@rule_name))='生产补领'
            set @suffix='SCBL'  
          if rtrim(ltrim(@rule_name))='生产入库'
            set @suffix='SCRK'   
          if rtrim(ltrim(@rule_name))='派工单'
            set @suffix='PGD'      
          if rtrim(ltrim(@rule_name))='工票单'
            set @suffix='GPD'           
          if rtrim(ltrim(@rule_name))='生产费用'
            set @suffix='SCFY'           
          if rtrim(ltrim(@rule_name))='返工单'
            set @suffix='FGD'      
          if rtrim(ltrim(@rule_name))='委托加工'
            set @suffix='WTJG'
          if rtrim(ltrim(@rule_name))='工资维护'
            set @suffix='GZWH'
	  if rtrim(ltrim(@rule_name))='主生产计划'
            set @suffix='ZSCJH'
	  if rtrim(ltrim(@rule_name))='生产作业进度'
            set @suffix='SCJD'
	  if rtrim(ltrim(@rule_name))='生产作业单'
            set @suffix='SCZY'


          set @scurDate=(select  convert(varchar(10),getdate(),21))/*当前日期*/

          insert into ctl00190(com_id,ruleapply_occasion,prefix,suffix,d_currentDate,i_currentValue)
          values (@com_id,@rule_name,@prefix,@suffix,@scurDate,1)

          set @scurDate=substring(@scurDate,1,4)+substring(@scurDate,6,2)+substring(@scurDate,9,2)
          select @S_RKDH ='1'
          while  len(ltrim(rtrim(@S_RKDH))) <3/*长度小于3就增加*/
          begin
            select  @S_RKDH = '0'+ ltrim(rtrim(@S_RKDH))
            if len(ltrim(rtrim(@S_RKDH))) >3
	    break  /*大于三就退出循环*/
          end
          select @S_RKDH=ltrim(rtrim(@prefix))+ltrim(rtrim(@suffix))+ltrim(rtrim(@scurDate))
               +ltrim(rtrim(@S_RKDH))       
        end else begin/*有就修改相关数值*/
          set @scurDate=(select  convert(varchar(10),getdate(),21))/*当前日期*/

          select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
          @i_currentValue=a.i_currentValue  from ctl00190  a 
	  where a.com_id = @com_id and a.ruleapply_occasion =@rule_name
          if @scurDate>@d_currentDate /* 如果当前日期大于实际日期*/
          begin
            update ctl00190 set d_currentDate=@scurDate,i_currentValue=1 from ctl00190 a 
	    where a.com_id = @com_id and a.ruleapply_occasion =@rule_name
          end else begin
            update ctl00190 set i_currentValue=i_currentValue+1 from ctl00190 a 
	    where a.com_id = @com_id and a.ruleapply_occasion =@rule_name
          end

          select  @prefix=a.prefix,@suffix=a.suffix,@d_currentDate=a.d_currentDate,
          @i_currentValue=a.i_currentValue  from ctl00190  a
	  where a.com_id = @com_id and a.ruleapply_occasion =@rule_name

          set @d_currentDate=substring(@d_currentDate,1,4)+substring(@d_currentDate,6,2)
                             +substring(@d_currentDate,9,2)
          select @S_RKDH =@i_currentValue

          while  len(ltrim(rtrim(@S_RKDH))) < 3
          begin
            select  @S_RKDH = '0'+ ltrim(rtrim(@S_RKDH))
	    if len(ltrim(rtrim(@S_RKDH))) > 3
	    break
          end
          select @S_RKDH=ltrim(rtrim(@prefix))+ltrim(rtrim(@suffix))+ltrim(rtrim(@d_currentDate))
               +ltrim(rtrim(@S_RKDH))        

        end 

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranpro_getNo_Ivtd01201
end else
begin
COMMIT TRANSACTION MyTranpro_getNo_Ivtd01201
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

