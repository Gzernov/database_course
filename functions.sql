create or replace function insert_movie_stuff(mid integer, movie_title varchar(100), aired date, country char(2),
    movie_type movie_type, episodes integer, sid integer, stuff_name varchar(100), stuff_position varchar(100)) returns void as
$$
begin
	if (not exists (
    		select * from movies
        	where movies.movie_id = mid
    	)
    ) then
    	insert into movies(movie_id, movie_title, aired, country, movie_type, episodes) values
			(mid, movie_title, aired, country, movie_type, episodes);
    end if;
    if (not exists (
    		select * from stuff
        	where stuff.stuff_id = sid
    	)
    ) then
    	insert into stuff(stuff_id, stuff_name, stuff_position) values
			(sid, stuff_name, stuff_position);
    end if;
    insert into stuff_movies(movie_id, stuff_id) values
		(mid, sid);
end;
$$
LANGUAGE plpgsql;

create or replace function insert_movie_genre(mid integer, movie_title varchar(100), aired date, country char(2),
    movie_type movie_type, episodes integer, gid integer, genre_name varchar(100)) returns void as
$$
begin
	if (not exists (
    		select * from movies
        	where movies.movie_id = mid
    	)
    ) then
    	insert into movies(movie_id, movie_title, aired, country, movie_type, episodes) values
			(mid, movie_title, aired, country, movie_type, episodes);
    end if;
    if (not exists (
    		select * from genres
        	where genres.genre_id = gid
    	)
    ) then
    	insert into genres(genre_id, genre_name) values
			(gid, genre_name);
    end if;
    insert into genre_movies(movie_id, genre_id) values
		(mid, gid);
end;
$$
LANGUAGE plpgsql;

create or replace function all_movie_stuff (mid integer) returns 
	table(stuff_id integer, stuff_name varchar(100), stuff_position varchar(100)) as
$$
begin
	return query
	select 
    	stuff.stuff_id,
    	stuff.stuff_name,
		stuff.stuff_position
    from movies
    natural join stuff_movies
    natural join stuff;
end;
$$
LANGUAGE plpgsql;

create or replace function genres_string (mid integer) returns text as 
$$
declare
	rec record;
    res text;
    i integer;
begin
	res := '';
    i := 0;
	for rec in (select 
                * 
                from movies
                	natural join genre_movies
                	natural join genres
                where movie_id = mid) loop
        i := i + 1;
        if (i != 1) then
        	res := res || ', ' || rec.genre_name;
        else 
			res := rec.genre_name;
        end if;
    end loop;
    return res;
end;
$$
LANGUAGE plpgsql;

create or replace function movie_info (mid integer) returns
	table(movie_id integer, 
          movie_title varchar(100), 
          aired date, 
          country char(2), 
          movie_type movie_type, 
          episodes integer,
 		  average_score numeric,
          creator varchar(100),
          genres text) as
$$
begin
	
	return query
    with 
    avs as 
    (
        select * from
        average_scores
    ),
    creators as
    (
    	select * from stuff
        where stuff_position = 'Director' or stuff_position = 'Creator'
    )  
    
	select
    	movies.movie_id,
        movies.movie_title,
        movies.aired,
        movies.country,
        movies.movie_type,
        movies.episodes,
        avs.avg,
        coalesce(creators.stuff_name, 'Unknown'),
        genres_string(mid)
    from movies
    natural join avs
    natural join stuff_movies
    left join creators on stuff_movies.stuff_id = creators.stuff_id
    where movies.movie_id = mid;
end;
$$
LANGUAGE plpgsql;

create or replace function favourite_person (uid integer) returns table(user_name varchar (100), average_score numeric, person varchar (100)) as
$$
begin
	return query
    with avs as (
        select
            users.user_name,
            avg(score),
            stuff_name
        from users
        natural join scores
        inner join movies on movies.movie_id = scores.movie_id 
        inner join stuff_movies on movies.movie_id = stuff_movies.movie_id 
        natural join stuff
        where users.user_id = uid
        group by users.user_name, stuff_name       
    ),
    maxs as (
		select 
            avs.user_name,
            max(avg)
    	from avs
    	group by avs.user_name
    )
    select distinct on (maxs.user_name)
	maxs.user_name,
    max,
    stuff_name
    from maxs
    inner join avs on maxs.user_name = avs.user_name and maxs.max = avs.avg;
end;
$$
LANGUAGE plpgsql;

select * from favourite_person(1);
