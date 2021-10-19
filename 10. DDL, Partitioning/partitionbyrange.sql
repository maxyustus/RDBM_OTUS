use vinyldb;

select * from Genre;
DESC Genre;

-- Выполним RANGE партиционирование таблицы Genre по ключу GenreId, 3 партиции
ALTER TABLE Genre PARTITION BY RANGE(GenreId) (
	PARTITION P1 VALUES LESS THAN (4),
    PARTITION P2 VALUES LESS THAN (7),
    PARTITION P3 VALUES LESS THAN (9)
);

-- Посмотрим распределение строк по партициям
SELECT p.PARTITION_NAME, p.TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS p
WHERE TABLE_NAME = 'Genre';

-- Выберем данные из партиции p1
SELECT * FROM Genre PARTITION(p1);



