
select * from order_details
select * from orders
select * from pizza_types
select * from pizzas

------    Basic:        ------

--1. Retrieve the total number of orders placed. 
select count(*) order_placed from orders

--2. Calculate the total revenue generated from pizza sales.
select round(sum(p.price*od.quantity),2) revenue
from pizzas p join order_details od
on p.pizza_id = od.pizza_id

--3. Identify the highest-priced pizza.
select top(1) pt.name,p.price
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc 

--  or  --
select pt.name,p.price
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
where p.price = (select max(price) price from pizzas)

--4. Identify the most common pizza size ordered.
select top(1) p.size,count(od.order_id) as order_counts
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
group by p.size
order by count(od.order_id) desc

--5. List the top 5 most ordered pizza types along with their quantities.
select top(5) pt.name, sum(od.quantity) as order_count  
from pizza_types pt join pizzas p
on p.pizza_type_id = pt.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.name
order by sum(od.quantity) desc

------            Intermediate:     --------

--1. Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category,sum(od.quantity) total_quantity
from pizza_types  pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
group by pt.category
order by sum(od.quantity) desc


--2. Determine the distribution of orders by hour of the day.
select count(order_id) order_count,
       DATEPART(HOUR,time) hour_of_day 
from orders
group by DATEPART(HOUR,time)
order by DATEPART(HOUR,time)

--3. Join relevant tables to find the category-wise distribution of pizzas.
select category,
       count(name) pizza_count
from pizza_types 
group by category

--4. Group the orders by date and calculate the average number of pizzas ordered per day.
select  avg(order_quantity) as avg_order_perday 
from (select o.date, sum(quantity) as order_quantity
		from orders o
		join order_details od
		on o.order_id = od.order_id
		group by o.date ) as order_eachday

		-----OR-----

with everyday_order as
(select o.date, sum(quantity) as order_quantity
		from orders o
		join order_details od
		on o.order_id = od.order_id
		group by o.date )
select avg(order_quantity) avg_order_per_day from everyday_order

--5. Determine the top 3 most ordered pizza types based on revenue.

select top(3) pt.name, 
       sum(p.price*od.quantity) revenue
from 
   pizzas p join order_details od
on p.pizza_id = od.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by sum(p.price*od.quantity) desc


 ---------           Advanced:       ---------

--1. Calculate the percentage contribution of each pizza type to total revenue.

select pt.category, 
        round(((sum(p.price*od.quantity))/(select (sum(p.price*od.quantity)) from pizzas p join order_details od
		                                            on p.pizza_id = od.pizza_id
                                                    join pizza_types pt on pt.pizza_type_id = p.pizza_type_id)*100),2 )revenue_contribution
from pizzas p join order_details od
on p.pizza_id = od.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.category

       -----OR-----

with total_rev as 
	(select sum(od.quantity*p.price) total_revenue
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id),
category_rev as
	(select pt.category, sum(od.quantity*p.price) as revenue
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
	join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
	group by pt.category)
select cr.category,
       round(((cr.revenue/tr.total_revenue)*100),2) revenue
from total_rev tr ,category_rev cr 
order by revenue desc


--2. Analyze the cumulative revenue generated over time.
with rev_by_date as
	(select o.date,
		   sum(p.price*od.quantity) revenue
	from order_details od 
	join orders o on od.order_id = o.order_id
	join pizzas p on p.pizza_id = od.pizza_id
	group by o.date)
select date,
       sum(revenue) over (order by date) cumulative_revenue 
from rev_by_date

--3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with rev_categorywise as
	(select pt.category,pt.name,
		   sum(od.quantity*p.price) revenue,
		   rank() over (partition by category order by sum(od.quantity*p.price) desc ) rnk 
	from pizza_types pt
	join pizzas p on pt.pizza_type_id = p.pizza_type_id
	join order_details od on p.pizza_id = od.pizza_id
	group by pt.category,pt.name)
select * from rev_categorywise where rnk<=3