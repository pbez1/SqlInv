USE [SqlInv]
GO

/****** Object:  Synonym [dbo].[instances]    Script Date: 12/27/2025 6:51:01 PM ******/
CREATE SYNONYM [dbo].[instances] FOR [sdc-sqldbadb].[SqlInv].[dbo].[instance]
GO

ALTER AUTHORIZATION ON [dbo].[instances] TO  SCHEMA OWNER 
GO

