---------------------------------------------------------------
------- query to find all pages with links into archive
---------------------------------------------------------------
select distinct L.TargetDirname + '/' + L.TargetLeafName AS the_link
from links L, Docs D
where L.DocId = D.Id
AND d.IsCurrentVersion = 1
AND 
(
	L.TargetDirName like 'archive%%' 
)
AND D.DirName NOT like '%archive%'
AND D.DirName NOT like '%copybin%'
AND D.DirName NOT like 'Quick Deploy Items%'
order by the_link

