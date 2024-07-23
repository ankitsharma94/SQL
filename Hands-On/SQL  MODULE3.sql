--1. HOW MANY PROGRAMMERS DONT KNOW PASCAL AND C?
SELECT COUNT(*) FROM PROGRAMMER WHERE PROF1 NOT IN('PASCAL','C') AND PROF2 NOT IN ('PASCAL','C')

--2. DISPLAY THE DETAILS OF THOSE WHO DONT KNOW CLIPPER,COBOL OR PASCAL.
SELECT * FROM PROGRAMMER WHERE PROF1 NOT IN ('CLIPPER','COBOL','PASCAL')
AND PROF2 NOT IN ('CLIPPER','COBOL','PASCAL') 

--3. DISPLAY EACH LANGUAGE NAME WITH AVERAGE DEVELOPMENT COST ,AVERAGE SELLING COST AND AVERAGE PRICE PER COPY.
SELECT DEVELOPIN, AVG(DCOST) AS AVGDC, AVG(SCOST) AS AVGSC,AVG(SCOST*SOLD) AS AVGPPC FROM SOFTWARE
GROUP BY DEVELOPIN

--4. LIST THE PROGAMMER NAMES(FROM THE PROGRAMMER TABLE)AND THE NUMBER OF PACKAGES EACH HAVE DEVELOPED.
SELECT PG.PNAME ,SW.DEVELOPIN, COUNT(DEVELOPIN) AS COUNT FROM PROGRAMMER PG 
INNER JOIN  SOFTWARE SW ON PG.PNAME=SW.PNAME
GROUP BY PG.PNAME,SW.DEVELOPIN

--5. LIST EACH PROF WITH THE NUMBER OF PROGRAMMERS HAVING THAT PROF AND THE NUMBER OF PACKAGES IN THAT PROF.
SELECT PROF1,PROF2, PG.PNAME ,SOLD FROM PROGRAMMER PG 
INNER JOIN  SOFTWARE SW ON PG.PNAME=SW.PNAME
GROUP BY PROF1,PROF2,PG.PNAME,SOLD

--6. HOW MANY PACKAGES WERE DEVELOPED BY THE MOST EXPERIENCED PROGRAMMER FROM BDPS?
SELECT COUNT(DEVELOPIN) FROM PROGRAMMER PG INNER JOIN SOFTWARE SW ON PG.PNAME=SW.PNAME WHERE DOJ=
(SELECT MIN(DOJ) AS EXPERIENCE FROM PROGRAMMER  PG INNER JOIN STUDIES SD ON PG.PNAME =SD.PNAME 
WHERE INSTITUTE='BDPS')

--7. HOW MANY PACKAGES WERE DEVELOPED BY FEMALE PROGRAMMERS EARNING MORE THAN HIGHEST PAID MALE PROGRAMMER ?
SELECT COUNT(DEVELOPIN) FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME=SW.PNAME
WHERE GENDER ='F' AND SALARY>(SELECT MAX(SALARY) FROM PROGRAMMER WHERE GENDER='M')

--8. HOW MUCH DOES THE PERSON WHO DEVELOPED THE HIGHEST SELLING PACKAGE EARN AND WHAT COURSE DID HE/SHE UNDERGO?
SELECT SALARY,COURSE  FROM PROGRAMMER PG INNER JOIN STUDIES ST ON PG.PNAME=ST.PNAME  WHERE PG.PNAME=
(SELECT PNAME FROM SOFTWARE WHERE SCOST=(SELECT MAX(SCOST) FROM SOFTWARE))

select A.pname,A.course,B.sold,(B.SCOST*B.sold) earn from studies A inner join software B
ON A.Pname=B.Pname
where sold=(select MAX(sold) from software)
--9. IN WHICH INSTITUTE DID THE PERSON WHO DEVELOPED THE COSTLIEST PACKAGE STUDY?
SELECT INSTITUTE FROM STUDIES ST INNER JOIN SOFTWARE SW ON ST.PNAME=SW.PNAME WHERE SW.PNAME=
(SELECT PNAME FROM SOFTWARE WHERE DCOST=(SELECT MAX(DCOST) FROM SOFTWARE)) 

--10. DISPLAY THE NAMES OF THE PROGRAMMERS WHO HAVE NOT DEVELOPED ANY PACKAGES.
SELECT PNAME FROM PROGRAMMER WHERE PNAME NOT IN ( SELECT PNAME FROM SOFTWARE)

--11. DISPLAY THE DETAILS OF THE SOFTWARE THAT HAS BEEN DEVELOPED IN THE LANGUAGE WHICH IS
    --NEITHER  THEIR FIRST NOR THEIR SECOND PROFICIENCY.
SELECT SW.* FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME =PG.PNAME 
WHERE DEVELOPIN NOT IN (PG.PROF1,PG.PROF2)

