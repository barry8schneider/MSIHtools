SELECT DISTINCT
	'/' + Docs.DirName + '/' + Docs.LeafName AS thepage, 
	WebParts.tp_Class, 
	Docs.UIVersionString, 
	WebParts.tp_ZoneID, WebParts.tp_Version AS webpart_version, WebParts.tp_IsCurrentVersion,
	UD.tp_Created, UD.nvarchar2 AS createdBy, UD.tp_Modified, UD.nvarchar1 AS modifiedBy
FROM Docs
INNER JOIN Webs On Docs.WebId = Webs.Id
INNER JOIN AllWebParts webparts ON Docs.Id = WebParts.tp_PageUrlID
LEFT JOIN AllLists ON Docs.ListId = AllLists.tp_ID

INNER JOIN UserData ud ON ud.tp_ListID = AllLists.tp_ID 
	AND ud.tp_id = docs.DoclibRowId
	--AND ud.tp_IsCurrent = 1
	AND UD.tp_RowOrdinal = 0 -- without this, the records will be duplicated

WHERE 1 = 1
--and WebParts.tp_IsCurrentVersion = 1
--AND Docs.IsCurrentVersion = 1
/*
How to get the webpart GUID WebParts.tp_WebPartTypeID:
	1) you know a page that this is on and you run this query for that page (without any WebParts where clause)
	2) it's listed in a PSConfig error log (ex. [powershell] [SPContentDatabaseSequence] [WARNING] [8/4/2010 3:50:55 PM]: WebPart class [8a860dca-4061-d270-a67b-f6bde7fc3e0a] is referenced [10] times in the database [NICHDSPETS01-SP-NCS-Content], but is not installed on the current farm. Please install any feature/solution which contains this web part.)
	3) Central Admin > Monitoring > Review problems and solutions > Missing server side dependencies:
		[MissingWebPart] WebPart class [8a860dca-4061-d270-a67b-f6bde7fc3e0a] is referenced [81] times in the database [wss_Content], but is not installed on the current farm. 
*/
AND (
	--WebParts.tp_Assembly LIKE '%00e293235734db6b%' -- many times this field is NULL, if it has a value, its the PublicKeyToken of the assembly found in web.config (example data: aRTEWebPart, Version=1.0.0.0, Culture=neutral, PublicKeyToken=79a02695d35014e8)
	-- WebParts.tp_Class LIKE '%NICHDWWW.FOA.AllRelatedFOAs.AllRelatedFOAs%' -- many times this field is NULL, if it has a value, its the Namespace of the assembly found in web.config (example data: aRTE.SharePoint.WebControls)
WebParts.tp_Class LIKE '%NICHDWWW.Webparts.Infant.Events%'  OR 
WebParts.tp_Class LIKE '%NICHDWWW.SiteSearch%'  OR 
WebParts.tp_Class LIKE '%NICHDWWW.A2ZTopics%'  OR 
WebParts.tp_Class LIKE '%NICHDWWW.News%'  OR 
WebParts.tp_Class LIKE '%NICHDWWW.Meetings%'  OR 
WebParts.tp_Class LIKE '%NICHDWWW.GenericList%'  OR 
WebParts.tp_Class LIKE '%NichdWWW.External%'  OR 
WebParts.tp_Class LIKE '%NICHDWWW.A2ZTopics%'  OR 
WebParts.tp_Assembly LIKE '%6ee342a9d09403c2%' OR 
WebParts.tp_Assembly LIKE '%053be8d0e5ce4ad1%' OR 
WebParts.tp_Assembly LIKE '%0e83db6fa34953e4%' OR 
WebParts.tp_Assembly LIKE '%053be8d0e5ce4ad1%' OR 
WebParts.tp_Assembly LIKE '%226e15408b722182%' OR 
WebParts.tp_Assembly LIKE '%68c795106150f2be%' OR 
WebParts.tp_Assembly LIKE '%fcd1924a49186a31%' OR 
WebParts.tp_Assembly LIKE '%1f7e4affd80f4655%' 

)
--AND Docs.DirName + '/' + Docs.LeafName = 'grants-funding/opportunities-mechanisms/active-foa/Pages/default.aspx'
--AND tp_zoneID = 'CenterRightColumn' 	-- other webpart zones: CenterRightColumnTopID
/* 
	to get the spelling of the zoneID, add a webpart to the zone of interest on a particular page and run this query without any WebParts where clause 
	so far, the ncs site uses: 
	CenterColumn, CenterRightColumn, Footer
*/
ORDER BY thepage
