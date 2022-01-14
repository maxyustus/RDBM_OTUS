-- Текущая структура данных неоптимальна:
--    - нет типизации - почти все поля хранятся как строки
--    - данные не нормализованы - данные о адресе и человеке хранятся в одной таблице,
--    - на одного человека может приходится несколько адресов
-- Попытаться выделить следующие сущности:
--    - страны
--    - города
--    - улицы
--    - дома
--    и другие которые посчитаете нужными

USE vinyldb;
SHOW VARIABLES LIKE 'secure_file_priv';
-- /var/lib/mysql-files/
-- Копируем выбранный CSV по адресу secure_file_priv, далее настроим некоторые параметры.

SET unique_checks=0;
SET foreign_key_checks=0;

show variables like '%deadlock_detect%';
show variables like 'innodb_log_buffer_size';

SET innodb_lock_wait_timeout=360;
SET GLOBAL innodb_log_buffer_size=128000000;

-- Создадим таблицу
DROP TABLE IF EXISTS test_load;
CREATE TABLE IF NOT EXISTS test_load (
	title varchar(50),
	first_name varchar(50),
	last_name varchar(50),
	correspondence_language varchar(50),
	birth_date varchar(50),
	gender varchar(50),
	marital_status varchar(50),
	country varchar(50),
	postal_code varchar(50),
	region varchar(50),
	city varchar(50),
	street varchar(100),
	building_number varchar(50)
);

-- Зальём данные
LOAD DATA INFILE '/var/lib/mysql-files/some_customers.csv'
	INTO TABLE test_load
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(title,first_name,last_name,correspondence_language,birth_date,gender,
	marital_status,country,postal_code,region,city,street,building_number)
;

-- Посмотрим что за данные и в каком они состоянии.
SELECT title,first_name,last_name,correspondence_language,birth_date,gender,
	marital_status,country,postal_code,region,city,street,building_number FROM test_load
LIMIT 10;
-- Нормализованная база данных, с выделенными сущностями приложена как скриншот. 
-- После нормализации данных, мы можем приступать к их разделению по разным таблицам.
-- Проблемы, которые могут возникнуть: 
-- 1. В исходной таблице содержится очень много Null значений, и значений "unknown". Помогут дефолтные значения.
-- 2. Сейчас данные все в varchar, нужно привести их к нужным типам.
-- Разбить по таблицам можно создавая новые таблицы и применяя UPDATE, можно MERGE. Либо INSERT.
-- пример таблицы для выделенной сущности 'country'.

CREATE TABLE IF NOT EXISTS customers_country (
	country_id int NOT NULL AUTO_INCREMENT,
	country_name varchar(50),
	city_id int,
	PRIMARY KEY (country_id)
);

-- Всё удалим
DROP TABLE IF EXISTS test_load;
DROP TABLE IF EXISTS customers_country;




