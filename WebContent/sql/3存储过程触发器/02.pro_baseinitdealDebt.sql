if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pro_baseinitdealDebt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pro_baseinitdealDebt]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--应付帐款初始化
CREATE PROCEDURE pro_baseinitdealDebt 
          @com_id char(10),
          @seeds_id int ,
          @initial_flag char(1)
AS 
BEGIN TRANSACTION mytranpro_baseinitdealDebt

     declare @finacial_y int,@finacial_m tinyint,@vendor_id varchar(30),@beg_sum decimal(15,6)

    declare mycur  CURSOR FOR 
    select b.finacial_y,b.finacial_m,b.vendor_id,b.beg_sum  from stfM0201 b
    where  b.com_id = @com_id and b.seeds_id=@seeds_id
        
OPEN mycur
FETCH NEXT FROM mycur 
   INTO @finacial_y,@finacial_m,@vendor_id,@beg_sum
WHILE @@FETCH_STATUS = 0
begin
  if rtrim(ltrim(@initial_flag))='Y'
  begin    
    select  vendor_id from stdM0201 a  where a.com_id=@com_id and a.vendor_id=@vendor_id --and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m 
    if @@rowcount=0 
    begin
      insert into stdM0201(com_id,finacial_y,finacial_m,vendor_id,beg_sum,increase,decrease,end_sum) values 
      (@com_id,@finacial_y,@finacial_m,@vendor_id,@beg_sum,0,0,@beg_sum)
    end else begin
      update stdM0201 set beg_sum=isnull(beg_sum,0)+@beg_sum,end_sum=isnull(end_sum,0)+@beg_sum from stdM0201 a  
      where a.com_id=@com_id and a.vendor_id=@vendor_id -- and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m  
    end
 end else begin /*----------------------------弃审---------------------------------------*/
    select  vendor_id from stdM0201 a  where a.com_id=@com_id and a.vendor_id=@vendor_id  --and a.finacial_y=@finacial_y and  a.finacial_m=@finacial_m
    if @@rowcount<>0
    begin
      update stdM0201 set beg_sum=isnull(beg_sum,0)-@beg_sum,end_sum=isnull(end_sum,0)-@beg_sum from stdM0201 a  
      where a.com_id=@com_id and a.vendor_id=@vendor_id -- and a.finacial_y=@finacial_y and a.finacial_m=@finacial_m  
    end
 end
  FETCH NEXT FROM mycur 
      INTO @finacial_y,@finacial_m,@vendor_id,@beg_sum
end
CLOSE mycur
DEALLOCATE mycur

                            
IF @@ERROR <> 0 
begin
ROLLBACK TRANSACTION MyTranpro_baseinitdealDebt
end else
begin
COMMIT TRANSACTION MyTranpro_baseinitdealDebt
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

