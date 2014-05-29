#removes workflows associated with lists
$site = Get-SPSite "http://website"

foreach($web in $site.AllWebs)
{

    foreach($list in $web.Lists)
    {
        $tempList = New-Object System.Collections.Generic.List[System.Object]
        
        foreach($wf in $list.WorkflowAssociations) { $tempList.Add($wf); }

        foreach ($wf in $tempList)
        { 
            Write-host "Site URL :" $web.Url ", List Name :" $list.Title ", Workflow Name :" $wf.Name -foregroundcolor  "Yellow"
            
           $list.RemoveWorkflowAssociation($wf); 
            
            Write-Host  "Workflow association removed Successfully." -foregroundcolor  "Green"
        }
        
        $list.Update();
    }
}