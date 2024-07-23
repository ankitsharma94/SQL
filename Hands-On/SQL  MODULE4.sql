--1. WHAT IS THE COST OF THE COSTLIEST SOFTWARE DEVELOPED IN BASIC?
SELECT DCOST FROM SOFTWARE WHERE DCOST=(SELECT MAX(DCOST) FROM SOFTWARE WHERE DEVELOPIN='BASIC')

--2. DISPLAY DETAILS OF THE PACKAGES WHOOSE SALE CROSSED THE 2000 MARK.
SELECT * FROM SOFTWARE WHERE (SCOST*SOLD)>2000

--3. WHO ARE THE PROGRAMMERS WHO CELEBRATE THEIR BIRTHDAY DURING THE CURRENT MONTH?
SELECT PNAME FROM PROGRAMMER WHERE MONTH(DOB)=MONTH(GETDATE())

--4. DISPLAY THE COST OF THE PACKAGES DEVELOPED BY EACH PROGRAMMER.
SELECT PNAME, DCOST FROM SOFTWARE GROUP BY PNAME,DCOST 

--5. DISPLAY THE SALES VALUE OF THE PACKAGES DEVELOPED BY EACH PROGRAMMER.
SELECT PNAME,SUM(SCOST*SOLD) AS SALES_VALUE FROM SOFTWARE GROUP BY PNAME 

--6. DISPLAY NUMBER OF PACKAGES SOLD BY EACH PROGRAMMER.
SELECT PNAME, SUM(SOLD) FROM SOFTWARE GROUP BY PNAME

--7. DISPLAY EACH PROGRAMMERS NAME, COSTLIEST AND CHEAPEST PACKAGESDEVELOPED BY HIM OR HER.
SELECT PNAME,MAX(DCOST)AS COSTLIEST_PKG,MIN(DCOST) AS CHEAPEST_PKG FROM SOFTWARE GROUP BY PNAME

--8. DISPLAY EACH INSTITUTES NAME WITH THE NUMBER OF COURSES AND AVERAGE COST PER COURSE.
SELECT INSTITUTE, COUNT(COURSE) AS COURSE, AVG([COURSE FEE]) AS AVG_COST FROM STUDIES GROUP BY INSTITUTE

--9. DISPLAY EACH INSTITUTES NAME WITH THE NUMBER OF STUDENTS.
SELECT INSTITUTE ,COUNT(PNAME) AS STUDENTS FROM STUDIES GROUP BY INSTITUTE

--10. LIST THE PROGRAMMERS (FROM THE SOFTWARE TABLE) AND THE INSTITUTES THEY STUDIED AT.
SELECT SW.PNAME, INSTITUTE FROM SOFTWARE SW INNER JOIN STUDIES ST ON SW.PNAME=ST.PNAME
GROUP BY SW.PNAME,INSTITUTE

--11. HOW MANY PACKAGES WERE DEVELOPED BY STUDENTS WHO STUDIED IN INSTITUTES THAT CHARGE THE LOWEST COURSE FEE?
SELECT COUNT(DEVELOPIN) FROM SOFTWARE SW INNER JOIN STUDIES ST ON SW.PNAME=ST.PNAME 
WHERE INSTITUTE IN (SELECT INSTITUTE FROM STUDIES 
WHERE [COURSE FEE]=(SELECT MIN([COURSE FEE]) FROM STUDIES))

--12. WHAT IS THE AVERAGE SALARY FOR THOSE WHOOSE SOFTWARE SALES ARE MORE THAN 50000?
SELECT AVG(SALARY) AS AVG_SALARY FROM PROGRAMMER PG INNER JOIN SOFTWARE SW ON PG.PNAME=SW.PNAME 
WHERE (SCOST*SOLD)>50000

--13. WHICH LANGUAGE LISTED IN PROF1, PROF2 HAS NOT BEEN USED TO DEVELOP ANY PACKAGE?
SELECT PROF1 FROM PROGRAMMER WHERE PROF1 NOT IN (SELECT DEVELOPIN FROM SOFTWARE)
UNION
SELECT PROF2 FROM PROGRAMMER WHERE PROF2 NOT IN (SELECT DEVELOPIN FROM SOFTWARE)

