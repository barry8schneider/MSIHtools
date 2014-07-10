SELECT Docs.DirName 
FROM Docs 
WHERE Docs.IsCurrentVersion = 1 
AND docs.DirName LIKE 'health/topics/%/researchinfo/Pages' 
AND docs.LeafName IN ( 
'default.aspx', 
'contacts.aspx' 
) 
GROUP BY Docs.DirName 
HAVING COUNT(*) < 2 
ORDER BY Docs.DirName 
