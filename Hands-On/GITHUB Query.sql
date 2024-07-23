-- Amazon Interview Practice 21/02/2024

/* 1. You have two tables: Product and Supplier.
- Product Table Columns: Product_id, Product_Name, Supplier_id, Price
- Supplier Table Columns: Supplier_id, Supplier_Name, Country
*/

CREATE TABLE suppliers(supplier_id int PRIMARY KEY,
					  supplier_name varchar(25),
					  country VARCHAR(25)
					  )
-- let's insert some values 

INSERT INTO suppliers
VALUES(501, 'alan', 'India'),
		(502, 'rex', 'US'),
		(503, 'dodo', 'India'),
		(504, 'rahul', 'US'),
		(505, 'zara', 'Canda'),
		(506, 'max', 'Canada')

CREATE TABLE products(

						product_id int PRIMARY KEY,
						product_name VARCHAR(25),
						supplier_id int,
						price float,
						FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
						)

INSERT INTO products
VALUES	(201, 'iPhone 14', '501', 1299),
		(202, 'iPhone 8', '502', 999),
		(204, 'iPhone 13', '502', 1199),
		(203, 'iPhone 11', '503', 1199),
		(205, 'iPhone 12', '502', 1199),
		(206, 'iPhone 14', '501', 1399),
		(214, 'iPhone 15', '503', 1499),
		(207, 'iPhone 15', '505', 1499),
		(208, 'iPhone 15', '504', 1499),
		(209, 'iPhone 12', '502', 1299),
		(210, 'iPhone 13', '502', 1199),
		(211, 'iPhone 11', '501', 1099),
		(212, 'iPhone 14', '503', 1399),
		(213, 'iPhone 8', '502', 1099)
;

-- adding more products 

INSERT INTO products
VALUES	(222, 'Samsung Galaxy S21', '504', 1699),
		(223, 'Samsung Galaxy S20', '505', 1899),
		(224, 'Google Pixel 6', '501', 899),
		(225, 'Google Pixel 5', '502', 799),
		(226, 'OnePlus 9 Pro', '503', 1699),
		(227, 'OnePlus 9', '502', 1999),
		(228, 'Xiaomi Mi 11', '501', 899),
		(229, 'Xiaomi Mi 10', '504', 699),
		(230, 'Huawei P40 Pro', '505', 1099),
		(231, 'Huawei P30', '502', 1299),
		(232, 'Sony Xperia 1 III', '503', 1199),
		(233, 'Sony Xperia 5 III', '501', 999),
		(234, 'LG Velvet', '505', 1899),
		(235, 'LG G8 ThinQ', '504', 799),
		(236, 'Motorola Edge Plus', '502', 1099),
		(237, 'Motorola One 5G', '501', 799),
		(238, 'ASUS ROG Phone 5', '503', 1999),
		(239, 'ASUS ZenFone 8', '504', 999),
		(240, 'Nokia 8.3 5G', '502', 899),
		(241, 'Nokia 7.2', '501', 699),
		(242, 'BlackBerry Key2', '504', 1899),
		(243, 'BlackBerry Motion', '502', 799),
		(244, 'HTC U12 Plus', '501', 899),
		(245, 'HTC Desire 20 Pro', '505', 699),
		(246, 'Lenovo Legion Phone Duel', '503', 1499),
		(247, 'Lenovo K12 Note', '504', 1499),
		(248, 'ZTE Axon 30 Ultra', '501', 1299),
		(249, 'ZTE Blade 20', '502', 1599),
		(250, 'Oppo Find X3 Pro', '503', 1999);

SELECT * FROM suppliers;
SELECT * FROM products;


-- Write an SQL query to find the name of the product with the highest  price in each country.
 with cte as
 (
 select country,product_name,price,
 ROW_NUMBER() over (partition by country order by price desc) as RN 
 from products 
 join suppliers on products.supplier_id = suppliers.supplier_id 
 )

 select country, product_name , price from cte where RN = 1

                      --OR--

select   country,product_name,price 
from
(select country,product_name,price,
ROW_NUMBER () over (partition by country order by price desc) as RN
from products p join suppliers s 
on p.supplier_id = s.supplier_id) x1
where RN = 1

-- Q.2 

/* 
You have two tables: Customer and Transaction.
- Customer Table Columns: Customer_id, Customer_Name, Registration_Date
- Transaction Table Columns: Transaction_id, Customer_id, Transaction_Date, Amount

-- Write an SQL query to calculate the total transaction amount for each customer for the current year. 
The output should contain Customer_Name and the total amount.
*/
-- Create Customer table
CREATE TABLE Customers (
    Customer_id INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Registration_Date DATE
);

-- Create Transaction table
CREATE TABLE Transactions (
    Transaction_id INT PRIMARY KEY,
    Customer_id INT,
    Transaction_Date DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);

-- Insert records into Customer table
INSERT INTO Customers (Customer_id, Customer_Name, Registration_Date)
VALUES
    (1, 'John Doe', '2023-01-15'),
    (2, 'Jane Smith', '2023-02-20'),
    (3, 'Michael Johnson', '2023-03-10');

-- Insert records into Transaction table
INSERT INTO Transactions (Transaction_id, Customer_id, Transaction_Date, Amount)
VALUES
    (201, 1, '2024-01-20', 50.00),
    (202, 1, '2024-02-05', 75.50),
    (203, 2, '2023-02-22', 100.00),
    (204, 3, '2022-03-15', 200.00),
    (205, 2, '2024-03-20', 120.75),
	(301, 1, '2024-01-20', 50.00),
    (302, 1, '2024-02-05', 75.50),
    (403, 2, '2023-02-22', 100.00),
    (304, 3, '2022-03-15', 200.00),
    (505, 2, '2024-03-20', 120.75);

SELECT * FROM customers;
SELECT * FROM Transactions;

-- 1. find total transaction amt group by each customer filter with current year 
-- put where condition to check if the transaction are current year year 1  

select Customer_Name,c.Customer_id,sum(Amount) as TotalAmount
from Transactions t 
join Customers c on t.Customer_id = c.Customer_id 
where DATEPART(YEAR,Transaction_Date)  = DATEPART(YEAR,GETDATE())
group by Customer_Name,c.Customer_id

-- verifying it
SELECT
	SUM(amount)
FROM Transactions
WHERE customer_id = 1 AND datepart(YEAR,Transaction_Date) = '2024'




-- Day 02/30 days SQL challenge
-- SCHEMA

