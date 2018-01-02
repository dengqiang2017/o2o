/****** Object:  View [dbo].[View_waitingPurchasing]    Script Date: 06/15/2016 14:37:48 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_waitingPurchasing]'))
DROP VIEW [dbo].[View_waitingPurchasing]
GO

/****** Object:  View [dbo].[View_waitingPurchasing]    Script Date: 06/15/2016 14:37:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_waitingPurchasing]
AS
SELECT     dbo.View_sdd02020G.item_id, dbo.View_sdd02020G.sd_oq, dbo.View_sdd02020G.com_id, dbo.IVTd01302.use_oq, dbo.Ctl03001.item_sim_name, 
                      dbo.Ctl03001.item_name, dbo.Ctl03001.item_type, dbo.Ctl03001.item_spec, dbo.Ctl03001.item_color, dbo.Ctl03001.class_card, dbo.Ctl03001.casing_unit, 
                      dbo.Ctl03001.goods_origin, dbo.Ctl03001.item_status, dbo.Ctl03001.type_id, dbo.Ctl00504.corp_sim_name, dbo.Ctl00504.corp_name, dbo.Ctl00504.weixinID, 
                      dbo.Ctl00504.movtel, dbo.Ctl03001.item_cost, dbo.Ctl03001.pack_unit, dbo.Ctl03001.vendor_id, dbo.Ctl03001.easy_id, dbo.View_sdd02020G.customer_id, 
                      dbo.View_sdd02020G.ivt_oper_listing, dbo.View_sdd02020G.corp_name AS c_corp_name, dbo.View_sdd02020G.corp_sim_name AS c_corp_sim_name
FROM         dbo.Ctl00504 RIGHT OUTER JOIN
                      dbo.Ctl03001 ON dbo.Ctl00504.com_id = dbo.Ctl03001.com_id AND dbo.Ctl00504.corp_id = dbo.Ctl03001.vendor_id RIGHT OUTER JOIN
                      dbo.View_sdd02020G ON dbo.Ctl03001.item_id = dbo.View_sdd02020G.item_id AND dbo.Ctl03001.com_id = dbo.View_sdd02020G.com_id LEFT OUTER JOIN
                      dbo.IVTd01302 ON dbo.View_sdd02020G.item_id = dbo.IVTd01302.item_id AND dbo.View_sdd02020G.com_id = dbo.IVTd01302.com_id
WHERE     (ISNULL(dbo.View_sdd02020G.sd_oq, 0) > ISNULL(dbo.IVTd01302.use_oq, 0))

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[16] 2[29] 3) )"
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
         Begin Table = "Ctl00504"
            Begin Extent = 
               Top = 69
               Left = 1006
               Bottom = 266
               Right = 1213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Ctl03001"
            Begin Extent = 
               Top = 23
               Left = 645
               Bottom = 297
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "View_sdd02020G"
            Begin Extent = 
               Top = 19
               Left = 34
               Bottom = 223
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IVTd01302"
            Begin Extent = 
               Top = 141
               Left = 366
               Bottom = 424
               Right = 555
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 27
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2040
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
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_waitingPurchasing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_waitingPurchasing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_waitingPurchasing'
GO


