if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pro_initAccept]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pro_initAccept]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE pro_initAccept
          @com_id char(10)
AS 
BEGIN TRANSACTION mytranpro_initAccept
     declare @finacial_y int,@finacial_m tinyint,@customer_id varchar(30),@oh_sum decimal(15,6)

    declare mycur  CURSOR FOR 
    select b.finacial_y,b.finacial_m,b.customer_id,b.oh_sum  from ARf02030 b
    where  b.com_id = @com_id and isnull(b.initial_flag,'')<>'Y'
        
OPEN mycur
FETCH NEXT FROM mycur 
   INTO @finacial_y,@finacial_m,@customer_id,@oh_sum
WHILE @@FETCH_STATUS = 0
begin
   
   select  customer_id  from ARdM02011 a  where a.com_id=@com_id and a.finacial_y=@finacial_y and 
   a.finacial_m=@finacial_m and a.customer_id=@customer_id 
   if @@rowcount=0 
   begin
     insert into ARdM02011(com_id,finacial_y,finacial_m,customer_id,oh_sum,addi_sum,rev_sum,acct_recieve_sum) values 
     (@com_id,@finacial_y,@finacial_m,@customer_id,@oh_sum,0,0,@oh_sum)
  end else begin
    update ARdM02011 set oh_sum=isnull(oh_sum,0)+@oh_sum,acct_recieve_sum=isnull(acct_recieve_sum,0)+@oh_sum from ARdM02011 a  
    where a.com_id=@com_id and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m and a.customer_id=@customer_id   
  end
 
  FETCH NEXT FROM mycur 
      INTO @finacial_y,@finacial_m,@customer_id,@oh_sum
end
CLOSE mycur
DEALLOCATE mycur

   update ARf02030 set initial_flag='Y' where com_id= @com_id and isnull(initial_flag,'')<>'Y'

                            
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranpro_initAccept
end else
begin
COMMIT TRANSACTION MyTranpro_initAccept
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

