/*
All pages not published
*/
select 
Replace('/' + webs.FullUrl + '/', '//', '/') AS subsite,
--'/' + docs.dirName + '/' + docs.LeafName AS thepage,
CASE 	
	-- /ReusableContent/DispForm.aspx?ID=70
	WHEN docs.DirName LIKE 'ReusableContent%' THEN '/ReusableContent/DispForm.aspx?ID=' + convert(varchar, docs.doclibRowId)
	ELSE '/' + docs.dirName + '/' + docs.LeafName 
 END
 AS thepage,
--docs.DirName,
Replace(UD.nvarchar14, '/_catalogs/masterpage/', '') as thetemplate,
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
UD.tp_Modified, 
-- ReusableContent: just set the modifiedBy to who has checked out the item
CASE 	
	-- /ReusableContent/DispForm.aspx?ID=70
	WHEN docs.DirName LIKE 'ReusableContent%' THEN UserInfo2.tp_Login
	ELSE UD.nvarchar1 
END AS modifiedBy, 

UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate, 
CASE 	
	-- ReusableContent
	WHEN docs.DirName LIKE 'ReusableContent%' THEN UD.nvarchar1
	ELSE UD.nvarchar7
END AS the_title
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID AND UserInfo.tp_SiteID = ud.tp_SiteId
LEFT JOIN UserInfo UserInfo2 with (nolock) ON UserInfo2.tp_ID = ud.tp_editor AND UserInfo2.tp_SiteID = ud.tp_SiteId
where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
AND '/' + docs.dirName not like '/archive/%'
AND '/' + docs.dirName not like '/0_copybin/%'
AND '/' + docs.dirname NOT LIKE '%/StaffProfiles%'
AND '/' + docs.dirName not like '/navxmlsite/%'
AND '/' + docs.dirName not like '/pwsadmin/%'
--AND docs.DirName LIKE 'ReusableContent%'
AND UD.tp_ModerationStatus != 0
--AND docs.UIVersionString LIKE '0.%' --- this is a page that has never been published and will produce an NT prompt

ORDER BY subsite, thepage
;