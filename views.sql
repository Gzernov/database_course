drop view if exists movie_lists;
drop view if exists movies_by_genre;
drop view if exists average_scores;
drop view if exists favourite_genres;

create view movie_lists as (
	select 
    	user_name, 
    	movie_title,
    	score,
    	status,
    	scores.episodes
    from users 
    natural join scores
    inner join movies on movies.movie_id = scores.movie_id
);

create view movies_by_genre as (
	select
        count(*),
        genre_name,
        genre_id
    from genre_movies
    natural join genres
    group by genre_id, genre_name
    order by count desc
);

create view average_scores as (
	select 
        avg(score),
        count(*),
        movie_title,
        movies.movie_id
    from scores
    inner join movies on movies.movie_id = scores.movie_id
    where
    	score is not null
    group by movies.movie_id, movie_title
    order by avg desc
);

create view favourite_genres as (
	select
       avg(score),
        count(*),
        genre_name,
        genres.genre_id
    from scores
    inner join movies on movies.movie_id = scores.movie_id 
    inner join genre_movies on movies.movie_id = genre_movies.movie_id
    natural join genres
    where
    	score is not null
    group by genres.genre_id, genre_name
    order by avg desc
);