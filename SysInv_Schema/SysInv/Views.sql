USE [SqlInv]
GO

/****** Object:  View [dbo].[v_instance_history]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[v_instance_history]
as
select
    i.instance_id,
    i.server_id,
    i.instance,
	ltrim((select replace((select substring((select ', ' + alias as 'data()' from inst_alias ia1 where ia1.instance_id = i.instance_id and retire_dt is null for xml path('')), 2, 9999)), ' ,', ', '))) as alias,
	ltrim((select replace((select substring((select ',' + convert(char(1), is_cname) as 'data()' from inst_alias ia1 where ia1.instance_id = i.instance_id and retire_dt is null for xml path('')), 2, 9999)), ' ,', ', '))) as is_cname,
	le.env_cd,
	dbo.uf_version_text(ih.version) version_txt,
    ih.version,
    ih.patchlvl,
	ih.edition,
    lit.instance_type,
    s.server_nm,
    s.domain_nm,
    s.fqdn,
    ll.location_cd,
    lhv.is_vm,
    i.linked_server,
    i.login_name,
    ih.service_acct,
    ih.agent_acct,
    ih.ipv4_addr,
    ih.ipv4_sql_port,
    ih.is_alias_of,
    lhv.lu_host_version_id,
    lhv.host_version,
    lhv.common_os_nm,
	ih.agent_mail_enabled,
	i.support_db,
    i.retrieve_data,
    i.retrieve_disk_space,
    i.retrieve_db_space,
    lue.enabled_cd,
    lue.enabled_desc,
    i.notes,
	is_current,
    i.mod_dt,
	i.decom_dt,
    i.create_dt,
    ih.revision
from
    dbo.instance as i
    left outer join dbo.instance_history as ih on i.instance_id = ih.instance_id
    left outer join dbo.server as s on i.server_id = s.server_id
	left outer join dbo.lu_location ll on ll.lu_location_id = s.lu_location_id
    left outer join dbo.lu_enabled as lue on i.lu_enabled_id = lue.lu_enabled_id
	left outer join dbo.lu_instance_type lit on lit.instance_type_cd = i.instance_type_cd
	left outer join dbo.lu_env le on le.env_id = i.env_id
    left outer join dbo.lu_host_version lhv on lhv.lu_host_version_id = ih.lu_host_version_id
where
    (ih.is_current = 1)
    or (ih.is_current is null)
    or (ih.server_id is null)

GO

ALTER AUTHORIZATION ON [dbo].[v_instance_history] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_instance_all]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















create view [dbo].[v_instance_all]
as
select distinct
    instance_id,
    server_id,
    instance,
	env_cd,
	version_txt,
    version,
    patchlvl,
    edition,
    instance_type,
    server_nm,
    domain_nm,
    fqdn,
    location_cd,
    is_vm,
    linked_server,
    login_name,
    service_acct,
    agent_acct,
    ipv4_addr,
    ipv4_sql_port,
 	UPPER(alias) as alias,
	vih.is_cname,
    is_alias_of,
    lu_host_version_id,
    host_version,
    common_os_nm,
	agent_mail_enabled,
	support_db,
    retrieve_data,
    retrieve_disk_space,
    retrieve_db_space,
    enabled_cd,
    enabled_desc,
    notes,
    mod_dt,
	decom_dt,
    create_dt,
    revision
from
    dbo.v_instance_history vih
where
    (is_current = 1)
    or (is_current is null)
    or (server_id is null)








GO

ALTER AUTHORIZATION ON [dbo].[v_instance_all] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_db_staging]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[v_db_staging]
as
select
    db_staging_id,
    instance_id,
    instance,
    dbname,
    dbid,
	db_create_dt,
    dbowner,
    server,
	ipv4_addr,
	ipv4_sql_port,
    version,
    patchlvl,
    service_account,
    agent_account,
    edition,
    cmplevel,
    recovery,
    online_state,
    updateability,
    host_version,
    file_path,
    file_type,
    internal_name,
	snapshot_isolation_state,
	is_read_committed_snapshot_on,
    size,
	max_size,
	growth,
	is_percent_growth,
	is_auto_create_stats_on,
	is_auto_update_stats_on,
	is_auto_update_stats_async_on,
	is_trustworthy_on,
    revision,
    db_size_kb,
    unallocated_kb,
    reserved_kb,
    data_kb,
    index_size_kb,
    unused_kb,
    searched_instance,
    is_alias_of,
    enable_processing,
	agent_mail_enabled
from
    dbo.db_staging
where
    (enable_processing = 1)





GO

ALTER AUTHORIZATION ON [dbo].[v_db_staging] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_dblist]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[v_dblist]
as
select
    dl.db_list_id,
	dl.instance_id,
    i.instance,
    dl.dbname,
    dl.env_cd,
    dl.notes as db_notes,
    dl.systems_id,
	s.[system_nm],
    dl.create_dt
from
    dbo.db_list dl
	left outer join dbo.systems s on s.systems_id = dl.systems_id
	inner join instance i on i.instance_id = dl.instance_id
where
    (is_active = 1);






GO

ALTER AUTHORIZATION ON [dbo].[v_dblist] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_dblist_all]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[v_dblist_all]
as
select
    dl.db_list_id,
	dl.instance_id,
    i.instance,
    dl.dbname,
    dl.is_active,
    dl.env_cd,
    dl.notes as db_notes,
    dl.systems_id,
    dl.create_dt
from
    dbo.db_list dl
	inner join dbo.instance i on i.instance_id = dl.instance_id

GO

ALTER AUTHORIZATION ON [dbo].[v_dblist_all] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_file_paths_all]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create   view [dbo].[v_file_paths_all]  
as  
select  
 dl.db_list_id,  
    dh.db_history_id,  
 dl.instance_id,  
    i.instance,  
    dl.dbname,  
    dh.cmplevel,  
    dh.recovery,  
    dh.online_state,  
    dh.updateability,
	dfp.mount_pt,  
    dfp.file_path,
	dfp.file_type,
    dfp.internal_name,  
    dfp.size,
    dh.revision  
from  
    dbo.db_history dh  
    inner join dbo.db_file_paths dfp on dh.db_history_id = dfp.db_history_id  
    inner join dbo.db_list dl on dh.db_list_id = dl.db_list_id
	inner join dbo.instance i on i.instance_id = dl.instance_id
  
GO

ALTER AUTHORIZATION ON [dbo].[v_file_paths_all] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_inst_alias]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[v_inst_alias]
as
	select
		i.instance,
		ia.alias,
		ia.is_cname,
		ia.cname,
		ia.retire_dt,
		ia.inst_alias_id,
		i.instance_id
	from
		inst_alias ia
		inner join dbo.instance i on i.instance_id = ia.instance_id
GO

ALTER AUTHORIZATION ON [dbo].[v_inst_alias] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_instance]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SET QUOTED_IDENTIFIER ON
--SET ANSI_NULLS ON
--GO





--/****** Object:  View [dbo].[v_instance]    Script Date: 4/23/2018 7:54:08 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE view [dbo].[v_instance]
as
    select
        i.instance_id,
        i.instance,
        le.env_cd,
        ih.version,
        dbo.uf_version_text(ih.version) version_txt,
        ih.patchlvl,
        ih.edition,
        lit.instance_type,
        s.server_nm,
        s.domain_nm,
        s.fqdn,
		lul.location_cd,
        lhv.is_vm,
        i.linked_server,
        i.login_name,
        ih.service_acct,
        ih.agent_acct,
        ih.ipv4_addr,
        ih.ipv4_sql_port,
		ltrim((select replace((select substring((select ', ' + alias as 'data()' from inst_alias ia1 where ia1.instance_id = i.instance_id and retire_dt is null for xml path('')), 2, 9999)), ' ,', ', '))) as alias,
	    ltrim((select replace((select substring((select ',' + convert(char(1), is_cname) as 'data()' from inst_alias ia1 where ia1.instance_id = i.instance_id and retire_dt is null for xml path('')), 2, 9999)), ' ,', ', '))) as is_cname,
		ih.is_alias_of,
        lhv.lu_host_version_id,
        lhv.host_version,
        lhv.common_os_nm,
		ih.agent_mail_enabled,
		i.support_db,
        i.retrieve_data,
        i.retrieve_disk_space,
        i.retrieve_db_space,
        lue.enabled_cd,
        lue.enabled_desc,
        i.notes,
        i.mod_dt,
        i.create_dt,
        ih.revision,
		i.lu_enabled_id,
        s.lu_location_id,
		s.server_id
    from
        dbo.instance i
        left outer join dbo.instance_history ih on i.instance_id = ih.instance_id
        left outer join dbo.server s on i.server_id = s.server_id
		left outer join dbo.lu_location lul on lul.lu_location_id = s.lu_location_id
        left outer join dbo.lu_instance_type lit on lit.instance_type_cd = i.instance_type_cd
        left outer join dbo.lu_env le on le.env_id = i.env_id
        left outer join dbo.lu_host_version lhv on lhv.lu_host_version_id = ih.lu_host_version_id
		left outer join dbo.lu_enabled lue on lue.lu_enabled_id = i.lu_enabled_id
    where	
        lue.enabled_cd = 'E'
        and (ih.is_current = 1)










GO

ALTER AUTHORIZATION ON [dbo].[v_instance] TO  SCHEMA OWNER 
GO

/****** Object:  View [dbo].[v_server]    Script Date: 12/27/2025 6:50:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_server] as
select
	s.server_id,
	s.server_nm,
	s.dns_alias_id,
	s.domain_nm,
	ll.location_cd,
	hv.host_version,
	s.cpu_type,
	s.cpu_cnt,
	s.cpu_core_cnt,
	s.phys_ram_gb,
	s.make,
	s.model,
	s.fqdn,
	s.lu_host_version_id,
	s.lu_location_id
from
	server s
	left outer join lu_locations ll on ll.lu_location_id = s.lu_location_id
	left outer join lu_host_version hv on hv.lu_host_version_id = s.lu_host_version_id

GO

ALTER AUTHORIZATION ON [dbo].[v_server] TO  SCHEMA OWNER 
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'db_staging_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance hosting this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the database.  Examples: master, msdb, dba_tools, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'dbname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server internal database ID number.  This number can be determined by running: SELECT DB_ID(''<database name>'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the owner of the database.  This is different from the persons responsible for the database.  This is the system login name that "owns" the database and is mapped to the "dbo" database user.  Policy dictates that this should be "sa" but not all databases currently comply with this policy.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'dbowner'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Represents the name of the SQL Server from which the data in this row is collected.  This column contains the results of the "SERVERPROPERTY(''ServerName'')" function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance version as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance patch level as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the account SQL Server is running as.  This is usually an Active Directory account but can be a local as well.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'service_account'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the current edition of the installed SQL Server.  For example: Enterprise, Developer, Standard, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'edition'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The compatibility level of the database.  Compatibility levels are: 70 (SQL Server 7); 80 (SQL Server 2000); 90 (SQL Server 2005); and 100 (SQL Server 2008)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes the recovery model used by the database.  Possible values are: "Full", "Bulk-Load", "Simple".' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes whether the database is on-line or off-line at the time this information was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server database state of updateability.  For example: READ_WRITE, READ_ONLY, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'updateability'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A windows file path which includes both the path and the file name.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'file_path'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes the type of file it is.  Possible types are "DB" and "LOG".' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'file_type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server internal name for the file.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'internal_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The size of the file in bytes at the time the information was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'size'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date this information was imported into the system inventory.  Since historical data is maintained in this table, there may be many inventory data sets collected at different dates and times.  This column differentiates the sets by tagging the individual row with the date and time it was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'db_size_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'unallocated_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'reserved_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'data_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'index_size_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'unused_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column represents the actual name of the instance searched.  This will be the same as the value in the "instance" column unless this row represents an instance alias (which can happen following a cutover to new server).  If that situation arises, the "is_alias_of" column will be populated with the name of the actual server being aliased (which will be the same as "searched_instance").' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'searched_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If this column contains data, the value will be the name of the actual SQL Server instance being aliased by the instance specified by the "instance" column.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'is_alias_of'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Occasionally, there may be rows in this table that should be exculded from processing by the "up_inventory_load_from_staging" data procedure.  If that is the case, this column will be set (numeric 1).  Otherwise it will be unset (numeric 0).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging', @level2type=N'COLUMN',@level2name=N'enable_processing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns the entire contents of the "db_staging" table except those rows that are NOT enabled for processing.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging'
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
         Configuration = "(H (1[33] 4[41] 2) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "db_staging"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 325
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1485
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_db_staging'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Uniquely identifies a given row in the "db_list" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'db_list_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance hosting this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the database.  Examples: master, msdb, dba_tools, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'dbname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A brief notation pertinent to a given database.  This column can be blank.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'db_notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Uniquely identifies a given row in the "systems" table.  Identifies which company system this database belongs to.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'systems_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column contains the date the database was entered into this system.  It does NOT indicate the date the database itself was created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns a list of active databases.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[37] 2[4] 3) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "db_list"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 341
               Right = 225
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
         Column = 2415
         Alias = 1980
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'db_list_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance hosting this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the database.  Examples: master, msdb, dba_tools, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'dbname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether the database is active or not.  A database may no longer exist on a SQL Server but we may want to retain it''s historical information.  In that case, rather than deleting the database from the system (which would remove its historicatl data) we simply mark it as inactive.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'is_active'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A brief notation pertinent to a given database.  This column can be blank.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'db_notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a link to the particular system this database belongs to (as defined in the xxx table).  The system might be ECC, Readsoft, NPD, for example.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'systems_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column contains the date the database was entered into this system.  It does NOT indicate the date the database itself was created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns a list of all databases that have ever been entered into the dblist table whether they''re active or not.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all'
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
         Configuration = "(H (1[51] 4[38] 3) )"
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
         Configuration = "(H (1[36] 4) )"
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "db_list"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 252
               Right = 225
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_dblist_all'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2130 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2295 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance this data will reflect.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance version as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Represents the current level of patching as returned by the "serverproperty(''productlevel'')" function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the current edition of the installed SQL Server.  For example: Enterprise, Developer, Standard, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'edition'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active Directory Domain Name.  This differentiates similar server names that exist in different Active Directory domains.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'domain_nm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'"Fully Quailified Domain Name".  This fully qualifies the server name by appending the domain name (the value in the "domain_nm" column above).  For example: svr1.yahoo.com, svr2.google.com.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'fqdn'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A three letter code representing the physical location of the server.  Note: Given that most servers are virtual, this could conceivably change if the server is VMotioned to another site.  If the three letter code does not exist in the "lu_location" table, it is not considered valid by this system.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'location_cd'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Specifies whether the underlying host is a physical server or a virtual machine.  0 = physical server; 1 = virtual machine.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'is_vm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the linked server to build.  The system will use this linked server to access the remote SQL Server instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the account SQL Server is running as.  This is usually an Active Directory account but can be a local as well.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'service_acct'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the "virtual" instance name that aliases the "instance" value above (implemented as a DNS CName) if one exists.  If no alias exists, the value is null.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'alias'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When this column has a value, it indicates that the SQL Server instance hosting this database is really an alias of another system.  Therefore, the database really resides on the system listed in this collumn.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'is_alias_of'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether to attempt to retrieve data from the remote instance.  Usually, it is set to retrieve data but may be turned off for troubleshooting purposes or if data is no longer needed.  1 = Retrieve data; 0 = Don''t retrieve data.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether disk usage information for this instance is retrieved or not.  1 = Retrieved; 0 = Not retrieved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_disk_space'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether database usage information (file size, internal free space) for this instance is retrieved or not.  1 = Retrieved; 0 = Not retrieved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'retrieve_db_space'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=4560 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column will accomodate any notes the user wishes to associate with this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time data in the "instance" table was last modified.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'mod_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this row was created in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this instance information was collected.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the ID representing the server that this instance resides on.  The ID is the primary key in the "servers" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance', @level2type=N'COLUMN',@level2name=N'server_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns a list of all SQL Server instances in the "instances" table that are flagged as ENABLED.  Also includes the most recent "instance_history" information associated with the instance.  Instances not flagged as enabled will not be returned.  (It''s not clear what condition the "ih.server_id IS NULL" clause is for in the WHERE clause.  As far as I can recall, the server_id should never be NULL in the instance history table, but there must have been a reason so I''ll leave it in place until I can determine what that reason was.)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[36] 4[29] 2[7] 3) )"
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
         Configuration = "(H (1[49] 4[25] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[43] 4) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "i"
            Begin Extent = 
               Top = 18
               Left = 351
               Bottom = 393
               Right = 552
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ih"
            Begin Extent = 
               Top = 197
               Left = 652
               Bottom = 404
               Right = 841
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 84
               Left = 62
               Bottom = 427
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ia"
            Begin Extent = 
               Top = 18
               Left = 651
               Bottom = 173
               Right = 821
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lit"
            Begin Extent = 
               Top = 396
               Left = 270
               Bottom = 509
               Right = 461
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 2055
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2115
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2625
         Alias = 900
         Table = 1830
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=N'<none>' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=N'[v_instance].[instance], [v_instance].[version] DESC, [v_instance].[patchlvl] DESC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=N'10000' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance this data will reflect.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance version as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Represents the current level of patching as returned by the "serverproperty(''productlevel'')" function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the current edition of the installed SQL Server.  For example: Enterprise, Developer, Standard, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'edition'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the server that this instance resides on.  The name is recorded in the "servers" table and is associated with the "server_id" column described above.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'server_nm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active Directory Domain Name.  This differentiates similar server names that exist in different Active Directory domains.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'domain_nm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'"Fully Quailified Domain Name".  This fully qualifies the server name by appending the domain name (the value in the "domain_nm" column above).  For example: svr1.yahoo.com, svr2.google.com.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'fqdn'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A three letter code representing the physical location of the server.  Note: Given that most servers are virtual, this could conceivably change if the server is VMotioned to another site.  If the three letter code does not exist in the "lu_location" table, it is not considered valid by this system.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'location_cd'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Specifies whether the underlying host is a physical server or a virtual machine.  0 = physical server; 1 = virtual machine.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'is_vm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the linked server to build.  The system will use this linked server to access the remote SQL Server instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the account SQL Server is running as.  This is usually an Active Directory account but can be a local as well.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'service_acct'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the "virtual" instance name that aliases the "instance" value above (implemented as a DNS CName) if one exists.  If no alias exists, the value is null.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'alias'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When this column has a value, it indicates that the SQL Server instance hosting this database is really an alias of another system.  Therefore, the database really resides on the system listed in this collumn.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'is_alias_of'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether to attempt to retrieve data from the remote instance.  Usually, it is set to retrieve data but may be turned off for troubleshooting purposes or if data is no longer needed.  1 = Retrieve data; 0 = Don''t retrieve data.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether disk usage information for this instance is retrieved or not.  1 = Retrieved; 0 = Not retrieved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'retrieve_disk_space'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether database usage information (file size, internal free space) for this instance is retrieved or not.  1 = Retrieved; 0 = Not retrieved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'retrieve_db_space'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Enables or disables the instance row from being processed by some stored procedures.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'enabled_cd'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column will accomodate any notes the user wishes to associate with this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time data in the "instance" table was last modified.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'mod_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this row was created in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this instance information was collected.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Returns a list of all SQL Server instances in the "instances" table regardless of the ENABLED state.  Also includes the most recent "instance_history" information associated with the instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all'
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[36] 4[38] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[28] 4) )"
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
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "ih"
            Begin Extent = 
               Top = 127
               Left = 353
               Bottom = 256
               Right = 542
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 319
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 9
         End
         Begin Table = "ia"
            Begin Extent = 
               Top = 0
               Left = 370
               Bottom = 129
               Right = 540
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
      Begin ColumnWidths = 10
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2385
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_instance_all'
GO

