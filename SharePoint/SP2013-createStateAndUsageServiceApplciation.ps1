<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

$ver = $host | select version
if ($ver.Version.Major -gt 1) {$host.Runspace.ThreadOptions = "ReuseThread"} 
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$sqlserveralias=”EnterName”
New-SPStateServiceApplication -Name "State Service"
Get-SPStateServiceApplication  | New-SPStateServiceApplicationProxy -defaultproxygroup
Get-SPStateServiceApplication | New-SPStateServiceDatabase -Name "State_Service_DB" -Databaseserver $sqlserveralias
Get-spdatabase | where-object {$_.type -eq "Microsoft.Office.Server.Administration.StateDatabase"} | initialize-spstateservicedatabase

<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

New-SPUsageApplication -Name "Usage and Health Data Collection"

$proxy = Get-SPServiceApplicationProxy | where {$_.TypeName -eq "Usage and Health Data Collection Proxy"}

$proxy.Provision()