--/florida/About/faqs/WorkflowHistory/
select 
Replace('/' + webs.FullUrl + '/', '//', '/') AS subsite,
'/' + docs.dirName + '/' + docs.LeafName AS thepage,
docs.UIVersionString,
docs.TimeLastModified,
docs.Extension
FROM docs with (nolock), webs with (nolock), Lists L with (nolock)
where docs.ListId = l.tp_ID
AND docs.WebId = Webs.Id
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
AND '/' + docs.dirName like '/florida/About/faqs/WorkflowHistory%'
and docs.Extension like '%0%'
order by TimeLastModified
;