-- Create pages table
CREATE TABLE pages (
    page_id INTEGER PRIMARY KEY,
    page_name VARCHAR(255)
);

-- Insert data into pages table
INSERT INTO pages (page_id, page_name) VALUES
(20001, 'SQL Solutions'),
(20045, 'Brain Exercises'),
(20701, 'Tips for Data Analysts');

-- Create page_likes table
CREATE TABLE page_likes (
    user_id INTEGER,
    page_id INTEGER,
    liked_date DATETIME,
    FOREIGN KEY (page_id) REFERENCES pages(page_id)
);

-- Insert data into page_likes table
INSERT INTO page_likes (user_id, page_id, liked_date) VALUES
(111, 20001, '2022-04-08 00:00:00'),
(121, 20045, '2022-03-12 00:00:00'),
(156, 20001, '2022-07-25 00:00:00');

/*
Question 1:
Write a SQL query to retrieve the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs.
*/
-- Question 1 link ::  https://datalemur.com/questions/sql-page-with-no-likes

select * from pages
select * from page_likes

select pages.page_id from pages 
left join page_likes on pages.page_id = page_likes.page_id
group by pages.page_id
having COUNT(liked_date) = 0
order by pages.page_id asc 

-- Question 2 App Click-through Rate (CTR) [Facebook SQL Interview Question]
-- ------------------------------------------------------------------------------------------------------------------------------------


-- Create the events table
CREATE TABLE events (
    app_id INTEGER,
    event_type VARCHAR(10),
    timestamp DATETIME
);

-- Insert records into the events table
INSERT INTO events (app_id, event_type, timestamp) VALUES
(123, 'impression', '2022-07-18 11:36:12'),
(123, 'impression', '2022-07-18 11:37:12'),
(123, 'click', '2022-07-18 11:37:42'),
(234, 'impression', '2022-07-18 14:15:12'),
(234, 'click', '2022-07-18 14:16:12');

/*
Question 2: 
Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.
Definition and note:
Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
To avoid integer division, multiply the CTR by 100.0, not 100.
Expected Output Columns: app_id, ctr
*/

 SELECT 
    app_id,
    ROUND((100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / COUNT(*)), 2) AS ctr
FROM 
    events
WHERE 
    YEAR(timestamp) = 2022
GROUP BY 
    app_id;

	   ---DAY 03---

	-- DDL for Salaries table
CREATE TABLE Salaries (
emp_name VARCHAR(50),
department VARCHAR(50),
salary INT,
PRIMARY KEY (emp_name, department)
);

-- DML for Salaries table
INSERT INTO Salaries (emp_name, 
					  department, salary) VALUES
('Kathy', 'Engineering', 50000),
('Roy', 'Marketing', 30000),
('Charles', 'Engineering', 45000),
('Jack', 'Engineering', 85000),
('Benjamin', 'Marketing', 34000),
('Anthony', 'Marketing', 42000),
('Edward', 'Engineering', 102000),
('Terry', 'Engineering', 44000),
('Evelyn', 'Marketing', 53000),
('Arthur', 'Engineering', 32000);

/*Write an SQL query to calculate the difference between the highest salaries in the marketing and engineering department. 
Output the absolute difference in salaries.*/

select ABS(MAX(case when department = 'marketing' then salary end)-
           MAX(case when department = 'engineering' then salary end)) as salary_difference
from Salaries

      ---DAY 04---

	  CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- Insert values into the customers table
INSERT INTO customer (customer_id, customer_name, age, gender)
VALUES
    (1, 'John Doe', 30, 'Male'),
    (2, 'Jane Smith', 25, 'Female'),
    (3, 'Alice Johnson', 35, 'Female'),
    (4, 'Bob Brown', 40, 'Male');

-- Insert values into the orders table
INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
    (101, 1, '2023-01-15', 150.50),
    (102, 2, '2022-02-20', 200.25),
    (103, 3, '2023-03-10', 180.75),
    (104, 4, '2023-04-05', 300.00),
    (105, 1, '2022-05-12', 175.80),
    (106, 2, '2021-06-18', 220.40),
    (107, 3, '2023-07-22', 190.30),
    (108, 4, '2023-08-30', 250.60),
	(109, 4, '2021-08-30', 250.60),
	(110, 4, '2024-01-30', 250.60),
	(111, 4, '2023-08-30', 250.60);

/* IBM Data Analyst SQL Question
Write an SQL query to find the average order amount for male and female customers separately
return the results with 2 DECIMAL.
*/
select * from customer
select * from orders

select gender,round(AVG(total_amount),2) as order_amnt from orders o
join customer c on o.customer_id = c.customer_id
where gender = 'male' or gender = 'female'
group by gender

------------------------------------------------------------------------------------------
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10, 2)
);

-- Insert sample values into the sales table
INSERT INTO sales (order_id, order_date, product_id, quantity, price_per_unit)
VALUES
    (1, '2022-03-10', 101, 2, 15.00),
    (2, '2022-04-05', 102, 1, 25.50),
    (3, '2023-01-15', 103, 3, 10.75),
    (4, '2023-02-20', 104, 2, 30.20),
    (5, '2022-05-12', 105, 4, 12.80),
    (6, '2023-06-18', 106, 2, 22.40),
    (7, '2023-07-22', 107, 1, 45.30),
    (8, '2021-08-30', 108, 3, 20.60);


/*Q.2 You have been given a table named sales with the following columns:
Write an SQL query to find out the total sales revenue generated for each month in the year 2023.*/
select * from sales

select DATEPART(MONTH,order_date) as sales_month,(quantity*price_per_unit) as total_revenue from sales
where YEAR(order_date) = '2023'

-- Day 05/30 days SQL challenge

-- Question 2

-- Create product_revenue table
CREATE TABLE product_revenue (
    product_name VARCHAR(255),
    year INTEGER,
    revenue DECIMAL(10, 2)
);

-- Insert sample records
INSERT INTO product_revenue (product_name, year, revenue) VALUES
('Product A', 2022, 10000.00),
('Product A', 2023, 9500.00),
('Product B', 2022, 15000.00),
('Product B', 2023, 14500.00),
('Product C', 2022, 8000.00),
('Product C', 2023, 8500.00),
('Product D', 2022, 12000.00),
('Product D', 2023, 12500.00),
('Product E', 2022, 20000.00),
('Product E', 2023, 19000.00),
('Product F', 2022, 7000.00),
('Product F', 2023, 7200.00),
('Product G', 2022, 18000.00),
('Product G', 2023, 17000.00),
('Product H', 2022, 3000.00),
('Product H', 2023, 3200.00),
('Product I', 2022, 9000.00),
('Product I', 2023, 9200.00),
('Product J', 2022, 6000.00),
('Product J', 2023, 5900.00);

