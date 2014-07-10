-- if needed, use ¿ as the custom delimiter and piped this to a file on the file system

/* 
-------------------------------------------------------------------------------------------------
------  RMC dump Query is found in : C:\NIH\Insider_SharePoint_2010\Data_dumps\records_management_center\_rmc_data_dump.SQL
------  IRMB BRANCH PORTAL DATA DUMP QUERY MOVED TO: C:\NIH\Insider_SharePoint_2010\Data_dumps\IRMB_branch_portal\_irmb_data_dump.sql
------  IRMB Publishing Subsites DUMP QUERY MOVED TO: C:\NIH\Insider_SharePoint_2010\Data_dumps\IRMB\_irmb_data_dump.sql
-------------------------------------------------------------------------------------------------
*/

---------------------------------------------------------------
------- dump of all pages Circle solutions has touched in SC site
------- sharepoint 2010
---------------------------------------------------------------
select 
'/' + docs.dirName + '/' + docs.LeafName AS thepage, 
docs.Extension, 
UD.nvarchar2 AS createdBy, 
UD.tp_Created AS CreatedDate, 
UD.nvarchar1 AS modifiedBy, 
UD.tp_Modified AS modifiedDate, 
--- KENT NOTE 4/16/2012: I should also look at the UserData table b/c there are 2 columns in that table that look like they can also be used for modified date
UD.tp_ModerationStatus,
UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate, docs.CheckoutExpires,
docs.UIVersionString, 
UD.nvarchar23 AS redirectURL1, 
UD.nvarchar24 AS redirectURL2, 
UD.nvarchar25 AS redirectURL3
from docs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) 
	ON UserInfo.tp_ID = ud.tp_checkoutUserID 
	AND UserInfo.tp_SiteID = ud.tp_SiteId
where docs.ListId = l.tp_ID
and docs.Id = ud.tp_DocId
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
--and docs.Extension in ('aspx', 'pdf')
and docs.Extension not in ('000', '')
/**** if you're interested in anything changed on a specific day ***/
/*
and (
	CONVERT(varchar, UD.tp_Created ,121) like '%2011-03-03%'
	OR CONVERT(varchar, UD.tp_Modified ,121) like '%2011-03-03%'
)
*/
AND (
	nvarchar1 like '%lynchk2%'
	OR nvarchar2 like '%lynchk2%'
)	
/***** list of users from circle ******************/
/*
AND (
	nvarchar1 in ('NIH\jonesjohnsontr', 'NIH\worthb', 'NIH\barreragc', 'NIH\wilsonmc', 'NIH\pultarnm')
	OR 
	nvarchar2 in ('NIH\jonesjohnsontr', 'NIH\worthb', 'NIH\barreragc', 'NIH\wilsonmc', 'NIH\pultarnm')
)
*/
/************** list of redirect url's **********************/
/*	
AND (
	ud.nvarchar23 LIKE 'http://insider2%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	OR ud.nvarchar24 LIKE 'http://insider2%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
	OR ud.nvarchar25 LIKE 'http://insider2%' -- On Insider2010 SP, this column is used for the URL value for redirect pages
)	
*/
ORDER BY thepage, ud.nvarchar1, ud.nvarchar2
;


