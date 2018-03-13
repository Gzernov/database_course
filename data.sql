insert into users (user_id, user_name, user_login, user_password) values 
	(1, 'Ivan Ivanov', 'II', 'secret'),
    (2, 'Petr Petrov', 'Petya99', 'nopass'),
    (3, 'Vasilii Sidorov', 'vasya', 'vasya'),
    (4, 'No name', 'noname', 'dklfghlJEOIG#*sdf')
    ;

insert into movies(movie_id, movie_title, aired, country, movie_type, episodes) values
	(1, 'Pulp fiction', '10-09-1994', 'US', 'Movie', 1),
    (2, 'Snatch', '23-08-2000', 'UK', 'Movie', 1),
    (3, 'Whiplash', '16-01-2014', 'US', 'Movie', 1),
    (4, 'Black Mirror', '04-12-2011', 'US', 'TV', 19),
    (5, 'Stranger Things', '15-07-2016', 'US', 'TV', 17);
    
insert into genres(genre_id, genre_name) values
	(1, 'Comedy'),
    (2, 'Crime'),
    (3, 'Drama'),
    (4, 'Music'),
    (5, 'Thriller'),
    (6, 'Sci-fi'),
    (7, 'Horror');
    
insert into genre_movies(movie_id, genre_id) values
	(1, 1),
    (1, 2),
    (2, 1),
    (2, 2),
    (2, 3),
    (3, 3),
    (3, 4),
    (4, 3),
    (4, 5),
    (4, 6),
    (5, 3),
    (5, 5),
    (5, 6),
    (5, 7);
    
insert into stuff(stuff_id, stuff_name, stuff_position) values
	(1, 'Guy Ritchie', 'Director'),
    (2, 'Quentin Tarantino', 'Director'),
    (3, 'Damien Chazelle', 'Director'),
    (4, 'Charlie Brooker', 'Creator'),
    (5, 'Matt Duffer', 'Creator'),
    (6, 'Ross Duffer', 'Creator');

    
insert into stuff_movies(movie_id, stuff_id) values
	(1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (5, 6);
    
insert into scores (user_id, movie_id, score, status, episodes) values
	(1, 1, null, 'Plan to watch', default),
    (1, 2, 10, 'Completed', 1),
    (1, 4, 5, 'Dropped', 10),
    (2, 5, 8, 'Completed', 17),
    (2, 4, 9, 'Completed', 19),
    (3, 1, 10, 'Completed', 1),
    (3, 2, 3, 'Dropped', 0),
    (3, 3, 10, 'Completed', 1),
    (4, 1, 7, 'Completed', 1),
    (4, 3, null, 'Plan to watch', 0);
    
insert into reviews(user_id, movie_id, review, score) values
	(1, 2, 'Masterpiece, must to watch!', 10),
    (1, 4, 'Pretty mediocre, overhyped', 5),
    (2, 4, 'Best TV show ever!', null),
    (3, 2, 'Garbage', 3),
    (4, 1, 'Good movie', 7);