/*Question:
Find the top 5 products whose revenue has decreased in comparison to the 
previous year (both 2022 and 2023). Return the product name, 
revenue for the previous year, revenue for the current year, 
revenue decreased, and the decreased ratio (percentage).
*/
select * from product_revenue

		WITH revenue_comparison AS (
    SELECT 
        product_name,
        year,
        revenue,
        LAG(revenue) OVER (PARTITION BY product_name ORDER BY year) AS prev_year_revenue
    FROM product_revenue
)
SELECT 
    product_name,
    prev_year_revenue AS previous_year_revenue,
    revenue AS current_year_revenue,
    (prev_year_revenue - revenue) AS revenue_decreased,
    ((prev_year_revenue - revenue) / prev_year_revenue) * 100 AS decreased_ratio_percentage
FROM revenue_comparison
WHERE prev_year_revenue IS NOT NULL
ORDER BY revenue_decreased DESC
LIMIT 5;

-- Day 06/30 days sql challenge

-- SCHEMAS

-- Create viewership table
CREATE TABLE viewership (
    device_type VARCHAR(255),
    viewership_count INTEGER
);

-- Insert sample records
INSERT INTO viewership (device_type, viewership_count) VALUES
('laptop', 5000),
('tablet', 3000),
('phone', 7000),
('laptop', 6000),
('tablet', 4000),
('phone', 8000),
('laptop', 5500),
('tablet', 3500),
('phone', 7500);

/* Question:
Write a query that calculates the total viewership for laptops and mobile devices, 
where mobile is defined as the sum of tablet and phone viewership. Output the total 
viewership for laptops as laptop_views and the total viewership for mobile devices as mobile_views. */

select 
    sum(case when device_type = 'laptop' then viewership_count else 0 end ) as laptop_views,
    sum(case when device_type in ('tablet', 'phone') then viewership_count else 0 end) as mobile_views
from viewership

-- Day 07/30 SQL Challenge


-- Create product_spend table
CREATE TABLE product_spend (
    category VARCHAR(255),
    product VARCHAR(255),
    user_id INTEGER,
    spend DECIMAL(10, 2),
    transaction_date TIMESTAMP
);

-- Insert sample records
INSERT INTO product_spend (category, product, user_id, spend) VALUES
('appliance', 'refrigerator', 165, 246.00),
('appliance', 'refrigerator', 123, 299.99),
('appliance', 'washing machine', 123, 219.80),
('electronics', 'vacuum', 178, 152.00),
('electronics', 'wireless headset', 156, 249.90),
('electronics', 'vacuum', 145, 189.00);

/* Amazon Interview question
Question:
Write a query to identify the top two highest-grossing products 
within each category in the year 2022. Output should include the category,
product, and total spend. */
select * from product_spend

select category,product,sum(spend) as total_spend, 
rank() over (partition by category order by sum(spend) desc) as ranking
from product_spend
where DATEPART(YEAR,transaction_date) = '2022'
group by category,product


-- Day 08/30 days SQL Challenge



-- Create tweets table
CREATE TABLE tweet (
    tweet_id INTEGER,
    user_id INTEGER,
    msg VARCHAR(255),
    tweet_date date
);

-- Insert sample records
INSERT INTO tweet (tweet_id, user_id, msg, tweet_date) VALUES
(214252, 111, 'Am considering taking Tesla private at $420. Funding secured.', '2021-12-30 00:00:00'),
(739252, 111, 'Despite the constant negative press covfefe', '2022-01-01 00:00:00'),
(846402, 111, 'Following @NickSinghTech on Twitter changed my life!', '2022-02-14 00:00:00'),
(241425, 254, 'If the salary is so competitive why won’t you tell me what it is?', '2022-03-01 00:00:00'),
(231574, 148, 'I no longer have a manager. I can\''t be managed', '2022-03-23 00:00:00');

/* Question:
Write a query to obtain a histogram of tweets posted per user in 2022. 
Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket. */

SELECT 
num_post,
COUNT(user_id) as num_user
FROM
  (
    SELECT
      user_id,
      COUNT(tweet_id) as num_post
    FROM tweet
    WHERE datepart(YEAR,tweet_date) = '2022'
    GROUP BY user_id
    )x1
GROUP BY num_post

-- Day 09 SQL 

-- Create Department table
CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Insert values into Department table
INSERT INTO Department (id, name) VALUES
(1, 'IT'),
(2, 'Sales');

-- Create Employee table
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    departmentId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(id)
);

-- Insert additional records into Employee table
INSERT INTO Employee (id, name, salary, departmentId) VALUES
(8, 'Alice', 75000, 2),
(9, 'Bob', 82000, 2),
(10, 'Carol', 78000, 1),
(11, 'David', 70000, 1),
(12, 'Eva', 85000, 2),
(13, 'Frank', 72000, 1),
(14, 'Gina', 83000, 1),
(15, 'Hank', 68000, 1),
(16, 'Irene', 76000, 2),
(17, 'Jack', 74000, 2),
(18, 'Kelly', 79000, 1),
(19, 'Liam', 71000, 1),
(20, 'Molly', 77000, 2),
(21, 'Nathan', 81000, 1),
(22, 'Olivia', 73000, 2),
(23, 'Peter', 78000, 1),
(24, 'Quinn', 72000, 1),
(25, 'Rachel', 80000, 2),
(26, 'Steve', 75000, 2),
(27, 'Tina', 79000, 1);

/*
-- Question : Find Department's Top three salaries in each department.
Table: department
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |  id is primary key
| name        | varchar |	department_name
+-------------+---------+

Table: employee
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |		id is the primary key
| name         | varchar |
| salary       | int     |
| departmentId | int     |		departmentId is the foreign key	
+--------------+---------+

 A company's executives are interested in seeing who earns the most 
 money in each of the company's departments. 
 A high earner in a department is an employee 
 who has a salary in the top three unique salaries 
 for that department.

-- Write a solution to find the employees 
who are high earners in each of the departments.*/

select dept_name,emp_name,emp_salary from
(SELECT 
d.name as dept_name ,
e.name as emp_name ,
e.salary as emp_salary,
DENSE_RANK() over (partition by departmentid order by salary desc) as rn
FROM employee e
join Department d on e.departmentId = d.id) x1
where rn <= 3


-- Day 10/30 SQL Interview Question - Medium

