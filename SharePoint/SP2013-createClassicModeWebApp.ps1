<#
.SYNOPSIS
   Create Classic Mode Web App in SharePoint 2013
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

$ver = $Host | select version
if ($ver.Version.Major -gt 1) {$Host.Runspace.ThreadOptions = "ReuseThread"} 
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$webAppName = ”EnterName”
$webAppPoolName = ”EnterAppPool”
$webAppPoolAccount = ”domain\account”
$hostHeaderFQDN = ”EnterFQDN”
$webAppURL = ”http://$hostHeaderFQDN”
$databaseName = ”EnterDatabseName”

New-SPWebApplication -Name $webAppName -ApplicationPool $webAppPoolName -AuthenticationMethod "NTLM" -ApplicationPoolAccount (Get-SPManagedAccount $webAppPoolAccount) -HostHeader $hostHeaderFQDN -Port 80 -URL $webAppURL –DatabaseName $databaseName # -AllowAnonymousAccess
