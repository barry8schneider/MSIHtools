-- List of all "staff.aspx" pages 
SELECT '/' + replace(Docs.DirName, '/pages', '/') as thesubsite, docs.DirName + '/' + docs.LeafName as thepage
FROM Docs 
WHERE Docs.IsCurrentVersion = 1 
AND docs.DirName LIKE 'about/org/%/Pages' 
AND docs.LeafName IN ( 'staff.aspx' ) 
ORDER BY thesubsite
;

-- List of all aspx pages under the "storz" subsite: 
SELECT '/' + replace(Docs.DirName, '/pages', '/') as thesubsite, docs.DirName + '/' + docs.LeafName as thepage
FROM Docs 
WHERE Docs.IsCurrentVersion = 1 
AND docs.DirName = 'about/org/dir/cbmp/storz/pages' 
and docs.Extension = 'aspx'
ORDER BY thesubsite
---NICHD-NewsPage-Template.aspx
;