select * from Genre;
SELECT * FROM Author;
SELECT * FROM RecordLabel;
SELECT * FROM Country;
SELECT * FROM ReleaseBase;
DESC ReleaseBase;
ALTER TABLE ReleaseBase CHANGE ReleaseData ReleaseDate DATE NOT NULL;


DESC RecordLabel;
ALTER TABLE RecordLabel CHANGE LabelName LabelName VARCHAR(50) NOT NULL;

INSERT INTO Genre
(GenreId, GenreName, ModifiedDate)
VALUES(1, 'house', now()),
	  (2, 'techno', now()),
	  (3, 'disco', now()),
	  (4, 'minimal', now()),
	  (5, 'trance', now()),
	  (6, 'downtempo', now()),
	  (7, 'electro', now()),
	  (8, 'breaks', now());

INSERT INTO Author
(AuthorId, AuthorName, Biography, Website, Photo, ModifiedDate)
VALUES(1, 'Adam Pits', 'some biography', 'https://soundcloud.com/adampits', 'some photo', now()),
	  (2, 'Desert Sound Colony', 'British artist Desert Sound Colony runs the label Holding Hands as well as releasing music on a wide spectrum of underground labels.', 
	  'https://soundcloud.com/desertsoundcolony', 'some photo', now()),
	  (3, 'Alex Kassian', 'DJ and music producer based in Berlin. Co-founder of Planet Sundae.', 
	  'https://soundcloud.com/alexkassian', 'some photo', now());
	  
INSERT INTO RecordLabel
(LabelId, LabelName, Website, LabelArtwork, Email, ModifiedDate)
VALUES(1, 'Holding Hands', 'https://soundcloud.com/holdinghandsrecords', 'some artwork', 'holdinghandsrecords@gmail.com', now()),
	  (2, 'Touch From A Distance', 'https://touchfromadistance.com/', 'some artwork', 'samplewebsite@gmail.com', now()),
	  (3, 'Love On The Rocks', 'https://soundcloud.com/loveontherocks', 'some artwork', 'info@loveontherocks.cc', now());
	  
INSERT INTO Country
(CountryId, CountryName, ModifiedDate)
VALUES(1, 'United Kigndom', now()),
	  (2, 'Germany', now()),
	  (3, 'United States', now());

INSERT INTO ReleaseBase
(ReleaseId, ReleaseName, LabelId, AuthorId, GenreId, CountryId, 
Attributes, 
ReleaseDate, TotalCopies, AvailableCopies, AverageRating, ReleaseArtwork, ModifiedDate)
 VALUES(1, 'Stagga', 1, 1, 7, 1, 
		JSON_OBJECT(
        "cat" ,
        "HHANDS009" ,
        "style" ,
        JSON_ARRAY("breaks" , "bass music" , "electro") ,
        "tracklist" ,
        JSON_ARRAY("A1 - Stagga" , "B1 - Pest Control" , "B2 - Stagga(OCB Remix)") ,
        "format" ,
        "EP" ,
        "size" ,
        "12"), 
        '03.08.2019', 300, 300, 4.62, "release artwork", now()),
        
	(2, 'Fast Life', 2, 2, 1, 2,
       JSON_OBJECT(
        "cat" ,
        "TFAD 1" ,
        "style" ,
        JSON_ARRAY("leftfield" , "house") ,
        "tracklist" ,
        JSON_ARRAY("A1 - Fast Life" , "A2 - Somehow I Talk" , "B1 - Finger Flies" , "B2 - Glixen") ,
        "format" ,
        "EP" ,
        "size" ,
        "12"),
       '01.07.2018', 300, 300, 4.39, "release artwork", now()),
       
	(3, 'Oolong Trance Ep', 3, 3, 5, 2,
       JSON_OBJECT(
        "cat" ,
        "LOTR022" ,
        "style" ,
        JSON_ARRAY("house" , "trance") ,
        "tracklist" ,
        JSON_ARRAY("A1 - Oolong Trance (Club Mix)" , "A2 - Oolong Trance (Paradise Mix)" , "B1 - Oolong Trance (Telephones ADHS Remix)") ,
        "format" ,
        "EP" ,
        "size" ,
        "12"),
       '01.01.2020', 300, 300, 4.92, "release artwork", now());
	  
	
