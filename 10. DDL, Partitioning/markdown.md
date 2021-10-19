### 10. DDL, Partitioning
---
Выполнить задание по партиционированию решил на таблице Genre по ключу GenreId. Partition by range. Таким образом мы разделим нашу таблицу на 3 партиции.
Скрипт 
[partitioningbyrange](https://github.com/maxyustus/RDBM_OTUS/blob/main/10.%20DDL%2C%20Partitioning/partitionbyrange.sql)

Посмотрим распределение строк по партициям

![frominfoschema](https://github.com/maxyustus/RDBM_OTUS/blob/main/10.%20DDL%2C%20Partitioning/Screenshot%20from%202021-10-19%2017-24-30.png)


Выберем данные из партиции p1
![datafrompartition](https://github.com/maxyustus/RDBM_OTUS/blob/main/10.%20DDL%2C%20Partitioning/Screenshot%20from%202021-10-19%2017-24-54.png)