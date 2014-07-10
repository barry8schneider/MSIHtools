$contentapppools= [Microsoft.SharePoint.Administration.SPWebService]::ContentService.ApplicationPools
$contentapppools | ft Name,id,status