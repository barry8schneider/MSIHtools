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
docs.UIVersionString, 
UD.tp_iscurrent, 
UD.tp_ModerationStatus, -- 0: checked in and published; 3: "checked out" or "draft"; 2: checked in and ready for approval
status_label = (CASE 
	WHEN UD.tp_ModerationStatus = 0 THEN 'checked in and published'
	WHEN UD.tp_ModerationStatus = 1 THEN 'not sure what status=1 is'
	WHEN UD.tp_ModerationStatus = 2 THEN 'checked in and ready for approval'
	WHEN UD.tp_ModerationStatus = 3 THEN 'checked out or draft'
	ELSE
	''
	END
), 	
UD.tp_Modified, UD.nvarchar1 AS modifiedBy, 
UserInfo.tp_Login AS checkOutUser, docs.CheckoutDate, 
ud.tp_UIVersionString, ud.tp_IsCurrent, ud.tp_IsCurrentVersion,ud.tp_WorkflowVersion, ud.tp_WorkflowInstanceID, 
ud.nvarchar11 AS picture_url, -- col at NICHD for picture
--ud.nvarchar13 AS picture_url, -- col at WOOD for picture
'/Lists/StaffProfiles/DispForm.aspx?ID=' + convert(varchar, UD.tp_id) AS approval_url, 
'/about/staff/pages/bio.aspx?nih_id=' + UD.nvarchar22 AS edit_url,
docs.ContentVersion
--- add this section to get the thumbnails in the same query 
-- , '/' + thumbs.DirName + '/' + thumbs.LeafName as thumbnail 
FROM docs with (nolock), webs with (nolock), Lists L with (nolock), UserData ud with (nolock)
LEFT JOIN UserInfo with (nolock) ON UserInfo.tp_ID = ud.tp_checkoutUserID	AND UserInfo.tp_SiteID = ud.tp_SiteId
/*
--- add this section to get the thumbnails in the same query 
LEFT JOIN AllDocs thumbs with (nolock) ON ud.nvarchar22 = substring(thumbs.LeafName, 1, 10)
	AND thumbs.leafname like '%f[_]%' --- looks like thumbnails are versioned like f1_jpg.jpg, f2_jpg.jpg etc...
	and thumbs.dirname like 'publishingImages/directory/[_]t%'-- to find just the thumbnail
	and thumbs.dirname NOT like '%/[_]t/[_]%'-- don't want lower-level ones
	and thumbs.ContentVersion = 0

*/
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
	and ContentVersion != 0 --- active image: ContentVersion=0
)
--AND ud.ntext3 LIKE '%¿%'  --- this is the biosketch
ORDER BY lastfirstname
;

---------------------------------------------------
--- query to find the profile thumbnail pictures
---------------------------------------------------
select *
from AllDocs 
where leafname like '%f[_]%' --- looks like thumbnails are versioned like f1_jpg.jpg, f2_jpg.jpg etc...
and dirname like 'publishingImages/directory/[_]t%'-- to find just the thumbnail
and dirname NOT like '%/[_]t/[_]%'-- don't want lower-level ones
and ContentVersion != 0
and substring(LeafName, 1, 10) in (
--- list of nihid's from vw_ned_person_sharepoint
'0010043407', '0010053958', '0010054731', '0010056052', '0010063898', '0010111171', '0010116799', '0010122619', '0010126245', '0010139152', 
'0010142742', '0010169735', '0010169825', '0010173694', '0010174790', '0010302285', '0011059233', '0011059740', '0011068662', '0011069671', 
'0011143256', '0011165956', '0011165964', '0011166359', '0011381022', '0011467537', '0011474198', '0011557408', '0012329182', '0012606554', 
'0012701035', '0012729610', '0012799036', '0012930453', '0013380541', '0013549107', '0013575478', '0013612473', '2000452336'	
	)

order by LeafName
;
