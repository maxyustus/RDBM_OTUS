## Percona XtraDB Cluster
---

###  Общий комментарий:
В целях ознакомления развернём XtraDB Cluster от Percona.
Прикладываю скриншоты с комментариями. 

* Развернем 3 ВМ для кластера PXC(mysql1, mysql2, mysql3), установим mysql
![Gcloud VMs](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/1.%20%D0%A0%D0%B0%D0%B7%D0%B2%D0%B5%D1%80%D0%BD%D1%83%D0%BB%D0%B8%203%20%D0%92%D0%9C%20%D0%B4%D0%BB%D1%8F%20PXC.png)

* Установим кластер на всех нодах. Сконфигурируем кластер: зададим ip внутренней сети и имя ноды. Бутстрапим 1 ноду.Добавим другие ноды. Посмотрим статус: *show status like 'wsrep%';* И ничего не заработало =/
![show status like 'wsrep%'](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/2.%20%D0%91%D1%83%D1%81%D1%82%D1%80%D0%B0%D0%BF%D0%B8%D0%BC%20%D0%BD%D0%BE%D0%B4%D1%83%20%D0%B8%20%D1%81%D0%BC%D0%BE%D1%82%D1%80%D0%B8%D0%BC%20%D1%81%D1%82%D0%B0%D1%82%D1%83%D1%81%20wsrep.png)
* Решаем проблему с ключами, на mysql1, mysql2 удаляем */var/lib/mysql/server-key.pem && rm /var/lib/mysql/ca.pem && rm /var/lib/mysql/server-cert.pem* Затем копируем ключи с первой ноды утилитой scp. Возвращаем права mysql, так копировали под рутом. 
![Fix keys](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/3.%20%D1%84%D0%B8%D0%BA%D1%81%D0%B8%D0%BC%20%D0%BA%D0%BB%D1%8E%D1%87%D0%B8.png)
* *show status like 'wsrep%';* wsrep_cluster_size = 3. Ок
![Fix keys](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/4.%20wsrep%20%D1%82%D0%B5%D0%BF%D0%B5%D1%80%D1%8C%203%20%D0%BD%D0%BE%D0%B4%D1%8B.png)
* Добавим немного данных, внимание на id.
![data](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/5.%20%D0%94%D0%BE%D0%B1%D0%B0%D0%B2%D0%B8%D0%BC%20%D0%BD%D0%B5%D0%BC%D0%BD%D0%BE%D0%B3%D0%BE%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%2C%20%D0%B2%D0%BD%D0%B8%D0%BC%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%BD%D0%B0%20id.png)
* Поставим proxySQL для Load Balancing. Для этого развернём еще одну ВМ и установим всё необходимое. Добавим наши кластерные ноды. Что получилось - *SELECT * FROM mysql_servers;*
![mysql_servers](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/7.%20%D0%94%D0%BE%D0%B1%D0%B0%D0%B2%D0%B8%D0%BC%20%D0%BD%D0%BE%D0%B4%D1%8B%20%D0%B2%20ProxySQL.png)
* Но несмотря на наличие серверов, ничего работать не будет. Необходимо добавить изменения в RUNTIME, а потом на DISK, так как у ProxySQL есть 3 области, где находятся конфигурационные настройки, а MEMORY, RUNTIME, DISK. Когда мы их меняем, изменения происходят только в MEMORY. *SELECT hostgroup_id,hostname,port,status FROM runtime_mysql_servers;*
![Loading configs](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/8.%20%D0%A1%D1%82%D0%B0%D1%82%D1%83%D1%81%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0.png)
* Добавим юзера на любую ноду, так как у нас мультимастер и пропишем его в настройках on pxcps, загрузим конфигурацию VARIABLES в оперативную память. Затем создадим ProxySQL Client User. Чтобы не потерять текущую конфигурацию USERS, запишем ее на диск. Не забываем поставить  mysql_native_password вместо caching_sha2_password, иначе работать не будет. 
Наконец залогинимся под созданным юзером и проверим наши данные. Данные на месте.
![Check data from pxcps](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/10.%20%D0%9F%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%B8%D0%BC%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%20pxcps.png)
* Попробуем добавить еще данных с любой нашей ноды, например с mysql2. Проверим данные с pxcps ноды. Видим добавленные данные. Всё работает.
![Check data from pxcps after change](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/11.%20%D0%94%D0%BE%D0%B1%D0%B0%D0%B2%D0%B8%D0%BC%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%20%D0%BB%D1%8E%D0%B1%D0%BE%D0%B8%CC%86%20%D0%BD%D0%BE%D0%B4%D1%8B.png)
* Проверим отказоустойчивость, уроним mysql2. На pxcps ноде: *SELECT hostgroup_id,hostname,port,status FROM mysql_servers; SELECT hostgroup_id,hostname,port,status FROM runtime_mysql_servers;*
![mysql2 shunned](https://github.com/maxyustus/RDBM_OTUS/blob/main/19.%20MySQL%20-%20Percona%20XtraDB%20Cluster/12.%20%D0%9F%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%B8%D0%BC%20%D0%BE%D1%82%D0%BA%D0%B0%D0%B7%D0%BE%D1%83%D1%81%D1%82%D0%BE%D0%B8%CC%86%D1%87%D0%B8%D0%B2%D0%BE%D1%81%D1%82%D1%8C.png)

Таким образом мы собрали XtraDB Cluster от Percona. 