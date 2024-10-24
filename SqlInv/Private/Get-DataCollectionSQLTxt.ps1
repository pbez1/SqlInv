Function Get-DataCollectionSQLTxt {
    [cmdletbinding()]
    Param()
    
    [string] $sql = "
        begin try
            select 
                <!instance_id!> instance_id,
                '<!instance!>' instance,
                db.name dbname, 
                db.database_id dbid,
                db.create_date db_create_dt,
                suser_sname(db.owner_sid) dbowner,
                convert(nvarchar(128), SERVERPROPERTY('ComputerNamePhysicalNetBIOS')) server,  
                (select top 1 isnull(local_net_address, 'Not found') from master.sys.dm_exec_connections ec where ec.net_transport = 'TCP' and ec.local_net_address is not null and ec.local_net_address not in ('::1', '127.0.0.1') and ec.local_net_address not like '%:%') ipv4_addr,
                --(select top 1 local_tcp_port from master.sys.dm_exec_connections ec1 where ec1.net_transport = 'TCP' and ec1.local_net_address is not null) ipv4_sql_port,
                convert(nvarchar(50), SERVERPROPERTY('ProductVersion')) version,
                convert(nvarchar(128), SERVERPROPERTY('Edition')) edition,
                convert(varchar(10), serverproperty('productlevel')) patchLevel,
                '<!svc_account!>' service_account, 
                '<!agt_account!>' agent_account, 
                [compatibility_level] cmplevel,
                convert(varchar(50), DATABASEPROPERTYEX (db.name, 'Recovery')) recovery,
                db.state_desc online_state, 
                convert(varchar(50), DATABASEPROPERTYEX (db.name, 'Updateability')) updateability,
                left(right(@@version, len(@@version) - charindex('Windows ', @@version) + 1), len(right(@@version, len(@@version) - charindex('Windows ', @@version)))) [host_version], --+ case when <!is_vm!> = 1 then ' (Hypervisor)' else '' end [host_version],       
                mf.physical_name file_path, 
                mf.type_desc file_type, 
                mf.name internal_name, 
                db.snapshot_isolation_state snapshot_isolation_state,
                db.is_read_committed_snapshot_on is_read_committed_snapshot_on,
                (cast(mf.size as bigint) * 8192) size,
                case
                    when mf.max_size >= 0 then
                        (cast(mf.max_size as bigint) * 8192)
                    else
                        cast(mf.max_size as bigint)
                    end as max_size,
                case
                    when is_percent_growth = 0 then
                        (cast(mf.growth as bigint) * 8192)
                    else
                        cast(mf.growth as bigint)
                    end as growth,
                is_percent_growth is_percent_growth,
                db.is_auto_create_stats_on is_auto_create_stats_on, 
                db.is_auto_update_stats_on is_auto_update_stats_on, 
                db.is_auto_update_stats_async_on is_auto_update_stats_async_on, 
                db.is_trustworthy_on is_trustworthy_on,
                '<!revision!>' revision,
                convert(nvarchar(128), SERVERPROPERTY('ServerName')) searched_instance,
                '<!searched_domain!>' searched_domain,
                '<!agent_email_enabled!>' agent_mail_enabled
            from 
                sys.databases db inner join
                sys.master_files mf on db.database_id = mf.database_id left outer join
                sys.server_principals sp on sp.sid = db.owner_sid
            end try
        begin catch
            select ROWCOUNT_BIG() row_cnt, Error_Message() err_msg
            end catch
        "

    $sql
    }
    
