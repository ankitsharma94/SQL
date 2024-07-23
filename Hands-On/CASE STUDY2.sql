CREATE TABLE LOCATION
(  LOCATION_ID INT,
   CITY     VARCHAR(30)
   CONSTRAINT PK_LC_LID PRIMARY KEY(LOCATION_ID)
   )

INSERT INTO LOCATION VALUES (122,'NEW YORK'),(123,'DALLAS'),(124,'CHICAGO'),(167,'BOSTON')
							
CREATE TABLE DEPARTMENT
( DEPARTMENT_ID INT,
  NAME  VARCHAR(30),
  LOCATION_ID   INT,
  CONSTRAINT PK_DPT_DID PRIMARY KEY(DEPARTMENT_ID),
  CONSTRAINT FK_DPT_LID FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCATION_ID)
  )

INSERT INTO DEPARTMENT VALUES (10,'ACCOUNTING',122),(20,'SALES',124),(30,'RESEARCH',123),
                              (40,'OPERATIONS',167)

CREATE TABLE JOB
( JOB_ID INT,
  DESIGNATION VARCHAR(40)
  CONSTRAINT PK_JOB_JID PRIMARY KEY(JOB_ID)
  )
  
INSERT INTO JOB VALUES (667,'CLERKK'),(668,'STAFF'),(669,'ANALYST'),(670,'SALES PERSON'),
                       (671,'MANAGER'),(672,'PRESIDENT')

CREATE TABLE EMPLOYEE 
(
  Employee_Id INT,
  Last_Name VARCHAR(50),
  First_Name VARCHAR(50),
  Middle_Name VARCHAR(50),
  Job_Id INT,
  Manager_Id INT,
  Hire_Date DATE,
  Salary DECIMAL(10, 2),
  Commission DECIMAL(10, 2),
  Department_Id INT,
  CONSTRAINT FK_EMP_JID FOREIGN KEY (Job_ID) REFERENCES JOB(JOB_ID),
  CONSTRAINT FK_DPT_DID FOREIGN KEY (Department_Id) REFERENCES DEPARTMENT(Department_Id)
)

INSERT INTO EMPLOYEE VALUES (7369, 'SMITH', 'JOHN', 'Q', 667, 7902,'17-DEC-84', 800, NULL, 20)
INSERT INTO EMPLOYEE VALUES (7499, 'ALLEN', 'KEVIN', 'J', 670, 7698,'20-FEB-85', 1600, 300, 30)
INSERT INTO EMPLOYEE VALUES (7505, 'DOYLE', 'JEAN', 'K', 671, 7839, '04-APR-85', 2850, NULL, 30)
INSERT INTO EMPLOYEE VALUES (7506,'DENNIS', 'LYNN','S',671, 7839, '15-MAY-85',2750, NULL,30)
INSERT INTO EMPLOYEE VALUES (7507, 'BAKER', 'LESLIE', 'D', 671, 7839, '10-JUN-85', 2200, NULL, 40)
INSERT INTO EMPLOYEE VALUES (7521,'WARK','CYNTHIA','D', 670, 7698, '22-FEB-85', 1250, 500, 30)

--SIMPLE QUERIES--
--1. List all the employee details.
SELECT * FROM EMPLOYEE

--2. List all the department details.
SELECT * FROM DEPARTMENT

--3. List all job details.
SELECT * FROM JOB

--4. List all the locations.
SELECT * FROM LOCATION

--5. List out the First Name, Last Name, Salary, Commission for all Employees.
SELECT First_Name,Last_Name,Salary,Commission FROM EMPLOYEE

--6. List out the Employee ID, Last Name, Department ID for all employees and alias Employee ID as "ID of the Employee",
  -- Last Name as "Name of the Employee", Department ID as "Dep_id".
  SELECT Employee_Id AS 'ID of the employee', Last_Name as 'Name of the employee', 
  Department_Id as 'dep_id' FROM EMPLOYEE

--7. List out the annual salary of the employees with their names only.select First_Name+' '+Last_Name as Name, salary*12 as 'Annual salary' from EMPLOYEE --WHERE Condition:--
--1. List the details about "Smith".
SELECT * FROM EMPLOYEE WHERE Last_Name='SMITH'

--2. List out the employees who are working in department 20.
SELECT * FROM EMPLOYEE WHERE Department_Id=20

--3. List out the employees who are earning salaries between 3000 and 4500.
SELECT * FROM EMPLOYEE WHERE SALARY BETWEEN 3000 AND 4500

