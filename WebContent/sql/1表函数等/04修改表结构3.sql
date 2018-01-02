IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='all_sum')
  alter  table  IVTd01310 add  all_sum decimal(28,6) null
  else alter  table  IVTd01310 alter COLUMN all_sum decimal(28,6) null --盘点主表中的总金额  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='tax_sum_si')
  alter  table  IVTd01311 add  tax_sum_si decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN tax_sum_si decimal(28,6) null --盘点从表中的盘点前成本单价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  IVTd01311 add  accn_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN accn_ivt decimal(28,6) null --盘点从表中的当前帐存数 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='pack_num')
  alter  table  IVTd01311 add  pack_num decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN pack_num decimal(28,6) null --盘点从表中的实盘包装数
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='send_qty')
  alter  table  IVTd01311 add  send_qty decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN send_qty decimal(28,6) null --盘点从表中的实盘零售数
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_ivt')
  alter  table  IVTd01311 add  counted_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_ivt decimal(28,6) null --盘点从表中的总实盘数
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_quant')
  alter  table  IVTd01311 add  differ_quant decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_quant decimal(28,6) null --盘点从表中的盈亏数
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_price')
  alter  table  IVTd01311 add  counted_price decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_price decimal(28,6) null --盘点从表中的实盘成本价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  IVTd01311 add  item_yardPrice decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_yardPrice decimal(28,6) null --盘点从表中的物品出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_sum')
  alter  table  IVTd01311 add  differ_sum decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_sum decimal(28,6) null --盘点从表中的盈亏金额
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  IVTd01311 add  item_Sellprice decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_Sellprice decimal(28,6) null --盘点从表中的物品分仓位的销售批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  IVTd01311 add  item_zeroSell decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_zeroSell decimal(28,6) null --盘点从表中的物品分仓位的销售零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='i_price')
  alter  table  ivtd01302 add  i_price decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN i_price decimal(28,6) null --库存表中的成本单价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  ivtd01302 add  accn_ivt decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN accn_ivt decimal(28,6) null --库存表中的库存数量
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='oh')
  alter  table  ivtd01302 add  oh decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN oh decimal(28,6) null --库存表中的可用量
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  ivtd01302 add  item_Sellprice decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN item_Sellprice decimal(28,6) null --库存表中的物品分仓位的销售批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  ivtd01302 add  item_zeroSell decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN item_zeroSell decimal(28,6) null --库存表中的物品分仓位的销售零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  ivtd01302 add  item_yardPrice decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN item_yardPrice decimal(28,6) null --库存表中的物品出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  Ivtd01300 add  item_Sellprice decimal(28,6) null
  else alter  table  Ivtd01300 alter COLUMN item_Sellprice decimal(28,6) null --库存初始化表中的物品分仓位的销售批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  Ivtd01300 add  item_zeroSell decimal(28,6) null
  else alter  table  Ivtd01300 alter COLUMN item_zeroSell decimal(28,6) null --库存初始化表中的物品分仓位的销售零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  Ivtd01300 add  item_yardPrice decimal(28,6) null
  else alter  table  Ivtd01300 alter COLUMN item_yardPrice decimal(28,6) null --库存初始化表中的物品出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  SDd02021 add  item_Sellprice decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Sellprice decimal(28,6) null --销售发货单及销售退货单从表中物品分仓位的销售批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  SDd02021 add  item_zeroSell decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_zeroSell decimal(28,6) null --销售发货单及销售退货单从表中的物品分仓位的销售零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  SDd02021 add  item_yardPrice decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_yardPrice decimal(28,6) null --销售发货单及销售退货单从表中的物品出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  SDd02011 add  item_yardPrice decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_yardPrice decimal(28,6) null --销售订单（报价单）从表中的物品出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  SDd02011 add  item_Sellprice decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_Sellprice decimal(28,6) null --销售订单（报价单）从表中的物品分仓位的销售批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  SDd02011 add  item_zeroSell decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_zeroSell decimal(28,6) null --销售订单（报价单）从表中的的物品分仓位的销售零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  IVTd01202 add  item_yardPrice decimal(28,6) null
  else alter  table  IVTd01202 alter COLUMN item_yardPrice decimal(28,6) null --库存调拨单/生产入库/物资领用/库存报损单从表中的物品出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  IVTd01202 add  item_Sellprice decimal(28,6) null
  else alter  table  IVTd01202 alter COLUMN item_Sellprice decimal(28,6) null --库存调拨单/生产入库/物资领用/库存报损单从表中的物品分仓位的销售批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  IVTd01202 add  item_zeroSell decimal(28,6) null
  else alter  table  IVTd01202 alter COLUMN item_zeroSell decimal(28,6) null --库存调拨单/生产入库/物资领用/库存报损单从表中的的物品分仓位的销售零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01201' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01201 add  c_memo varchar(800) null
  else alter  table  IVTd01201 alter COLUMN c_memo varchar(800) null --库存调拨单/生产入库/物资领用/库存报损单主表中的的备注
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd03001' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  ivtd03001 add  c_memo varchar(800) null
  else alter  table  ivtd03001 alter COLUMN c_memo varchar(800) null --物品组装拆卸单主表中的的备注
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01310 add  c_memo varchar(800) null
  else alter  table  IVTd01310 alter COLUMN c_memo varchar(800) null --库存盘点单主表中的的备注
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  Ivtd01300 add  dept_id varchar(30) null
  else alter  table  Ivtd01300 alter COLUMN dept_id varchar(30) null --库存初始化表中的部门编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='clerk_id')
  alter  table  Ivtd01300 add  clerk_id varchar(35) null
  else alter  table  Ivtd01300 alter COLUMN clerk_id varchar(35) null --库存初始化表中的员工编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='i_weight')
  alter  table  Ctl03001 add  i_weight decimal(22,6) null
  else alter  table  Ctl03001 alter COLUMN i_weight decimal(22,6) null  --物品资料表中的重量
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='volume')
  alter  table  Ctl03001 add  volume decimal(22,6) null
  else alter  table  Ctl03001 alter COLUMN volume decimal(22,6) null  --物品资料表中的体积
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  IVTd01310 add  dept_id varchar(30) null
  else alter  table  IVTd01310 alter COLUMN dept_id varchar(30) null --盘点表中的部门编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01310 add  c_memo varchar(300) null
  else alter  table  IVTd01310 alter COLUMN c_memo varchar(300) null --盘点表中的备注
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01311 add  c_memo varchar(300) null
  else alter  table  IVTd01311 alter COLUMN c_memo varchar(300) null --盘点从表中的备注
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl04090' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  Ctl04090 add  dept_id varchar(30) null
  else alter  table  Ctl04090 alter COLUMN dept_id varchar(30) null --银行存取款表中的部门编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'stfM0201' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  stfM0201 add  dept_id varchar(30) null
  else alter  table  stfM0201 alter COLUMN dept_id varchar(30) null --应付帐款初始化表中的部门编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'stfM0201' AND a.type = 'u'  and a.id=b.id  and b.name='clerk_id')
  alter  table  stfM0201 add  clerk_id varchar(35) null
  else alter  table  stfM0201 alter COLUMN clerk_id varchar(35) null --应付帐款初始化表中的员工编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl02107' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  ctl02107 add  dept_id varchar(30) null
  else alter  table  ctl02107 alter COLUMN dept_id varchar(30) null --结算方式表中的部门编码：为了计算现金银行分部门
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  ctl00504 add  dept_id varchar(30) null
  else alter  table  ctl00504 alter COLUMN dept_id varchar(30) null --供应商表中的部门编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='clerk_id')
  alter  table  ctl00504 add  clerk_id varchar(35) null
  else alter  table  ctl00504 alter COLUMN clerk_id varchar(35) null --供应商表中的员工编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARd02041' AND a.type = 'u'  and a.id=b.id  and b.name='store_struct_id')
