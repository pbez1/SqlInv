# This procedure attempts to identify and label instances that alias other instances.  
# An alias is a server name that references a server by another name.
Function Get-ServerAliases {
    [cmdletbinding()]
    Param(
        [Parameter (Mandatory=$false)]
        [string] $SqlInvServer = $SqlInv_Server
        )
    
Write-Verbose 'Running the "up_identify_instance_aliases" procedure located in the DSI database.'

try {
    $sql = 'exec up_identify_instance_aliases'
    Invoke-Sqlcmd @sql_parms -ServerInstance $SqlInvServer -Database 'dsi' -Query $sql
    }
catch{
    throw "$_"
    }
}

