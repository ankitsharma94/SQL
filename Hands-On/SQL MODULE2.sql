
--1. WHAT IS THE HIGHEST NO. OF COPIES SOLD BY A PACKAGE?
SELECT TITLE,SOLD AS HIGHEST_SOLD FROM SOFTWARE WHERE SOLD=
(SELECT MAX(sold) AS HIGHEST_SOLD FROM SOFTWARE)

--2. DISPLAY LOWEST COURSE FEE.
SELECT MIN([COURSE FEE])AS MINFEES FROM STUDIES

--3. HOW OLD IS THE OLDEST MALE PROGRAMMER ?
SELECT MAX(DATEDIFF(YEAR,DOB,GETDATE()))AS AGE FROM PROGRAMMER
WHERE GENDER ='M' 

--4. WHAT IS THE AVERAGE AGE OF FEMALE PROGRAMMER ?
SELECT AVG(DATEDIFF(YEAR,DOB,GETDATE())) AS AGE FROM PROGRAMMER 
WHERE GENDER='F'

--5. CALCULATE THE EXPERIANCE IN YEARS FOR EACH PROGRAMMER AND DISPLAY WITH THEIR NAMES IN DESCENDING ORDER.
SELECT PNAME, DATEDIFF(YEAR,DOJ,GETDATE()) AS EXPERIANCE FROM PROGRAMMER
ORDER BY PNAME DESC

--6. HOW MANY PROGRAMMERS DONE THE PGDCA COURSE?
SELECT COUNT(*) FROM STUDIES WHERE COURSE= 'PGDCA'

--7. HOW MUCH REVENUE HAS BEEN EARNED THROUGH SALES OF PACKAGES DEVELOPED IN C?
SELECT  SUM(SCOST*SOLD) AS REVENUE FROM SOFTWARE WHERE DEVELOPIN='C'

--8. HOW MANY PROGRAMMERS HAVE BEEN STUDIED AT SABHARI?
SELECT COUNT(*) FROM STUDIES WHERE INSTITUTE='SABHARI'

--9. HOW MANY PACKAGES HAVE BEEN DEVELOPEDIN DBASE?
SELECT COUNT(*) FROM SOFTWARE WHERE DEVELOPIN='DBASE'

--10. HOW MANY PROGRAMMERS HAVE STUDIED IN PRAGATHI?
SELECT COUNT(*) FROM STUDIES WHERE INSTITUTE='PRAGATHI'

--11. HOW MANY PROGRAMMERS PAID BETWEEN 5000 TO 10000 FOR THEIR COURSE?
SELECT COUNT(*) FROM STUDIES WHERE [COURSE FEE] BETWEEN 5000 AND 10000

--12. HOW MANY PROGRAMMERS KNOW EITHER COBOL OR PASCAL?
SELECT COUNT(*) FROM PROGRAMMER WHERE PROF1 IN ('COBOL','PASCAL') OR PROF2 IN('COBOL','PASCAL')

--13. HOW MANY FEMALE PROGRAMMERS ARE THERE ?
SELECT COUNT(*) FROM PROGRAMMER WHERE GENDER='F'

--14. WHAT IS THE AVERAGE SALARY?
SELECT AVG(SALARY)AS AVGSALARY FROM PROGRAMMER

--15. HOW MANY PEOPLE DRAW A SALARY BETWEEN 2000 TO 4000?
SELECT COUNT(*) FROM PROGRAMMER WHERE SALARY BETWEEN 2000 AND 4000

--16. DISPLAY THE SALES COST OF THE PACKAGES DEVELOPED BY EACH PROGRAMMER LANGUAGE WISE.
SELECT DEVELOPIN,SCOST FROM SOFTWARE GROUP BY DEVELOPIN,SCOST

--17. DISPLAY THE DETAILS OF THE SOFTWARE DEVELOPED BY THE MALE STUDENTS OF SABHARI.
SELECT ST.PNAME, SW.DEVELOPIN,PG.GENDER,ST.INSTITUTE FROM STUDIES ST 
INNER JOIN SOFTWARE SW ON ST.PNAME=SW.PNAME
INNER JOIN PROGRAMMER PG ON SW.PNAME=PG.PNAME 
WHERE GENDER='M' AND INSTITUTE='SABHARI'

--18. WHO IS THE OLDEST FEMALE PROGRAMMER WHO JOINED IN 1992?
SELECT PNAME FROM PROGRAMMER WHERE GENDER ='F' AND YEAR(DOB)=
(SELECT MIN(YEAR(DOB)) AS AGE FROM PROGRAMMER WHERE YEAR(DOJ)=1992)

--19. WHO IS THE YOUNGEST MALE PROGRAMMER BORN IN 1965?
SELECT PNAME FROM PROGRAMMER WHERE MONTH(DOB)=
(SELECT MAX(MONTH(DOB)) FROM PROGRAMMER WHERE YEAR(DOB)=1965 AND GENDER='M')
 
--20. WHICH PACKAGE HAS THE LOWEST SELLING COST?
SELECT PNAME FROM SOFTWARE WHERE SCOST=(SELECT MIN(SCOST) FROM SOFTWARE)
SELECT * FROM SOFTWARE

--21. WHICH FEMALE PROGRAMMER EARNING MORE THAN 3000 DOESNOT KNOW C,C++,ORACLE OR DBASE?
SELECT PNAME FROM PROGRAMMER WHERE GENDER='F' AND SALARY >=3000 AND  PROF1 NOT IN ('C','C++','ORACLE','DBASE')
AND PROF2 NOT IN ('C','C++','ORACLE','DBASE')


--22. WHO IS THE YOUNGEST PROGRAMMER KNOWING DBASE
SELECT PNAME FROM PROGRAMMER WHERE DOB=
(SELECT MAX(DOB) FROM PROGRAMMER WHERE PROF1='DBASE' OR PROF2='DBASE')

--23. WHICH LANGUAGE IS KNOWN BY ONLY ONE PROGRAMMER?
SELECT PROF1 FROM PROGRAMMER
GROUP BY PROF1
HAVING PROF1 NOT IN (SELECT PROF2 FROM PROGRAMMER ) AND COUNT(PROF1)=1



--24. WHO IS THE MOST EXPERIENCED MALE PROGRAMMER KNOWING PASCAL
SELECT PNAME FROM PROGRAMMER WHERE GENDER='M' AND DOJ=
(SELECT MIN(DOJ) FROM PROGRAMMER WHERE PROF1='PASCAL' OR PROF2='PASCAL')

--25. WHO IS THE LEAST EXPERIENCED PROGRAMMER ? 
SELECT PNAME FROM PROGRAMMER WHERE DOJ=(SELECT MAX(DOJ) FROM PROGRAMMER)

--26. DISPLAY THE NUMBER OF PACKAGES IN EACH LANGUAGE FOR WHICH DEVELOPMENT COST IS LESS THAN 1000.
SELECT DEVELOPIN,SOLD ,COUNT(SOLD) AS COUNT FROM SOFTWARE WHERE DCOST<1000
GROUP BY DEVELOPIN, SOLD

--27. DISPLAY THE HIGHEST, LOWEST AND AVERAGE SALAR
SELECT MAX(SALARY) AS MAXSAL, MIN(SALARY) AS MINSAL, AVG(SALARY) AS AVGSAL FROM PROGRAMMER WHERE SALARY>2000


