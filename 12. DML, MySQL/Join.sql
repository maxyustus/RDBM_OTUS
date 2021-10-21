USE vinyldb;
SELECT * FROM ReleaseBase; 
SELECT * FROM SuppliedRelease; 
SELECT * FROM Supplier;
SELECT * FROM RecordLabel; 

-- Сколько копий каких релиз(название) мы получили от всех поставщиков.
SELECT
	sr.TotalCopies,
    r.ReleaseName,
    s.SupplierName
FROM SuppliedRelease sr
	INNER JOIN Supplier s 
		ON sr.SupplierId = s.SupplierId 
			INNER JOIN ReleaseBase r
				ON sr.ReleaseId = r.ReleaseId
ORDER BY r.ReleaseName; 

SET sql_mode = 'ONLY_FULL_GROUP_BY';
-- В CTE CalcTable находится основная информация о поставщиках, купленных релизах с названием и total по ценам закупа и продажи.
WITH CalcTable AS (
SELECT 
	s.SupplierName,
	s.Email, 
	s.SupplierInfo, 
	s.Since,
	(sr.TotalCopies * sr.SupplierPrice) AS TotalPaid,
	(sr.TotalCopies * sr.RetailPrice) AS EstimatedTotal,
	rb.ReleaseName
	FROM Supplier s
		LEFT JOIN SuppliedRelease sr
			on s.SupplierId = sr.SupplierId 
				INNER JOIN ReleaseBase rb
					ON sr.ReleaseId = rb.ReleaseId
)
/* Дополнительно, используя CTE, можем посчитать нашу ожидаемую прибыль при успешной продаже всех закупленных релизов.*/	
SELECT 
	ReleaseName,
	SUM(EstimatedTotal - TotalPaid) AS Profit
FROM CalcTable
GROUP BY ReleaseName;

		
		
