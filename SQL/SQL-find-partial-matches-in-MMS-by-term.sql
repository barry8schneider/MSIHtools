---------------------------------------------------------------
------– Looping through the MMS to find partial matches for each item
---------------------------------------------------------------
--use [NICHDspe01_Metadata]
--use [NICHDspe02_Metadata]
SET NOCOUNT ON

DECLARE
@label varchar(255),
@safelabel varchar(255)



DECLARE Table_Cursor CURSOR FOR 
	select tl.Label, REPLACE(tl.Label, '''', '''''') AS safe_label
	from ECMTermSet ts, ECMTermSetMembership tsm, ECMTermLabel tl
	where ts.Name = '1033|A-Z Topics' -- '1033|A-Z Topics' or '1033|Org Units'
	and ts.Id = tsm.TermSetId
	and tsm.AvailableForTagging = 1
	and tsm.TermId = tl.TermId
	and tl.IsDefault = 1 --- for AZtopics, these records are where the URL is different than the name
	--and tl.Label like '%''%'
	order by tl.Label

OPEN Table_Cursor FETCH NEXT FROM  Table_Cursor INTO @label,@safelabel
WHILE(@@FETCH_STATUS=0) 
BEGIN 

exec(
	'SELECT ''' + @safelabel + ''' AS the_term, COUNT(*) AS thecount 
	FROM ECMTermSet ts, ECMTermSetMembership tsm, ECMTermLabel tl 
	where ts.Name = ''1033|A-Z Topics'' -- ''1033|A-Z Topics'' or ''1033|Org Units''
	and ts.Id = tsm.TermSetId 
	and tsm.TermId = tl.TermId 
	and tl.IsDefault = 1 
	AND tl.Label LIKE ''%' + @safelabel + '%'' 
	AND tl.Label != ''' + @safelabel + ''' 
	HAVING COUNT(*) > 0
	'
	)

FETCH NEXT FROM  Table_Cursor INTO @label,@safelabel
END 
CLOSE Table_Cursor 
DEALLOCATE Table_Cursor
