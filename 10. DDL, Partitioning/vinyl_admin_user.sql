SELECT USER(), CURRENT_USER();
CREATE DATABASE IF NOT EXISTS vinyldb;

SHOW DATABASES;

CREATE USER IF NOT EXISTS 'vinyl_admin'@'%' IDENTIFIED BY 'vinylpassword321';
SELECT * FROM mysql.user;
SELECT user, host, db, command FROM information_schema.processlist;

GRANT ALL ON vinyldb.* TO 'vinyl_admin'@'%';
SHOW GRANTS FOR 'vinyl_admin';

USE vinyldb;

