select * from actor;


analyze actor;

CREATE INDEX actor_id_last_name ON actor(actor_id, first_name text_pattern_ops);

explain select * from actor where actor_id = 1 and last_name like 'PE%';
/* Seq Scan on actor  (cost=0.00..5.03 rows=1 width=25) */

SET enable_seqscan TO off;
explain select * from actor where actor_id = 1 and last_name like 'PE%';
/*Index Scan using actor_id_last_name on actor  (cost=0.14..8.16 rows=1 width=25)*/

SET enable_seqscan TO ON; 
DROP INDEX actor_id_last_name;