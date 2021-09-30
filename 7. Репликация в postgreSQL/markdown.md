## Репликация в PostgreSQL
---
### Общий комментарий
Для выполнения работы использовал gcloud. Поднял виртуальную машину. Установил PostgreSQL 13. Поднял два кластера postgres(5432 и 5433 порт). Далее результаты всех команд и процесс зафиксировал на скриншотах с комментариями.
### 1. Настройка физической репликации
    На скриншотах, где два терминала - мастер слева, реплика - справа
1. На мастере в postgresql.conf и pg_hba.conf исправил адрес на нужный. Добавил таблицу testtable и залил немного данных.
2. Дополнительно в postgresql.conf указал параметр wal_receiver_status_interval в 300 секунд согласно заданию.
3. Создал слот репликации node_a_slot, используя документацию.
4. На реплике удалил все файлы из директории и восстановил с мастера с помощью pg_basebackup
5. Настроил параметры необходимые для работы слота репликации в postgresql.conf. Убедимся, что он теперь active.
![slotisworking](https://github.com/maxyustus/RDBM_OTUS/blob/main/7.%20%D0%A0%D0%B5%D0%BF%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B2%20postgreSQL/replication%20slot%20is%20working.png)
6. Посмотрим результат pg_stat_replication. Добавим еще данных и повторно посмотрим результат pg_stat_replication.
![pgstatreplication](https://github.com/maxyustus/RDBM_OTUS/blob/main/7.%20%D0%A0%D0%B5%D0%BF%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B2%20postgreSQL/pgstatreplication.png)
7. В дополнение, выйдем из psql и посмотрим на процессы командой ps на мастере и на реплике. Видим, что всё получилось.
![Processing](https://github.com/maxyustus/RDBM_OTUS/blob/main/7.%20%D0%A0%D0%B5%D0%BF%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B2%20postgreSQL/processing.png)

### 2. Настройка логической репликации.
1. Запромоутим реплику.
2. На публикаторе изменим параметр wal_level = logical.
3. Создадим таблицу test и добавим данные.
4. Создадим публикацию, проверим \dRp+
P.S. Немного ошибся со скриншотами. Сначала создал таблицу в базе postgres, потом заметил и решил переделать, создал базу replicadb и уже потом в ней таблицу и подписку. Но скриншот новый сделать забыл. Дальше на скришотах уже будет видно, что мы работаем с базой replicadb
5. ![publication](https://github.com/maxyustus/RDBM_OTUS/blob/main/7.%20%D0%A0%D0%B5%D0%BF%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B2%20postgreSQL/publication.png)
6. На подписчике создадим такую же таблицу и создадим подписку. Проверим pg_stat_subcription. Видим созданную подписку. Проверим данные. Данные на месте.
7. ![logical complete](https://github.com/maxyustus/RDBM_OTUS/blob/main/7.%20%D0%A0%D0%B5%D0%BF%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B2%20postgreSQL/logical%20complete.png)

