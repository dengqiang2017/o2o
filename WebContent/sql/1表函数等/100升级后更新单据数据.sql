update ARf02030 set customer_id='C'+ltrim(rtrim(isnull(customer_id,'')))  where not customer_id like 'C%' 
go
update ARd02051 set customer_id='C'+ltrim(rtrim(isnull(customer_id,'')))  where not customer_id like 'C%' and recieved_auto_id like '%XSSK%'
go
update ARfM02010 set customer_id='C'+ltrim(rtrim(isnull(customer_id,'')))  where not customer_id like 'C%' and Debt_auto_no like '%YSHZ%'
go
update sdd02020 set customer_id='C'+ltrim(rtrim(isnull(customer_id,'')))  where not customer_id like 'C%' 
go

select * from ARf02030 where not customer_id like 'C%' 
select * from ARd02051 where not customer_id like 'C%' and recieved_auto_id like '%XSSK%'
select * from ARfM02010 where not customer_id like 'C%' and Debt_auto_no like '%YSHZ%'
select * from View_sdd02020 where not customer_id like 'C%' 


update stfM0201 set vendor_id='G'+ltrim(rtrim(isnull(vendor_id,'')))  where not vendor_id like 'G%' 
go
update ARd02051 set customer_id='G'+ltrim(rtrim(isnull(customer_id,'')))  where not customer_id like 'G%' and recieved_auto_id like '%CGFK%'
go
update ARfM02010 set customer_id='G'+ltrim(rtrim(isnull(customer_id,'')))  where not customer_id like 'G%' and Debt_auto_no like '%YFHZ%'
go
update STDM03001 set vendor_id='G'+ltrim(rtrim(isnull(vendor_id,'')))  where not vendor_id like 'C%' 
go

select * from stfM0201 where not vendor_id like 'G%' 
select * from ARd02051 where not customer_id like 'G%' and recieved_auto_id like '%CGFK%'
select * from ARfM02010 where not customer_id like 'G%' and Debt_auto_no like '%YFHZ%'
select * from View_STDM03001 where not vendor_id like 'G%' 