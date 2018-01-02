

/****** Object:  View [dbo].[View_sdd02020G]    Script Date: 06/16/2016 12:32:24 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_sdd02020G]'))
DROP VIEW [dbo].[View_sdd02020G]
GO

/****** Object:  View [dbo].[View_sdd02020G]    Script Date: 06/16/2016 12:32:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_sdd02020G]
AS
SELECT     dbo.SDd02021.item_id, SUM(dbo.SDd02021.sd_oq) AS sd_oq, dbo.SDd02020.com_id, dbo.SDd02021.ivt_oper_listing, dbo.Sdf00504.corp_name, 
                      dbo.Sdf00504.corp_sim_name, dbo.SDd02020.customer_id
FROM         dbo.SDd02020 LEFT OUTER JOIN
                      dbo.Sdf00504 ON dbo.SDd02020.customer_id = dbo.Sdf00504.customer_id FULL OUTER JOIN
                      dbo.SDd02021 ON dbo.Sdf00504.com_id = dbo.SDd02021.com_id AND dbo.SDd02020.ivt_oper_listing = dbo.SDd02021.ivt_oper_listing AND 
                      dbo.SDd02020.com_id = dbo.SDd02021.com_id
WHERE     (dbo.SDd02021.Status_OutStore LIKE '%ºË»õ%') AND (LTRIM(RTRIM(ISNULL(dbo.SDd02021.st_hw_no, ''))) = '') AND 
                      (LTRIM(RTRIM(ISNULL(dbo.SDd02021.ivt_oper_listing, ''))) NOT IN
                          (SELECT DISTINCT t4.ivt_oper_listing
                            FROM          dbo.ARd02051 AS t3 LEFT OUTER JOIN
                                                   dbo.View_sdd02020_ctl03001 AS t4 ON LTRIM(RTRIM(ISNULL(t3.com_id, ''))) = LTRIM(RTRIM(ISNULL(t4.com_id, ''))) AND 
                                                   (LTRIM(RTRIM(ISNULL(t3.rejg_hw_no, ''))) LIKE '%' + LTRIM(RTRIM(ISNULL(t4.ivt_oper_listing, ''))) + '%' OR
                                                   LTRIM(RTRIM(ISNULL(t3.c_memo, ''))) LIKE '%' + LTRIM(RTRIM(ISNULL(t4.ivt_oper_listing, ''))) + '%')
                            WHERE      (NOT (LTRIM(RTRIM(ISNULL(t4.ivt_oper_listing, ''))) = '')) AND (LTRIM(RTRIM(ISNULL(t3.comfirm_flag, 'N'))) = 'N')))
GROUP BY dbo.SDd02021.item_id, dbo.SDd02020.com_id, dbo.SDd02021.ivt_oper_listing, dbo.Sdf00504.corp_name, dbo.Sdf00504.corp_sim_name, 
                      dbo.SDd02020.customer_id

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[20] 2[32] 3) )"
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
         Begin Table = "SDd02020"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 272
               Right = 270
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sdf00504"
            Begin Extent = 
               Top = 7
               Left = 964
               Bottom = 293
               Right = 1212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SDd02021"
            Begin Extent = 
               Top = 138
               Left = 469
               Bottom = 404
               Right = 701
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 2235
         Width = 1920
         Width = 1500
         Width = 3555
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1725
         Or = 1350
         Or = 1350
         Or = 1035
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020G'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020G'
GO


