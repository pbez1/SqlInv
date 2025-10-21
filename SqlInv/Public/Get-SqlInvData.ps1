# Responsible for collecting all database inventory related information from remote servers.
function Get-SqlInvData {
    [cmdletbinding()]

    Param(
        [Parameter (Mandatory=$false)]
        [string] $SqlInvServer = $SqlInv_Server
        ,
        [Parameter (Mandatory=$false)]
        [string] $SqlInvDatabase = $SqlInv_Database
        ,
        [Parameter (Mandatory=$false)]
        [string] $MailTo = $Mail_To
        ,
        [Parameter (Mandatory=$false)]
        [string] $Where
        )

    Begin {
        # Set the SqlInv event log parameters.
        $LoggingParms = [PsCustomObject] @{
            SqlInvServer = $SqlInvServer;
            SqlInvDatabase = $SqlInvDatabase;
            LogBatch = @{
                BatchNo = -1     # <0 = Start new batch.
                BatchDesc = 'Update Inventory (ps)'
                Print = 0
                }
            }

            # Get the collection date of record.
        $process_dt = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'

        # Get the list of SQL Servers we'll be querying.
        if ($Where) {
            $where_clause = $Where
            }

        $instance_list = Get-PsInstanceList -WhereClause $where_clause

        # Clear the staging table.
        if ($Instance_list) {
            Clear-PsTableContents -TableName 'db_staging' -LogBatch $LoggingParms.LogBatch
            }
        }

    Process {
        # For each instance, collect its data and write it to the "db_staging" table.
        $instance_cnt = 0
        foreach ($inst in $instance_list) {
            try {
                $instance_cnt++

                # Prepare some variables for ease of use and clarity.
                $instance_id = $inst.instance_id
                $instance_nm = $inst.instance

                Write-Output "Processing Instance: ($instance_cnt) $instance_nm"

                $msg = "Processing instance: $instance_nm ($instance_id)"
                New-LogEntry -LogMessage $msg -LogBatch $LoggingParms.LogBatch

                # Handle named instances.
                $server_nm = $instance_nm.split("\")[0]
                $named_instance = $instance_nm.split("\")[1]
                if (!$named_instance) {$named_instance = "MSSQLSERVER"}

                # Get some of the parameters the T-SQL statement will be unable to obtain.
                $agent_email_eanbled = Get-SqlAgentEmailEnabled -ServerInstance $instance_nm
                $searched_domain = Get-SearchedDomain -Server $server_nm
                $svc_account = (Get-ServiceLogonAccount -Server $server_nm -ServiceDesc 'SQLServer' -InstanceName $named_instance).StartName
                $agt_account = (Get-ServiceLogonAccount -Server $server_nm -ServiceDesc 'SQLAgent' -InstanceName $named_instance).StartName
                $is_vm = Get-IsSqlVm -Server $instance_nm

                # Get the SQL statement template and update the variable tags.
                $sql = Get-DataCollectionSQLTxt
                $sql = $sql -replace "<!instance_id!>", $instance_id
                $sql = $sql -replace "<!instance!>", $instance_nm
                $sql = $sql -replace "<!svc_account!>", $svc_account
                $sql = $sql -replace "<!agt_account!>", $agt_account
                $sql = $sql -replace "<!searched_domain!>", $searched_domain
                $sql = $sql -replace "<!agent_email_enabled!>", $agent_email_eanbled
                $sql = $sql -replace "<!revision!>", $process_dt
                $sql = $sql -replace "<!is_vm!>", $is_vm

                # Run the SQL statement we just prepared above and send email if there's a problem
                try {
                    $instance_data = Invoke-Sqlcmd @sql_parms -ServerInstance $instance_nm -Database 'master' -Query $sql 
                    }
                catch {
                    $subject = "Instance Data Retrieval Failure ($instance_nm)"
                    $msg = "Failed to retrieve data from instance: $instance_nm : $_"
                    Send-DBMail @LoggingParms -Subject $subject -MailMessage $msg
                    }

                # For each data row retrieved by the prepared SQL statement, insert it into the db_staging table.
                foreach ($row in $instance_data) {
                    $sql = "
                        insert into dbo.db_staging (instance_id, instance, dbname, dbid, db_create_dt, dbowner, server, ipv4_addr, ipv4_sql_port, version,
                            edition, patchlvl, service_account, agent_account, cmplevel, [recovery], online_state, updateability, host_version, file_path, file_type,
                            internal_name, snapshot_isolation_state, is_read_committed_snapshot_on, [size], max_size, growth, is_percent_growth,
                            is_auto_create_stats_on, is_auto_update_stats_on, is_auto_update_stats_async_on, is_trustworthy_on, revision, searched_instance,
                            searched_domain, agent_mail_enabled)
                        values (
                            {0},   '{1}',  '{2}',   {3},  '{4}',  '{5}', '{6}', '{7}', '{8}', '{9}', '{10}', '{11}', '{12}', '{13}', {14},  '{15}', '{16}', '{17}', 
                            '{18}', '{19}', '{20}', '{21}', {22},   {23},  {24},  {25},  {26},  {27},   {28},   {29},   {30},   {31}, '{32}', '{33}', '{34}',  {35}
                            )" -f $row.instance_id, $row.instance, $row.dbname, $row.dbid, $row.db_create_dt, $row.dbowner, $row.server, $row.ipv4_addr, $row.ipv4_sql_port,
                                $row.version, $row.edition, $row.patchLevel, $row.service_account, $row.agent_account, $row.cmplevel, $row.recovery, $row.online_state, 
                                $row.updateability, $row.host_version, $row.file_path, $row.file_type, $row.internal_name, $row.snapshot_isolation_state, 
                                $row.is_read_committed_snapshot_on, $row.size, $row.max_size, $row.growth, $row.is_percent_growth, $row.is_auto_create_stats_on, 
                                $row.is_auto_update_stats_on, $row.is_auto_update_stats_async_on, $row.is_trustworthy_on, $row.revision, $row.searched_instance,
                                $row.searched_domain, $row.agent_mail_enabled

                        # Convert the "True" and "False" values PowerShell so helpfully substitutes back to the values we wanted in the first place!
                        $sql = $sql -replace 'false', '0'
                        $sql = $sql -replace 'True', '1'

                    # Insert the data into the db_staging table.
                    Invoke-Sqlcmd @sql_parms -ServerInstance $SqlInvServer -Database $SqlInvDatabase -Query $sql

        # Need to add logging here!!!
        
                    }
                }
            catch{
                $msg = $_
                Write-Output $msg
                if ($_ -match 'Server Connection Failure') {
                    $msg = "Server Connecton Failure!  DSI was unable to connect to instance: $instance_nm"
                    New-LogEntry -LogMessage $msg -LogBatch $LoggingParms.LogBatch

                    # Email an alert
                    $email_profile = Get-SysInfo @LoggingParms -SysInfoParm "sql_mail_profile"
                    Send-DBMail @LoggingParms -Subject "Failure to connect to instance: $instance_nm" -MailMessage $msg -Recipients $MailTo -MailProfile $email_profile
                    }
                else {
                    New-LogEntry -LogMessage $msg -LogBatch $LoggingParms.LogBatch
                    }
                }
            }

        try {
            # Detect and label aliased instances in the new data.
            Get-ServerAliases

            # Signal successful completion of this process.
            # $process_dt = $rslt[-1]
            $sql = "update semaphore set flag = 1, process_dt = '$process_dt' where name = 'retreive_base_inventory'"
            Invoke-Sqlcmd @sql_parms -ServerInstance $SqlInvServer -Database $SqlInvDatabase -Query $sql
            }
        catch {throw $_}
        }

    End {
        # Return the process date recorded by this process in the "db_staging" table.
        $process_dt
        }
    }    
