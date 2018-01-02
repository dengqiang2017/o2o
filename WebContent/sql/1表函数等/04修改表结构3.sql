IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='all_sum')
  alter  table  IVTd01310 add  all_sum decimal(28,6) null
  else alter  table  IVTd01310 alter COLUMN all_sum decimal(28,6) null --�̵������е��ܽ��  
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='tax_sum_si')
  alter  table  IVTd01311 add  tax_sum_si decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN tax_sum_si decimal(28,6) null --�̵�ӱ��е��̵�ǰ�ɱ�����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  IVTd01311 add  accn_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN accn_ivt decimal(28,6) null --�̵�ӱ��еĵ�ǰ�ʴ��� 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='pack_num')
  alter  table  IVTd01311 add  pack_num decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN pack_num decimal(28,6) null --�̵�ӱ��е�ʵ�̰�װ��
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='send_qty')
  alter  table  IVTd01311 add  send_qty decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN send_qty decimal(28,6) null --�̵�ӱ��е�ʵ��������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_ivt')
  alter  table  IVTd01311 add  counted_ivt decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_ivt decimal(28,6) null --�̵�ӱ��е���ʵ����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_quant')
  alter  table  IVTd01311 add  differ_quant decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_quant decimal(28,6) null --�̵�ӱ��е�ӯ����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='counted_price')
  alter  table  IVTd01311 add  counted_price decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN counted_price decimal(28,6) null --�̵�ӱ��е�ʵ�̳ɱ���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  IVTd01311 add  item_yardPrice decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_yardPrice decimal(28,6) null --�̵�ӱ��е���Ʒ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='differ_sum')
  alter  table  IVTd01311 add  differ_sum decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN differ_sum decimal(28,6) null --�̵�ӱ��е�ӯ�����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  IVTd01311 add  item_Sellprice decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_Sellprice decimal(28,6) null --�̵�ӱ��е���Ʒ�ֲ�λ������������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  IVTd01311 add  item_zeroSell decimal(28,6) null
  else alter  table  IVTd01311 alter COLUMN item_zeroSell decimal(28,6) null --�̵�ӱ��е���Ʒ�ֲ�λ���������ۼ�
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='i_price')
  alter  table  ivtd01302 add  i_price decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN i_price decimal(28,6) null --�����еĳɱ�����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='accn_ivt')
  alter  table  ivtd01302 add  accn_ivt decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN accn_ivt decimal(28,6) null --�����еĿ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='oh')
  alter  table  ivtd01302 add  oh decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN oh decimal(28,6) null --�����еĿ�����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  ivtd01302 add  item_Sellprice decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN item_Sellprice decimal(28,6) null --�����е���Ʒ�ֲ�λ������������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  ivtd01302 add  item_zeroSell decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN item_zeroSell decimal(28,6) null --�����е���Ʒ�ֲ�λ���������ۼ�
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd01302' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  ivtd01302 add  item_yardPrice decimal(28,6) null
  else alter  table  ivtd01302 alter COLUMN item_yardPrice decimal(28,6) null --�����е���Ʒ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  Ivtd01300 add  item_Sellprice decimal(28,6) null
  else alter  table  Ivtd01300 alter COLUMN item_Sellprice decimal(28,6) null --����ʼ�����е���Ʒ�ֲ�λ������������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  Ivtd01300 add  item_zeroSell decimal(28,6) null
  else alter  table  Ivtd01300 alter COLUMN item_zeroSell decimal(28,6) null --����ʼ�����е���Ʒ�ֲ�λ���������ۼ�
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  Ivtd01300 add  item_yardPrice decimal(28,6) null
  else alter  table  Ivtd01300 alter COLUMN item_yardPrice decimal(28,6) null --����ʼ�����е���Ʒ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  SDd02021 add  item_Sellprice decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_Sellprice decimal(28,6) null --���۷������������˻����ӱ�����Ʒ�ֲ�λ������������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  SDd02021 add  item_zeroSell decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_zeroSell decimal(28,6) null --���۷������������˻����ӱ��е���Ʒ�ֲ�λ���������ۼ�
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  SDd02021 add  item_yardPrice decimal(28,6) null
  else alter  table  SDd02021 alter COLUMN item_yardPrice decimal(28,6) null --���۷������������˻����ӱ��е���Ʒ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  SDd02011 add  item_yardPrice decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_yardPrice decimal(28,6) null --���۶��������۵����ӱ��е���Ʒ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  SDd02011 add  item_Sellprice decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_Sellprice decimal(28,6) null --���۶��������۵����ӱ��е���Ʒ�ֲ�λ������������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  SDd02011 add  item_zeroSell decimal(28,6) null
  else alter  table  SDd02011 alter COLUMN item_zeroSell decimal(28,6) null --���۶��������۵����ӱ��еĵ���Ʒ�ֲ�λ���������ۼ�
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='item_yardPrice')
  alter  table  IVTd01202 add  item_yardPrice decimal(28,6) null
  else alter  table  IVTd01202 alter COLUMN item_yardPrice decimal(28,6) null --��������/�������/��������/��汨�𵥴ӱ��е���Ʒ������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='item_Sellprice')
  alter  table  IVTd01202 add  item_Sellprice decimal(28,6) null
  else alter  table  IVTd01202 alter COLUMN item_Sellprice decimal(28,6) null --��������/�������/��������/��汨�𵥴ӱ��е���Ʒ�ֲ�λ������������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01202' AND a.type = 'u'  and a.id=b.id  and b.name='item_zeroSell')
  alter  table  IVTd01202 add  item_zeroSell decimal(28,6) null
  else alter  table  IVTd01202 alter COLUMN item_zeroSell decimal(28,6) null --��������/�������/��������/��汨�𵥴ӱ��еĵ���Ʒ�ֲ�λ���������ۼ�
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01201' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01201 add  c_memo varchar(800) null
  else alter  table  IVTd01201 alter COLUMN c_memo varchar(800) null --��������/�������/��������/��汨�������еĵı�ע
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ivtd03001' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  ivtd03001 add  c_memo varchar(800) null
  else alter  table  ivtd03001 alter COLUMN c_memo varchar(800) null --��Ʒ��װ��ж�������еĵı�ע
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01310 add  c_memo varchar(800) null
  else alter  table  IVTd01310 alter COLUMN c_memo varchar(800) null --����̵㵥�����еĵı�ע
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  Ivtd01300 add  dept_id varchar(30) null
  else alter  table  Ivtd01300 alter COLUMN dept_id varchar(30) null --����ʼ�����еĲ��ű���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivtd01300' AND a.type = 'u'  and a.id=b.id  and b.name='clerk_id')
  alter  table  Ivtd01300 add  clerk_id varchar(35) null
  else alter  table  Ivtd01300 alter COLUMN clerk_id varchar(35) null --����ʼ�����е�Ա������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='i_weight')
  alter  table  Ctl03001 add  i_weight decimal(22,6) null
  else alter  table  Ctl03001 alter COLUMN i_weight decimal(22,6) null  --��Ʒ���ϱ��е�����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl03001' AND a.type = 'u'  and a.id=b.id  and b.name='volume')
  alter  table  Ctl03001 add  volume decimal(22,6) null
  else alter  table  Ctl03001 alter COLUMN volume decimal(22,6) null  --��Ʒ���ϱ��е����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  IVTd01310 add  dept_id varchar(30) null
  else alter  table  IVTd01310 alter COLUMN dept_id varchar(30) null --�̵���еĲ��ű���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01310' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01310 add  c_memo varchar(300) null
  else alter  table  IVTd01310 alter COLUMN c_memo varchar(300) null --�̵���еı�ע
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'IVTd01311' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  IVTd01311 add  c_memo varchar(300) null
  else alter  table  IVTd01311 alter COLUMN c_memo varchar(300) null --�̵�ӱ��еı�ע
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ctl04090' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  Ctl04090 add  dept_id varchar(30) null
  else alter  table  Ctl04090 alter COLUMN dept_id varchar(30) null --���д�ȡ����еĲ��ű���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'stfM0201' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  stfM0201 add  dept_id varchar(30) null
  else alter  table  stfM0201 alter COLUMN dept_id varchar(30) null --Ӧ���ʿ��ʼ�����еĲ��ű���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'stfM0201' AND a.type = 'u'  and a.id=b.id  and b.name='clerk_id')
  alter  table  stfM0201 add  clerk_id varchar(35) null
  else alter  table  stfM0201 alter COLUMN clerk_id varchar(35) null --Ӧ���ʿ��ʼ�����е�Ա������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl02107' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  ctl02107 add  dept_id varchar(30) null
  else alter  table  ctl02107 alter COLUMN dept_id varchar(30) null --���㷽ʽ���еĲ��ű��룺Ϊ�˼����ֽ����зֲ���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='dept_id')
  alter  table  ctl00504 add  dept_id varchar(30) null
  else alter  table  ctl00504 alter COLUMN dept_id varchar(30) null --��Ӧ�̱��еĲ��ű���
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ctl00504' AND a.type = 'u'  and a.id=b.id  and b.name='clerk_id')
  alter  table  ctl00504 add  clerk_id varchar(35) null
  else alter  table  ctl00504 alter COLUMN clerk_id varchar(35) null --��Ӧ�̱��е�Ա������
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARd02041' AND a.type = 'u'  and a.id=b.id  and b.name='store_struct_id')
begin
  alter  table  ARd02041 add  store_struct_id varchar(30) null