--4. List out the employees who are working in department 10 or 20.
SELECT * FROM EMPLOYEE WHERE Department_Id IN (10,20)

--5. Find out the employees who are not working in department 10 or 30.
SELECT * FROM EMPLOYEE WHERE Department_Id NOT IN (10,30)

--6. List out the employees whose name starts with 'S'.
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'S%' OR Last_Name LIKE 'S%'

--7. List out the employees whose name starts with 'S' and ends with 'H'.
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'S%H' OR Last_Name LIKE'S%H'

--8. List out the employees whose name length is 4 and start with 'S'.
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'S___' OR Last_Name LIKE 'S___'

--9. List out employees who are working in department 10 and draw salaries more than 3500.
SELECT * FROM EMPLOYEE WHERE Department_Id=10 AND Salary>3500

--10. List out the employees who are not receiving commission.
SELECT * FROM EMPLOYEE WHERE Commission IS NULL

--ORDER BY Clause:--
--1. List out the Employee ID and Last Name in ascending order based on the Employee ID.
SELECT Employee_Id,Last_Name FROM EMPLOYEE
ORDER BY Employee_Id

--2. List out the Employee ID and Name in descending order based on salary.
SELECT Employee_Id,First_Name+' '+Last_Name AS NAME FROM EMPLOYEE ORDER BY Salary

--3. List out the employee details according to their Last Name in ascending order.
SELECT * FROM EMPLOYEE ORDER BY Last_Name--4. List out the employee details according to their Last Name in ascending order    --and then Department ID in descending order.SELECT * FROM EMPLOYEE ORDER BY Last_Name ASCSELECT * FROM EMPLOYEE ORDER BY Department_Id DESC--GROUP BY and HAVING Clause:--
--1. How many employees are in different departments in the organization?
SELECT Department_Id, COUNT(Last_Name) NO_OF_EMPLOYEES FROM EMPLOYEE GROUP BY  Department_Id

--2. List out the department wise maximum salary, minimum salary and
   --average salary of the employees.
SELECT Department_Id,MAX(SALARY) MAX_SALARY,MIN(SALARY) MIN_SALARY, AVG(SALARY) AVG_SALARY FROM EMPLOYEE
GROUP BY Department_Id

--3. List out the job wise maximum salary, minimum salary and average salary of the employees.
SELECT Job_Id,MAX(SALARY) MAX_SALARY,MIN(SALARY) MIN_SALARY, AVG(SALARY) AVG_SALARY FROM EMPLOYEE
GROUP BY Job_Id

--4. List out the number of employees who joined each month in ascending order.
SELECT DATENAME(MONTH,Hire_Date) AS JOIN_MONTH,COUNT(*) NO_OF_EMPLOYEES FROM EMPLOYEE
GROUP BY Hire_Date 
ORDER BY MONTH(Hire_Date) 

--5. List out the number of employees for each month and year in ascending order based on the year and month.
SELECT DATENAME(YEAR,Hire_Date) JOINYEAR, DATENAME(MONTH,Hire_Date) JOINMONTH,
COUNT(*) NO_OF_EMPLOYEES FROM EMPLOYEE
GROUP BY Hire_Date
ORDER BY Hire_Date,MONTH(Hire_Date)

--6. List out the Department ID having at least four employees.
SELECT Department_Id,COUNT(*) NO_OF_EMPLOYEES FROM EMPLOYEE 
GROUP BY Department_Id
HAVING COUNT(*)>3 

--7. How many employees joined in the month of January?
SELECT DATENAME(MONTH,Hire_Date) JOINMONTH, COUNT(*) NO_OF_EMPLOYEES FROM EMPLOYEE
GROUP BY DATENAME(MONTH,Hire_Date)
HAVING DATENAME(MONTH,Hire_Date) ='JANUARY'

--8. How many employees joined in the month of January or September?
SELECT DATENAME(MONTH,Hire_Date) JOINMONTH, COUNT(*) NO_OF_EMPLOYEES FROM EMPLOYEE
GROUP BY DATENAME(MONTH,Hire_Date)
HAVING DATENAME(MONTH,Hire_Date) IN('JANUARY','SEPTEMBER')

--9. How many employees joined in 1985?
SELECT YEAR(Hire_Date) JOINYEAR, COUNT(*) FROM EMPLOYEE
GROUP BY  YEAR(Hire_Date)
HAVING YEAR(Hire_Date)='1985'

   --10. How many employees joined each month in 1985?
