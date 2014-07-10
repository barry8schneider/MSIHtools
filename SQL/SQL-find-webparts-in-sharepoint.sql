SELECT DISTINCT
	Webs.FullUrl AS sitecollectionURL, 
	Docs.DirName, Docs.LeafName, Docs.UIVersionString, WebParts.tp_PartOrder, 
	WebParts.tp_ZoneID, WebParts.tp_Version AS webpart_version, WebParts.tp_IsCurrentVersion,
	WebParts.tp_WebPartTypeID, WebParts.tp_Assembly, WebParts.tp_Class,
	UD.tp_Modified, UD.tp_Created, UD.nvarchar2 AS createdBy, UD.nvarchar1 AS modifiedBy
FROM Docs
INNER JOIN Webs On Docs.WebId = Webs.Id
INNER JOIN AllWebParts webparts ON Docs.Id = WebParts.tp_PageUrlID
LEFT JOIN AllLists ON Docs.ListId = AllLists.tp_ID

INNER JOIN UserData ud ON ud.tp_ListID = AllLists.tp_ID 
	AND ud.tp_id = docs.DoclibRowId
	AND ud.tp_IsCurrent = 1
	AND UD.tp_RowOrdinal = 0 -- without this, the records will be duplicated

WHERE WebParts.tp_IsCurrentVersion = 1
AND Docs.IsCurrentVersion = 1
/*
How to get the webpart GUID WebParts.tp_WebPartTypeID:
	1) you know a page that this is on and you run this query for that page (without any WebParts where clause)
	2) it's listed in a PSConfig error log (ex. [powershell] [SPContentDatabaseSequence] [WARNING] [8/4/2010 3:50:55 PM]: WebPart class [8a860dca-4061-d270-a67b-f6bde7fc3e0a] is referenced [10] times in the database [NICHDSPETS01-SP-NCS-Content], but is not installed on the current farm. Please install any feature/solution which contains this web part.)
	3) Central Admin > Monitoring > Review problems and solutions > Missing server side dependencies:
		[MissingWebPart] WebPart class [8a860dca-4061-d270-a67b-f6bde7fc3e0a] is referenced [81] times in the database [wss_Content], but is not installed on the current farm. 
*/
AND (
	--WebParts.tp_Assembly LIKE '%00e293235734db6b%' -- many times this field is NULL, if it has a value, its the PublicKeyToken of the assembly found in web.config (example data: aRTEWebPart, Version=1.0.0.0, Culture=neutral, PublicKeyToken=79a02695d35014e8)
	--WebParts.tp_Class LIKE '%OrgUnitsRightNav%' -- many times this field is NULL, if it has a value, its the Namespace of the assembly found in web.config (example data: aRTE.SharePoint.WebControls)
	--OR
	--WebParts.tp_Class LIKE '%OrgUnits.SupportedProjects%' -- many times this field is NULL, if it has a value, its the Namespace of the assembly found in web.config (example data: aRTE.SharePoint.WebControls)
	--OR
	--WebParts.tp_Class LIKE '%OrgUnits.StaffContacts%' -- many times this field is NULL, if it has a value, its the Namespace of the assembly found in web.config (example data: aRTE.SharePoint.WebControls)
	--OR
	WebParts.tp_Class LIKE '%NICHDWWW.FOA.AllRelatedFOAs.AllRelatedFOAs%' -- many times this field is NULL, if it has a value, its the Namespace of the assembly found in web.config (example data: aRTE.SharePoint.WebControls)
)
--AND Docs.DirName + '/' + Docs.LeafName = 'grants-funding/opportunities-mechanisms/active-foa/Pages/default.aspx'
--AND tp_zoneID = 'CenterRightColumn' 	-- other webpart zones: CenterRightColumnTopID
/* 
	to get the spelling of the zoneID, add a webpart to the zone of interest on a particular page and run this query without any WebParts where clause 
	so far, the ncs site uses: 
	CenterColumn, CenterRightColumn, Footer
*/
ORDER BY Docs.DirName, Docs.LeafName, Docs.UIVersionString, WebParts.tp_PartOrder, WebParts.tp_ZoneID
