 
/****** Object:  View [dbo].[VIEW_STDM02001]    Script Date: 06/15/2016 14:32:56 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_STDM02001]'))
DROP VIEW [dbo].[VIEW_STDM02001]
GO
 

/****** Object:  View [dbo].[VIEW_STDM02001]    Script Date: 06/15/2016 14:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VIEW_STDM02001]
AS
SELECT     dbo.STDM02001.st_auto_no, dbo.STDM02001.st_hw_no, dbo.STDM02001.finacial_y, dbo.STDM02001.finacial_m, dbo.STDM02001.vendor_id, 
                      dbo.STDM02001.dept_id, dbo.STDM02001.clerk_id, dbo.STDM02001.finacial_d, dbo.STDM02001.bgn_id, dbo.STDM02001.rep_reason, dbo.STDM02001.comfirm_flag, 
                      dbo.STDM02001.ivt_oper_cfm, dbo.STDM02001.ivt_oper_cfm_time, dbo.STD02001.item_id, dbo.STD02001.lot_number, dbo.STD02001.rep_qty, dbo.STD02001.unit_id, 
                      dbo.STD02001.price, dbo.STD02001.discount_rate, dbo.STD02001.tax_rate, dbo.STD02001.st_sum, dbo.STD02001.type_id, dbo.STD02001.no, 
                      dbo.STD02001.peijian_id, dbo.STD02001.fact_rcv, dbo.STD02001.seeds_id, dbo.STD02001.hav_rcv, dbo.STD02001.adress_id, dbo.STD02001.store_struct_id, 
                      dbo.STDM02001.com_id, dbo.STD02001.pack_unit, dbo.STD02001.pack_num, dbo.STD02001.oddment_num, dbo.STD02001.at_term_datetime, 
                      dbo.STD02001.item_type, dbo.STDM02001.expenses_id, dbo.STDM02001.deal_flag, dbo.STDM02001.pay_days, dbo.STDM02001.cgt_day, 
                      dbo.STDM02001.pay_style, dbo.STDM02001.bill_sum, dbo.STDM02001.coin_id, dbo.STDM02001.isbudget, dbo.STDM02001.budget_id, 
                      dbo.STDM02001.mainten_clerk_id, dbo.STDM02001.mainten_datetime, dbo.STDM02001.st_mode, dbo.STDM02001.rep_stat, dbo.STDM02001.stat_des, 
                      dbo.STD02001.item_Lenth, dbo.STD02001.item_Width, dbo.STD02001.item_Hight, dbo.STDM02001.if_All_rcv, dbo.STD02001.m_flag, dbo.STD02001.c_memo, 
                      dbo.STD02001.wuliudx, dbo.STD02001.mps_id
FROM         dbo.STDM02001 LEFT OUTER JOIN
                      dbo.STD02001 ON dbo.STDM02001.com_id = dbo.STD02001.com_id AND dbo.STDM02001.st_auto_no = dbo.STD02001.st_auto_no

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[20] 2[20] 3) )"
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
         Begin Table = "STDM02001"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 270
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "STD02001"
            Begin Extent = 
               Top = 6
               Left = 308
               Bottom = 272
               Right = 474
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
      Begin ColumnWidths = 9
         Width = 284
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_STDM02001'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_STDM02001'
GO


