use vinyldb;
SELECT * FROM ReleaseBase;

-- Query to find ReleaseID, ReleaseName, ReleaseDate by track name like 'Stagga' from JSON object attribute.
SELECT
	ReleaseID, ReleaseName, ReleaseDate
FROM
	vinyldb.ReleaseBase
WHERE
	LabelId = 1
AND JSON_EXTRACT(Attributes, '$.tracklist') LIKE '%Stagga%';

-- Adding property 'featuring' to JSON attribute for ReleaseId = 2
UPDATE vinyldb.ReleaseBase
SET Attributes = JSON_INSERT(
	Attributes ,
    '$.featuring' ,
    'Baby Rollen'
)
WHERE
	ReleaseId = 2;

-- Removing property 'featuring' from JSON attribute for ReleaseId = 2
UPDATE vinyldb.ReleaseBase
SET Attributes = JSON_REMOVE(
	Attributes ,
    '$.featuring')
WHERE
	ReleaseId = 2;
    
    
    
    
    
    
    
    
    
    
    
    
    
    



