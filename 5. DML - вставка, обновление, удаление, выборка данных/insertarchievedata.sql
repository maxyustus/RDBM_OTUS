insert into archievedata.genre
(genre_id, genre_name)
values(1, 'house'),
	  (2, 'techno'),
	  (3, 'disco'),
	  (4, 'minimal'),
	  (5, 'trance'),
	  (6, 'downtempo'),
	  (7, 'electro'),
	  (8, 'breaks');

insert into archievedata.author
(author_id, author_name, biography, website, photo)
values(1, 'Adam Pits', null, 'https://soundcloud.com/adampits', null),
	  (2, 'Desert Sound Colony', 'British artist Desert Sound Colony runs the label Holding Hands as well as releasing music on a wide spectrum of underground labels.', 
	  'https://soundcloud.com/desertsoundcolony', null),
	  (3, 'Alex Kassian', 'DJ and music producer based in Berlin. Co-founder of Planet Sundae.', 
	  'https://soundcloud.com/alexkassian', null);
	  
insert into archievedata.record_label
(label_id, label_name, website, label_artwork, email)
values(1, 'Holding Hands', 'https://soundcloud.com/holdinghandsrecords', null, 'holdinghandsrecords@gmail.com'),
	  (2, 'Touch From A Distance', 'https://touchfromadistance.com/', null, null),
	  (3, 'Love On The Rocks', 'https://soundcloud.com/loveontherocks', null, 'info@loveontherocks.cc');
	  
insert into archievedata.country
(country_id, country_name)
values(1, 'United Kigndom'),
	  (2, 'Germany'),
	  (3, 'United States');

insert into archievedata.release
(release_id, release_name, label_id, author_id, genre_id, country_id, tracklist, release_date, 
 total_copies, available_copies, average_rating, release_artwork)
 values(1, 'Stagga', 1, 1, 7, 1, 'A - Stagga, B1 - Pest Control, B2 - Stagga(OCB remix)', '03/08/2019',
	   300, 300, 4.62, null),
	   (2, 'Fast Life', 2, 2, 1, 2, 'A1 - Fast Life, A2 - Somehow I Feel, B1 - Finger Flies, B2 - Glixen', '01/07/2018',
	   300, 300, 4.39, null),
	   (3, 'Oolong Trance Ep', 3, 3, 5, 2, 'A1 - Oolong Trance(Club Mix), B1 - Oolong Trance(Paradise Mix), 
		B2 - Oolong Trance(Telephones ADHS Remix)', '01/01/2020', 300, 300, 4.92, null);
	  
	