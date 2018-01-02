IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CtL00001' AND a.type = 'u'  and a.id=b.id  and b.name='c_tablename')
  alter  table  CtL00001 add  c_tablename varchar(300) null
  else alter  table  CtL00001 alter COLUMN c_tablename varchar(300) null --����
go
IF not EXISTS (SELECT b.name FROM sysobjects a ,syscolumns b
  WHERE a.name = 'CtL00001' AND a.type = 'u'  and a.id=b.id  and b.name='c_tableTitle')
  alter  table  CtL00001 add  c_tableTitle varchar(300) null
  else alter  table  CtL00001 alter COLUMN c_tableTitle varchar(300) null --�����������
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Data_Report_Customize_Sales_ItemtypeAndRegionalism' as c_tablename,'���ܱ�-���ͺż����´��������������ܱ������ݱ�' as c_tableTitle,'C' as c_type,'0' as c_use
from CtL00001 where 'Data_Report_Customize_Sales_ItemtypeAndRegionalism' not in ( select c_tablename from CtL00001 where (c_tablename = 'Data_Report_Customize_Sales_ItemtypeAndRegionalism')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Customize_Sales_ItemtypeAndRegionalism' as c_tablename,'��������ȡ������-�ܱ�-���ͺż����´��������������ܱ��ж���' as c_tableTitle,'B' as c_type,'0' as c_use
from CtL00001 where 'Customize_Sales_ItemtypeAndRegionalism' not in ( select c_tablename from CtL00001 where (c_tablename = 'Customize_Sales_ItemtypeAndRegionalism')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Data_Report_Customize_Sales_vendorIDtypeIDAndRegionalism' as c_tablename,'���ܱ�-��Ʒ�Ʋ�Ʒ��𼰰��´������۶���ܱ������ݱ�' as c_tableTitle,'C' as c_type,'0' as c_use
from CtL00001 where 'Data_Report_Customize_Sales_vendorIDtypeIDAndRegionalism' not in ( select c_tablename from CtL00001 where (c_tablename = 'Data_Report_Customize_Sales_vendorIDtypeIDAndRegionalism')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Customize_Sales_vendorIDtypeIDAndRegionalism' as c_tablename,'��������ȡ������-�ܱ�-��Ʒ�Ʋ�Ʒ��𼰰��´������۶���ܱ��ж���' as c_tableTitle,'B' as c_type,'0' as c_use
from CtL00001 where 'Customize_Sales_vendorIDtypeIDAndRegionalism' not in ( select c_tablename from CtL00001 where (c_tablename = 'Customize_Sales_vendorIDtypeIDAndRegionalism')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Salary_Convey' as c_tablename,'�����˹��ʽ��㵥-��' as c_tableTitle,'C' as c_type,'0' as c_use
from CtL00001 where 'Salary_Convey' not in ( select c_tablename from CtL00001 where (c_tablename = 'Salary_Convey')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Yie05010' as c_tablename,'ί�мӹ���ⵥ(��Ӧ��)-����' as c_tableTitle,'C' as c_type,'0' as c_use
from CtL00001 where 'Yie05010' not in ( select c_tablename from CtL00001 where (c_tablename = 'Yie05010')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Yie05011' as c_tablename,'ί�мӹ���ⵥ(��Ӧ��)-�ӹ���Ʒ�ӱ�' as c_tableTitle,'C' as c_type,'0' as c_use
from CtL00001 where 'Yie05011' not in ( select c_tablename from CtL00001 where (c_tablename = 'Yie05011')  )
go
insert into CtL00001(c_tablename,c_tableTitle,c_type,c_use) 
select distinct 'Yie05012' as c_tablename,'ί�мӹ���ⵥ(��Ӧ��)-������ϴӱ�' as c_tableTitle,'C' as c_type,'0' as c_use
from CtL00001 where 'Yie05012' not in ( select c_tablename from CtL00001 where (c_tablename = 'Yie05012')  )
go
