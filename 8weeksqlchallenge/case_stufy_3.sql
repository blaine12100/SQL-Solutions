/*
On boarding journey

For customer 1, they started a trial on 2020-08-01 and transitioned to a basic plan on the 8th of the same month (1 week trial)

Customer 2 started a trial but on the same day (2020-09-20), transitioned to a pro annual fan.

Short summary is that most people go from a trial to a pro monthly / annual plan. There are lesser number of people who go from a basic to a higher plan or go from no plan to churn (Leave the service)
*/

--SELECT * FROM foodie_fi.subscriptions where customer_id in (1, 2, 11, 13, 15, 16, 18, 19)

-- Data analysis Questions

--How many customers has Foodie-Fi ever had?
--select count(distinct(customer_id)) from foodie_fi.subscriptions

--What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value (Per month per date distribution is I think what the question is asking so the group by should be on both of them)

/*
select EXTRACT(month from start_date) as month, EXTRACT(day from start_date) as day, count(*) from foodie_fi.subscriptions where plan_id = 0 group by month, day
*/

-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
/*
SELECT EXTRACT(year from start_date) as plan_year, plan_id, count(*) FROM foodie_fi.subscriptions where EXTRACT(year from start_date) > 2020 group by EXTRACT(year from start_date), 
*/

--What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

/*
Get unique customers who have churned (plan = null) divided by the number of unique customers in the subscription table

select round((sum(case when plan_id='4' then 1 else 0 end)::NUMERIC / count(distinct customer_id)) * 100, 2) as churn_percentage, sum(case when plan_id='4' then 1 else 0 end)::NUMERIC as churn_customers  from subscriptions
*/

-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

/*
Group by customers, havting count of plans = 2 and plans in 0 or 4 (Trial or churn)
*/

/*Use window function to get count of customers who only had 2 subscriptions. Then, amongst these customers we further need to filter out people who had the first subscriotion was trial and then the second as churn
*/

-- with multiplan as (select customer_id, plan_id, row_number() over(partition by customer_id order by plan_id) as ranking from subscriptions where plan_id in ('0', '4')),

-- Selecting only those with row number  = 2 as if they had row number equal tot 2, their first plan was the one with zero (order by plan id comes into play here)

--select count(customer_id), round((count(customer_id)::NUMERIC / 1000) * 100, 2) from multiplan where ranking = 2 

-- This solution is wrong as when we're filtering by plans, it is possible that there are plans in the middle for that given customer, using the below solution with
-- lag is correct

/*cte_churn AS 
(
-- use lag function to look at the previous row in the plan_id column resulting in previous_plan column
SELECT *, 
       LAG(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY plan_id) AS previous_plan
FROM subscriptions
)
SELECT COUNT(previous_plan) AS churn_count, 
	   ROUND(COUNT(*) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 0) AS percentage_churn
FROM cte_churn
WHERE plan_id = 4 and previous_plan = 0;
*/