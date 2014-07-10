DECLARE
@SELECT_string varchar(50)
SELECT @SELECT_string = '0_copybin/espanol/investigaciones'

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
 docs.DirName,
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
AND Docs.DirName NOT LIKE '%Quick Deploy Items%'
AND Docs.DirName NOT LIKE '%archive/%'
-- and docs.Extension in ('aspx', 'pdf')
--AND '/' + docs.dirName not like '/archive/%'
-- and docs.leafname = 'default.aspx'
----- ALL TEXT FIELDS WHERE CONTENT CAN BE
AND 
(
	UD.ntext1 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext2 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext3 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext4 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext5 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext6 LIKE '%' + @SELECT_string + '%' -- body content (REMEMBER that content can be found in some of the other columns ntext's OR nvarchar's)
	or UD.ntext7 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext8 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext9 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext10 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext11 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext12 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext13 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext14 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext15 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext16 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext17 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext18 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext19 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext20 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext21 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext22 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext23 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext24 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext25 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext26 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext27 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext28 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext29 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext30 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext31 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext32 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar1 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar2 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar3 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar4 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar5 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar6 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar7 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar8 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar9 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar10 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar11 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar12 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar13 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar14 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar15 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar16 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar17 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar18 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar19 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar20 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar21 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar22 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar23 LIKE '%' + @SELECT_string + '%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	or UD.nvarchar24 LIKE '%' + @SELECT_string + '%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	or UD.nvarchar25 LIKE '%' + @SELECT_string + '%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	or UD.nvarchar26 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar27 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar28 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar29 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar30 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar31 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar32 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar33 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar34 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar35 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar36 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar37 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar38 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar39 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar40 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar41 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar42 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar43 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar44 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar45 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar46 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar47 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar48 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar49 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar50 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar51 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar52 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar53 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar54 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar55 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar56 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar57 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar58 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar59 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar60 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar61 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar62 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar63 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar64 LIKE '%' + @SELECT_string + '%' 
)
ORDER BY subsite, thepage
;