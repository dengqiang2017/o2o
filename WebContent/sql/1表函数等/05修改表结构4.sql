IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='i_Amount')
  alter  table  ivtd01302 add  i_Amount decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN i_Amount decimal(28,6) null --库存表中的金额  
go 
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='Statistic')
  alter  table  ctl03001 add  Statistic varchar(4) null
  else alter  table  ctl03001 alter COLUMN Statistic varchar(4) null --物品资料表中的统计?  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='sales_property')
  alter  table  ctl03001 add  sales_property varchar(20) null
  else alter  table  ctl03001 alter COLUMN sales_property varchar(20) null --物品资料表中的销售属性  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  ctl03001 add  item_Lenth decimal(28,6) null
  else alter  table  ctl03001 alter COLUMN item_Lenth decimal(28,6) null --物品资料表中的长  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  ctl03001 add  item_Width decimal(28,6) null
  else alter  table  ctl03001 alter COLUMN item_Width decimal(28,6) null --物品资料表中的宽  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  ctl03001 add  item_Hight decimal(28,6) null
  else alter  table  ctl03001 alter COLUMN item_Hight decimal(28,6) null --物品资料表中的高（厚）  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD02001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  STD02001 add  item_Lenth decimal(28,6) null
  else alter  table  STD02001 alter COLUMN item_Lenth decimal(28,6) null --采购订单从表中的的长  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD02001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  STD02001 add  item_Width decimal(28,6) null
  else alter  table  STD02001 alter COLUMN item_Width decimal(28,6) null --采购订单从表中的的宽  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD02001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  STD02001 add  item_Hight decimal(28,6) null
  else alter  table  STD02001 alter COLUMN item_Hight decimal(28,6) null --采购订单从表中的高（厚）  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  STD03001 add  item_Lenth decimal(28,6) null
  else alter  table  STD03001 alter COLUMN item_Lenth decimal(28,6) null --采购进货、退货从表中的的长  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  STD03001 add  item_Width decimal(28,6) null
  else alter  table  STD03001 alter COLUMN item_Width decimal(28,6) null --采购进货、退货从表中的的宽  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  STD03001 add  item_Hight decimal(28,6) null
  else alter  table  STD03001 alter COLUMN item_Hight decimal(28,6) null --采购进货、退货从表中的高（厚）  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  SDd02011 add  item_Lenth decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_Lenth decimal(28,6) null --销售订单从表中的的长  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  SDd02011 add  item_Width decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_Width decimal(28,6) null --销售订单从表中的的宽  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  SDd02011 add  item_Hight decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_Hight decimal(28,6) null --销售订单从表中的高（厚）  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  SDd02021 add  item_Lenth decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Lenth decimal(28,6) null --销售开票、退货从表中的的长  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  SDd02021 add  item_Width decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Width decimal(28,6) null --销售开票、退货从表中的的宽  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  SDd02021 add  item_Hight decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Hight decimal(28,6) null --销售开票、退货从表中的高（厚）  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02020' AND a.type = 'u'  and a.id=b.id  and b.name='HYJE')
  alter  table  SDd02020 add  HYJE decimal(17,6) null
  else alter  table  SDd02020 alter COLUMN HYJE decimal(17,6) null --销售开票、退货主表中的货运金额  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='BXQ')
  alter  table  SDd02021 add  BXQ int null
  else alter  table  SDd02021 alter COLUMN BXQ int null --销售开票、退货从表中的保修期(天) 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  SDd02021 add  item_Sellprice decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Sellprice decimal(28,6) null --销售开票、退货从表中的分仓位批发价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  SDd02021 add  item_zeroSell decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_zeroSell decimal(28,6) null --销售开票、退货从表中的分仓位零售价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  SDd02021 add  item_yardPrice decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_yardPrice decimal(28,6) null --销售开票、退货从表中的出厂价
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  SDd02021 add  item_Lenth decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Lenth decimal(28,6) null --销售开票、退货从表中的长度mm
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  SDd02021 add  item_Width decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Width decimal(28,6) null --销售开票、退货从表中的宽度mm
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  SDd02021 add  item_Hight decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Hight decimal(28,6) null --销售开票、退货从表中的高(厚)度mm
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDf00504' AND a.type = 'u'  and a.id=b.id  and b.name='HYS')
  alter  table  SDf00504 add  HYS varchar(40) null
  else alter  table  SDf00504 alter COLUMN HYS varchar(40) null --客户资料表中的货运商名称及电话 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDf00504' AND a.type = 'u'  and a.id=b.id  and b.name='FHDZ')
  alter  table  SDf00504 add  FHDZ varchar(40) null
  else alter  table  SDf00504 alter COLUMN FHDZ varchar(40) null --客户资料表中的发货地址  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='Cggoods_id')
  alter  table  ctl04100 add  Cggoods_id varchar(30) null
  else alter  table  ctl04100 alter COLUMN Cggoods_id varchar(30) null --科目表中的往来户及物品编码  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='debitandcredit_type')
  alter  table  ctl04100 add  debitandcredit_type char(1) null
  else alter  table  ctl04100 alter COLUMN debitandcredit_type char(1) null --科目表中的余额方向 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='oqAmount_flag')
  alter  table  ctl04100 add  oqAmount_flag char(1) null
  else alter  table  ctl04100 alter COLUMN oqAmount_flag char(1) null --科目表中的核算数量或金额 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='cash_subject')
  alter  table  ctl04100 add  cash_subject char(1) null
  else alter  table  ctl04100 alter COLUMN cash_subject char(1) null --科目表中的是否是初始化科目 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='square_subject')
  alter  table  ctl04100 add  square_subject char(1) null
  else alter  table  ctl04100 alter COLUMN square_subject char(1) null --科目表中的是否结算类科目 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='subject_type_id')
  alter  table  ctl04100 add  subject_type_id char(30) null
  else alter  table  ctl04100 alter COLUMN subject_type_id char(30) null --科目表中的科目类别 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='unit_id')
  alter  table  ctl04100 add  unit_id char(30) null
  else alter  table  ctl04100 alter COLUMN unit_id char(30) null --科目表中的计量单位 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='csubject_flag')
  alter  table  ctl04100 add  csubject_flag char(1) null
  else alter  table  ctl04100 alter COLUMN csubject_flag char(1) null --科目表中的分类标志 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='CheckType_id')
  alter  table  ctl04100 add  CheckType_id char(30) null
  else alter  table  ctl04100 alter COLUMN CheckType_id char(30) null --科目表中的核算项目编码 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='CheckType_name')
  alter  table  ctl04100 add  CheckType_name char(20) null
  else alter  table  ctl04100 alter COLUMN CheckType_name char(20) null --科目表中的核算项目 
