use vinyldb;

SET sql_mode = '';
-- Посмотрим сколько всего копий и их полную стоимость по месяцам с rollup, закупленных у всех поставщиков за всё время. 
SELECT
	sr.SupplierId,
	s.SupplierName,
	IF(GROUPING(MONTH(sr.ArrivedDate)), 'All Month', MONTH(sr.ArrivedDate)) AS ArrivedMonth,
	SUM(sr.TotalCopies) as TotalCopies,
	SUM(sr.SupplierPrice * sr.TotalCopies) AS TotalPrice
FROM SuppliedRelease sr
INNER JOIN Supplier s
	ON sr.SupplierId = s.SupplierId 
GROUP BY SupplierId, MONTH(ArrivedDate) WITH ROLLUP;

-- Посмотрим min и max стоимость самых больших партий по каждому товару, заказанному у поставщика.
SET sql_mode= 'only_full_group_by';
SELECT 
	ReleaseId,
	TotalCopies,
	MAX(SupplierPrice) AS MaxPrice,
	MIN(SupplierPrice) AS MinPrice
FROM SuppliedRelease
GROUP BY ReleaseId, TotalCopies
HAVING TotalCopies = 100;
ORDER BY ReleaseId; 

-- Самый дорогой товар в каждой категории(вместо категории Label). 
-- Тоже самое работает для самого дешевого, min меняем на max.
-- Сначала получил выборку из двух таблиц, потом сджойнил саму с собой с условием where.
-- Лучше ничего не придумал =/. Подскажите как лучше сделать?
SET sql_mode = '';
WITH TotalProducts AS (
SELECT DISTINCT 
	rb.ReleaseId, 
	rb.ReleaseName,
	rb.LabelId,
	sr.RetailPrice
FROM SuppliedRelease sr
INNER JOIN ReleaseBase rb 
	ON sr.ReleaseId = rb.ReleaseId
)
SELECT 
	tp1.ReleaseName, 
	tp1.RetailPrice,
	tp1.LabelId
FROM TotalProducts AS tp1 
WHERE tp1.RetailPrice IN (
SELECT MAX(tp2.RetailPrice) 
FROM TotalProducts tp2 
WHERE tp2.LabelId = tp1.LabelId) 
GROUP BY LabelId;

-- Rollup с количеством пластинок (аналогично выполняем по колличеству товаров по категориям).
SET sql_mode = '';
SELECT
	IF(GROUPING(ReleaseId), 'total', ReleaseId) AS ReleaseId, 
	SUM(TotalCopies) AS TotalCopies
FROM SuppliedRelease 
GROUP BY ReleaseId WITH ROLLUP;

-- Кейс с использованием CASE. Посчитаем общий total и total, который закупили только большими партиями по 100 пластинок. Практичнее ничего не придумал, но практиковаться надо.
SET sql_mode = '';
SELECT
	IF(GROUPING(ReleaseId), 'total', ReleaseId) AS ReleaseId,
	SUM(TotalCopies) AS TotalCopies,
	SUM(CASE 
		WHEN TotalCopies = 100 THEN TotalCopies
		ELSE 0
	    END) AS 'BigBatches'
FROM SuppliedRelease
GROUP BY ReleaseId WITH ROLLUP;