CREATE TABLE Transaction1 (
    id INT PRIMARY KEY,
    country VARCHAR(255),
    state VARCHAR (100),
    amount INT,
    trans_date DATE
);

INSERT INTO Transaction1 (id, country, state, amount, trans_date) VALUES
(121, 'US', 'approved', 1000, '2018-12-18'),
(122, 'US', 'declined', 2000, '2018-12-19'),
(123, 'US', 'approved', 2000, '2019-01-01'),
(124, 'DE', 'approved', 2000, '2019-01-07');

alter table transaction1 alter column state varchar(100)

/*Write an SQL query to find for each month and country, the number of transactions and their total amount, 
the number of approved transactions and their total amount.
Return the result table in in below order.RANGE

Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
*/
select concat(year(trans_date),'-',MONTH(trans_date)) as Month, country, 
count(1) as trans_count ,
sum(case when state = 'approved' then 1 else 0 end) as approved_count ,
SUM(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from Transaction1
group by concat(year(trans_date),'-',MONTH(trans_date)),country
order by concat(year(trans_date),'-',MONTH(trans_date))

SELECT 
	concat(year(trans_date),'-',MONTH(trans_date)) as Month,
	country,
	COUNT(1) as trans_count,
	SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) as approved_count,
	SUM(amount) as trans_total_amount,
	SUM(CASE WHEN state= 'approved' THEN amount ELSE 0 END) as approved_total_amount
FROM Transaction1
GROUP BY 1, 2;

select * from Transaction1

-- SQL 11/30 Days 

CREATE TABLE reviews (
    review_id INTEGER,
    user_id INTEGER,
    submit_date Date,
    product_id INTEGER,
    stars INTEGER
);

INSERT INTO reviews (review_id, user_id, submit_date, product_id, stars) VALUES
(6171, 123, '2022-06-08 00:00:00', 50001, 4),
(7802, 265, '2022-06-10 00:00:00', 69852, 4),
(5293, 362, '2022-06-18 00:00:00', 50001, 3),
(6352, 192, '2022-07-26 00:00:00', 69852, 3),
(4517, 981, '2022-07-05 00:00:00', 69852, 2),
(8654, 753, '2022-08-15 00:00:00', 50001, 5),
(9743, 642, '2022-08-22 00:00:00', 69852, 3),
(1025, 874, '2022-08-05 00:00:00', 50001, 4),
(2089, 512, '2022-09-10 00:00:00', 69852, 2),
(3078, 369, '2022-09-18 00:00:00', 50001, 5),
(4056, 785, '2022-09-25 00:00:00', 69852, 4),
(5034, 641, '2022-10-12 00:00:00', 50001, 3),
(6023, 829, '2022-10-18 00:00:00', 69852, 5),
(7012, 957, '2022-10-25 00:00:00', 50001, 2),
(8001, 413, '2022-11-05 00:00:00', 69852, 4),
(8990, 268, '2022-11-15 00:00:00', 50001, 3),
(9967, 518, '2022-11-22 00:00:00', 69852, 3),
(1086, 753, '2022-12-10 00:00:00', 50001, 5),
(1175, 642, '2022-12-18 00:00:00', 69852, 4),
(1264, 874, '2022-12-25 00:00:00', 50001, 3),
(1353, 512, '2022-12-31 00:00:00', 69852, 2),
(1442, 369, '2023-01-05 00:00:00', 50001, 4),
(1531, 785, '2023-01-15 00:00:00', 69852, 5),
(1620, 641, '2023-01-22 00:00:00', 50001, 3),
(1709, 829, '2023-01-30 00:00:00', 69852, 4);



-- ---------------------------------------------
-- Amazon Interview Question for enty Business Analyst!
-- ---------------------------------------------
/*
Question:: Given the reviews table, write a query to retrieve 
the average star rating for each product, grouped by month. 
The output should display the month as a numerical value, 
product ID, and average star rating rounded to two decimal places. 
Sort the output first by month and then by product ID.
*/
select * from reviews
select product_id,
       DATEPART(MONTH,submit_date) as month,
round(AVG(stars),2) as star_rating from reviews
group by  submit_date, product_id
order by month, product_id 

-- Day 12/30 SQL Challenge

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    date_of_purchase Date,
    product_id INT,
    amount_spent DECIMAL(10, 2)
);

INSERT INTO purchases (purchase_id, user_id, date_of_purchase, product_id, amount_spent) VALUES
(2171, 145, '2024-02-22 00:00:00', 43001, 1000),
(3022, 578, '2024-02-24 00:00:00', 25852, 4000),
(4933, 145, '2024-02-28 00:00:00', 43001, 7000),
(6322, 248, '2024-02-19 00:00:00', 25852, 2000),
(4717, 578, '2024-02-12 00:00:00', 25852, 7000),
(2172, 145, '2024-01-15 00:00:00', 43001, 8000),
(3023, 578, '2024-01-18 00:00:00', 25852, 3000),
(4934, 145, '2024-01-28 00:00:00', 43001, 9000),
(6323, 248, '2024-02-20 00:00:00', 25852, 1500),
(4718, 578, '2024-02-25 00:00:00', 25852, 6000);

/*
SQL Question 1: Identify IBM's High Capacity Users
SQL Question: Identify users who have made purchases totaling more than $10,000 in the last month from the purchases table. 
The table contains information about purchases, including the user ID, date of purchase, product ID, and amount spent.
*/
select purchase_id,date_of_purchase,
       RANK() over(partition by purchase_id order by date_of_purchase) rn, 
sum(amount_spent) total_purchase_amount from purchases
group by purchase_id, date_of_purchase

-- 13/30 SQL Challenge
-- Q.1 SCHEMAS

CREATE TABLE fb_posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    comments INT,
    post_date DATE
);


INSERT INTO fb_posts (post_id, user_id, likes, comments, post_date) VALUES
(1, 101, 50, 20, '2024-02-27'),
(2, 102, 30, 15, '2024-02-28'),
(3, 103, 70, 25, '2024-02-29'),
(4, 101, 80, 30, '2024-03-01'),
(5, 102, 40, 10, '2024-03-02'),
(6, 103, 60, 20, '2024-03-03'),
(7, 101, 90, 35, '2024-03-04'),
(8, 101, 90, 35, '2024-03-05'),
(9, 102, 50, 15, '2024-03-06'),
(10, 103, 30, 10, '2024-03-07'),
(11, 101, 60, 25, '2024-03-08'),
(12, 102, 70, 30, '2024-03-09'),
(13, 103, 80, 35, '2024-03-10'),
(14, 101, 40, 20, '2024-03-11'),
(15, 102, 90, 40, '2024-03-12'),
(16, 103, 20, 5, '2024-03-13'),
(17, 101, 70, 25, '2024-03-14'),
(18, 102, 50, 15, '2024-03-15'),
(19, 103, 30, 10, '2024-03-16'),
(20, 101, 60, 20, '2024-03-17');

