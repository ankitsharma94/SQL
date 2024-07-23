-- Create the database if it does not exist
IF DB_ID('paintings') IS NULL
BEGIN
    CREATE DATABASE paintings;
END
GO

-- Grant permissions to the user
USE paintings;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ankit')
BEGIN
    CREATE USER ankit FOR LOGIN ankit;
END
ALTER ROLE db_owner ADD MEMBER ankit;
GO

-- Check and bring the database online if it is offline
USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'paintings' AND state_desc = 'OFFLINE')
BEGIN
    ALTER DATABASE paintings SET ONLINE;
END
GO

use paintings
select * from artist
select * from canvas_size
select * from image_link
select * from museum
select * from museum_hours
select * from product_size
select * from subject
select * from work


-- Solve the below SQL problems using the Famous Paintings & Museum dataset:

--1) Fetch all the paintings which are not displayed on any museums?
select * from work 
where museum_id is null

--2) Are there museuems without any paintings?
select * from museum m
where not exists (select 1 from work w
                  where m.museum_id=w.museum_id  )

--3) How many paintings have an asking price of more than their regular price? 
select * from product_size
where sale_price>regular_price

--4) Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size
where sale_price = (0.5*regular_price)

--5) Which canva size costs the most?
select cs.label,ps.sale_price 
from canvas_size cs
join product_size ps on cs.size_id=ps.size_id
where sale_price = (select max(sale_price) from product_size)

               --OR--

select cs.label as canva, ps.sale_price
	from (select *
		  , rank() over(order by sale_price desc) as rnk 
		  from product_size) ps
	join canvas_size cs on cs.size_id=ps.size_id
	where ps.rnk=1;					 

--6) Delete duplicate records from work, product_size, subject and image_link tables
with cte as 
	(select *,
	ROW_NUMBER() over (partition by work_id order by museum_id) rn
	from work)
delete from cte where rn>1

with cte as 
	(select *,
	ROW_NUMBER() over (partition by work_id order by size_id) rn
	from product_size)
delete from cte where rn>1

with cte as 
	(select *,
	ROW_NUMBER() over (partition by work_id order by subject) rn
	from subject)
delete from cte where rn>1

with cte as 
	(select *,
	ROW_NUMBER() over (partition by work_id order by url) rn
	from image_link)
delete from cte where rn>1

--7) Identify the museums with invalid city information in the given dataset
select * from museum
where city like ('[0-9]%')

--8) Museum_Hours table has 1 invalid entry. Identify it and remove it.
with cte as 
(select *,
ROW_NUMBER() over (partition by museum_id order by day) rn
from museum_hours)
select * from cte where rn >1

--9) Fetch the top 10 most famous painting subject
select * from
	(select s.subject, count(*) no_of_paintings,
	ROW_NUMBER() over (order by count(*) desc) ranking
	from work w
	join subject s on w.work_id=s.work_id
	group by s.subject) ss
where ranking<=10

--10) Identify the museums which are open on both Sunday and Monday. Display museum name, city.
select m.name,m.address
from museum m
join museum_hours mh1 on m.museum_id=mh1.museum_id
where day = 'sunday' 
and exists (select * from museum_hours mh2
			where mh1.museum_id=mh2.museum_id
			and day = 'monday')

--11) How many museums are open every single day?
select count(1) museums_open_everyday from
		(select museum_id,count(1) no_days_open
		from museum_hours
		group by museum_id) x
where no_days_open = 7

--12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
select m.name,m.city,x.no_of_paintings from 
		(select w.museum_id,count(1) no_of_paintings,
		rank() over (order by count(1) desc) ranking
		from work w
		join museum m on w.museum_id=m.museum_id
		group by w.museum_id) x
join museum m on x.museum_id=m.museum_id
where ranking <6

--13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
 select (a.first_name+' '+a.full_name+' '+a.last_name) name,x.count_paintings  
	   from	( select artist_id,count(1) count_paintings,
			 rank() over (order by count(1) desc) ranking
			 from work
			 group by artist_id) x
join artist a on a.artist_id=x.artist_id
where ranking <=5

--14) Display the 3 least popular canva sizes
select x.label,x.ranking,x.paintings_count
from 
	(select cs.size_id,cs.label,count(1) paintings_count,
	dense_rank() over (order by count(1)) ranking
	from work w
	join product_size ps on w.work_id=ps.work_id
	join canvas_size cs on cast(cs.size_id as varchar)=ps.size_id
	group by cs.size_id,cs.label) x