end else alter  table  ARd02041 alter COLUMN store_struct_id varchar(30) null --�������ͻ�Ʒ���еĿⷿ�����ֶ�
go
IF EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'ARd02041' AND a.type = 'u'  and a.id=b.id  and b.name='store_struct_id')
begin
  update ARd02041 set store_struct_id=sd_order_id
end                                                          --�������ͻ�Ʒ���еĿⷿ�������ֵ
go

IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='YYSL')
  alter  table  CTLf01000 add  YYSL  decimal(12,4) null
  else alter  table  CTLf01000 alter COLUMN YYSL decimal(12,4) null --����ģʽ��ʻ�ֱ��е�Ӫҵ˰��(%)
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='sd_tax')
  alter  table  CTLf01000 add  sd_tax decimal(17,6) null
  else alter  table  CTLf01000 alter COLUMN sd_tax  decimal(17,6) null --����ģʽ��ʻ�ֱ��е�����˰��(%)
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='if_stockAlarm_recordStoreroom')
  alter  table  CTLf01000 add  if_stockAlarm_recordStoreroom varchar(1) null
  else alter  table  CTLf01000 alter COLUMN if_stockAlarm_recordStoreroom  varchar(1) null --����ģʽ��ʻ�ֱ��еĿ�汨���Ƿ�ֿⷿ
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='MoveStore_Style')
  alter  table  CTLf01000 add  MoveStore_Style varchar(1) null
  else alter  table  CTLf01000 alter COLUMN MoveStore_Style  varchar(1) null --����ģʽ��ʻ�ֱ��еĿ���������-ͬ�۵���=1��۵���=0
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02021' AND a.type = 'u'  and a.id=b.id  and b.name='beizhu')
  alter  table  SDd02021 add  beizhu varchar(800) null
  else alter  table  SDd02021 alter COLUMN beizhu varchar(800) null --���۷������������˻����ӱ��еı�עbeizhu
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02020' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  SDd02020 add  c_memo varchar(800) null
  else alter  table  SDd02020 alter COLUMN c_memo varchar(800) null --���۷������������˻��������еı�עc_memo
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02010' AND a.type = 'u'  and a.id=b.id  and b.name='c_memo')
  alter  table  SDd02010 add  c_memo varchar(800) null
  else alter  table  SDd02010 alter COLUMN c_memo varchar(800) null --���۶��������еı�עc_memo
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'SDd02011' AND a.type = 'u'  and a.id=b.id  and b.name='c_miaoshu')
  alter  table  SDd02011 add  c_miaoshu varchar(200) null
  else alter  table  SDd02011 alter COLUMN c_miaoshu varchar(200) null --���۶����ӱ��е�"����",��ʱû����
go
