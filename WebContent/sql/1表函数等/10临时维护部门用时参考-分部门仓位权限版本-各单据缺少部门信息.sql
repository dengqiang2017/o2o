update stfM0201 set dept_id='001' --where ltrim(rtrim(isnull(vendor_id,'')))='000003'  --Ӧ����ʼ��
go
update STDM02001 set dept_id='001' --where ltrim(rtrim(isnull(vendor_id,'')))='000003'  --�ɹ�����
go
update STDM03001 set dept_id='001' --where ltrim(rtrim(isnull(vendor_id,'')))='000003'  --�ɹ������˻�
go
update ARd02051 set dept_id='001' --where ltrim(rtrim(isnull(customer_id,'')))='000003' and recieved_direct='����'  --�ɹ����������տ�
go
update SDd02010 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --���۶���
go
update SDd02020 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --���۷����˻�
go
update ARd02040 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''   --���ͻ�Ʒ��Ϣά��
go
update STDM01001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --���ͻ���ά��
go
update IVTd01201 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --��������������õ���������
go
update IVTd01310 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --����̵㵥
go
update ivtd03001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --��Ʒ��װ��ж����
go
update ivtd03001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --��Ʒ��װ��ж�ӱ�
go
update SDDM03001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --���õ�
go  
update Ctl04090 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --���д�ȡ��
go 
update ARfM02010 set dept_id='001' --where ltrim(rtrim(isnull(customer_id,'')))='000003' and c_type='Ӧ��'  --Ӧ��Ӧ�������ʵ���
go




