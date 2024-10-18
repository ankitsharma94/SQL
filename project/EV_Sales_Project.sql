select * from dim_date
select * from EVsales_by_makers
select * from EVsales_by_state

----------------------------0Preliminary Research Questions:-----------------------------

--1. List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers sold.
with cte as 
		(select maker,fiscal_year,
			   sum(electric_vehicles_sold) total_sold,
			   RANK() over (partition by fiscal_year order by sum(electric_vehicles_sold) desc) top_ranking,
			   RANK() over (partition by fiscal_year order by sum(electric_vehicles_sold) ) low_ranking
		from 
		    dim_date dd
		    join EVsales_by_makers evm on dd.date = evm.date
		where 
		    dd.fiscal_year in ('2023','2024') 
		    and evm.vehicle_category = '2-Wheelers'
		group by 
		    maker,fiscal_year)

select maker,fiscal_year,
       total_sold,
	   'top 3' as category
from 
    cte 
where 
    top_ranking < 4

union all

select maker,fiscal_year,
       total_sold,
	   'bottom 3' as category
from 
    cte 
where 
    low_ranking < 4
order by 
    fiscal_year,
    category,
    total_sold desc

--2. Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheeler EV sales in FY 2024.
with ev_sales as 
		(select state,vehicle_category,
			   sum(electric_vehicles_sold) total_ev_sold,
			   sum(total_vehicles_sold) total_vehicle_sold
		from dim_date dd 
		join EVsales_by_state evs on dd.date=evs.date
		where fiscal_year = '2024'
		group by state, vehicle_category),

 penetrationrate as 
	    (select state,vehicle_category,
				 (total_ev_sold*1.0/total_vehicle_sold) penetration_rate
		 from ev_sales)

 select top(5) * from penetrationrate
 order by penetration_rate desc

--3. List the states with negative penetration (decline) in EV sales from 2022 to 2024?
with ev_sales as 
		(select fiscal_year,state,vehicle_category,
			   sum(electric_vehicles_sold) total_ev_sold,
			   sum(total_vehicles_sold) total_vehicle_sold
		from dim_date dd 
		join EVsales_by_state evs on dd.date=evs.date
		where fiscal_year in ('2022','2024')
		group by fiscal_year,state, vehicle_category),

 penetrationrate as 
	    (select fiscal_year,state,vehicle_category,
				 (total_ev_sold*1.0/total_vehicle_sold) penetration_rate,
				 rank() over (partition by fiscal_year order by (total_ev_sold*1.0/total_vehicle_sold) desc) rnk
		 from ev_sales)
select 
   pr2022.state
from 
   penetrationrate pr2022 
join penetrationrate pr2024 on pr2022.state = pr2024.state
where pr2022.fiscal_year = '2022'
   and pr2024.fiscal_year = '20244'
   and pr2022.penetration_rate > pr2024.penetration_rate



--4. What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) from 2022 to 2024?
with top_makr as 
		(select top(5) maker,
			   sum(electric_vehicles_sold) as evsold
		from dim_date dd
		join EVsales_by_makers evm on dd.date = evm.date
		where vehicle_category = '4-wheelers' and fiscal_year between 2022 and 2024
		group by maker
		order by sum(electric_vehicles_sold) desc),

     quarterly_trends as 
	    (select dd.fiscal_year year,dd.quarter,maker,
		        sum(electric_vehicles_sold) as total_ev_sold
		from dim_date dd 
		join EVsales_by_makers evm on dd.date = evm.date
		where vehicle_category = '4-wheelers' 
		  and fiscal_year between 2022 and 2024
		  and maker in (select maker from top_makr)
		group by dd.fiscal_year,dd.quarter,maker )
select * from quarterly_trends


--5. How do the EV sales and penetration rates in Delhi compare to Karnataka for 2024?
with penetration_rate as
			(select state,
				   sum(electric_vehicles_sold) total_ev_sold,
				   sum(total_vehicles_sold) total_vehicle_sold,
				   (sum(electric_vehicles_sold)*1.00/sum(total_vehicles_sold)) penetration_rate
			from dim_date dd
			join EVsales_by_state evs on dd.date = evs.date
			where fiscal_year = '2024'
			   and state in ('Delhi','Karnataka')
			group by fiscal_year,state)
select * from penetration_rate 

--6. List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024.
with sales_per_year as 
			(select fiscal_year,maker,
				   sum(electric_vehicles_sold) total_sales
			from dim_date dd 
			join EVsales_by_makers evm on dd.date = evm.date
			where vehicle_category = '4-wheelers'
			group by fiscal_year,maker ),
    topmaker as
			(select top(5) maker,
				   sum(total_sales) total_sales_over_period 
			from sales_per_year 
			where fiscal_year between 2022 and 2024
			group by maker
			order by total_sales_over_period desc)
 select s1.maker,
   ROUND(
    (POWER(CAST(s2.total_sales AS FLOAT) / CAST(s1.total_sales AS FLOAT), 1.0 / (2024 - 2022)) - 1) * 100, 
    2)AS cagr_perc from sales_per_year s1 
 join sales_per_year s2 on s1.maker = s2.maker
 join topmaker t on t.maker = s1.maker
 where s1.fiscal_year = '2022' 
 and s2.fiscal_year = '2024'
 order by cagr_perc desc 


--7. List down the top 10 states that had the highest compounded annual growth rate (CAGR) from 2022 to 2024 in total vehicles sold.
with sales_per_year as
		(select fiscal_year,state,
			   sum(total_vehicles_sold) total_vehicle_sold
		from EVsales_by_state evs 
		join dim_date dd on evs.date = dd.date
		where fiscal_year between '2022' and '2024'
		group by fiscal_year,state
		)
