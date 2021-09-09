CREATE INDEX week_rental_duration ON film(rental_duration) where rental_duration = 7;
analyze film;

explain select * from film where rental_duration = 7;
/* with week_rental_duration index 
Bitmap Heap Scan on film  (cost=9.15..66.54 rows=191 width=15) */
explain (analyze) select * from film where rental_duration = 7;
/*Bitmap Heap Scan on film  (cost=9.15..66.54 rows=191 width=386) 
(actual time=0.047..0.163 rows=191 loops=1)*/

explain select * from film where rental_duration = 7;
/* without week_rental_duration 
Seq Scan on film  (cost=0.00..67.50 rows=191 width=15) */
explain (analyze) select * from film where rental_duration = 7;
/*Seq Scan on film  (cost=0.00..67.50 rows=191 width=386) 
(actual time=0.012..0.339 rows=191 loops=1)*/
select relpages from pg_class where relname='week_rental_duration';

DROP INDEX week_rental_duration;