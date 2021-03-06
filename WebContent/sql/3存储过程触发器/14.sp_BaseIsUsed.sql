if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_BaseIsUsed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_BaseIsUsed]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*判断货品等基础资料是否已在业务单据中使用
返回值：1=已使用，0=未使用*/
CREATE PROCEDURE sp_BaseIsUsed
 @com_id char(10),
 @Sort_Id  varchar(40),
 @i_Flag int
AS
  if  @i_Flag=0 /*物品*/
  begin
    if exists (select item_id from Ivt01010 where  item_id=@Sort_Id  and com_id=@com_id)/*库房存量*/
       return 1
    if exists (select item_id from Ivtd01300 where  item_id=@Sort_Id  and com_id=@com_id)/*库房初始化*/
       return 1
    if exists (select item_id from STD02001 where  item_id=@Sort_Id  and com_id=@com_id)/*采购定单*/
       return 1
    if exists (select item_id from STD03001 where  item_id=@Sort_Id  and com_id=@com_id)/*采购开单*/
       return 1
    if exists (select item_id from SDd02011 where  item_id=@Sort_Id  and com_id=@com_id)/*销售报价单*/
       return 1
    if exists (select item_id from SDd02021 where  item_id=@Sort_Id  and com_id=@com_id)/*销售开单*/
       return 1
    if exists (select item_id from IVTd01202 where  item_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select item_id from IVTd01311 where  item_id=@Sort_Id  and com_id=@com_id)/*库存盘点*/
       return 1 
    if exists (select self_id from STD09001 where  self_id=@Sort_Id  and com_id=@com_id  and CheckType_id='005')/*核算项目*/
       return 1  
  end else if  @i_Flag=1 /*客户*/
  begin
    if exists (select customer_id from ARf02030 where  customer_id=@Sort_Id  and com_id=@com_id)/*应收初始化*/
       return 1
    if exists (select customer_id from SDd02010 where  customer_id=@Sort_Id  and com_id=@com_id)/*销售报价单*/
       return 1
    if exists (select customer_id from SDd02020 where  customer_id=@Sort_Id  and com_id=@com_id)/*销售开单*/
       return 1
    if exists (select customer_id from ARd02051 where  customer_id=@Sort_Id and recieved_direct='收款'  and com_id=@com_id)
       return 1
    if exists (select customer_id from ARdM02011 where  customer_id=@Sort_Id  and com_id=@com_id)/*应收帐款*/
       return 1

  end else if  @i_Flag=2/*供应商*/
  begin
    if exists (select vendor_id from stfM0201 where  vendor_id=@Sort_Id  and com_id=@com_id)/*应付初始化*/
       return 1
    if exists (select vendor_id from STDM02001 where  vendor_id=@Sort_Id  and com_id=@com_id)/*采购定单*/
       return 1
    if exists (select vendor_id from STDM03001 where  vendor_id=@Sort_Id  and com_id=@com_id)/*采购开单*/
       return 1
    if exists (select customer_id from ARd02051 where  customer_id=@Sort_Id and recieved_direct='付款'  and com_id=@com_id)
       return 1
    if exists (select vendor_id from stdM0201 where  vendor_id=@Sort_Id  and com_id=@com_id)/*应付帐款*/
       return 1
  end  else if  @i_Flag=3/* 仓位*/
  begin
    if exists (select store_struct_id from ctl03001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*物品资料*/
       return 1
    if exists (select store_struct_id from Ivt01010 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*仓位存量*/
       return 1
    if exists (select store_struct_id from Ivtd01300 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库房初始化*/
       return 1
    if exists (select store_struct_id from STD02001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*采购定单*/
       return 1
    if exists (select store_struct_id from STD03001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*采购开单*/
       return 1
    if exists (select store_struct_id from SDd02011 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*销售报价单*/
       return 1
    if exists (select store_struct_id from SDd02021 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*销售开单*/
       return 1
    if exists (select store_struct_id from IVTd01202 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select corpstorestruct_id from IVTd01202 where corpstorestruct_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select store_struct_id from IVTd01310 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库存盘点*/
       return 1 
  end  else if  @i_Flag=4/* 部门*/
  begin
    if exists (select store_struct_id from Ivt01010 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*仓位存量*/
       return 1
    if exists (select store_struct_id from Ivtd01300 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库房初始化*/
       return 1
    if exists (select store_struct_id from STD02001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*采购定单*/
       return 1
    if exists (select store_struct_id from STD03001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*采购开单*/
       return 1
    if exists (select store_struct_id from SDd02011 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*销售报价单*/
       return 1
    if exists (select store_struct_id from SDd02021 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*销售开单*/
       return 1
    if exists (select store_struct_id from IVTd01202 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select corpstorestruct_id from IVTd01202 where corpstorestruct_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select store_struct_id from IVTd01310 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库存盘点*/
       return 1 
  end  else if  @i_Flag=5 /*员工*/
  begin
    if exists (select store_struct_id from Ivt01010 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*仓位存量*/
       return 1
    if exists (select store_struct_id from Ivtd01300 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库房初始化*/
       return 1
    if exists (select store_struct_id from STD02001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*采购定单*/
       return 1
    if exists (select store_struct_id from STD03001 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*采购开单*/
       return 1
    if exists (select store_struct_id from SDd02011 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*销售报价单*/
       return 1
    if exists (select store_struct_id from SDd02021 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*销售开单*/
       return 1
    if exists (select store_struct_id from IVTd01202 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select corpstorestruct_id from IVTd01202 where corpstorestruct_id=@Sort_Id  and com_id=@com_id)/*库房操作*/
       return 1
    if exists (select store_struct_id from IVTd01310 where  store_struct_id=@Sort_Id  and com_id=@com_id)/*库存盘点*/
       return 1 
  end else if  @i_Flag=6 /*判断科目的引用*/
  begin
    if exists (select Sort_Id from STD09001 where  Sort_Id=@Sort_Id  and com_id=@com_id ) /*凭证*/
       return 61  
    if exists (select com_id from ACNT_RP_Module01 where com_id=@com_id and (   (ltrim(rtrim(capital_formula_sortid ))=ltrim(rtrim(@Sort_Id))+'+' ) 
                                                                               or (ltrim(rtrim(Uncapital_formula_sortid ))=ltrim(rtrim(@Sort_Id))+'+' )
                                                                               ) 
              )  /*资产负债表模板*/
       return 62
    if exists (select com_id from ACNT_RP_Module02 where com_id=@com_id and (   (ltrim(rtrim(mainSubject_formula_sortid))=ltrim(rtrim(@Sort_Id))+'+' ) 
                                                                               or (ltrim(rtrim(assistantSubject_formula_sortid))=ltrim(rtrim(@Sort_Id))+'+' )
                                                                               ) 
              )   /*损益表模板*/
       return 63
    if exists (select com_id from ACNT_RP_Capital where com_id=@com_id and (   (ltrim(rtrim(capital_formula_sortid ))=ltrim(rtrim(@Sort_Id))+'+' ) 
                                                                               or (ltrim(rtrim(Uncapital_formula_sortid ))=ltrim(rtrim(@Sort_Id))+'+' )
                                                                               ) 
              )  /*资产负债表*/ 
       return 64
    if exists (select com_id from ACNT_RP_ProfitLoss where com_id=@com_id and (   (ltrim(rtrim(mainSubject_formula_sortid))=ltrim(rtrim(@Sort_Id))+'+' ) 
                                                                               or (ltrim(rtrim(assistantSubject_formula_sortid))=ltrim(rtrim(@Sort_Id))+'+' )
                                                                               ) 
              )  /*损益表*/
       return 65
    if (
       exists (select com_id from ctl04100 where com_id=@com_id and (   (ltrim(rtrim(Sort_Id))=ltrim(rtrim(@Sort_Id)) ) 
                                                                               and (isnull(expenses_unitprice,0.000000)<>0.000000 )
                                                                     ) 
              ) 
       and exists (select com_id from ctl02101 where com_id=@com_id and ltrim(rtrim(@Sort_Id))<>''  and ltrim(rtrim(isnull(finacial_month_status,'0')))='1'
              )  
       )  /*科目期初余额及会计核算期表的结帐状态:用于科目删除条件*/
       return 66
    if exists (select com_id from ctl02101 where com_id=@com_id and ltrim(rtrim(@Sort_Id))<>'' and ltrim(rtrim(isnull(finacial_month_status,'0')))='1'
              )  /*会计核算期表的结帐状态:用于科目修改条件*/
       return 67
    if exists (select settlement_type_id from STDM03001 where  settlement_type_id=@Sort_Id  and com_id=@com_id)/*采购进货*/
       return 1
    if exists (select rejg_hw_no from ARd02051 where  rejg_hw_no=@Sort_Id  and com_id=@com_id and recieved_direct='付款')/*采购付款*/
       return 1
    if exists (select self_id from STD09001 where  self_id=@Sort_Id  and com_id=@com_id  and CheckType_id='005')/*核算项目*/
       return 1 
  end else if  @i_Flag=7  --其它核算项目
  begin
    if exists (select self_id from Ctl03201 where  ltrim(rtrim(self_id))=ltrim(rtrim(@Sort_Id))  and com_id=@com_id)  --核算项目明细表
       return 1
    if exists (select self_id from STD09001 where  ltrim(rtrim(self_id))=ltrim(rtrim(@Sort_Id))  and com_id=@com_id )  --凭证表
       return 1
  end
 
return 0



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