/*Q.1 Question: Identify the top 3 posts with the highest engagement 
(likes + comments) for each user on a Facebook page. Display 
the user ID, post ID, engagement count, and rank for each post.
*/
select * from fb_posts

with eng_count as 
(
select user_id,post_id,sum(likes+comments) engagement_count,
       ROW_NUMBER() over (partition by user_id order by sum(likes+comments) desc ) RN,
       RANK() over (partition by user_id order by sum(likes+comments) desc ) RNK 
from fb_posts
group by user_id,post_id
)

select 
      user_id,post_id,engagement_count,RNK
from eng_count
where RN <=3
order by user_id, engagement_count desc 





-- Schemas for Q.2

CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    post_date DATE
);

INSERT INTO posts (post_id, user_id, likes, post_date) VALUES
(1, 101, 50, '2024-02-27'),
(2, 102, 30, '2024-02-28'),
(3, 103, 70, '2024-02-29'),
(4, 101, 80, '2024-02-01'),
(5, 102, 40, '2024-02-02'),
(6, 103, 60, '2024-02-29'),
(7, 101, 90, '2024-01-29'),
(8, 101, 20, '2024-02-05'),
(9, 102, 50, '2024-01-29'),
(10, 103, 30, '2024-02-29'),
(11, 101, 60, '2024-01-08'),
(12, 102, 70, '2024-01-09'),
(13, 103, 80, '2024-01-10'),
(14, 101, 40, '2024-01-29'),
(15, 102, 90, '2024-01-29'),
(16, 103, 20, '2024-01-13'),
(17, 101, 70, '2024-01-14'),
(18, 102, 50, '2024-02-29'),
(19, 103, 30, '2024-02-16'),
(20, 101, 60, '2024-02-17');

/*  Q.2 Determine the users who have posted more than 2 times 
in the past week and calculate the total number of likes
they have received. Return user_id and number of post and no of likes   */

SELECT 
	user_id,
	SUM(likes) as total_likes,
	COUNT(post_id) as cnt_post
FROM posts
WHERE post_date >= GETDATE() - 7 AND 
		post_date < GETDATE()
GROUP BY user_id
HAVING COUNT(post_id) > 2


-- SQL Challenge 14/30 Days 

CREATE TABLE job_listings (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    title TEXT,
    description TEXT
);

alter table job_listings alter column title varchar(50) 
alter table job_listings alter column description varchar(100) 
INSERT INTO job_listings (job_id, company_id, title, description)
VALUES
    (248, 827, 'Business Analyst', 'Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.'),
    (149, 845, 'Business Analyst', 'Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.'),
    (945, 345, 'Data Analyst', 'Data analyst reviews data to identify key insights into a business''s customers and ways the data can be used to solve problems.'),
    (164, 345, 'Data Analyst', 'Data analyst reviews data to identify key insights into a business''s customers and ways the data can be used to solve problems.'),
    (172, 244, 'Data Engineer', 'Data engineer works in a variety of settings to build systems that collect, manage, and convert raw data into usable information for data scientists and business analysts to interpret.'),
    (573, 456, 'Software Engineer', 'Software engineer designs, develops, tests, and maintains software applications.'),
    (324, 789, 'Software Engineer', 'Software engineer designs, develops, tests, and maintains software applications.'),
    (890, 123, 'Data Scientist', 'Data scientist analyzes and interprets complex data to help organizations make informed decisions.'),
    (753, 123, 'Data Scientist', 'Data scientist analyzes and interprets complex data to help organizations make informed decisions.');


/*
-- Q.1 LinkedIn Data Analyst Interview question 
Assume you're given a table containing job postings from various companies on the LinkedIn platform. 
Write a query to retrieve the count of companies that have posted duplicate job listings.

Definition:Duplicate job listings are defined as two job listings 
within the same company that share identical titles and descriptions. */
select count(*) from job_listings j1,job_listings j2
where j1.company_id = j2.company_id
    and j1.title like j2.title
	and j1.description like j2.description
	
select * from job_listings

SELECT
	COUNT(1) as cnt_company
FROM 	
	(SELECT 
		company_id,
		title,
		description,
		COUNT(1) as total_job
	FROM job_listings
	GROUP BY company_id,
		title,
		description )x1
where total_job >1


-- SQL Challenge 15/30 Days 

CREATE TABLE Sale (
    SaleID INT IDENTITY(1,1)  PRIMARY KEY,
    Region VARCHAR(50),
    Amount DECIMAL(10, 2),
    SaleDate DATE
);

INSERT INTO Sale (Region, Amount, SaleDate) VALUES
('North', 5000.00, '2024-02-01'),
('South', 6000.00, '2024-02-02'),
('East', 4500.00, '2024-02-03'),
('West', 7000.00, '2024-02-04'),
('North', 5500.00, '2024-02-05'),
('South', 6500.00, '2024-02-06'),
('East', 4800.00, '2024-02-07'),
('West', 7200.00, '2024-02-08'),
('North', 5200.00, '2024-02-09'),
('South', 6200.00, '2024-02-10'),
('East', 4700.00, '2024-02-11'),
('West', 7100.00, '2024-02-12'),
('North', 5300.00, '2024-02-13'),
('South', 6300.00, '2024-02-14'),
('East', 4600.00, '2024-02-15'),
('West', 7300.00, '2024-02-16'),
('North', 5400.00, '2024-02-17'),
('South', 6400.00, '2024-02-18'),
('East', 4900.00, '2024-02-19'),
('West', 7400.00, '2024-02-20'),
('North', 5600.00, '2024-02-21'),
('South', 6600.00, '2024-02-22'),
('East', 5000.00, '2024-02-23'),
('West', 7500.00, '2024-02-24'),
('North', 5700.00, '2024-02-25'),
('South', 6700.00, '2024-02-26'),
('East', 5100.00, '2024-02-27'),
('West', 7600.00, '2024-02-28');



-- Flipkart Business Analyst entry level SQL question
/*  Identify the region with the lowest sales amount for the previous month. return region name and total_sale amount.   */
with cte as (
			select region,sum(Amount) as total_sale_amount
			from sale
			group by Region )