go 
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='upper_expenses_id')
  alter  table  ctl04100 add  upper_expenses_id char(30) null
  else alter  table  ctl04100 alter COLUMN upper_expenses_id char(30) null --科目表中的上级科目编码 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='upper_self_id')
  alter  table  ctl04100 add  upper_self_id char(30) null
  else alter  table  ctl04100 alter COLUMN upper_self_id char(30) null --科目表中的上级科目自编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='comfirm_flag')
  alter  table  ctl04100 add  comfirm_flag char(1) null
  else alter  table  ctl04100 alter COLUMN comfirm_flag char(1) null --科目表中的是否审核
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='finacial_y')
  alter  table  ctl04100 add  finacial_y int null
  else alter  table  ctl04100 alter COLUMN finacial_y int null --科目表中的核算年 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='finacial_m')
  alter  table  ctl04100 add  finacial_m int null
  else alter  table  ctl04100 alter COLUMN finacial_m int null --科目表中的核算月
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  ctl04100 add  dept_id char(30) null
  else alter  table  ctl04100 alter COLUMN dept_id char(30) null --科目表中的部门编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='turn_check')
  alter  table  ctl04100 add  turn_check char(1) null
  else alter  table  ctl04100 alter COLUMN turn_check char(1) null --科目表中的是否结转
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='self_id')
  alter  table  ctl04100 add  self_id char(30) null
  else alter  table  ctl04100 alter COLUMN self_id char(30) null --科目表中的科目自编码
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl04100' AND a.type = 'u'  and a.id=b.id  and b.name='if_used')
  alter  table  ctl04100 add  if_used char(1) null
  else alter  table  ctl04100 alter COLUMN if_used char(1) null --科目表中的计科目是否使用发生过(凭证从表、资产负债表模板)
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='item_type')
  alter  table  ctl03001 add  item_type varchar(50) null
  else alter  table  ctl03001 alter COLUMN item_type varchar(50) null --物品资料表中的型号
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='bank_id')
  alter  table  ctl00504 add  bank_id varchar(100) null
  else alter  table  ctl00504 alter COLUMN bank_id varchar(100) null --供应商资料表中的开户银行
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='bank_accounts')
  alter  table  ctl00504 add  bank_accounts varchar(100) null
  else alter  table  ctl00504 alter COLUMN bank_accounts varchar(100) null --供应商资料表中的银行账号
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD02001' AND a.type = 'u'  and a.id=b.id  and b.name='at_term_datetime')
  alter  table  STD02001 add  at_term_datetime datetime null
  else alter  table  STD02001 alter COLUMN at_term_datetime datetime null --采购订单从表中的要求交期
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STDM02001' AND a.type = 'u'  and a.id=b.id  and b.name='expenses_id')
  alter  table  STDM02001 add  expenses_id varchar(30) null
  else alter  table  STDM02001 alter COLUMN expenses_id varchar(30) null --采购订单表中的结算方式内码 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STDM02001' AND a.type = 'u'  and a.id=b.id  and b.name='deal_flag')
  alter  table  STDM02001 add  deal_flag varchar(1) null
  else alter  table  STDM02001 alter COLUMN deal_flag varchar(1) null --采购订单表中的订单结束标记 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='sd_if_auto_ri')
  alter  table  CTLf01000 add  sd_if_auto_ri varchar(1) null
  else alter  table  CTLf01000 alter COLUMN sd_if_auto_ri varchar(1) null --管理模式驾驶舱委托加工领料处理方式标记 