---------------------------------------------------------------
------– Get List of All Documents That 
------– were NEVER published/checked in
------– or in draft state
------– or that are checked out and by who
------– or that are uploaded for the first time and havenot been checked in yet
------– (moss2007 and SharePoint2010)
---------------------------------------------------------------
SELECT 
Webs.FullUrl AS sitecollectionURL, 
AllLists.tp_Title AS LibraryTitle,
Docs.DirName, Docs.LeafName, 
Docs.Extension, 
------ Docs.Version AS VersionNumber, (this field doesn't seem to correlate to anything...)
Docs.UIVersionString, -- this seems to be what's displayed to the user 
Docs.timeLastModified, Docs.Size/1024 AS FileSize_InKB,
UD.tp_ModerationStatus, -- if moderation is NOT enabled: always = 0 
						-- otherwise if moderation is enabled: 0 = checked in and published; 3 = "checked out" or "draft"; 2 = checked in and ready for approval
UD.tp_Modified, UD.tp_Created, 
UD.nvarchar2 AS createdBy, 
UD.nvarchar1 AS modifiedBy, 
UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate, docs.CheckoutExpires
-- UD.tp_IsCurrent, ud.tp_IsCurrentVersion, ud.tp_Version, ud.tp_UIVersionString, ud.tp_CheckoutUserId
-- UD.ntext2, -- insider 2010 description
-- UD.ntext6, -- insider 2010 body content 
-- UD.nvarchar7, -- insider 2010 insider title 
-- UD.nvarchar19, -- insider 2010 keywords
FROM     Docs with (nolock)
INNER JOIN Webs with (nolock) On Docs.WebId = Webs.Id
INNER JOIN Sites with (nolock) ON Webs.SiteId = SItes.Id
LEFT JOIN AllLists with (nolock) ON Docs.ListId = AllLists.tp_ID
INNER JOIN UserData ud with (nolock) ON ud.tp_ListID = AllLists.tp_ID 
	AND ud.tp_id = docs.DoclibRowId
	AND ud.tp_IsCurrent = 1
LEFT JOIN UserInfo with (nolock) 
	ON UserInfo.tp_ID = ud.tp_checkoutUserID
	AND UserInfo.tp_SiteID = ud.tp_SiteId
WHERE
Docs.Type NOT in ( 1, 2) -- Docs.Type = 2 is a site
AND docs.IsCurrentVersion = 1
AND UD.tp_RowOrdinal = 0 -- for some reason in RMC, this query was listing each document twice, this fixed the dup listings
-- AND Extension != 'aspx' -- if we want to exclude these pages (for the RMC dump, we exclude these)
-- AND convert(numeric, UIVersionString) < 1 -- use this for items that have never been published
-- AND UIVersionString NOT LIKE '%.0'  -- use this for items in a draft state
-- AND ud.tp_checkoutUserID IS NOT NULL -- use this for items that are checked out
-- AND UIVersionString = '1.0' AND ud.tp_checkoutUserID IS NOT NULL -- use this for items that have been uploaded but not checked in
-- AND (DirName LIKE '%sites/myprojects/councilprep/Documents/Council Prep 201101/Presentations%')
-- AND (Docs.CheckinComment LIKE 'Published by Woodbourne automated publishing program.')
-- AND (CONVERT(VARCHAR, Docs.TimeLastModified, 121) NOT like '2011-01-26%')

AND Size > 0
--- WE HAVE TO BE CAREFUL WITH THIS ONE... there are legit libraries with this name in them...
AND (LeafName NOT LIKE '%template%') 

-- MIGHT WANT TO EXCLUDE THE MOBILE DIRECTORY FROM THE PAGE COUNTS
AND (DirName NOT LIKE '%/m') 
AND (DirName != 'm') 
-- CAN NOT USE THIS!!! AND (DirName LIKE '%/Pages')
AND (DirName NOT LIKE '%_catalogs/%') 
AND (DirName NOT LIKE '%/Forms') 
AND (DirName NOT LIKE '%Lists/%') 
AND (DirName NOT LIKE '%Style Library%')
AND (DirName NOT LIKE '%cache profiles%')
AND (DirName NOT LIKE '%WorkflowHistory')
AND (DirName NOT LIKE '%WorkflowTasks')
--AND (DirName NOT LIKE 'archived%')
AND (DirName NOT LIKE 'projects/recordsmanagement%PublishingImages%')
AND (DirName NOT LIKE 'projects/recordsmanagement/Reporting Templates%')
AND (DirName NOT LIKE 'projects/recordsmanagement/Reports/%')
AND (DirName != 'projects/recordsmanagement/Pages') -- there are no user-uploaded documents at the root-level pages library in RMC

AND (DirName NOT LIKE '%Long Running Operation Status%')
AND (DirName NOT LIKE '%Quick Deploy Items%')
AND (DirName NOT LIKE '%Relationships List%')
AND (DirName NOT LIKE '%Reports List%')
AND (LeafName NOT LIKE '%.stp')  
AND (LeafName NOT LIKE '%.xfp') 
AND (LeafName NOT LIKE '%.dwp') 
AND (LeafName NOT LIKE '%.inf') 
AND (LeafName NOT LIKE '%.css') 
AND (LeafName NOT LIKE 'bl_%.jpg')
AND (LeafName NOT IN 
	(
	'AllItems.aspx', 'DispForm.aspx', 'EditForm.aspx', 'Upload.aspx',
	'Combine.aspx', 'repair.aspx', 'WebFldr.aspx', 
	'NewForm.aspx', 'active.aspx', 
	'MyItems.aspx', 'MyGrTsks.aspx', 'byowner.aspx', 'duetoday.aspx', 
	'All Forms.aspx', 'AllCategories.aspx', 'AllComments.aspx', 'AllPosts.aspx',
	'AllPages.aspx', 'ByEditor.aspx', 'CreatedByMe.aspx',
	'RssView.aspx', 'ByAuthor.aspx', 
	'EditCategory.aspx', 'EditComment.aspx', 'EditPost.aspx', 
	'MyCategories.aspx', 'MyComments.aspx', 'MyPosts.aspx', 
	'NewCategory.aspx', 'NewComment.aspx', 'NewPost.aspx', 
	'ViewCategory.aspx', 'ViewComment.aspx', 'ViewPost.aspx', 
'mod-view.aspx', 'my-sub.aspx', 'colorschememapping.xml', 
'filelist.xml', 'themedata.thmx', 'Thumbs.db', 
'PersonalViews.aspx', 'RecentChanges.aspx', 
'audit.xml', 'Automatic Update No.aspx', 'Automatic Update Yes.aspx', 
'Content Preview.aspx', 'ContentQueryMain.xsl', 
'durations.xml', 'errors.xml', 'Header.xsl', 'ItemStyle.xsl', 'LevelStyle.xsl', 
'linksdivider.gif', 'Post.aspx', 'Rss.xsl', 'Search_Arrow.jpg', 
'Search_Arrow_RTL.jpg', 'Selected.aspx', 'Slidshow.aspx', 
'SummaryLinkMain.xsl', 'TableOfContentsMain.xsl'
	) 
)
order by Docs.DirName, Docs.LeafName

