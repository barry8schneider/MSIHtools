--- other queries can be found on: http://www.codeproject.com/kb/dotnet/QueriesToAnalyzeSPUsage.aspx [these are for moss2007]

---------------------------------------------------------------
------- list of all tables 
---------------------------------------------------------------
SELECT *
FROM INFORMATION_SCHEMA.tables
ORDER BY table_name

---------------------------------------------------------------
------- list of all columns in a table
---------------------------------------------------------------
SELECT table_name, column_name, data_type, character_maximum_length
FROM INFORMATION_SCHEMA.columns
WHERE COLUMN_NAME like '%moderation%'
ORDER BY table_name, column_name


---------------------------------------------------------------
------- referring links moss2007
---------------------------------------------------------------
select L.TargetDirName, L.TargetLeafName, '/' + dirName + '/' + LeafName AS the_page_with_the_link
from links L with (nolock)
where 
(
	'/' + L.TargetDirName + '/' + L.TargetLeafName IN
		(
		'/about/organization/advisorycommittee/2004Mar/Pages/Scheidt-March-2004-Presentation.pdf',
		'/about/organization/advisorycommittee/Pages/1st_trimester_v2.pdf'
		)
	-------- if there's a link or image to an external site, then the TargetDirName field is the entire url beginning with "http://" and ending with the filename, therefore, the TargetLeafName field will be blank
	OR L.TargetDirName like '%.pdf%' 
)
order by L.TargetDirName, L.TargetLeafName

---------------------------------------------------------------
------- referring links moss2007 another sample query
---------------------------------------------------------------
select L.TargetDirName, L.TargetLeafName, '/' + dirName + '/' + LeafName AS the_page_with_the_link
from links L with (nolock)
where 
(
L.TargetLeafName LIKE '%Adjunct-Studies-4-13-10.pdf%'
OR L.TargetLeafName LIKE '%NCS-Study-Scholars-Program-Application.pdf%'
OR L.TargetLeafName LIKE '%Steering-Committee-7-14-09.pdf%'
OR L.TargetLeafName LIKE '%2008-NCS-Study-Centers.pdf%'
-------- if there's a link or image to an external site, then the TargetDirName field will be used
OR L.TargetDirName LIKE '%Adjunct-Studies-4-13-10.pdf%'
OR L.TargetDirName LIKE '%NCS-Study-Scholars-Program-Application.pdf%'
OR L.TargetDirName LIKE '%Steering-Committee-7-14-09.pdf%'
OR L.TargetDirName LIKE '%2008-NCS-Study-Centers.pdf%'
)
order by L.TargetDirName, L.TargetLeafName

---------------------------------------------------------------
------- referring links SP2010
---------------------------------------------------------------
select L.TargetDirName, L.TargetLeafName, L.Type, D.DirName + '/' + D.LeafName AS the_page_with_the_link
from links L with (nolock), Docs D with (nolock)
where L.DocId = D.Id
AND 
(
	L.TargetLeafName like '%help.aspx%' 
	OR '/' + L.TargetDirName + '/' + L.TargetLeafName IN
		(
		'/about/organization/advisorycommittee/2004Mar/Pages/Scheidt-March-2004-Presentation.pdf',
		'/about/organization/advisorycommittee/Pages/1st_trimester_v2.pdf'
		)
	-------- if there is a link or image to an external site, then the TargetDirName field is the entire url beginning with "http://" and ending with the filename, therefore, the TargetLeafName field will be blank
	OR L.TargetDirName like '%.pdf%' 
)
order by TargetDirName, TargetLeafName

---------------------------------------------------------------
------- referring links SP2010 (similar query as above , but a little different scenario)
------- looking for pages outside a specific subsite with links to pages in a specific subsite
---------------------------------------------------------------
select 
'/' + D.DirName + '/' + D.LeafName AS the_page_with_the_link, 
'/' + L.TargetDirName + '/' + L.TargetLeafName AS targetpage, L.Type
from links L with (nolock), Docs D with (nolock)
where L.DocId = D.Id
AND 
(
	-- looking for links to the following target
	'/' + L.TargetDirName + '/' LIKE '/funding/foa%'
)
-- looking for pages with the link on it that is not under a specific subsite
AND '/' + D.DirName + '/' NOT LIKE '/funding/%'
order by the_page_with_the_link

-----------------------------------------------------------------
------- finding pages with links to items in a library that do not exist
---------------------------------------------------------------
SELECT DISTINCT
	D.DirName + '/' + D.LeafName AS the_page_with_the_link, 
	'/' + L.TargetDirName + '/' + L.TargetLeafName  AS the_target_page
from links L with (nolock), Docs D with (nolock)
where L.DocId = D.Id
and D.IsCurrentVersion = 1
--and L.Level = 1 --- seems that the Links table duplicates some records...