begin
  alter  table  ARd02041 add  store_struct_id varchar(30) null
end else alter  table  ARd02041 alter COLUMN store_struct_id varchar(30) null --更新赠送货品表中的库房编码字段
go
IF EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARd02041' AND a.type = 'u'  and a.id=b.id  and b.name='store_struct_id')
begin
  update ARd02041 set store_struct_id=sd_order_id
end                                                          --更新赠送货品表中的库房编码的数值
go

IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='YYSL')
  alter  table  CTLf01000 add  YYSL  decimal(12,4) null
  else alter  table  CTLf01000 alter COLUMN YYSL decimal(12,4) null --管理模式驾驶仓表中的营业税率(%)
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='sd_tax')
  alter  table  CTLf01000 add  sd_tax decimal(17,6) null
  else alter  table  CTLf01000 alter COLUMN sd_tax  decimal(17,6) null --管理模式驾驶仓表中的销项税率(%)
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='if_stockAlarm_recordStoreroom')
  alter  table  CTLf01000 add  if_stockAlarm_recordStoreroom varchar(1) null
  else alter  table  CTLf01000 alter COLUMN if_stockAlarm_recordStoreroom  varchar(1) null --管理模式驾驶仓表中的库存报警是否分库房
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='MoveStore_Style')
  alter  table  CTLf01000 add  MoveStore_Style varchar(1) null
  else alter  table  CTLf01000 alter COLUMN MoveStore_Style  varchar(1) null --管理模式驾驶仓表中的库存调拨方案-同价调拨=1变价调拨=0
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='beizhu')
  alter  table  SDd02021 add  beizhu varchar(800) null
  else alter  table  SDd02021 alter COLUMN beizhu varchar(800) null --销售发货单及销售退货单从表中的备注beizhu
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02020' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  SDd02020 add  c_memo varchar(800) null
  else alter  table  SDd02020 alter COLUMN c_memo varchar(800) null --销售发货单及销售退货单主表中的备注c_memo
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02010' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  SDd02010 add  c_memo varchar(800) null
  else alter  table  SDd02010 alter COLUMN c_memo varchar(800) null --销售订单主表中的备注c_memo
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='c_miaoshu')
  alter  table  SDd02011 add  c_miaoshu varchar(200) null
  else alter  table  SDd02011 alter COLUMN c_miaoshu varchar(200) null --销售订单从表中的"描述",暂时没有用
go
