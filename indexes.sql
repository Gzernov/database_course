drop index if exists title_index;
drop index if exists score_index;
drop index if exists score_movie_index;
drop index if exists stuff_index; 

create index title_index on movies USING HASH (movie_title);
create index score_index on scores using Btree (user_id, movie_id);
create index score_movie_index on scores using Btree (movie_id, user_id);
create index stuff_index on stuff using hash (stuff_name);