select top 1 region,min(total_sale_amount) as total_sale_amount from cte
group by Region

-- 16/30 Days SQL Challenge 

-- TikTok Interview Question for data analyst

-- Create TikTok table
CREATE TABLE tiktok (
					views INT
);

INSERT INTO tiktok (views) 
VALUES 
	(100), (800), (350), 
	(150), (600), 
	(700), (700), (950);

/*
Q1 Find the median within a series of numbers in SQL ;
1 8 3 4 5 odd 
1 3 4 5 8 9 even  */
select * from tiktok

WITH CTE
AS (
	SELECT 
		views,
		ROW_NUMBER() OVER( ORDER BY views ASC) rn_asc,
		ROW_NUMBER() OVER( ORDER BY views DESC) rn_desc
	FROM tiktok
	WHERE views < 900
)
SELECT 
	AVG(views) as median
FROM CTE 
WHERE ABS(rn_asc - rn_desc) <= 1    -- 0 or 1

-- 17/30 SQL Challenge

-- Zomato Business Analyst interview question 

CREATE TABLE order_details (
    order_id INT,
    del_partner VARCHAR(255),
    predicted_time datetime,
    delivery_time datetime
);


INSERT INTO order_details (order_id, del_partner, predicted_time, delivery_time) 
VALUES 
    (11, 'Partner C', '2024-02-29 11:30:00', '2024-02-29 12:00:00'),
    (12, 'Partner A', '2024-02-29 10:45:00', '2024-02-29 11:30:00'),
    (13, 'Partner B', '2024-02-29 09:00:00', '2024-02-29 09:45:00'),
    (14, 'Partner A', '2024-02-29 12:15:00', '2024-02-29 13:00:00'),
    (15, 'Partner C', '2024-02-29 13:30:00', '2024-02-29 14:15:00'),
    (16, 'Partner B', '2024-02-29 14:45:00', '2024-02-29 15:30:00'),
    (17, 'Partner A', '2024-02-29 16:00:00', '2024-02-29 16:45:00'),
    (18, 'Partner B', '2024-02-29 17:15:00', '2024-02-29 18:00:00'),
    (19, 'Partner C', '2024-02-29 18:30:00', '2024-02-29 19:15:00');


-- How many delayed orders does each delivery partner have, considering the predicted delivery time and the actual delivery time?
select count(order_id),del_partner from order_details
where delivery_time > predicted_time
group by del_partner

-- 18/30 SQL Challenge

-- SWIGGY BA Interview questions 


-- Create the Table
CREATE TABLE restaurant_orders (
    city VARCHAR(50),
    restaurant_id INT,
    order_id INT,
    order_date DATE
);


-- Insert Records
INSERT INTO restaurant_orders (city, restaurant_id, order_id, order_date)
VALUES
    ('Delhi', 101, 1, '2021-09-05'),
    ('Bangalore', 102, 12, '2021-09-08'),
    ('Bangalore', 102, 13, '2021-09-08'),
    ('Bangalore', 102, 14, '2021-09-08'),
    ('Mumbai', 103, 3, '2021-09-10'),
    ('Mumbai', 103, 30, '2021-09-10'),
    ('Chennai', 104, 4, '2021-09-15'),
    ('Delhi', 105, 5, '2021-09-20'),
    ('Bangalore', 106, 6, '2021-09-25'),
    ('Mumbai', 107, 7, '2021-09-28'),
    ('Chennai', 108, 8, '2021-09-30'),
    ('Delhi', 109, 9, '2021-10-05'),
    ('Bangalore', 110, 10, '2021-10-08'),
    ('Mumbai', 111, 11, '2021-10-10'),
    ('Chennai', 112, 12, '2021-10-15'),
    ('Kolkata', 113, 13, '2021-10-20'),
    ('Hyderabad', 114, 14, '2021-10-25'),
    ('Pune', 115, 15, '2021-10-28'),
    ('Jaipur', 116, 16, '2021-10-30');

/*Question:
Which metro city had the highest number of restaurant orders in September 2021?
Write the SQL query to retrieve the city name and the total count of orders, ordered by the total count of orders in descending order.
-- Note metro cites are 'Delhi', 'Mumbai', 'Bangalore', 'Hyderabad' */

with restraunt_orders as 
		(select city,count(order_id) as order_count 
		from restaurant_orders
		where MONTH(order_date) = '09'
		group by city)
select top 1 city, max(order_count) ord_count from restraunt_orders
    where city <> 'chennai'
	group by city
	order by ord_count desc

				-------OR---------------------

	SELECT top 1
		city,
		count(order_id) as total_orders
FROM restaurant_orders
WHERE city IN ('Delhi', 'Mumbai', 'Bangalore', 'Hyderabad')
AND order_date BETWEEN '2021-09-01' AND '2021-09-30'
GROUP BY city
ORDER BY total_orders DESC

-- --  Day 19/30 SQL Challenge

-- Google Interview Question for DA

CREATE TABLE student_names(
    student_id INT,
    name VARCHAR(50)
);

-- Insert the records
INSERT INTO student_names (student_id, name) VALUES
(1, 'RAM'),
(2, 'ROBERT'),
(3, 'ROHIM'),
(4, 'RAM'),
(5, 'ROBERT');


-- Question -- Get the count of distint student that are not unique 
select count(*) distint_student_cnt
	from (select name,count(name) dc from student_names
		  group by name
		  having count(name) = 1) as sq

-- Day 20/30 days sql challenge 
-- Schemas 


CREATE TABLE zomato_orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    price FLOAT,
    city VARCHAR(25)
);


