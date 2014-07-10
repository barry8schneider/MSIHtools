/*** from NWR-1178 ***********/
----------- List of all sites in SharePoint under /about/org/ --------------- 
SELECT distinct 
Replace('/' + lower(webs.FullUrl) + '/', '//', '/') AS thesubsite 
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock) 
where docs.ListId = l.tp_ID 
AND Docs.WebId = Webs.Id 
and docs.Id = ud.tp_DocId 
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back... 
--and docs.IsCurrentVersion = 1 
and docs.Level = ud.tp_level 
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed 
and '/' + webs.FullUrl + '/' ! = '/about/org/' 
and '/' + webs.FullUrl + '/' LIKE '/about/org/%' 
ORDER BY thesubsite 
;


---- Using the above list, created a temp table named "temp_1(internet_home_url)" and inserted all subsite urls into it. 

----Then ran the following query in Oracle: 
/*
----- to see if any are in ref_org but not in sharepoint --------
select ref_org.nihsac, ref_org.nihouname, ref_org.nihouacronym, ref_org.internet_home_url
from ref_org
Where Ref_Org.Internet_Home_Url Is Not Null 
--and Lower(Ref_Org.Internet_Home_Url) Like '%osd/mt%'
And Lower(Ref_Org.Internet_Home_Url) NOT In (
select lower(internet_home_url) from temp_1
)
; 
----- to get a listing of all subsites in ref_org and if they're built in sharepoint or not --------
select ref_org.nihsac, ref_org.nihouname, ref_org.nihouacronym, ref_org.internet_home_url, decode(temp_1.internet_home_url, NULL, 'N', 'Y') as IsSiteBuilt, count(vnp.nihid) as HasStaff 
from ref_org, temp_1, vw_ned_person_sharepoint vnp 
where ref_org.internet_home_url is not null 
and ref_org.internet_home_url = temp_1.internet_home_url (+) 
and ref_org.nihsac = vnp.orgunitcode (+) 
group by ref_org.nihsac, ref_org.nihouname, ref_org.nihouacronym, ref_org.internet_home_url, decode(temp_1.internet_home_url, NULL, 'N', 'Y') 
order by ref_org.nihsac, ref_org.nihouname, ref_org.nihouacronym, ref_org.internet_home_url, decode(temp_1.internet_home_url, NULL, 'N', 'Y') 
; 
*/