select top(10) s1.state,
       round((power(cast(s2.total_vehicle_sold as float) / cast(s1.total_vehicle_sold as float), 1.0 / (2024-2022))-1) * 100,
		   2) as CAGR_perc
from sales_per_year s1
join sales_per_year s2 on s1.state = s2.state
where s1.fiscal_year = '2022'
and s2.fiscal_year = '2024'
order by cagr_perc desc

--8. What are the peak and low season months for EV sales based on the data from 2022 to 2024?
with montly_sales as 
		(select fiscal_year as year,
			   datepart(MONTH,dd.date) as month,
			   sum(electric_vehicles_sold) ev_sold
		from EVsales_by_makers evm
		join dim_date dd on dd.date = evm.date
		group by  datepart(MONTH,dd.date),fiscal_year),
   aggregated_sale as
       (select month,
	           sum(ev_sold) total_sale_overperiod    
		from montly_sales
		group by month )
select month,
       case 
	        when total_sale_overperiod =(select max(total_sale_overperiod) from aggregated_sale) then 'Peak Season'
	        when total_sale_overperiod =(select min(total_sale_overperiod) from aggregated_sale) then 'Low Season'
			else 'Average Season'
       end as season_type
from aggregated_sale
order by total_sale_overperiod desc

--9. What is the projected number of EV sales (including 2-wheelers and 4-wheelers) for the top 10 states
--by penetration rate in 2030, based on the compounded annual growth rate (CAGR) from previous years?
-- Step 1: Calculate the Penetration Rate for Each State
WITH PenetrationRate AS (
    SELECT 
        state,
        SUM(electric_vehicles_sold) AS TotalEVsSold,
        SUM(total_vehicles_sold) AS TotalVehiclesSold,
        CAST(SUM(electric_vehicles_sold) AS FLOAT) / CAST(SUM(total_vehicles_sold) AS FLOAT) AS PenetrationRate
    FROM 
        evsales_by_state 
    GROUP BY 
        state
),

-- Step 2: Calculate the CAGR for Each State from 2022 to 2024
CAGRCalculation AS (
    SELECT
        state,
        SUM(CASE WHEN fiscal_year = 2022 THEN electric_vehicles_sold ELSE 0 END) AS EVSales2022,
        SUM(CASE WHEN fiscal_year = 2024 THEN electric_vehicles_sold ELSE 0 END) AS EVSales2024,
        POWER(CAST(SUM(CASE WHEN fiscal_year = 2024 THEN electric_vehicles_sold ELSE 0 END) AS FLOAT) / 
              CAST(SUM(CASE WHEN fiscal_year = 2022 THEN electric_vehicles_sold ELSE 0 END) AS FLOAT), 
              1.0 / (2024 - 2022)) - 1 AS CAGR
    FROM 
        evsales_by_state evs
    JOIN 
        dim_date dd ON evs.date = dd.date
    WHERE 
        dd.fiscal_year BETWEEN 2022 AND 2024
    GROUP BY 
        state
),

-- Step 3: Identify Top 10 States by Penetration Rate
Top10States AS (
    SELECT TOP 10 
        pr.state,
        pr.PenetrationRate,
        c.CAGR
    FROM 
        PenetrationRate pr
    JOIN 
        CAGRCalculation c ON pr.state = c.state
    ORDER BY 
        pr.PenetrationRate DESC
)

-- Step 4: Project EV Sales for 2030
SELECT 
    t.state,
    t.PenetrationRate,
    t.CAGR,
    -- Projected EV Sales for 2030
    ROUND(SUM(CASE WHEN dd.fiscal_year = 2024 THEN evs.electric_vehicles_sold ELSE 0 END) * 
          POWER(1 + t.CAGR, 2030 - 2024), 0) AS ProjectedEVSales2030
FROM 
    Top10States t
JOIN 
    evsales_by_state evs ON t.state = evs.state
JOIN 
    dim_date dd ON evs.date = dd.date
WHERE 
    dd.fiscal_year = 2024
GROUP BY 
    t.state, t.PenetrationRate, t.CAGR
ORDER BY 
    ProjectedEVSales2030 DESC;



--10. Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 2023 vs 2024, 
--assuming an average unit price. H
with sales_by_year as 
			(select fiscal_year,
				   vehicle_category,
				   sum(electric_vehicles_sold) total_ev_sold 
			from EVsales_by_makers evm
			join dim_date dd on dd.date = evm.date
			group by fiscal_year,vehicle_category),
     revenue as 
			 (select *,case when vehicle_category = '2-Wheelers' then (cast(total_ev_sold as bigint)*85000) 
					  when vehicle_category = '4-Wheelers' then (cast(total_ev_sold as bigint)*1500000)
				 end as revenue
			  from sales_by_year)
select r1.vehicle_category,
       '2022 vs 2024' as comparison,
       round(((r2.revenue-r1.revenue)*100.0 / r1.revenue),2) growth_rate
from revenue r1 
join revenue r2 on r1.vehicle_category = r2.vehicle_category
where r1.fiscal_year = '2022' and r2.fiscal_year = '2024'

union all 

select r1.vehicle_category,
       '2023 vs 2024' as comparison,
       round(((r2.revenue-r1.revenue)*100.0 / r1.revenue),2) growth_rate
from revenue r1 
join revenue r2 on r1.vehicle_category = r2.vehicle_category
where r1.fiscal_year = '2023' and r2.fiscal_year = '2024'



