create table netflix
(
show_id	varchar(6),
type	varchar(10),
title	varchar(150),
director	varchar(208),
casts	varchar(1000),
country	varchar(150),
date_added	varchar(50),
release_year	int,
rating    varchar(10),	
duration	varchar(15),
listed_in	varchar(100),
description varchar(250)

);
drop table netflix;
select * from netflix;
select count (*) as total_content from netflix;
select distinct type from netflix;
-- number of movies and tv shows
select type, count(*) as total_content from netflix group by type;  
-- most common rating for movies and tv shows s
SELECT type, rating  FROM (select type,rating,  count(*), RANK() over (partition by type order by count(*) desc) as ranking from netflix 
group by type, rating) AS t1 where ranking = 1;
-- all the movies released in 2020
select * from netflix where release_year = 2020 and type = 'Movie';
-- top 5 countries with most content on netflix
select unnest(string_to_array(country,',')) as new_country, count(show_id)  
as total_content 
from netflix 
group by country
order by 2 desc 
limit 5;
--identifying longest movie
select title, max(cast(substring(duration ,1,position(' ' in duration)-1)as int ))  from netflix where type ='Movie'
and duration is not null
 group by title order by 2 desc limit 1;
 -- content added in last 5 years
 select * from netflix where  to_date(date_added,'Month DD, YYYY') >= current_date - interval '5 years';
 -- tv shows and movies done by "Rajiv Chilaka"
 select * from netflix where director ilike '%Rajiv Chilaka%';
 -- all the tv shows with more than 5 seasons
 select * from netflix where type = 'TV Show' and split_part(duration, ' ', 1)::numeric > 5;
 --counting the number of content items in each genre
 select  unnest(string_to_array(listed_in,',')) as genre, count(show_id) as total_content from netflix
 group by 1;
 -- finding each year and the averge numbers of content release by india on netflix return top 5 year with highest avg content release
 select extract(year from to_date(date_added, 'Month dd, yyyy')) as year, 
 count (*) as yearly_content,
 round(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content_per_year
 from netflix
 where country = 'India'
 group by 1;
 -- all movies that are documentries
 select * from netflix where listed_in ilike '%documentaries%';
 --all content without  director 
 select * from netflix where director is null;