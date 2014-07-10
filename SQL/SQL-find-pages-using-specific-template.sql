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
and UD.nvarchar14 != '/_catalogs/masterpage/NICHD-AZTopicsResearchPage-Template.aspx'
and docs.dirName not like '%_catalogs%'
and '/' + docs.dirName like '/health/topics/%researchinfo%'
order by subsite, thepage

