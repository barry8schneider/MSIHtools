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

$webapps = Get-SPWebApplication -ea silentlyContinue

foreach ($webapp in $webapps)
{

    $sites = Get-SPSite -WebApplication $webapp -Limit All

    foreach ($site in $sites)
    {
        $webs = $site.AllWebs
        foreach ($web in $webs)
        {
            $lists = $web.Lists
            foreach ($list in $lists)
            {


            }
            $web.Dispose()
        }
        $site.Dispose()
    }
} 
