Function Remove-WebApplicataionPool($ApplicationPoolName){
	$apppool = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.ApplicationPools | where {$_.Name -eq $ApplicationPoolName}
	if ($apppool -eq $null){
		write-host "The Application Pool $ApplicationPoolName does not exist!"
		return
	}
	$apppool.UnProvisionGlobally()
	write-host "$ApplicationPoolName has been deleted"
}

Remove-WebApplicataionPool -ApplicationPoolName "AppPoolName"