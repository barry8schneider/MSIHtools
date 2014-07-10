DECLARE @SELECT_string varchar(50)
DECLARE @SELECT_string2  varchar(50)
SELECT @SELECT_string = 'CP_' 
select @SELECT_string2 = '.cfm'

select 
Replace('/' + webs.FullUrl + '/', '//', '/') AS subsite,
'/' + docs.dirName + '/' + docs.LeafName AS thepage,
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
UD.tp_Modified, UD.nvarchar1 AS modifiedBy, 
UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate, 
UD.nvarchar7 AS the_title
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID	AND UserInfo.tp_SiteID = ud.tp_SiteId
where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
and docs.Extension in ('aspx')
AND '/' + docs.dirName not like '/archive/%'
-- and docs.leafname = 'default.aspx'
----- ALL TEXT FIELDS WHERE CONTENT CAN BE
AND 
(
	UD.ntext6 LIKE '%' + @SELECT_string + '%' -- body content (REMEMBER that content can be found in some of the other columns ntext's OR nvarchar's)
	and 
	ud.ntext6 like '%' + @SELECT_string2 + '%'
)
ORDER BY subsite, thepage
;