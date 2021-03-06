if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pro_getFK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pro_getFK]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE  pro_getFK
	@fkname varchar(120),
        @tname varchar(120) output
as
BEGIN TRANSACTION mytranpro_getFK
	declare @id int,@rkeyid int,@fkeyid int
	select @id = id from sysobjects where name = @fkname
	select @fkeyid = fkeyid,@rkeyid = rkeyid from sysforeignkeys where constid = @id
	select @tname = a.name from sysobjects a
	where a.id =@rkeyid
        select @tname = @tname + '关联'
	select @tname = @tname + a.name from sysobjects a
	where a.id =@fkeyid

IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranpro_getFK
end else
begin
COMMIT TRANSACTION MyTranpro_getFK
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

