ALTER TABLE release
RENAME TO release_data;

select label_name, rd.* from record_label left join release_data as rd
	using(label_id);
	
select * from release_data left join genre as ge
	using(genre_id);
	
select author_name, rd.* from author as au inner join release_data as rd on true
	where au.author_id = rd.author_id;
	
select country_name, rd.* from country as cy inner join release_data as rd on 1 = 1
	where cy.country_id = rd.country_id;
	
select au.author_name, rl.label_name, ge.genre_name, rd.release_name, rd.tracklist, rd.release_date, rd.available_copies
from release_data as rd
	join author as au on rd.author_id = au.author_id
	join record_label as rl on rd.label_id = rl.label_id
	join genre as ge on rd.genre_id = ge.genre_id;

	 