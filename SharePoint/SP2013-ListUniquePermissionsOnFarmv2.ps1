$WebApplication = ""

$FieldDelimiter = ","
 
# Load the SharePoint PowerShell snapin if needed
if ((Get-PSSnapin -Name Microsoft.SharePoint.Powershell -EA SilentlyContinue) -eq $null)
{
   Write-Host "Loading the SharePoint PowerShell snapin..."
   Add-PSSnapin Microsoft.SharePoint.Powershell
}
 
$webapps = Get-SPWebApplication -ea silentlyContinue
if ($webapps -eq $null)
{
   Write-Host -ForegroundColor Red "The URL $WebApplication is not a valid webapplication"
   exit
}
foreach ($webapp in $webapps)
{

$sites = Get-SPSite -WebApplication $webapp -Limit All
$header = [string]::Format("Site{0}Web{0}List{0}# Items{0}Break Permission Inheritance{0}# Items with unique permissions", $FieldDelimiter)
 
Write-Output $header
foreach ($site in $sites)
{
   $siteUrl = $site.Url
   $webs = $site.AllWebs
   $detail = [string]::Format("$siteUrl{0}{0}{0}{0}{0}", $FieldDelimiter)
   Write-Output $detail
   foreach ($web in $webs)
   {
      $webUrl = $web.Url
      $lists = $web.Lists
      $webBreakInheritance = $web.HasUniqueRoleAssignments
      if ($webBreakInheritance)
      {
        $detail = [string]::Format("$siteUrl{0}$webUrl{0}{0}{0}$webBreakInheritance{0}", $FieldDelimiter)
        Write-Output $detail
      }
      foreach ($list in $lists)
      {
         $items = $list.Items
         $listItemCount = $items.Count
         $listBreakInheritance = $list.HasUniqueRoleAssignments
         $i = 0
         try
         {
            foreach ($item in $items)
            {
               if ($item.HasUniqueRoleAssignments)
               {
                  $i++
               }
            }
         }
         catch {}
         if ($listBreakInheritance)
         {
            $detail = [string]::Format("$siteUrl{0}$webUrl{0}$($list.Title){0}$listItemCount{0}$listBreakInheritance{0}$i", $FieldDelimiter)
         Write-Output $detail
         }
      }
      $web.Dispose()
   }
   $site.Dispose()
}
} 
