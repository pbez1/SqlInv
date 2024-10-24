# This procedure attempts to identify and label instances that alias other instances.  
# An alias is a server name that references a server by another name.
Function Get-ServerAliases {
    [cmdletbinding()]
    Param(
        [Parameter (Mandatory=$false)]
        [string] $SqlInvServer = $global:DSI_Server
        )
    
Write-Verbose 'Running the "up_identify_instance_aliases" procedure located in the DSI database.'

$sql = 'exec up_identify_instance_aliases'

try {
    Invoke-Sqlcmd @sql_parms -ServerInstance $SqlInvServer -Database 'dsi' -Query $sql
    }
catch{
    throw "$_"
    }
}

