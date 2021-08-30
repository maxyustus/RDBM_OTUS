## 5. DML - вставка, обновление, удаление, выборка данных

---
### Общий комментарий
Добавил в базу данные. Написал запрос с регулярным выражением, LEFT JOIN, INNER JOIN. Запрос с обновлением данных используя UPDATE FROM. Запрос для удаления данных с оператором DELETE используя JOIN с другой таблицей с помощью using.

### Шаг 1. Добавление данных

Добавил данные к таблицам в схема archievedata

[Step 1](https://github.com/maxyustus/RDBM_OTUS/blob/main/5.%20DML%20-%20%D0%B2%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0%2C%20%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85/insertarchievedata.sql)

Запрос на добавление данных с выводом информации о добавленных строках.

[Step 1.1](https://github.com/maxyustus/RDBM_OTUS/blob/main/5.%20DML%20-%20%D0%B2%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0%2C%20%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85/updatereturning.sql)

### Шаг 2. Запрос с регулярным выражением

Я использовал запрос из лекции по индексам.

[Step 2](https://github.com/maxyustus/RDBM_OTUS/blob/main/5.%20DML%20-%20%D0%B2%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0%2C%20%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85/regexpquery.sql)

### Шаг 3. Запросы с left/inner join

Inner join - комбинация соединений строк с неким фильтром condition. 
Left join тоже самое что inner join плюс ещё записи из левой таблицы, для которых в правой по этому фильтру ничего не совпало, поэтому порядок соединений в FROM влияет на результат. Если в правой таблице по этому фильтру ничего не совпало, то получим записи из левой таблицы  и значения null по полям из правой.

[Step 3](https://github.com/maxyustus/RDBM_OTUS/blob/main/5.%20DML%20-%20%D0%B2%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0%2C%20%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85/jointables.sql)

### Шаг 4. Запрос с обновлением данных используя UPDATE FROM 

[Step 4](https://github.com/maxyustus/RDBM_OTUS/blob/main/5.%20DML%20-%20%D0%B2%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0%2C%20%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85/updatecountry.sql)

### Шаг 5. Запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using

[Step 5](https://github.com/maxyustus/RDBM_OTUS/blob/main/5.%20DML%20-%20%D0%B2%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0%2C%20%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85/deleteusing.sql)