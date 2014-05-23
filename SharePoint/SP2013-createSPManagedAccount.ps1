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

#Set User Name 
$Username = "Domain\username"
#Set Password    
$Password = ConvertTo-SecureString -AsPlainText "Passw0rd!" -force
#Set Credentials 
$cred = new-object management.automation.pscredential $Username ,$Password 
#Create SP ManagedAccount
New-SPManagedAccount -Credential $cred