-- this pulls out all pages that link to items in the top-level pages library
and '/' + L.TargetDirName + '/' + L.TargetLeafName LIKE '/pages/%'
-- this then looks for all links other than those that are actually in the top-level pages library
AND D.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
AND '/' + L.TargetDirName + '/' + L.TargetLeafName NOT IN
	(
		-- this pulls out all items that are actually in the top-level pages library
		select 
		'/' + docs.dirName + '/' + docs.LeafName AS thepage
		FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
		where docs.ListId = l.tp_ID
		AND Docs.WebId = Webs.Id
		AND webs.ParentWebId IS null 
		and docs.Id = ud.tp_DocId
		-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
		and docs.IsCurrentVersion = 1
		and docs.Level = ud.tp_level
		AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
		AND L.tp_Title = 'Pages' 
	)
order by the_page_with_the_link, the_target_page

---------------------------------------------------------------
------- finding content inside a page moss2007
---------------------------------------------------------------
DECLARE
@SELECT_string varchar(50)
SELECT @SELECT_string = 'workload/spworkload.aspx' 

select 
'/' + UD.tp_dirName + '/' + UD.tp_LeafName AS thepage, 
UD.tp_id, UD.tp_version, UD.tp_UIVersionString, 
UD.nvarchar1, UD.tp_iscurrent, 
UD.tp_ModerationStatus, -- 0: checked in and published; 3: checked out; 2: checked in and ready for approval
UD.tp_Modified, UD.tp_Created, 
UD.tp_dirName, UD.tp_LeafName, UD.tp_ContentType, UD.nvarchar1 AS createdBy, UD.nvarchar2 AS modifiedBy, UD.nvarchar3 AS filetype,
UD.nvarchar7 AS the_titleA, UD.ntext2 AS the_description, UD.ntext6 AS bodycontent
/*** specific to ncs national and sc sites ***/
, UD.nvarchar20 AS NCSKeywords, datetime7 AS NCSStartDate, datetime5 AS NCSEndDate, datetime4 AS NCSEffectiveDate, datetime6 AS NCSReviewedDate, datetime8 AS NCSUpdateDate
from UserData UD, Lists L ---- , UserInfo {CANNOT SEEM TO JOIN WITH "UserInfo" TABLE SINCE THE Ids donot seem to match}
where ud.tp_ListID = L.tp_ID 
--and ud.tp_editor = UserInfo.tp_id
and L.tp_Title = 'Pages'
--and ud.tp_dirname = 'about/Pages'
--and ud.tp_leafname = 'default.aspx'
and 
(
	UD.ntext1 like '%' + @SELECT_string + '%' 
	or UD.ntext2 like '%' + @SELECT_string + '%' 
	or UD.ntext3 like '%' + @SELECT_string + '%' 
	or ud.ntext4 like '%' + @SELECT_string + '%' 
	or ud.ntext5 like '%' + @SELECT_string + '%' 
	or UD.ntext6 like '%' + @SELECT_string + '%' -- body content (REMEMBER that content can be found in some of the other columns ntext1 - ntext30)
	or UD.ntext7 like '%' + @SELECT_string + '%' 
	or ud.ntext8 like '%' + @SELECT_string + '%' 
	or ud.ntext9 like '%' + @SELECT_string + '%' 
	or UD.ntext10 like '%' + @SELECT_string + '%' 
	or UD.ntext11 like '%' + @SELECT_string + '%' 
	or UD.ntext12 like '%' + @SELECT_string + '%' 
	or ud.ntext13 like '%' + @SELECT_string + '%' 
	or ud.ntext14 like '%' + @SELECT_string + '%' 
	or UD.ntext15 like '%' + @SELECT_string + '%' 
	or UD.ntext16 like '%' + @SELECT_string + '%' 
	or UD.ntext17 like '%' + @SELECT_string + '%' 
	or ud.ntext18 like '%' + @SELECT_string + '%' 
	or ud.ntext19 like '%' + @SELECT_string + '%' 
	or UD.ntext20 like '%' + @SELECT_string + '%' 
	or UD.ntext21 like '%' + @SELECT_string + '%' 
	or UD.ntext22 like '%' + @SELECT_string + '%' 
	or ud.ntext23 like '%' + @SELECT_string + '%' 
	or ud.ntext24 like '%' + @SELECT_string + '%' 
	or UD.ntext25 like '%' + @SELECT_string + '%' 
	or UD.ntext26 like '%' + @SELECT_string + '%' 
	or UD.ntext27 like '%' + @SELECT_string + '%' 
	or ud.ntext28 like '%' + @SELECT_string + '%' 
	or ud.ntext29 like '%' + @SELECT_string + '%' 
	or ud.ntext30 like '%' + @SELECT_string + '%' 
)

ORDER BY thepage


