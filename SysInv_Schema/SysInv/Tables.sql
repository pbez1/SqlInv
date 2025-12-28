USE [SqlInv]
GO

/****** Object:  Table [dbo].[db_file_paths]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[db_file_paths](
	[db_file_paths_id] [bigint] IDENTITY(1,1) NOT NULL,
	[db_history_id] [bigint] NOT NULL,
	[mount_pt] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[file_path] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[internal_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[size] [bigint] NULL,
	[max_size] [bigint] NULL,
	[growth] [bigint] NULL,
	[is_percent_growth] [bit] NULL,
 CONSTRAINT [PK_db_file_paths] PRIMARY KEY CLUSTERED 
(
	[db_file_paths_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[db_file_paths] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[db_history]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[db_history](
	[db_history_id] [bigint] IDENTITY(1,1) NOT NULL,
	[db_list_id] [bigint] NULL,
	[dbid] [int] NULL,
	[dbowner] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cmplevel] [tinyint] NULL,
	[recovery] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[online_state] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateability] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_auto_create_stats_on] [bit] NULL,
	[is_auto_update_stats_on] [bit] NULL,
	[is_auto_update_stats_async_on] [bit] NULL,
	[is_trustworthy_on] [bit] NULL,
	[db_create_dt] [datetime2](3) NULL,
	[snapshot_isolation_state] [tinyint] NULL,
	[is_read_committed_snapshot_on] [bit] NULL,
	[revision] [datetime2](3) NULL,
	[is_current] [tinyint] NULL,
	[db_size_kb] [bigint] NULL,
	[unallocated_kb] [bigint] NULL,
	[reserved_kb] [bigint] NULL,
	[data_kb] [bigint] NULL,
	[index_size_kb] [bigint] NULL,
	[unused_kb] [bigint] NULL,
 CONSTRAINT [PK_db_history] PRIMARY KEY CLUSTERED 
(
	[db_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[db_history] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[db_list]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[db_list](
	[db_list_id] [bigint] IDENTITY(6374,1) NOT NULL,
	[instance_id] [bigint] NOT NULL,
	[dbname] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[env_cd] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_active] [bit] NOT NULL,
	[systems_id] [bigint] NULL,
	[mod_dt] [datetime] NULL,
	[create_dt] [datetime] NULL,
 CONSTRAINT [PK_db_list] PRIMARY KEY CLUSTERED 
(
	[db_list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[db_list] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[db_space_staging]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[db_space_staging](
	[db_space_staging_id] [bigint] IDENTITY(1,1) NOT NULL,
	[instance] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dbname] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[domain_nm] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[internal_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_path] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[file_size_bytes] [bigint] NOT NULL,
	[free_space_bytes] [bigint] NOT NULL,
	[revision] [datetime] NULL,
	[create_dt] [datetime] NULL,
 CONSTRAINT [PK_db_space_staging] PRIMARY KEY CLUSTERED 
(
	[db_space_staging_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[db_space_staging] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[db_space_usage]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[db_space_usage](
	[db_space_used_id] [bigint] IDENTITY(21332,1) NOT NULL,
	[instance_id] [bigint] NOT NULL,
	[db_list_id] [bigint] NULL,
	[db_file_paths_id] [bigint] NULL,
	[file_size_bytes] [bigint] NOT NULL,
	[free_space_bytes] [bigint] NOT NULL,
	[percent_free_space]  AS (CONVERT([numeric](5,2),(CONVERT([float],[free_space_bytes],(0))/CONVERT([float],[file_size_bytes],(0)))*(100.0),(0))) PERSISTED,
	[is_current] [bit] NULL,
	[import_dt] [datetime] NULL,
	[revision] [datetime] NOT NULL,
	[rev_hour]  AS (datepart(hour,[revision])) PERSISTED,
 CONSTRAINT [PK_db_space_usage] PRIMARY KEY CLUSTERED 
(
	[db_space_used_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[db_space_usage] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[db_staging]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[db_staging](
	[db_staging_id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[instance_id] [bigint] NOT NULL,
	[instance] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dbname] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dbid] [int] NULL,
	[db_create_dt] [datetime] NULL,
	[dbowner] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[server] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ipv4_addr] [nvarchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ipv4_sql_port] [nvarchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[version] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[edition] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[patchlvl] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[service_account] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_account] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cmplevel] [tinyint] NULL,
	[recovery] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[online_state] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateability] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[host_version] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[file_path] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[file_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[internal_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[snapshot_isolation_state] [tinyint] NULL,
	[is_read_committed_snapshot_on] [bit] NULL,
	[size] [bigint] NULL,
	[max_size] [bigint] NULL,
	[growth] [bigint] NULL,
	[is_percent_growth] [bit] NULL,
	[is_auto_create_stats_on] [bit] NULL,
	[is_auto_update_stats_on] [bit] NULL,
	[is_auto_update_stats_async_on] [bit] NULL,
	[is_trustworthy_on] [bit] NULL,
	[revision] [datetime] NULL,
	[db_size_kb] [bigint] NULL,
	[unallocated_kb] [bigint] NULL,
	[reserved_kb] [bigint] NULL,
	[data_kb] [bigint] NULL,
	[index_size_kb] [bigint] NULL,
	[unused_kb] [bigint] NULL,
	[searched_instance_id] [bigint] NULL,
	[searched_instance] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[searched_domain] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_alias_of] [nvarchar](386) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[enable_processing] [bit] NULL,
	[agent_mail_enabled] [int] NULL,
 CONSTRAINT [PK_db_staging] PRIMARY KEY CLUSTERED 
(
	[db_staging_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[db_staging] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[exec_log]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[exec_log](
	[exec_log_id] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[batch_no] [bigint] NOT NULL,
	[reporting_proc] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[message] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_dt] [datetime] NULL,
 CONSTRAINT [PK_exec_log] PRIMARY KEY CLUSTERED 
(
	[exec_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[exec_log] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[exec_log_batch]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[exec_log_batch](
	[exec_log_batch_id] [bigint] IDENTITY(1,1) NOT NULL,
	[batch_no] [bigint] NOT NULL,
	[revision] [datetime] NOT NULL,
	[batch_desc] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_exec_log_batch] PRIMARY KEY CLUSTERED 
(
	[exec_log_batch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[exec_log_batch] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[inst_alias]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[inst_alias](
	[inst_alias_id] [bigint] IDENTITY(1,1) NOT NULL,
	[instance_id] [bigint] NOT NULL,
	[alias] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_cname] [bit] NULL,
	[cname] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[retire_dt] [datetime] NULL,
 CONSTRAINT [PK_inst_alias] PRIMARY KEY CLUSTERED 
(
	[inst_alias_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[inst_alias] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[instance]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[instance](
	[instance_id] [bigint] IDENTITY(1,1) NOT NULL,
	[instance] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[instance_type_cd] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[server_id] [bigint] NULL,
	[env_id] [bigint] NULL,
	[linked_server] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[support_db] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[on_prem] [tinyint] NULL,
	[lu_enabled_id] [bigint] NOT NULL,
	[retrieve_data] [tinyint] NULL,
	[retrieve_disk_space] [tinyint] NULL,
	[retrieve_db_space] [tinyint] NULL,
	[notes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[mod_dt] [datetime] NULL,
	[decom_dt] [datetime] NULL,
	[create_dt] [datetime] NULL,
 CONSTRAINT [PK_instance] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[instance] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[instance_history]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[instance_history](
	[instance_history_id] [bigint] IDENTITY(1,1) NOT NULL,
	[instance_id] [bigint] NOT NULL,
	[instance] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_id] [bigint] NOT NULL,
	[version] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[patchlvl] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cu] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[edition] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_acct] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[service_acct] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_alias_of] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ipv4_addr] [nvarchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ipv4_sql_port] [nvarchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lu_host_version_id] [bigint] NULL,
	[agent_mail_enabled] [int] NULL,
	[is_current] [int] NULL,
	[revision] [datetime2](3) NOT NULL,
 CONSTRAINT [PK_instance_history] PRIMARY KEY CLUSTERED 
(
	[instance_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[instance_history] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_domain_code]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_domain_code](
	[lu_domain_code_id] [bigint] NOT NULL,
	[domain_nm] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[domain_cd] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_domain_code] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_edition]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_edition](
	[lu_edition_id] [bigint] NOT NULL,
	[edition_cd] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[edition] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_edition] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_enabled]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_enabled](
	[lu_enabled_id] [bigint] IDENTITY(1,1) NOT NULL,
	[enabled_cd] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[enabled_desc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_by] [tinyint] NOT NULL,
 CONSTRAINT [PK_lu_enabled] PRIMARY KEY CLUSTERED 
(
	[lu_enabled_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_enabled] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_env]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_env](
	[env_id] [bigint] IDENTITY(1,1) NOT NULL,
	[env_cd] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[env_desc] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ok_instance] [tinyint] NULL,
	[ok_db] [tinyint] NULL,
 CONSTRAINT [PK_lu_env] PRIMARY KEY CLUSTERED 
(
	[env_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_env] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_host_version]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_host_version](
	[lu_host_version_id] [bigint] NOT NULL,
	[host_version] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[os_nm] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_vm] [bit] NULL,
	[release_no] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[build_no] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[common_os_nm] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_host_version] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_instance_type]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_instance_type](
	[lu_instance_type_id] [bigint] IDENTITY(1,1) NOT NULL,
	[instance_type_cd] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[instance_type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lu_instance_type] PRIMARY KEY CLUSTERED 
(
	[lu_instance_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_instance_type] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_location]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_location](
	[lu_location_id] [bigint] IDENTITY(1,1) NOT NULL,
	[location] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[location_cd] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lu_locations] PRIMARY KEY CLUSTERED 
(
	[lu_location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_location] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[lu_sql_version]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_sql_version](
	[lu_sql_version_id] [bigint] IDENTITY(1,1) NOT NULL,
	[version_id] [int] NOT NULL,
	[minor_id] [int] NOT NULL,
	[version_desc] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[create_dt] [datetime] NOT NULL,
 CONSTRAINT [PK_lu_sql_version] PRIMARY KEY CLUSTERED 
(
	[lu_sql_version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[lu_sql_version] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[semaphore]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[semaphore](
	[semaphore_id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[flag] [smallint] NULL,
	[notes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_dt] [datetime] NULL,
	[modified_dt] [datetime] NULL,
	[create_dt] [datetime] NOT NULL,
 CONSTRAINT [PK_semaphore] PRIMARY KEY CLUSTERED 
(
	[semaphore_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[semaphore] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[server]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[server](
	[server_id] [bigint] IDENTITY(1,1) NOT NULL,
	[server_nm] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dns_alias_id] [bigint] NULL,
	[domain_nm] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[lu_location_id] [bigint] NULL,
	[lu_host_version_id] [bigint] NULL,
	[cpu_type] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_cnt] [int] NULL,
	[cpu_core_cnt] [int] NULL,
	[phys_ram_gb] [int] NULL,
	[make] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[model] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fqdn]  AS ([server_nm]+'.pha.pacificsource.com'),
 CONSTRAINT [PK_server] PRIMARY KEY CLUSTERED 
(
	[server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[server] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[sysinfo]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sysinfo](
	[sysinfo_id] [bigint] IDENTITY(1,1) NOT NULL,
	[parameter] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[value] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[datatype] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[revision] [datetime] NOT NULL,
	[create_dt] [datetime] NOT NULL,
 CONSTRAINT [PK_sysinfo] PRIMARY KEY CLUSTERED 
(
	[sysinfo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[sysinfo] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[system_category]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[system_category](
	[system_category_id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_system_category] PRIMARY KEY CLUSTERED 
(
	[system_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[system_category] TO  SCHEMA OWNER 
GO

/****** Object:  Table [dbo].[systems]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[systems](
	[systems_id] [bigint] IDENTITY(1,1) NOT NULL,
	[system_nm] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bus_owner] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[it_owner] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[system_category_id] [bigint] NULL,
	[sort_by] [int] NULL,
	[src_ext] [bit] NOT NULL,
	[import_dt] [datetime] NULL,
	[create_dt] [datetime] NOT NULL,
 CONSTRAINT [PK_systems] PRIMARY KEY CLUSTERED 
(
	[systems_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER AUTHORIZATION ON [dbo].[systems] TO  SCHEMA OWNER 
GO

/****** Object:  Index [IX_db_space_usage-db_file_paths_id]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_db_space_usage-db_file_paths_id] ON [dbo].[db_space_usage]
(
	[db_file_paths_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_db_space_usage-db_list_id-I]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_db_space_usage-db_list_id-I] ON [dbo].[db_space_usage]
(
	[db_list_id] ASC,
	[revision] ASC
)
INCLUDE([db_file_paths_id],[file_size_bytes],[free_space_bytes],[instance_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_db_space_usage-instance_id-db_list_id-Inc]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_db_space_usage-instance_id-db_list_id-Inc] ON [dbo].[db_space_usage]
(
	[instance_id] ASC,
	[db_list_id] ASC
)
INCLUDE([db_file_paths_id],[revision],[rev_hour]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_db_space_usage-instance_id-Inc]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_db_space_usage-instance_id-Inc] ON [dbo].[db_space_usage]
(
	[instance_id] ASC
)
INCLUDE([db_list_id],[db_file_paths_id],[revision],[file_size_bytes],[free_space_bytes]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_db_staging-enable_processing-inc-instance_id-dbname]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_db_staging-enable_processing-inc-instance_id-dbname] ON [dbo].[db_staging]
(
	[enable_processing] ASC
)
INCLUDE([instance_id],[dbname]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_exec_log-batch_no]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_exec_log-batch_no] ON [dbo].[exec_log]
(
	[batch_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_exec_log_batch-batch_no]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_exec_log_batch-batch_no] ON [dbo].[exec_log_batch]
(
	[batch_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_instance-instance]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_instance-instance] ON [dbo].[instance]
(
	[instance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_instance-instance_id-server_id]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_instance-instance_id-server_id] ON [dbo].[instance]
(
	[instance_id] ASC,
	[server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_instance-server_id-instance_id]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_instance-server_id-instance_id] ON [dbo].[instance]
(
	[server_id] ASC,
	[instance_id] ASC
)
INCLUDE([instance]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_lu_enabled]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_lu_enabled] ON [dbo].[lu_enabled]
(
	[enabled_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_lu_env-env_cd]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_lu_env-env_cd] ON [dbo].[lu_env]
(
	[env_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_lu_instance_type-instance_type_cd]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_lu_instance_type-instance_type_cd] ON [dbo].[lu_instance_type]
(
	[instance_type_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_system_category-name]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_system_category-name] ON [dbo].[system_category]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_systems-system_nm-src_ext]    Script Date: 12/27/2025 6:49:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_systems-system_nm-src_ext] ON [dbo].[systems]
(
	[system_nm] ASC,
	[src_ext] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

ALTER TABLE [dbo].[db_space_staging] ADD  CONSTRAINT [DF_db_space_staging_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[db_space_usage] ADD  CONSTRAINT [DF_db_space_usage_is_current]  DEFAULT ((0)) FOR [is_current]
GO

ALTER TABLE [dbo].[db_space_usage] ADD  CONSTRAINT [DF_db_space_usage_create_dt]  DEFAULT (getdate()) FOR [import_dt]
GO

ALTER TABLE [dbo].[db_staging] ADD  CONSTRAINT [DF_db_staging_instance_id]  DEFAULT ((0)) FOR [instance_id]
GO

ALTER TABLE [dbo].[db_staging] ADD  CONSTRAINT [DF_db_staging_enable_processing]  DEFAULT ((1)) FOR [enable_processing]
GO

ALTER TABLE [dbo].[exec_log] ADD  CONSTRAINT [DF_exec_log_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[instance] ADD  CONSTRAINT [DF_instances_instance_type_cd]  DEFAULT ('SQLSERVER') FOR [instance_type_cd]
GO

ALTER TABLE [dbo].[instance] ADD  CONSTRAINT [DF_instance_on_prem]  DEFAULT ((1)) FOR [on_prem]
GO

ALTER TABLE [dbo].[instance] ADD  CONSTRAINT [DF_instance_enabled]  DEFAULT ((2)) FOR [lu_enabled_id]
GO

ALTER TABLE [dbo].[instance] ADD  CONSTRAINT [DF_instance_retrieve_data]  DEFAULT ((1)) FOR [retrieve_data]
GO

ALTER TABLE [dbo].[instance] ADD  CONSTRAINT [DF_instance_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[lu_enabled] ADD  CONSTRAINT [DF_lu_enabled_enabled_cd]  DEFAULT ('E') FOR [enabled_cd]
GO

ALTER TABLE [dbo].[lu_sql_version] ADD  CONSTRAINT [DF_lu_sql_version_minor_id]  DEFAULT ((0)) FOR [minor_id]
GO

ALTER TABLE [dbo].[lu_sql_version] ADD  CONSTRAINT [DF_lu_sql_version_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[semaphore] ADD  CONSTRAINT [DF_semaphores_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[sysinfo] ADD  CONSTRAINT [DF_sysinfo_datatype]  DEFAULT ('string') FOR [datatype]
GO

ALTER TABLE [dbo].[sysinfo] ADD  CONSTRAINT [DF_sysinfo_revision]  DEFAULT (getdate()) FOR [revision]
GO

ALTER TABLE [dbo].[sysinfo] ADD  CONSTRAINT [DF_sysinfo_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[systems] ADD  CONSTRAINT [DF_systems_system_category_id]  DEFAULT ((1)) FOR [system_category_id]
GO

ALTER TABLE [dbo].[systems] ADD  CONSTRAINT [DF_systems_src_ps]  DEFAULT ((0)) FOR [src_ext]
GO

ALTER TABLE [dbo].[systems] ADD  CONSTRAINT [DF_systems_create_dt]  DEFAULT (getdate()) FOR [create_dt]
GO

ALTER TABLE [dbo].[db_file_paths]  WITH CHECK ADD  CONSTRAINT [FK_db_file_paths_db_history_id_db_history_db_history_id] FOREIGN KEY([db_history_id])
REFERENCES [dbo].[db_history] ([db_history_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[db_file_paths] CHECK CONSTRAINT [FK_db_file_paths_db_history_id_db_history_db_history_id]
GO

ALTER TABLE [dbo].[db_history]  WITH CHECK ADD  CONSTRAINT [FK_db_history-db_list_id-db_list-db_list_id] FOREIGN KEY([db_list_id])
REFERENCES [dbo].[db_list] ([db_list_id])
GO

ALTER TABLE [dbo].[db_history] CHECK CONSTRAINT [FK_db_history-db_list_id-db_list-db_list_id]
GO

ALTER TABLE [dbo].[db_list]  WITH CHECK ADD  CONSTRAINT [FK_db_list-instance_id-instance-instance_id] FOREIGN KEY([instance_id])
REFERENCES [dbo].[instance] ([instance_id])
GO

ALTER TABLE [dbo].[db_list] CHECK CONSTRAINT [FK_db_list-instance_id-instance-instance_id]
GO

ALTER TABLE [dbo].[exec_log]  WITH CHECK ADD  CONSTRAINT [FK_exec_log-batch_no-exec_log_batch-batch_no] FOREIGN KEY([batch_no])
REFERENCES [dbo].[exec_log_batch] ([batch_no])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[exec_log] CHECK CONSTRAINT [FK_exec_log-batch_no-exec_log_batch-batch_no]
GO

ALTER TABLE [dbo].[inst_alias]  WITH CHECK ADD  CONSTRAINT [FK_inst_alias-instance_id-instance-instance_id] FOREIGN KEY([instance_id])
REFERENCES [dbo].[instance] ([instance_id])
GO

ALTER TABLE [dbo].[inst_alias] CHECK CONSTRAINT [FK_inst_alias-instance_id-instance-instance_id]
GO

ALTER TABLE [dbo].[instance]  WITH CHECK ADD  CONSTRAINT [FK_instance-env_id-lu_env-env_id] FOREIGN KEY([env_id])
REFERENCES [dbo].[lu_env] ([env_id])
GO

ALTER TABLE [dbo].[instance] CHECK CONSTRAINT [FK_instance-env_id-lu_env-env_id]
GO

ALTER TABLE [dbo].[instance]  WITH CHECK ADD  CONSTRAINT [FK_instance-server_id-server-server_id] FOREIGN KEY([server_id])
REFERENCES [dbo].[server] ([server_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[instance] CHECK CONSTRAINT [FK_instance-server_id-server-server_id]
GO

ALTER TABLE [dbo].[instance_history]  WITH CHECK ADD  CONSTRAINT [FK_instance_history-instance_id_instance_instance_id] FOREIGN KEY([instance_id])
REFERENCES [dbo].[instance] ([instance_id])
GO

ALTER TABLE [dbo].[instance_history] CHECK CONSTRAINT [FK_instance_history-instance_id_instance_instance_id]
GO

ALTER TABLE [dbo].[systems]  WITH CHECK ADD  CONSTRAINT [FK_systems-system_category_id-system_category-system_category_id] FOREIGN KEY([system_category_id])
REFERENCES [dbo].[system_category] ([system_category_id])
GO

ALTER TABLE [dbo].[systems] CHECK CONSTRAINT [FK_systems-system_category_id-system_category-system_category_id]
GO

ALTER TABLE [dbo].[sysinfo]  WITH CHECK ADD  CONSTRAINT [CK_sysinfo-datatype] CHECK  (([datatype]='string' OR [datatype]='bit' OR [datatype]='number' OR [datatype]='encryp_str' OR [datatype]='datetime'))
GO

ALTER TABLE [dbo].[sysinfo] CHECK CONSTRAINT [CK_sysinfo-datatype]
GO

/****** Object:  Trigger [dbo].[update_modified_dt]    Script Date: 12/27/2025 6:49:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[update_modified_dt]
	on [dbo].[semaphore]
	after update 
as begin
	update dbo.semaphore
	set modified_dt = getdate()
	from inserted i
	where i.semaphore_id = semaphore.semaphore_id
	end
GO

ALTER TABLE [dbo].[semaphore] ENABLE TRIGGER [update_modified_dt]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'db_file_paths_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The id of a row in the ''db_history'' table.  This represents a foreign key and associates a row in this table with a row in the ''db_history'' table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the drive letter or mount point path where the file is stored.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'mount_pt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A windows file path which includes both the path and the file name.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'file_path'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes the type of file it is.  Possible types are "DB" and "LOG"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'file_type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server internal name for the file.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'internal_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The size of the file in bytes at the time the information was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'size'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the maximum size the file is allowed to grow to in Megabytes.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'max_size'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the rate at which the file may grow.  It may be in terms of percent growth or an actual absolute amount in Megabytes.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'growth'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a bit value: 1 = the value in the "growth" column is a percentage of the total file size.  0 = The value in the "growth" column is the absolute amount in Megabytes  that the file will be grown.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths', @level2type=N'COLUMN',@level2name=N'is_percent_growth'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table maintains a list of the file names, paths, sizes and internal database names associated with any given database in the "db_history" table.  There will be at least two entries in this table for each database: one for the database file, and one for the log file.  Of course, databases may be associated with more than one database or log file, so there will be more than two entries in this table for databases meeting those conditions; one entry for each file.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_file_paths'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of database in the "db_list" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_list_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server internal database ID number.  This number can be determined by running: SELECT DB_ID(''<database name>'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the owner of the database.  This is different from the persons responsible for the database.  This is the system login name that "owns" the database and is mapped to the "dbo" database user.  Policy dictates that this should be "sa" but not all databases currently comply with this policy.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'dbowner'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The compatibility level of the database.  Compatibility levels are: 70 (SQL Server 7); 80 (SQL Server 2000); 90 (SQL Server 2005); and 100 (SQL Server 2008)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes the recovery model used by the database.  Possible values are: "Full", "Bulk-Load", "Simple"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes whether the database is on-line or off-line at the time this information was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes whether the database is Read-Only or Read-Write.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'updateability'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date this information was imported into the system inventory.  Since historical data is maintained in this table, there may be many inventory data sets collected at different dates and times.  This column differentiates the sets by tagging the individual row with the date and time it was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flags whether the data in a given row is the most recent or not.  This column is set to 1 if it represents the most recent data collected for a given database.  Otherwise, it''s set to 0.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'db_size_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'unallocated_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'reserved_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'data_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'index_size_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history', @level2type=N'COLUMN',@level2name=N'unused_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table maintains all the database historical information.  There are multiple entries in this table for each database in the inventory and these entries are linked to databases recorded in the db_list table.  Note that this table retains historical information so there will be prior information for databases.  (The most recent available data, or "current data", will have a "1" in the "is_current" column.  Note that this flag is NOT the same as the "is_active" flag in the db_list table.  This flag marks the most recent data retrieved for any given database whether that database is active or not.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=N'([db_history].[is_current] Not In (0))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=N'<none>' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=N'10000' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'db_list_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the database.  Examples: master, msdb, dba_tools, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'dbname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column will accomodate any notes the user wishes to associate with this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a link to the particular system this database belongs to (as defined in the "systems" table).  The system might be ECC, Readsoft, NPD, for example.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'systems_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this row was last modified.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'mod_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column contains the date the database was entered into this system.  It does NOT indicate the date the database itself was created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table maintains a list of all the databases on the monitored systems.  There is one entry per instance/database combination and each entry serves as the master entry for the historical detail database information contained in the db_info table.  The db_list/db_info data are linked on db_list_id.  

Databases that are deleted from their respective instances are not deleted from this table but rather they are flagged as inactive by the "up_inventory_retrieve_data" procedure.  Moreover, disabling or decommisioning an instance, inactivates the database, as well.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_list'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'db_staging_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance hosting this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the database.  Examples: master, msdb, dba_tools, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'dbname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server internal database ID number.  This number can be determined by running: SELECT DB_ID(''<database name>'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'dbid'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the owner of the database.  This is different from the persons responsible for the database.  This is the system login name that "owns" the database and is mapped to the "dbo" database user.  Policy dictates that this should be "sa" but not all databases currently comply with this policy.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'dbowner'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Represents the name of the SQL Server from which the data in this row is collected.  This column contains the results of the "SERVERPROPERTY(''ServerName'')" function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance version as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the current edition of the installed SQL Server.  For example: Enterprise, Developer, Standard, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'edition'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance patch level as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the account SQL Server is running as.  This is usually an Active Directory account but can be a local as well.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'service_account'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The compatibility level of the database.  Compatibility levels are: 70 (SQL Server 7); 80 (SQL Server 2000); 90 (SQL Server 2005); and 100 (SQL Server 2008)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'cmplevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes the recovery model used by the database.  Possible values are: "Full", "Bulk-Load", "Simple".' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'recovery'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes whether the database is on-line or off-line at the time this information was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'online_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes whether the database is Read-Only or Read-Write.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'updateability'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A windows file path which includes both the path and the file name.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'file_path'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Describes the type of file it is.  Possible types are "DB" and "LOG".' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'file_type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server internal name for the file.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'internal_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The size of the file in bytes at the time the information was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'size'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date this information was imported into the system inventory.  Since historical data is maintained in this table, there may be many inventory data sets collected at different dates and times.  This column differentiates the sets by tagging the individual row with the date and time it was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'db_size_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'unallocated_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'reserved_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'data_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'index_size_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deprecated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'unused_kb'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of the actual instance searched.  This is the value reported by the remote server as its true name.  It may differ from the name of the instance the system *thinks* it''s searching especially if a DNS alias is involved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'searched_instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column represents the actual name of the instance searched.  This will be the same as the value in the "instance" column unless this row represents an instance alias (which can happen following a cutover to new server).  If that situation arises, the "is_alias_of" column will be populated with the name of the actual server being aliased (which will be the same as "searched_instance").' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'searched_instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the value reported by the remote server as its true Active Directory domain membership.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'searched_domain'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If this column contains data, the value will be the name of the actual SQL Server instance being aliased by the instance specified by the "instance" column.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'is_alias_of'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Occasionally, there may be rows in this table that should be exculded from processing by the "up_inventory_load_from_staging" data procedure.  If that is the case, this column will be set (numeric 1).  Otherwise it will be unset (numeric 0).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging', @level2type=N'COLUMN',@level2name=N'enable_processing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table contains the raw data that is imported from each of the inventoried SQL Server instances.  Data in this table is deleted and repopulated every time the "up_inventory_update" procedure is run.  The data is then parsed and copied to its proper place within the related table structure.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'db_staging'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log', @level2type=N'COLUMN',@level2name=N'exec_log_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A batch number.  All entries that share the same batch number are from the same update attempt.  The "exec_log_id" serves as a sequence number.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log', @level2type=N'COLUMN',@level2name=N'batch_no'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the procedure that is logging the message.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log', @level2type=N'COLUMN',@level2name=N'reporting_proc'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The message logged by the calling object.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log', @level2type=N'COLUMN',@level2name=N'message'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this row was created.  Defaults to: getdate()' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table maintains a log of the steps completed during the import and parsing of the raw SQL Server instance information.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log_batch', @level2type=N'COLUMN',@level2name=N'exec_log_batch_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number of the batch thats been created in the "exec_log" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log_batch', @level2type=N'COLUMN',@level2name=N'batch_no'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time the batch was run.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log_batch', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A brief description of what the batch did.  This can be an ad hoc value for a process that''s run only once or can serve as a kind of category for jobs that are run frequently (since the job will supply the same value each time).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log_batch', @level2type=N'COLUMN',@level2name=N'batch_desc'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table associates an exec_log batch number with a particular date and time, and description.  It is intended to simplify searching for batches that are associated (search for the latest inventory update log, for example).  The batch number would be associated with the "inventory update" category in this table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'exec_log_batch'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'inst_alias', @level2type=N'COLUMN',@level2name=N'inst_alias_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'inst_alias', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The alias that is associated with the value in the "instance" column.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'inst_alias', @level2type=N'COLUMN',@level2name=N'alias'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Specifies whether the virtual instance name (the alias) is also configured as a CName in DNS.  If it is, this value will be 1, otherwise it will be false.  Default: 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'inst_alias', @level2type=N'COLUMN',@level2name=N'is_cname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Specifies the date and time this alias (DNS CName) was retired.  Default: Null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'inst_alias', @level2type=N'COLUMN',@level2name=N'retire_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In order to avoid the problem of having to repoint a database application to a new server whenever its database is moved, this table supports "virtual" SQL Server Instance names via DNS "CNames".  

All applications should connect to a virtual SQL Server instance name rather than the actual SQL Server instance name.  For example, if a database is hosted by a physical SQL Server instance named "SRV001", when the system is upgraded, it might be moved to an instance called "SRV002".  If all connections are made to a virtual host name "VSRV001", for example, which is a DNS "CName" pointing to "SRV001", all that''s necessary is to point the "VSRV001" CName to the new "SRV002" host in DNS and all connections will follow.

This table maps physical SQL Server instance names to their virtual instance names (DNS CName or alias).  Note: In order to facilitate certain DSI functionality, sometimes an virtual name must be created in this table where one doesn''t really exist in DNS.  In this case the "is_cname" column value is set to zero (or false), otherwise it defaults to 1 (true).

The "retire_dt" column records the date and time a particular "physical" instance name was decommissioned.  Names that are still in use record a "null" in this column.

Currently this table is used mostly by DSI views that provide data to DSI reports and the Database Storage Dashboard (Excel spreadsheet).  Since data in the DSI database is related to the physical not the virtual instance name, most DSI reports as well as the Database Storage Dashboard views attempt to eliminate the ambiguity of a single database across multiple physical names over time by using the virtual instance name (which is always unchanging) rather than the physical one.  The "retired_dt" value is used to determine which physical name to use for any given period of time.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'inst_alias'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance this data will reflect.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether this is a SQL Server instance or an instance of some other RDMS.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'instance_type_cd'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID used in the "servers" table to uniquely identifies a particular server.  This is a foreign key.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'server_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a foreign key to the lu_env table.  It determines what environment the SQL Server instance participates in: DEV, QA, PRD, for example.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'env_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the linked server to build.  The system will use this linked server to access the remote SQL Server instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'linked_server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column contains a reference to a specific row in the "authentication" table and is used to ascertain which login name should be used when attempting to connect to a remote system.  It''s used mostly by the "up_linked_servers_create" proceudre.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'login_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Records the name of the DBA support database on this SQL Server instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'support_db'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether this system resides on premesis or in the cloud.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'on_prem'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a foreign key to the lu_enabled table.  It determines the enabled status of this SQL Server instance.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'lu_enabled_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether to attempt to retrieve data from the remote instance.  Usually, it is set to retrieve data but may be turned off for troubleshooting purposes or if data is no longer needed.  1 = Retrieve data; 0 = Don''t retrieve data.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_data'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether disk usage information for this instance is retrieved or not.  1 = Retrieved; 0 = Not retrieved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_disk_space'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines whether database usage information (file size, internal free space) for this instance is retrieved or not.  1 = Retrieved; 0 = Not retrieved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'retrieve_db_space'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column will accomodate any notes the user wishes to associate with this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date this information was last modified.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'mod_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time this row was created in the "instance" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An instance is unique in this system only through its association with a server and domain.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance', @level2type=N'INDEX',@level2name=N'IX_instance-server_id-instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table maintains a list of the SQL Server instance inventoried by this system.  In addition to cataloging SQL Server Instance level information (instance name, version, patch level, etc.) this table also defines which SQL Server instance will be queried and maintained within the system inventory database.  (Instance information may be cataloged in this table without causing database information to be queried during the update process by placing a "0" in the "retrieve_data" column.)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=N'<none>' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=N'<none>' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=N'10000' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'instance_history_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of this instance as recorded in the "instances" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'instance_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the SQL Server instance hosting this database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'instance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID used in the "servers" table to uniquely identifies a particular server.  This is a foreign key.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'server_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance version as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'version'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SQL Server instance patch level as reported by the ServerProperties() function.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'patchlvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the current edition of the installed SQL Server.  For example: Enterprise, Developer, Standard, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'edition'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the account SQL Server is running as.  This is usually an Active Directory account but can be a local as well.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'service_acct'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If this column contains data then the instance name is an alias (DNS alias) of some other actual SQL Server instance meaning that this row will contain information that duplicates the SQL Server it aliases.  Generally, alias instances should be disabled (or decommissioned), but there are occasions where an aliased server may be allowed to exist for a time.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'is_alias_of'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flags whether the data in a given row is the most recent or not.  This column is set to 1 if it represents the most recent data collected for a given database.  Otherwise, it''s set to 0. ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'is_current'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date this information was imported into the system inventory.  Since historical data is maintained in this table, there may be many inventory data sets collected at different dates and times.  This column differentiates the sets by tagging the individual row with the date and time it was imported.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history', @level2type=N'COLUMN',@level2name=N'revision'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table stores a history of instance related data that may change over time.  For example, an instance''s version number and patch level may change from time to time.  This table will record when those changes occur.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'instance_history'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the MS version ID.  For example, the version ID of SQL 2016 is 13, the version ID of SQL 2019 is 15, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'lu_sql_version', @level2type=N'COLUMN',@level2name=N'version_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a description of the version.  For example, SQL 2014, SQL 2019, SQL 2022, etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'lu_sql_version', @level2type=N'COLUMN',@level2name=N'version_desc'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the date and time the row was created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'lu_sql_version', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the system generated surrogate key for this table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'semaphore_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the name of the semaphore.  It is the "logical" Primary key.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is a flag value whose significance is determined by how the semaphore is used.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'flag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is an optional note field that can be used in whatever way is useful by the semaphore.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'notes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the description of the semaphore.  It should be concise and explain to the casual user, what this semaphore is used for as well as how to use it.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the processing date and can help identify when the processing that used the semaphore was executed.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'process_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the date this semaphore was last used.  It is updated automatically and should not be written to directly.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'modified_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is the date this semaphore was created.  It is updated automatically and should not be written to directly.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'External processes that interact with this database need a way to communicate.  This table provides that ability.  External processes may raise or lower a flag here as well as post a process date and a note.  The notes column is intended to contain transient data.  It should not be used for permanent data; use the "description" column for that if necessary.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'semaphore'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table maintains a list of host server names.  Default instances of SQL Server adopt the name of the host server but clustered instances are not bound by this rule.  Clustered instances of SQL Server as well as CNAME alias''s, generally assign instance names that offer no indication of the actual name of the host server they''re running on.  This table provides the actual name of the server hosting any given SQL Server instance and is tied to the instances listed in the "instance" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'server'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Constrains datatype to: ''string, ''bit'' or ''number''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysinfo', @level2type=N'CONSTRAINT',@level2name=N'CK_sysinfo-datatype'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'system_category', @level2type=N'COLUMN',@level2name=N'system_category_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The category name.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'system_category', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A brief description of the category.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'system_category', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Assures no duplicate names.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'system_category', @level2type=N'INDEX',@level2name=N'IX_system_category-name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table contains system categories and supports the "systems" table.  System categories examples may be: SAP, Business Intelligence, Client Support, etc.  This is part of a currently partially implemented effort to associate databases with their respective systems.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'system_category'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System generated sequential numeric ID.  Uniquely identifies a given row.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems', @level2type=N'COLUMN',@level2name=N'systems_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the system.  Sophos, ECC, VMWare, are examples.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems', @level2type=N'COLUMN',@level2name=N'system_nm'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A description of the system.  Useful when the sysname value is vague or not well known.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A reference into the "system_category" table.  It may be null.  The "system_category" table contains a list of system categories that may be useful in grouping systems into functional roles.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems', @level2type=N'COLUMN',@level2name=N'system_category_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Source of this row was manual entry; 1 = This row was sourced from external data.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems', @level2type=N'COLUMN',@level2name=N'src_ext'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time the row was created in the "systems" table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems', @level2type=N'COLUMN',@level2name=N'create_dt'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lists many of the "Systems", both built in-house and third party, in use by the company.  Examples include: Sophos, Landesk, NPD, SysInv, etc.  This is part of a currently partially implemented effort to associate databases with their respecive systems.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'systems'
GO

