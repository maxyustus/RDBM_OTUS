USE vinyldb;

-- Возьмём наш запрос, который показывает сколько мы заработаем прибыли с продажи всех копий каждого релиза.
-- Попробуем оптимизировать его, используя индексы.
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
SELECT 
	ReleaseName,
	SUM(EstimatedTotal - TotalPaid) AS Profit
FROM CalcTable
GROUP BY ReleaseName;

-- Дропнем индексы с таблиц.
SHOW INDEX FROM ReleaseBase; 
DROP INDEX ReleaseNameIdx ON ReleaseBase;
SHOW INDEX FROM SuppliedRelease; 
DROP INDEX ReleaseIdIdx ON SuppliedRelease;

-- EXPLAIN ANALYZE
-> Table scan on <temporary>  (actual time=0.001..0.001 rows=3 loops=1) -- Планировщик предпочёл aggregate using temporary table. Потом он сканирует <temporary>.
  -> Aggregate using temporary table  (actual time=0.396..0.397 rows=3 loops=1)
     -> Nested loop inner join  (cost=10.90 rows=18) (actual time=0.168..0.303 rows=18 loops=1)
         -> Nested loop inner join  (cost=4.60 rows=18) (actual time=0.159..0.220 rows=18 loops=1)
             -> Table scan on rb  (cost=1.30 rows=3) (actual time=0.120..0.123 rows=3 loops=1) -- Table Scan, индекса нет.
             -> Filter: (sr.SupplierId is not null)  (cost=0.70 rows=6) (actual time=0.025..0.031 rows=6 loops=3)
                 -> Index lookup on sr using ReleaseIdIdx (ReleaseId=rb.ReleaseId)  (cost=0.70 rows=6) (actual time=0.025..0.030 rows=6 loops=3)
           -> Single-row covering index lookup on s using PRIMARY (SupplierId=sr.SupplierId)  (cost=0.26 rows=1) (actual time=0.004..0.004 rows=1 loops=18)

-- DESC FORMAT=TREE
 -> Table scan on <temporary>
    -> Aggregate using temporary table
        -> Nested loop inner join  (cost=1.84 rows=1)
            -> Inner hash join (sr.ReleaseId = rb.ReleaseId)  (cost=1.34 rows=1)
                -> Filter: (sr.SupplierId is not null)  (cost=0.14 rows=2)
                    -> Table scan on sr  (cost=0.14 rows=18) -- Без индексов видим 2 table scan - по sr и по rb. 
                -> Hash
                    -> Table scan on rb  (cost=0.55 rows=3) -- Выполняет чуть быстрее, но у нас очень мало строк в таблице.
            -> Single-row covering index lookup on s using PRIMARY (SupplierId=sr.SupplierId)  (cost=0.10 rows=1)
            
-- EXPLAIN           
SIMPLE	rb	ALL		PRIMARY		[NULL]	[NULL]	[NULL]		3	100.0	Using temporary   -- type:ALL, индекса нет, Сканируем всю таблицу.
SIMPLE	sr	ALL		SupplierIdIdx	[NULL]	[NULL]	[NULL]		18	10.0	Using where; Using join buffer (hash join) -- type:ALL, индекса нет, Сканируем всю таблицу.
SIMPLE	s	eq_ref	PRIMARY	PRIMARY		4	vinyldb.sr.SupplierId	1	100.0	Using index

-- Вернём обратно наши индексы.
CREATE INDEX ReleaseNameIdx ON ReleaseBase(ReleaseName);
CREATE INDEX ReleaseIdIdx ON SuppliedRelease(ReleaseId);
-- EXPLAIN ANALYZE
-> Group aggregate: sum(((sr.TotalCopies * sr.RetailPrice) - (sr.TotalCopies * sr.SupplierPrice))) -- А тут видим Group aggregate.
							(cost=11.95 rows=18) (actual time=0.190..0.295 rows=3 loops=1) -- Посчитал быстрее на 100-200мсек.
    -> Nested loop inner join  (cost=10.15 rows=18) (actual time=0.107..0.246 rows=18 loops=1)
        -> Nested loop inner join  (cost=3.85 rows=18) (actual time=0.095..0.159 rows=18 loops=1)
            -> Covering index scan on rb using ReleaseNameIdx  (cost=0.55 rows=3) (actual time=0.043..0.046 rows=3 loops=1) -- Индекс используется, видим Index Scan вместо table scan
            -> Filter: (sr.SupplierId is not null)  (cost=0.70 rows=6) (actual time=0.031..0.036 rows=6 loops=3)
                -> Index lookup on sr using ReleaseIdIdx (ReleaseId=rb.ReleaseId)  (cost=0.70 rows=6) (actual time=0.030..0.035 rows=6 loops=3)
        -> Single-row covering index lookup on s using PRIMARY (SupplierId=sr.SupplierId)  (cost=0.26 rows=1) (actual time=0.004..0.005 rows=1 loops=18)
        
 -- DESC FORMAT=TREE
 -> Group aggregate: sum(((sr.TotalCopies * sr.RetailPrice) - (sr.TotalCopies * sr.SupplierPrice)))  (cost=11.95 rows=18)
    -> Nested loop inner join  (cost=10.15 rows=18)
        -> Nested loop inner join  (cost=3.85 rows=18)
            -> Index scan on rb using ReleaseNameIdx  (cost=0.55 rows=3) -- index scan вместе table scan
            -> Filter: (sr.SupplierId is not null)  (cost=0.70 rows=6)
                -> Index lookup on sr using ReleaseIdIdx (ReleaseId=rb.ReleaseId)  (cost=0.70 rows=6) -- index lookup
        -> Single-row covering index lookup on s using PRIMARY (SupplierId=sr.SupplierId)  (cost=0.26 rows=1)


 -- EXPLAIN
