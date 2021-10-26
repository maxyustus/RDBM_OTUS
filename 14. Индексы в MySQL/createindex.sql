use vinyldb;

SELECT * FROM Author LIMIT 5;
SELECT * FROM AuthorAlias LIMIT 5;
SELECT * FROM Country LIMIT 5;
SELECT * FROM Genre LIMIT 5;
SELECT * FROM RecordLabel LIMIT 5;
SELECT * FROM ReleaseBase LIMIT 5;
SELECT * FROM SuppliedRelease LIMIT 5;
SELECT * FROM Supplier LIMIT 5; 

SHOW INDEX FROM Supplier;

-- Author
CREATE INDEX AuthorNameIdx ON Author(AuthorName);

-- AuthorAlias
CREATE INDEX AuthorIdIdx ON AuthorAlias(AuthorId);
CREATE INDEX AuthorAliasIdx ON AuthorAlias(AuthorAlias);

-- Country
CREATE UNIQUE INDEX CountryNameIdx ON Country(CountryName);

-- Genre
CREATE UNIQUE INDEX GenreNameIdx ON Genre(GenreName);

-- RecordLabel
CREATE UNIQUE INDEX LabelNameIdx ON RecordLabel(LabelName);

-- ReleaseBase
CREATE INDEX ReleaseNameIdx ON ReleaseBase(ReleaseName);
CREATE INDEX LabelIdIdx ON ReleaseBase(LabelId);
CREATE INDEX AuthorIdIdx ON ReleaseBase(AuthorId);
CREATE INDEX GenreIdIdx ON ReleaseBase(GenreId);
CREATE INDEX CountryIdIdx ON ReleaseBase(CountryId);
-- Не получается создать индекс на поле JSON по атрибуту 'cat'. 
/*
CREATE UNIQUE INDEX CatIdx ((CAST(Attributes->>'$.cat' AS CHAR(30))));
CREATE INDEX CatIdx ((JSON_VALUE(Attributes, '$.cat' RETURNING CHAR(30))));
*/
-- SuppliedRelease
CREATE INDEX SupplierIdIdx ON SuppliedRelease(SupplierId);
CREATE INDEX ReleaseIdIdx ON SuppliedRelease(ReleaseId);

-- Supplier
CREATE UNIQUE INDEX SupplierNameEmailIdx ON Supplier(SupplierName, Email);
-- меняем тип с varchar на text и создадим индекс на полнотекстовый поиск
ALTER TABLE Supplier MODIFY SupplierInfo TEXT NOT NULL;
CREATE FULLTEXT INDEX SupplierNameInfoFullTextIdx ON Supplier(SupplierName, SupplierInfo);
-- Видим, что индекс работает
-- type:fulltext , key/possible_key:SupplierNameInfoFullTextIdx
EXPLAIN SELECT * FROM Supplier WHERE MATCH (SupplierName, SupplierInfo) AGAINST ('biggest');
EXPLAIN SELECT * FROM Supplier WHERE MATCH (SupplierName, SupplierInfo) AGAINST ('akwax');

 

