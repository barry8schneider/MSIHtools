select fullurl
from Webs
where ParentWebId = (
	-- this is the root site collection web
	SELECT Webs.Id 
	FROM Webs 
	WHERE (Webs.ParentWebId IS NULL)
)
order by fullurl