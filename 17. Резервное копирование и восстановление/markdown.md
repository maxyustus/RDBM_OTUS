## Резервное копирование и восстановление в MySQL
---
### Что сделано
* Подняли тестовый стенд на gcloud, поставили mysql и xtrabackup от percona. И удалим сдержимое /var/lib/mysql
* На тестовый стенд gcloud скопировали бэкап файл утилитой scp.
![scp](https://github.com/maxyustus/RDBM_OTUS/blob/main/17.%20%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5%20%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B8%20%D0%B2%D0%BE%D1%81%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/Screenshot%20from%202021-11-09%2018-04-16.png)
* Распакуем зашифрованный бэкап
![unzipdecode](https://github.com/maxyustus/RDBM_OTUS/blob/main/17.%20%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5%20%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B8%20%D0%B2%D0%BE%D1%81%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/Screenshot%20from%202021-11-09%2018-07-17.png)
* Раскроем содержимое в текущую директорию, проверим. Данные на месте. 
![xbstream](https://github.com/maxyustus/RDBM_OTUS/blob/main/17.%20%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5%20%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B8%20%D0%B2%D0%BE%D1%81%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/Screenshot%20from%202021-11-09%2018-22-47.png)
* Восстановимся с нашего бэкапа. Проверим содержимое var/lib/mysql, данные на месте. Не забываем поменять права. Стартуем MySQL. 
![backup](https://github.com/maxyustus/RDBM_OTUS/blob/main/17.%20%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5%20%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B8%20%D0%B2%D0%BE%D1%81%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/Screenshot%20from%202021-11-09%2018-32-01.png)
* В базе русских городов оказалось 189 штук. 
![checkthenumber](https://github.com/maxyustus/RDBM_OTUS/blob/main/17.%20%D0%A0%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%BD%D0%BE%D0%B5%20%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B8%20%D0%B2%D0%BE%D1%81%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/Screenshot%20from%202021-11-09%2018-34-26.png)
