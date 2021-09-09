select * from author;
select * from author_alias;
select * from country;
select * from genre;

CREATE INDEX ON author(author_name);

CREATE INDEX ON author_alias(author_alias_id);
CREATE INDEX ON author_alias(author_alias);

CREATE INDEX ON country(country_name);

CREATE INDEX ON genre(genre_name);

CREATE INDEX ON record_label(label_name);

CREATE INDEX ON release_data(author_id);
CREATE INDEX ON release_data(country_id);
CREATE INDEX ON release_data(genre_id);
CREATE INDEX ON release_data(label_id);
/* CREATE INDEX on release_data(release_name); */
