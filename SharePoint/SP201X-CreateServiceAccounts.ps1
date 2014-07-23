# Script to create Active Directory accounts
# v2 9/12/2012
# Todd Klindt
# http://www.toddklindt.com
 
# Add the Active Directory bits and not complain if they're already there
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
 
# set default password
# change pass@word1 to whatever you want the account passwords to be
$defpassword = (ConvertTo-SecureString "pass@word1" -AsPlainText -force)
 
# Get domain DNS suffix
$dnsroot = '@' + (Get-ADDomain).dnsroot

# Import the file with the users. You can change the filename to reflect your file
$users = Import-Csv .\users.csv
 
Import-Module ActiveDirectory
 
$dnsroot = '@' + (Get-ADDomain).DNSRoot
$accountPassword = (ConvertTo-SecureString "pass@word1" -AsPlainText -force)
 
Import-Csv SharePoint_Users.csv | foreach-object {
     #In case of specific OU. For example: OU=ServiceAccount
    if ($_.OU -ne "") { $OU = "OU=" + $_.OU + ',' + (Get-ADDomain).DistinguishedName }
    else { $OU = (Get-ADDomain).UsersContainer }
 
    #In case of for example a service account without first and last name.
    if ($_.FirstName -eq"" -and $_.LastName -eq "") { $Name = $_.SamAccountName }
    else { $Name = ($_.FirstName + " " + $_.LastName) }
 
    if ($_.Manager -eq "") {
        New-ADUser -Name $Name -SamAccountName $_.SamAccountName -DisplayName $Name
            -Description $_.Description -GivenName $_.FirstName -Surname $_.LastName `
            -EmailAddress ($_.SamAccountName + $dnsroot) -Title $_.Title `
            -UserPrincipalName ($_.SamAccountName + $dnsroot) -Path $OU -Enabled $true `
            -ChangePasswordAtLogon $false -PasswordNeverExpires $true `
            -AccountPassword $accountPassword -PassThru
    }
    else {
        New-ADUser -Name $Name -SamAccountName $_.SamAccountName -DisplayName $Name
            -Description $_.Description -GivenName $_.FirstName -Surname $_.LastName `
            -EmailAddress ($_.SamAccountName + $dnsroot) -Title $_.Title`
            -UserPrincipalName ($_.SamAccountName + $dnsroot) -Path $OU -Enabled $true `
            -ChangePasswordAtLogon $false -Manager $_.Manager -PasswordNeverExpires $true `
            -AccountPassword $accountPassword -PassThru
    }
}