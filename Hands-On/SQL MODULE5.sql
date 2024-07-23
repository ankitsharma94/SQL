  --1. DISPLAY THE DETAILS OF THE SOFTWARE DEVELOPED IN DBASE BY MALE PROGRAMMER 
     --WHO BELONG TO THE INSTITUTE WITH MOST NUMBER OF PROGRAMMERS.
	 select sw.*,gender from programmer pg inner join software sw on pg.pname=sw.pname
	 inner join studies st on st.pname=sw.pname 
	 where developin='dbase' and gender='m'and institute=( select institute from studies
	order by (select count(*) as programmers_count from studies where institute=st.institute) desc )

	
	SELECT S1.*, S2.INSTITUTE, P1.GENDER	FROM SOFTWARE S1
	INNER JOIN STUDIES S2 ON S1.PNAME = S2.PNAME
	INNER JOIN PROGRAMMER P1 ON P1.PNAME = S2.PNAME
	WHERE P1.GENDER	='M' AND S1.DEVELOPIN='DBASE' AND
	S2.INSTITUTE=(SELECT cast(MAX(INSTITUTE)AS INT) AS MAX_INSTITUTE FROM STUDIES)
	GROUP BY INSTITUTE
	
--2. IN WHICH LANGUAGE ARE MOST OF THE PROGRAMMERS PROFICIENT?
with dataset as
(select prof1 prof, count(*) as prof_count from programmer group by prof1 
union
select prof2 prof, count(*) as count from programmer group by prof2 )
select prof from dataset where prof_count=(select max(prof_count) from dataset)

--3. IN WHICH MONTH DID MOST NUMBER OF PROGRAMMERS JOIN?
with dataset as
(select datename(month,doj) as joining_month,count(month(doj)) as month_count from programmer 
group by datename(month,doj))
select joining_month from dataset where month_count=(select max(month_count) from dataset)

--4. IN WHICH YEAR THE MOST NUMBER OF PROGRAMMER4S BORN?
with dataset as 
(select year(dob) as born_year,count(year(dob)) as year_count from programmer group by year(dob))
select born_year from dataset where year_count=(select max(year_count) from dataset)


--5. WHICH PROGRAMMER HAS DEVELOPED THE HIGHEST NUMBER OF PACKAGES?
with cte as
(select pname,count(*) as max_packages from software
group by pname )
select pname from cte where max_packages=(select max(max_packages) from cte)

--6. WHICH LANGUAGE IS USED TO DEVELOP THE MOST NUMBER OF PACKAGES?
with dataset01 as
(select developin,count(*) as no_of_packages from software group by developin)
select developin from dataset01 where no_of_packages=(select max(no_of_packages) from dataset01)

--7. WHICH COURSE HAS BELOW AVERAGE NUMBER OF STUDENTS?
with dataset02 as
(select course,count(*) as no_of_students from studies group by course)
select course from dataset02 where no_of_students<(select avg(no_of_students) from dataset02)

--8. WHICH COURSE HAS BEEN DONE BY THE MOST NUMBER OF STUDENTS?
with dataset03 as
(select course,count(*) as no_of_students from studies group by course)
select course from dataset03 where no_of_students=(select max(no_of_students) from dataset03)

--9. WHICH INSTITUTE HAS THE MOST NUMBER OF STUDENTS?
with dataset04 as
(select institute,count(*) as no_of_students from studies group by institute)
select institute from dataset04 where no_of_students=(select max(no_of_students) from dataset04)

--10. WHO IS THE ABOVE PROGRAMMER REFERED TO IN 50?
with dataset as
(select pname,datediff(year,dob,getdate()) as age from programmer group by pname,dob)
select * from dataset where age like'5%'

--11. DISPLAY THE NAMES OF THE HIGHEST PAID PROGRAMMERS FOR EACH LANGUAGE.
with dataset as 
(select pname,prof1 prof ,salary ,dense_rank() over (partition by prof1 order by salary desc) as ranking
from programmer group by pname,prof1,salary )
select  prof,pname,salary from dataset where ranking=1 

--12. DISPLAY THE NAMES OF HIGHEST PAID PROGRAMMERS FOR EACH LANGUAGE.
 with dataset as 
(select pname,prof2 prof ,salary ,dense_rank() over (partition by prof2 order by salary desc) as ranking
from programmer group by pname,prof2,salary )
select  prof,pname,salary from dataset where ranking=1   