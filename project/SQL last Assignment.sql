

CREATE TABLE Employee_tab
(Employee_id INT primary key,
First_name VARCHAR(50),
Last_name VARCHAR(50),
salary int,
Joining_date Datetime,
Department VARCHAR(30));

INSERT INTO Employee_tab VALUES 
(1,'Ankita','arora',100000,'2020-02-14 9:00:00','HR'),
(2,'Veena','Verma',80000,'2011-06-15 09:00:00','Admin'),
(3,'Vishal','Singhal',300000,'2020-02-16 09:00:00','HR'),
(4,'Sushanth','Singh',500000,'2020-02-17 09:0:00','Admin'),
(5,'Bhupal','Bhati',500000,'2011-06-18 09:00:00','Admin'),
(6,'Dheeraj','Diwan',200000,'2011-06-19 09:00:00','Account'),
(7,'Karan','Kumar',75000,'2020-01-14 09:00:00','Account'),
(8,'Chandrika','Chauhan',90000,'2011-04-15 09:00:00','Admin')


CREATE TABLE Employee_Bonus
(Employee_ref_id INT Foreign key references Employee_tab(Employee_id),
Bonus_Amount int,
Bonus_date Datetime);

INSERT INTO Employee_Bonus VALUES
(1,5000,'2020-02-19 0:00:00:000'),
(2,3000,'2011-06-16 0:00:00:000'),
(3,4000,'2020-02-16 0:00:00:000'),
(1,4500,'2020-02-16 0:00:00:000'),
(2,3500,'2011-06-16 0:00:00:000');




CREATE TABLE Employee_Title
(Employee_ref_id INT,
Bonus_title VARCHAR(30),
Affective_date Datetime);

INSERT INTO Employee_Title VALUES
(1,'Manager','2016-02-20 0:00:00:000'),
(2,'Executive','2016-06-11 0:00:00:000'),
(8,'Executive','2016-06-11 0:00:00:000'),
(5,'Manager','2016-06-11 0:00:00:000'),
(4,'Asst. Manager','2016-06-11 0:00:00:000'),
(7,'Executive','2016-06-11 0:00:00:000'),
(6,'Lead','2016-06-11 0:00:00:000'),
(3,'Lead','2016-06-11 0:00:00:000');

select * from Employee_tab
select * from Employee_Bonus
select * from Employee_Title

--1 Display the “FIRST_NAME” from Employee table using the alias name as Employee_name.
select First_name as Employee_name from Employee_tab;

--2 Display “LAST_NAME” from Employee table in upper case.
select UPPER(Last_name) as L_name from Employee_tab;

--3 Display unique values of DEPARTMENT from EMPLOYEE table.
select Department from Employee_tab
Group BY Department;

--4 Display the first three characters of LAST_NAME from EMPLOYEE table
select SUBSTRING(Last_name,1,3) from Employee_tab

--5 Display the unique values of DEPARTMENT from EMPLOYEE table and prints its length.
select Department,LEN(Department) as Length_ from Employee_tab
Group BY Department;

-- 6 Display the FIRST_NAME and LAST_NAME from EMPLOYEE table into a single column AS FULL_NAME a space char should separate them.

select (First_name+' '+Last_name) as Full_name from Employee_tab


--7 DISPLAY all EMPLOYEE details from the employee table order by FIRST_NAME Ascending.
select * from Employee_tab
Order BY First_name ASC;

--8. Display all EMPLOYEE details order by FIRST_NAME Ascending and DEPARTMENT Descending.

select * from Employee_tab
order by First_name, Department DESC


--9 Display details for EMPLOYEE with the first name as “VEENA” and “KARAN” from EMPLOYEE table
select * from Employee_tab
where First_name in ('Veena','Karan');

--10 Display details of EMPLOYEE with DEPARTMENT name as “Admin”
select * from Employee_tab
where Department='Admin';

--11 DISPLAY details of the EMPLOYEES whose FIRST_NAME contains ‘V’.

select * from Employee_tab
where First_name like '%V%';

--12 DISPLAY details of the EMPLOYEES whose SALARY lies between 100000 and 500000.
select * from Employee_tab
where salary between 100000 and 500000;

--13 Display details of the employees who have joined in Feb-2020
select * from Employee_tab
where month(Joining_date)='02' and YEAR(Joining_date)='2020' ;

--14 Display employee names with salaries >= 50000 and <= 100000
select * from Employee_tab
where salary>=50000 and salary<=100000;

--16 DISPLAY details of the EMPLOYEES who are also Managers.
select * from
Employee_tab E full join Employee_Title T on E.Employee_id= T.Employee_ref_id
where T.Bonus_title = 'Manager';

--17 DISPLAY duplicate records having matching data in some fields of a table.

 select Employee_id,First_name,salary,Department,Joining_date,count(*) from Employee_tab
 group by Employee_id,First_name,salary,Department,Joining_date
 having count(*)>1

--18 Display only odd rows from a table
select * from Employee_tab
where (Employee_id)%2 != 0

--19 Clone a new table from EMPLOYEE table.
select * into Employee_tab2 from Employee_tab

select * from Employee_tab2

--20 DISPLAY the TOP 2 highest salary from a table.
SELECT top(2) salary from Employee_tab;

--21. DISPLAY the list of employees with the same salary.
 select A.Employee_id,A.First_name,A.salary,A.Department from
 Employee_tab A inner Join (select Employee_id,salary from Employee_tab) B
 On A.salary=B.salary
 where A.Employee_id  != B.Employee_id 

--22 Display the second highest salary from a table.
select top(1) salary from Employee_tab
where salary<(select max(salary) from Employee_tab)
order by salary DESC;


--23 Display the first 50% records from a table.
select * from Employee_tab
Where Employee_id<=(select (count(Employee_id))/2 from Employee_tab);


--24. Display the departments that have less than 4 people in it.
select Department From Employee_tab
Group by Department
having COUNT(Department) < 4

--25. Display all departments along with the number of people in there.
select Department,COUNT(Employee_id) Count From Employee_tab
group by Department

--26 Display the name of employees having the highest salary in each department.
select A.First_name,A.Department,A.salary from 
Employee_tab A inner join (select max(salary) salary ,Department from Employee_tab
group by Department ) 
 B ON
A.salary=B.salary

--27 Display the names of employees who earn the highest salary.
select First_name,Last_name,salary from Employee_tab
where salary=(select MAX(salary) from Employee_tab);

--28 Diplay the average salaries for each department
select Department,Avg(salary) from Employee_tab
group by Department;

--29 display the name of the employee who has got maximum bonus
select First_name from Employee_tab
where Employee_id = (select Employee_ref_id from Employee_Bonus
                     where Bonus_Amount=(select max(Bonus_Amount) from Employee_Bonus) );

--30 Display the first name and title of all the employee
select 
E.First_name,
T.Bonus_title
from
Employee_tab E Full JOIN Employee_Title T ON E.Employee_id=T.Employee_ref_id



