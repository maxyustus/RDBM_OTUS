ALTER TABLE release_data
	ADD FOREIGN KEY (label_id)
	REFERENCES record_label;
	
ALTER TABLE release_data
	ADD FOREIGN KEY (author_id)
	REFERENCES author;
	
ALTER TABLE release_data
	ADD FOREIGN KEY (genre_id)
	REFERENCES genre;
	
ALTER TABLE release_data
	ADD FOREIGN KEY (country_id)
	REFERENCES country;
	
ALTER TABLE author_alias
	ADD FOREIGN KEY (author_id)
	REFERENCES author;