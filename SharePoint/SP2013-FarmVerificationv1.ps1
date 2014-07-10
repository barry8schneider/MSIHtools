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
cls
$ver = $Host | select version
if ($ver.Version.Major -gt 1) {$Host.Runspace.ThreadOptions = "ReuseThread"} 
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$webapps = Get-SPWebApplication -ea silentlyContinue

foreach ($webapp in $webapps)
{
    write-host ---------------
    write-host Web App Name:, $webapp.Name 
    write-host Web App URL:,$webapp.Url
    $props = @("UseClaimsAuthentication", "FileNotFoundPage","DefaultTimeZone","MaximumFileSize","SyndicationEnabled","BrowserFileHandling","PresenceEnabled","ChangeLogExpirationEnabled")

    foreach( $p in $props)
    {
        write-host $p':', $($webapp.$p)
    }

    write-host portalsuperuseraccount':', $webapp.Properties.portalsuperuseraccount
    write-host portalsuperreaderaccount':', $webapp.Properties.portalsuperreaderaccount
    write-host AllowAnonymous':', $webapp.IisSettings['Default'].AllowAnonymous


    $sites = Get-SPSite -WebApplication $webapp -Limit All


    foreach ($site in $sites)
    {
        Write-Host site collection':', $($siteAdmin.ParentWeb.Url) 
        foreach($siteAdmin in $site.RootWeb.SiteAdministrators)
        {
            Write-Host "Site Collection Administrators: $($siteAdmin.UserLogin) |($($siteAdmin.DisplayName))"
        }

        $webs = $site.AllWebs
        foreach ($web in $webs)
        {
            Write-Host Anonymous Status':' $web.Url '|' $web.AnonymousState
            foreach ($list in $lists)
            {


            }
            $web.Dispose()
        }
        $site.Dispose()
    }
} 
write-host -----Get Deployment Path-----
Get-SPContentDeploymentPath
write-host -----Get Deployment Jobs-----
Get-SPContentDeploymentJob

