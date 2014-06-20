# create a backup file

$filePath = "C:\Windows\Temp\web.config"
if  ($filePath -ne "")
{
	$file = Get-ChildItem $filePath
    if ($file.Count -eq 1)
    {

    $dateTime=get-date -f yyyyMMdd-hhmmss
    "$($file.DirectoryName)\$($file.Name)-$dateTime-bak$($file.Extension)"
    Copy-Item $file "$($file.DirectoryName)\$($file.Name)-$dateTime-bak$($file.Extension)" -Force 
    }
    else
    {
    
    write-host Enter File name . you only ented a directory
    }
}
else
{
write-host Enter File Path
}