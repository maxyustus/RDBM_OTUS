USE vinyldb;

SHOW VARIABLES LIKE 'secure_file_priv';
/var/lib/mysql-files/
-- Скопировал выбранный CSV по адресу secure_file_priv, далее настроим некоторые параметры.

SET unique_checks=0;
SET foreign_key_checks=0;

show variables like '%deadlock_detect%';
show variables like 'innodb_log_buffer_size';

SET innodb_lock_wait_timeout=360;
SET GLOBAL innodb_log_buffer_size=128000000;

-- Создадим таблицу
DROP TABLE IF EXISTS test_load;
CREATE TABLE IF NOT EXISTS test_load (
	Handle varchar(50),
	Title varchar(50),
	BodyHTML text,
	Vendor varchar(50),
	TypeCat varchar(50),
	Tags varchar(50),
	Published varchar(25),
	Option1Name varchar(50),
	Option1Value varchar(50),
	Option2Name varchar(50),
	Option2Value varchar(50),
	Option3Name varchar(50),
	Option3Value varchar(50),
	VarianSKU varchar(50),
	VariantGrams varchar(25),
	VariantInventoryTracker varchar(50),
	VariantInventoryQty varchar(25),
	VariantInventoryPolicy varchar(50),
	VariantFulfillmentService varchar(50),
	VariantPrice varchar(25),
	VariantCompareAtPrice varchar(25),
	VariantRequiresShipping varchar(25),
	VariantTaxable varchar(25),
	VariantBarcode varchar(50),
	ImageSrc varchar(255),
	ImageAltText varchar(128),
	GiftCard varchar(25),
	SEOTitle varchar(50),
	SEODescription text,
	GoogleProduct varchar(50),
	Gender varchar(50),
	AgeGroup varchar(50),
	MPN varchar(50),
	AdWordsGrouping varchar(50),
	AdWordsLabels varchar(50),
	GCondition varchar(50),
	CustomProduct varchar(50),
	CustomLabel0 varchar(50),
	CustomLabel1 varchar(50),
	CustomLabel2 varchar(50),
	CustomLabel3 varchar(50),
	CustomLabel4 varchar(50),
	VariantImage text,
	VariantWeightUnit varchar(50)	
);
-- Зальём данные
LOAD DATA INFILE '/var/lib/mysql-files/Apparel.csv'
	INTO TABLE test_load
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(Handle,Title,BodyHTML,Vendor,TypeCat,Tags,Published,Option1Name,Option1Value,Option2Name,Option2Value,Option3Name,
	Option3Value,VarianSKU,VariantGrams,VariantInventoryTracker,VariantInventoryQty,VariantInventoryPolicy,VariantFulfillmentService,
	VariantPrice,VariantCompareAtPrice,VariantRequiresShipping,VariantTaxable,VariantBarcode,ImageSrc,ImageAltText,GiftCard,
	SEOTitle,SEODescription,GoogleProduct,Gender,AgeGroup,MPN,AdWordsGrouping,AdWordsLabels,GCondition,CustomProduct,
	CustomLabel0,CustomLabel1,CustomLabel2,CustomLabel3,CustomLabel4,VariantImage,VariantWeightUnit)
;

SELECT * FROM test_load
LIMIT 1;
-- Удалось перенести весь CSV файл полностью, но не совсем корректные некоторые типы данных. Некоторые int пришлось заменить на varchar. 
-- Запрос не выполнялся, данные не заливались. Ошибка - некорректный тип данных для выбраного поля, хотя всё там впорядке.
-- Вообщем всё получилось, а типы данных мы можем теперь заменить на любые другие, которые были нужны.
DROP TABLE IF EXISTS test_load;

-- Попробуем залить через mysqlimport
/*
mysqlimport --ignore-lines=1 --lines-terminated-by="\n" --fields-terminated-by="," --fields-optionally-enclosed-by=\" \
--columns='Handle,Title,BodyHTML,Vendor,TypeCat,Tags,Published,Option1Name,Option1Value,Option2Name,Option2Value,Option3Name, \
Option3Value,VarianSKU,VariantGrams,VariantInventoryTracker,VariantInventoryQty,VariantInventoryPolicy,VariantFulfillmentService, \
VariantPrice,VariantCompareAtPrice,VariantRequiresShipping,VariantTaxable,VariantBarcode,ImageSrc,ImageAltText,GiftCard,SEOTitle, \
SEODescription,GoogleProduct,Gender,AgeGroup,MPN,AdWordsGrouping,AdWordsLabels,GCondition,CustomProduct,CustomLabel0,CustomLabel1, \
CustomLabel2,CustomLabel3,CustomLabel4,VariantImage,VariantWeightUnit' --local -u root -p vinyldb "/var/lib/mysql-files/Apparel.csv"
*/
-- Выдаёт ошибку
-- mysqlimport: Error: 3948, Loading local data is disabled; this must be enabled on both the client and server sides, when using table: Apparel
-- Ок. Поменяем значение переменной
SET GLOBAL local_infile=1;

-- mysqlimport: Error: 1146, Table 'vinyldb.Apparel' doesn't exist, when using table: Apparel
-- Ок. Создадим таблицу теперь уже с названием Apparel.
DROP TABLE IF EXISTS Apparel;
CREATE TABLE IF NOT EXISTS Apparel (
	Handle varchar(50),
	Title varchar(50),
	BodyHTML text,
	Vendor varchar(50),
	TypeCat varchar(50),
	Tags varchar(50),
	Published varchar(25),
	Option1Name varchar(50),
	Option1Value varchar(50),
	Option2Name varchar(50),
	Option2Value varchar(50),
	Option3Name varchar(50),
	Option3Value varchar(50),
	VarianSKU varchar(50),
	VariantGrams varchar(25),
	VariantInventoryTracker varchar(50),
	VariantInventoryQty varchar(25),
	VariantInventoryPolicy varchar(50),
	VariantFulfillmentService varchar(50),
	VariantPrice varchar(25),
	VariantCompareAtPrice varchar(25),
	VariantRequiresShipping varchar(25),
	VariantTaxable varchar(25),
	VariantBarcode varchar(50),
	ImageSrc varchar(255),
	ImageAltText varchar(128),
	GiftCard varchar(25),
	SEOTitle varchar(50),
	SEODescription text,
	GoogleProduct varchar(50),
	Gender varchar(50),
	AgeGroup varchar(50),
	MPN varchar(50),
	AdWordsGrouping varchar(50),
	AdWordsLabels varchar(50),
	GCondition varchar(50),
	CustomProduct varchar(50),
	CustomLabel0 varchar(50),
	CustomLabel1 varchar(50),
	CustomLabel2 varchar(50),
	CustomLabel3 varchar(50),
	CustomLabel4 varchar(50),
	VariantImage text,
	VariantWeightUnit varchar(50)	
);


-- Что в итоге, опять ошибка. Нашел решение, установить глобал local_infile=1(уже сделал). Выйти. Зайти на сервер примерно так mysql --local-infile=1 -u root -p1,
-- и выполнить всё тот же load data local infile =)
-- mysqlimport: Error: 2068, LOAD DATA LOCAL INFILE file request rejected due to restrictions on access., when using table: Apparel
-- Так как под капотом все равно почти тот же LOAD DATA, дальше копать не стал. Для себя определился, что всегда буду использовать LOAD DATA.
-- Работает быстро, минимум боли.


