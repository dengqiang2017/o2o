 

/****** Object:  View [dbo].[ViewWaitingPurchasing]    Script Date: 06/15/2016 14:35:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewWaitingPurchasing]'))
DROP VIEW [dbo].[ViewWaitingPurchasing]
GO
 

/****** Object:  View [dbo].[ViewWaitingPurchasing]    Script Date: 06/15/2016 14:35:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewWaitingPurchasing]
AS
SELECT     dbo.View_waitingPurchasing.item_id, dbo.View_waitingPurchasing.use_oq, dbo.View_waitingPurchasing.com_id, dbo.View_waitingPurchasing.item_sim_name, 
                      dbo.View_waitingPurchasing.item_name, dbo.View_waitingPurchasing.item_type, dbo.View_waitingPurchasing.item_spec, dbo.View_waitingPurchasing.item_color, 
                      dbo.View_waitingPurchasing.class_card, dbo.View_waitingPurchasing.casing_unit, dbo.View_waitingPurchasing.goods_origin, 
                      dbo.View_waitingPurchasing.item_status, dbo.View_waitingPurchasing.type_id, dbo.View_waitingPurchasing.corp_sim_name, dbo.View_waitingPurchasing.weixinID, 
                      dbo.View_waitingPurchasing.corp_name, dbo.View_waitingPurchasing.movtel, dbo.View_waitingPurchasing.item_cost, dbo.View_waitingPurchasing.pack_unit, 
                      dbo.View_waitingPurchasing.easy_id, dbo.View_waitingPurchasing.vendor_id, 
                      dbo.View_waitingPurchasing.sd_oq - dbo.View_waitingPurchasing.use_oq - dbo.VIEW_STDM02001.hav_rcv AS caigounum, 
                      dbo.View_waitingPurchasing.sd_oq - dbo.VIEW_STDM02001.hav_rcv AS sd_oq
FROM         dbo.View_waitingPurchasing LEFT OUTER JOIN
                      dbo.VIEW_STDM02001 ON dbo.View_waitingPurchasing.com_id = dbo.VIEW_STDM02001.com_id AND 
                      dbo.View_waitingPurchasing.item_id = dbo.VIEW_STDM02001.item_id
WHERE     (dbo.VIEW_STDM02001.m_flag <> 1) AND (dbo.View_waitingPurchasing.sd_oq - dbo.View_waitingPurchasing.use_oq - dbo.VIEW_STDM02001.hav_rcv > 0)

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[22] 3) )"
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
         Begin Table = "VIEW_STDM02001"
            Begin Extent = 
               Top = 23
               Left = 442
               Bottom = 344
               Right = 611
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "View_waitingPurchasing"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 344
               Right = 192
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
      Begin ColumnWidths = 25
         Width = 284
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewWaitingPurchasing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewWaitingPurchasing'
GO


