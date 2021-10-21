use vinyldb;

SET
-- Данное условие поможет найти поставщиков, с которыми мы начали работать в этом месяце.
SELECT 
	SupplierId,
	SupplierName,
	Email,
	SupplierInfo,
	Since
FROM Supplier
WHERE EXTRACT(MONTH FROM Since) = EXTRACT(MONTH FROM NOW());

-- Найдём крупнейших поставщиков по полю SupplierInfo.
SELECT 
	SupplierId,
	SupplierName,
	Email,
	SupplierInfo,
	Since 
FROM Supplier
WHERE SupplierInfo LIKE '%biggest%' OR '%largest';

-- Найдём релизы из ReleaseBase по атрибуту style из JSON Объекта с уточнением жанров.
SELECT
	ReleaseId,
	ReleaseName,
	LabelId,
	GenreId,
	ReleaseDate 
FROM ReleaseBase
WHERE JSON_EXTRACT(Attributes, '$.style') LIKE '%leftfield%'
	  AND JSON_EXTRACT(Attributes, '$.style') LIKE '%house%';
	 
-- Найдём все релизы и имя поставщика, закупленные у поставщиков количеством n и более.
SELECT 
	rb.ReleaseName,
	sr.TotalCopies,
	s.SupplierName
FROM SuppliedRelease sr
	INNER JOIN ReleaseBase rb
		ON sr.ReleaseId = rb.ReleaseId
			INNER JOIN Supplier s
				ON sr.SupplierId = s.SupplierId 
WHERE (sr.TotalCopies >= 100);

-- Найдём релизы в которых больше n треков.
SELECT 
	ReleaseId,
	ReleaseName,
	JSON_LENGTH(JSON_EXTRACT(Attributes, '$.tracklist')) AS TracksTotal
FROM ReleaseBase
WHERE JSON_LENGTH(JSON_EXTRACT(Attributes, '$.tracklist')) > 3;
