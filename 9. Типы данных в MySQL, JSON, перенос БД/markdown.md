## 9. Типы данных в MySQL, JSON, перенос БД
---

1. Проанализировав типы данных, решил внести следущие изменения:
   * Добавил к каждой таблице колонку ModifiedDate, чтобы отслеживать изменения данных с учётом времени, timestamp.
   * Изменил именование на camelCase с первой заглавной буквой.
   * Избавился от всех Null значений, теперь в базе нет Nullable полей.
   * Все BIGINT заменены на INT с целью экономии места на диске.
   * Добавил JSON(информация в пункт 3)

2. Перенёс всю базу данных с PostgreSQL на MySQL, внёс правки, добавил данные в некоторые таблицы. Прикладываю скрипты. 
   [part1ddl.sql](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/archievedataddl.sql)
   [part2ddl.sql](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/customersdataddl.sql)
   [part3ddl.sql](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/suppliersdataddl.sql)

3. Добавил тип JSON в структуру. В таблице ReleaseBase, где находятся данные о каждом релизе из музыкального каталога заменил поле "Tracklist" на "Attributes" JSON. В него решил добавить данные функцией JSON_OBJECT. JSON содержит 5 ключей: cat, tracklist, style, format, size. Те данные, которых как раз не хватало чтобы дополнить информацию о релизах и, по-моему субъективному мнение, их будет удобно хранить именно в этом формате.
   [insertdata(+JSON).sql](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/insertdata.sql)

4. Скрипт с запросами на выборку, добавление/удаление ключа в JSON
   [JSON_practice.sql](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/JSON_Workout.sql)

Выбрали по значению ключа "tracklist"

![select](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/Screenshot%20from%202021-10-18%2022-35-16.png)

Добавили ключ "featuring"

![addingkey](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/Screenshot%20from%202021-10-18%2022-44-07.png)

Удалим созданный ключ

![removekey](https://github.com/maxyustus/RDBM_OTUS/blob/main/9.%20%D0%A2%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20MySQL%2C%20JSON%2C%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%BE%D1%81%20%D0%91%D0%94/Screenshot%20from%202021-10-18%2022-51-35.png)
