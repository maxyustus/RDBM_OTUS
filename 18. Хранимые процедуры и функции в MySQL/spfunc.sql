USE vinyldb;
SHOW PROCEDURE STATUS WHERE db='vinyldb';

-- 1
-- Процедура для выборки товаров с использованием фильтра по GenreId
DROP PROCEDURE IF EXISTS SpGetItemsByGenreId;
DELIMITER $$
USE vinyldb $$
CREATE PROCEDURE SpGetItemsByGenreId (genId INT, sortval INT, pagination INT)
BEGIN
	SELECT 
		*
	FROM ReleaseBase
	WHERE GenreId = genId
	ORDER BY sortval
	LIMIT pagination;
END $$
DELIMITER ;

CALL SpGetItemsByGenreId(7, 3, 5);

-- Процедура для выборки товаров с использованием фильтра по CountryId
DROP PROCEDURE IF EXISTS SpGetItemsByCountryId;
DELIMITER $$
USE vinyldb $$
CREATE PROCEDURE SpGetItemsByCountryId (conId INT, sortval INT, pagination INT)
BEGIN
	SELECT 
		*
	FROM ReleaseBase
	WHERE CountryId = conId
	ORDER BY sortval
	LIMIT pagination;
END $$
DELIMITER ;

CALL SpGetItemsByCountryId(2, 3, 5);

-- Процедура для выборки товаров с использованием фильтра по LabelId
DROP PROCEDURE IF EXISTS SpGetItemsByLabelId;
DELIMITER $$
USE vinyldb $$
CREATE PROCEDURE SpGetItemsByLabelId (labId INT, sortval INT, pagination INT)
BEGIN
	SELECT 
		*
	FROM ReleaseBase
	WHERE LabelId = labId
	ORDER BY sortval
	LIMIT pagination;
END $$
DELIMITER ;

CALL SpGetItemsByLabelId(1, 3, 5);

-- Создадим юзера client и дадим ему права на селект таблицы и выполнение трёх процедур
DROP USER IF EXISTS 'client'@'localhost';
CREATE USER IF NOT EXISTS 'client'@'localhost' IDENTIFIED BY 'client123';
GRANT SELECT ON vinyldb.ReleaseBase TO 'client'@'localhost';
GRANT EXECUTE ON PROCEDURE vinyldb.SpGetItemsByCountryId TO 'client'@'localhost';
GRANT EXECUTE ON PROCEDURE vinyldb.SpGetItemsByLabelId TO 'client'@'localhost';
GRANT EXECUTE ON PROCEDURE vinyldb.SpGetItemsByGenreId TO 'client'@'localhost';
SELECT * FROM mysql.user;

-- 2
-- Процедура для получения отчёта о покупках у поставщика за нужный период времени с группировкой по товару(ReleaseId)
DROP PROCEDURE IF EXISTS SpGetTotalBuyReportByReleaseId;
DELIMITER $$
USE vinyldb $$
CREATE PROCEDURE SpGetTotalBuyReportByReleaseId (datestart DATETIME, datefinish DATETIME)
BEGIN
	SELECT 
		ReleaseId,
		SUM(TotalCopies * SupplierPrice) AS TotalBuy
	FROM SuppliedRelease
	WHERE OrderedDate BETWEEN datestart AND datefinish
	GROUP BY ReleaseId
	ORDER BY TotalBuy DESC;
END $$
DELIMITER ; 

CALL SpGetTotalBuyReportByReleaseId('2021-05-01 00:00:00', '2021-11-01 00:00:00');

-- Процедура с диманическим параметром группировки для отчета о покупках за нужный период
DROP PROCEDURE IF EXISTS SpGetTotalBuyReportCustom;
DELIMITER $$
USE vinyldb $$
CREATE PROCEDURE SpGetTotalBuyReportCustom (datestart DATETIME, datefinish DATETIME, groupcolumn VARCHAR(50))
BEGIN
	SET @report_query:=CONCAT("SELECT ",
									groupcolumn,", ",
									"SUM(TotalCopies * SupplierPrice) AS TotalBuy "
							  "FROM SuppliedRelease ",
							  "WHERE OrderedDate BETWEEN ","'",datestart,"'"," AND ","'",datefinish,"'",
							 " GROUP BY ",groupcolumn,
							 " ORDER BY TotalBuy DESC;");			
							
PREPARE report_query FROM @report_query;
EXECUTE report_query;
DEALLOCATE PREPARE report_query;
END$$
DELIMITER ;

CALL SpGetTotalBuyReportCustom('2021-05-01 00:00:00', '2021-11-01 00:00:00', 'ReleaseId');
-- CONCAT конструкция формирует запрос который будет выглядить примерно так
-- SELECT 
-- 		ReleaseId,
-- 		SUM(TotalCopies * SupplierPrice) AS TotalBuy
-- FROM SuppliedRelease
-- WHERE OrderedDate BETWEEN datestart AND datefinish
-- GROUP BY ReleaseId
-- ORDER BY TotalBuy DESC;
-- В отличие от прошлой процедуры, мы получаем динамический параметр группировки.(CategoryId, SupplierId, ReleaseId, etc.)
-- Как и параметры времени, чтобы обозначить нужный период с точностью до секунд.

-- Создадим юзера manager и дадим ему права на селект таблицы и выполнение двух процедур
DROP USER IF EXISTS 'manager'@'localhost';
CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'manager123';
GRANT SELECT ON vinyldb.SuppliedRelease TO 'manager'@'localhost';
GRANT EXECUTE ON PROCEDURE vinyldb.SpGetTotalBuyReportByReleaseId TO 'manager'@'localhost';
GRANT EXECUTE ON PROCEDURE vinyldb.SpGetTotalBuyReportCustom TO 'manager'@'localhost';
SELECT * FROM mysql.user;

