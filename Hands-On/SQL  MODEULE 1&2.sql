CREATE TABLE SALESMAN(
SalesmanID INT,
SalesmanName VARCHAR(50),
Commission VARCHAR(50),
City VARCHAR(50),
Age INT )

Insert into SALESMAN values (101,'Joe',50,'California',17)
Insert into SALESMAN values (102,'Simon',75,'Texas',25),(103,'Jessie',105,'Florida',35),
                            (104,'Danny',100,'Texas',22),(105,'Lia',65,'New Jersy',30)
select * from SALESMAN

Create Table CUSTOMERS(
SalesmanId int,
CustomerId int,
CustomerName varchar(50),
PurchaseAmount int)

Insert into CUSTOMERS values (101,2345,'Andrew',550),(103,1575,'Lucky',4500),
                             (104,2345,'Andrew',4000),(107,3747,'Remona',2700),
							 (110,4004,'Julia',4545)

select * from CUSTOMERS


Create table ORDERS(
OrderId int,
CustomerId int,
SalesmanId int,
OrderDate Date,
Amount int)

Insert into ORDERS values (5001,2345,101,'2021-07-01',550),(5003,1234,105,'2022-02-15',1500)

select * from ORDERS
select * from CUSTOMERS
select * from SALESMAN

--1. Insert a new record in your Orders table.
Insert into ORDERS values (5002,4004,110,'2024-03-29',2000)

--2. Add Primary key constraint for SalesmanId column in Salesman table. Add default constraint for City column in Salesman table.
--Add Foreign key constraint for SalesmanId column in Customer table. Add not null constraint in Customer_name column 
--for the Customer table.
Alter table Salesman alter column salesmanid int not null
alter table salesman add constraint pk primary key (salesmanid)
alter table salesman add constraint df default 'India' for city
alter table customers add constraint forekey foreign key (SalesmanId) references Salesman(SalesmanId)
alter table customers alter column customerName varchar(50) not null

--3. Fetch the data where the Customer’s name is ending with ‘N’ also get the purchase
--amount value greater than 500.
select * from CUSTOMERS 
where CustomerName like '%N' and PurchaseAmount >500

--4. Using SET operators, retrieve the first result with unique SalesmanId values from two
--tables, and the other result containing SalesmanId with duplicates from two tables.
select salesmanid from
(select SalesmanID from SALESMAN
union
select SalesmanId from CUSTOMERS) as smid
group by SalesmanID
having count(*) = 1

select salesmanid from
(select SalesmanID from SALESMAN
union
select SalesmanId from CUSTOMERS) as smid
group by SalesmanID
having count(*) > 1

--5. Display the below columns which has the matching data.
--Orderdate, Salesman Name, Customer Name, Commission, and City which has the range of Purchase Amount between 500 to 1500.
select OrderDate,SalesmanName,CustomerName,Commission,City,PurchaseAmount from SALESMAN 
inner join CUSTOMERS on SALESMAN.SalesmanID = CUSTOMERS.SalesmanId
inner join ORDERS on CUSTOMERS.SalesmanID = ORDERS.SalesmanId
where PurchaseAmount between 500 and 1500


--6. Using right join fetch all the results from Salesman and Orders table.
select * from SALESMAN right join ORDERS on SALESMAN.SalesmanID = ORDERS.SalesmanId