--12. DISPLAY THE DETAILS OF THE SOFTWARE DEVELOPED BY THE MALE PROGRAMMERS BORN BEFORE 1965 AND 
    --FEMALE PROGRAMMERS BORN AFTER 1975.
SELECT * FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME=PG.PNAME
WHERE(YEAR(DOB)<1965  AND GENDER ='M')  AND (YEAR(DOB)>1975 AND GENDER='F')

--13. DISPLAY THE NUMBER OF PACKAGES ,NUMBER OF COPIES SOLD AND THE SALES VALUE OF EACH PROGRAMMER 
    --INSTITUTE WISE.
select institute,software.pname ,count(title) as count , sum(sold) as sold , sum(scost*sold) as
sales from software inner join studies
on software.pname=studies.pname group by institute ,software.pname

--14. DISPLAY THE DETAILS OF THE SOFTWARE DEVELOPED BY THE MALE PROGRAMMERS EARNING MORE THAN 3000.
SELECT SW.* FROM SOFTWARE SW INNER JOIN PROGRAMMER PG ON SW.PNAME=PG.PNAME 
WHERE GENDER='M' AND SALARY>3000

--15. WHO ARE THE FEMALE PROGRAMMERS EARNING MORE THAN THE HIGHEST PAID MALE PROGRAMMER?
SELECT PNAME FROM PROGRAMMER WHERE GENDER ='F' AND 
SALARY>(SELECT MAX(SALARY) FROM PROGRAMMER WHERE GENDER='M')

--16. WHO ARE THE MALE PROGRAMMERS EARNING BELOW THE AVERAGE SALARY OF FEMALE PROGRAMMERS?
SELECT PNAME FROM PROGRAMMER WHERE GENDER ='M' AND 
SALARY<(SELECT AVG(SALARY) FROM PROGRAMMER WHERE GENDER='F')

--17. DISPLAY THE LANGUAGE USED BY EACH PROGRAMMER TO DEVELOP THE HIGHEST SELLING AND LOWEST SELLING PACKAGE.
SELECT DEVELOPIN FROM  SOFTWARE 
WHERE SOLD=(SELECT MAX(SOLD) AS HST_SLNG_PKG FROM SOFTWARE) AND
SOLD=(SELECT MIN(SOLD) AS MIN_SLNG_PKG FROM SOFTWARE)

--18. DISPLAY THE NAMES OF THE PACKAGES WHICH HAVE SOLD LESS THAN THE AVERAGE NUMBER OF COPIES.
SELECT TITLE FROM SOFTWARE WHERE SOLD<(SELECT AVG(SOLD) FROM SOFTWARE)

--19. WHICH IS THE COSTLIEST PACKAGE DEVELOPED IN PASCAL?
SELECT TITLE FROM SOFTWARE WHERE DCOST =(SELECT MAX(DCOST) FROM SOFTWARE WHERE DEVELOPIN='PASCAL')

--20. HOW MANY COPIES OF THE PACKAGE THAT HAS THE LEAST DIFFERENCE BETWEEN DEVELOPMENT AND 
    --SELLING COST WERE SOLD?
SELECT SOLD FROM SOFTWARE WHERE (DCOST-SCOST) =(SELECT MIN(DCOST-SCOST) FROM SOFTWARE)

--21. WHICH LANGUAGE HAS BEEN USED TO DEVELOP THE PACKAGE WHICH HAS THE HIGHEST SALES AMOUNT?
SELECT DEVELOPIN FROM SOFTWARE WHERE (SCOST*SOLD)=(SELECT MAX(SCOST*SOLD) FROM SOFTWARE)

--22. WHO DEVELOPED THE PACKAGE THAT HAS SOLD THE LEAST NUMBER OF COPIES ?
SELECT PNAME FROM SOFTWARE WHERE SOLD=(SELECT MIN(SOLD) FROM SOFTWARE)

--23. DISPLAY THE NAMES OF THE COURSES WHOOSE FEES ARE WITHIN 1000(+ OR-) OF THE AVERAGE FEES.
SELECT COURSE FROM STUDIES WHERE [COURSE FEE] BETWEEN(SELECT AVG([COURSE FEE])-1000 FROM STUDIES)AND
(SELECT AVG([COURSE FEE])+1000 FROM STUDIES)


--24. DISPLAY THE NAMES OF THE INSTITUTE AND COURSE WHICH HAS BELOW AVERAGE COURSE FEE.
SELECT INSTITUTE,COURSE FROM STUDIES WHERE [COURSE FEE] <(SELECT AVG([COURSE FEE]) FROM STUDIES)

--25. WHICH INSTITUTE CONDUCTS THE COSTLIEST COURSRE?
SELECT INSTITUTE FROM STUDIES WHERE [COURSE FEE]=(SELECT MAX([COURSE FEE]) FROM STUDIES)

--26. WHAT IS THE COSTLIEST COURSE ?
SELECT COURSE FROM STUDIES WHERE [COURSE FEE]=(SELECT MAX([COURSE FEE]) FROM STUDIES) 







