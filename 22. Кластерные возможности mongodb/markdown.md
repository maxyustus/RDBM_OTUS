## Кластерный возможности MongoDB
---
### Предисловие
Собираем репликасет с арбитром, 2 реплика сета с конфигурацией шардов. Разворачиваем на gcloud, ubuntu 20.04 LTS. Для удобства всё проделаем на 1 ВМ, будем форкать процессы. Пройдёмся по шагам с комментариями. Ниже после сборки скрипт для настройки многоролевого доступа с аутентификацией.

* Развернём ВМ на gcloud, установим MongoDB 4.4.9. Подключимся по ssh, подготовим директории для реплика сета. Форкнем child processes. Посмотрим, что процессы успешно запущены.

![fork child process, create replica set](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/1.%20fork%20child%20process%2C%20create%20replicat%20set.png)

* Подключимся к mongo shell, проверим статус кластера *rs.status()*. Видим, что кластер не проинициализирован.

![check status](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/2.%20check%20status.png)

* Проинициализируем кластер, проверим статус ещё раз."majorityVoteCount" : 2. Через некоторое время SECONDARY->PRIMARY после голосования.

![initiate cluster, check status](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/3.%20initialize%20cluster.%20check%20status.png)

* Добавим 4 ноду и проверим статус ещё раз. 

![add 4th node, check status](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/4.%20add%204th%20node%2C%20check%20status.png)

* Попробуем добавить тестовых данных. Затем попробуем развернуть 2 реплика сета с конфигурацией шардов. 

![add some data, check the data](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/5.%20add%20some%20data%2C%20check%20the%20data.png)

* Развернем ВМ mongo 4.4.9. Подготовим директории, создадим 2 реплика сета с конфигурацией шарда, снова форкнем процесс.

![replica set with sharding configuration](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/9.%20create%202%20replica%20set%20with%20sharding%20configuration.png)

* Проверим процессы и проинициализируем кластер.

![initiate cluster, check processing](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/10.%20Check%20processing%20and%20initialize%20cluster.png)

* Создадим шардированный кластер. Для этого снова форкаем процесс и дополнительно запустим в 2 экземплярах для отказоустойчивости.

![cluster with sharding configuration](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/12.%20create%20cluster%20with%20sharding%20configuration.png)

* Подключимся к mongo shell и добавим шарды.

![add shards](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/13.%20fork%20process%20twice%20and%20add%20shards.png)

* Проверим статус. Шарды добавили.

![check status](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/14.%20check%20status.png)

* Посмотрим загрузку htop. 

![check the load](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/15.%20checking%20the%20load.png)

* Теперь посмотрим как данные будут разъезжаться по шардам. Для этого сначала включим шардирование, нагенерим данных, укажем ключ. Понаблюдаем за статусом кластера. 

![generate data, balancing](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/16.%20generate%20some%20data%2C%20enable%20sharding%2C%20check%20status.png)

* Данные генерятся, разбиваются на чанки и происходит процесс балансировки. Через минут 15 проверим ещё раз. Видим, что данные
разбились равномерно по 512 чанков на каждый шард.

![chuncks are scattered across evenly](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/18.%20data%20chuncks%20scattered%20across%20shadrs%20evenly%20.png)

* Для настройки аутентификации и многоролевого доступа создадим юзеров с указанием роли. Роли можно создавать самостоятельно, также есть много встроенных ролей, с правами которых можно ознакомиться в документации. Для примера я создал readonly юзера с ролью "read". Перезапустим сервер с аутентификацией, для этого форкнем процесс. После этого при подключении без указания пользователя и пароля никакие данные посмотреть не получится. При аутентификации под конкретным пользователем ему будут доступны только те ресурсы и права, на которые выдан доступ. Прикрепляю небольшой markdown файл с примерами. 

[managing roles and users](https://github.com/maxyustus/RDBM_OTUS/blob/main/22.%20%D0%9A%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20mongodb/Managing_roles_and_users.md)