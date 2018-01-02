IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='tax_sum_si')
  alter  table  IVTd01311 add  tax_sum_si decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN tax_sum_si decimal(28,6) null --�̵�ӱ��е��̵�ǰ�ɱ�����
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  IVTd01311 add  accn_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN accn_ivt decimal(28,6) null --�̵�ӱ��еĵ�ǰ�ʴ���
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_ivt')
  alter  table  IVTd01311 add  counted_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_ivt decimal(28,6) null --�̵�ӱ��е�ʵ���� 
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_quant')
  alter  table  IVTd01311 add  differ_quant decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_quant decimal(28,6) null --�̵�ӱ��е�ӯ����
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_price')
  alter  table  IVTd01311 add  counted_price decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_price decimal(28,6) null --�̵�ӱ��е�ʵ�̳ɱ���
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_sum')
  alter  table  IVTd01311 add  differ_sum decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_sum decimal(28,6) null --�̵�ӱ��е�ӯ�����
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='i_price')
  alter  table  ivtd01302 add  i_price decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN i_price decimal(28,6) null --�����еĳɱ�����
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  ivtd01302 add  accn_ivt decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN accn_ivt decimal(28,6) null --�����еĿ������
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='oh')
  alter  table  ivtd01302 add  oh decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN oh decimal(28,6) null --�����еĿ�����
