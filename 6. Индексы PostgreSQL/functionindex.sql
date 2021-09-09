select * from actor;

CREATE INDEX initcap_first_name_idx ON actor(INITCAP(first_name));
analyze actor;

explain select actor_id from actor where INITCAP(first_name) = INITCAP('PENELOPE');
/* Seq Scan on actor  (cost=0.00..5.03 rows=4 width=4) */
SET enable_seqscan TO off;
/* Bitmap Heap Scan on actor  (cost=4.18..6.24 rows=4 width=4)
-> Bitmap Index Scan on initcap_first_name_idx  (cost=0.00..4.17 rows=4 width=0)*/
SET enable_seqscan TO ON;