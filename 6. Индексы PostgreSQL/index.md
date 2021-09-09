## 6. Индексы PostgreSQL

---
### Общий комментарий
Создал индексы по полям таблиц в схеме archievedata. Остальную часть домашнего задания сделал на демонстрационной базе sakila т.к. в ней вполне достаточно строк и реальные данные. Реализовал индексы полнотекстового поиска, на поле с функцией и часть таблицы, индекс на несколько полей. В sql файлах к заданию прикрепил результаты explain. К сожалению, планировщик далеко не всегда хотел выполнять поиск по созданым индексам. Соответственно, оптимизировать получилось не везде. 

### 1. Cоздал индексы
[step 1](https://github.com/maxyustus/RDBM_OTUS/blob/main/6.%20%D0%98%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D1%8B%20PostgreSQL/createindexsql.sql)

### 2. Полнотекстовый поиск
[step 2](https://github.com/maxyustus/RDBM_OTUS/blob/main/6.%20%D0%98%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D1%8B%20PostgreSQL/fulltextindex.sql)

Индекс GIN для полнотекстового поиска по полю description таблицы film. Результат -  удалось оптимизировать, планировщик использует index scan и общая стоимость меньше.

### 3. Индекс по полю с функцией 
[step 3](https://github.com/maxyustus/RDBM_OTUS/blob/main/6.%20%D0%98%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D1%8B%20PostgreSQL/functionindex.sql)

Индекс по полю first_name таблицы actor с функцией initcap. Планировщик не хочет подключать индекс при поиске. Установив seq scan в off увидели, что общая стоимость по index scan выше, а значит использовать этот индекс возможно не стоит. 

### 3. Индекс на часть таблицы
[step 4](https://github.com/maxyustus/RDBM_OTUS/blob/main/6.%20%D0%98%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D1%8B%20PostgreSQL/partialindex.sql)

Индекс по полю rental_duration таблицы film, где rental_duration = 7 т.е. равна неделе. Разница почти незначительная, хотя планировщик использует индекс при поиске. В таблице всего 1000 строк.

### 4. Составной индекс

[step 5](https://github.com/maxyustus/RDBM_OTUS/blob/main/6.%20%D0%98%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D1%8B%20PostgreSQL/compositeindex.sql)

Составной индекс по полям actor_id, first_name таблицы actor. Explain показывает, что планировщик не хочет использовать индекс при поиске. Отключив seq scan мы в этом убедились. общая стоимость немного выше при index scan.