--14. DISPALY THE TOTAL SALE VALUE OF THE SOFTWARE INSTITUTE WISE.
SELECT INSTITUTE, sum(SCOST*SOLD) AS TOTAL_SALE_VALUE FROM  SOFTWARE SW 
INNER JOIN STUDIES ST ON SW.PNAME=ST.PNAME
GROUP BY INSTITUTE

--15. DISPLAY THE DETAILS OF THE SOFTWARE DEVELOPED IN C BY FEMALE PROGRAMMERS OF PRAGATHI.
SELECT SW.* FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME=PG.PNAME 
INNER JOIN STUDIES ST ON SW.PNAME=ST.PNAME WHERE GENDER='F' AND INSTITUTE='PRAGATHI'

--16. DISPLAY THE DETAILS OF THE PACKAGES DEVELOPED IN PASCAL BY FEMALE PROGRAMMERS .
SELECT SW.* FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME=PG.PNAME
WHERE GENDER='F' AND DEVELOPIN='PASCAL'

--17. WHICH LANGUAGE HAS MOST OF THE PROGRAMMERS STATED AS BEING PROFICIENT IN?
SELECT LANGUAGE,COUNT(*) FROM (SELECT PROF1 AS LANGUAGE FROM PROGRAMMER UNION
SELECT PROF2 AS LANGUAGE FROM PROGRAMMER)AS LANGUAGES GROUP BY LANGUAGE 
SELECT * FROM PROGRAMMER

--18. WHO IS THE AUTHOR OF THE COSTLIEST PACKAGE?
SELECT PNAME FROM SOFTWARE WHERE SCOST=(SELECT MAX(SCOST) FROM SOFTWARE)

--19. WHICH PACKAGE HAS THE HIGHEST DEVeLOPMENT COST?
SELECT TITLE FROM SOFTWARE WHERE DCOST=(SELECT MAX(DCOST) FROM SOFTWARE)

--20. WHO IS THE HIGHEST PAID FEMALE COBOL PROGRAMMER?
SELECT PNAME FROM PROGRAMMER WHERE GENDER='F' AND SALARY=
(SELECT MAX(SALARY) FROM PROGRAMMER WHERE PROF1='COBOL' OR PROF2='COBOL')

--21. DISPLAY THE NAMES OF THE PACKAGES OF THE PROGRAMMERS.
SELECT PG.PNAME,TITLE FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME=PG.PNAME 
GROUP BY PG.PNAME,TITLE

--22. DISPLAY THE NUMBER OF PACKAGES IN EACH LANGUAGE EXCEPT C AND C++.
SELECT DEVELOPIN,COUNT(TITLE) FROM SOFTWARE WHERE DEVELOPIN NOT IN ('C','C++') GROUP BY DEVELOPIN

--23. DISPLAY THE AVERAGE DIFFERENCE BETWEEN SCOST AND DCOST FOR EACH PACKAGE .
SELECT TITLE, AVG(SCOST-DCOST) AS AVG_DIFF FROM SOFTWARE GROUP BY TITLE

--24. DISPLAY THE TOTAL SCOST AND DCOST AND THE AMOUNT TO BE RECOVERED FOR EACH PROGRAMMER FOR THOSE WHOOSE COST HAS NOT YET BEEN RECOVERED.
SELECT SUM(SCOST)AS TOTAL_SCOST,SUM(DCOST) AS TOTAL_DCOST , SUM(DCOST-SCOST) AS AMOUNT_TOBE_RECOVERED 
FROM SOFTWARE WHERE SCOST<DCOST

--25. WHO IS THE HIGHEST PAID C PROGRAMMER?
SELECT PNAME FROM PROGRAMMER WHERE SALARY=(SELECT MAX(SALARY) FROM PROGRAMMER WHERE PROF1='C' OR PROF2='C')

--26. WHO IS THE HIGHEST PAID FEMALE COBOL PROGRAMMER? 
SELECT PNAME FROM PROGRAMMER WHERE GENDER='F' AND SALARY=
(SELECT MAX(SALARY) FROM PROGRAMMER WHERE PROF1='COBOL' OR PROF2='COBOL')



