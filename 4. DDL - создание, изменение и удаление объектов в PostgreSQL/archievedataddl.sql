CREATE TABLE IF NOT EXISTS archievedata.record_label(
	label_id bigint PRIMARY KEY,
	label_name varchar(50) NOT NULL,
	website varchar(50) NULL,
	label_artwork varchar(255) NULL,
	email varchar(50) NULL
);

CREATE TABLE IF NOT EXISTS archievedata.country(
	country_id bigint PRIMARY KEY,
	country_name varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS archievedata.author(
	author_id bigint PRIMARY KEY,
	author_name varchar(50) NOT NULL,
	biography varchar(255) NULL,
	website varchar(50) NULL,
	photo varchar(255) NULL
);

CREATE TABLE IF NOT EXISTS archievedata.author_alias(
	author_alias_id bigint PRIMARY KEY,
	author_id bigint NOT NULL,
	author_alias varchar(50) NULL
);

CREATE TABLE IF NOT EXISTS archievedata.release(
	release_id bigint PRIMARY KEY,
	serial_id bigserial NOT NULL,
	release_name varchar(50) NOT NULL,
	label_id bigint NOT NULL,
	author_id bigint NOT NULL,
	genre_id bigint NOT NULL,
	country_id bigint NOT NULL,
	tracklist varchar(255) NOT NULL,
	release_data date NOT NULL,
	total_copies int NOT NULL CHECK (total_copies >= 0),
	available_copies int NOT NULL CHECK (available_copies >= 0),
	average_rating numeric(2,1) NULL,
	release_artwork varchar(255) NULL
);

CREATE TABLE IF NOT EXISTS archievedata.genre(
	genre_id bigint PRIMARY KEY,
	genre_name varchar(50) NOT NULL
);
