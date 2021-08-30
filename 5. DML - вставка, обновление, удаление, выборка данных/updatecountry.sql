create table archievedata.country_updated as
select * from archievedata.country;

update archievedata.country_updated
set country_name = 'United Kingdom'
where country_id = 1;

set search_path to archievedata, public;

update country
set country_name = cu.country_name
from country_updated as cu
where cu.country_id = country.country_id
returning country.country_name;

