IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='tax_sum_si')
  alter  table  IVTd01311 add  tax_sum_si decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN tax_sum_si decimal(28,6) null --盘点从表中的盘点前成本单价
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  IVTd01311 add  accn_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN accn_ivt decimal(28,6) null --盘点从表中的当前帐存数
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_ivt')
  alter  table  IVTd01311 add  counted_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_ivt decimal(28,6) null --盘点从表中的实盘数 
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_quant')
  alter  table  IVTd01311 add  differ_quant decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_quant decimal(28,6) null --盘点从表中的盈亏数
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_price')
  alter  table  IVTd01311 add  counted_price decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_price decimal(28,6) null --盘点从表中的实盘成本价
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_sum')
  alter  table  IVTd01311 add  differ_sum decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_sum decimal(28,6) null --盘点从表中的盈亏金额
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='i_price')
  alter  table  ivtd01302 add  i_price decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN i_price decimal(28,6) null --库存表中的成本单价
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  ivtd01302 add  accn_ivt decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN accn_ivt decimal(28,6) null --库存表中的库存数量
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='oh')
  alter  table  ivtd01302 add  oh decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN oh decimal(28,6) null --库存表中的可用量
