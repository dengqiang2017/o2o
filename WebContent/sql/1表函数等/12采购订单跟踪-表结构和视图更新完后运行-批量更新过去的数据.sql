--更改采购订单主表中的是否收完?
update a set a.if_All_rcv='N'  
--select a.com_id,a.if_All_rcv ,a.st_auto_no
from  STDM02001 a
where a.st_auto_no in
  (select c.st_auto_no as st_auto_no from  VIEW_STDM02001 c
  where c.com_id='001'  
  group by c.com_id,c.st_auto_no,c.seeds_id having sum(isnull(c.hav_rcv,0))>0 )
go

update a set a.if_All_rcv='Y'  
--select a.com_id,a.if_All_rcv ,a.st_auto_no
from  STDM02001 a
where a.st_auto_no not in
  (select DISTINCT c.st_auto_no as st_auto_no from  VIEW_STDM02001 c
  where c.com_id='001' and  (isnull(c.hav_rcv,0)>0 )
  group by c.com_id,c.st_auto_no )
go


