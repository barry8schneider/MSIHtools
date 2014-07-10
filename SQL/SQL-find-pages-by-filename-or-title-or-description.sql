------------------------------------------------------------
-- List of all aspx pages under the "storz" subsite: 
------------------------------------------------------------
SELECT '/' + replace(Docs.DirName, '/pages', '/') as thesubsite, docs.DirName + '/' + docs.LeafName as thepage
FROM Docs 
WHERE Docs.IsCurrentVersion = 1 
AND docs.DirName = 'about/org/dir/cbmp/storz/pages' 
and docs.Extension = 'aspx'
ORDER BY thesubsite
---NICHD-NewsPage-Template.aspx
;

------------------------------------------------------------
-- list of all pages with "overview" as their title
-- or with 'Division of Intramural Research (DIR)' as it's description
------------------------------------------------------------
SELECT 
Replace('/' + webs.FullUrl + '/', '//', '/') AS thesubsite,
docs.DirName + '/' + docs.LeafName as thepage,
UD.nvarchar7 AS the_title,
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
ud.ntext2 AS the_description
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND UD.nvarchar7 = 'overview'
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
AND docs.DirName LIKE 'health/topics/%' 
and docs.Extension = 'aspx'
--and ud.ntext2 = 'Division of Intramural Research (DIR)'
ORDER BY thesubsite, thepage

