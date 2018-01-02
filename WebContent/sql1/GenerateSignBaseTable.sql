IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GenerateSignBaseTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GenerateSignBaseTable];
go
CREATE PROCEDURE GenerateSignBaseTable 
@com_id char(10)
AS
BEGIN TRANSACTION generateSignBase 
	SET NOCOUNT ON; 
declare @xingqi varchar(30);
set language N'Simplified Chinese'
set @xingqi=(select datename(weekday, getdate())); 
declare @xql varchar(5),@xqt varchar(5);
if @xingqi='ÐÇÆÚÁù'
begin
set @xql=(select 
	ltrim(rtrim(isnull(param_val,''))) as param_val
	 from CTLf01001 where
	ltrim(rtrim(isnull(com_id,'')))=@com_id
	and ltrim(rtrim(isnull(param_name,'')))='isGenerateSaturday');
end;
if @xingqi='ÐÇÆÚÌì'  
begin
set @xqt=(
	select  
	ltrim(rtrim(isnull(param_val,''))) as param_val
	 from CTLf01001 where
	ltrim(rtrim(isnull(com_id,'')))=@com_id
	and ltrim(rtrim(isnull(param_name,'')))='isGenerateSaturday'); 
end;
if(@xqt='false' or @xql='false')
begin
declare clerk_id cursor local for
  	select 
  	 ltrim(rtrim(t1.clerk_id)) as clerk_id 
  	 from ctl00801 t1
  	left join ctl00801_sign t2 on t1.clerk_id=t2.clerk_id and t1.com_id=t2.com_id 
  	where ltrim(rtrim(isnull(t1.com_id,'')))=@com_id
  	and ltrim(rtrim(isnull(t1.working_status,'0')))='1';
open clerk_id;
declare @clerk_id varchar(30);
while @@FETCH_STATUS=0
begin
fetch next from clerk_id into @clerk_id; 
	set @clerk_id=(
	select top 1 ltrim(rtrim(isnull(t1.clerk_id,''))) as clerk_id from ctl00801_sign t1 where ltrim(rtrim(isnull(t1.com_id,'')))=@com_id
	and ltrim(rtrim(isnull(t1.clerk_id,'')))=@clerk_id and convert(varchar(10),t1.signDate,121)=convert(varchar(10),getdate(),120)
	);
	if @clerk_id=''
	insert into ctl00801_sign (com_id,clerk_id,signDate)values(@com_id,@clerk_id,convert(varchar(10),getdate(),120));
	select @clerk_id;
end
close clerk_id;
deallocate clerk_id;
end;	
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION GenerateSignBaseTable
end else
begin
COMMIT TRANSACTION GenerateSignBaseTable 
END