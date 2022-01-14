## MySQL - InnoDB Cluster 
---

### Общий комментарий:
Собираем MySQL InnoDB Cluster кластер из 3 ВМ на Gcloud.
Ниже скриншоты с комментариями по шагам сборки.

* Развернём 3 ВМ, установим mysql && shell.

![3 gcloud vms configure](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/1.%203%20vms%20and%20mysql%20shell.png)

* Попробуем собрать по документации. Cконфигурируем инстанс, заодно включатся GTID и т.д. Подключим ноды. Что получили:
* 
![configure instances](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/2.%20configure%20instances.png)

* Рабочий вариант: прописываем ipAllowList и добавляем ноды. Снова проверим статус. *cluster.status()*
"Cluster is ONLINE and can tolerate up to ONE failure." Кластер собрали.

![cluster is online](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/3.%20%D1%81%D0%BE%D0%B1%D0%B5%D1%80%D0%B5%D0%BC%20%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%2C%20%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%B8%D0%BC.png)

* Попробуем переключить в мультимастер. 
*cluster.switchToMultiPrimaryMode()*

*[multimaster switch](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/4.%20multimaster%20switch.png)

*  Выдадим себе гранты выдадим из под MYSQL. 

![grants](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/5.%20grant%20all.png)

* С любой ноды(у нас мультимастер) создадим базу данных и с проверим её наличие на другой ноде.

![create db and check](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/6.%20create%20db%20and%20check.png)

* Установим и сконфигурируем mysql-router, для этого нужен или чистый инстанс или мастер нода. Подключимся *mysql -P 6446 -u root -p* . Работает.

![install and configure router](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/7.%20install%20and%20configure%20router.png)

* Кластер мы собрали, проверим отказоустойчивость, уроним ноду innodb1. На второй ноде посмотрим статус кластера - 
*cluster.status()* . "Cluster is NOT tolerant to any failures. 1 member is not active. status: (MISSING)".

![node shutdown](https://github.com/maxyustus/RDBM_OTUS/blob/main/20.%20MySQL%20-%20InnoDB%20Cluster/8.%20%D1%83%D1%80%D0%BE%D0%BD%D0%B8%D0%BC%20%D0%BD%D0%BE%D0%B4%D1%83.png)