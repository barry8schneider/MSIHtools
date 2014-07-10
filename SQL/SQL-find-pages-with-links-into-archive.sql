---------------------------------------------------------------
------- query to find all pages with links into archive
---------------------------------------------------------------
select L.TargetDirName, L.TargetLeafName, L.Type, D.DirName + '/' + D.LeafName AS the_page_with_the_link
from links L, Docs D
where L.DocId = D.Id
and d.IsCurrentVersion = 1
AND 
(
	L.TargetDirName like '%archive%' 
)
-- if you only want to look at images:
--and L.TargetDirName like '%images'
AND D.DirName NOT like '%archive%'
AND D.DirName NOT like '%copybin%'
AND D.DirName NOT like 'Quick Deploy Items%'
AND L.TargetDirName NOT like 'http%'
order by the_page_with_the_link

---------------------------------------------------------------
------- referring links SP2010 (similar query as above , but a little different scenario)
------- looking for pages in archive links pointing to pages outside of archive
---------------------------------------------------------------
select 
--L.TargetDirName, COUNT(*) as thecount
'/' + D.DirName + '/' + D.LeafName AS the_page_with_the_link, 
'/' + L.TargetDirName + '/' + L.TargetLeafName AS targetpage, L.Type, L.TargetDirName, L.TargetLeafName
from links L with (nolock), Docs D with (nolock)
where L.DocId = D.Id
and d.IsCurrentVersion = 1
-- looking only at pages under archive with links on it 
AND D.DirName + '/' LIKE 'archive/%'
-- whose links point to pages outside of archive
AND '/' + L.TargetDirName + '/' NOT LIKE '/archive/%' 
-- if you only want to look at images:
--and L.TargetDirName like '%images'
-- we don't care about 'mailto:', external or master page links
AND L.TargetDirName NOT LIKE 'mailto:%'
AND L.TargetDirName NOT LIKE 'http%'
AND L.TargetDirName NOT LIKE '_catalogs/masterpage%'
AND L.TargetDirName NOT LIKE '~masterurl/custom.master%'
AND L.TargetDirName NOT LIKE '~TemplatePageUrl%'
order by the_page_with_the_link
