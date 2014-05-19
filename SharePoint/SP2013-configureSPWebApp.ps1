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

$ver = $Host | select version
if ($ver.Version.Major -gt 1) {$Host.Runspace.ThreadOptions = "ReuseThread"} 
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}
$publicFacing = $true #set true to enable anonymous access on web
$spwebAppURL = ""
$spwebapp = Get-SPWebApplication $spwebAppURL
# UTC-5 Eastern Time
$spwebapp.DefaultTimeZone = 35
# Person Name actions and presence setting
$spwebapp.PresenceEnabled = $FALSE
# RSS setting
$spwebapp.SyndicationEnabled = $FALSE
$spwebapp.BrowserFileHandling = [Microsoft.SharePoint.SPBrowserFileHandling]::Permissive
$spwebapp.MaximumFileSize = 75
# Change Log to never
$spwebapp.ChangeLogExpirationEnabled = $FALSE

#if the sharepoint site is public facing then enable anonymous access
if($publicFacing)
{
    $authprov = Get-SPAuthenticationProvider -WebApplication $spwebAppURL -Zone Default
    $authprov.AllowAnonymous = 1
}


