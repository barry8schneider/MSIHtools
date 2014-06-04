$SPDatabases = Get-SPDatabase
foreach ($SPdatabase in $SPdatabases)
{
    write-host "$($SPdatabase.NormalizedDataSource), $($SPdatabase.Name)"
}