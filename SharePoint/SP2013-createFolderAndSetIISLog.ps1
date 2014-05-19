<#
.SYNOPSIS
   Create IIS Log Folder and Configure IIS
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>
$drive = "C"
$drive = $drive + ":"
$path = "IISlogs"
#################
## install IIS ##
#################
Import-Module servermanager
Add-WindowsFeature web-server
###########################
## set log file location ##
###########################
#create new directory if needed
$drive_exist = Test-Path -Path "$drive"
if ($drive_exist -eq $false)
{
    [console]::ForegroundColor = "red"
    read-host "$drive drive does not exist. Please manually set log directory. Press ENTER to exit script."
    [console]::ResetColor()
    exit
}
Write-Host drive exists
$folder_exist = Test-Path -Path "$drive\$path"
if ($folder_exist -eq $false)
{
    #create it
    Write-Host create path
    New-Item -Path "$drive\$path" -ItemType directory
}
else
{
Write-Host path exists
}
#load the existing XLM configuration file
$xml = [xml](Get-Content C:\Windows\System32\inetsrv\config\applicationHost.config)
#set server wide defaults
$xml.configuration."system.applicationHost".sites.siteDefaults.logfile.directory = "$drive\$path"
$xml.configuration."system.applicationHost".sites.siteDefaults.tracefailedrequestslogging.directory = "$drive\$path"
#set individual site defaults
$xml.configuration."system.applicationHost".log.centralW3CLogFile.directory = "$drive\$path"
$xml.configuration."system.applicationHost".log.centralBinaryLogFile.directory = "$drive\$path"
#save changes
$xml.save('C:\Windows\System32\inetsrv\config\applicationHost.config')