-- Insert sample records into the zomato_orders table
INSERT INTO zomato_orders (order_id, customer_id, order_date, price, city) VALUES
(1, 101, '2023-11-01', 150.50, 'Mumbai'),
(2, 102, '2023-11-05', 200.75, 'Delhi'),
(3, 103, '2023-11-10', 180.25, 'Mumbai'),
(4, 104, '2023-11-15', 120.90, 'Delhi'),
(5, 105, '2023-11-20', 250.00, 'Mumbai'),
(6, 108, '2023-11-25', 180.75, 'Gurgoan'),
(7, 107, '2023-12-30', 300.25, 'Delhi'),
(8, 108, '2023-12-02', 220.50, 'Gurgoan'),
(9, 109, '2023-11-08', 170.00, 'Mumbai'),
(10, 110, '2023-10-12', 190.75, 'Delhi'),
(11, 108, '2023-10-18', 210.25, 'Gurgoan'),
(12, 112, '2023-11-24', 280.50, 'Mumbai'),
(13, 113, '2023-10-29', 150.00, 'Mumbai'),
(14, 103, '2023-11-03', 200.75, 'Mumbai'),
(15, 115, '2023-10-07', 230.90, 'Delhi'),
(16, 116, '2023-11-11', 260.00, 'Mumbai'),
(17, 117, '2023-11-16', 180.75, 'Mumbai'),
(18, 102, '2023-11-22', 320.25, 'Delhi'),
(19, 103, '2023-11-27', 170.50, 'Mumbai'),
(20, 102, '2023-11-05', 220.75, 'Delhi'),
(21, 103, '2023-11-09', 300.25, 'Mumbai'), 
(22, 101, '2023-11-15', 180.50, 'Mumbai'), 
(23, 104, '2023-11-18', 250.75, 'Delhi'), 
(24, 102, '2023-11-20', 280.25, 'Delhi'),
(25, 117, '2023-11-16', 180.75, 'Mumbai'),
(26, 117, '2023-11-16', 180.75, 'Mumbai'),
(27, 117, '2023-11-16', 180.75, 'Mumbai'),
(28, 117, '2023-11-16', 180.75, 'Mumbai');

/*
zomato business analyst interview question
Find city wise customers count who have placed  more than three orders in November 2023. */

select city, count(1) total_order_count
   from	(select city,
			   customer_id customers ,
			   count(1) total_orders
		from zomato_orders
		where MONTH(order_date) = '11'
		group by city,customer_id
		having count(1) >3 ) sq
		group by city


-- 21/30 days sql challenge 

-- SCHEMA

-- Create the hotel_revenue table
CREATE TABLE hotel_revenue (
    hotel_id INT,
    month VARCHAR(10),
    year INT,
    revenue DECIMAL(10, 2)
);


-- Insert sample records
INSERT INTO hotel_revenue (hotel_id, month, year, revenue) VALUES
(101, 'January', 2022, 15000.50),
(101, 'February', 2022, 18000.75),
(101, 'March', 2022, 20000.00),
(101, 'April', 2022, 20000.00),
(101, 'May', 2022, 20000.00),
(101, 'June', 2022, 20000.00),
(101, 'July', 2022, 26000.00),
(101, 'August', 2022, 28000.00),
(102, 'January', 2022, 12000.25),
(102, 'February', 2022, 14000.50),
(102, 'March', 2022, 16000.75),
(101, 'January', 2023, 17000.25),
(101, 'February', 2023, 19000.50),
(101, 'March', 2023, 21000.75),
(102, 'January', 2023, 13000.50),
(102, 'February', 2023, 15000.75),
(102, 'March', 2023, 17000.25),
(103, 'January', 2022, 11000.25),
(103, 'February', 2022, 13000.50),
(103, 'March', 2022, 15000.75),
(104, 'January', 2022, 14000.50),
(108, 'May', 2022, 31000.75),
(108, 'April', 2022, 28000.75),
(108, 'June', 2022, 16000.75),
(108, 'August', 2022, 16000.75),	
(104, 'March', 2022, 18000.25),
(103, 'January', 2023, 12000.50),
(103, 'February', 2023, 14000.75),
(103, 'March', 2023, 16000.25),
(104, 'January', 2023, 15000.75),
(107, 'February', 2023, 17000.25),
(106, 'March', 2023, 19000.50);


-- Booking.com Data Analyst interview question
/* Find the top-performing two months by revenue for each hotel for each year.
return hotel_id, year, month, revenue  */

with revenue_by_year as
	(select *,
	 RANK() over (partition by hotel_id,year order by revenue desc) as ranking 
	 from hotel_revenue)
select hotel_id,month,year,revenue from revenue_by_year
where ranking <=2 

-- 22/30 days sql challenge 


CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(255),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);


-- Inserting records into the employees table
INSERT INTO employees (emp_id, emp_name, manager_id) VALUES
(1, 'John Doe', NULL),           -- John Doe is the manager
(2, 'Jane Smith', 1),            -- Jane Smith reports to John Doe
(3, 'Alice Johnson', 1),         -- Alice Johnson reports to John Doe
(4, 'Bob Williams', 2),          -- Bob Williams reports to Jane Smith
(5, 'Charlie Brown', 2),         -- Charlie Brown reports to Jane Smith
(6, 'David Lee', 3),             -- David Lee reports to Alice Johnson
(7, 'Emily Davis', 3),           -- Emily Davis reports to Alice Johnson
(8, 'Fiona Clark', 4),           -- Fiona Clark reports to Bob Williams
(9, 'George Turner', 4),         -- George Turner reports to Bob Williams
(10, 'Hannah Baker', 5),         -- Hannah Baker reports to Charlie Brown
(11, 'Isaac White', 5),          -- Isaac White reports to Charlie Brown
(12, 'Jessica Adams', 6),        -- Jessica Adams reports to David Lee
(13, 'Kevin Harris', 6);         -- Kevin Harris reports to David Lee

/* TCS Data Analyst Interview question
Question
Write a SQL query to retrieve the emp_id, emp_name, and manager_name from the given employee table. 
It's important to note that managers are also employees in the table.
Employees table has 3 COLUMNS - emp_id, emp_name, maneger_id */

select e1.emp_id,e1.emp_name,
       e2.emp_name as manager_name 
from employees e1
       join employees e2 on e1.manager_id = e2.emp_id


	   -- 23/30 Days SQL Challenge

-- Dropping the table if it exists and then recreating it
DROP TABLE IF EXISTS employee;

-- Creating the employee table
CREATE TABLE employee (
    EMP_ID INT PRIMARY KEY,
    SALARY DECIMAL(10, 2)
);

-- Inserting sample data into the employee table
INSERT INTO employee (EMP_ID, SALARY) VALUES
(1, 50000),
(2, 60000),
(3, 70000),
(4, 45000),
(5, 80000),
(6, 55000),
(7, 75000),
(8, 62000),
(9, 48000),
(10, 85000);

/*Question 1
Given the employee table with columns EMP_ID and SALARY, 
write an SQL query to find all salaries greater than the average salary. return emp_id and salary */

select 
      EMP_ID,
	  SALARY 
from employee 
where SALARY > (select avg(SALARY) as avg_sal from employee)


-- 24/30 SQL Challenge

--  ----------------------------------------------------------------------------------
-- Questions 1
--  ----------------------------------------------------------------------------------	

-- SCHEMA 

