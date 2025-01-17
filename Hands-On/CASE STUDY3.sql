select * from Continent
select * from Customers
select * from Transactions

--1. DISPLAY THE COUNT OF THE CUSTOMERS IN EACH REGION WHO HAVE DONE THE TRANSACTION IN THE YEAR 2020.
SELECT CS.REGION_ID, COUNT(DISTINCT CS.customer_id) AS COUNT FROM CONTINENT CT 
INNER JOIN CUSTOMERS CS ON CT.REGION_ID=CS.REGION_ID
INNER JOIN TRANSACTIONS TS ON CS.CUSTOMER_ID=TS.CUSTOMER_ID WHERE YEAR(TXN_DATE)=2020
GROUP BY CS.REGION_ID
ORDER BY REGION_ID

--2. DISPLAY THE MAXIMUM AND MINIMUM TRANSACTION AMOUNT OF EACH TRANSACTION TYPE.
SELECT TXN_TYPE,MAX(TXN_AMOUNT) AS MAX_TXN, MIN(TXN_AMOUNT) AS MIN_TXN FROM TRANSACTIONS
GROUP BY TXN_TYPE

--3. DISPLAY THE CUSTOMER_ID,REGION_NAME,TRANSACTION AMOUNT WHERE TRANSACTION TYPE IS DEPOSIT AND 
   --TRANSACTION AMOUNT>500
SELECT CS.CUSTOMER_ID,CT.REGION_NAME,TXN_AMOUNT FROM CONTINENT CT 
INNER JOIN CUSTOMERS CS ON CT.REGION_ID=CS.REGION_ID
INNER JOIN TRANSACTIONS TS ON CS.CUSTOMER_ID=TS.CUSTOMER_ID
WHERE TXN_TYPE='DEPOSIT' AND TXN_AMOUNT>500

--4. FIND DUPLICATE RECORDS IN THE CUSTOMERS TABLE?
SELECT CUSTOMER_ID,COUNT(*) FROM Customers 
GROUP BY CUSTOMER_ID 
HAVING COUNT(*)>1

--5. DISPLAY THE CUSTOMER_ID,REGION NAME,TRANSACTION TYPE AND TRANSACTION AMOUNT
   --FOR THE MINIMUM TRANSACTION AMOUNT IN DEPOSIT.

SELECT DISTINCT TS.CUSTOMER_ID,CT.REGION_NAME,TS.TXN_TYPE,TXN_AMOUNT FROM CONTINENT CT 
INNER JOIN CUSTOMERS CS ON CT.REGION_ID=CS.REGION_ID
INNER JOIN TRANSACTIONS TS ON CS.CUSTOMER_ID=TS.CUSTOMER_ID  WHERE TXN_AMOUNT=
(SELECT MIN(TXN_AMOUNT) FROM TRANSACTIONS WHERE TXN_TYPE='DEPOSIT')

SELECT  TS.CUSTOMER_ID,CT.REGION_NAME,TS.TXN_TYPE,TXN_AMOUNT FROM CONTINENT CT 
INNER JOIN CUSTOMERS CS ON CT.REGION_ID=CS.REGION_ID
INNER JOIN TRANSACTIONS TS ON CS.CUSTOMER_ID=TS.CUSTOMER_ID  WHERE TXN_AMOUNT=
(SELECT MIN(TXN_AMOUNT) FROM TRANSACTIONS WHERE TXN_TYPE='DEPOSIT')
GROUP BY TS.CUSTOMER_ID,CT.REGION_NAME,TS.TXN_TYPE,TXN_AMOUNT

--6. CREATE A STORED PROCEDURE TO DISPLAY DETAILS OF CUSTOMERS IN THE TRANSACTION TABLE 
   --WHERE TRANSACTION DATE IS GREATER THAN JUN 2020.  
CREATE OR ALTER PROCEDURE PROC001 (@X DATE)
AS
BEGIN
SELECT CS.CUSTOMER_ID,REGION_NAME,txn_date,txn_type FROM TRANSACTIONS TS 
INNER JOIN CUSTOMERS CS ON TS.CUSTOMER_ID=CS.CUSTOMER_ID
INNER JOIN CONTINENT CT ON CT.REGION_ID=CS.REGION_ID 
WHERE TXN_DATE> @X
END
EXEC PROC001 '2020-01-01'

--7. CREATE A STORED PROCEDURE TO INSERT A RECORD IN THE CONTINENT TABLE.
CREATE OR ALTER PROCEDURE INSERTCONTINENT (@X INT,@Y VARCHAR(20))
AS
BEGIN
INSERT INTO CONTINENT (REGION_ID,REGION_NAME) VALUES (@X,@Y)
END

