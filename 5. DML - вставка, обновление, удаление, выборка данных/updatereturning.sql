insert into archievedata.country
(country_id, country_name)
values(4, 'France')
returning country_id, country_name;