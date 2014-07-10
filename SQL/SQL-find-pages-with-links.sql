---------------------------------------------------------------
------- query to find all pages with a link to a .CFM page
---------------------------------------------------------------
select D.DirName + '/' + D.LeafName AS the_page_with_the_link, '/' + L.TargetDirName + '/' + L.TargetLeafName AS the_link, L.Type
from links L, Docs D
where L.DocId = D.Id
AND 
(
	L.TargetDirName LIKE  '%admin/archive%' or 
	L.TargetLeafName like 'testingorg.bmp%' or
	L.TargetLeafName like 'halfon-developing-ncs-health-measurement-network-NCSAC-january-2012.pdf%' or
	L.TargetLeafName like 'G_barrera.jpg%' or
	L.TargetLeafName like 'studyassemblymeetings.aspx%' or
	L.TargetLeafName like 'Workshops.aspx%' or
	L.TargetLeafName like 'briefingmaterials.aspx%' or
	L.TargetLeafName like 'Extant-Databases,-Census-Abstracts.aspx%' or
	L.TargetLeafName like 'Final-Abstract-Wisconsin-evaluation-self-administered-mailed-2011-RD.pdf%' or
	L.TargetLeafName like 'nationalacademyofsciencesreview.aspx%'
)
order by the_page_with_the_link
;
---------------------------------------------------------------
------- referring links SP2010
---------------------------------------------------------------
select L.TargetDirName, L.TargetLeafName, L.Type, D.DirName + '/' + D.LeafName AS the_page_with_the_link
from links L, Docs D
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
-- 
