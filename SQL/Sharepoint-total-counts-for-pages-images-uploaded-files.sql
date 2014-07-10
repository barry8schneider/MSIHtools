--use [NICHDSPE02-NationalChildrensStudy-Content1]
select 
--docs.UIVersionString, 
--docs.dirname, 
--DOCS.Extension,  
COUNT(docs.Id) AS thecount
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID	AND UserInfo.tp_SiteID = ud.tp_SiteId
where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
	AND (
			( docs.dirname like '%/Documents' 
			)
			or ( docs.dirname like '%/Pages' 
			)
			or (
			docs.dirname like '%Images%' 
			)
	)

/*** webpages only ***/
--and docs.Extension in ('aspx')
/*** images only ***/
--and docs.Extension in ('eps', 'gif', 'jpeg', 'jpg', 'png', 'tiff')
/*** uploaded files only ***/
--and docs.Extension in ('doc', 'docx', 'pdf', 'ppt', 'pptx', 'svg', 'swf', 'wk4', 'wmv', 'xls', 'xlsx')
/*** images and uploaded files ***/
--and docs.Extension in ('eps', 'gif', 'jpeg', 'jpg', 'png', 'tiff','doc', 'docx', 'pdf', 'ppt', 'pptx', 'svg', 'swf', 'wk4', 'wmv', 'xls', 'xlsx')
/*** webpages, images and uploaded files ***/
--and docs.Extension in ('aspx','eps', 'gif', 'jpeg', 'jpg', 'png', 'tiff','doc', 'docx', 'pdf', 'ppt', 'pptx', 'svg', 'swf', 'wk4', 'wmv', 'xls', 'xlsx')

AND docs.dirName not like 'archived/%'
AND docs.dirName not like 'archive/%'
AND docs.dirName not like '0_copybin%'
AND docs.DirName not like 'Style Library/%'
--and docs.dirname like '%/Pages' 
-- and docs.leafname = 'default.aspx'
--AND webs.FullUrl not like '%projects%' ---- I donnot want the master page / templates listed 
--AND webs.FullUrl not like '%branches%' ---- I donnot want the master page / templates listed 
--AND webs.FullUrl NOT like '%clearancetracking%' ---- I donnot want the master page / templates listed 
--AND webs.FullUrl NOT like '%k2admin%' ---- I donnot want the master page / templates listed 
--AND webs.FullUrl not like '%sites%' ---- I donnot want the master page / templates listed 
--and webs.FullUrl = 'projects/recordsmanagement/der/cdbb' 
AND docs.dirname not like ('%catalogs/%')
--and UD.tp_Modified > '2013'

--GROUP BY 
--docs.dirname
--docs.UIVersionString, 
--DOCS.Extension
--ORDER BY 
--docs.dirname
--docs.UIVersionString, 
--DOCS.Extension
;