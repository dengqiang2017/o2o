IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='if_Edit_sd_order_id')
  alter  table  CTLf01000 add  if_Edit_sd_order_id char(2) null
  else alter  table  CTLf01000 alter COLUMN if_Edit_sd_order_id char(2) null --是否允许改【销售开单】的单号？ 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='if_Delete_sd_order_id')
  alter  table  CTLf01000 add  if_Delete_sd_order_id char(2) null
  else alter  table  CTLf01000 alter COLUMN if_Delete_sd_order_id char(2) null --是否允许删除系统中的任何业务单据？ 
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CTLf01000' AND a.type = 'u'  and a.id=b.id  and b.name='if_BtnPreview_After_BtnAud')
  alter  table  CTLf01000 add  if_BtnPreview_After_BtnAud char(2) null
  else alter  table  CTLf01000 alter COLUMN if_BtnPreview_After_BtnAud char(2) null --【销售开单】是否审核后才允许打印？ 
go


