<#
.SYNOPSIS
   SP2013 Grant and Assign portal super user accounts
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

$webAppURL = ”http://webappFQDN”
$superUser = ”domain\account”
$superReader = ”domain\account”

$wa = Get-SPWebApplication $webAppURL
# grant superuser full control to web app
$fullPolicy = $wa.Policies.Add($superUser, $superUser) 
$fullPolicy.PolicyRoleBindings.Add($wa.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl)) 
# grant superuser full read to web app
$readPolicy = $wa.Policies.Add($superReader, $superReader) 
$readPolicy.PolicyRoleBindings.Add($wa.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullRead))

$wa.Properties["portalsuperuseraccount"] = $superUser
$wa.Properties["portalsuperreaderaccount"] = $superReader
$wa.Update()
