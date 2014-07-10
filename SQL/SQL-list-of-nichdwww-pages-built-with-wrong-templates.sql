/***** SQL-list-of-nichdwww-pages-built-with-wrong-templates.sql ****/
SELECT 
REPLACE('/' + docs.dirName, '/pages', '/') AS subsite, 
'http://stagingwww2012.nichd.nih.gov/' + docs.dirName + '/' + docs.LeafName AS thepage, 
REPLACE(nvarchar14, '/_catalogs/masterpage/', '') AS pagelayout_url
FROM DOCS, UserData UD, Lists L ---- , UserInfo {CANNOT SEEM TO JOIN WITH "UserInfo" TABLE SINCE THE IDs donot seem to match}
WHERE ud.tp_ListID = L.tp_ID 
--and ud.tp_editor = UserInfo.tp_id
/* added join to "docs" table for sp2010 */
and docs.ListId = l.tp_ID
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
and docs.Extension in ('aspx')
--and docs.LeafName in ('index.aspx', 'default.aspx')
/*** list of all research info pages built with wrong template ********/
/*
and UD.nvarchar14 != '/_catalogs/masterpage/NICHD-AZTopicsResearchPage-Template.aspx'
and docs.dirName not like '%_catalogs%'
and '/' + docs.dirName like '/health/topics/%researchinfo%'
*/
/***** list of all NON-researchinfo pages built with wrong template ***********/
/*
and UD.nvarchar14 != '/_catalogs/masterpage/NICHD-AZTopicsPage-Template.aspx'
and docs.dirName not like '%_catalogs%'
and '/' + docs.dirName != '/health/topics/pages'
and '/' + docs.dirName like '/health/topics/%'
and '/' + docs.dirName NOT like '/health/topics/%researchinfo%'
*/
/***** list of extramural org unit pages built with wrong template ***********/
/*
and UD.nvarchar14 != '/_catalogs/masterpage/NICHD-OrgUnitPage-Extra-Template.aspx'
and docs.dirName not like '%_catalogs%'
and '/' + docs.dirName != '/about/org/pages'
and '/' + docs.dirName != '/about/org/orgchart/pages'
and '/' + docs.dirName like '/about/org/%'
and '/' + docs.dirName not like '/about/org/dir/%'
*/
/***** list of intramural org unit pages built with wrong template ***********/
and UD.nvarchar14 != '/_catalogs/masterpage/NICHD-OrgUnitPage-Intra-Template.aspx'
and docs.dirName not like '%_catalogs%'
and '/' + docs.dirName like '/about/org/dir/%'

order by subsite, thepage