---------------------------------------------------------------
------- finding content inside a page sp2010
---------------------------------------------------------------
DECLARE
@SELECT_string varchar(50)
SELECT @SELECT_string = 'workload/spworkload.aspx' 

select 
'/' + webs.FullUrl + '/' AS subsite,
L.tp_Title AS libraryname, 
docs.LeafName, 
'/' + docs.dirName + '/' + docs.LeafName AS thepage,
docs.LeafName, docs.Type, docs.Extension, docs.ExtensionForFile, 
UD.nvarchar1,
docs.id, docs.UIVersionString, 
UD.tp_iscurrent, 
UD.tp_ModerationStatus, -- 0: checked in and published; 3: "checked out" or "draft"; 2: checked in and ready for approval
UD.tp_Modified, UD.tp_Created, 
UD.nvarchar2 AS createdBy, 
UD.nvarchar1 AS modifiedBy, 
UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate, docs.CheckoutExpires,
UD.nvarchar3 AS filetype,
UD.nvarchar7 AS the_title, UD.ntext2 AS the_description, UD.ntext6 AS bodycontent
/*** specific to ncs national and sc sites ***/
--, UD.nvarchar20 AS NCSKeywords, datetime7 AS NCSStartDate, datetime5 AS NCSEndDate, datetime4 AS NCSEffectiveDate, datetime6 AS NCSReviewedDate, datetime8 AS NCSUpdateDate
/**** specific to NICHDWWW site *****/
/*
	---- my original analysis -----
	UD.nvarchar24 AS MigrationSourceURL, UD.nvarchar15 AS template_filename, UD.ntext11 AS NICHDNotes, 
	UD.datetime6 AS NICHDEffectiveDate, UD.datetime4 AS NICHDReviewDate, UD.datetime5 AS NICHDUpdateDate, 
	UD.nvarchar20 AS NICHDShowLeftNav, UD.nvarchar21 AS NICHDShowUpdatedReviewedDates, 
	UD.nvarchar22 AS NICHDShowLeftNavNavigation, UD.nvarchar23 AS NICHDPageID,

	--- reviewing /about/meetings/2001/ncmrr_bioengineering/documents/ ---
	UD.nvarchar19 AS NICHDShowLeftNav, 
	UD.nvarchar20 AS NICHDShowUpdatedReviewedDates, 
	UD.nvarchar21 AS NICHDShowLeftNavNavigation, 
	UD.nvarchar22 AS NICHDPageID,
	UD.nvarchar23 AS MigrationSourceURL,
	UD.datetime3 AS NICHDReviewDate,
	UD.datetime4 AS NICHDUpdateDate,
	UD.datetime5 AS NICHDEffectiveDate,
	UD.ntext5 AS NICHDNotes,
*/
/**** end specific to NICHDWWW site *****/
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID	AND UserInfo.tp_SiteID = ud.tp_SiteId
where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
--AND webs.ParentWebId IS NOT null --- ABSOLUTELY CRITICAL THAT THIS IS HERE (this does not seem to be the case anymore)
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND Docs.DirName NOT like '%_catalogs/%' ---- I donnot want the master page / templates listed
-- and docs.Extension in ('aspx', 'pdf')
-- AND '/' + docs.dirName + '/' like '/about/meetings/2001/DBS_planning/%'
-- and docs.leafname = 'default.aspx'
--- NCS and Study Centers Sites Fields:
/*
and 
(
UD.ntext6 like '%map_NYNJ_mtsinai_only.jpg%'  -- body content (REMEMBER that content can be found in some of the other columns ntext1 - ntext30)
or UD.ntext15 like '%map_NYNJ_mtsinai_only.jpg%' -- contacts section
or UD.ntext16 like '%map_NYNJ_mtsinai_only.jpg%' -- spotlight section
or UD.ntext17 like '%map_NYNJ_mtsinai_only.jpg%' -- what's new
or ud.ntext18 like '%map_NYNJ_mtsinai_only.jpg%' -- right nav content1
or ud.ntext19 like '%map_NYNJ_mtsinai_only.jpg%' -- right nav content2
)
*/
--- NICHDWWW Specific Field:
--AND UD.ntext6 LIKE '%' + @SELECT_string + '%'   -- body content (REMEMBER that content can be found in some of the other columns ntext1 - ntext30)

