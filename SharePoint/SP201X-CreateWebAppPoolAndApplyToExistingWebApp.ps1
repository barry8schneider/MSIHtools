asnp *SharePoint* -ErrorAction SilentlyContinue
$NewAppPoolUserName = "domain\account"

$Farm = Get-SPFarm
$Service = $Farm.Services | where {$_.TypeName -eq "Microsoft SharePoint Foundation Web Application"}
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString

$WebAppURL = "http://stagingwww2013.nichd.nih.gov/"
$NewAppPoolName = "StagingNICHDWWW2013AppPool"
$NewAppPool = New-Object Microsoft.SharePoint.Administration.SPApplicationPool($NewAppPoolName,$Service)
$NewAppPool.CurrentIdentityType = "SpecificUser"
$NewAppPool.Username = $NewAppPoolUserName
$NewAppPool.SetPassword($Password)
$NewAppPool.Provision()
$NewAppPool.Update($true)

$NewAppPool = $Service.ApplicationPools[$NewAppPoolName]
$WebApp = Get-SPWebApplication $WebAppURL
$WAAppPool = $WebApp.ApplicationPool = $NewAppPool
$WebApp.Update()
$WebApp.ProvisionGlobally()