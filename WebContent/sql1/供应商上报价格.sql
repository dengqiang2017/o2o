-- ��Ӧ���ϱ��۸� DROP TABLE [dbo].[stdM02010]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stdM02010]') AND type in (N'U'))
CREATE TABLE [dbo].[stdM02010](
[com_id] [char](10) NOT NULL,
[ivt_oper_listing] [varchar](30) NOT NULL,-- �ϱ���¼���
[item_id] [varchar](30) NOT NULL,--��Ʒ
[ware_num] [decimal](17, 6) NOT NULL,--���
[price] [decimal](17, 6) NOT NULL,-- �۸�
[up_datetime] [datetime] NOT NULL,--�ϱ�ʱ��
[vendor_id] [varchar](30) NOT NULL,--�ϱ���Ӧ��
[m_flag] [char](1) NOT NULL-- 0-��֤��,1-��֤ͨ��,2��֤ʧ��,
CONSTRAINT [PK_stdM02010] PRIMARY KEY CLUSTERED
(   [com_id] ASC,
	[ivt_oper_listing] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]