----- ALL TEXT FIELDS WHERE CONTENT CAN BE
AND 
(
	UD.ntext1 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext2 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext3 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext4 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext5 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext6 LIKE '%' + @SELECT_string + '%' -- body content (REMEMBER that content can be found in some of the other columns ntext's OR nvarchar's)
	or UD.ntext7 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext8 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext9 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext10 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext11 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext12 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext13 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext14 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext15 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext16 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext17 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext18 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext19 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext20 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext21 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext22 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext23 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext24 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext25 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext26 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext27 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext28 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext29 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext30 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext31 LIKE '%' + @SELECT_string + '%' 
	or UD.ntext32 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar1 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar2 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar3 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar4 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar5 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar6 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar7 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar8 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar9 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar10 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar11 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar12 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar13 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar14 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar15 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar16 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar17 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar18 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar19 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar20 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar21 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar22 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar23 LIKE '%' + @SELECT_string + '%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	or UD.nvarchar24 LIKE '%' + @SELECT_string + '%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	or UD.nvarchar25 LIKE '%' + @SELECT_string + '%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	or UD.nvarchar26 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar27 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar28 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar29 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar30 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar31 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar32 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar33 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar34 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar35 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar36 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar37 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar38 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar39 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar40 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar41 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar42 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar43 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar44 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar45 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar46 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar47 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar48 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar49 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar50 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar51 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar52 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar53 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar54 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar55 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar56 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar57 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar58 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar59 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar60 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar61 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar62 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar63 LIKE '%' + @SELECT_string + '%' 
	or UD.nvarchar64 LIKE '%' + @SELECT_string + '%' 
)
ORDER BY thepage
;

---------------------------------------------------------------
------– ULTIMATE FISHING EXPEDITION 
------– WHEN YOU HAVE NO CLUE WHERE TO LOOK
------– ALL VERSIONS OF SHAREPOINT
---------------------------------------------------------------

SET NOCOUNT ON

DECLARE
@T varchar(255),
@C varchar(4000),
@SELECT_String varchar(50),
@sq varchar(2),
@emptyq varchar(5)
SELECT @SELECT_String = 'help.aspx' 

SELECT @sq = ''''
select @emptyq = @sq + @sq

DECLARE Table_Cursor CURSOR FOR 
	SELECT a.name, b.name
	FROM sysobjects a,syscolumns b
	WHERE a.id=b.id 
	AND a.xtype IN ('U', 'V') -- u=table; v=view
	/* a.xtype: 
		C = CHECK constraint; 
		D = Default or DEFAULT constraint; 
		F = FOREIGN KEY constraint; 
		fn = scalar-value function; 
		if = table-valued function; 
		it=don't know;
		L = Log 
		P = Stored procedure 
		PK = PRIMARY KEY constraint (type is K) 
		RF = Replication filter stored procedure 
		S = System table 
		sq = don't know
		tf = function; 
		TR = Trigger 
		U = User table 
		UQ = UNIQUE constraint (type is K) 
		V = View 
		X = Extended stored procedure 
	*/
	AND (
		--OR b.xtype=127	--	bigint
		--OR b.xtype=173	--	binary
		--OR b.xtype=104	--	bit
		b.xtype=175	--	char
		--OR b.xtype=61	--	datetime
		--OR b.xtype=106	--	decimal
		--OR b.xtype=62	--	float
		--OR b.xtype=34	--	image
		--OR b.xtype=56	--	int
		--OR b.xtype=60	--	money
		OR b.xtype=239	--	nchar
		OR b.xtype=99	--	ntext
		--OR b.xtype=108	--	numeric
		OR b.xtype=231	--	nvarchar
		--OR b.xtype=59	--	real
		--OR b.xtype=58	--	smalldatetime
		--OR b.xtype=52	--	smallint
		--OR b.xtype=122	--	smallmoney
		--OR b.xtype=98	--	sql_variant (THESE FIELD TYPES CAN CONTAIN TEXT BASED INFO)
		--OR b.xtype=231	--	sysname
		OR b.xtype=35	--	text
		--OR b.xtype=189	--	timestamp
		--OR b.xtype=48	--	tinyint
		OR b.xtype=36	--	uniqueidentifier
		--OR b.xtype=165	--	varbinary
		OR b.xtype=167	--	varchar
		OR b.xtype=241 -- xml
	) 
	--AND a.name = 'AllUserData' 
	ORDER BY a.name, b.name
OPEN Table_Cursor FETCH NEXT FROM  Table_Cursor INTO @T,@C
WHILE(@@FETCH_STATUS=0) 
BEGIN 

/*** To get counts ONLY from the database ***/
--exec('SELECT COUNT(*) AS thecount FROM ['+@T+'] where [' + @C + '] like ''%' + @SELECT_String + '%''')

/*** To get counts with table/column from the database ***/
exec('SELECT ''' + @T + ''' AS table_name, ''' + @C + ''' AS column_name, COUNT(*) AS thecount FROM ['+@T+'] where [' + @C + '] like ''%' + @SELECT_String + '%''')
FETCH NEXT FROM  Table_Cursor INTO @T,@C 
END 
CLOSE Table_Cursor 
DEALLOCATE Table_Cursor


