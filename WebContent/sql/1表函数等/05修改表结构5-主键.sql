IF ( select   count(*)   from   [sysobjects]   where   xtype   =   'pk '
  and   parent_obj   in   (select   [id]   from   [sysobjects]   where   [name]   =   'Ivt01010') )=1
begin
  if ( select   name   from   sysobjects  where   name   like   '%Ivt01010%' and xtype   =   'pk ' )='PK_Ivt01010'
  alter table Ivt01010 drop constraint PK_Ivt01010
end
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'Ivt01010' AND a.type = 'u'  and a.id=b.id  and b.name='store_struct_id')
  alter  table  Ivt01010   add  store_struct_id varchar(30)  NULL
  else alter  table  Ivt01010 alter COLUMN store_struct_id varchar(30) NULL 