SIMPLE	rb	index	PRIMARY,ReleaseNameIdx		ReleaseNameIdx	202	[NULL]			3	100.0	Using index -- type:index, Используется индекс ReleaseNameIdx.
SIMPLE	sr	ref	SupplierIdIdx,ReleaseIdIdx	ReleaseIdIdx	4	vinyldb.rb.ReleaseId	6	100.0	Using where -- type:ref, Используется индекс ReleaseIdIdx из SuppliedRelease.
SIMPLE	s	eq_ref	PRIMARY				PRIMARY		4	vinyldb.sr.SupplierId	1	100.0	Using index  
-- Итого: с большой долей вероятности у нас получилось оптимизировать запрос, используя индексы. 
-- Однозначно сказать сейчас нельзя, потому что в таблице физически не хватает данных, чтобы посмотреть насколько индексы ускоряют выборку.
-- Однако, оптимизатор их использует, мы видим это при построении плана запроса.

-- Дополнительно к заданию по оптимизации я решил переписать запрос из дз по агрегации и сортировке, использовав оконные функции.
-- Выбрать самый дорогой и самый дешевый товар из каждой категории категории. Дополнительно я посчитал прибыль с его продажи.
-- Было:
SET SQL_MODE = '';
WITH CalcTable AS (
SELECT 
	rb.ReleaseId, 
	rb.ReleaseName,
	rb.LabelId,
	sr.RetailPrice,
	s.SupplierName,
	(sr.TotalCopies * sr.SupplierPrice) AS TotalPaid,
	(sr.TotalCopies * sr.RetailPrice) AS EstimatedTotal
	FROM SuppliedRelease sr
INNER JOIN Supplier s
	on sr.SupplierId = s.SupplierId 
INNER JOIN ReleaseBase rb
	ON sr.ReleaseId = rb.ReleaseId
)
SELECT 
	ct1.ReleaseName, 
	ct1.RetailPrice,
	ct1.LabelId,
	SUM(ct1.EstimatedTotal - ct1.TotalPaid) AS Profit
FROM CalcTable AS ct1 
WHERE ct1.RetailPrice IN (
SELECT MAX(ct2.RetailPrice) 
FROM CalcTable ct2 
WHERE ct2.LabelId = ct1.LabelId) 
group by LabelId;
-- Стало. Теперь и самый дешевый и самый дорогой видно в одной выборке. 
-- И вместо двух запросов ранее, сейчас мы можем выполнить всего один. И спокойно выполняем с ONLY_FULL_GROUP_BY.
SET SQL_MODE = 'ONLY_FULL_GROUP_BY';
WITH CalcTable AS (
SELECT 
	rb.ReleaseId, 
	rb.ReleaseName,
	rb.LabelId,
	sr.RetailPrice,
	s.SupplierName,
	(sr.TotalCopies * sr.SupplierPrice) AS TotalPaid,
	(sr.TotalCopies * sr.RetailPrice) AS EstimatedTotal
	FROM SuppliedRelease sr
INNER JOIN Supplier s
	on sr.SupplierId = s.SupplierId 
INNER JOIN ReleaseBase rb
	ON sr.ReleaseId = rb.ReleaseId
)	
SELECT
	ReleaseName, 
	LabelId,
	SUM(EstimatedTotal - TotalPaid) OVER (PARTITION BY LabelId) AS Profit,
	MAX(RetailPrice) OVER (PARTITION BY LabelId) AS MaxPrice,
	MIN(RetailPrice) OVER (PARTITION BY LabelId) AS MinPrice
FROM CalcTable;

-- Включим slow_log
SET GLOBAL slow_query_log = 1;

-- По конфигурационным настройкам:
-- Установим innodb_buffer_pool_size в 75% от сервера 4gb(3gb):
SET GLOBAL innodb_buffer_pool_size = 3000000000;
SET GLOBAL max_connections = 20;

-- Дописал в my.cnf
innodb_flush_method = O_DIRECT -- стоял fsync

-- Перезапустим сервер
-- service mysqld restart

