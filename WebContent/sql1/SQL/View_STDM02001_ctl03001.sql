USE [o2ohuashen]
GO

/****** Object:  View [dbo].[View_STDM02001_ctl03001]    Script Date: 06/17/2016 09:51:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_STDM02001_ctl03001]'))
DROP VIEW [dbo].[View_STDM02001_ctl03001]
GO

USE [o2ohuashen]
GO

/****** Object:  View [dbo].[View_STDM02001_ctl03001]    Script Date: 06/17/2016 09:51:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_STDM02001_ctl03001]
AS
SELECT     dbo.Ctl03001.easy_id, dbo.Ctl03001.item_name, dbo.Ctl03001.item_spec, dbo.Ctl03001.item_color, dbo.Ctl03001.item_unit_weight, dbo.Ctl03001.class_card, 
                      dbo.Ctl03001.casing_unit, dbo.Ctl03001.item_pic, dbo.Ctl03001.item_unit, dbo.VIEW_STDM02001.st_auto_no, dbo.VIEW_STDM02001.st_hw_no, 
                      dbo.Ctl03001.item_cost, dbo.VIEW_STDM02001.com_id, dbo.Ctl03001.pack_unit, dbo.Ctl03001.item_type, dbo.Ctl03001.type_id, dbo.VIEW_STDM02001.item_id, 
                      dbo.Ctl03001.item_sim_name, dbo.VIEW_STDM02001.m_flag, dbo.VIEW_STDM02001.finacial_y, dbo.VIEW_STDM02001.price, dbo.VIEW_STDM02001.hav_rcv, 
                      dbo.VIEW_STDM02001.rep_qty, dbo.Ctl00504.corp_sim_name, dbo.Ctl00504.corp_name, dbo.Ctl00504.movtel, dbo.Ctl00504.weixinID, 
                      dbo.VIEW_STDM02001.vendor_id, dbo.VIEW_STDM02001.clerk_id, dbo.VIEW_STDM02001.at_term_datetime, dbo.VIEW_STDM02001.finacial_d, 
                      dbo.VIEW_STDM02001.ivt_oper_cfm, dbo.VIEW_STDM02001.c_memo, dbo.VIEW_STDM02001.wuliudx, dbo.VIEW_STDM02001.no, dbo.VIEW_STDM02001.mps_id, 
                      dbo.VIEW_STDM02001.seeds_id, dbo.Ctl03001.store_struct_id, dbo.Ctl03001.store_struct_name, dbo.Ctl03001.discount_rate
FROM         dbo.VIEW_STDM02001 LEFT OUTER JOIN
                      dbo.Ctl00504 ON dbo.VIEW_STDM02001.vendor_id = dbo.Ctl00504.corp_id AND dbo.VIEW_STDM02001.com_id = dbo.Ctl00504.com_id LEFT OUTER JOIN
                      dbo.Ctl03001 ON dbo.VIEW_STDM02001.com_id = dbo.Ctl03001.com_id AND dbo.VIEW_STDM02001.item_id = dbo.Ctl03001.item_id

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
               Top = 6
               Left = 38
               Bottom = 344
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "Ctl00504"
            Begin Extent = 
               Top = 14
               Left = 730
               Bottom = 251
               Right = 937
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Ctl03001"
            Begin Extent = 
               Top = 21
               Left = 373
               Bottom = 272
               Right = 569
            End
            DisplayFlags = 280
            TopColumn = 24
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 67
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
         Width = 2580
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
         Width = 1500
         Width = 1500
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_STDM02001_ctl03001'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_STDM02001_ctl03001'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_STDM02001_ctl03001'
GO


