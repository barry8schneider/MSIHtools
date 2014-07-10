select 
Replace('/' + webs.FullUrl + '/', '//', '/') AS subsite,
CASE 	
	-- /ReusableContent/DispForm.aspx?ID=70
	WHEN docs.DirName LIKE 'ReusableContent%' THEN '/ReusableContent/DispForm.aspx?ID=' + convert(varchar, docs.doclibRowId)
	-- /Lists/staffprofiles/DispForm.aspx?ID=
	WHEN docs.DirName LIKE 'Lists/staffprofiles%' THEN '/Lists/staffprofiles/DispForm.aspx?ID=' + convert(varchar, docs.doclibRowId)
	ELSE '/' + docs.dirName + '/' + docs.LeafName 
 END
 AS thepage,
UD.nvarchar7 AS the_title,
docs.Size/1024 AS FileSize_InKB,
docs.UIVersionString, 
UD.tp_iscurrent, 
UD.tp_ModerationStatus, -- 0: checked in and published; 3: "checked out" or "draft"; 2: checked in and ready for approval
status_label = (CASE 
	WHEN UD.tp_ModerationStatus = 0 THEN 'checked in and published'
	WHEN UD.tp_ModerationStatus = 1 THEN 'not sure what status=1 is'
	WHEN UD.tp_ModerationStatus = 2 THEN 'checked in and ready for approval'
	WHEN UD.tp_ModerationStatus = 3 THEN 'checked out or draft'
	ELSE
	''
	END
), 	
UD.tp_Created, UD.nvarchar2 AS createdBy, 
UD.tp_Modified, UD.nvarchar1 AS modifiedBy, 
UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID	AND UserInfo.tp_SiteID = ud.tp_SiteId
where docs.ListId = l.tp_ID 
AND Docs.WebId = Webs.Id 
and docs.Id = ud.tp_DocId 
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1 
and docs.Level = ud.tp_level 
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
-- and docs.Extension in ('aspx', 'pdf')
and docs.Extension in ('pdf')
--AND '/' + docs.dirName not like '/archive/%'
/*
AND '/' + docs.dirName + '/' + docs.LeafName in (
'/about/Documents/2013-04-08_All_Consent_SUPPORT.pdf',
'/about/Documents/Systemic_Hypothermia_Protocol.pdf'
)
*/
-- and docs.leafname = 'default.aspx'
ORDER BY subsite, thepage
;