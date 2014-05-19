<#
.SYNOPSIS
   SharePoint 2013 Setup Scrip
.DESCRIPTION
   This script will
   - Disable Loopback Check
.PARAMETER <paramName>
   None
.EXAMPLE
   None
#>

# Disable Loopback Check
New-ItemProperty HKLM:\System\CurrentControlSet\Control\Lsa -Name "DisableLoopbackCheck" -Value "1" -PropertyType dword -ErrorAction SilentlyContinue


# Disable Firewall
netsh advfirewall set allprofiles state off

# Create SQL Aliase
#This is the name of your SQL Alias
$AliasName = "Alias2"  #Standard is to use the name of the current server
 
#This is the name of your SQL server (the actual name!)
$ServerName = "ServerName2"
 
#These are the two Registry locations for the SQL Alias locations
$x86 = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
$x64 = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
 
#We're going to see if the ConnectTo key already exists, and create it if it doesn't.
if ((test-path -path $x86) -ne $True)
{
    write-host "$x86 doesn't exist"
    New-Item $x86
}
if ((test-path -path $x64) -ne $True)
{
    write-host "$x64 doesn't exist"
    New-Item $x64
}
 
#Adding the extra "fluff" to tell the machine what type of alias it is
$TCPAlias = "DBMSSOCN," + $ServerName
$NamedPipesAlias = "DBNMPNTW,\\" + $ServerName + "\pipe\sql\query"
 
#Creating our TCP/IP Aliases
New-ItemProperty -Path $x86 -Name $AliasName -PropertyType String -Value $TCPAlias
New-ItemProperty -Path $x64 -Name $AliasName -PropertyType String -Value $TCPAlias

Creating our Named Pipes Aliases
New-ItemProperty -Path $x86 –Name $AliasName -PropertyType String -Value $NamedPipesAlias
#New-ItemProperty -Path $x64 –Name $AliasName -PropertyType String -Value $NamedPipesAlias

#check SQL alias
$Server=$AliasName
$connectionString = "Data Source=$Server;Integrated Security=true;Initial Catalog=master;Connect Timeout=3;"
$results="script failed to run"

            try {
                    # Try and connect to server
                    $sqlConn = new-object ("Data.SqlClient.SqlConnection") $connectionString
                    $sqlConn.Open()
  
                          # If connection was made to the server
                            if ($sqlConn.State -eq 'Open')
                            {
                                # write to output and verbose
                                $sqlConn.Close();
                                $results= "Successfully connected to SQL Alias: $Server"
                            }
                   
                }

            catch   {

                    # If connection failed write to verbose
                    $results= "Failed to connected to SQL Alias: $Server . Please fix"
                    }

CLS
$results
	
#Disabling the UAC 
New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force
Restart-Computer

