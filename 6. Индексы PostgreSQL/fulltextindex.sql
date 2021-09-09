select * from film;

select description, to_tsvector(description) from film;

alter table film add column description_lexeme tsvector;

update film
set description_lexeme = to_tsvector(description);

explain select * from film where description_lexeme @@ to_tsquery('chase');
/* Seq Scan on film  (cost=0.00..391.50 rows=33 width=533) */

CREATE INDEX search_index_description ON film USING GIN (description_lexeme);
analyze film;

explain select * from film where description_lexeme @@ to_tsquery('chase');
/* Bitmap Heap Scan on film  (cost=8.51..93.77 rows=33 width=533) 
-> Bitmap Index Scan on search_index_description  (cost=0.00..8.50 rows=33 width=0) */

DROP INDEX search_index_description;