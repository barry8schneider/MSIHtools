/*
SQL-all-aztopics-landingpages-with-Page-titles-and-Site-titles.sql
*/

SELECT 
webs.Title as sitename, 
UD.nvarchar7 AS pagetitle,
webs.FullUrl,
Replace('/' + lower(webs.FullUrl) + '/', '//', '/') AS thesubsite,
docs.DirName + '/' + docs.LeafName as thepage,
UD.tp_ModerationStatus, -- 0: checked in and published; 3: "checked out" or "draft"; 2: checked in and ready for approval
status_label = (CASE 
	WHEN UD.tp_ModerationStatus = 0 THEN 'checked in and published'
	WHEN UD.tp_ModerationStatus = 1 THEN 'not sure what status=1 is'
	WHEN UD.tp_ModerationStatus = 2 THEN 'checked in and ready for approval'
	WHEN UD.tp_ModerationStatus = 3 THEN 'checked out or draft'
	ELSE
	''
	END
)
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
AND webs.FullUrl != 'health/topics' 
AND docs.DirName LIKE 'health/topics/%' 
AND docs.DirName not like '%/clinicaltrials%'
AND docs.DirName not like '%/conditioninfo%'
AND docs.DirName not like '%/researchinfo%'
AND docs.DirName not like '%/resources%'
and docs.LeafName = 'default.aspx' -- we want just the landing page
-- this is the full list of all topicurls from oracle inter_ndata_sp.aztopics where isavailablefortagging=1
and replace(webs.FullUrl, 'health/topics/', '') in (

	--- get the aztopics with url's different than name isdefault=0 records
	select tl.Label
	from [NICHDspe01_Metadata].dbo.ecmtermset ts with (nolock), [NICHDspe01_Metadata].dbo.ECMTermSetMembership tsm with (nolock), [NICHDspe01_Metadata].dbo.ECMTermLabel tl with (nolock)
	where ts.Name = '1033|A-Z Topics' -- '1033|A-Z Topics' or '1033|Org Units'
	and ts.Id = tsm.TermSetId
	and tsm.AvailableForTagging = 1
	and tsm.TermId = tl.TermId
	and tl.IsDefault = 0 --- for AZtopics, these records are where the URL is different than the name
	union
	---- get just the isdefault=1 that don't items that don't have isdefault=0 records
	select tl.Label
	from [NICHDspe01_Metadata].dbo.ecmtermset ts with (nolock), [NICHDspe01_Metadata].dbo.ECMTermSetMembership tsm with (nolock), [NICHDspe01_Metadata].dbo.ECMTermLabel tl with (nolock)
	where ts.Name = '1033|A-Z Topics' -- '1033|A-Z Topics' or '1033|Org Units'
	and ts.Id = tsm.TermSetId
	and tsm.AvailableForTagging = 1
	and tsm.TermId = tl.TermId
	and tl.TermId in (
		select tl.TermId from [NICHDspe01_Metadata].dbo.ECMTermLabel tl with (nolock) group by tl.TermId having COUNT(*) < 2
	)
)
-------- get list where pagetitle and aztopicname are different
/*
and Replace(ud.nvarchar7, ' overview', '') NOT in ( 
	select tl.Label
	from [NICHDspe01_Metadata].dbo.ecmtermset ts with (nolock), [NICHDspe01_Metadata].dbo.ECMTermSetMembership tsm with (nolock), [NICHDspe01_Metadata].dbo.ECMTermLabel tl with (nolock)
	where ts.Name = '1033|A-Z Topics' -- '1033|A-Z Topics' or '1033|Org Units'
	and ts.Id = tsm.TermSetId
	and tsm.AvailableForTagging = 1
	and tsm.TermId = tl.TermId
	and tl.IsDefault = 1 --- for AZtopics, these records are where the URL is different than the name
)
*/
------- get list where sitename and aztopicname are different
/*
and webs.title NOT in (
	--- get list of all aztopicnames (these are the IsDefault=1 records)
	select tl.Label
	from [NICHDspe01_Metadata].dbo.ecmtermset ts with (nolock), [NICHDspe01_Metadata].dbo.ECMTermSetMembership tsm with (nolock), [NICHDspe01_Metadata].dbo.ECMTermLabel tl with (nolock)
	where ts.Name = '1033|A-Z Topics' -- '1033|A-Z Topics' or '1033|Org Units'
	and ts.Id = tsm.TermSetId
	and tsm.AvailableForTagging = 1
	and tsm.TermId = tl.TermId
	and tl.IsDefault = 1 --- for AZtopics, these records are where the URL is different than the name
) 
*/
ORDER BY thesubsite, thepage

