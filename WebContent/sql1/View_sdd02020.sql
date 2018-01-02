/****** Object:  View [dbo].[View_sdd02020]    Script Date: 10/24/2016 16:38:29 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_sdd02020]'))
DROP VIEW [dbo].[View_sdd02020]
GO

/* 销售开票退货后台视图V10002销售订单视图View_sdd02020*/
CREATE VIEW [dbo].[View_sdd02020]
AS
SELECT     a.com_id, a.customer_id, a.clerk_id AS cz_clerk_id, a.dept_id, a.comfirm_flag, a.finacial_y, a.finacial_m, a.sd_order_direct, b.item_id, b.lot_number, b.unit_id, 
                      b.sd_oq, b.use_oq, b.base_oq, b.base_unit_id, a.ivt_oper_listing, a.sd_order_id, b.discount_rate, b.sd_unit_price, b.tax_rate, b.send_sum, a.so_consign_date, 
                      b.send_qty, b.seeds_id, a.at_term_datetime, b.item_code, b.PH, a.settlement_type_id, a.tax_type, a.pay_style, b.type_id, a.regionalism_id, a.mainten_clerk_id, 
                      a.mainten_datetime, a.youhui_sum, b.customer_id AS MXcustomer_id, b.store_struct_id, b.beizhu, b.peijian_id, a.ivt_oper_cfm_time, b.JS, b.BXQ, c.zip, 
                      b.memo_color, b.c_memo, b.if_anomaly, b.class_card, b.item_color, b.item_type, b.item_name, b.sid, b.ivt_oper_bill, b.xnitem_id, b.no, b.sum_si, b.JC_cost, 
                      b.tax_sum_si, b.S_N, b.vendor_id, b.rev_days, b.memo_other, b.item_struct, b.accountTurn_Flag, b.tax_sum, b.pack_unit, b.pack_num, b.charg_no, b.NoAud, 
                      a.ServerArti_id, a.ServerArti_name, a.no_acceptsum, a.send_sum_all, a.rev_days AS Expr3, a.origin_ivt_oper_listing, a.ivt_oper_cfm, a.HYS, a.FHDZ, 
                      c.HYS AS customerFile_HYS, c.FHDZ AS customerFile_FHDZ, a.HYJE, a.c_memo AS c_memoMain, a.transport_AgentClerk_Reciever, a.delivery_Add, 
                      c.clerk_idAccountApprover, c.ifUseDeposit, c.isSale_direct, c.isSale_special, c.isSale_Whole, c.Kar_Driver, c.Kar_paizhao, c.Kar_Driver_Msg_Mobile, c.HY_style, 
                      c.If_Certificate, c.movtel, c.ifUseCredit, c.accountSum, c.accountPeriod, c.creditSum, b.discount_ornot, b.sd_unit_price_UP, b.sd_unit_price_DOWN, 
                      b.discount_time_begin, b.discount_time, b.at_term_datetime_Act, b.Status_OutStore, b.clerk_id_sid, b.ivt_oper_listingMyPlan, b.price_display, b.price_prefer, 
                      b.price_otherDiscount, a.HYJE2, c.user_id, c.corp_sim_name, c.corp_name, a.if_sendMsg, a.Kar_paizhao AS Kar_paizhao_a, 
                      dbo.View_Ctl00801_Ctl00701.clerk_name, dbo.View_Ctl00801_Ctl00701.dept_sim_name, dbo.View_Ctl00801_Ctl00701.dept_name, 
                      dbo.View_Ctl00801_Ctl00701.dept_id_IN, dbo.View_Ctl00801_Ctl00701.dept_id_OUT, dbo.View_Ctl00801_Ctl00701.clerk_id_OUT, c.self_id AS customer_id_OUT, 
                      b.transport_AgentClerk_Reciever AS transport_AgentClerk_Reciever_SDd02021, b.HYS AS HYS_SDd02021, b.Kar_paizhao AS Kar_paizhao_SDd02021, 
                      b.FHDZ AS FHDZ_SDd02021, c.salesOrder_Process, b.shipped, b.elecState, b.qianmingTime, b.qianming, b.m_flag, b.st_hw_no, c.clerk_id
FROM         dbo.SDd02020 AS a LEFT OUTER JOIN
                      dbo.Sdf00504 AS c ON a.com_id = c.com_id AND LTRIM(RTRIM(ISNULL(a.customer_id, ''))) = LTRIM(RTRIM(ISNULL(c.customer_id, ''))) LEFT OUTER JOIN
                      dbo.SDd02021 AS b ON a.com_id = b.com_id AND LTRIM(RTRIM(ISNULL(a.com_id, ''))) = LTRIM(RTRIM(ISNULL(b.com_id, ''))) AND 
                      LTRIM(RTRIM(ISNULL(a.ivt_oper_listing, ''))) = LTRIM(RTRIM(ISNULL(b.ivt_oper_listing, ''))) LEFT OUTER JOIN
                      dbo.View_Ctl00801_Ctl00701 ON a.clerk_id = dbo.View_Ctl00801_Ctl00701.clerk_id AND a.com_id = dbo.View_Ctl00801_Ctl00701.com_id

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[33] 2[17] 3) )"
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
         Begin Table = "a"
            Begin Extent = 
               Top = 5
               Left = 28
               Bottom = 225
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 0
               Left = 570
               Bottom = 347
               Right = 802
            End
            DisplayFlags = 280
            TopColumn = 86
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 36
               Left = 286
               Bottom = 275
               Right = 518
            End
            DisplayFlags = 280
            TopColumn = 34
         End
         Begin Table = "View_Ctl00801_Ctl00701"
            Begin Extent = 
               Top = 66
               Left = 876
               Bottom = 174
               Right = 1075
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
      Begin ColumnWidths = 136
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
         Width = 1500
 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Width = 1500
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
         Alias = 3780
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_sdd02020'
GO