where ranking <=3 

--15) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?
	select museum_name,state as city,day, open, close, duration
	from (	select m.name as museum_name, m.state, day, open, close
			, to_timestamp(open,'HH:MI AM') 
			, to_timestamp(close,'HH:MI PM') 
			, to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM') as duration
			, rank() over (order by (to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM')) desc) as rnk
			from museum_hours mh
		 	join museum m on m.museum_id=mh.museum_id) x
	where x.rnk=1;

--16) Which museum has the most no of most popular painting style?
with pop_style as 
		(select style,
			   RANK() over (order by count(1) desc) rnk
		from work
		group by style),
     cte as 
	    (select w.museum_id,m.name museum_name,ps.style,count(1) paintings_count,
		 RANK() over (order by count(1) desc) rnk
		 from work w
		 join museum m on w.museum_id = m.museum_id
		 join pop_style ps on ps.style = w.style
		 where w.museum_id is not null
		 and rnk = 1
		 group by w.museum_id,m.name,ps.style
	      )
select museum_name,style,paintings_count from cte 
where rnk = 1

--17) Identify the artists whose paintings are displayed in multiple countries
with cte as 
		(select distinct a.full_name artist_name, w.name painting_name,m.name museum_name ,m.country 
		from artist a 
		join work w on a.artist_id=w.artist_id
		join museum m on w.museum_id=m.museum_id)
select artist_name,count(1) no_of_countries
from cte
group by artist_name
having count(1) > 1
order by count(1) desc

--18) Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country.
--If there are multiple value, seperate them with comma.
with cte_country as
		(select  country,count(1) mcount,
		rank() over (order by count(1) desc) rnk 
		from museum
		group by country),
    cte_city as 
		(select  city,count(1) mscount,
		rank() over (order by count(1) desc) rnk 
		from museum
		group by city)
select 
	(select string_agg( country,' , ') 
	from cte_country
	where rnk =  1) as country ,
	(select string_agg(city,' , ' )
	from cte_city
	where rnk = 1) as city

--19) Identify the artist and the museum where the most expensive and least expensive painting is placed. 
--Display the artist name, sale_price, painting name, museum name, museum city and canvas label
with cte as
		(select *,
		       rank() over (order by sale_price desc) rnk_hi_lo,
			   rank() over (order by sale_price asc) rnk_lo_hi
		from product_size)
select w.name as painting
	, cte.sale_price
	, a.full_name as artist
	, m.name as museum, m.city
	, cz.label as canvas
	from cte 
	join work w on w.work_id=cte.work_id
	join museum m on m.museum_id=w.museum_id
	join artist a on a.artist_id=w.artist_id
	join canvas_size cz on cz.size_id = cast(cte.size_id as numeric)
	where rnk_hi_lo = 1 and rnk_lo_hi = 1
--20) Which country has the 5th highest no of paintings?
with cte as 
		(select m.country,count(1) painting_count,
			   RANK() over (order by count(1) desc) rnk
		from work w
		join museum m on w.museum_id = m.museum_id
		group by m.country)
select country from cte where rnk=5

--21) Which are the 3 most popular and 3 least popular painting styles?
with cte as 
		(select style, count(1) as cnt
		, rank() over(order by count(1) desc) rnk
		, count(1) over() as no_of_records
		from work
		where style is not null
		group by style)
	select style
	, case when rnk <=3 then 'Most Popular' else 'Least Popular' end as remarks 
	from cte
	where rnk <=3
	or rnk > no_of_records - 3

--22) Which artist has the most no of Portraits paintings outside USA?. 
--Display artist name, no of paintings and the artist nationality.
with cte as 
		(select a.full_name artist_name,
				count(1) no_of_paintings,a.nationality,
				rank() over (order by count(1) desc) rnk
		from subject s
		join work w on s.work_id=w.work_id
		join museum m on w.museum_id=m.museum_id
		join artist a on w.artist_id = a.artist_id
		where subject = 'portraits'
		   and m.country != 'USA'
		group by a.full_name,a.nationality)
select artist_name,no_of_paintings,nationality from cte
where rnk = 1

