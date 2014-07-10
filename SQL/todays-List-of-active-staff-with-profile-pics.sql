---------------------------------------------------
--- query to find staffprofiles 
--- PLEASE NOTE: 
---		This list is not accurate.
---		It does NOT take into account vw_ned_person_sharepoint
---------------------------------------------------
select 
ud.nvarchar1 AS lastfirstname, 
ud.nvarchar22 AS nihid, 
ud.nvarchar6 as title, 
ud.nvarchar28 as orgunitcode, 
ud.nvarchar15 as orgunitname, 
ud.nvarchar16 as internet_home_url, 
ud.nvarchar11 AS picture_url, -- col at NICHD for picture
--ud.nvarchar13 AS picture_url, -- col at WOOD for picture
'/Lists/StaffProfiles/DispForm.aspx?ID=' + convert(varchar, UD.tp_id) AS approval_url, 
'/about/staff/pages/bio.aspx?nih_id=' + UD.nvarchar22 AS edit_url,
--- add this section to get the thumbnails in the same query 
 '/' + thumbs.DirName + '/' + thumbs.LeafName as thumbnail 
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID	AND UserInfo.tp_SiteID = ud.tp_SiteId
--- add this section to get the thumbnails in the same query 
LEFT JOIN AllDocs thumbs with (nolock) ON ud.nvarchar22 = substring(thumbs.LeafName, 1, 10)
	AND thumbs.leafname like '%f[_]%' --- looks like thumbnails are versioned like f1_jpg.jpg, f2_jpg.jpg etc...
	and thumbs.dirname like 'publishingImages/directory/[_]t%'-- to find just the thumbnail
	and thumbs.dirname NOT like '%/[_]t/[_]%'-- don't want lower-level ones
	--and thumbs.ContentVersion = 0

where docs.ListId = l.tp_ID
AND Docs.WebId = Webs.Id
and docs.Id = ud.tp_DocId
-- kent added the following 2 lines on 8/30/2010, seems that docs and ud tables store multiple versions, and thus you get dup records back...
and docs.IsCurrentVersion = 1
and docs.Level = ud.tp_level
AND Docs.DirName like 'Lists/staffprofiles%' ---- I donnot want the master page / templates listed
and ud.nvarchar11  != '' ---- col at NICHD for picture
--and ud.nvarchar13 != '' -- col at WOOD for picture

-- and ud.nvarchar13 AS picture_url, -- col at WOOD for picture
AND ud.nvarchar22 in (
	--- list of all non-active images converted to nihid's
	--- PLEASE NOTE, just b/c they have a non-active image, doesn't mean they're active in NED...
	select  substring(LeafName, 1, 10)
	from AllDocs 
	where leafname like '%f[_]%' --- looks like thumbnails are versioned like f1_jpg.jpg, f2_jpg.jpg etc...
	--and leafname like '%0011143256%'
	and dirname like 'publishingImages/directory/[_]t%'-- to find just the thumbnail
	and dirname NOT like '%/[_]t/[_]%'-- don't want lower-level ones
	--and ContentVersion != 0 --- active image: ContentVersion=0
)
--AND ud.ntext3 LIKE '%¿%'  --- this is the biosketch
--- and 109 active nihid's from vw_ned_person_sharepoint
AND ud.nvarchar22 in (
--- 109 active staff with profile pics
'0010035600', '0010037749', '0010041325', '0010043407', '0010050615', '0010051538', '0010053958', '0010054436', '0010054731', '0010055041', 
'0010056052', '0010056786', '0010060395', '0010063898', '0010067995', '0010068150', '0010069538', '0010072189', '0010074641', '0010085473', 
'0010097508', '0010102371', '0010111171', '0010116799', '0010122619', '0010126245', '0010126288', '0010139152', '0010140095', '0010142742', 
'0010144391', '0010146392', '0010152932', '0010154294', '0010159135', '0010162528', '0010164474', '0010168164', '0010168172', '0010169735', 
'0010169825', '0010170034', '0010170510', '0010171060', '0010172722', '0010173694', '0010174589', '0010174790', '0010179103', '0010181522', 
'0010183410', '0010183740', '0010302285', '0011058907', '0011059233', '0011059740', '0011060053', '0011068662', '0011069671', '0011075918', 
'0011143256', '0011165956', '0011165964', '0011166359', '0011250862', '0011299458', '0011312909', '0011359262', '0011381022', '0011403119', 
'0011467537', '0011474198', '0011557408', '0011730158', '0012168710', '0012212671', '0012246647', '0012329182', '0012347034', '0012568395', 
'0012701035', '0012729610', '0012930453', '0013312507', '0013380541', '0013411275', '0013549107', '0013575478', '0013612473', '0013632670', 
'0013813082', '0014016930', '0014194143', '0014246545', '0014310984', '0014312610', '0014326666', '0014380927', '0014383371', '0014399479', 
'1001036091', '2000728754', '2000764693', '2000792648', '2000792672', '2000803453', '2001109083', '2001123077', '2001135623'
)
ORDER BY lastfirstname
;