-- Dropping the table if it exists and then recreating it
DROP TABLE IF EXISTS customers;
drop table if exists Transactions

-- Creating the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Inserting sample data into the customers table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(4, 'Bob', 'Brown', 'bob.brown@example.com'),
(5, 'Emily', 'Davis', 'john.doe@example.com'),
(6, 'Michael', 'Williams', 'michael.w@example.com'),
(7, 'David', 'Wilson', 'jane.smith@example.com'),
(8, 'Sarah', 'Taylor', 'sarah.t@example.com'),
(9, 'James', 'Anderson', 'james.a@example.com'),
(10, 'Laura', 'Martinez', 'laura.m@example.com');


/*Consider a table named customers with the following columns: customer_id, first_name, last_name, and email. 
Write an SQL query to find all the duplicate email addresses in the customers table. */

select 
      email 
from customers
group by email
having COUNT(email) > 1

-- 25/30

-- Drop the orders table if it exists
DROP TABLE IF EXISTS orders;

-- Create the orders table with columns: date, product_id, product_name, and revenue
CREATE TABLE orders (
    date DATE,
    product_id INT,
    product_name VARCHAR(255),
    revenue DECIMAL(10, 2)
);

-- Insert sample data into the orders table representing orders of iPhones
INSERT INTO orders (date, product_id, product_name, revenue) VALUES
('2024-01-01', 101, 'iPhone 13 Pro', 1000.00),
('2024-01-01', 102, 'iPhone 13 Pro Max', 1200.00),
('2024-01-02', 101, 'iPhone 13 Pro', 950.00),
('2024-01-02', 103, 'iPhone 12 Pro', 1100.00),
('2024-01-03', 102, 'iPhone 13 Pro Max', 1250.00),
('2024-01-03', 104, 'iPhone 11', 1400.00),
('2024-01-04', 101, 'iPhone 13 Pro', 800.00),
('2024-01-04', 102, 'iPhone 13 Pro Max', 1350.00),
('2024-01-05', 103, 'iPhone 12 Pro', 1000.00),
('2024-01-05', 104, 'iPhone 11', 700.00),
('2024-01-06', 101, 'iPhone 13 Pro', 600.00),
('2024-01-06', 102, 'iPhone 13 Pro Max', 550.00),
('2024-01-07', 101, 'iPhone 13 Pro', 400.00),
('2024-01-07', 103, 'iPhone 12 Pro', 250.00),
('2024-01-08', 102, 'iPhone 13 Pro Max', 200.00),
('2024-01-08', 104, 'iPhone 11', 150.00),
('2024-01-09', 101, 'iPhone 13 Pro', 100.00),
('2024-01-09', 102, 'iPhone 13 Pro Max', 50.00),
('2024-01-10', 101, 'iPhone 13 Pro', 1000.00),
('2024-01-10', 102, 'iPhone 13 Pro Max', 1200.00),
('2024-01-11', 101, 'iPhone 13 Pro', 950.00),
('2024-01-11', 103, 'iPhone 12 Pro', 1100.00),
('2024-01-12', 102, 'iPhone 13 Pro Max', 1250.00),
('2024-01-12', 104, 'iPhone 11', 1400.00);

/* Flipkart Business Analyst Interview Question
Question: 
Write a SQL query to calculate the running total revenue for each combination of date and product ID.

Expected Output Columns: 
	date, product_id, product_name, revenue, running_total
	ORDER BY product_id, date ascending */

select o1.*,sum(o2.revenue) as running_total_revenue 
from orders o1
join orders o2
on o1.product_id = o2.product_id
where o1.date >= o2.date
group by o1.date,
         o1.product_id,
		 o1.product_name,
		 o1.revenue
order by o1.product_id,
         o1.date asc

-- 26/30 Days SQL Challenge

-- SCHEMA

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_items_ordered INT
);

INSERT INTO orders VALUES
(1, 101, '2022-01-01', 5),
(2, 102, '2022-01-02', 10),
(3, 103, '2022-01-03', 8),
(4, 104, '2022-01-04', 12),
(5, 105, '2022-01-05', 15),
(6, 106, '2022-01-06', 20),
(7, 107, '2022-01-07', 25),
(8, 108, '2022-01-08', 30),
(9, 109, '2022-01-09', 35),
(10, 110, '2022-01-10', 40),
(11, 111, '2022-01-11', 45),
(12, 112, '2022-01-12', 50),
(13, 113, '2022-01-13', 55),
(14, 114, '2022-01-14', 60),
(15, 115, '2022-01-15', 65);


DROP TABLE IF EXISTS returns;

CREATE TABLE returns (
    return_id INT,
    order_id INT,
    return_date DATE,
    returned_items INT
);

INSERT INTO returns VALUES
(1, 1, '2022-01-03', 2),
(2, 2, '2022-01-05', 3),
(3, 3, '2022-01-07', 1),
(4, 5, '2022-01-08', 4),
(5, 6, '2022-01-08', 6),
(6, 7, '2022-01-09', 7),
(7, 8, '2022-01-10', 8),
(8, 9, '2022-01-11', 9),
(9, 10, '2022-01-12', 10),
(10, 11, '2022-01-13', 11),
(11, 12, '2022-01-14', 12),
(12, 13, '2022-01-15', 13),
(13, 14, '2022-01-16', 14),
(14, 15, '2022-01-17', 15);
/*
Question:Suppose you are given two tables - Orders and Returns. 
The Orders table contains information about orders placed by customers, and the Returns table contains information about returned items. 

Design a SQL query to find the top 5 customer with the highest percentage of returned items out of their total orders. 
	
Return the customer ID 
and the percentage of returned items rounded to two decimal places. */

select * from orders
select * from returns
 

 with cte_orders as 
		 (select customer_id,
				sum(total_items_ordered) as total_items_ordered
		 from orders
		 group by customer_id),
     
	 cte_returns as
	 (select o.customer_id,
	         sum(returned_items) as total_items_returned
	  from returns r
	  join orders o
	  on r.order_id = o.order_id
	  group by o.customer_id)

select top(5)
       oc.customer_id,
       oc.total_items_ordered,
	   rc.total_items_returned,
	   ROUND(CASE
		WHEN oc.total_items_ordered > 0 
		THEN (CAST(rc.total_items_returned as decimal)/CAST(oc.total_items_ordered as decimal))*100 
		ELSE 0 
	   END, 2) as returned_percentage
from cte_orders oc
join cte_returns rc
on oc.customer_id = rc.customer_id
order by returned_percentage desc

