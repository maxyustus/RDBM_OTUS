delete from country_updated
	using country
where country.country_id = country_updated.country_id
returning country_updated.*;

drop table if exists country_updated;