SELECT DATENAME(MONTH,Hire_Date) JOINMONTH, COUNT(*) FROM EMPLOYEE WHERE year(Hire_date)='1985'
GROUP BY DATENAME(MONTH,Hire_Date),YEAR(Hire_Date)


--11. How many employees joined in March 1985?
SELECT YEAR(Hire_Date) JOINYEAR ,DATENAME(MONTH,Hire_Date) JOINMONTH, COUNT(*) FROM EMPLOYEE
where YEAR(Hire_date)='1985' AND MONTH(Hire_date)=3
GROUP BY DATENAME(MONTH,Hire_Date),YEAR(Hire_Date)

--12. Which is the Department ID having greater than or equal to 3 employees joining in April 1985?
SELECT Department_Id, COUNT(*) NO_OF_EMPLOYEES FROM EMPLOYEE 
WHERE MONTH(Hire_Date)=4 AND YEAR(Hire_date)='1985'
GROUP BY Department_Id
HAVING COUNT(*)>=3

--Joins:--


--1. LIST OUT EMPLOYEES WITH THEIR DEPARTMENT NAMES.
select E.Employee_ID,E.First_name,D.name from
EMPLOYEE E inner join Department D ON E.Department_ID=D.Department_id 

--2. DISPLAY EMPLOYEES WITH THEIR DESIGNATIONS.
select E.Employee_ID,E.First_name,J.Designation from
EMPLOYEE E inner join Job J ON E.Job_ID=J.Job_ID

--3. DISPLAY THE EMPLOYEES WITH THEIR DEPARTMENT NAMES AND REGIONAL GROUPS.
select E.Employee_ID,E.First_name,D.name,L.city from
Department D  inner join EMPLOYEE E ON E.Department_ID=D.Department_id
			  inner  join	Location L ON D.Location_ID = L.LOCATION_ID

--4. HOW MANY EMPLOYEES WHO ARE WORKING IN DIFFERENT DEPARTMENTS AND DISPLAY WITH
   --DEPARTMENT NAMES.
select count(E.Employee_ID) Total_emps,D.name from
EMPLOYEE E inner join Department D ON E.Department_ID=D.Department_id
group by D.name

--5. HOW MANY EMPLOYEES WHO ARE WORKING IN SALES DEPARTMENT.
select count(E.Employee_ID) Total_emps,D.name from
EMPLOYEE E inner join Department D ON E.Department_ID=D.Department_id
Group By D.name
Having D.name='sales'

--6. WHICH IS THE DEPARTMENT HAVING GREATER THAN OR EQUAL TO 5 EMPLOYEES AND 
  -- DISPLAY THE DEPARTMENT NAMES IN ASCENDING ORDER.*/
select count(E.Employee_ID) Total_emps,D.name from
EMPLOYEE E inner join Department D ON E.Department_ID=D.Department_id
Group By D.name
Having count(E.Employee_ID)>=5
order by D.name ASC


--7. HOW MANY JOBS IN THE ORGANIZATION WITH DESIGNATIONS.
select count(Job_ID) ,Designation from Job
Group By Designation

--8. HOW MANY EMPLOYEES ARE WORKING IN "NEW YORK".
select count(LOCATION_ID),city from Location
Group By city
Having city='New York'

--9. DISPLAY THE EMPLOYEE DETAILS WITH SALARY GRADES.
select Employee_ID, salary ,
(select case when salary<1000 then 'C'
             when salary>=1000 and  salary<2000 then 'B'
			 else 'A' End) as Grade from EMPLOYEE
 group by salary,Employee_id
 Order by salary DESC

--10. LIST OUT THE NO. OF EMPLOYEES ON GRADE WISE.
select COUNT(Employee_ID) count ,salary,
(select case when salary<1000 then 'C' 
             when salary>=1000 and  salary<2000 then 'B' 
			 else 'A' End) as Grade from EMPLOYEE
 group by salary,Employee_id
 order by salary Desc

--11. DISPLAY THE EMPLOYEE SALARY GRADES AND NO. OF EMPLOYEES BETWEEN 2000 TO 5000 RANGE OF SALARY.
select Employee_ID, salary ,
(select case when salary<1000 then 'C' 
             when salary>=1000 and  salary<2000 then 'B'  
			 else 'A' End) as Grade from EMPLOYEE
 group by salary,Employee_id
 Having salary Between 2000 and 5000
 Order by salary DESC