go
update CTLf01000 set sd_if_auto_ri = '0' --where com_id='001'  --默认“手工输入”委托加工的领料
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD03001' AND a.type = 'u'  and a.id=b.id  and b.name='finacial_d')
  alter  table  STD03001 add  finacial_d datetime null
  else alter  table  STD03001 alter COLUMN finacial_d datetime null --采购进货、退货从表中的订货日期  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STD03001' AND a.type = 'u'  and a.id=b.id  and b.name='at_term_datetime')
  alter  table  STD03001 add  at_term_datetime datetime null
  else alter  table  STD03001 alter COLUMN at_term_datetime datetime null --采购进货、退货从表中的要求交期  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'STDM02001' AND a.type = 'u'  and a.id=b.id  and b.name='if_All_rcv')
  alter  table  STDM02001 add  if_All_rcv char(1) null
  else alter  table  STDM02001 alter COLUMN if_All_rcv char(1) null --采购订单中的是否收完?  Y=收完 N=未收完 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_Lenth')
  alter  table  IVTd01311 add  item_Lenth decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_Lenth decimal(28,6) null --库存盘点从表中的长度mm
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_Width')
  alter  table  IVTd01311 add  item_Width decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_Width decimal(28,6) null --库存盘点从表中的宽度mm
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_Hight')
  alter  table  IVTd01311 add  item_Hight decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_Hight decimal(28,6) null --库存盘点从表中的高(厚)度mm
go
update a set a.item_Lenth=b.item_Lenth,a.item_Width=b.item_Width,a.item_Hight=b.item_Hight
from IVTd01311 a,ctl03001 b
where a.com_id=b.com_id and a.item_id=b.item_id
go