--8. CREATE A STORED PROCEDURE TO DISPLAY THE DETAILS OF TRANSACTIONS THAT HAPPENED ON A SPECIFIC DAY.
CREATE PROCEDURE PROC_002 (@TXN_DATE DATE)
AS
BEGIN
SELECT * FROM TRANSACTIONS WHERE TXN_DATE=@TXN_DATE
END
 EXEC PROC_002 '2020-01-01'

--9. CREATE A USER DEFINED FUNCTION TO ADD 10% OF THE TRANSACTION AMOUNT IN THE TABLE.
CREATE OR ALTER FUNCTION FUN_10AMNT (@TXN_AMNT DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @Y DECIMAL(10,2)
SET @Y = @TXN_AMNT+(@TXN_AMNT*0.10)
RETURN @Y
END
SELECT *,DBO.FUN_10AMNT(TXN_AMOUNT) AS UPDATED_AMNT FROM TRANSACTIONS

--10. CREATE A USER DEFINED FUNCTION TO FIND THE TOTAL TRANSACTION AMOUNT FOR A GIVEN TRANSACTION TYPE.
CREATE FUNCTION FUN_TOTALAMNT (@TXN_TYPE VARCHAR(40))
RETURNS NUMERIC(10,2)
AS
BEGIN
RETURN (SELECT SUM(TXN_AMOUNT) AS TOTAL_TXN_AMOUNT FROM TRANSACTIONS WHERE TXN_TYPE=@TXN_TYPE)
END
SELECT DBO.FUN_TOTALAMNT ('WITHDRAWAL') AS TOTAL_TXNAMNT

--11. CREATE A TABLE VALUE FUNCTION WHICH COMPRISES THE COLUMNS CUSTOMER_ID,
    --REGION_ID,TXN_DATE,TXN_TYPE,TXN_AMOUNT WHICH WILL RETRIEVE DATA FROM THE ABOVE TABLE.
CREATE FUNCTION FUN_TABLE()
RETURNS TABLE
AS
RETURN (SELECT TS.*,CT.REGION_ID FROM CONTINENT CT 
INNER JOIN CUSTOMERS CS ON CT.REGION_ID=CS.REGION_ID
INNER JOIN TRANSACTIONS TS ON CS.CUSTOMER_ID=TS.CUSTOMER_ID)

SELECT * FROM DBO.FUN_TABLE()

--12. CREATE A TRY...CATCH BLOCK TO PRINT A REGION ID AND REGION NAME IN A SINGLE COLUMN.
BEGIN TRY
SELECT CAST(REGION_ID AS VARCHAR(20))+' -- '+REGION_NAME FROM CONTINENT 
END TRY
BEGIN CATCH
PRINT 'ERROR OCCURED'+ERROR_MESSAGE()
END CATCH

--13. CREATE A TRY...CATCH BLOCK TO INSERT A VALUE IN THE CONTINENT TABLE.
begin try
	insert into continent values
    (7/0,'S.America')
end try
begin catch
	print 'error 404'
end catch
--14. CREATE A TRIGGER TO PREVENT DELETING A TABLE IN A DATABASE.
create or alter Trigger trgdelcontinent 
on continent
FOR delete
as begin
 print 'data cannot be delete'
 rollback
end

delete from continent
where region_id=8

--15. CREATE A TRIGGER TO AUDIT THE DATA IN A TABLE.
create  table AUDIT
(
region_id INT,
Region_name Varchar(30),
Date_ datetime Default(getdate())
)

create trigger TR_new
ON continent
for insert 
as begin 
declare @ID INT, @name  varchar(20)
select @ID=region_id,@name=region_name from inserted
insert into AUDIT values
(@ID,@name,default)
end

insert into continent values
(8,'newone')

select * from  continent
select * from AUDIT

--16. CREATE A TRIGGER TO PREVENT LOGIN OF THE SAME USER ID IN MULTIPLE PAGES.
CREATE TRIGGER PreventMultipleLogins
ON transactions
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT customer_id
        FROM transactions 
        WHERE customer_id IN (SELECT customer_id FROM INSERTED)
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Multiple logins are not allowed.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Transactions(customer_id, txn_date)
        SELECT customer_id, txn_date
        FROM INSERTED
    END
END

--17. DISPLAY TOP N CUSTOMERS ON THE BASIS OF TRANSACTION TYPE.
create function  NUM(@num int , @type Varchar(30))
returns table
as
return(select TOP(@num) Customer_id from Transactions where txn_type = @type)

select * from NUM(6,'deposit')

--18. CREATE A PIVOT TABLE TO DISPLAY THE TOTAL PURCHASE, WITHDRAWAL AND DEPOSIT FOR ALL THE CUSTOMERS.
select * from (select customer_id,txn_type,txn_amount from Transactions ) result
PIVOT 
(
 sum(txn_amount)
 for txn_type
 IN
 (deposit,withdrawal,purchase)
 )as Pivot_table
 order by customer_id


