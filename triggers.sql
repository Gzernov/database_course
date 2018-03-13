drop trigger if exists delete_movie_trigger on movies;
drop trigger if exists delete_stuff_trigger on stuff;
drop trigger if exists delete_genre_trigger on genres;
drop trigger if exists insert_user_score_trigger on scores;

create or replace function delete_movie_trigger_function()
  returns trigger as
$$
declare
    rec record;
    person record;
    genre record;
begin
	ALTER TABLE stuff DISABLE TRIGGER delete_stuff_trigger;
    ALTER TABLE genres DISABLE TRIGGER delete_genre_trigger;
	for rec in (select
               		*
              	from stuff_movies
                	where stuff_movies.movie_id = OLD.movie_id) loop
		for person in (select
                      count (*)
                      from 
                      stuff_movies 
                      where stuff_movies.stuff_id = rec.stuff_id) loop
		if (person.count = 1) then
        	delete from stuff
            	where stuff_id = rec.stuff_id;
        end if;
        end loop;
    end loop;
    
    for rec in (select
               		*
              	from genre_movies
                	where genre_movies.movie_id = OLD.movie_id) loop
		for genre in (select
                      count (*)
                      from 
                      genre_movies 
                      where genre_movies.genre_id = rec.genre_id) loop
		if (genre.count = 1) then
        	delete from genres
            	where genre_id = rec.genre_id;
        end if;
        end loop;
    end loop;
    ALTER TABLE stuff enable TRIGGER delete_stuff_trigger;
    ALTER TABLE genres enable TRIGGER delete_genre_trigger;
    return old;
end;
$$
LANGUAGE plpgsql;

create trigger delete_movie_trigger before delete on movies
    FOR EACH row EXECUTE PROCEDURE delete_movie_trigger_function();
    


create or replace function delete_stuff_trigger_function()
  returns trigger as
$$
declare
    rec record;
    movie record;
begin
	ALTER TABLE movies DISABLE TRIGGER delete_movie_trigger;
	for rec in (select
               		*
              	from stuff_movies
                	where stuff_movies.stuff_id = OLD.stuff_id) loop
		for movie in (select
                      count (*)
                      from 
                      stuff_movies 
                      where stuff_movies.movie_id = rec.movie_id) loop
		if (movie.count = 1) then
        	delete from movies
            	where movie_id = rec.movie_id;
        end if;
        end loop;
    end loop;
    
    ALTER TABLE movies enable TRIGGER delete_movie_trigger;
    return old;
end;
$$
LANGUAGE plpgsql;

create trigger delete_stuff_trigger before delete on stuff
    FOR EACH row EXECUTE PROCEDURE delete_stuff_trigger_function();
    
    

create or replace function delete_genre_trigger_function()
  returns trigger as
$$
declare
    rec record;
    movie record;
begin
	ALTER TABLE movies DISABLE TRIGGER delete_movie_trigger;
	for rec in (select
               		*
              	from genre_movies
                	where genre_movies.genre_id = OLD.genre_id) loop
		for movie in (select
                      count (*)
                      from 
                      genre_movies 
                      where genre_movies.movie_id = rec.movie_id) loop
		if (movie.count = 1) then
        	delete from movies
            	where movie_id = rec.movie_id;
        end if;
        end loop;
    end loop;
    ALTER TABLE movies enable TRIGGER delete_movie_trigger;
    return old;
end;
$$
LANGUAGE plpgsql;

create trigger delete_genre_trigger before delete on genres
    FOR EACH row EXECUTE PROCEDURE delete_genre_trigger_function();
    
create or replace function check_score(score score, status status, episodes integer) returns void as
$$
begin
	if (status = 'Plan to watch') then
    	if (score is not null) then
        	raise exception 'score for plan to watch title';
        end if;
        if (episodes != 0) then
        	raise exception 'non zero episodes completed for plan to watch title';
        end if;
    end if;
end;
$$
LANGUAGE plpgsql;

create or replace function insert_user_score() returns trigger as
$$
declare
	i int;
    rec record;
begin
	if (new.user_id is null or new.movie_id is null or new.status is null or new.episodes is null)
    	then raise exception 'null for not nullable field';
	end if;
    perform check_score(new.score, new.status, new.episodes);
    i := 0;
    for rec in (select
               		movies.movie_id,
                	movies.episodes as total
              	from movies
                	where movies.movie_id = new.movie_id) loop
		i := i + 1;
		if (rec.total < new.episodes) then
        	raise exception 'total % episodes count is smaller than given %', rec.total, new.episodes;
        end if;
	end loop;
    if (i != 1) then
    	raise exception 'can`t find movie';
    end if;
    --insert into scores (user_id, movie_id, score, status, episodes) values
--(new.user_id, new.movie_id, new.score, new.status, new.episodes);
    return new;
end;
$$
LANGUAGE plpgsql;

create trigger insert_user_score_trigger before insert or update on scores
    FOR EACH row EXECUTE PROCEDURE insert_user_score();