 
/****** Object:  View [dbo].[View_sdd02020ctl03001]    Script Date: 10/21/2016 14:55:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_sdd02020ctl03001]'))
DROP VIEW [dbo].[View_sdd02020ctl03001]
 GO
-- 订单跟踪视图
CREATE VIEW [dbo].[View_sdd02020ctl03001]
AS
SELECT     TOP (100) PERCENT dbo.SDd02020.ivt_oper_listing, dbo.SDd02021.sd_oq, dbo.SDd02021.sd_unit_price, dbo.Ctl03001.item_sim_name, dbo.Ctl03001.item_name, 
                      dbo.Ctl03001.item_spec, dbo.Ctl03001.item_type, dbo.Ctl03001.item_status, dbo.Ctl03001.goods_origin, dbo.Ctl03001.casing_unit, dbo.Ctl03001.vendor_id, 
                      dbo.Ctl03001.m_flag, dbo.Ctl03001.f_flag, dbo.Ctl03001.item_unit, dbo.Ctl03001.peijian_id, dbo.Ctl03001.pack_unit, dbo.Ctl03001.class_card, 
                      dbo.Sdf00504.corp_sim_name, dbo.Ctl03001.type_id, dbo.SDd02021.item_id, dbo.SDd02020.so_consign_date, dbo.SDd02021.Status_OutStore, 
                      dbo.SDd02021.sum_si, dbo.SDd02021.seeds_id, dbo.Sdf00504.corp_name, dbo.Sdf00504.user_id, dbo.SDd02021.st_hw_no, dbo.Ctl03001.item_color, 
                      dbo.Ctl03001.item_code, dbo.SDd02020.com_id, dbo.SDd02020.customer_id, dbo.SDd02021.shipped, dbo.SDd02021.at_term_datetime_Act, dbo.SDd02021.qianming, 
                      dbo.SDd02021.qianmingTime, dbo.Sdf00504.pay_style, dbo.SDd02021.HYS, dbo.SDd02021.Kar_paizhao, dbo.SDd02021.transport_AgentClerk_Reciever, 
                      dbo.SDd02020.store_struct_id, dbo.SDd02021.c_memo, dbo.SDd02021.memo_color, dbo.SDd02021.memo_other, dbo.Sdf00504.clerk_id, dbo.Ctl00801.clerk_name, 
                      dbo.Ctl00801.dept_id
FROM         dbo.SDd02021 LEFT OUTER JOIN
                      dbo.Sdf00504 LEFT OUTER JOIN
                      dbo.Ctl00801 ON dbo.Sdf00504.clerk_id = dbo.Ctl00801.clerk_id AND dbo.Sdf00504.com_id = dbo.Ctl00801.com_id RIGHT OUTER JOIN
                      dbo.SDd02020 ON dbo.Sdf00504.customer_id = dbo.SDd02020.customer_id ON dbo.SDd02021.com_id = dbo.Sdf00504.com_id AND 
                      dbo.SDd02021.ivt_oper_listing = dbo.SDd02020.ivt_oper_listing AND dbo.SDd02021.com_id = dbo.SDd02020.com_id LEFT OUTER JOIN
                      dbo.Ctl03001 ON dbo.SDd02021.com_id = dbo.Ctl03001.com_id AND dbo.SDd02021.item_id = dbo.Ctl03001.item_id
ORDER BY dbo.SDd02020.com_id, dbo.SDd02020.ivt_oper_listing DESC

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[13] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Ctl03001"
            Begin Extent = 
               Top = 25
               Left = 501
               Bottom = 313
               Right = 697
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "Sdf00504"
            Begin Extent = 
               Top = 12
               Left = 726
               Bottom = 227
               Right = 958
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SDd02020"
            Begin Extent = 
               Top = 2
               Left = 5
               Bottom = 310
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "SDd02021"
            Begin Extent = 
               Top = 54
               Left = 236
               Bottom = 417
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Ctl00801"
            Begin Extent = 
               Top = 20
               Left = 1144
               Bottom = 343
               Right = 1323
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 46
         Width = 284
         Width = 1500
         Width = 2265
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020ctl03001'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2295
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020ctl03001'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020ctl03001'
GO


