drop table users cascade;
drop table movies cascade;
drop table stuff cascade;
drop table genres cascade;
drop table scores cascade;
drop table reviews cascade;
drop table favorite_movies cascade;
drop table favorite_people cascade;
drop table stuff_movies cascade;
drop table genre_movies cascade;

drop type movie_type cascade;
drop type status cascade;

drop domain score cascade;

create type movie_type as enum ('TV', 'Movie');
create type status as enum ('Completed', 'Watching', 'Plan to watch', 'Dropped', 'On hold');

create domain score as integer check (value >= 1 and value <= 10);

create table users(
	user_id integer primary key not null,
    user_name varchar(100) not null,
    user_login varchar(20) not null,
    user_password varchar(20) not null
);

create table movies(
	movie_id integer primary key not null,
    movie_title varchar(100) not null,
    aired date not null,
    country char(2),
    movie_type movie_type not null,
    episodes integer not null,
    check (episodes > 0)
);

create table stuff(
	stuff_id integer primary key not null,
    stuff_name varchar(100) not null,
    stuff_position varchar(100) not null
);

create table genres(
	genre_id integer primary key not null,
    genre_name varchar(100) not null
);

create table scores(
	user_id integer not null,
    movie_id integer not null,
    score score,
    status status not null,  
    episodes integer not null default 0,
    primary key (user_id, movie_id),
    foreign key (user_id) references users(user_id) on delete cascade on update cascade,
    foreign key (movie_id) references movies(movie_id) on delete cascade on update cascade
);

create table reviews(
	user_id integer not null,
    movie_id integer not null,
    review text not null,
    score score,    
    primary key (user_id, movie_id),
    foreign key (user_id) references users(user_id) on delete cascade on update cascade,
    foreign key (movie_id) references movies(movie_id) on delete cascade on update cascade
);

create table favorite_movies(
	user_id integer not null,
    movie_id integer not null,
    primary key (user_id, movie_id),
    foreign key (user_id) references users(user_id) on delete cascade on update cascade,
    foreign key (movie_id) references movies(movie_id) on delete cascade on update cascade
);

create table favorite_people(
	user_id integer not null,
    stuff_id integer not null,
    primary key (user_id, stuff_id),
    foreign key (user_id) references users(user_id) on delete cascade on update cascade,
    foreign key (stuff_id) references stuff(stuff_id) on delete cascade on update cascade
);

create table stuff_movies(
	movie_id integer not null,
    stuff_id integer not null,
    primary key (movie_id, stuff_id),
    foreign key (movie_id) references movies(movie_id) on delete cascade on update cascade,
    foreign key (stuff_id) references stuff(stuff_id) on delete cascade on update cascade
);


create table genre_movies(
	movie_id integer not null,
    genre_id integer not null,
    primary key (movie_id, genre_id),
    foreign key (movie_id) references movies(movie_id) on delete cascade on update cascade,
    foreign key (genre_id) references genres(genre_id) on delete cascade on update cascade
);

