update Ctl09201 set object_name='��������(&B)'
from Ctl09201 where (object_name = '��������(&B)') 
go
update Ctl09201 set object_name='�������'
from Ctl09201 where (object_name = '�������') 
go
update Ctl09201 set object_name='���ϳ���'
from Ctl09201 where (object_name = '��������') 
go
update Ctl09201 set object_name='��ƿ�Ŀ'
from Ctl09201 where (object_name = '��Ŀά��') 
go
update Ctl09201 set object_name='�������'
from Ctl09201 where (object_name = '������ձ�') 
go
update Ctl09201 set object_name='���۶���'
from Ctl09201 where (object_name = '���۱��۵�') 
go
update Ctl09201 set object_name='�շ�����ܱ�'
from Ctl09201 where (object_name = '�����ܱ�') 
go
update Ctl09201 set object_name='�շ�����ˮ��'
from Ctl09201 where (object_name = '��������ˮ��') 
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10001 as [object_id],'39' as upper_object_id,'���ۻ���ͳ�Ʊ���' as [object_name],'���ۻ���ͳ�Ʊ���' as object_desc
from Ctl09201 where '���ۻ���ͳ�Ʊ���' not in ( select object_name from Ctl09201 where (object_name = '���ۻ���ͳ�Ʊ���')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10002 as [object_id],'20' as upper_object_id,'�û��鲿��Ȩ��' as [object_name],'�û��鲿��Ȩ��' as object_desc
from Ctl09201 where '�û��鲿��Ȩ��' not in ( select object_name from Ctl09201 where (object_name = '�û��鲿��Ȩ��')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10003 as [object_id],'20' as upper_object_id,'�û���λȨ��' as [object_name],'�û���λȨ��' as object_desc
from Ctl09201 where '�û���λȨ��' not in ( select object_name from Ctl09201 where (object_name = '�û���λȨ��')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10004 as [object_id],'180' as upper_object_id,'�ɹ�ͳ�Ʊ���' as [object_name],'�ɹ�ͳ�Ʊ���' as object_desc
from Ctl09201 where '�ɹ�ͳ�Ʊ���' not in ( select object_name from Ctl09201 where (object_name = '�ɹ�ͳ�Ʊ���')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10005 as [object_id],'180' as upper_object_id,'�շ���ͳ�Ʊ���' as [object_name],'�շ���ͳ�Ʊ���' as object_desc
from Ctl09201 where '�շ���ͳ�Ʊ���' not in ( select object_name from Ctl09201 where (object_name = '�շ���ͳ�Ʊ���')  )
go

--select * from Ctl09201 where (object_name like '%Ӧ��%') 
--go
