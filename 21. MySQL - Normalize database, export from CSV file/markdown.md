### Декомпозиция и нормализация базы данных
---
### Задача:

Реализовать модель данных БД, определить сущности, построить связи, выполнить декомпозицию и нормализацию.
Исходный файл с данным:
[some-customers.csv](https://github.com/maxyustus/RDBM_OTUS/blob/main/21.%20MySQL%20-%20Normalize%20database%2C%20export%20from%20CSV%20file/some_customers.csv-25239-a24525)

### Общий комментарий: 

Cтруктура данных неоптимальна. Выделил 5 основных сущностей: customer, country, city, street, building. 
Файл с данным небольшого размера, использовал LOAD DATA, чтобы залить данные в базу. Разбивать по таблицам не стал. Предполагаю, что удобно было бы для этого создавать таблицы и использовать операторы UPDATE/MERGE/INSERT. Прикладываю SQL скрипт, там есть ещё немного комментариев.

[somecustomersscript.sql](https://github.com/maxyustus/RDBM_OTUS/blob/main/21.%20MySQL%20-%20Normalize%20database%2C%20export%20from%20CSV%20file/somecustomerscripts.sql)

В конструкторе воссоздал нормализованную модель с корректными типами данных и связями, добавились IDшники. Единственнй момент - не стал проставлять not Null значения, их можно добавить потом. Посчитал, что на данном этапе они создадут больше проблем, когда мы будем заливать данные по таблицам. Что получилось:

![some customers database](https://github.com/maxyustus/RDBM_OTUS/blob/main/21.%20MySQL%20-%20Normalize%20database%2C%20export%20from%20CSV%20file/Screen%20Shot%202022-01-13%20at%2017.02.32.png)
