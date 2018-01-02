update stfM0201 set dept_id='001' --where ltrim(rtrim(isnull(vendor_id,'')))='000003'  --应付初始化
go
update STDM02001 set dept_id='001' --where ltrim(rtrim(isnull(vendor_id,'')))='000003'  --采购订单
go
update STDM03001 set dept_id='001' --where ltrim(rtrim(isnull(vendor_id,'')))='000003'  --采购进货退货
go
update ARd02051 set dept_id='001' --where ltrim(rtrim(isnull(customer_id,'')))='000003' and recieved_direct='付款'  --采购付款销售收款
go
update SDd02010 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --销售订单
go
update SDd02020 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --销售发货退货
go
update ARd02040 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''   --赠送货品信息维护
go
update STDM01001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --赠送货款维护
go
update IVTd01201 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --生产入库物资领用调拨单报损单
go
update IVTd01310 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --库存盘点单
go
update ivtd03001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --物品组装拆卸主表
go
update ivtd03001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --物品组装拆卸从表
go
update SDDM03001 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --费用单
go  
update Ctl04090 set dept_id='001' where ltrim(rtrim(isnull(dept_id,'')))=''  --银行存取款
go 
update ARfM02010 set dept_id='001' --where ltrim(rtrim(isnull(customer_id,'')))='000003' and c_type='应付'  --应收应付呆坏帐调整
go