--SET OPERATORS--
--1. LIST OUT THE DISTINCT JOBS IN SALES AND ACCOUNTING DEPARTMENTS.
select Job_ID from EMPLOYEE
where Department_ID=20 OR Department_ID=10

--2. LIST OUT ALL THE JOBS IN SALES AND ACCOUNTING DEPARTMENTS.
select Job_ID from EMPLOYEE
where Department_ID=20 OR Department_ID=10

--3. LIST OUT THE COMMON JOBS IN RESEARCH AND ACCOUNTING DEPARTMENTS IN ASCENDING ORDER
select Job_ID from EMPLOYEE
where Department_ID=10 And Department_ID=10;

--SUB QUERIES--
--1. DISPLAY THE EMPLOYEES LIST WHO GOT THE MAXIMUM SALARY.
select Department_ID,MAX(salary) max_sal from EMPLOYEE
group by Department_ID

--2. DISPLAY THE EMPLOYEES WHO ARE WORKING IN SALES DEPARTMENT.
select * from EMPLOYEE
where Department_ID in (select Department_ID from Department where Name='sales' )

--3. DISPLAY THE EMPLOYEES WHO ARE WORKING AS 'CLERK'.
select * from EMPLOYEE
where Job_ID=(select Job_ID from Job where Designation='clerkk' )


--4. DISPLAY THE LIST OF EMPLOYEES WHO ARE LIVING IN "NEW YORK".
select * from EMPLOYEE
where Department_ID=
		(select department_ID from Department
		 where Location_ID=(select LOCATION_ID from Location
		                     where city='New York' ))

--5. FIND OUT NO. OF EMPLOYEES WORKING IN "SALES" DEPARTMENT.
select count(Department_ID) from EMPLOYEE
where Department_ID=(select Department_ID from Department where name='sales')

--6. UPDATE THE EMPLOYEES SALARIES, WHO ARE WORKING AS CLERK ON THE BASIS OF 10%.
update EMPLOYEE
set salary= salary*1.1
where  Job_ID=(select Job_ID from Job 
			        where Designation='Clerkk')
					
--7. DELETE THE EMPLOYEES WHO ARE WORKING IN ACCOUNTING DEPARTMENT.
delete from EMPLOYEE where Department_ID=(select Department_ID from Department where name='Accounting')

--8. DISPLAY THE SECOND HIGHEST SALARY DRAWING EMPLOYEE DETAILS.
select Top(1) salary from EMPLOYEE
where salary <(Select MAX(salary) from EMPLOYEE) 
order By salary DESC

--9.*** DISPLAY THE N'TH HIGHEST SALARY DRAWING EMPLOYEE DETAILS.
select distinct E.salary from EMPLOYEE E 
where 5=(select count(distinct salary) from EMPLOYEE where salary>E.salary) 

/*here 5 is 5th highest salary*/

--10. LIST OUT THE EMPLOYEES WHO EARN MORE THAN EVERY EMPLOYEE IN DEPARTMENT 30.
select Employee_ID,First_name from EMPLOYEE
where salary=(select MAX(salary) from EMPLOYEE
				where Department_ID=30)


--11. LIST OUT THE EMPLOYEES WHO EARN MORE THAN THE LOWEST SALARY IN DEPARTMENT 30.
select Employee_ID,First_name,salary from EMPLOYEE
where salary>(select MIN(salary) from EMPLOYEE
				where Department_ID=30)


--12. FIND OUT WHOSE DEPARTMENT HAS NOT EMPLOYEES. /*DOUBT 12 and 13 are same?*/
select Department_ID from Department
--Except 
select Department_ID from EMPLOYEE

select Department_ID from Department D where  NOT EXISTS(select 1 from EMPLOYEE E
where E.Department_ID=D.Department_ID) /*1 fro true*/

--13. FIND OUT WHICH DEPARTMENT DOES NOT HAVE ANY EMPLOYEES.
select Department_ID from Department
where Department_ID not in (select Department_ID from EMPLOYEE)

--14. FIND OUT THE EMPLOYEES WHO EARN GREATER THAN THE AVERAGE SALARY FOR THEIR DEPARTMENT.
select First_Name,salary,Department_ID from EMPLOYEE A
where salary>(select avg(salary) from EMPLOYEE )
group by First_Name,Department_ID,salary

