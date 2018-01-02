 

/****** Object:  View [dbo].[View_sdd02020_ctl03001]    Script Date: 10/24/2016 16:38:24 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_sdd02020_ctl03001]'))
DROP VIEW [dbo].[View_sdd02020_ctl03001]
GO 

/* V10002销售订单产品视图View_sdd02020_ctl03001*/
CREATE VIEW [dbo].[View_sdd02020_ctl03001]
AS
SELECT     dbo.View_sdd02020.com_id, dbo.View_sdd02020.customer_id, dbo.View_sdd02020.clerk_id, dbo.View_sdd02020.dept_id, dbo.View_sdd02020.comfirm_flag, 
                      dbo.View_sdd02020.finacial_y, dbo.View_sdd02020.sd_order_direct, dbo.View_sdd02020.finacial_m, dbo.View_sdd02020.lot_number, dbo.View_sdd02020.unit_id, 
                      dbo.Ctl03001.item_sim_name, dbo.Ctl03001.easy_id, dbo.Ctl03001.type_id, dbo.Ctl03001.item_type, dbo.Ctl03001.item_name, dbo.Ctl03001.item_spec, 
                      dbo.Ctl03001.item_color, dbo.Ctl03001.item_unit_weight, dbo.Ctl03001.class_card, dbo.Ctl03001.casing_unit, dbo.View_sdd02020.sd_oq, dbo.View_sdd02020.use_oq, 
                      dbo.View_sdd02020.base_oq, dbo.View_sdd02020.base_unit_id, dbo.View_sdd02020.ivt_oper_listing, dbo.View_sdd02020.sd_order_id, 
                      dbo.View_sdd02020.discount_rate, dbo.View_sdd02020.sd_unit_price, dbo.View_sdd02020.tax_rate, dbo.View_sdd02020.send_sum, 
                      dbo.View_sdd02020.so_consign_date, dbo.View_sdd02020.send_qty, dbo.View_sdd02020.seeds_id, dbo.View_sdd02020.at_term_datetime, 
                      dbo.View_sdd02020.settlement_type_id, dbo.View_sdd02020.PH, dbo.View_sdd02020.tax_type, dbo.View_sdd02020.pay_style, dbo.View_sdd02020.regionalism_id, 
                      dbo.View_sdd02020.FHDZ, dbo.View_sdd02020.HYS, dbo.View_sdd02020.BXQ, dbo.View_sdd02020.HYJE, dbo.View_sdd02020.store_struct_id, 
                      dbo.View_sdd02020.beizhu, dbo.View_sdd02020.ivt_oper_cfm_time, dbo.Ctl03001.item_pic, dbo.Ctl03001.item_status, dbo.Ctl03001.goods_origin, 
                      dbo.Ctl03001.m_flag, dbo.Ctl03001.item_cost, dbo.Ctl03001.item_unit, dbo.Ctl03001.item_zeroSell, dbo.Ctl03001.item_Sellprice, dbo.Ctl03001.item_code, 
                      dbo.Ctl03001.item_style, dbo.Ctl03001.JS, dbo.Ctl03001.if_O2O, dbo.Ctl03001.quality_class, dbo.View_sdd02020.Status_OutStore, dbo.View_sdd02020.pack_num, 
                      dbo.View_sdd02020.mainten_datetime, dbo.View_sdd02020.discount_ornot, dbo.Ctl03001.peijian_id, dbo.View_sdd02020.HYJE2, dbo.View_sdd02020.user_id, 
                      dbo.View_sdd02020.corp_sim_name, dbo.View_sdd02020.corp_name, dbo.View_sdd02020.sum_si, dbo.View_sdd02020.at_term_datetime_Act, 
                      dbo.View_sdd02020.if_sendMsg, dbo.View_sdd02020.Kar_paizhao_a, dbo.View_sdd02020.customer_id_OUT, dbo.View_sdd02020.clerk_id_OUT, 
                      dbo.View_sdd02020.dept_id_OUT, dbo.View_sdd02020.dept_id_IN, dbo.View_sdd02020.dept_name, dbo.View_sdd02020.dept_sim_name, 
                      dbo.View_sdd02020.clerk_name, dbo.Ctl03001.pack_unit, dbo.View_sdd02020.ivt_oper_listingMyPlan, dbo.View_sdd02020.item_id, 
                      dbo.View_sdd02020.price_display, dbo.View_sdd02020.price_prefer, dbo.View_sdd02020.price_otherDiscount, 
                      dbo.View_sdd02020.transport_AgentClerk_Reciever_SDd02021, dbo.View_sdd02020.HYS_SDd02021, dbo.View_sdd02020.Kar_paizhao_SDd02021, 
                      dbo.View_sdd02020.FHDZ_SDd02021, dbo.View_sdd02020.salesOrder_Process, dbo.View_sdd02020.st_hw_no, dbo.View_sdd02020.shipped, 
                      dbo.View_sdd02020.qianmingTime, dbo.View_sdd02020.qianming, dbo.View_sdd02020.c_memo, dbo.View_sdd02020.memo_color, 
                      dbo.View_sdd02020.memo_other
FROM         dbo.View_sdd02020 LEFT OUTER JOIN
                      dbo.Ctl03001 ON dbo.View_sdd02020.com_id = dbo.Ctl03001.com_id AND dbo.View_sdd02020.item_id = dbo.Ctl03001.item_id

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
         Begin Table = "Ctl03001"
            Begin Extent = 
               Top = 71
               Left = 634
               Bottom = 179
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "View_sdd02020"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 318
               Right = 325
            End
            DisplayFlags = 280
            TopColumn = 45
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020_ctl03001'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020_ctl03001'
GO


