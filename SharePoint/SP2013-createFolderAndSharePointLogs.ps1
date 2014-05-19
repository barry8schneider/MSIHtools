<#
.SYNOPSIS
   Create SharePoint Log Folder and Configure SharePoint
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

$drive = "C"
$path = "SharePointLogs"

#################
## install SharePoint ##
#################
$ver = $Host | select version
if ($ver.Version.Major -gt 1) {$Host.Runspace.ThreadOptions = "ReuseThread"} 
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###########################
## set log file location ##
###########################
#create new directory if needed on all sharepoint servers
$serverNames = get-spserver | ? { $_.Role -eq "Application" }
foreach($serverName in $serverNames){
 $sn = $serverName.Name
 write-host \\$sn\$drive$
        $drive_exist = Test-Path -Path \\$sn\$drive$
        if ($drive_exist -eq $false)
        {
            [console]::ForegroundColor = "red"
            read-host "$drive drive does not exist. Please manually set log directory. Press ENTER to exit script."
            [console]::ResetColor()
            exit
        }
        write-host "\\$sn\$drive$\$path"
        $folder_exist = Test-Path -Path "\\$sn\$drive$\$path"
        $folder_exist
        if ($folder_exist -eq $false)
        {
            #create it
            New-Item -Path "\\$sn\$drive$\$path" -ItemType directory
            Test-Path -Path "\\$sn\$drive$\$path"
        }
 }
  

# max storage for ULS log 20GB   
$drive = $drive + ":" 
set-SPDiagnosticConfig -LogLocation "$drive\$path" -LogDiskSpaceUsageGB 20 -LogMaxDiskSpaceUsageEnabled:$true
set-SPUsageService -UsageLogLocation "$drive\$path"



