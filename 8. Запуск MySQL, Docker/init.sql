CREATE database vinyldb;
USE vinyldb;
CREATE TABLE release (
	id INT PRIMARY KEY NOT,
	releaseName VARCHAR(50) NOT NULL,
	labelId INT NOT NULL,
	authorId INT NOT NULL,
	genreId INT NOT NULL,
	countryId INT NOT NULL,
	tracklist VARCHAR(100) NOT NULL,
	releaseData DATE NOT NULL
	);

