update Ctl09201 set object_name='基础资料(&B)'
from Ctl09201 where (object_name = '基础编码(&B)') 
go
update Ctl09201 set object_name='生产入库'
from Ctl09201 where (object_name = '其他入库') 
go
update Ctl09201 set object_name='领料出库'
from Ctl09201 where (object_name = '其他出库') 
go
update Ctl09201 set object_name='会计科目'
from Ctl09201 where (object_name = '科目维护') 
go
update Ctl09201 set object_name='清空数据'
from Ctl09201 where (object_name = '数据清空表') 
go
update Ctl09201 set object_name='销售订单'
from Ctl09201 where (object_name = '销售报价单') 
go
update Ctl09201 set object_name='收发存汇总表'
from Ctl09201 where (object_name = '库存汇总表') 
go
update Ctl09201 set object_name='收发存流水帐'
from Ctl09201 where (object_name = '出入移流水账') 
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10001 as [object_id],'39' as upper_object_id,'销售汇总统计报表' as [object_name],'销售汇总统计报表' as object_desc
from Ctl09201 where '销售汇总统计报表' not in ( select object_name from Ctl09201 where (object_name = '销售汇总统计报表')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10002 as [object_id],'20' as upper_object_id,'用户组部门权限' as [object_name],'用户组部门权限' as object_desc
from Ctl09201 where '用户组部门权限' not in ( select object_name from Ctl09201 where (object_name = '用户组部门权限')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10003 as [object_id],'20' as upper_object_id,'用户仓位权限' as [object_name],'用户仓位权限' as object_desc
from Ctl09201 where '用户仓位权限' not in ( select object_name from Ctl09201 where (object_name = '用户仓位权限')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10004 as [object_id],'180' as upper_object_id,'采购统计报表' as [object_name],'采购统计报表' as object_desc
from Ctl09201 where '采购统计报表' not in ( select object_name from Ctl09201 where (object_name = '采购统计报表')  )
go
insert into Ctl09201([object_id],upper_object_id,[object_name],object_desc) 
select distinct 10005 as [object_id],'180' as upper_object_id,'收发存统计报表' as [object_name],'收发存统计报表' as object_desc
from Ctl09201 where '收发存统计报表' not in ( select object_name from Ctl09201 where (object_name = '收发存统计报表')  )
go

--select * from Ctl09201 where (object_name like '%应收%') 
--go
