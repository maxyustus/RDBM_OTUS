## Apache Cassandra with JPA
---

### Задача:
Сравнить драйвера к Cassandra по производительности и потреблению ресурсов.

1. Забрал репозиторий отсюда https://github.com/hands-on-tech/cassandra-jpa-example.
2. Поставили Java и Maven, собрали jar'ник и затем Docker image.
3. Стартуем docker контейнеры.
4. Посмотрим логи `docker logs cassandra-jpa-example_java_1 -f`.
5. Результаты на скриншоте: число репетиций (5), в  каждой репетиции число операций (10000). Значения по столбцам по каждому типу операции(WRITE, READ, UPDATE, DELETE) в msec - total, max, min, avg.
![docker logs](https://github.com/maxyustus/RDBM_OTUS/blob/main/23.%20Apache%20Cassandra%20with%20JPA/appache_cassandra_JPA_test.png)


**Выводы**
По всем типам операций лидирует Datastax ORM. Лучшие показатели из всех 4 драйверов. Нет никаких всплесков, каждая репетиция по любому типу от 4 до 5.6 сек. на 10к операций. 
Остальные драйверы чуть хуже, встречаются вплески до 10-11сек. на репетицию и суммарное время за 5 репетиций в диапозоне 23.5 - 31 сек.

В процессе выполнения тестов, используемый CPU достигал 70%. MEM USAGE - 1.118GiB/3.833GiB ~ 30-38% MEM.
