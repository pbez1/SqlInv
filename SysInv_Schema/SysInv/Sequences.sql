USE [SqlInv]
GO

USE [SqlInv]
GO

/****** Object:  Sequence [dbo].[seq_batch_number]    Script Date: 12/27/2025 6:53:25 PM ******/
CREATE SEQUENCE [dbo].[seq_batch_number] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO

ALTER AUTHORIZATION ON [dbo].[seq_batch_number] TO  SCHEMA OWNER 
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This sequence provides the batch number for the execution log (exec_log) table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'SEQUENCE',@level1name=N'seq_batch_number'
GO

