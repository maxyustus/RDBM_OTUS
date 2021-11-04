use vinyldb;

SELECT * FROM ReleaseBase;
SELECT * FROM SuppliedRelease;
-- Создадим копию таблицы, чтобы потренироваться
CREATE TABLE ReleaseBase2 AS SELECT * FROM ReleaseBase Limit 5;
SELECT * FROM ReleaseBase2;

-- Хочу написать хранимую процедуру для своего проекта, которая будет обновлять TotalCopies по каждому ReleaseId в таблице ReleaseBase, используя данные из таблицы SuppliedRelease.
-- Проблема в том, что один и тот же релиз приходит от разных поставщиков в таблице SuppliedRelease, поэтому нужно сначала их сгрупировать.
-- Если прописывать Id в ручную запрос будет выглядеть примерно так.
UPDATE ReleaseBase2
SET TotalCopies = (SELECT
						SUM(TotalCopies) 
				   FROM SuppliedRelease
				   WHERE ReleaseId = 1
				   GROUP BY ReleaseId)
WHERE ReleaseId = 1;
-- А хотелось бы написать процедуру, которая группировала бы данные для всех ReleaseId таблицы SuppliedRelease,
-- Затем обновляла бы их в таблице ReleaseBase по каждому ReleaseId в цикле. 

-- Я решил начать с простого, написать процедуру, где я могу поставить Id при ее вызове и она выполнит обновление.
-- Но она не создаётся, я не могу понять почему. Определённо что-то не понимаю. Подскажите пожалуйста как мне реализовать мою идею описанную выше.
DELIMITER $$
CREATE PROCEDURE UpdateTotalCopies (IN ReleaseId INT)   
BEGIN
  UPDATE ReleaseBase2 SET TotalCopies = (SELECT SUM(TotalCopies) 
  										 FROM SuppliedRelease 
  										 WHERE ReleaseId=@ReleaseId 
  										 GROUP BY ReleaseId)
  WHERE ReleaseId=@ReleaseId;
END $$
DELIMITER ;

SELECT UpdateTotalCopies(1);
-- SQL Error [1305] [42000]: FUNCTION vinyldb.UpdateTotalCopies does not exist


